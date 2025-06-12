-- 🌱 Grow a Garden Script | Created by 100days0o

-- Load UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🌱 Grow a Garden | by 100days0o", "BloodTheme") -- GUI Theme: Black & Red

-- Tabs & Sections
local FarmTab = Window:NewTab("Auto Farm")
local FarmSection = FarmTab:NewSection("Automation")

local TpTab = Window:NewTab("Teleport")
local TpSection = TpTab:NewSection("Teleport Locations")

local UtilityTab = Window:NewTab("Utilities")
local UtilitySection = UtilityTab:NewSection("System Tools")

local InfoTab = Window:NewTab("Player Info")
local InfoSection = InfoTab:NewSection("Details")
InfoSection:NewLabel("🧠 Script by: 100days0o")

-- Settings
local SETTINGS = {
    autoWater = false,
    autoHarvest = false,
    autoReplant = false,
    autoBuySeed = false,
    autoBuyGear = false,
    seedType = "Tomato",
    seedPrice = 1000,
    gearName = "Sprinkler",
    gearPrice = 5000,
    buyThreshold = 5000,
    loopDelay = 1,
}

-- Services & Player Info
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local Stats = player:WaitForChild("leaderstats")
local Backpack = player:WaitForChild("Backpack")
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Remote Events
local RE = ReplicatedStorage:WaitForChild("RemoteEvents")
local remotes = {
    water = RE:WaitForChild("WaterPlant"),
    harvest = RE:WaitForChild("HarvestPlant"),
    plant = RE:WaitForChild("PlantSeed"),
    buySeed = RE:WaitForChild("PurchaseSeed"),
    buyGear = RE:WaitForChild("PurchaseGear"),
}

-- Anti-AFK
player.Idled:Connect(function()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Auto Farming Logic
task.spawn(function()
    while true do
        pcall(function()
            for _, plant in pairs(workspace.Plants:GetChildren()) do
                if SETTINGS.autoHarvest and plant:FindFirstChild("FullyGrown") then
                    remotes.harvest:FireServer(plant)
                end
                if SETTINGS.autoWater and plant:FindFirstChild("NeedsWater") then
                    remotes.water:FireServer(plant)
                end
                if SETTINGS.autoReplant and plant:FindFirstChild("Picked") then
                    remotes.plant:FireServer(plant.Position, SETTINGS.seedType)
                end
            end

            if SETTINGS.autoBuySeed then
                local cash = Stats.Cash and Stats.Cash.Value or 0
                if cash > SETTINGS.buyThreshold then
                    local count = math.floor(cash / SETTINGS.seedPrice)
                    remotes.buySeed:FireServer(SETTINGS.seedType, count)
                end
            end

            if SETTINGS.autoBuyGear then
                local cash = Stats.Cash and Stats.Cash.Value or 0
                if cash > SETTINGS.gearPrice then
                    remotes.buyGear:FireServer(SETTINGS.gearName)
                end
            end
        end)
        wait(SETTINGS.loopDelay)
    end
end)

-- Auto Farm Toggles
FarmSection:NewToggle("Auto Water", "", function(v) SETTINGS.autoWater = v end)
FarmSection:NewToggle("Auto Harvest", "", function(v) SETTINGS.autoHarvest = v end)
FarmSection:NewToggle("Auto Replant", "", function(v) SETTINGS.autoReplant = v end)
FarmSection:NewToggle("Auto Buy Seed", "", function(v) SETTINGS.autoBuySeed = v end)
FarmSection:NewToggle("Auto Buy Gear", "", function(v) SETTINGS.autoBuyGear = v end)

-- Disable All Button
FarmSection:NewButton("❌ Disable All Auto", "Turns off all automation features", function()
    for k, v in pairs(SETTINGS) do
        if type(v) == "boolean" then SETTINGS[k] = false end
    end
end)

-- Teleport Buttons
local locations = {
    ["Your Garden"] = Vector3.new(50, 5, 120),
    ["Seed Shop"] = Vector3.new(-120, 5, 80),
    ["Gear Shop"] = Vector3.new(-60, 5, -40),
}
for name, pos in pairs(locations) do
    TpSection:NewButton(name, "Teleport to " .. name, function()
        hrp.CFrame = CFrame.new(pos)
    end)
end

-- Lag Reducer Button
UtilitySection:NewButton("🧹 Reduce Lag", "Removes particles & effects to boost FPS", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") then
            v:Destroy()
        elseif v:IsA("Decal") then
            v.Transparency = 1
        elseif v:IsA("Texture") then
            v:Destroy()
        end
    end
    local Lighting = game:GetService("Lighting")
    Lighting.FogEnd = 1000000
    Lighting.GlobalShadows = false
    sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility)
end)

-- Show Player Info
InfoSection:NewLabel("👤 Name: " .. player.Name)
task.spawn(function()
    while wait(2) do
        pcall(function()
            InfoSection:NewLabel("💰 Cash: " .. tostring(Stats.Cash.Value))
        end)
    end
end)

-- Show Seeds (if available)
task.spawn(function()
    while wait(3) do
        for _, item in pairs(Backpack:GetChildren()) do
            if item:IsA("Tool") and string.find(item.Name, SETTINGS.seedType) then
                InfoSection:NewLabel("🌱 You have: " .. item.Name)
            end
        end
    end
end)
