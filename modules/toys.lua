--[[
    Swarm Protocol - Toys Module (Bot-09)
    Global Cooldown Registry for Dispensers.
]]

local Toys = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Registry of Dispensers and their cooldown timestamps (os.time() + seconds)
local DispenserRegistry = {
    ["Samovar"] = { NextUse = 0, Location = Vector3.new(50, 5, 50) },
    ["Glue Dispenser"] = { NextUse = 0, Location = Vector3.new(60, 20, 60) },
    ["Coconut Dispenser"] = { NextUse = 1726000000, Location = Vector3.new(500, 15, 300) }, -- Future time
    ["Blueberry Dispenser"] = { NextUse = 0, Location = Vector3.new(100, 5, 100) },
    ["Strawberry Dispenser"] = { NextUse = 0, Location = Vector3.new(120, 5, 120) },
    ["Onett's Lid Art"] = { NextUse = 1726000000, Location = Vector3.new(300, 30, 300) }
}

function Toys.check_cooldowns(navigator)
    print("[Bot-09 Monitor]: Checking Global Cooldowns...")
    local current_time = os.time()

    for name, data in pairs(DispenserRegistry) do
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
            local remaining = data.NextUse - current_time
            -- print("[Bot-09 Monitor]: " .. name .. " on cooldown for " .. remaining .. "s.")
        end
    end
end

return Toys
