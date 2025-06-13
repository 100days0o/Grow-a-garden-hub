-- 🍀 Grow a Garden Hub – Main Script (English Version) -- Script by: 100days0o

-- Wait until game assets are loaded local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))() repeat wait() until workspace:FindFirstChild("Plants") and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents")

local Players = game:GetService("Players") local P = Players.LocalPlayer local UIS = game:GetService("UserInputService") local RS = game:GetService("ReplicatedStorage") local VU = game:GetService("VirtualUser")

-- UI Setup local Window = Library.CreateLib("🌱 Grow a Garden | 100days0o", "BloodTheme") local FarmSec = Window:NewTab("Auto Farm"):NewSection("Automation") local TpSec = Window:NewTab("Teleport"):NewSection("Teleport") local UtilSec = Window:NewTab("Utilities"):NewSection("Tools") local InfoSec = Window:NewTab("Info"):NewSection("Player Info") InfoSec:NewLabel("🧠 Script by 100days0o")

-- Config local S = { autoWater = false, autoHarvest = false, autoReplant = false, autoBuySeed = false, autoBuyGear = false, seedType = "Tomato", seedPrice = 1000, gearName = "Sprinkler", gearPrice = 5000, threshold = 5000, loopDelay = 1 } local Stats = P:WaitForChild("leaderstats") local Backpack = P:WaitForChild("Backpack") local Char = P.Character or P.CharacterAdded:Wait() local HRP = Char:WaitForChild("HumanoidRootPart")

-- RemoteEvents local RE = RS:WaitForChild("RemoteEvents") local rem = {} for _,name in pairs({"WaterPlant", "HarvestPlant", "PlantSeed", "PurchaseSeed", "PurchaseGear"}) do rem[name] = RE:FindFirstChild(name) end

-- Anti-AFK P.Idled:Connect(function() VU:ClickButton2(Vector2.new()) end)

-- Auto Farming spawn(function() while wait(S.loopDelay) do for _,plant in pairs(workspace.Plants:GetChildren()) do if S.autoHarvest and rem.HarvestPlant and plant:FindFirstChild("FullyGrown") then rem.HarvestPlant:FireServer(plant) end if S.autoWater and rem.WaterPlant and plant:FindFirstChild("NeedsWater") then rem.WaterPlant:FireServer(plant) end if S.autoReplant and rem.PlantSeed and plant:FindFirstChild("Picked") then rem.PlantSeed:FireServer(plant.Position, S.seedType) end end local cash = (Stats.Cash and Stats.Cash.Value) or 0 if S.autoBuySeed and rem.PurchaseSeed and cash > S.threshold then rem.PurchaseSeed:FireServer(S.seedType, math.floor(cash / S.seedPrice)) end if S.autoBuyGear and rem.PurchaseGear and cash > S.gearPrice then rem.PurchaseGear:FireServer(S.gearName) end end end)

-- GUI Toggles FarmSec:NewToggle("Auto Water", "Automatically water plants", function(v) S.autoWater = v end) FarmSec:NewToggle("Auto Harvest", "Automatically harvest plants", function(v) S.autoHarvest = v end) FarmSec:NewToggle("Auto Replant", "Automatically replant seeds", function(v) S.autoReplant = v end) FarmSec:NewToggle("Auto Buy Seed", "Automatically buy seeds", function(v) S.autoBuySeed = v end) FarmSec:NewToggle("Auto Buy Gear", "Automatically buy gear", function(v) S.autoBuyGear = v end) FarmSec:NewButton("Disable All", "Disable all automation", function() for k,_ in pairs(S) do if type(S[k]) == "boolean" then S[k] = false end end end)

-- Teleport Locations local locs = { ["Garden"] = Vector3.new(50,5,120), ["Seed Shop"] = Vector3.new(-120,5,80), ["Gear Shop"] = Vector3.new(-60,5,-40), } for name,pos in pairs(locs) do TpSec:NewButton(name, "Teleport to " .. name, function() HRP.CFrame = CFrame.new(pos) end) end

-- Reduce Lag UtilSec:NewButton("Reduce Lag", "Optimize game for low-end devices", function() for _,obj in pairs(workspace:GetDescendants()) do if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") or obj:IsA("Smoke") then obj:Destroy() elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1 end end local L = game:GetService("Lighting") L.FogEnd = 1e6 L.GlobalShadows = false end)

-- Player Info InfoSec:NewLabel("Name: " .. P.Name) spawn(function() while wait(2) do InfoSec:NewLabel("Cash: " .. tostring(Stats.Cash.Value)) end end) spawn(function() while wait(3) do local s = "" for _,tool in pairs(Backpack:GetChildren()) do if tool:IsA("Tool") and tool.Name:find(S.seedType) then s = s .. tool.Name .. ", " end end InfoSec:NewLabel("Seeds: " .. (s ~= "" and s or "none")) end end)

-- Troll Tab: Infinite Jump and Fly local TrollTab = Window:NewTab("Troll") local TrollSec = TrollTab:NewSection("Fun Features")

local infJ = false TrollSec:NewToggle("Infinite Jump", "Hold space to jump infinitely", function(v) infJ = v end) UIS.JumpRequest:Connect(function() if infJ and P.Character and P.Character:FindFirstChild("Humanoid") then P.Character:FindFirstChild("Humanoid"):ChangeState("Jumping") end end)

local fly = false local flyConn, gyro, vel local function toggleFly(on) if on then local char = P.Character if not char then return end local HR = char:FindFirstChild("HumanoidRootPart") gyro = Instance.new("BodyGyro", HR) vel = Instance.new("BodyVelocity", HR) gyro.P = 9e4 gyro.maxTorque = Vector3.new(9e9,9e9,9e9) gyro.cframe = HR.CFrame vel.Velocity = Vector3.new(0,0,0) vel.MaxForce = Vector3.new(9e9,9e9,9e9) local keys = {w=false,a=false,s=false,d=false} local cam = workspace.CurrentCamera

flyConn = game:GetService("RunService").Heartbeat:Connect(function()
        local dir = Vector3.new()
        if keys.w then dir += cam.CFrame.LookVector end
        if keys.s then dir -= cam.CFrame.LookVector end
        if keys.a then dir -= cam.CFrame.RightVector end
        if keys.d then dir += cam.CFrame.RightVector end
        vel.Velocity = dir.Unit * 60
        gyro.CFrame = cam.CFrame
    end)

    UIS.InputBegan:Connect(function(i, g)
        if g then return end
        if i.KeyCode == Enum.KeyCode.W then keys.w = true end
        if i.KeyCode == Enum.KeyCode.A then keys.a = true end
        if i.KeyCode == Enum.KeyCode.S then keys.s = true end
        if i.KeyCode == Enum.KeyCode.D then keys.d = true end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.W then keys.w = false end
        if i.KeyCode == Enum.KeyCode.A then keys.a = false end
        if i.KeyCode == Enum.KeyCode.S then keys.s = false end
        if i.KeyCode == Enum.KeyCode.D then keys.d = false end
    end)
else
    if flyConn then flyConn:Disconnect() end
    if gyro then gyro:Destroy() end
    if vel then vel:Destroy() end
end

end TrollSec:NewToggle("Fly", "Enable WASD fly mode", function(v) fly = v toggleFly(v) end)

-- GUI Toggle UIS.InputBegan:Connect(function(inp, g) if g then return end if inp.KeyCode == Enum.KeyCode.RightShift then Window:Toggle() end end)

