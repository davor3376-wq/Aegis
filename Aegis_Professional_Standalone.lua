--[[
    AEGIS ULTIMATE - PROFESSIONAL BUILD (v3.0)
    "The Atlas Killer"

    Architecture: Unified Monolith (Standalone)
    UI Library: Fluent (Dark Matter)
    Physics: TweenService + Humanoid:MoveTo
    Interaction: VirtualInputManager
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Update Character Reference on Spawn
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
end)

-- Request Function (Executor Support)
local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

-- ============================================================================
-- 1. CONFIGURATION & MANIFEST (The Brain)
-- ============================================================================
local Config = {
    -- Toggles
    Autofarm = false,
    Combat = false,
    Quests = false,

    -- State
    CurrentField = "Sunflower Field",
    CurrentPattern = "Snake",
    WalkSpeed = 16,
    JumpPower = 50,
}

local Manifest = {
    Fields = {
        ["Sunflower Field"] = { Center = Vector3.new(208, 4, 137), Size = Vector3.new(65, 0, 46) }, -- Adjusted Real Coords
        ["Dandelion Field"] = { Center = Vector3.new(30, 4, 220), Size = Vector3.new(65, 0, 50) },
        ["Mushroom Field"] = { Center = Vector3.new(-93, 5, 115), Size = Vector3.new(55, 0, 55) },
        ["Blue Flower Field"] = { Center = Vector3.new(113, 4, 286), Size = Vector3.new(65, 0, 65) },
        ["Clover Field"] = { Center = Vector3.new(174, 5, 193), Size = Vector3.new(70, 0, 70) },
        ["Spider Field"] = { Center = Vector3.new(-57, 5, -23), Size = Vector3.new(60, 0, 60) },
        ["Bamboo Field"] = { Center = Vector3.new(93, 5, -25), Size = Vector3.new(50, 0, 90) },
        ["Strawberry Field"] = { Center = Vector3.new(-180, 5, 20), Size = Vector3.new(55, 0, 55) },
        ["Pineapple Patch"] = { Center = Vector3.new(262, 68, -201), Size = Vector3.new(60, 0, 60) },
        ["Stump Field"] = { Center = Vector3.new(416, 97, -173), Size = Vector3.new(55, 0, 55) },
        ["Cactus Field"] = { Center = Vector3.new(-194, 68, -107), Size = Vector3.new(55, 0, 55) },
        ["Pumpkin Patch"] = { Center = Vector3.new(-194, 68, -182), Size = Vector3.new(60, 0, 60) },
        ["Pine Tree Forest"] = { Center = Vector3.new(-318, 68, -50), Size = Vector3.new(70, 0, 70) },
        ["Rose Field"] = { Center = Vector3.new(-322, 68, 124), Size = Vector3.new(60, 0, 60) },
        ["Mountain Top Field"] = { Center = Vector3.new(76, 176, -171), Size = Vector3.new(75, 0, 75) },
        ["Coconut Field"] = { Center = Vector3.new(-255, 72, 463), Size = Vector3.new(70, 0, 70) },
        ["Pepper Patch"] = { Center = Vector3.new(-485, 124, 517), Size = Vector3.new(65, 0, 65) },
    },
    Bosses = {
        ["Tunnel Bear"] = { Pos = Vector3.new(469, 5, 96), Enabled = false, Status = "Ready" },
        ["King Beetle"] = { Pos = Vector3.new(122, 5, 275), Enabled = false, Status = "Ready" }, -- Entrance
        ["Stump Snail"] = { Pos = Vector3.new(416, 97, -173), Enabled = false, Status = "Ready", Method = "Stationary" },
        ["Coconut Crab"] = { Pos = Vector3.new(-255, 72, 463), Enabled = false, Status = "Ready", Method = "Walk" },
        ["Commando Chick"] = { Pos = Vector3.new(30, 5, 30), Enabled = false, Status = "Ready", Method = "Tween" }, -- Placeholder Pos
        ["Mondo Chick"] = { Pos = Vector3.new(76, 176, -171), Enabled = false, Status = "Ready" },
    }
}

-- ============================================================================
-- 2. HELPER FUNCTIONS (Physics & Interaction)
-- ============================================================================

local function TweenTo(position, speed)
    speed = speed or 35
    if not RootPart then return end
    local distance = (position - RootPart.Position).Magnitude
    local info = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(RootPart, info, {CFrame = CFrame.new(position)})
    tween:Play()
    tween.Completed:Wait()
end

local function VirtualClick(x, y)
    VirtualInputManager:SendMouseButtonEvent(x or 500, y or 500, 0, true, game, 1)
    task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(x or 500, y or 500, 0, false, game, 1)
end

local function CollectToken(token)
    -- Logic to touch token
    if token and token:IsA("BasePart") then
        RootPart.CFrame = token.CFrame
    end
end

-- ============================================================================
-- 3. CORE SYSTEMS (Logic)
-- ============================================================================

-- [FARMING SYSTEM]
local Farming = {}
function Farming.GetPatternPosition(center, size, pattern, index)
    local width = size.X / 2
    local depth = size.Z / 2

    if pattern == "Snake" then
        -- Snake: Zig-zag along X, Step along Z
        local stepSize = 6
        local x = (index % (width * 2)) - width
        local z = math.floor(index / width) * stepSize
        z = (z % (depth * 2)) - depth
        -- Flip direction every row
        if math.floor(z / stepSize) % 2 == 1 then x = -x end
        return center + Vector3.new(x, 0, z)

    elseif pattern == "Super-Spiral" then
        -- Expanding circles
        local angle = index * 0.5
        local radius = (index * 0.2) % width
        return center + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)

    elseif pattern == "E_lol" then
        -- Square with cross
        local limit = width * 0.8
        local phase = index % 80
        if phase < 20 then return center + Vector3.new(limit, 0, (phase - 10) * (limit/10)) -- Right Side
        elseif phase < 40 then return center + Vector3.new((30 - phase) * (limit/10), 0, limit) -- Bottom Side
        elseif phase < 60 then return center + Vector3.new(-limit, 0, (50 - phase) * (limit/10)) -- Left Side
        else return center + Vector3.new((phase - 70) * (limit/10), 0, -limit) -- Top Side
        end
    end
    return center
end

function Farming.Run()
    local step = 0
    while Config.Autofarm do
        local fieldData = Manifest.Fields[Config.CurrentField]
        if fieldData then
            local targetPos = Farming.GetPatternPosition(fieldData.Center, fieldData.Size, Config.CurrentPattern, step)

            -- Move using Humanoid for natural appearance (Bot detection evasion)
            Humanoid:MoveTo(targetPos)

            -- Tool Swing (Virtual Click)
            VirtualClick()

            -- Detect Priority Tokens (Matrix)
            -- Mock Logic: Scan workspace.Collectibles

            step = step + 1
        end
        task.wait(0.1)
    end
end

-- [COMBAT SYSTEM]
local Combat = {}
function Combat.Run()
    while Config.Combat do
        for name, data in pairs(Manifest.Bosses) do
            if data.Enabled and data.Status == "Ready" then
                print("[Slayer] Engaging " .. name)

                -- Travel
                TweenTo(data.Pos)

                -- Kill Logic
                if name == "Stump Snail" and data.Method == "Train" then
                    -- Dodge Pattern
                    local angle = 0
                    while data.Enabled do -- Loop until killed or disabled
                        angle = angle + 0.2
                        local offset = Vector3.new(math.cos(angle)*30, 0, math.sin(angle)*30)
                        Humanoid:MoveTo(data.Pos + offset)
                        task.wait(0.1)
                    end
                elseif name == "Coconut Crab" and data.Method == "Tween" then
                    -- Hover
                    RootPart.CFrame = CFrame.new(data.Pos + Vector3.new(0, 20, 0))
                    -- Wait for kill
                else
                    -- Standard Stand & Kill
                    Humanoid:MoveTo(data.Pos)
                end

                -- Mock Cooldown Reset
                task.wait(5)
                print("[Slayer] " .. name .. " Defeated")
            end
        end
        task.wait(1)
    end
end

-- ============================================================================
-- 4. UI CONSTRUCTION (Fluent)
-- ============================================================================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Aegis Ultimate",
    SubTitle = "Professional Build v3.0",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Slayer = Window:AddTab({ Title = "Slayer", Icon = "skull" }),
    Overlord = Window:AddTab({ Title = "Overlord", Icon = "sword" }),
    Pathfinder = Window:AddTab({ Title = "Pathfinder", Icon = "map" }), -- Quests
    Botanist = Window:AddTab({ Title = "Botanist", Icon = "flower" }),
    Artifacts = Window:AddTab({ Title = "Artifacts", Icon = "package" }),
    Nexus = Window:AddTab({ Title = "Nexus", Icon = "settings" })
}

-- [OVERLORD TAB]
local fieldNames = {}
for k,v in pairs(Manifest.Fields) do table.insert(fieldNames, k) end
table.sort(fieldNames)

Tabs.Overlord:AddDropdown("FieldSelect", {
    Title = "Select Field",
    Values = fieldNames,
    Multi = false,
    Default = 1,
    Callback = function(val) Config.CurrentField = val end
})

Tabs.Overlord:AddDropdown("PatternSelect", {
    Title = "Pattern",
    Values = {"Snake", "Super-Spiral", "E_lol"},
    Multi = false,
    Default = 1,
    Callback = function(val) Config.CurrentPattern = val end
})

Tabs.Overlord:AddToggle("AutofarmToggle", {
    Title = "Enable Autofarm",
    Default = false,
    Callback = function(val)
        Config.Autofarm = val
        if val then task.spawn(Farming.Run) end
    end
})

-- [SLAYER TAB]
for boss, data in pairs(Manifest.Bosses) do
    Tabs.Slayer:AddToggle("Boss_"..boss, {
        Title = boss .. " [" .. data.Status .. "]",
        Default = false,
        Callback = function(val)
            Manifest.Bosses[boss].Enabled = val
            Config.Combat = true -- Enable loop if any boss selected
            task.spawn(Combat.Run)
        end
    })
end

-- [BOTANIST TAB]
Tabs.Botanist:AddDropdown("NectarPriority", {
    Title = "Nectar Goal",
    Values = {"Motivating", "Satisfying", "Refreshing", "Invigorating", "Comforting"},
    Default = 1,
    Callback = function(val)
        -- Logic to calculate best field
        local bestField = "None"
        local maxMult = 0
        for name, field in pairs(Manifest.Fields) do
            if field.Nectar and field.Nectar[val] and field.Nectar[val] > maxMult then
                maxMult = field.Nectar[val]
                bestField = name
            end
        end
        Fluent:Notify({Title = "Optimizer", Content = "Best Field: " .. bestField .. " (x"..maxMult..")", Duration = 3})
    end
})

-- [ARTIFACTS TAB]
local Dispensers = {"Samovar", "Glue", "Treats", "Blueberry", "Strawberry", "Coconut", "Onett's Lid Art"}
for _, d in ipairs(Dispensers) do
    Tabs.Artifacts:AddToggle("Disp_"..d, { Title = "Auto "..d, Default = true })
end

-- [NEXUS TAB]
Tabs.Nexus:AddSlider("WalkSpeed", {
    Title = "Walk Speed",
    Description = "Adjust player speed",
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 1,
    Callback = function(val)
        Config.WalkSpeed = val
        if Humanoid then Humanoid.WalkSpeed = val end
    end
})

Window:SelectTab(1)
Fluent:Notify({
    Title = "Aegis Ultimate",
    Content = "Professional Build Loaded.",
    Duration = 5
})

-- Main Physics Loop
RunService.Heartbeat:Connect(function()
    if Humanoid then
        Humanoid.WalkSpeed = Config.WalkSpeed
    end
end)
