
-- 🍀 Grow a Garden Hub – Main Script (English Version) -- Script by: 100days0o

-- Wait until game assets are loaded local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))() repeat wait() until workspace:FindFirstChild("Plants") and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents")

local Players = game:GetService("Players") local P = Players.LocalPlayer local UIS = game:GetService("UserInputService") local RS = game:GetService("ReplicatedStorage") local VU = game:GetService("VirtualUser")

-- UI Setup local Window = Library.CreateLib("🌱 Grow a Garden | 100days0o", "BloodTheme") local FarmSec = Window:NewTab("Auto Farm"):NewSection("Automation") local TpSec = Window:NewTab("Teleport"):NewSection("Teleport") local UtilSec = Window:NewTab("Utilities"):NewSection("Tools") local InfoSec = Window:NewTab("Info"):NewSection("Player Info") InfoSec:NewLabel("🧠 Script by 100days0o")

-- Config local S = { autoWater = false, autoHarvest = false, autoReplant = false, autoBuySeed = false, autoBuyGear = false, seedType = "Tomato", seedPrice = 1000, gearName = "Sprinkler", gearPrice = 5000, threshold = 5000, loopDelay = 1 } local Stats = P:WaitForChild("leaderstats") local Backpack = P:WaitForChild("Backpack") local Char = P.Character or P.CharacterAdded:Wait() local HRP = Char:WaitForChild("HumanoidRootPart")

-- RemoteEvents local RE = RS:WaitForChild("RemoteEvents") local rem = {} for _,name in pairs({"WaterPlant", "HarvestPlant", "PlantSeed", "PurchaseSeed", "PurchaseGear"}) do rem[name] = RE:FindFirstChild(name) end

-- Anti-AFK P.Idled:Connect(function() VU:ClickButton2(Vector2.new()) end)

-- Auto Farming spawn(function() while wait(S.loopDelay) do for _,plant in pairs(workspace.Plants:GetChildren()) do if S.autoHarvest and rem.HarvestPlant and plant:FindFirstChild("FullyGrown") then rem.HarvestPlant:FireServer(plant) end if S.autoWater and rem.WaterPlant and plant:FindFirstChild("NeedsWater") then rem.WaterPlant:FireServer(plant) end if S.autoReplant and rem.PlantSeed and plant:FindFirstChild("Picked") then rem.PlantSeed:FireServer(plant.Position, S.seedType) end end local cash = (Stats.Cash and Stats.Cash.Value) or 0 if S.autoBuySeed and rem.PurchaseSeed and cash > S.threshold then rem.PurchaseSeed:FireServer(S.seedType, math.floor(cash / S.seedPrice)) end if S.autoBuyGear and rem.PurchaseGear and cash > S.gearPrice then rem.PurchaseGear:FireServer(S.gearName) end end end)

-- GUI Toggles FarmSec:NewToggle("Auto Water", "Automatically water plants", function(v) S.autoWater = v end) FarmSec:NewToggle("Auto Harvest", "Automatically harvest plants", function(v) S.autoHarvest = v end) FarmSec:NewToggle("Auto Replant", "Automatically replant seeds", function(v) S.autoReplant = v end) FarmSec:NewToggle("Auto Buy Seed", "Automatically buy seeds", function(v) S.autoBuySeed = v end) FarmSec:NewToggle("Auto Buy Gear", "Automatically buy gear", function(v) S.autoBuyGear = v end) FarmSec:NewButton("Disable All", "Disable all automation", function() for k,_ in pairs(S) do if type(S[k]) == "boolean" then S[k] = false end end end)

-- Teleport Locations local locs = { ["Garden"] = Vector3.new(50,5,120), ["Seed Shop"] = Vector3.new(-120,5,80), ["Gear Shop"] = Vector3.new(-60,5,-40

