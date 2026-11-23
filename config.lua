Config = {}

Config.debug = false        -- Print debug messages to the F8 / server console
Config.versionCheck = true  -- Check GitHub for a newer version on start

-- Every feature can be switched off on its own. Restart the resource after changing.
Config.features = {
    playerInfo    = true,   -- /info menu with your IDs, job and gang
    autowalk      = true,   -- /autowalk makes your character wander like an AI ped
    vehicleCombat = true,   -- Lets players shoot each other inside the same vehicle
    noHelmet      = true,   -- Stops the automatic motorcycle helmet (qbx_smallresources has the same feature)
    noVehWeapons  = true,   -- Disables vehicle-mounted weapons
    pauseMap      = true,   -- Plays a map-reading animation while the pause menu is open
    look          = true,   -- Your head turns toward the closest player who is talking
    leap          = true,   -- Sprint + G to dive/slide
    trafficLights = false,  -- Makes traffic light props frozen and unbreakable
    noRoll        = false,  -- Ragdolls players who combat roll while armed
    weaponDrop    = false,  -- Drops your equipped weapon on the ground when you die (needs ox_inventory)
    wStart        = false,  -- Press W in the driver seat to start the engine
    propStuck     = true,   -- /propfix removes props stuck to your character
    jumpSpam      = true,   -- Chance to ragdoll when jumping while running
    disablePunch  = true,  -- Blocks melee unless you are locked on to a target
    firstPerson   = true,   -- Forces first person while aiming (see Config.firstPerson)
    headshots     = false,  -- Headshots aren't one-shot kills; set how many it takes (see Config.headshots)
}

Config.commands = {
    playerInfo = { enabled = true, command = 'info' },
    autoWalk   = { enabled = true, command = 'autowalk' },
    propStuck  = { enabled = true, command = 'propfix' },
}

-- Feature settings ---------------------------------------------------------

Config.leap = {
    key = 'G',               -- Default key; players can rebind it in Settings > Key Bindings > FiveM
    requireSprint = true,    -- Only leap while holding Sprint
    cooldown = 3000,         -- ms between leaps
}

Config.look = {
    distance = 20.0,         -- How far away a talking player can be
}

Config.jumpSpam = {
    chance = 0.25,           -- 0.0 - 1.0 chance to ragdoll per running jump
    ragdollTime = 2500,      -- ms
}

Config.noRoll = {
    ragdollTime = 3000,      -- ms
}

Config.vehicleCombat = {
    interval = 500,          -- ms between occupant checks while in a vehicle
}

Config.trafficLights = {
    rescanDistance = 50.0,   -- Re-scan nearby props after moving this far
    rescanInterval = 15000,  -- ...or after this many ms, to catch props that streamed in
    models = {
        `prop_traffic_01a`,
        `prop_traffic_01b`,
        `prop_traffic_01d`,
    },
}

Config.firstPerson = {
    always = false,          -- First person at all times (ignores the options below)
    onFootAiming = false,    -- First person while aiming on foot
    vehicleAiming = true,    -- First person while aiming inside a vehicle
    bikeAiming = true,       -- First person while aiming on a bike or motorcycle
    disarmOnEnter = true,    -- Holsters your weapon if you enter a vehicle while aiming
}

Config.headshots = {
    shotsToKill = 3,         -- Headshots to kill a player at full health
    weaponOverrides = {      -- Per-weapon shotsToKill; 1 keeps a weapon as a true one-shot
        -- [`WEAPON_PISTOL`]       = 4,
        -- [`WEAPON_COMBATPISTOL`] = 4,
        [`WEAPON_SNIPERRIFLE`]  = 1,
        [`WEAPON_HEAVYSNIPER`]  = 1,
    },
    ignoreArmor = true,      -- true: headshots skip armor. false: armor soaks them first
    deathHealth = 100,       -- Health at which a player counts as dead (100 on default player peds)
    hitCooldown = 60,        -- ms; extra head hits from the same weapon in this window are ignored (shotgun pellets)
    headBones = {            -- Bones that count as a headshot
        [31086] = true,      -- SKEL_Head
        [39317] = true,      -- SKEL_Neck_1
    },
}

Config.weaponDrop = {
    cooldown = 10,           -- Seconds a player must wait between drops (server-enforced)
    fallbackModel = `prop_med_bag_01b`,
}

Config.wStart = {
    -- Return false to block the engine from starting, e.g. to require keys.
    ---@param vehicle number
    ---@return boolean
    canStart = function(vehicle)
        return true
    end,
}
