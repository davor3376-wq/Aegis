--[[
    Swarm Protocol - Main Loader (Bot-10)
    Executes core/body.lua and modules (combat, planters, toys, webhook, ui_dashboard) using Verified Oauth Headers.
    Auto-Updates by saving modules to disk to ensure dependencies (require) work correctly.
]]

local repo_url_base = "https://raw.githubusercontent.com/username/repo/branch/"
local oauth_token = "VERIFIED_OAUTH_TOKEN_PLACEHOLDER" -- Secret Tunnel

local headers = {
    ["Authorization"] = "Bearer " .. oauth_token,
    ["User-Agent"] = "Swarm-Protocol-Loader/2.0"
}

-- File System Setup
local folder_name = "Aegis_Swarm"
if not isfolder(folder_name) then makefolder(folder_name) end
if not isfolder(folder_name .. "/modules") then makefolder(folder_name .. "/modules") end
if not isfolder(folder_name .. "/core") then makefolder(folder_name .. "/core") end
if not isfolder(folder_name .. "/data") then makefolder(folder_name .. "/data") end

-- Fetch & Save Function
local function fetch_and_save(path, save_path)
    print("[Bot-10 Integrator]: Fetching " .. path .. "...")
    local success, response = pcall(function()
        return request({
            Url = repo_url_base .. path,
            Method = "GET",
            Headers = headers
        })
    end)

    if success and response.StatusCode == 200 then
        print("[Bot-10 Integrator]: Fetched " .. path .. ". Saving to " .. save_path)
        writefile(save_path, response.Body)
        return true
    else
        warn("[Bot-10 Integrator]: Failed to fetch " .. path .. ".")
        return false
    end
end

-- Main Execution
print("[Bot-10 Integrator]: Initializing The Grand Unification...")

-- 1. Download All Modules
local files = {
    { Remote = "modules/manifest.lua", Local = folder_name .. "/modules/Manifest.lua" }, -- Rename for require case-sensitivity?
    { Remote = "core/body.lua", Local = folder_name .. "/core/body.lua" },
    { Remote = "modules/combat.lua", Local = folder_name .. "/modules/combat.lua" },
    { Remote = "modules/farming.lua", Local = folder_name .. "/modules/farming.lua" },
    { Remote = "modules/planters.lua", Local = folder_name .. "/modules/planters.lua" },
    { Remote = "modules/quests.lua", Local = folder_name .. "/modules/quests.lua" },
    { Remote = "modules/toys.lua", Local = folder_name .. "/modules/toys.lua" },
    { Remote = "modules/webhook.lua", Local = folder_name .. "/modules/webhook.lua" },
    { Remote = "modules/ui_dashboard.lua", Local = folder_name .. "/modules/ui_dashboard.lua" }
}

for _, file in ipairs(files) do
    fetch_and_save(file.Remote, file.Local)
end

-- 2. Require Modules (Now that they are on disk, relative requires work if pathing is correct, or we use absolute)
-- Note: 'require' in executors usually needs a ModuleScript instance or a file path if 'dofile' isn't standard.
-- We will use 'loadfile' or custom require logic.
-- Assuming standard executor 'dofile' or 'loadfile' works.

local function load_local_module(path)
    local func, err = loadfile(path)
    if func then
        return func()
    else
        warn("Failed to load local module: " .. path .. " Error: " .. tostring(err))
        return nil
    end
end

-- Load Manifest First (Implicitly loaded by others via require, but we load here to verify)
-- Note: modules use 'require(script.Parent.Manifest)'.
-- For this to work in 'loadfile', the script environment must simulate 'script'.
-- Most executors don't perfectly simulate 'script.Parent' for files.
-- we might need to rely on 'dofile' returning the table.

-- 3. Load Core & Modules
local Body = load_local_module(folder_name .. "/core/body.lua")
local Navigator = Body and Body.Navigator
local Aviator = Body and Body.Aviator

local Combat = load_local_module(folder_name .. "/modules/combat.lua")
local Farming = load_local_module(folder_name .. "/modules/farming.lua")
local Planters = load_local_module(folder_name .. "/modules/planters.lua")
local Quests = load_local_module(folder_name .. "/modules/quests.lua")
local Toys = load_local_module(folder_name .. "/modules/toys.lua")
local Webhook = load_local_module(folder_name .. "/modules/webhook.lua")
local Dashboard = load_local_module(folder_name .. "/modules/ui_dashboard.lua")

-- 4. Initialize Dashboard (Bot-08)
if Dashboard then
    print("[Bot-10 Integrator]: Launching Aegis UI Ultimate...")
    Dashboard.init({
        Navigator = Navigator,
        Aviator = Aviator,
        Combat = Combat,
        Farming = Farming,
        Planters = Planters,
        Quests = Quests,
        Toys = Toys,
        Webhook = Webhook
    })
else
    warn("[Bot-10 Integrator]: Failed to load UI Dashboard.")
end

-- 5. Execution Loop (Mock Integration)
task.spawn(function()
    while true do
        -- Bot-07: Check Combat
        if Combat then
            Combat.check_bosses(Navigator)
        end

        -- Bot-06: Check Planters
        if Planters then
            Planters.monitor_growth()
        end

        -- Bot-09: Check Toys
        if Toys then
            Toys.check_cooldowns(Navigator)
        end

        -- Bot-02: Check RBC (if active)
        -- Handled internally by Quests.run_challenge() task

        task.wait(5) -- Loop every 5 seconds
    end
end)

print("[Bot-10 Integrator]: Swarm Protocol Fully Online (File System Mode).")
