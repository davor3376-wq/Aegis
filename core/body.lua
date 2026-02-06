--[[
    Swarm Protocol - Body Logic
    Drafted by: Bot-04 (Navigator) & Bot-05 (Aviator)
    Target: Delta Executor (Roblox Luau)
]]

local Body = {}
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Bot-03 (Strategist): Console Output
local function log_thought(thought)
    -- Option A: Console Only
    print("[Bot-03 Strategist]: " .. thought)
end

-- Bot-05 (Aviator): Flight Logic
local Aviator = {}

-- Safety Shield Locked Y-Level
Aviator.SAFETY_Y_LEVEL = 35

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

    -- Maintain Height logic (Safety Shield) could go here
    log_thought("Safety Shield reached (Y=" .. tostring(Aviator.SAFETY_Y_LEVEL) .. ").")

    task.wait(0.5) -- Stabilize

    bodyVelocity:Destroy()
    log_thought("Vertical Bypass complete.")
end

-- Bot-04 (Navigator): Pathfinding Logic
local Navigator = {}

-- Temporary Test Destination (Honey Bee NPC)
Navigator.TEST_DESTINATION = Vector3.new(100, 5, 100)

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

function Navigator.loot_divert()
    -- Placeholder: Scan for high-value items within radius
    -- In a real scenario, this would iterate through a folder of drops
    local high_value_found = false

    -- Example logic (commented out as specific game object structure is unknown)
    -- for _, item in pairs(Workspace.Drops:GetChildren()) do
    --     if item.Name == "DiamondEgg" and (item.Position - HumanoidRootPart.Position).Magnitude < 20 then
    --         high_value_found = true
    --         break
    --     end
    -- end

    if high_value_found then
        log_thought("Loot-Divert triggered! deviating path.")
        -- Logic to move towards loot would go here
        return true
    end
    return false
end

function Navigator.pathfind(target_position)
    target_position = target_position or Navigator.TEST_DESTINATION
    log_thought("Navigating to target: " .. tostring(target_position))

    local reached = false
    while not reached do
        local current_pos = HumanoidRootPart.Position
        local direction = (target_position - current_pos).Unit
        local distance = (target_position - current_pos).Magnitude

        if distance < 2 then
            reached = true
            break
        end

        -- Check for Loot Divert
        if Navigator.loot_divert() then
            -- Pause main pathfinding for loot (simplified)
            task.wait(1)
        end

        -- Check for Obstacles
        if Navigator.raycast_check(direction) then
            Aviator.vertical_bypass()
        else
            -- Move forward
            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + (direction * 0.5)
        end

        task.wait() -- Yield for next frame
    end

    log_thought("Destination reached.")
end

-- Expose modules
Body.Navigator = Navigator
Body.Aviator = Aviator

return Body
