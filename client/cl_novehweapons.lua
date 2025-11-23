if type(Config) == 'table' and Config.features and not Config.features.noVehWeapons then
    return
end

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        local retval, weaponHash = GetCurrentPedVehicleWeapon(ped)
        if veh ~= 0 then
            if weaponHash ~= 0 then
                DisableVehicleWeapon(true, weaponHash, veh, ped)
            end
        end
    end
end)