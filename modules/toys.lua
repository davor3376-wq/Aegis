--[[
    Swarm Protocol - Toys Module (Bot-09)
    Global Cooldown Registry for Dispensers and Toys.
]]

local Toys = {}
local Manifest = require(script.Parent.Manifest) -- The Brain
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- State
local Registry = {}

-- Initialize Registry from Manifest
for name, data in pairs(Manifest.Toys) do
    Registry[name] = {
        NextUse = 0, -- Ready
        Enabled = true
    }
end

local MacroSyncEnabled = true

-- Interaction Logic
function Toys.interact_toy(toy_name)
    local toy_data = Manifest.Toys[toy_name]
    if not toy_data then return end

    local state = Registry[toy_name]
    if not state.Enabled then return end

    if os.time() >= state.NextUse then
        print("[Bot-09 Toys]: Interacting with " .. toy_name)

        -- Pathfind (Mock)
        HumanoidRootPart.CFrame = CFrame.new(toy_data.Coordinates)
        task.wait(1)

        -- Trigger Prompt (Mock)
        -- fireproximityprompt(workspace.Toys[toy_name].Prompt)

        print("[Bot-09 Toys]: Used " .. toy_name)
        state.NextUse = os.time() + toy_data.Cooldown
    else
        -- print("[Bot-09 Toys]: " .. toy_name .. " is on cooldown.")
    end
end

-- UI API Hooks
function Toys.toggle_dispenser(dispenser_name, bool_state)
    if Registry[dispenser_name] then
        Registry[dispenser_name].Enabled = bool_state
        print("[Bot-09 Toys]: Toggled " .. dispenser_name .. " to " .. tostring(bool_state))
    else
        warn("[Bot-09 Toys]: Dispenser " .. tostring(dispenser_name) .. " not found.")
    end
end

function Toys.get_cooldown(dispenser_name)
    local data = Registry[dispenser_name]
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
    print("[Bot-09 Toys]: Macro-Sync set to " .. tostring(bool_state))
end

function Toys.check_cooldowns(navigator)
    -- print("[Bot-09 Toys]: Checking Cooldowns...")

    for name, _ in pairs(Registry) do
        Toys.interact_toy(name)
    end
end

return Toys
