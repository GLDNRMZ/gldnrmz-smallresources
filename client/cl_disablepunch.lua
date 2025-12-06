-- Disable Punch Controls
-- Disables melee inputs to prevent spam punching, allowing punches only when targetting

if not (Config and Config.features and Config.features.disablePunch) then return end

local function startMonitor()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(250)
    end

    CreateThread(function()
        while true do
            local ped = PlayerPedId()
            if ped ~= 0 then
                -- Only affect on-foot players to avoid interfering with vehicles/other states
                if IsPedOnFoot(ped) and not IsEntityDead(ped) then
                    -- Disable light melee
                    DisableControlAction(0, 140, true)
                    -- Disable heavy and alternate melee when not targetting
                    if not IsPlayerTargettingAnything(PlayerId()) then
                        DisableControlAction(0, 141, true)
                        DisableControlAction(0, 142, true)
                    end
                end
            end
            Wait(0)
        end
    end)
end

AddEventHandler('QBCore:Client:OnPlayerLoaded', startMonitor)
AddEventHandler('playerSpawned', startMonitor)
if NetworkIsPlayerActive(PlayerId()) then
    startMonitor()
end