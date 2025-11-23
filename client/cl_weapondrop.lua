if not (Config and Config.features and Config.features.weaponDropClient) then return end

local CurrentWeapon = {}

AddEventHandler('ox_inventory:currentWeapon', function(currentWeapon)
    CurrentWeapon = currentWeapon
end)

AddEventHandler('gameEventTriggered', function(event, data)
    if event == 'CEventNetworkEntityDamage' then
        if data[1] == cache.ped and IsEntityDead(cache.ped) then
            if CurrentWeapon then
                DeleteEntity(GetWeaponObjectFromPed(cache.ped))
                local hash = GetWeapontypeModel(CurrentWeapon.hash)
                TriggerServerEvent('dropYourFuckingGun', CurrentWeapon.slot, hash)
            end
        end
    end
end)