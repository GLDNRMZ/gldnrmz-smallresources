-- Plays a map-reading animation while the pause menu is open

if not Utils.enabled('pauseMap') then return end

local DICT, ANIM = 'amb@world_human_tourist_map@male@idle_b', 'idle_d'
local PROP_MODEL = `p_tourist_map_01_s`
local PROP_BONE = 28422

local active = false
local prop ---@type number?

local function canPlay(ped)
    return IsPedOnFoot(ped)
        and not IsPedRagdoll(ped)
        and not IsPedFalling(ped)
        and not IsPedSwimming(ped)
        and not IsPedUsingAnyScenario(ped)
        and not Utils.isIncapacitated(ped)
end

local function deleteProp()
    if prop and DoesEntityExist(prop) then
        DeleteEntity(prop)
    end
    prop = nil
end

local function stop()
    if not active then return end
    active = false

    local ped = cache.ped
    -- Only stop our own animation instead of clearing every task on the ped
    if IsEntityPlayingAnim(ped, DICT, ANIM, 3) then
        StopAnimTask(ped, DICT, ANIM, 2.0)
    end
    deleteProp()
    RemoveAnimDict(DICT)
end

local function start()
    local ped = cache.ped
    if not canPlay(ped) then return end
    if not Utils.requestAnimDict(DICT) or not Utils.requestModel(PROP_MODEL) then return end

    active = true

    local coords = GetEntityCoords(ped)
    prop = CreateObject(PROP_MODEL, coords.x, coords.y, coords.z + 0.2, true, true, false)
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, PROP_BONE), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(PROP_MODEL)

    TaskPlayAnim(ped, DICT, ANIM, 2.0, 8.0, -1, 53, 0, false, false, false)
end

CreateThread(function()
    while true do
        local paused = IsPauseMenuActive()
        if paused and not active then
            start()
        elseif not paused and active then
            stop()
        end
        Wait(250)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == cache.resource then stop() end
end)
