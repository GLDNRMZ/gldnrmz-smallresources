-- gldnrmz-smallresources server side
-- Keep minimal and safe so the resource can restart without affecting the city

local resourceName = GetCurrentResourceName()

local function isResourceActive(name)
    local state = GetResourceState(name)
    return state == 'started' or state == 'starting'
end

local function safeGetPlayer(src)
    if not isResourceActive('qb-core') then return nil end
    local ok, player = pcall(function() return exports['qb-core']:GetPlayer(src) end)
    if not ok then return nil end
    return player
end

-- Health check / ping to confirm server script loaded
RegisterCommand('gsr_ping', function(source)
    if source ~= 0 then
        TriggerClientEvent('chat:addMessage', source, {
            color = {0, 255, 100},
            multiline = false,
            args = {'SmallResources', 'Server script is loaded and responding.'}
        })
    end
end, true)

-- Notify on resource start/stop for visibility and dependency hints
AddEventHandler('onResourceStart', function(res)
    if res == resourceName then
        if not isResourceActive('qb-core') then
            -- qb-core not active
        end
        if not isResourceActive('ox_lib') then
            -- ox_lib not active
        end
        if Config and Config.features then
            -- Features: playerInfo available via config; no console prints
        end
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res == resourceName then
        -- stopped (server)
    end
end)

-- Core info builder used by export and callback
local function buildPlayerInfo(src)
    local xPlayer = safeGetPlayer(src)
    if not xPlayer then return nil end

    local job = xPlayer.PlayerData.job or {}
    local gang = xPlayer.PlayerData.gang or {}

    return {
        name = (xPlayer.PlayerData.charinfo and xPlayer.PlayerData.charinfo.firstname .. ' ' .. xPlayer.PlayerData.charinfo.lastname) or 'Unknown',
        cid = xPlayer.PlayerData.citizenid,
        job = job.label or job.name,
        jobGrade = (job.grade and job.grade.name) or tostring(job.grade and job.grade.level),
        gang = gang.label or gang.name,
        gangGrade = (gang.grade and gang.grade.name) or tostring(gang.grade and gang.grade.level),
    }
end

-- Only register info features when enabled in config
if Config and Config.features and Config.features.playerInfo then
    -- Export so other resources can retrieve player info safely
    exports('GetPlayerInfo', function(src)
        return buildPlayerInfo(src)
    end)

    -- Server callback for client usage (guarded if ox_lib is missing)
    if lib and lib.callback and lib.callback.register then
        lib.callback.register('gldnrmz:server:getPlayerInfo', function(source)
            return buildPlayerInfo(source)
        end)
    else
        -- ox_lib callback API not available on server; skipping lib.callback.register
    end
else
    -- playerInfo feature disabled in config; server export/callback not registered
end