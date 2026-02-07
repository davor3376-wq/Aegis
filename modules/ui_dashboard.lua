--[[
    Swarm Protocol - UI Dashboard (Bot-08)
    Theme: Dark Matter (#0a0a0a, #3b82f6)
    Library: Fluent UI (dawid)
    Dynamic Logic: Powered by The Brain (Manifest)
]]

local Dashboard = {}
local Manifest = require(script.Parent.Manifest) -- The Brain

-- Load Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Create Window (Dark Matter Theme)
local Window = Fluent:CreateWindow({
    Title = "Aegis Ultimate - Swarm Protocol",
    SubTitle = "God-Run Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

function Dashboard.init(modules)
    local Navigator = modules.Navigator -- Actually Body.Navigator
    local Combat = modules.Combat
    local Planters = modules.Planters
    local Toys = modules.Toys
    local Webhook = modules.Webhook
    local Aviator = modules.Aviator
    local Farming = modules.Farming
    local Quests = modules.Quests

    -- TABS
    local Tabs = {
        Overlord = Window:AddTab({ Title = "Overlord", Icon = "sword" }),
        Slayer = Window:AddTab({ Title = "Slayer", Icon = "skull" }),
        Quests = Window:AddTab({ Title = "Quests", Icon = "scroll" }),
        Botanist = Window:AddTab({ Title = "Botanist", Icon = "flower" }),
        Artifacts = Window:AddTab({ Title = "Artifacts", Icon = "package" }),
        Nexus = Window:AddTab({ Title = "Nexus", Icon = "settings" })
    }

    -- 1. OVERLORD: Farming & Patterns

    -- Field Selection
    local field_names = {}
    for name, _ in pairs(Manifest.Fields) do table.insert(field_names, name) end
    table.sort(field_names)

    Tabs.Overlord:AddDropdown("SmartField", {
        Title = "Smart Field",
        Values = field_names,
        Multi = false,
        Default = 1,
        Callback = function(Value)
            if Farming then Farming.set_field(Value) end
        end
    })

    -- Pattern Selection
    local pattern_names = {}
    for name, _ in pairs(Manifest.Patterns) do table.insert(pattern_names, name) end

    Tabs.Overlord:AddDropdown("GatherPattern", {
        Title = "Gather Pattern",
        Values = pattern_names,
        Multi = false,
        Default = 1,
        Callback = function(Value)
            if Farming then Farming.set_pattern(Value) end
        end
    })

    -- God Mode / Pro Preset
    Tabs.Overlord:AddButton({
        Title = "GOD MODE (Pro Preset)",
        Description = "Enable All Bosses, Snake Pattern, Auto-Convert 100%, Smart Planters",
        Callback = function()
            print("[UI] Activating GOD MODE...")
            if Farming then Farming.set_pattern("Snake") end
            if Planters then Planters.toggle_smart_soil(true) end
            if Combat then
                for boss, _ in pairs(Manifest.Bosses) do
                    Combat.toggle_boss(boss, true)
                end
            end
            Fluent:Notify({ Title = "God Mode", Content = "All systems maxed out.", Duration = 3 })
        end
    })

    Tabs.Overlord:AddToggle("Autofarm", {
        Title = "Start Autofarm",
        Default = false,
        Callback = function(Value)
            if Farming then
                if Value then Farming.start_autofarm() else Farming.stop_autofarm() end
            end
        end
    })

    Tabs.Overlord:AddToggle("SproutSniper", {
        Title = "Sprout Sniper",
        Default = false,
        Callback = function(Value)
            if Farming then Farming.toggle_sprout_sniper(Value) end
        end
    })

    -- Token Priority Matrix
    local TokenSection = Tabs.Overlord:AddSection("Token Priority")
    -- Fluent doesn't support massive multiselect well, so using a few key toggles or a prioritized dropdown
    -- Or we iterate:
    for _, token in ipairs(Manifest.Tokens) do
        -- Just adding a few as examples to avoid UI clutter in this mock,
        -- but "Pro-Tier" implies control.
        -- Let's add a Multi-Dropdown if supported or just a few key toggles.
        -- Assuming MultiDropdown support or just simulating logic
    end
    -- Use dropdown for Priority Token
    Tabs.Overlord:AddDropdown("PriorityToken", {
        Title = "Focus Token",
        Values = Manifest.Tokens,
        Multi = true,
        Default = {},
        Callback = function(Value)
            -- Value is a table of selected strings
            if Farming then Farming.set_token_priority(Value) end
        end
    })


    -- 2. SLAYER: Dynamic Boss List
    local BossToggles = {}

    -- Sort bosses for consistent UI
    local boss_names = {}
    for name, _ in pairs(Manifest.Bosses) do table.insert(boss_names, name) end
    table.sort(boss_names)

    for _, bossName in ipairs(boss_names) do
        local bossData = Manifest.Bosses[bossName]
        BossToggles[bossName] = Tabs.Slayer:AddToggle(bossName, {
            Title = bossName .. " [WAITING...]",
            Default = false,
            Callback = function(Value)
                if Combat then Combat.toggle_boss(bossName, Value) end
            end
        })
    end

    -- Live Status Update Loop
    task.spawn(function()
        while true do
            if Combat and Combat.get_boss_status then
                for bossName, toggle in pairs(BossToggles) do
                    local status = Combat.get_boss_status(bossName)
                    if toggle.SetTitle then
                        toggle:SetTitle(bossName .. " [" .. status .. "]")
                    end
                end
            end
            task.wait(1)
        end
    end)


    -- 3. QUESTS: NPC Matrix
    local npc_names = {}
    for name, _ in pairs(Manifest.NPCs) do table.insert(npc_names, name) end
    table.sort(npc_names)

    for _, npc in ipairs(npc_names) do
        Tabs.Quests:AddButton({
            Title = "Auto " .. npc,
            Callback = function()
                if Quests then Quests.auto_quest(npc) end
            end
        })
    end

    Tabs.Quests:AddButton({
        Title = "Start Robo Bear Challenge",
        Callback = function()
            if Quests then Quests.run_challenge() end
        end
    })


    -- 4. BOTANIST: Planters
    Tabs.Botanist:AddDropdown("NectarPriority", {
        Title = "Nectar Priority",
        Values = {"Comforting", "Invigorating", "Motivating", "Refreshing", "Satisfying"},
        Multi = false,
        Default = 1,
        Callback = function(Value)
            if Planters then
                local best = Planters.get_best_field_for_nectar(Value)
                Fluent:Notify({Title = "Optimizer", Content = "Best Field: " .. tostring(best), Duration = 3})
            end
        end
    })

    -- Active Planters Display (Placeholder for dynamic list)
    Tabs.Botanist:AddParagraph({
        Title = "Active Planters",
        Content = "None"
    })


    -- 5. ARTIFACTS: Dispensers
    local dispenser_names = {}
    for name, _ in pairs(Manifest.Toys) do table.insert(dispenser_names, name) end
    table.sort(dispenser_names)

    for _, disp in ipairs(dispenser_names) do
        Tabs.Artifacts:AddToggle(disp, {
            Title = disp,
            Default = true,
            Callback = function(Value)
                 if Toys then Toys.toggle_dispenser(disp, Value) end
            end
        })
    end


    -- 6. NEXUS: Webhook & Config
    Tabs.Nexus:AddInput("WebhookURL", {
        Title = "Discord Webhook URL",
        Default = "",
        Placeholder = "https://discord.com/...",
        Numeric = false,
        Finished = true,
        Callback = function(Value)
            if Webhook then Webhook.set_url(Value) end
        end
    })

    Tabs.Nexus:AddToggle("SendPlanters", { Title = "Log Planters", Default = true, Callback = function(V) if Webhook then Webhook.toggle_send_planters(V) end end })
    Tabs.Nexus:AddToggle("SendItems", { Title = "Log Items", Default = true, Callback = function(V) if Webhook then Webhook.toggle_send_items(V) end end })
    Tabs.Nexus:AddToggle("SendQuests", { Title = "Log Quests", Default = true, Callback = function(V) if Webhook then Webhook.toggle_send_quests(V) end end })


    Window:SelectTab(1)
    Fluent:Notify({
        Title = "Aegis Ultimate",
        Content = "Swarm Protocol Online. God Mode Available.",
        Duration = 5
    })
end

return Dashboard
