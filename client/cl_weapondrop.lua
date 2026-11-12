-- Drops your equipped weapon on the ground when you die (ox_inventory)

if not Utils.enabled('weaponDrop') then return end

local currentWeapon ---@type table?
local dropped = false

AddEventHandler('ox_inventory:currentWeapon', function(weapon)
    currentWeapon = weapon
end)

-- Allow another drop once the player is back up
local function waitForRevive()
    CreateThread(function()
        while IsEntityDead(cache.ped) or Utils.isIncapacitated(cache.ped) do
            Wait(1000)
        end
        dropped = false
    end)
end

AddEventHandler('gameEventTriggered', function(name, data)
    if name ~= 'CEventNetworkEntityDamage' then return end
    if dropped or not currentWeapon then return end

    local ped = cache.ped
    if data[1] ~= ped or not IsEntityDead(ped) then return end

    -- Damage events can fire several times for one death; only drop once
    dropped = true

    local weaponObject = GetWeaponObjectFromPed(ped, false)
    if weaponObject ~= 0 then DeleteEntity(weaponObject) end

    TriggerServerEvent('gldnrmz-smallresources:server:dropWeapon', currentWeapon.slot, GetWeapontypeModel(currentWeapon.hash))
    currentWeapon = nil
    waitForRevive()
end)
