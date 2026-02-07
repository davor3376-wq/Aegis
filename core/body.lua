--[[
    Swarm Protocol - Body Logic (The Core)
    Target: Delta Executor (Roblox Luau)
    Handles Physics, Pathfinding, and Flight.
]]

local Body = {}
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Bot-03 (Strategist): Console Output
local function log_thought(thought)
    print("[Bot-03 Strategist]: " .. thought)
end

-- Bot-05 (Aviator): Flight Logic
local Aviator = {}
Aviator.SAFETY_Y_LEVEL = 35
local SproutSniperEnabled = false

function Aviator.vertical_bypass()
    log_thought("Obstacle detected. Initiating Vertical Bypass.")

    local bodyVelocity = Instance.new("BodyVelocity")
    -- Ensure we fly up to at least SAFETY_Y_LEVEL
    local targetY = math.max(HumanoidRootPart.Position.Y + 20, Aviator.SAFETY_Y_LEVEL)
    local velocityY = 50

    bodyVelocity.Velocity = Vector3.new(0, velocityY, 0)
    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
    bodyVelocity.Parent = HumanoidRootPart

    -- Hold height until we reach Safety Shield level
    while HumanoidRootPart.Position.Y < Aviator.SAFETY_Y_LEVEL do
        task.wait()
    end

    log_thought("Safety Shield reached (Y=" .. tostring(Aviator.SAFETY_Y_LEVEL) .. ").")
    task.wait(0.5) -- Stabilize

    bodyVelocity:Destroy()
    log_thought("Vertical Bypass complete.")
end

function Aviator.toggle_sprout_sniper(bool_state)
    SproutSniperEnabled = bool_state
    log_thought("Sprout Sniper toggled to: " .. tostring(bool_state))
end

-- Bot-04 (Navigator): Pathfinding Logic
local Navigator = {}

function Navigator.raycast_check(direction)
    local rayOrigin = HumanoidRootPart.Position
    local rayDirection = direction * 5 -- Check 5 studs ahead

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local raycastResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)

    if raycastResult then
        log_thought("Raycast hit: " .. raycastResult.Instance.Name)
        return true -- Obstacle detected
    end
    return false
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
    method = method or "Walk" -- Default
    log_thought("Navigating to target: " .. tostring(target_position) .. " (Method: " .. method .. ")")

    if method == "Tween" then
        Navigator.tween_to(target_position)
        return
    end

    -- Walk Method
    local reached = false
    while not reached do
        local current_pos = HumanoidRootPart.Position
        local direction = (target_position - current_pos).Unit
        local distance = (target_position - current_pos).Magnitude

        if distance < 2 then
            reached = true
            break
        end

        if Navigator.raycast_check(direction) then
            Aviator.vertical_bypass()
        else
            Humanoid:MoveTo(target_position)
        end

        task.wait(0.1)
    end
    log_thought("Destination reached.")
end

-- UI API Hooks
function Navigator.set_smart_field(field_name)
    -- Handled by Farming module mainly, but Navigator stores context if needed
    log_thought("Target Field context updated to: " .. field_name)
end

function Navigator.set_pattern(pattern_name)
    -- Handled by Farming module
    log_thought("Gather Pattern context updated to: " .. pattern_name)
end

-- Expose modules
Body.Navigator = Navigator
Body.Aviator = Aviator

return Body
