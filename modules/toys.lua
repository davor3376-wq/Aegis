--[[
    Swarm Protocol - Toys Module (Bot-09)
    Global Cooldown Registry for Dispensers.
]]

local Toys = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Registry of Dispensers and their cooldown timestamps (os.time() + seconds)
local DispenserRegistry = {
    ["Samovar"] = { NextUse = 0, Location = Vector3.new(50, 5, 50), Enabled = true },
    ["Glue Dispenser"] = { NextUse = 0, Location = Vector3.new(60, 20, 60), Enabled = true },
    ["Coconut Dispenser"] = { NextUse = 1726000000, Location = Vector3.new(500, 15, 300), Enabled = true }, -- Future time
    ["Blueberry Dispenser"] = { NextUse = 0, Location = Vector3.new(100, 5, 100), Enabled = true },
    ["Strawberry Dispenser"] = { NextUse = 0, Location = Vector3.new(120, 5, 120), Enabled = true },
    ["Onett's Lid Art"] = { NextUse = 1726000000, Location = Vector3.new(300, 30, 300), Enabled = true }
}

local MacroSyncEnabled = true

-- UI API Hooks
function Toys.toggle_dispenser(dispenser_name, bool_state)
    if DispenserRegistry[dispenser_name] then
        DispenserRegistry[dispenser_name].Enabled = bool_state
        print("[Bot-09 Monitor]: Toggled " .. dispenser_name .. " to " .. tostring(bool_state))
    else
        warn("[Bot-09 Monitor]: Dispenser " .. tostring(dispenser_name) .. " not found.")
    end
end

function Toys.get_cooldown(dispenser_name)
    local data = DispenserRegistry[dispenser_name]
    if not data then return "UNKNOWN" end

    if os.time() >= data.NextUse then
        return "READY"
    else
        local diff = data.NextUse - os.time()
        local minutes = math.floor(diff / 60)
        local seconds = diff % 60
        return string.format("%02d:%02d", minutes, seconds)
    end
end

function Toys.toggle_macro_sync(bool_state)
    MacroSyncEnabled = bool_state
    print("[Bot-09 Monitor]: Macro-Sync set to " .. tostring(bool_state))
end

function Toys.check_cooldowns(navigator)
    print("[Bot-09 Monitor]: Checking Global Cooldowns (Sync: " .. tostring(MacroSyncEnabled) .. ")...")
    local current_time = os.time()

    for name, data in pairs(DispenserRegistry) do
        if data.Enabled then
            if current_time >= data.NextUse then
                print("[Bot-09 Monitor]: " .. name .. " is READY. Teleporting...")
                if navigator then
                    navigator.pathfind(data.Location)
                    -- Interaction logic would go here
                    print("[Bot-09 Monitor]: Collected " .. name)
                    -- Update cooldown
                    data.NextUse = current_time + 3600 -- Mock 1 hour cooldown
                else
                     warn("[Bot-09 Monitor]: Navigator not available.")
                end
            else
                -- local remaining = data.NextUse - current_time
                -- print("[Bot-09 Monitor]: " .. name .. " on cooldown for " .. remaining .. "s.")
            end
        else
            print("[Bot-09 Monitor]: " .. name .. " disabled.")
        end
    end
end

return Toys
