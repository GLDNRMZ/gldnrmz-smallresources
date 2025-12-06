gldnrmz-smallresources

A collection of small, toggleable gameplay and utility scripts for FiveM/QBCore-based servers. Every feature is gated behind a config toggle, so the resource can be safely restarted or tailored to your preferences without impacting other systems.

Dependencies
- qb-core: Required for some server-side features (player info export/callback, player data access).
- qbx_core: Used to save/restore player armor metadata in sv_savearmor.lua.
- ox_lib: Recommended/optional. Powers the /info context menu and server callbacks.
- ox_inventory: Recommended/optional. Powers the server-side weapon drop logic.

Installation
1) Place this resource into your resources folder:
   [scripts]/[gldnrmz]/gldnrmz-smallresources
2) Ensure it in your server.cfg after qb-core/qbx_core and ox_lib:
   ensure qb-core
   ensure qbx_core
   ensure ox_lib
   ensure ox_inventory
   ensure gldnrmz-smallresources
3) Configure features and commands in config.lua. Restart the resource after changes.

Configuration (config.lua)
Features (client)
- playerInfo: Player info context menu (ox_lib)
- autowalk: Allow players to wander like an AI ped
- vehicleCombat: Allow shooting other players in the same vehicle
- noHelmet: Prevent auto-helmet when on motorcycle
- noVehWeapons: Disable vehicle-mounted weapons
- pauseMap: Play tourist map animation when pause menu is active
- look: Look at closest talking player
- leap: Enable leap keybind (R)
- trafficLights: Freeze traffic/street light props
- noRoll: Prevent combat roll (ragdoll if detected)
- weaponDropClient: Drop current weapon on death (client-side event bridge)
- wStart: Press W to start car engine (driver seat only)
- propStuck: Enable client command to clear props attached to your ped
- jumpSpam: Ragdoll on repeated jump spam to discourage bunnyhopping
- disablePunch: Disable melee punch controls to prevent spam punching

Features (server)
- saveArmor: Save armor on unload and restore on load via qbx_core metadata
- weaponDropServer: Handle weapon drop creation using ox_inventory

Commands (config)
- Commands are defined under `Config.commands` with `enabled` and `command` fields. Change names or disable per-command.
  - `playerInfo`: `{ enabled = true, command = 'info' }`
  - `autoWalk`: `{ enabled = true, command = 'autowalk' }`
  - `propStuck`: `{ enabled = true, command = 'propfix' }`

Usage
- Commands (examples; actual names read from `Config.commands`)
  - `/info`: Shows player info (requires `ox_lib` and `Config.features.playerInfo = true`)
  - `/autowalk`: Toggles AI-style wandering (requires `Config.features.autowalk = true`)
  - `/propfix`: Clears props attached to your ped (requires `Config.features.propStuck = true`)

- Export (server)
  - exports['gldnrmz-smallresources']:GetPlayerInfo(src)
    Returns table: { name, cid, job, jobGrade, gang, gangGrade } when qb-core is available and playerInfo=true

- Callback (server via ox_lib)
  - lib.callback.register('gldnrmz:server:getPlayerInfo', function(source) ... end)
    Access via client lib.callback('gldnrmz:server:getPlayerInfo', ...)

- Keybinds
  - Leap: Press R to perform a leap (requires `Config.features.leap = true`)
  - W Start: Press W to start the engine if you are in the driver seat (requires `Config.features.wStart = true`)

Notes
- All features are protected by config toggles; setting a toggle to false will safely disable its script.
- Command registration and names are controlled separately by `Config.commands`.
- Player info features require both qb-core (for player data) and ox_lib (for context UI and callbacks).
- Armor persistence requires qbx_core and uses its metadata storage.
- Weapon drop server logic requires ox_inventory.
 - `jumpSpam` and `disablePunch` are mutually exclusive in effect; if punches are disabled, punch spam detection will not trigger.

Troubleshooting
- If /info does nothing, verify ox_lib is started and playerInfo=true.
- If server export/callback returns nil, ensure qb-core is started and playerInfo=true.
- If armor is not restored, verify qbx_core is started and saveArmor=true.
- If weapon drops are not created, ensure ox_inventory is started and weaponDropServer=true.

Files & Structure
- client/*: Client-side features (guarded by `Config.features` and some with commands in `Config.commands`)
- server/*: Server-side features and exports/callbacks (guarded by Config.features)
- config.lua: Centralized feature toggles and settings
- fxmanifest.lua: Manifest includes shared config and ox_lib init

License
- MIT or your preferred license. Replace this section if you need a specific license.