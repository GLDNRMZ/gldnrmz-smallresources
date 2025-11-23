RegisterNetEvent('dropYourFuckingGun', function(slot, hash)
    local src = source
    if type(slot) == 'number' then
        local item = exports.ox_inventory:GetSlot(source, slot)
        local success = exports.ox_inventory:RemoveItem(src, item.name, item.count, nil, item.slot)
        if success then
            exports.ox_inventory:CustomDrop('Drop', {
                { item.name, item.count, item.metadata }
            }, GetEntityCoords(GetPlayerPed(src)), 1, 10000, nil, hash or `prop_med_bag_01b`)
        end
    end
end)