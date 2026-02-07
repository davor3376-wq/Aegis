--[[
    Swarm Protocol - Quests Module (Bot-02/Soul)
    Handles NPC Quests and Robo Bear Challenge (RBC).
]]

local Quests = {}
local Manifest = require(script.Parent.Manifest) -- The Brain
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- State
local RBC_Active = false
local RBC_Round = 0
local RBC_MaxRound = 25

-- NPC Logic
function Quests.auto_quest(npc_name)
    local npc_data = Manifest.NPCs[npc_name]
    if npc_data then
        print("[Bot-02 Quests]: Starting Auto-Quest for " .. npc_name)

        -- Pathfind to NPC (Mock call to Navigator logic)
        -- Ideally, we would call Navigator.move_to(npc_data.Coordinates)
        -- For now, we simulate the travel
        print("[Bot-02 Quests]: Traveling to " .. tostring(npc_data.Coordinates))
        task.wait(2) -- Travel time

        print("[Bot-02 Quests]: Interacting with " .. npc_name)
        -- FireProximityPrompt or ClickDetector logic would go here
        task.wait(1)

        print("[Bot-02 Quests]: Quest Accepted/Turned In.")
    else
        warn("[Bot-02 Quests]: NPC " .. npc_name .. " not found in Manifest.")
    end
end

-- Robo Bear Challenge (RBC) Logic
function Quests.reroll_digital_bee()
    -- Logic to check current bees offered in RBC
    local digital_bee_found = false -- Mock check

    if not digital_bee_found then
        print("[Bot-02 Quests]: Rerolling for Digital Bee...")
        -- FireRemote("RerollBees")
        task.wait(1)
    else
        print("[Bot-02 Quests]: Digital Bee found (or max rerolls reached).")
    end
end

function Quests.prioritize_gold_cogmowers()
    -- Logic to target Gold Cogmowers
    local gold_cogmower = nil -- Mock detection

    if gold_cogmower then
        print("[Bot-02 Quests]: Gold Cogmower detected! Prioritizing kill.")
        -- Combat.kill_mob("Gold Cogmower")
        return true
    end
    return false
end

function Quests.run_challenge()
    if RBC_Active then return end
    RBC_Active = true
    RBC_Round = 1

    print("[Bot-02 Quests]: Starting Robo Bear Challenge (Target: Round " .. RBC_MaxRound .. ")")

    task.spawn(function()
        while RBC_Active and RBC_Round <= RBC_MaxRound do
            print("[Bot-02 Quests]: RBC Round " .. RBC_Round .. " started.")

            -- 1. Bee Selection Phase
            Quests.reroll_digital_bee()

            -- 2. Quest Phase
            -- Mock Quest: "Collect Red Pollen"
            print("[Bot-02 Quests]: Selected Quest: Collect Red Pollen")

            local round_complete = false
            local timer = 0
            while not round_complete and timer < 60 do -- 60s timeout for mock
                if Quests.prioritize_gold_cogmowers() then
                    task.wait(2) -- Combat time
                else
                    -- Farm logic would run here
                    task.wait(1)
                end
                timer = timer + 1

                -- Mock completion
                if timer > 5 then round_complete = true end
            end

            print("[Bot-02 Quests]: Round " .. RBC_Round .. " Complete.")
            RBC_Round = RBC_Round + 1
            task.wait(2) -- Intermission
        end

        print("[Bot-02 Quests]: RBC Finished.")
        RBC_Active = false
    end)
end

function Quests.stop_challenge()
    RBC_Active = false
    print("[Bot-02 Quests]: RBC Stopped.")
end

return Quests
