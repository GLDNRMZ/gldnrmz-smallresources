-- Server half of the weapon drop feature (needs ox_inventory for world drops)

if not Config.features.weaponDrop then return end

if GetResourceState('ox_inventory') == 'missing' then
    print('^3[gldnrmz-smallresources]^0 weaponDrop needs ox_inventory and has been disabled.')
    return
end

local cfg = Config.weaponDrop
local nextAllowed = {} ---@type table<number, number>

RegisterNetEvent('gldnrmz-smallresources:server:dropWeapon', function(slot, model)
    local src = source --[[@as number]]
    if type(slot) ~= 'number' then return end

    -- Cooldown stops a modified client from spamming drops
    local now = os.time()
    if (nextAllowed[src] or 0) > now then return end
    nextAllowed[src] = now + cfg.cooldown

    local item = exports.ox_inventory:GetSlot(src, slot)
    -- Only weapons can be dropped through this event
    if not item or type(item.name) ~= 'string' or not item.name:upper():find('^WEAPON_') then return end

    local ped = GetPlayerPed(src)
    if ped == 0 then return end
    local coords = GetEntityCoords(ped)

    if not exports.ox_inventory:RemoveItem(src, item.name, item.count, nil, item.slot) then return end

    exports.ox_inventory:CustomDrop('Weapon', {
        { item.name, item.count, item.metadata },
    }, coords, 1, 10000, nil, type(model) == 'number' and model ~= 0 and model or cfg.fallbackModel)
end)

AddEventHandler('playerDropped', function()
    nextAllowed[source] = nil
end)
