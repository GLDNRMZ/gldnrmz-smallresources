-- Gives a chance to ragdoll when jumping while running, to discourage bunny hopping

if not Utils.enabled('jumpSpam') then return end

local cfg = Config.jumpSpam

local function isRunningJump(ped)
    return IsPedJumping(ped)
        and (IsPedRunning(ped) or IsPedSprinting(ped))
        and IsPedOnFoot(ped)
        and not IsPedSwimming(ped)
        and not IsPedClimbing(ped)
        and not IsPedRagdoll(ped)
        and not IsEntityDead(ped)
end

CreateThread(function()
    while true do
        local ped = cache.ped
        if isRunningJump(ped) then
            if math.random() < cfg.chance then
                Wait(600) -- let the jump play out before falling over
                if not IsPedRagdoll(ped) and not IsEntityDead(ped) then
                    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
                    SetPedToRagdoll(ped, cfg.ragdollTime, cfg.ragdollTime, 0, false, false, false)
                end
            end
            -- A jump lasts long enough to be sampled several times; skip past it
            Wait(2000)
        else
            Wait(100)
        end
    end
end)
