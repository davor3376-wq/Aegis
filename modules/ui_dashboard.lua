--[[
    Swarm Protocol - UI Dashboard (Bot-08)
    Theme: Dark Matter (#0a0a0a, #3b82f6)
    Library: Fluent UI (dawid)
]]

local Dashboard = {}

-- Load Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Create Window (Dark Matter Theme)
local Window = Fluent:CreateWindow({
    Title = "Aegis Ultimate - Swarm Protocol",
    SubTitle = "by Jules",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

function Dashboard.init(modules)
    local Navigator = modules.Navigator
    local Combat = modules.Combat
    local Planters = modules.Planters
    local Toys = modules.Toys
    local Webhook = modules.Webhook
    local Aviator = modules.Aviator

    -- TAB 1: OVERLORD (Farming)
    local Tabs = {
        Overlord = Window:AddTab({ Title = "Overlord", Icon = "sword" }),
        Slayer = Window:AddTab({ Title = "Slayer", Icon = "skull" }),
        Quests = Window:AddTab({ Title = "Quests", Icon = "scroll" }),
        Botanist = Window:AddTab({ Title = "Botanist", Icon = "flower" }),
        Artifacts = Window:AddTab({ Title = "Artifacts", Icon = "package" }),
        Nexus = Window:AddTab({ Title = "Nexus", Icon = "settings" })
    }

    -- 1. OVERLORD: Smart Field & Gather Pattern
    Tabs.Overlord:AddDropdown("SmartField", {
        Title = "Smart Field",
        Values = {"Best Blue", "Best Red", "Best White"},
        Multi = false,
        Default = 1,
        Callback = function(Value)
            print("[UI] Smart Field Set: ", Value)
            if Navigator and Navigator.set_smart_field then Navigator.set_smart_field(Value) end
        end
    })

    Tabs.Overlord:AddDropdown("GatherPattern", {
        Title = "Gather Pattern",
        Values = {"Elian's Snake", "Super-Spiral", "Corner-X"},
        Multi = false,
        Default = 1,
        Callback = function(Value)
            print("[UI] Pattern Set: ", Value)
            if Navigator and Navigator.set_pattern then Navigator.set_pattern(Value) end
        end
    })

    Tabs.Overlord:AddToggle("SproutSniper", {
        Title = "Sprout Sniper",
        Description = "Bot-05 (Aviator) abandons farm for Sprouts.",
        Default = false,
        Callback = function(Value)
            print("[UI] Sprout Sniper: ", Value)
            if Aviator and Aviator.toggle_sprout_sniper then Aviator.toggle_sprout_sniper(Value) end
        end
    })

    -- 2. SLAYER: Live Boss Buttons
    local BossToggles = {}

    local function createBossToggle(bossName, displayName)
        BossToggles[bossName] = Tabs.Slayer:AddToggle(bossName, {
            Title = displayName .. " (Loading...)",
            Default = false,
            Callback = function(Value)
                print("[UI] Toggle Boss " .. bossName .. ": ", Value)
                if Combat and Combat.toggle_boss then
                    Combat.toggle_boss(bossName, Value)
                end
            end
        })
    end

    createBossToggle("Tunnel Bear", "Tunnel Bear")
    createBossToggle("King Beetle", "King Beetle")

    -- Logic to update button text based on Combat module
    task.spawn(function()
        while true do
            if Combat and Combat.get_boss_status then
                for bossName, toggle in pairs(BossToggles) do
                    local status = Combat.get_boss_status(bossName)
                    -- Note: Fluent might not support dynamic title updates easily depending on version,
                    -- ensuring SetTitle exists or fallback to just status logging.
                    if toggle.SetTitle then
                        toggle:SetTitle(bossName .. " (" .. status .. ")")
                    end
                end
            end
            task.wait(1)
        end
    end)

    Tabs.Slayer:AddToggle("ViciousHunter", {
        Title = "Vicious Hunter (Server Hop)",
        Default = false,
        Callback = function(Value)
            print("[UI] Vicious Hunter: ", Value)
            -- if Combat then Combat.toggle_server_hop(Value) end
        end
    })

    Tabs.Slayer:AddToggle("SmartMask", {
        Title = "Smart Mask Swap",
        Description = "Demon for Bosses, Diamond/Gummy for Farm.",
        Default = false,
        Callback = function(Value)
            print("[UI] Smart Mask: ", Value)
            if Combat and Combat.set_smart_mask then Combat.set_smart_mask(Value) end
        end
    })


    -- 3. QUESTS: NPC Matrix
    local NPCToggles = {"Black Bear", "Brown Bear", "Polar Bear", "Science Bear", "Dapper Bear"}
    for _, npc in ipairs(NPCToggles) do
        Tabs.Quests:AddToggle(npc, {
            Title = npc,
            Default = true,
            Callback = function(Value)
                print("[UI] Quest Toggle " .. npc .. ": ", Value)
            end
        })
    end
    -- Visual Progress Bar (Placeholder)
    Tabs.Quests:AddParagraph({
        Title = "Active Quest Status",
        Content = "Collecting Red Pollen: 45%"
    })


    -- 4. BOTANIST: Planters
    Tabs.Botanist:AddDropdown("CycleMode", {
        Title = "Cycle Mode",
        Values = {"Nectar Priority", "Ticket Priority"},
        Default = 1,
        Callback = function(Value)
            print("[UI] Planter Mode: ", Value)
            if Planters and Planters.set_cycle_mode then Planters.set_cycle_mode(Value) end
        end
    })

    Tabs.Botanist:AddToggle("SmartSoil", {
        Title = "Smart Soil (Field Degradation)",
        Default = true,
        Callback = function(Value)
            print("[UI] Smart Soil: ", Value)
            if Planters and Planters.toggle_smart_soil then Planters.toggle_smart_soil(Value) end
        end
    })


    -- 5. ARTIFACTS: Dispensers
    local Dispensers = {"Samovar", "Glue Dispenser", "Coconut Dispenser", "Blueberry Dispenser", "Strawberry Dispenser", "Onett's Lid Art"}
    for _, disp in ipairs(Dispensers) do
        Tabs.Artifacts:AddToggle(disp, {
            Title = disp,
            Default = true,
            Callback = function(Value)
                 print("[UI] Toggle Dispenser " .. disp .. ": ", Value)
                 if Toys and Toys.toggle_dispenser then Toys.toggle_dispenser(disp, Value) end
            end
        })
    end

    Tabs.Artifacts:AddToggle("MacroSync", {
        Title = "Macro-Sync",
        Description = "Collect only when path-adjacent.",
        Default = true,
        Callback = function(Value)
            print("[UI] Macro-Sync: ", Value)
            if Toys and Toys.toggle_macro_sync then Toys.toggle_macro_sync(Value) end
        end
    })


    -- 6. NEXUS: Webhook & Config
    Tabs.Nexus:AddInput("WebhookURL", {
        Title = "Discord Webhook URL",
        Default = "",
        Placeholder = "https://discord.com/api/webhooks/...",
        Numeric = false,
        Finished = true,
        Callback = function(Value)
            print("[UI] Webhook Updated")
            if Webhook and Webhook.set_url then Webhook.set_url(Value) end
        end
    })

    Tabs.Nexus:AddToggle("HourlyGraphs", {
        Title = "Hourly Graphs (Flex Mode)",
        Default = false,
        Callback = function(Value)
            print("[UI] Hourly Graphs: ", Value)
            if Webhook and Webhook.toggle_graphs then Webhook.toggle_graphs(Value) end
        end
    })

    Tabs.Nexus:AddToggle("AnonymousMode", {
        Title = "Anonymous Mode",
        Default = false,
        Callback = function(Value)
            print("[UI] Anonymous Mode: ", Value)
            if Webhook and Webhook.toggle_anonymous then Webhook.toggle_anonymous(Value) end
        end
    })

    Window:SelectTab(1)
    Fluent:Notify({
        Title = "Aegis Ultimate",
        Content = "Swarm Protocol Online. Welcome, User.",
        Duration = 5
    })
end

return Dashboard
