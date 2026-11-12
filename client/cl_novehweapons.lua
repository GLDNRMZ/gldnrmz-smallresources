-- Disables vehicle-mounted weapons. Only runs while you're in a vehicle that has weapons.

if not Utils.enabled('noVehWeapons') then return end

local currentVehicle

---@param vehicle number|false
local function onVehicle(vehicle)
    currentVehicle = vehicle
    if not vehicle or not DoesVehicleHaveWeapons(vehicle) then return end

    CreateThread(function()
        while currentVehicle == vehicle do
            local ped = cache.ped
            local hasWeapon, weaponHash = GetCurrentPedVehicleWeapon(ped)
            if hasWeapon and weaponHash ~= 0 then
                DisableVehicleWeapon(true, weaponHash, vehicle, ped)
            end
            Wait(0)
        end
    end)
end

lib.onCache('vehicle', onVehicle)
if cache.vehicle then onVehicle(cache.vehicle) end
