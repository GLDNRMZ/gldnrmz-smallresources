-- Blocks melee attacks unless the player is locked on to a target

if not Utils.enabled('disablePunch') then return end

local MELEE_LIGHT, MELEE_HEAVY, MELEE_ALTERNATE = 140, 141, 142

CreateThread(function()
    while true do
        local ped = cache.ped
        if IsPedOnFoot(ped) and not IsEntityDead(ped) then
            DisableControlAction(0, MELEE_LIGHT, true)
            if not IsPlayerTargettingAnything(cache.playerId) then
                DisableControlAction(0, MELEE_HEAVY, true)
                DisableControlAction(0, MELEE_ALTERNATE, true)
            end
            Wait(0)
        else
            Wait(500)
        end
    end
end)
