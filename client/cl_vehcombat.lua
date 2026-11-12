-- Lets players shoot each other while sharing a vehicle.
-- GTA blocks this between "friendly" relationship groups, so while you're in a vehicle the
-- relationship between your group and the other occupants' groups is set to hostile.
-- The original values are restored when you get out.

if not Utils.enabled('vehicleCombat') then return end

local HOSTILE = 255 -- tested value that allows same-vehicle shooting
local interval = Config.vehicleCombat.interval

---@type table<string, { a: number, b: number, original: number }>
local changed = {}
local currentVehicle

local function makeHostile(a, b)
    local key = a .. ':' .. b
    if not changed[key] then
        changed[key] = { a = a, b = b, original = GetRelationshipBetweenGroups(a, b) }
    end
    -- Re-applied every check in case another script reset it
    SetRelationshipBetweenGroups(HOSTILE, a, b)
end

local function restoreAll()
    for key, entry in pairs(changed) do
        SetRelationshipBetweenGroups(entry.original, entry.a, entry.b)
        changed[key] = nil
    end
end

local function updateOccupants(vehicle)
    local ped = cache.ped
    local myGroup = GetPedRelationshipGroupHash(ped)

    for seat = -1, GetVehicleMaxNumberOfPassengers(vehicle) - 1 do
        local occupant = GetPedInVehicleSeat(vehicle, seat)
        if occupant ~= 0 and occupant ~= ped and IsPedAPlayer(occupant) then
            local theirGroup = GetPedRelationshipGroupHash(occupant)
            makeHostile(myGroup, theirGroup)
            makeHostile(theirGroup, myGroup)
        end
    end
end

---@param vehicle number|false
local function onVehicle(vehicle)
    currentVehicle = vehicle
    if not vehicle then
        -- Restoring matters: hostile groups make players yank each other out when entering vehicles
        restoreAll()
        return
    end

    CreateThread(function()
        while currentVehicle == vehicle and DoesEntityExist(vehicle) do
            updateOccupants(vehicle)
            Wait(interval)
        end
    end)
end

lib.onCache('vehicle', onVehicle)
if cache.vehicle then onVehicle(cache.vehicle) end

AddEventHandler('onResourceStop', function(resource)
    if resource == cache.resource then restoreAll() end
end)
