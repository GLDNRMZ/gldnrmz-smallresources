-- Clear props stuck to the player's body via a client command

-- Feature toggle: allow disabling this client script safely
if not (Config and Config.features and Config.features.propStuck) then return end

local function tryDeleteEntity(entity)
    if not DoesEntityExist(entity) then return false end

    -- Attempt to gain network control briefly
    NetworkRequestControlOfEntity(entity)
    local start = GetGameTimer()
    while not NetworkHasControlOfEntity(entity) and (GetGameTimer() - start) < 500 do
        Wait(0)
        NetworkRequestControlOfEntity(entity)
    end

    -- Detach and delete
    DetachEntity(entity, true, true)
    SetEntityAsMissionEntity(entity, true, true)
    DeleteEntity(entity)

    return not DoesEntityExist(entity)
end

local function clearAttachedPropsForPed(ped)
    local removed = 0
    for _, obj in ipairs(GetGamePool('CObject')) do
        if DoesEntityExist(obj) and IsEntityAttachedToEntity(obj, ped) then
            if tryDeleteEntity(obj) then
                removed = removed + 1
            end
        end
    end
    return removed
end

-- /propfix: clears props attached to your ped and stops current animations
local cmdPropFixName = (Config and Config.commands and Config.commands.propStuck and Config.commands.propStuck.command) or 'propfix'
local cmdPropFixEnabled = not (Config and Config.commands and Config.commands.propStuck and Config.commands.propStuck.enabled == false)

if cmdPropFixEnabled then
RegisterCommand(cmdPropFixName, function()
    local ped = PlayerPedId()

    -- Stop animations and immediate tasks to avoid re-attaching props
    ClearPedSecondaryTask(ped)
    ClearPedTasksImmediately(ped)

    local count = clearAttachedPropsForPed(ped)

end, false)
end