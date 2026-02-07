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

-- Apply Custom Theme Colors (Dark Matter)
-- Fluent usually handles themes internally, but we can override if supported or via preset.
-- Assuming "Dark" is close, and accents are handled by the library's options.

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
            if Navigator then Navigator.set_smart_field(Value) end
        end
    })

    Tabs.Overlord:AddDropdown("GatherPattern", {
        Title = "Gather Pattern",
        Values = {"Elian's Snake", "Super-Spiral", "Corner-X"},
        Multi = false,
        Default = 1,
        Callback = function(Value)
            print("[UI] Pattern Set: ", Value)
            if Navigator then Navigator.set_pattern(Value) end
        end
    })

    Tabs.Overlord:AddToggle("SproutSniper", {
        Title = "Sprout Sniper",
        Description = "Bot-05 (Aviator) abandons farm for Sprouts.",
        Default = false,
        Callback = function(Value)
            print("[UI] Sprout Sniper: ", Value)
            if Aviator then Aviator.toggle_sprout_sniper(Value) end
        end
    })

    -- 2. SLAYER: Live Boss Buttons
    local BossToggles = {}
    BossToggles["Tunnel Bear"] = Tabs.Slayer:AddToggle("TunnelBear", { Title = "Tunnel Bear (Loading...)", Default = false })
    BossToggles["King Beetle"] = Tabs.Slayer:AddToggle("KingBeetle", { Title = "King Beetle (Loading...)", Default = false })

    -- Logic to update button text based on Combat module
    task.spawn(function()
        while true do
            if Combat and Combat.get_boss_status then
                local status = Combat.get_boss_status("Tunnel Bear")
                BossToggles["Tunnel Bear"]:SetTitle("Tunnel Bear (" .. status .. ")")
                -- Color logic would be handled by library if supported, or text color rich text

                status = Combat.get_boss_status("King Beetle")
                BossToggles["King Beetle"]:SetTitle("King Beetle (" .. status .. ")")
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
            -- if Combat then Combat.toggle_smart_mask(Value) end
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
        -- Visual Progress Bar (Placeholder)
        Tabs.Quests:AddParagraph({
            Title = "Progress: " .. npc,
            Content = "Collecting Red Pollen: 45%" -- This would update dynamically
        })
    end


    -- 4. BOTANIST: Planters
    Tabs.Botanist:AddDropdown("CycleMode", {
        Title = "Cycle Mode",
        Values = {"Nectar Priority", "Ticket Priority"},
        Default = 1,
        Callback = function(Value)
            print("[UI] Planter Mode: ", Value)
            if Planters then Planters.set_cycle_mode(Value) end
        end
    })

    Tabs.Botanist:AddToggle("SmartSoil", {
        Title = "Smart Soil (Field Degradation)",
        Default = true,
        Callback = function(Value)
            print("[UI] Smart Soil: ", Value)
            if Planters then Planters.toggle_smart_soil(Value) end
        end
    })


    -- 5. ARTIFACTS: Dispensers
    local Dispensers = {"Samovar", "Glue", "Treats", "Onett's Art", "Stockings"}
    for _, disp in ipairs(Dispensers) do
        Tabs.Artifacts:AddToggle(disp, {
            Title = disp,
            Default = true
        })
    end

    Tabs.Artifacts:AddToggle("MacroSync", {
        Title = "Macro-Sync",
        Description = "Collect only when path-adjacent.",
        Default = true,
        Callback = function(Value)
            print("[UI] Macro-Sync: ", Value)
            if Toys then Toys.toggle_macro_sync(Value) end
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
            if Webhook then Webhook.set_url(Value) end
        end
    })

    Tabs.Nexus:AddToggle("HourlyGraphs", {
        Title = "Hourly Graphs (Flex Mode)",
        Default = false,
        Callback = function(Value)
            print("[UI] Hourly Graphs: ", Value)
            if Webhook then Webhook.toggle_graphs(Value) end
        end
    })

    Tabs.Nexus:AddToggle("AnonymousMode", {
        Title = "Anonymous Mode",
        Default = false,
        Callback = function(Value)
            print("[UI] Anonymous Mode: ", Value)
            if Webhook then Webhook.toggle_anonymous(Value) end
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
