-- Allows players to shoot each other while in the same vehicle by manipulating relationship groups

-- Feature toggle: allow disabling this client script safely
if type(Config) == 'table' and Config.features and not Config.features.vehicleCombat then
    return
end

-- Enabling shooting between players in the same vehicle (no console prints)

local config = {
    -- Internal defaults; these values are now handled purely in the client and not from config.lua
    updateInterval = 500,      -- How often to check for occupant changes (ms)
    hostileRelationship = 255, -- Relationship level to set when players share a vehicle
    neutralRelationship = 1,   -- Relationship level to reset to when players exit vehicle
}

local ped = PlayerPedId()

-- Set hostile relationships between all players
local function setRelationships()
    -- Setting hostile relationships
    for _, playerId in ipairs(GetActivePlayers()) do
        local otherPed = GetPlayerPed(playerId)
        if otherPed ~= ped then
            -- THIS IS THE KEY!
            -- From my tests, setting relationship group to 3+ allows shooting other players in the same vehicle
            -- I'm using 255 (Pedestrians) which seems to work fine
            SetRelationshipBetweenGroups(
                config.hostileRelationship,
                GetPedRelationshipGroupHash(ped),
                GetPedRelationshipGroupHash(otherPed)
            )
            SetRelationshipBetweenGroups(
            config.hostileRelationship,
                GetPedRelationshipGroupHash(otherPed),
                GetPedRelationshipGroupHash(ped)
            )
        end
    end
end

-- Reset relationships to neutral
-- If we don't reset these, then players will always try to drag/smack the driver out
local function resetRelationships()
    -- Resetting relationships to neutral
    for _, playerId in ipairs(GetActivePlayers()) do
        local otherPed = GetPlayerPed(playerId)
        if otherPed ~= ped then
            SetRelationshipBetweenGroups(
                config.neutralRelationship,
                GetPedRelationshipGroupHash(ped),
                GetPedRelationshipGroupHash(otherPed)
            )
            SetRelationshipBetweenGroups(
                config.neutralRelationship,
                GetPedRelationshipGroupHash(otherPed),
                GetPedRelationshipGroupHash(ped)
            )
        end
    end
end

-- Get all current occupants of the vehicle the player is in
---@return table -- A table of player IDs currently in the vehicle
local function getVehOccupants()
    local currentVehicle = GetVehiclePedIsIn(ped, false)

    if not currentVehicle or currentVehicle == 0 then
        return {}
    end

    local currentOccupants = {}
    for seat = -1, GetVehicleModelNumberOfSeats(GetEntityModel(currentVehicle)) - 2 do
        local occupant = GetPedInVehicleSeat(currentVehicle, seat)
        if occupant and occupant ~= 0 and IsEntityAPed(occupant) and IsPedAPlayer(occupant) then
            local playerId = NetworkGetPlayerIndexFromPed(occupant)
            if playerId and playerId ~= -1 then
                currentOccupants[playerId] = true
            end
        end
    end

    return currentOccupants
end

-- Helper function to compare occupant tables
---@return boolean -- Returns true if occupants have changed
local function occupantsChanged(current, last)
    local currentCount, lastCount = 0, 0
    for _ in pairs(current) do currentCount = currentCount + 1 end
    for _ in pairs(last) do lastCount = lastCount + 1 end

    if currentCount ~= lastCount then
        return true
    end

    for playerId in pairs(current) do
        if not last[playerId] then
            return true
        end
    end

    return false
end

-- Monitor vehicle entry/exit and occupant changes
-- I wish there was a better way to do this...
-- I tried using ox_lib's onCache for vehicle,
-- but it only triggers for the individual client, not when others enter their vehicle
CreateThread(function()
    local lastOccupants = {}
    local inVehicle = false

    while true do
        local currentVehicle = GetVehiclePedIsIn(ped, false)
        local currentlyInVehicle = currentVehicle and currentVehicle ~= 0

        if currentlyInVehicle then
            if not inVehicle then
                -- Entered vehicle
                inVehicle = true
            end

            local currentOccupants = getVehOccupants()

            if occupantsChanged(currentOccupants, lastOccupants) then
                -- occupants changed, update relationships
                setRelationships()
                lastOccupants = currentOccupants
            end

            Wait(config.updateInterval)
        else
            -- Exited vehicle
            if inVehicle then
                -- Exited vehicle
                resetRelationships()
                inVehicle = false
                lastOccupants = {}
            end

            Wait(1000)
        end
    end
end)

-- Cleanup: Reset relationships
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        resetRelationships()
    end
end)