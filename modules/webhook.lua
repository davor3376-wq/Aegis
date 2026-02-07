--[[
    Swarm Protocol - Webhook Module (Bot-08/Voice)
    Handles Discord Logging, Analytics, and Configuration Saving.
]]

local Webhook = {}
local HttpService = game:GetService("HttpService")
local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

-- State
local WebhookURL = ""
local Settings = {
    Enabled = true,
    SendPlanters = true,
    SendItems = true,
    SendQuests = true,
    SendGraph = false,
    Anonymous = false
}

-- Screenshot Logic (Mock)
local function capture_screenshot()
    print("[Bot-08 Webhook]: 📸 SCREENSHOT CAPTURED (Rare Drop Detected) 📸")
    -- In real execution: rconsoleprint("SCREENSHOT SAVED\n")
end

-- Public API

function Webhook.set_url(url)
    WebhookURL = url
    print("[Bot-08 Webhook]: URL Updated.")
end

function Webhook.send_message(data)
    if not Settings.Enabled or not WebhookURL or WebhookURL == "" then return end

    -- Check Granularity
    if data.Type == "Planter" and not Settings.SendPlanters then return end
    if data.Type == "Item" and not Settings.SendItems then return end
    if data.Type == "Quest" and not Settings.SendQuests then return end

    -- Check Rare Drops
    if data.Items then
        for _, item in ipairs(data.Items) do
            if item == "Mythic Egg" or item == "Star Treat" then
                capture_screenshot()
                data.Content = "@everyone RARE DROP DETECTED: " .. item
            end
        end
    end

    local payload = {
        content = data.Content or "",
        embeds = {
            {
                title = data.Title or "Aegis Ultimate Notification",
                description = data.Description or "No description provided.",
                color = data.Color or 0x3b82f6,
                fields = data.Fields or {},
                footer = {
                    text = "Swarm Protocol v1.0"
                }
            }
        }
    }

    if Settings.Anonymous then
        payload.username = "Aegis Bot (Hidden)"
    else
        payload.username = "Aegis Bot - " .. game.Players.LocalPlayer.Name
    end

    local success, response = pcall(function()
        return request({
            Url = WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(payload)
        })
    end)

    if success then
        -- print("[Bot-08 Webhook]: Sent successfully.")
    else
        warn("[Bot-08 Webhook]: Failed to send - " .. tostring(response))
    end
end

-- Toggles
function Webhook.toggle_send_planters(bool_state)
    Settings.SendPlanters = bool_state
    print("[Bot-08 Webhook]: Send Planters: " .. tostring(bool_state))
end

function Webhook.toggle_send_items(bool_state)
    Settings.SendItems = bool_state
    print("[Bot-08 Webhook]: Send Items: " .. tostring(bool_state))
end

function Webhook.toggle_send_quests(bool_state)
    Settings.SendQuests = bool_state
    print("[Bot-08 Webhook]: Send Quests: " .. tostring(bool_state))
end

function Webhook.toggle_graphs(bool_state)
    Settings.SendGraph = bool_state
    print("[Bot-08 Webhook]: Hourly Graphs: " .. tostring(bool_state))
end

function Webhook.toggle_anonymous(bool_state)
    Settings.Anonymous = bool_state
    print("[Bot-08 Webhook]: Anonymous Mode: " .. tostring(bool_state))
end

return Webhook
