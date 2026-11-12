-- Turns your head toward the closest nearby player who is talking

if not Utils.enabled('look') then return end

local maxDistance = Config.look.distance
local lookingAt ---@type number? ped we are currently looking at

local function clearLook()
    if not lookingAt then return end
    TaskClearLookAt(cache.ped)
    lookingAt = nil
end

---@return number? ped
local function findClosestTalker(ped, coords)
    if IsPedShooting(ped) or IsPlayerFreeAiming(cache.playerId) then return end

    local players = lib.getNearbyPlayers(coords, maxDistance, false)
    local bestPed, bestDist

    for i = 1, #players do
        local player = players[i]
        if MumbleIsPlayerTalking(player.id) then
            local dist = #(coords - player.coords)
            if not bestDist or dist < bestDist then
                bestPed, bestDist = player.ped, dist
            end
        end
    end

    return bestPed
end

CreateThread(function()
    while true do
        local ped = cache.ped
        local target = findClosestTalker(ped, GetEntityCoords(ped))

        if target ~= lookingAt then
            if target then
                TaskLookAtEntity(ped, target, -1, 2048, 3)
                lookingAt = target
                Utils.debug('Looking at ped', target)
            else
                clearLook()
            end
        end

        Wait(lookingAt and 250 or 500)
    end
end)

-- A new ped (respawn, model change) starts without a look-at task
lib.onCache('ped', function() lookingAt = nil end)

AddEventHandler('onResourceStop', function(resource)
    if resource == cache.resource then clearLook() end
end)
