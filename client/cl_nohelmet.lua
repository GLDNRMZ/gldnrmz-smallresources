if type(Config) == 'table' and Config.features and not Config.features.noHelmet then
    return
end

lib.onCache('vehicle', function(value, oldValue)
    local isMotorcycle = GetVehicleClass(value) == 8
    if not isMotorcycle then return end

    SetPedHelmet(cache.ped, false)
    RemovePedHelmet(cache.ped, true)
end)