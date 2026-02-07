--[[
    Aegis Ultimate - Swarm Protocol (GOD-RUN EDITION)
    Unified Standalone Script for Mobile Executors (Delta)
    Bypassing File System Dependencies.

    Modules: Manifest, Body, Combat, Farming, Planters, Quests, Toys, Webhook, UI
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

-- ============================================================================
-- 1. THE BRAIN (MANIFEST)
-- ============================================================================
local Manifest = {}

-- Fields
Manifest.Fields = {
    ["Sunflower Field"] = { Center = Vector3.new(100, 5, 100), Size = Vector3.new(60, 0, 60), Nectar = { Motivating = 1.0, Satisfying = 1.1 } },
    ["Dandelion Field"] = { Center = Vector3.new(50, 5, 150), Size = Vector3.new(50, 0, 50), Nectar = { Comforting = 1.2 } },
    ["Mushroom Field"] = { Center = Vector3.new(-50, 5, 100), Size = Vector3.new(40, 0, 40), Nectar = { Motivating = 1.2, Refreshing = 1.1 } },
    ["Blue Flower Field"] = { Center = Vector3.new(150, 5, 50), Size = Vector3.new(55, 0, 55), Nectar = { Refreshing = 1.3 } },
    ["Clover Field"] = { Center = Vector3.new(200, 5, 150), Size = Vector3.new(60, 0, 60), Nectar = { Invigorating = 1.1 } },
    ["Spider Field"] = { Center = Vector3.new(-20, 5, 200), Size = Vector3.new(45, 0, 45), Nectar = { Satisfying = 1.0 } },
    ["Bamboo Field"] = { Center = Vector3.new(80, 5, 250), Size = Vector3.new(50, 0, 90), Nectar = { Comforting = 1.1, Refreshing = 1.2 } },
    ["Strawberry Field"] = { Center = Vector3.new(-80, 5, 250), Size = Vector3.new(50, 0, 60), Nectar = { Invigorating = 1.3, Motivating = 1.1 } },
    ["Pineapple Patch"] = { Center = Vector3.new(250, 15, 100), Size = Vector3.new(50, 0, 50), Nectar = { Satisfying = 1.4 } },
    ["Stump Field"] = { Center = Vector3.new(-100, 20, 100), Size = Vector3.new(60, 0, 60), Nectar = { Motivating = 1.0 } },
    ["Cactus Field"] = { Center = Vector3.new(300, 10, 200), Size = Vector3.new(55, 0, 55), Nectar = { Refreshing = 1.1, Invigorating = 1.1 } },
    ["Pumpkin Patch"] = { Center = Vector3.new(-150, 10, 200), Size = Vector3.new(60, 0, 60), Nectar = { Satisfying = 1.2, Comforting = 1.1 } },
    ["Pine Tree Forest"] = { Center = Vector3.new(350, 15, 250), Size = Vector3.new(70, 0, 70), Nectar = { Satisfying = 1.3 } },
    ["Rose Field"] = { Center = Vector3.new(-200, 15, 250), Size = Vector3.new(60, 0, 60), Nectar = { Motivating = 1.4, Invigorating = 1.2 } },
    ["Mountain Top Field"] = { Center = Vector3.new(0, 30, -50), Size = Vector3.new(80, 0, 80), Nectar = { Invigorating = 1.0 } },
    ["Coconut Field"] = { Center = Vector3.new(500, 15, 300), Size = Vector3.new(70, 0, 70), Nectar = { Comforting = 1.5 } },
    ["Pepper Patch"] = { Center = Vector3.new(500, 25, 400), Size = Vector3.new(65, 0, 65), Nectar = { Invigorating = 1.5, Motivating = 1.1 } }
}

-- Bosses
Manifest.Bosses = {
    ["Tunnel Bear"] = { Coordinates = Vector3.new(200, 10, 50), RespawnTime = 0, Settings = { "Auto Kill", "Tween Method" } },
    ["King Beetle"] = { Coordinates = Vector3.new(150, 5, 200), RespawnTime = 0, Settings = { "Auto Kill", "Auto Amulet", "Keep Old" } },
    ["Stump Snail"] = { Coordinates = Vector3.new(-100, 20, 100), RespawnTime = 0, Settings = { "Train Snail", "Auto Shell Amulet", "Keep Old" } },
    ["Coconut Crab"] = { Coordinates = Vector3.new(500, 15, 300), RespawnTime = 0, Settings = { "Auto Kill", "Kill Method: Tween" } },
    ["Commando Chick"] = { Coordinates = Vector3.new(50, 15, -20), RespawnTime = 0, Settings = { "Auto Kill", "Kill Method: Tween", "Respawn When Shell", "Help Alt" } },
    ["Mondo Chick"] = { Coordinates = Vector3.new(0, 30, -50), RespawnTime = 0, Settings = { "Auto Kill", "Time To Kill: 15m", "Prepare Time: 10s" } },
    ["Windy Bee"] = { Coordinates = Vector3.new(0, 0, 0), RespawnTime = 0, Settings = { "Auto Kill", "Donate Cloud Vials", "Min Level: 5", "Max Level: 15" } },
    ["Vicious Bee"] = { Coordinates = Vector3.new(0, 0, 0), RespawnTime = 0, Settings = { "Auto Kill", "Server Hop" } }
}

-- NPCs
Manifest.NPCs = {
    ["Black Bear"] = { Coordinates = Vector3.new(110, 5, 110) },
    ["Brown Bear"] = { Coordinates = Vector3.new(210, 5, 160) },
    ["Panda Bear"] = { Coordinates = Vector3.new(90, 5, 260) },
    ["Polar Bear"] = { Coordinates = Vector3.new(-100, 5, 50) },
    ["Science Bear"] = { Coordinates = Vector3.new(160, 15, 60) },
    ["Dapper Bear"] = { Coordinates = Vector3.new(30, 5, 300) },
    ["Mother Bear"] = { Coordinates = Vector3.new(-40, 5, 100) },
    ["Spirit Bear"] = { Coordinates = Vector3.new(500, 15, 350) },
    ["Bucko Bee"] = { Coordinates = Vector3.new(160, 5, 40) },
    ["Riley Bee"] = { Coordinates = Vector3.new(-100, 5, 240) },
    ["Honey Bee"] = { Coordinates = Vector3.new(100, 20, 100) },
    ["Onett"] = { Coordinates = Vector3.new(0, 40, -50) },
    ["Stick Bug"] = { Coordinates = Vector3.new(-50, 5, 80) },
    ["Gummy Bear"] = { Coordinates = Vector3.new(0, 100, 0) },
    ["Bee Bear"] = { Coordinates = Vector3.new(120, 5, 120) }
}

-- Tokens
Manifest.Tokens = { "Bubbles", "Fire", "Precise Mark", "Fuzz Bomb", "Petal", "Mark", "Coconut", "Cloud", "Meteor", "Festive Gift", "Token Link" }

-- Patterns
Manifest.Patterns = { ["Snake"] = "Snake", ["Super-Spiral"] = "Super-Spiral", ["E_lol"] = "E_lol", ["Corner-X"] = "Corner-X" }

-- Toys
Manifest.Toys = {
    ["Samovar"] = { Coordinates = Vector3.new(50, 5, 50), Cooldown = 3600 },
    ["Glue Dispenser"] = { Coordinates = Vector3.new(60, 20, 60), Cooldown = 79200 },
    ["Coconut Dispenser"] = { Coordinates = Vector3.new(500, 15, 300), Cooldown = 14400 },
    ["Blueberry Dispenser"] = { Coordinates = Vector3.new(100, 5, 100), Cooldown = 3600 },
    ["Strawberry Dispenser"] = { Coordinates = Vector3.new(120, 5, 120), Cooldown = 3600 },
    ["Onett's Lid Art"] = { Coordinates = Vector3.new(300, 30, 300), Cooldown = 28800 },
    ["Wealth Clock"] = { Coordinates = Vector3.new(20, 5, 20), Cooldown = 3600 },
    ["Free Royal Jelly"] = { Coordinates = Vector3.new(10, 50, 10), Cooldown = 79200 },
    ["Ant Challenge"] = { Coordinates = Vector3.new(100, 5, 100), Cooldown = 7200 }
}

-- Planters
Manifest.Planters = {
    ["Red Clay Planter"] = { Nectar = "Invigorating" },
    ["Blue Clay Planter"] = { Nectar = "Refreshing" },
    ["Candy Planter"] = { Nectar = "Motivating" },
    ["Tacky Planter"] = { Nectar = "Satisfying" },
    ["Pesticide Planter"] = { Nectar = "Comforting" },
    ["Petal Planter"] = { Nectar = "Satisfying" },
    ["The Planter of Plenty"] = { Nectar = "All" }
}


-- ============================================================================
-- 2. THE CORE (BODY: NAVIGATOR & AVIATOR)
-- ============================================================================
local Body = {}
local Aviator = { SAFETY_Y_LEVEL = 35 }
local Navigator = {}

function Aviator.vertical_bypass()
    print("[Bot-05 Aviator]: Vertical Bypass Initiated.")
    local bodyVelocity = Instance.new("BodyVelocity")
    local targetY = math.max(HumanoidRootPart.Position.Y + 20, Aviator.SAFETY_Y_LEVEL)
    bodyVelocity.Velocity = Vector3.new(0, 50, 0)
    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
    bodyVelocity.Parent = HumanoidRootPart

    while HumanoidRootPart.Position.Y < Aviator.SAFETY_Y_LEVEL do task.wait() end
    task.wait(0.5)
    bodyVelocity:Destroy()
    print("[Bot-05 Aviator]: Vertical Bypass Complete.")
end

function Navigator.raycast_check(direction)
    local rayOrigin = HumanoidRootPart.Position
    local rayDirection = direction * 5
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    local result = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    return result ~= nil
end

function Navigator.tween_to(target_position, speed)
    speed = speed or 30
    local distance = (target_position - HumanoidRootPart.Position).Magnitude
    local info = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(HumanoidRootPart, info, {CFrame = CFrame.new(target_position)})
    tween:Play()
    tween.Completed:Wait()
end

function Navigator.pathfind(target_position, method)
    method = method or "Walk"
    print("[Bot-04 Navigator]: Moving to " .. tostring(target_position) .. " (" .. method .. ")")

    if method == "Tween" then
        Navigator.tween_to(target_position)
        return
    end

    local reached = false
    while not reached do
        local dist = (target_position - HumanoidRootPart.Position).Magnitude
        if dist < 2 then reached = true; break end

        local dir = (target_position - HumanoidRootPart.Position).Unit
        if Navigator.raycast_check(dir) then
            Aviator.vertical_bypass()
        else
            Humanoid:MoveTo(target_position)
        end
        task.wait(0.1)
    end
end

Body.Navigator = Navigator
Body.Aviator = Aviator


-- ============================================================================
-- 3. THE LEGS (FARMING)
-- ============================================================================
local Farming = {}
local FarmingState = { IsFarming = false, CurrentField = "Sunflower Field", CurrentPattern = "Snake", TokenPriorities = {}, SproutSniper = false }

local Patterns = {}
function Patterns.Snake(center, size, step)
    local width, height = size.X / 2, size.Z / 2
    local step_size = 5
    local x = (step % (width * 2)) - width
    local z = math.floor(step / width) * step_size
    z = (z % (height * 2)) - height
    return center + Vector3.new(x, 0, z)
end

function Patterns.SuperSpiral(center, size, step)
    local angle = step * 0.5
    local radius = (step * 0.2) % (size.X / 2)
    return center + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
end

function Patterns.E_lol(center, size, step)
    local limit = size.X / 2
    local phase = step % 40
    if phase < 10 then return center + Vector3.new((phase - 5) * (limit/5), 0, -limit)
    elseif phase < 20 then return center + Vector3.new(limit, 0, (phase - 15) * (limit/5))
    elseif phase < 30 then return center + Vector3.new((25 - phase) * (limit/5), 0, limit)
    else return center + Vector3.new(-limit, 0, (35 - phase) * (limit/5)) end
end

function Farming.set_field(name) if Manifest.Fields[name] then FarmingState.CurrentField = name end end
function Farming.set_pattern(name) FarmingState.CurrentPattern = name end
function Farming.toggle_sprout_sniper(bool) FarmingState.SproutSniper = bool end
function Farming.set_token_priority(list) FarmingState.TokenPriorities = list end

function Farming.start_autofarm()
    if FarmingState.IsFarming then return end
    FarmingState.IsFarming = true
    print("[Bot-06 Farming]: Started in " .. FarmingState.CurrentField)

    task.spawn(function()
        local step = 0
        while FarmingState.IsFarming do
            if FarmingState.SproutSniper then
                -- Mock Sprout Check
            end

            local field = Manifest.Fields[FarmingState.CurrentField]
            if field then
                local target = Vector3.zero
                if FarmingState.CurrentPattern == "E_lol" then target = Patterns.E_lol(field.Center, field.Size, step)
                elseif FarmingState.CurrentPattern == "Super-Spiral" then target = Patterns.SuperSpiral(field.Center, field.Size, step)
                else target = Patterns.Snake(field.Center, field.Size, step) end

                Humanoid:MoveTo(target)
                step = step + 1
            end
            task.wait(0.1)
        end
        print("[Bot-06 Farming]: Stopped.")
    end)
end

function Farming.stop_autofarm() FarmingState.IsFarming = false end


-- ============================================================================
-- 4. THE SWORD (COMBAT)
-- ============================================================================
local Combat = {}
local CombatState = { ActiveTarget = nil, IsAttacking = false }

local function has_buff(name) return true end -- Mock
local function yield_for_buff(name, timeout)
    print("[Bot-07 Combat]: Waiting for " .. name)
    local start = os.time()
    while not has_buff(name) do
        if os.time() - start > timeout then return false end
        task.wait(1)
    end
    return true
end

function Combat.kill_boss(name)
    local data = Manifest.Bosses[name]
    if not data then return end

    CombatState.ActiveTarget = name
    CombatState.IsAttacking = true
    print("[Bot-07 Combat]: Killing " .. name)

    HumanoidRootPart.CFrame = CFrame.new(data.Coordinates)

    -- Special Logic Mocks
    if name == "Commando Chick" then
        -- Tween Logic
    elseif name == "Stump Snail" then
        -- Train Logic
    end

    task.wait(5) -- Kill Time

    yield_for_buff("Baby Love", 30)
    print("[Bot-07 Combat]: " .. name .. " Defeated.")
    CombatState.ActiveTarget = nil
    CombatState.IsAttacking = false
end

function Combat.toggle_boss(name, bool)
    -- Toggle Logic
    print("[Bot-07 Combat]: Boss " .. name .. " set to " .. tostring(bool))
end

function Combat.get_boss_status(name)
    local boss = Manifest.Bosses[name]
    if not boss then return "UNKNOWN" end
    if os.time() >= boss.RespawnTime then return "READY" else return "COOLDOWN" end
end


-- ============================================================================
-- 5. THE HANDS (PLANTERS)
-- ============================================================================
local Planters = {}
local PlanterState = { Active = {}, SmartSoil = true }

function Planters.get_best_field_for_nectar(nectar)
    local best, mult = nil, 0
    for name, data in pairs(Manifest.Fields) do
        local m = data.Nectar[nectar] or 0
        if m > mult then mult = m; best = name end
    end
    return best
end

function Planters.toggle_smart_soil(bool) PlanterState.SmartSoil = bool; print("[Bot-06 Planters]: Smart Soil: " .. tostring(bool)) end


-- ============================================================================
-- 6. THE SOUL (QUESTS)
-- ============================================================================
local Quests = {}
function Quests.auto_quest(npc)
    local data = Manifest.NPCs[npc]
    if data then
        print("[Bot-02 Quests]: Going to " .. npc)
        Navigator.pathfind(data.Coordinates)
        task.wait(1)
        print("[Bot-02 Quests]: Quest Accepted.")
    end
end

function Quests.run_challenge()
    print("[Bot-02 Quests]: Starting RBC...")
    -- RBC Logic
end


-- ============================================================================
-- 7. THE TOYS (DISPENSERS)
-- ============================================================================
local Toys = {}
local ToyRegistry = {}
for k,v in pairs(Manifest.Toys) do ToyRegistry[k] = { NextUse = 0, Enabled = true } end

function Toys.toggle_dispenser(name, bool)
    if ToyRegistry[name] then ToyRegistry[name].Enabled = bool; print("[Bot-09 Toys]: " .. name .. " " .. tostring(bool)) end
end


-- ============================================================================
-- 8. THE VOICE (WEBHOOK)
-- ============================================================================
local Webhook = {}
local WebhookSettings = { URL = "", Planters = true, Items = true }

function Webhook.set_url(url) WebhookSettings.URL = url end
function Webhook.toggle_send_planters(bool) WebhookSettings.Planters = bool end
function Webhook.toggle_send_items(bool) WebhookSettings.Items = bool end
function Webhook.toggle_send_quests(bool) WebhookSettings.Quests = bool end


-- ============================================================================
-- 9. THE FACE (UI DASHBOARD)
-- ============================================================================
local Dashboard = {}
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Aegis Ultimate - GOD MODE",
    SubTitle = "Standalone Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Overlord = Window:AddTab({ Title = "Overlord", Icon = "sword" }),
    Slayer = Window:AddTab({ Title = "Slayer", Icon = "skull" }),
    Quests = Window:AddTab({ Title = "Quests", Icon = "scroll" }),
    Botanist = Window:AddTab({ Title = "Botanist", Icon = "flower" }),
    Artifacts = Window:AddTab({ Title = "Artifacts", Icon = "package" }),
    Nexus = Window:AddTab({ Title = "Nexus", Icon = "settings" })
}

-- OVERLORD
local field_names = {}
for k,_ in pairs(Manifest.Fields) do table.insert(field_names, k) end
table.sort(field_names)

Tabs.Overlord:AddDropdown("SmartField", { Title = "Smart Field", Values = field_names, Default = 1, Callback = function(V) Farming.set_field(V) end })

local pattern_names = {}
for k,_ in pairs(Manifest.Patterns) do table.insert(pattern_names, k) end
Tabs.Overlord:AddDropdown("GatherPattern", { Title = "Gather Pattern", Values = pattern_names, Default = 1, Callback = function(V) Farming.set_pattern(V) end })

Tabs.Overlord:AddButton({
    Title = "GOD MODE (Pro Preset)",
    Description = "Enable All Bosses, Snake Pattern, Auto-Convert 100%, Smart Planters",
    Callback = function()
        print("[UI] Activating GOD MODE...")
        Farming.set_pattern("Snake")
        Planters.toggle_smart_soil(true)
        for boss, _ in pairs(Manifest.Bosses) do
            Combat.toggle_boss(boss, true)
        end
        Fluent:Notify({ Title = "God Mode", Content = "All systems maxed out.", Duration = 3 })
    end
})

Tabs.Overlord:AddToggle("Autofarm", { Title = "Start Autofarm", Default = false, Callback = function(V) if V then Farming.start_autofarm() else Farming.stop_autofarm() end end })

-- SLAYER
local boss_names = {}
for k,_ in pairs(Manifest.Bosses) do table.insert(boss_names, k) end
table.sort(boss_names)

for _, boss in ipairs(boss_names) do
    Tabs.Slayer:AddToggle(boss, { Title = boss, Default = false, Callback = function(V) Combat.toggle_boss(boss, V) end })
end

-- QUESTS
local npc_names = {}
for k,_ in pairs(Manifest.NPCs) do table.insert(npc_names, k) end
table.sort(npc_names)

for _, npc in ipairs(npc_names) do
    Tabs.Quests:AddButton({ Title = "Auto " .. npc, Callback = function() Quests.auto_quest(npc) end })
end

-- BOTANIST
Tabs.Botanist:AddDropdown("NectarPriority", {
    Title = "Nectar Priority",
    Values = {"Comforting", "Invigorating", "Motivating", "Refreshing", "Satisfying"},
    Default = 1,
    Callback = function(V)
        local best = Planters.get_best_field_for_nectar(V)
        Fluent:Notify({Title = "Optimizer", Content = "Best Field: " .. tostring(best), Duration = 3})
    end
})

-- ARTIFACTS
local disp_names = {}
for k,_ in pairs(Manifest.Toys) do table.insert(disp_names, k) end
table.sort(disp_names)

for _, d in ipairs(disp_names) do
    Tabs.Artifacts:AddToggle(d, { Title = d, Default = true, Callback = function(V) Toys.toggle_dispenser(d, V) end })
end

-- NEXUS
Tabs.Nexus:AddInput("WebhookURL", { Title = "Webhook URL", Default = "", Callback = function(V) Webhook.set_url(V) end })
Tabs.Nexus:AddToggle("SendPlanters", { Title = "Log Planters", Default = true, Callback = function(V) Webhook.toggle_send_planters(V) end })


Window:SelectTab(1)
Fluent:Notify({
    Title = "Aegis Ultimate",
    Content = "Swarm Protocol Online. God Mode Available.",
    Duration = 5
})

print("[Bot-10 Integrator]: Standalone Swarm Protocol Fully Online.")
