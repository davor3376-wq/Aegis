--[[
    Swarm Protocol - Planters Module (Bot-06)
    Intelligent Nectar & Quest Management.
]]

local Planters = {}

-- Mock Quest Data
local ActiveQuest = {
    Type = "Collect Pollen",
    Color = "Red",
    Amount = 1000000
}

-- Mock Planter Inventory
local Inventory = {
    ["Red Clay Planter"] = true,
    ["Plastic Planter"] = true
}

-- Active Planters in Fields
local ActivePlanters = {
    {
        Type = "Plastic Planter",
        Field = "Sunflower Field",
        Progress = 0.50, -- 50%
        NectarType = "Invigorating",
        TimeLeft = 3600 -- Seconds
    }
}

-- Settings
local CycleMode = "Nectar Priority" -- Default
local SmartSoilEnabled = true

-- UI API Hooks
function Planters.set_cycle_mode(mode_string)
    CycleMode = mode_string
    print("[Bot-06 Harvester]: Cycle Mode set to " .. mode_string)
end

function Planters.toggle_smart_soil(bool_state)
    SmartSoilEnabled = bool_state
    print("[Bot-06 Harvester]: Smart Soil set to " .. tostring(bool_state))
end

function Planters.get_active_planters()
    -- Format for UI display
    local ui_data = {}
    for _, planter in pairs(ActivePlanters) do
        table.insert(ui_data, {
            Name = planter.Type,
            Field = planter.Field,
            Progress = math.floor(planter.Progress * 100) .. "%"
        })
    end
    return ui_data
end

function Planters.check_quest_synergy()
    print("[Bot-06 Harvester]: Checking Quest Synergy...")
    if ActiveQuest.Color == "Red" and Inventory["Red Clay Planter"] then
        print("[Bot-06 Harvester]: Synergy Found! Suggesting Red Clay Planter in Red Field (e.g., Strawberry/Rose/Pepper).")
        -- Logic to plant would execute here
        return "Red Clay Planter"
    end
    return nil
end

function Planters.monitor_growth()
    print("[Bot-06 Harvester]: Monitoring Planter Growth (Mode: " .. CycleMode .. ")...")
    for _, planter in pairs(ActivePlanters) do
        local percent = planter.Progress * 100
        print("[Bot-06 Harvester]: " .. planter.Type .. " in " .. planter.Field .. " is at " .. percent .. "%.")

        if planter.Progress >= 1.0 then
             print("[Bot-06 Harvester]: Harvesting " .. planter.Type .. " (100% Growth).")
             -- Harvest logic
        elseif planter.Progress >= 0.8 and planter.NectarType == "Critical" and CycleMode == "Nectar Priority" then
            -- Placeholder logic for critical nectar
             print("[Bot-06 Harvester]: Emergency Harvest - " .. planter.Type .. " (Nectar Critical).")
        end
    end
end

return Planters
