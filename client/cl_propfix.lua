-- /propfix: removes props stuck to your character and stops your current animation

if not Utils.enabled('propStuck') then return end

local CONTROL_TIMEOUT = 500 -- ms to wait for network control of each prop

---@param entity number
---@return boolean deleted
local function deleteEntity(entity)
    if NetworkGetEntityIsNetworked(entity) and not NetworkHasControlOfEntity(entity) then
        local deadline = GetGameTimer() + CONTROL_TIMEOUT
        NetworkRequestControlOfEntity(entity)
        while not NetworkHasControlOfEntity(entity) and GetGameTimer() < deadline do
            Wait(0)
            NetworkRequestControlOfEntity(entity)
        end
    end

    DetachEntity(entity, true, true)
    SetEntityAsMissionEntity(entity, true, true)
    DeleteEntity(entity)

    return not DoesEntityExist(entity)
end

---@param ped number
---@return integer removed, integer failed
local function clearAttachedProps(ped)
    local removed, failed = 0, 0
    local objects = GetGamePool('CObject')

    for i = 1, #objects do
        local obj = objects[i]
        if DoesEntityExist(obj) and IsEntityAttachedToEntity(obj, ped) then
            if deleteEntity(obj) then
                removed += 1
            else
                failed += 1
            end
        end
    end

    return removed, failed
end

local running = false

Utils.registerCommand('propStuck', 'Remove props stuck to your character', function()
    if running then return end

    local ped = cache.ped
    if cache.vehicle then
        return Utils.notify('You can\'t use this in a vehicle.', 'error', 'Prop Fix')
    end
    if Utils.isIncapacitated(ped) then
        return Utils.notify('You can\'t use this right now.', 'error', 'Prop Fix')
    end

    running = true
    ClearPedSecondaryTask(ped)
    ClearPedTasks(ped)

    local removed, failed = clearAttachedProps(ped)
    running = false

    if removed == 0 and failed == 0 then
        Utils.notify('Nothing was attached to you.', 'inform', 'Prop Fix')
    elseif failed > 0 then
        Utils.notify(('Removed %d prop(s), %d could not be removed.'):format(removed, failed), 'warning', 'Prop Fix')
    else
        Utils.notify(('Removed %d prop(s).'):format(removed), 'success', 'Prop Fix')
    end
end)
