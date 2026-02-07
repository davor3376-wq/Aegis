--[[
    Swarm Protocol - Farming Module (Bot-06/Legs)
    Handles Field Farming, Pattern Interpretation, and Token Collection.
]]

local Farming = {}
local Manifest = require(script.Parent.Manifest) -- The Brain
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- State
local State = {
    IsFarming = false,
    CurrentField = "Sunflower Field",
    CurrentPattern = "Snake",
    TokenPriorities = {}, -- Populated from Manifest or UI
    SproutSniper = false
}

-- Mock Sprout Detection
local function check_for_sprouts()
    -- In a real execution, this would check workspace.Particles or UI
    -- For now, we return nil unless manually triggered
    return nil
end

-- Pattern Logic
local Patterns = {}

function Patterns.Snake(center, size, step_index)
    -- Zig-zag pattern
    -- Scale step based on field size
    local width = size.X / 2
    local height = size.Z / 2
    local step_size = 5 -- studs

    local x = (step_index % (width * 2)) - width
    local z = math.floor(step_index / width) * step_size

    -- Wrap Z to stay in field
    z = (z % (height * 2)) - height

    return center + Vector3.new(x, 0, z)
end

function Patterns.SuperSpiral(center, size, step_index)
    local angle = step_index * 0.5
    local radius = (step_index * 0.2) % (size.X / 2)
    return center + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
end

function Patterns.E_lol(center, size, step_index)
    -- "E_lol" optimized square pattern
    -- Moves in a square, then cuts across
    local limit = size.X / 2
    local phase = step_index % 40

    if phase < 10 then -- Right
        return center + Vector3.new((phase - 5) * (limit/5), 0, -limit)
    elseif phase < 20 then -- Down
        return center + Vector3.new(limit, 0, (phase - 15) * (limit/5))
    elseif phase < 30 then -- Left
        return center + Vector3.new((25 - phase) * (limit/5), 0, limit)
    else -- Up
        return center + Vector3.new(-limit, 0, (35 - phase) * (limit/5))
    end
end

-- Public API

function Farming.set_field(field_name)
    if Manifest.Fields[field_name] then
        State.CurrentField = field_name
        print("[Bot-06 Farming]: Field set to " .. field_name)
    else
        warn("[Bot-06 Farming]: Invalid field name: " .. tostring(field_name))
    end
end

function Farming.set_pattern(pattern_name)
    if Patterns[pattern_name] or pattern_name == "Snake" then -- Default fallback
        State.CurrentPattern = pattern_name
        print("[Bot-06 Farming]: Pattern set to " .. pattern_name)
    else
         print("[Bot-06 Farming]: Unknown pattern " .. pattern_name .. ", defaulting to Snake.")
         State.CurrentPattern = "Snake"
    end
end

function Farming.set_token_priority(priority_list)
    State.TokenPriorities = priority_list
    print("[Bot-06 Farming]: Token priorities updated (" .. #priority_list .. " items).")
end

function Farming.toggle_sprout_sniper(bool_state)
    State.SproutSniper = bool_state
    print("[Bot-06 Farming]: Sprout Sniper: " .. tostring(bool_state))
end

function Farming.start_autofarm()
    if State.IsFarming then return end
    State.IsFarming = true
    print("[Bot-06 Farming]: Starting Autofarm in " .. State.CurrentField .. " with " .. State.CurrentPattern)

    task.spawn(function()
        local step = 0
        while State.IsFarming do
            -- 1. Sprout Sniper Override
            if State.SproutSniper then
                local sprout_pos = check_for_sprouts()
                if sprout_pos then
                    print("[Bot-06 Farming]: Sprout detected! Diverting...")
                    Humanoid:MoveTo(sprout_pos)
                    task.wait(1)
                    continue
                end
            end

            -- 2. Pattern Movement
            local field_data = Manifest.Fields[State.CurrentField]
            if field_data then
                local target_pos = Vector3.new(0,0,0)

                if State.CurrentPattern == "Snake" then
                    target_pos = Patterns.Snake(field_data.Center, field_data.Size, step)
                elseif State.CurrentPattern == "Super-Spiral" then
                    target_pos = Patterns.SuperSpiral(field_data.Center, field_data.Size, step)
                elseif State.CurrentPattern == "E_lol" then
                    target_pos = Patterns.E_lol(field_data.Center, field_data.Size, step)
                else
                     target_pos = Patterns.Snake(field_data.Center, field_data.Size, step)
                end

                -- Move
                Humanoid:MoveTo(target_pos)

                -- Check for priority tokens nearby (Mock logic)
                -- In real script: loop workspace.Collectibles, check .Name vs State.TokenPriorities

                step = step + 1
            else
                warn("[Bot-06 Farming]: Current field data missing!")
                State.IsFarming = false
            end

            task.wait(0.1) -- Loop speed
        end
        print("[Bot-06 Farming]: Autofarm stopped.")
    end)
end

function Farming.stop_autofarm()
    State.IsFarming = false
end

return Farming
