-- Ragdolls players who combat roll while holding a weapon

if not Utils.enabled('noRoll') then return end

local COMBAT_ROLL_TASK = 3
local ragdollTime = Config.noRoll.ragdollTime

local armed, watching = false, false

local function watch()
    if watching then return end
    watching = true

    CreateThread(function()
        while armed do
            local ped = cache.ped
            if GetIsTaskActive(ped, COMBAT_ROLL_TASK) and not IsPedRagdoll(ped) then
                SetPedToRagdoll(ped, ragdollTime, ragdollTime, 0, false, false, false)
            end
            Wait(100)
        end
        watching = false
    end)
end

-- onCache fires before cache.weapon updates, so track the value ourselves
lib.onCache('weapon', function(weapon)
    armed = weapon ~= nil and weapon ~= false
    if armed then watch() end
end)

if cache.weapon then
    armed = true
    watch()
end
