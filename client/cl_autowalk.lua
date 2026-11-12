-- /autowalk: your character wanders like an AI ped until you move or something interrupts it

if not Utils.enabled('autowalk') then return end

-- Sprint, jump, attack, aim, W, S, A, D
local CANCEL_CONTROLS = { 21, 22, 24, 25, 32, 33, 34, 35 }

local active = false

local function stop()
    if not active then return end
    active = false
    ClearPedTasks(cache.ped)
end

local function shouldCancel(ped)
    if not IsPedOnFoot(ped) or IsPedSwimming(ped) or IsPedRagdoll(ped) or Utils.isIncapacitated(ped) then
        return true
    end

    for i = 1, #CANCEL_CONTROLS do
        if IsControlPressed(0, CANCEL_CONTROLS[i]) then return true end
    end

    return false
end

local function start()
    local ped = cache.ped
    if not IsPedOnFoot(ped) or Utils.isIncapacitated(ped) then
        return Utils.notify('You can\'t do that right now.', 'error')
    end

    active = true
    TaskWanderStandard(ped, 10.0, 10)

    CreateThread(function()
        -- Give the player a moment to release the keys used to type the command
        Wait(500)
        while active do
            if cache.ped ~= ped or shouldCancel(ped) then
                stop()
                break
            end
            Wait(50)
        end
    end)
end

Utils.registerCommand('autoWalk', 'Toggle auto walk', function()
    if active then stop() else start() end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == cache.resource then stop() end
end)
