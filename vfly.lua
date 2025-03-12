local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = game:GetService("Workspace").CurrentCamera

local player = Players.LocalPlayer
local vehicleSeat = Workspace.SessionVehicles["Punis962-Car"].DriveSeat
local vehicle = vehicleSeat.Parent
local rootPart = vehicle.PrimaryPart or vehicleSeat

local VehicleFlyToggle = false  -- Toggle for enabling/disabling flying
local flying = false
local speed = 200  -- Forward/backward speed
local upSpeed = 150  -- Upward speed

local bodyVelocity = nil
local bodyGyro = nil

-- Function to start flying
local function startFlying()
    if not VehicleFlyToggle or flying then return end
    flying = true
    print("🚀 Vehicle Fly Activated 🚀")

    -- Create BodyVelocity and BodyGyro
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.Parent = rootPart

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.P = 10000
    bodyGyro.D = 5000
    bodyGyro.Parent = rootPart
end

-- Function to stop flying
local function stopFlying()
    if not flying then return end
    flying = false
    print("🛑 Vehicle Fly Deactivated 🛑")

    -- Remove BodyVelocity and BodyGyro so normal physics resume
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
end

-- Update movement based on WASD input
local function updateMovement()
    if not VehicleFlyToggle then
        stopFlying() -- Ensure flying stops if toggle is false
        return
    end

    if not bodyVelocity then return end  -- Prevent errors if BodyVelocity is removed

    local velocity = Vector3.new(0, 0, 0)

    -- WASD input detection
    local forward = UserInputService:IsKeyDown(Enum.KeyCode.W)
    local backward = UserInputService:IsKeyDown(Enum.KeyCode.S)
    local left = UserInputService:IsKeyDown(Enum.KeyCode.A)
    local right = UserInputService:IsKeyDown(Enum.KeyCode.D)
    local up = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)  -- Shift = Up
    local down = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)  -- Ctrl = Down

    -- Get the camera's CFrame to determine the movement direction
    local cameraCFrame = Camera.CFrame
    local cameraLookVector = cameraCFrame.LookVector
    local cameraRightVector = cameraCFrame.RightVector
    local cameraUpVector = cameraCFrame.UpVector

    -- Forward/Backward Movement (relative to the camera)
    if forward then
        velocity = velocity + cameraLookVector * speed
    end
    if backward then
        velocity = velocity - cameraLookVector * speed
    end

    -- Left/Right Movement (relative to the camera)
    if left then
        velocity = velocity - cameraRightVector * speed
    end
    if right then
        velocity = velocity + cameraRightVector * speed
    end

    -- Up/Down Movement
    if up then
        velocity = velocity + cameraUpVector * upSpeed
    end
    if down then
        velocity = velocity - cameraUpVector * upSpeed
    end

    -- Apply the velocity to the vehicle
    bodyVelocity.Velocity = velocity
end

-- Start listening to RenderStepped for movement updates
RunService.RenderStepped:Connect(function()
    if flying then
        updateMovement()
    end
end)

-- Toggle Fly Mode (Example usage)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then  -- Press 'F' to toggle flight mode
        VehicleFlyToggle = not VehicleFlyToggle
        if VehicleFlyToggle then
            startFlying()
        else
            stopFlying()
        end
    end
end)
