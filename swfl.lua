-- Main Script With All The Magic :)
-- Ui Setup
local Finity = loadstring(game:HttpGet("https://raw.githubusercontent.com/acv39/Greenville-Leaker-Hacks/refs/heads/main/UiLib.lua"))()
local FinityWindow = Finity.new(true) -- true = dark mode, false light mode
FinityWindow.ChangeToggleKey(Enum.KeyCode.Semicolon)

-- Helper Function: Finds the player's car by checking the OwnerValue in each car's DriveSeat
function getCarByOwner(player)
    for _, car in ipairs(workspace.Cars:GetChildren()) do
        local driveSeat = car:FindFirstChild("DriveSeat")
        if driveSeat then
            local ownerValue = driveSeat:FindFirstChild("OwnerValue")
            if ownerValue and tostring(ownerValue.Value) == player.Name then
                return car  -- Return the matching car
            end
        end
    end
    return nil  -- Return nil if no matching car is found
end

local GeneralCheats = FinityWindow:Category("General")
local vflysec = GeneralCheats:Sector("Vehicle Flight")
local carmodsec = GeneralCheats:Sector("Car Mods")
local griefsec = GeneralCheats:Sector("Griefer Hacks")
local tpsec = GeneralCheats:Sector("Teleports")
local speedsec = GeneralCheats:Sector("Speed Hacks")

local speed = 200  -- Forward/backward vfly speed
local upSpeed = 150 -- Up/down vfly speed
local SpeedHacks = false
local speedhaxforce = 5000

-- Teleports

local function TeleportPlayer(x, y, z)
    local player = game.Players.LocalPlayer
    local vehicle = getCarByOwner(player)
    if vehicle and vehicle.PrimaryPart then
        local tppos = Vector3.new(x, y, z)
        vehicle:SetPrimaryPartCFrame(CFrame.new(tppos))
    else
        warn("No car found for " .. player.Name)
    end
end

tpsec:Cheat("Button", "Dealership", function()
    TeleportPlayer(-1728, -78.313, -11607.6)
end)
tpsec:Cheat("Button", "Dealership2", function()
    TeleportPlayer(-1364, -78.313, -11512.6)
end)
tpsec:Cheat("Button", "Burgerhaus", function()
    TeleportPlayer(-75, -76.313, -10540.6)
end)
tpsec:Cheat("Button", "Lakeville", function()
    TeleportPlayer(-426, -100, -6555.6)
end)
tpsec:Cheat("Button", "Six House", function()
    TeleportPlayer(-379, -90, -4128.6)
end)
tpsec:Cheat("Button", "Next Stop Gas", function()
    TeleportPlayer(381, -111, -2288.6)
end)
tpsec:Cheat("Button", "Apartments", function()
    TeleportPlayer(2172, -61, -3656)
end)
tpsec:Cheat("Button", "Airport", function()
    TeleportPlayer(5784.272, -78.313, -9934.6)
end)

-- Speed Hacks
speedsec:Cheat("Checkbox", "Toggle Speed Hacks", function(State)
    SpeedHacks = State
end)

speedsec:Cheat("Slider", "SpeedHacks Speed", function(Value)
    speedhaxforce = Value
end, {min = 1, max = 50000, suffix = "Studs"})

speedsec:Cheat("Button", "Inject Speed Hacks", function()
    local player = game.Players.LocalPlayer
    local userInputService = game:GetService("UserInputService")
    local runService = game:GetService("RunService")
    local vehicle = getCarByOwner(player)
    if vehicle and vehicle.PrimaryPart then
        local primaryPart = vehicle.PrimaryPart
        local attachment = primaryPart:FindFirstChild("ForceAttachment")
        if not attachment then
            attachment = Instance.new("Attachment")
            attachment.Name = "ForceAttachment"
            attachment.Parent = primaryPart
        end

        local force = Instance.new("VectorForce")
        force.Parent = vehicle
        force.RelativeTo = Enum.ActuatorRelativeTo.World
        force.Attachment0 = attachment
        force.ApplyAtCenterOfMass = true
        force.Force = Vector3.new(0, 0, 0)
        local isPressingW = false

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
                isPressingW = true
            elseif input.KeyCode == Enum.KeyCode.LeftShift then
                SpeedHacks = not SpeedHacks
                print("SpeedHacks: " .. tostring(SpeedHacks))
            end
        end
        local function onInputEnded(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.W then
                isPressingW = false
            end
        end
        userInputService.InputBegan:Connect(onInputBegan)
        userInputService.InputEnded:Connect(onInputEnded)
    end
end)

carmodsec:Cheat("Button", "Autofarm (Jump Out To Disable)", function()
    local player = game.Players.LocalPlayer
    local vehicle = getCarByOwner(player)
    if not (vehicle and vehicle.PrimaryPart) then
        warn("No car found for " .. player.Name)
        return
    end
    local startPosition = Vector3.new(-1801, -80, -10686.6)
    local endPosition = Vector3.new(-1130, -80, -10743)
    local autoSpeed = 112
    local isLooping = true
    vehicle:SetPrimaryPartCFrame(CFrame.new(startPosition) * CFrame.Angles(0, math.rad(90), 0))
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = vehicle.PrimaryPart
    local targetPos = endPosition
    while isLooping do
        while (vehicle.PrimaryPart.Position - targetPos).Magnitude > 1 and isLooping do
            local direction = (targetPos - vehicle.PrimaryPart.Position).unit
            bodyVelocity.Velocity = direction * autoSpeed
            wait(0.02)
            local finalPosition = Vector3.new(vehicle.PrimaryPart.Position.X, -80, vehicle.PrimaryPart.Position.Z)
            vehicle:SetPrimaryPartCFrame(CFrame.new(finalPosition) * CFrame.Angles(0, math.rad(90), 0))
        end
        if targetPos == startPosition then
            targetPos = endPosition
        else
            targetPos = startPosition
        end
    end
    bodyVelocity:Destroy()
end)

carmodsec:Cheat("Button", "Teleport To All Players", function()
    local player = game.Players.LocalPlayer
    local vehicle = getCarByOwner(player)
    if not vehicle then
        warn("No car found for " .. player.Name)
        return
    end
    local localPlayer = player
    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer ~= localPlayer and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = otherPlayer.Character.HumanoidRootPart
            local success, errorMessage = pcall(function()
                vehicle:SetPrimaryPartCFrame(CFrame.new(humanoidRootPart.Position))
            end)
            if not success then
                warn("Failed to teleport vehicle to " .. otherPlayer.Name .. ": " .. errorMessage)
            end
            wait(0.25)
        end 
    end
end)

carmodsec:Cheat("Button", "Increase Friction (More Grip)", function()
    local player = game.Players.LocalPlayer
    local PlayerCar = getCarByOwner(player)
    if not PlayerCar then
        warn("No car found for " .. player.Name)
        return
    end
    local Wheels = PlayerCar:FindFirstChild("Wheels")
    for _, wheel in ipairs(Wheels:GetChildren()) do
        local props = wheel.CustomPhysicalProperties
        wheel.CustomPhysicalProperties = PhysicalProperties.new(
            props.Density,
            2,
            props.Elasticity,
            100,
            props.ElasticityWeight
        )
    end	
end)

carmodsec:Cheat("Button", "Disable Weight", function()
    local player = game.Players.LocalPlayer
    local PlayerCar = getCarByOwner(player)
    if not PlayerCar then
        warn("No car found for " .. player.Name)
        return
    end
    local MainBody = PlayerCar:FindFirstChild("Body")
    local weight = MainBody:FindFirstChild("#Weight")
    local props = weight.CustomPhysicalProperties
    weight.CustomPhysicalProperties = PhysicalProperties.new(
        0,
        props.Friction,
        props.Elasticity,
        props.FrictionWeight,
        props.ElasticityWeight
    )
end)

carmodsec:Cheat("Button", "Goofy Wheels", function()
    local player = game.Players.LocalPlayer
    local PlayerCar = getCarByOwner(player)
    if not PlayerCar then
        warn("No car found for " .. player.Name)
        return
    end
    local Wheels = PlayerCar:FindFirstChild("Wheels")
    for _, wheel in ipairs(Wheels:GetChildren()) do
        local spring = wheel:FindFirstChild("Spring")
        spring.MinLength = 5
        spring.MaxLength = 15
    end	
end)

griefsec:Cheat("Label", "Cheats Below Only Work When Near Car You Want To Grief")
griefsec:Cheat("Button", "Goofy Wheels For All", function()
    for _, player in ipairs(game.Players:GetPlayers()) do
        local PlayerCar = getCarByOwner(player)
        if PlayerCar then
            local Wheels = PlayerCar:FindFirstChild("Wheels")
            if Wheels then
                for _, wheel in ipairs(Wheels:GetChildren()) do
                    local spring = wheel:FindFirstChild("Spring")
                    if spring then
                        spring.MinLength = 5
                        spring.MaxLength = 15
                    end
                end
            end
        end
    end
end)

griefsec:Cheat("Button", "Break Cars Seat", function()
    for _, player in ipairs(game.Players:GetPlayers()) do
        local PlayerCar = getCarByOwner(player)
        if PlayerCar and PlayerCar:FindFirstChild("DriveSeat") then
            PlayerCar.DriveSeat:Destroy()
        end
    end
end)

griefsec:Cheat("Button", "Break Cars", function()
    for _, player in ipairs(game.Players:GetPlayers()) do
        local PlayerCar = getCarByOwner(player)
        if PlayerCar then
            local Wheels = PlayerCar:FindFirstChild("Wheels")
            if Wheels then
                for _, wheel in ipairs(Wheels:GetChildren()) do
                    local spring = wheel:FindFirstChild("Spring")
                    if spring then
                        spring.MinLength = 15
                        spring.MaxLength = 30
                    end
                end
            end
        end
    end
end)

local teleportDistance = 100  -- Distance threshold for teleportation
local teleportHeight = 5
local tpfar = false

vflysec:Cheat("Checkbox", "Teleport To Car When Far", function(Value)
    tpfar = Value
end)
vflysec:Cheat("Slider", "Teleport Distance", function(Value)
    teleportDistance = Value
end, {min = 1, max = 150, suffix = "Studs"})

vflysec:Cheat("Slider", "Vfly Speed", function(Value)
    speed = math.ceil(Value)
    print("Updated Vfly Speed: " .. speed)
end, {min = 50, max = 1000, suffix = " Speed"})

vflysec:Cheat("Slider", "Vfly Up/Down Speed", function(Value)
    upSpeed = math.ceil(Value)
    print("Updated Vfly Up/Down Speed: " .. upSpeed)
end, {min = 5, max = 250, suffix = " Speed"})

vflysec:Cheat("Button", "Inject Vfly", function()
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local Camera = game:GetService("Workspace").CurrentCamera
    local player = Players.LocalPlayer
    local car = getCarByOwner(player)
    if not car or not car:FindFirstChild("DriveSeat") then
        warn("No car found for " .. player.Name)
        return
    end
    local vehicleSeat = car.DriveSeat
    local vehicle = vehicleSeat.Parent
    local rootPart = vehicle.PrimaryPart or vehicleSeat
    local VehicleFlyToggle = true
    local flying = false
    local bodyVelocity, bodyGyro

    local function startFlying()
        if not VehicleFlyToggle or flying then return end
        flying = true
        print("🚀 Vehicle Fly Activated 🚀")
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

    local function stopFlying()
        if not flying then return end
        flying = false
        print("🛑 Vehicle Fly Deactivated 🛑")
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        if bodyGyro then
            bodyGyro:Destroy()
            bodyGyro = nil
        end
    end

    local function updateMovement()
        if not VehicleFlyToggle then
            stopFlying()
            return
        end
        if not bodyVelocity then return end
        local velocity = Vector3.new(0, 0, 0)
        local forward = UserInputService:IsKeyDown(Enum.KeyCode.W)
        local backward = UserInputService:IsKeyDown(Enum.KeyCode.S)
        local left = UserInputService:IsKeyDown(Enum.KeyCode.A)
        local right = UserInputService:IsKeyDown(Enum.KeyCode.D)
        local up = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
        local down = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
        local cameraCFrame = Camera.CFrame
        local cameraLookVector = cameraCFrame.LookVector
        local cameraRightVector = cameraCFrame.RightVector
        local cameraUpVector = cameraCFrame.UpVector
        if forward then
            velocity = velocity + cameraLookVector * speed
        end
        if backward then
            velocity = velocity - cameraLookVector * speed
        end
        if left then
            velocity = velocity - cameraRightVector * speed
        end
        if right then
            velocity = velocity + cameraRightVector * speed
        end
        if up then
            velocity = velocity + cameraUpVector * upSpeed
        end
        if down then
            velocity = velocity - cameraUpVector * upSpeed
        end
        bodyVelocity.Velocity = velocity
    end

    local function teleportToVehicle()
        local playerPosition = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if playerPosition and vehicle.PrimaryPart then
            local distance = (playerPosition.Position - vehicle.PrimaryPart.Position).Magnitude
            if distance > teleportDistance then
                local vehicleTopPosition = vehicle.PrimaryPart.Position + Vector3.new(0, teleportHeight, 0)
                playerPosition.CFrame = CFrame.new(vehicleTopPosition)
                print("🚗 Player teleported to the top of the car 🚗")
            end
        end
    end

    RunService.RenderStepped:Connect(function()
        if flying then
            updateMovement()
        end
        if tpfar then
            teleportToVehicle()
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.F then
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

debugsec:Cheat("Button", "Print Player Pos", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    warn("Player's position: " .. tostring(humanoidRootPart.Position))
end)

debugsec:Cheat("Button", "Add ESP Ui", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/acv39/Greenville-Leaker-Hacks/refs/heads/main/ESP.lua", true))()
end)

debugsec:Cheat("Button", "Add Dex UI", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
end)
