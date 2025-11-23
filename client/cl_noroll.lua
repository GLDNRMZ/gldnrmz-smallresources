if not (Config and Config.features and Config.features.noRoll) then return end

local function checkCombatRoll()
    CreateThread(function()
        while cache.weapon do    
            if GetIsTaskActive(cache.ped, 3) then
                SetPedToRagdoll(cache.ped, 3000, 3000, 0, 0, 0, 0)
            end         
            Wait(100)
        end
    end)
end

lib.onCache('weapon', function(val)
    if not val then return end
    checkCombatRoll()
end)