-- Ragdoll players who jump while sprinting/running to discourage jump spamming

-- Feature toggle: allow disabling this client script safely
if not (Config and Config.features and Config.features.jumpSpam) then return end

-- Internal settings (tweak here if needed)
local ragdollChance = 0.25      -- 50% chance
local ragdollTime = 2500       -- milliseconds
local ragdollFlags = 1 + 2     -- normal ragdoll + stun

local function playerPed()
    return (cache and cache.ped) or PlayerPedId()
end

local function startJumpSpamMonitor()
    CreateThread(function()
        while true do
            Wait(100)
            local ped = playerPed()

            if IsPedOnFoot(ped)
                and not IsPedSwimming(ped)
                and (IsPedRunning(ped) or IsPedSprinting(ped))
                and not IsPedClimbing(ped)
                and IsPedJumping(ped)
                and not IsPedRagdoll(ped) then

                if math.random() < ragdollChance then
                    Wait(600)
                    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
                    -- Use consistent signature with other scripts: time1, time2, flags
                    SetPedToRagdoll(ped, ragdollTime, ragdollTime, ragdollFlags, 0, 0, 0)
                else
                    Wait(2000)
                end
            end
        end
    end)
end

-- Start once when player is active/loaded
local started = false
local function startOnce()
    if started then return end
    started = true
    startJumpSpamMonitor()
end

AddEventHandler('QBCore:Client:OnPlayerLoaded', startOnce)
AddEventHandler('playerSpawned', startOnce)
if NetworkIsPlayerActive(PlayerId()) then
    startOnce()
end