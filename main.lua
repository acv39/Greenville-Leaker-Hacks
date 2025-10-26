--Main Script With All The Magic :)
--Ui Setup
local Finity = loadstring(game:HttpGet("https://raw.githubusercontent.com/acv39/Greenville-Leaker-Hacks/refs/heads/main/UiLib.lua"))()
local FinityWindow = Finity.new(true) -- true = dark mode, false light mode
FinityWindow.ChangeToggleKey(Enum.KeyCode.Semicolon)

local GeneralCheats = FinityWindow:Category("General")
local vflysec = GeneralCheats:Sector("Vehicle Flight")
local carmodsec = GeneralCheats:Sector("Car Mods")
local griefsec = GeneralCheats:Sector("Griefer Hacks")
local tpsec = GeneralCheats:Sector("Teleports")
local speedsec = GeneralCheats:Sector("Speed Hacks")

local speed = 200  -- Forward/backward vfly speed
local upSpeed = 150 -- up/down vfly speed
--car sped hacks
local SpeedHacks = false
local speedhaxforce = 5000
-- Teleports

local function TeleportPlayer(x,y,z)
    local player = game.Players.LocalPlayer
	local vehicle = workspace.SessionVehicles:FindFirstChild(player.Name .. "-Car")
	if vehicle then
		vehicle:SetPrimaryPartCFrame(CFrame.new(x,y,z))
	else
		local tppos = Vector3.new(x,y,z)
		player.Character.PrimaryPart.CFrame = CFrame.new(tppos)
	end
end


tpsec:Cheat("Button","Dealership",function()
	TeleportPlayer(-1728, -78.313, -11607.6)
end)
tpsec:Cheat("Button","Dealership2",function()
	TeleportPlayer(-1364, -78.313, -11512.6)
end)
tpsec:Cheat("Button","Burgerhaus",function()
	TeleportPlayer(-75, -76.313, -10540.6)
end)
tpsec:Cheat("Button","Lakeville",function()
	TeleportPlayer(-426, -100, -6555.6)
end)
tpsec:Cheat("Button","Six House",function()
	TeleportPlayer(-379, -90, -4128.6)
end)
tpsec:Cheat("Button","Next Stop Gas",function()
	TeleportPlayer(381, -111, -2288.6)
end)
tpsec:Cheat("Button","Apartments",function()
	TeleportPlayer(2172, -61, -3656)
end)
tpsec:Cheat("Button","Airport",function()
	TeleportPlayer(5784.272, -78.313, -9934.6)
end)
tpsec:Cheat("Button","Airport",function()
	TeleportPlayer(255,-114,-2425)
end)

-- everything else
speedsec:Cheat("Checkbox","Toggle Speed Hacks",function(State)
	SpeedHacks = State
end)

speedsec:Cheat("Slider","SpeedHacks Speed",function(Value)
    speedhaxforce = Value
end,{min = 1, max = 50000, suffix = "Studs"})

speedsec:Cheat("Button","Inject Speed Hacks)",function()
    local player = game.Players.LocalPlayer
    local userInputService = game:GetService("UserInputService")
    local runService = game:GetService("RunService")
    local vehicle = workspace.SessionVehicles:FindFirstChild(player.Name .. "-Car")
    if vehicle and vehicle.PrimaryPart then
        local primaryPart = vehicle.PrimaryPart
        local attachment = primaryPart:FindFirstChild("ForceAttachment")
        if not attachment then
            attachment = Instance.new("Attachment")
            attachment.Name = "ForceAttachment"
            attachment.Parent = primaryPart
        end

        -- Create the VectorForce
        local force = Instance.new("VectorForce")
        force.Parent = vehicle
        force.RelativeTo = Enum.ActuatorRelativeTo.World
        force.Attachment0 = attachment
        force.ApplyAtCenterOfMass = true -- Apply force at center of mass
        force.Force = Vector3.new(0, 0, 0) -- Initially no force
        local isPressingW = false -- Track if "W" is held

        -- Run loop to apply force only when "W" is held and SpeedHacks is enabled
        runService.RenderStepped:Connect(function()
            if vehicle and vehicle.PrimaryPart then
                if isPressingW and SpeedHacks then
                    force.Force = vehicle.PrimaryPart.CFrame.LookVector * speedhaxforce
                else
                    force.Force = Vector3.new(0, 0, 0)
                end
            end
        end)
        local function onInputBegan(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.W then
                isPressingW = true -- Set flag when "W" is pressed
            elseif input.KeyCode == Enum.KeyCode.LeftShift then
                -- Toggle SpeedHacks when LeftShift is pressed
                SpeedHacks = not SpeedHacks
                print("SpeedHacks: " .. tostring(SpeedHacks))
            end
        end
        local function onInputEnded(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.W then
                isPressingW = false -- Unset flag when "W" is released
            end
        end
        userInputService.InputBegan:Connect(onInputBegan)
        userInputService.InputEnded:Connect(onInputEnded)
    end
end)

carmodsec:Cheat("Button","Autofarm (Jump Out To Disable)",function()
	local player = game.Players.LocalPlayer
	local vehicle = workspace.SessionVehicles:FindFirstChild(player.Name .. "-Car")
	local startPosition = Vector3.new(-1801, -80, -10686.6)
	local endPosition = Vector3.new(-1130, -80, -10743)
	local speed = 112
	local isLooping = true  -- Flag to control the loop
	-- Set initial position with 90-degree rotation
	vehicle:SetPrimaryPartCFrame(CFrame.new(startPosition) * CFrame.Angles(0, math.rad(90), 0))
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000) 
	bodyVelocity.Velocity = Vector3.new(0, 0, 0) 
	bodyVelocity.Parent = vehicle.PrimaryPart
	local targetPos = endPosition
	while isLooping do
		-- Move towards the target position
		while (vehicle.PrimaryPart.Position - targetPos).Magnitude > 1 and isLooping do
			-- Calculate the direction and move the vehicle
			local direction = (targetPos - vehicle.PrimaryPart.Position).unit
			bodyVelocity.Velocity = direction * speed  -- Apply velocity to move the vehicle
			wait(0.02)  -- Small wait to allow the physics engine to process the velocity
			
			-- Update the vehicle's position and keep it rotated 90 degrees
			local finalPosition = Vector3.new(vehicle.PrimaryPart.Position.X, -80, vehicle.PrimaryPart.Position.Z)
			vehicle:SetPrimaryPartCFrame(CFrame.new(finalPosition) * CFrame.Angles(0, math.rad(90), 0))
		end
		
		-- Swap the target position after reaching it
		if targetPos == startPosition then
			targetPos = endPosition
		else
			targetPos = startPosition
		end
	end
	bodyVelocity:Destroy()
end)
carmodsec:Cheat("Button","Teleport To All Players",function()
	local player = game.Players.LocalPlayer
	local vehicle = workspace.SessionVehicles:FindFirstChild(player.Name .. "-Car")
	local localPlayer = game.Players.LocalPlayer
	for _, player in ipairs(game.Players:GetPlayers()) do
		if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local humanoidRootPart = player.Character.HumanoidRootPart
			local success, errorMessage = pcall(function()
				vehicle:SetPrimaryPartCFrame(CFrame.new(humanoidRootPart.Position))
			end)
			if not success then
				warn("Failed to teleport vehicle to " .. player.Name .. ": " .. errorMessage)
			end
			wait(0.25)
		end 
	end
end)
carmodsec:Cheat("Button","Increase Friction (More Grip)",function()
	local player = game.Players.LocalPlayer
	local PlayerCar = workspace.SessionVehicles:FindFirstChild(player.Name .. "-Car")
	local MainBody = PlayerCar:FindFirstChild("Body")
	local Wheels = PlayerCar:FindFirstChild("Wheels")
	for _, wheel in ipairs(Wheels:GetChildren()) do
		print(wheel.Name)
		local props = wheel.CustomPhysicalProperties  -- Get current properties
		-- Create a new PhysicalProperties object with modified friction
		wheel.CustomPhysicalProperties = PhysicalProperties.new(
		props.Density,         -- Keep the same density
		2,  -- Increase friction by 0.1
		props.Elasticity,      -- Keep the same elasticity
		100,  -- Keep the same friction weight
		props.ElasticityWeight -- Keep the same elasticity weight
		)
	end	
end)
carmodsec:Cheat("Button","Disable Weight",function()
	local player = game.Players.LocalPlayer
	local PlayerCar = workspace.SessionVehicles:FindFirstChild(player.Name .. "-Car")
	local MainBody = PlayerCar:FindFirstChild("Body")
	local weight = MainBody:FindFirstChild("#Weight")
	local props = weight.CustomPhysicalProperties  -- Get current properties
	-- Create a new PhysicalProperties object with modified values
	weight.CustomPhysicalProperties = PhysicalProperties.new(
		0,           -- Keep the same density
		props.Friction,    -- Increase friction by 0.1
		props.Elasticity,        -- Keep the same elasticity
		props.FrictionWeight,    -- Keep the same friction weight
		props.ElasticityWeight   -- Keep the same elasticity weight
	)
end)
carmodsec:Cheat("Button","Goofy Wheels",function()
	local player = game.Players.LocalPlayer
	local PlayerCar = workspace.SessionVehicles:FindFirstChild(player.Name .. "-Car")
	local MainBody = PlayerCar:FindFirstChild("Body")
	local Wheels = PlayerCar:FindFirstChild("Wheels")
	for _, wheel in ipairs(Wheels:GetChildren()) do
		print(wheel.Name)
		local spring = wheel:FindFirstChild("Spring")
		spring.MinLength = 5
		spring.MaxLength = 15
	end	
end)
griefsec:Cheat("Label","Cheats Below Only Work When Near Car You Want To Grief")
griefsec:Cheat("Button","Goofy Wheels For All",function()
	for _, player in ipairs(game.Players:GetPlayers()) do
        print(player.Name)
        local PlayerCar = workspace.SessionVehicles:FindFirstChild(player.Name .. "-Car")
        if PlayerCar then
            local Wheels = PlayerCar:FindFirstChild("Wheels")
            if Wheels then
                for _, wheel in ipairs(Wheels:GetChildren()) do
                    local spring = wheel:FindFirstChild("Spring")
                    if spring then
                        spring.MinLength = 5
                        spring.MaxLength = 15
                        print(wheel.Name)
                    end
                end
            end
        end
    end
end)
griefsec:Cheat("Button","Break Cars Seat",function()
	for _, player in ipairs(game.Players:GetPlayers()) do
        print(player.Name)
        local PlayerCar = workspace.SessionVehicles:FindFirstChild(player.Name .. "-Car")
        PlayerCar.DriveSeat:Destroy()
        end
end)
griefsec:Cheat("Button","Break Cars",function()
	for _, player in ipairs(game.Players:GetPlayers()) do
        print(player.Name)
        local PlayerCar = workspace.SessionVehicles:FindFirstChild(player.Name .. "-Car")
        if PlayerCar then
            local Wheels = PlayerCar:FindFirstChild("Wheels")
            if Wheels then
                for _, wheel in ipairs(Wheels:GetChildren()) do
                    local spring = wheel:FindFirstChild("Spring")
                    if spring then
                        spring.MinLength = 15
                        spring.MaxLength = 30
                        print(wheel.Name)
                    end
                end
            end
        end
    end
end)
griefsec:Cheat("Button", "Glitch Collisions (Drive thru ppl)", function()
    local localPlayer = game.Players.LocalPlayer
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer then
            print("Disabling collisions for:", player.Name)
            local sessionVehicles = workspace:FindFirstChild("SessionVehicles")
            if not sessionVehicles then
                warn("SessionVehicles folder not found!")
                continue
            end
            local playerCar = sessionVehicles:FindFirstChild(player.Name .. "-Car")
            if playerCar then
                local body = playerCar:FindFirstChild("Body")
                if body then
                    -- remove "Color" parts directly under body
                    for _, part in ipairs(body:GetChildren()) do
                        if part.Name == "Color" then
                            part:Destroy()
                        end
                    end
                    -- check nested "realbody" inside body
                    local realbody = body:FindFirstChild("Body")
                    if realbody then
                        for _, part in ipairs(realbody:GetChildren()) do
                            if part.Name == "Color" then
                                part:Destroy()
                            end
                        end
                    end
                end
            end
        end
    end
end)

local teleportDistance = 100  -- Distance threshold for teleportation
local teleportHeight = 5
local tpfar = false

vflysec:Cheat("Checkbox","Teleport To Car When Far",function(Value)
    tpfar = Value
end)
vflysec:Cheat("Slider","Teleport Distance",function(Value)
    teleportDistance = Value
end,{min = 1, max = 150, suffix = "Studs"})
-- Slider 1 creation: Range from 50 to 1000
vflysec:Cheat("Slider", "Vfly Speed", function(Value)
	speed = math.ceil(Value)  -- Round and set the speed to the updated value
	print("Updated Vfly Speed: " .. speed)
end, {min = 50, max = 1000, suffix = " Speed"})
-- Slider 2 creation: Range from 5 to 250
vflysec:Cheat("Slider", "Vfly Up/Down Speed", function(Value)
	upSpeed = math.ceil(Value)  -- Round and set the upSpeed to the updated value
	print("Updated Vfly Up/Down Speed: " .. upSpeed)
end, {min = 5, max = 250, suffix = " Speed"})
vflysec:Cheat("Button", "Inject Vfly", function() -- inject vfly
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local Camera = game:GetService("Workspace").CurrentCamera
    local player = Players.LocalPlayer
    local vehicleSeat = Workspace.SessionVehicles[player.Name .."-Car"].DriveSeat
    local vehicle = vehicleSeat.Parent
    local rootPart = vehicle.PrimaryPart or vehicleSeat
    local VehicleFlyToggle = true  -- Toggle for enabling/disabling flying
    local flying = false
    -- Upward speed
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
            velocity = velocity + cameraUpVector * upspeed
        end
        if down then
            velocity = velocity - cameraUpVector * upspeed
        end
        -- Apply the velocity to the vehicle
        bodyVelocity.Velocity = velocity
    end

    -- Function to teleport the player on top of the vehicle if too far
    local function teleportToVehicle()
        local playerPosition = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if playerPosition and vehicle.PrimaryPart then
            local distance = (playerPosition.Position - vehicle.PrimaryPart.Position).Magnitude
            if distance > teleportDistance then
                -- Teleport player to a position just above the car
                local vehicleTopPosition = vehicle.PrimaryPart.Position + Vector3.new(0, teleportHeight, 0)
                playerPosition.CFrame = CFrame.new(vehicleTopPosition)
                print("🚗 Player teleported to the top of the car 🚗")
            end
        end
    end

    -- Start listening to RenderStepped for movement updates and teleportation check
    RunService.RenderStepped:Connect(function()
        if flying then
            updateMovement()
        end
        if tpfar then
            teleportToVehicle()  -- Check if teleportation is needed
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

end)

local DebugCat = FinityWindow:Category("Debug")
local debugsec = DebugCat:Sector("Debug Stuff")

debugsec:Cheat("Button","Print Player Pos",function()
	local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    warn("Player's position: " .. tostring(humanoidRootPart.Position))
end)

debugsec:Cheat("Button","Add ESP Ui",function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/acv39/Greenville-Leaker-Hacks/refs/heads/main/ESP.lua",true))()
end)

debugsec:Cheat("Button","Add Dex UI",function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
end)
