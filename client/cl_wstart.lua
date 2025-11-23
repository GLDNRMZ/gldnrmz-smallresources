if not (Config and Config.features and Config.features.wStart) then return end

-- Press W to start engine when seated in driver seat and engine is off
CreateThread(function()
   while true do
       Wait(0)
       local ped = PlayerPedId()
       if IsPedInAnyVehicle(ped, false) then
           local vehicle = GetVehiclePedIsIn(ped, false)
           if GetPedInVehicleSeat(vehicle, -1) == ped then
               local isEngineRunning = GetIsVehicleEngineRunning(vehicle)
               if not isEngineRunning then
                   -- Pressing W (accelerate) will start the engine
                   if IsControlJustPressed(0, 71) then
                       SetVehicleEngineOn(vehicle, true, true, false)
                       SetVehicleUndriveable(vehicle, false)
                   end
               end
           end
       end
   end
end)