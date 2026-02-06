--[[
    Swarm Protocol - Webhook Module (Bot-08)
    Remote Monitoring via Discord Webhooks.
]]

local Webhook = {}
local HttpService = game:GetService("HttpService")

-- Placeholder Config
local WEBHOOK_URL = "https://discord.com/api/webhooks/PLACEHOLDER_ID/PLACEHOLDER_TOKEN"
local LOG_INTERVAL = 3600 -- 60 Minutes

local last_log_time = 0

function Webhook.send_log(honey_per_hour, current_quest, next_boss)
    if os.time() - last_log_time < LOG_INTERVAL then
        return
    end

    print("[Bot-08 Interface]: Preparing Remote Log...")

    local payload = {
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "Swarm Protocol Status Report",
            ["description"] = "Hourly Performance Log",
            ["color"] = 16766720, -- Honey Gold
            ["fields"] = {
                {
                    ["name"] = "Honey/Hr",
                    ["value"] = tostring(honey_per_hour),
                    ["inline"] = true
                },
                {
                    ["name"] = "Current Quest",
                    ["value"] = tostring(current_quest),
                    ["inline"] = true
                },
                {
                    ["name"] = "Next Boss Spawn",
                    ["value"] = tostring(next_boss),
                    ["inline"] = false
                }
            },
            ["footer"] = {
                ["text"] = "Swarm Protocol - Bot-08"
            }
        }}
    }

    local success, result = pcall(function()
        local json_payload = HttpService:JSONEncode(payload)
        -- Using 'request' (standard exploit function) if available, falling back or mocking
        if request then
            return request({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = json_payload
            })
        else
            print("[Bot-08 Interface]: 'request' function not found (Studio/Standard Client). Mocking send.")
            return {StatusCode = 204}
        end
    end)

    if success then
        print("[Bot-08 Interface]: Log Sent Successfully.")
        last_log_time = os.time()
    else
        warn("[Bot-08 Interface]: Failed to send log: " .. tostring(result))
    end
end

return Webhook
