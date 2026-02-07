--[[
    Swarm Protocol - Planters Module (Bot-06/Hands)
    Intelligent Nectar & Quest Management.
]]

local Planters = {}
local Manifest = require(script.Parent.Manifest) -- The Brain

-- State
local ActivePlanters = {
    -- { Type = "Plastic Planter", Field = "Sunflower Field", Progress = 0.50, NectarType = "Invigorating" }
}

-- Settings
local CycleMode = "Nectar Priority" -- "Nectar Priority" or "Ticket Priority"
local SmartSoilEnabled = true

-- Helper: Check Field Pollen Levels (Mock)
local function get_field_pollen_percent(field_name)
    -- In real script, check game.Workspace.FlowerZones[field_name].Flowers
    return 0.8 -- Mock: 80% Pollen
end

-- Nectar Optimizer
function Planters.get_best_field_for_nectar(nectar_type)
    local best_field = nil
    local best_multiplier = 0

    for field_name, data in pairs(Manifest.Fields) do
        local mult = data.Nectar[nectar_type] or 0
        if mult > best_multiplier then
            best_multiplier = mult
            best_field = field_name
        end
    end

    print("[Bot-06 Planters]: Best field for " .. nectar_type .. " is " .. tostring(best_field) .. " (x" .. best_multiplier .. ")")
    return best_field
end

-- Planter Actions
function Planters.plant_planter(planter_name, field_name)
    -- Check Soil
    if SmartSoilEnabled then
        local pollen = get_field_pollen_percent(field_name)
        if pollen < 0.3 then
             warn("[Bot-06 Planters]: Skipped planting " .. planter_name .. " in " .. field_name .. " (Pollen too low: " .. pollen .. ")")
             return
        end
    end

    print("[Bot-06 Planters]: Planting " .. planter_name .. " in " .. field_name)
    -- Interaction logic (Equip planter, move to field, click)
    -- Update ActivePlanters
    table.insert(ActivePlanters, {
        Type = planter_name,
        Field = field_name,
        Progress = 0,
        NectarType = Manifest.Planters[planter_name].Nectar
    })
end

function Planters.harvest_planter(index)
    local planter = ActivePlanters[index]
    if not planter then return end

    print("[Bot-06 Planters]: Harvesting " .. planter.Type .. " from " .. planter.Field)
    -- Move to field, interact

    table.remove(ActivePlanters, index)
end

-- Loop Logic
function Planters.monitor_growth()
    for i, planter in ipairs(ActivePlanters) do
        planter.Progress = planter.Progress + 0.1 -- Mock Growth

        if planter.Progress >= 1.0 then
             Planters.harvest_planter(i)
        end
    end
end

-- UI API Hooks
function Planters.set_cycle_mode(mode_string)
    CycleMode = mode_string
    print("[Bot-06 Planters]: Cycle Mode set to " .. mode_string)
end

function Planters.toggle_smart_soil(bool_state)
    SmartSoilEnabled = bool_state
    print("[Bot-06 Planters]: Smart Soil set to " .. tostring(bool_state))
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

return Planters
