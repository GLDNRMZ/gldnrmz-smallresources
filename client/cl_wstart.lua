-- Press W in the driver seat to start the engine. Only runs while you're the driver.

if not Utils.enabled('wStart') then return end

local ACCELERATE = 71
local canStart = Config.wStart.canStart

local watching = false

local function isDriver(vehicle)
    return vehicle and cache.vehicle == vehicle and GetPedInVehicleSeat(vehicle, -1) == cache.ped
end

---@param vehicle number
local function watch(vehicle)
    if watching then return end
    watching = true

    CreateThread(function()
        while isDriver(vehicle) do
            if GetIsVehicleEngineRunning(vehicle) then
                Wait(250)
            else
                if IsControlJustPressed(0, ACCELERATE)
                    and GetVehicleEngineHealth(vehicle) > 0
                    and canStart(vehicle) then
                    SetVehicleEngineOn(vehicle, true, true, false)
                end
                Wait(0)
            end
        end
        watching = false
    end)
end

-- cache.seat changes on every seat swap; cache.vehicle updates just after it, so wait a tick
lib.onCache('seat', function(seat)
    if seat ~= -1 then return end
    SetTimeout(0, function()
        if cache.vehicle then watch(cache.vehicle) end
    end)
end)

if cache.vehicle and cache.seat == -1 then watch(cache.vehicle) end
