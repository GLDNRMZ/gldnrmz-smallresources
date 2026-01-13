-- Global configuration for gldnrmz-smallresources

Config = {}
-- Optional debug prints
Config.debug = false
-- Feature toggles so you can safely restart this resource without impacting other systems
Config.features = {

    -- Client gameplay tweaks (per-file)
    playerInfo = true,        -- Enable player info command/menu
    autowalk = true,           -- Allow players to walk aimlessly like a ped
    vehicleCombat = true,      -- Allow shooting players in same vehicle
    noHelmet = true,           -- Prevent auto helmet when on motorcycle
    noVehWeapons = true,       -- Disable vehicle-mounted weapons
    pauseMap = true,           -- Play map animation when pause menu is active
    look = true,               -- Look at closest talking player
    leap = true,               -- Enable leap keybind (R)
    trafficLights = false,     -- Freeze traffic/street light props
    noRoll = false,            -- Prevent combat roll (ragdoll if detected)
    weaponDropClient = false,  -- Drop current weapon on death (client event bridge)
    wStart = false,            -- Press W to start car engine (driver seat only)
    propStuck = true,          -- Enable /propstuck command to clear attached props
    jumpSpam = true,           -- Ragdoll players to discourage jump spamming
    disablePunch = false,       -- Disable punch controls to prevent spam punching

    -- Server-side features (per-file)
    saveArmor = true,          -- Save/restore player armor on unload/load
}

-- Commands: names and enable flags
Config.commands = {
    playerInfo = {
        command = 'info',       -- /info player info menu (ox_lib) and server info export/callback
    },
    autoWalk = {
        command = 'autowalk',    
    },
    propStuck = {
        command = 'propfix',     
    },
}