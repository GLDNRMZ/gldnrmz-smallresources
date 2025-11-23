-- Global configuration for gldnrmz-smallresources

Config = {}
-- Optional debug prints
Config.debug = false
-- Feature toggles so you can safely restart this resource without impacting other systems
Config.features = {
    -- Commands / UI (client/server)
    playerInfo = true,         -- /info player info menu (ox_lib) and server info export/callback

    -- Client gameplay tweaks (per-file)
    vehicleCombat = true,      -- Allow shooting players in same vehicle
    noHelmet = true,           -- Prevent auto helmet when on motorcycle
    noVehWeapons = true,       -- Disable vehicle-mounted weapons
    pauseMap = true,           -- Play map animation when pause menu is active
    look = true,               -- Look at closest talking player
    leap = true,               -- Enable leap keybind (R)
    trafficLights = false,      -- Freeze traffic/street light props
    noRoll = false,             -- Prevent combat roll (ragdoll if detected)
    weaponDropClient = false,   -- Drop current weapon on death (client event bridge)
    wStart = false,             -- Press W to start car engine (driver seat only)

    -- Server-side features (per-file)
    saveArmor = true,          -- Save/restore player armor on unload/load
}