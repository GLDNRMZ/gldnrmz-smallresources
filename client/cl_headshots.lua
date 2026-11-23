-- Stops headshots from being an instant kill and makes them deal a fixed amount of damage,
-- so it always takes Config.headshots.shotsToKill headshots to kill a player at full health.

if not Utils.enabled('headshots') then return end

local cfg = Config.headshots

-- Health/armor as of the previous frame = the values right before a hit landed
local lastHealth, lastArmor = 0, 0
local lastHitTime, lastHitWeapon = 0, 0

CreateThread(function()
    while true do
        local ped = cache.ped
        -- Re-applied every frame: the ped handle changes on respawn / model change
        SetPedSuffersCriticalHits(ped, false)
        lastHealth = GetEntityHealth(ped)
        lastArmor = GetPedArmour(ped)
        Wait(0)
    end
end)

local function shotsToKill(weapon)
    return cfg.weaponOverrides[weapon] or cfg.shotsToKill
end

AddEventHandler('gameEventTriggered', function(name, args)
    if name ~= 'CEventNetworkEntityDamage' then return end

    local ped = cache.ped
    local victim, weapon = args[1], args[7]
    if victim ~= ped or IsEntityDead(ped) then return end

    local hit, bone = GetPedLastDamageBone(ped)
    if not hit or not cfg.headBones[bone] then return end
    ClearPedLastDamageBone(ped)

    local now = GetGameTimer()
    if weapon == lastHitWeapon and now - lastHitTime < cfg.hitCooldown then
        -- Extra pellet from the same blast: undo whatever damage it did
        SetEntityHealth(ped, lastHealth)
        if cfg.ignoreArmor then SetPedArmour(ped, lastArmor) end
        return
    end
    lastHitTime, lastHitWeapon = now, weapon

    -- Fixed damage per headshot so N shots always drain a full health bar
    local pool = GetEntityMaxHealth(ped) - cfg.deathHealth
    local damage = math.ceil(pool / shotsToKill(weapon))

    if cfg.ignoreArmor then
        SetPedArmour(ped, lastArmor)
    else
        local absorbed = math.min(lastArmor, damage)
        SetPedArmour(ped, lastArmor - absorbed)
        damage = damage - absorbed
    end

    local newHealth = lastHealth - damage
    SetEntityHealth(ped, newHealth <= cfg.deathHealth and 0 or newHealth)
    Utils.debug(('Headshot (%s): %d -> %d health'):format(weapon, lastHealth, GetEntityHealth(ped)))

    lastHealth = GetEntityHealth(ped)
    lastArmor = GetPedArmour(ped)
end)
