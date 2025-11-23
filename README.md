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
3) Configure features in config.lua (all default to true). Restart the resource after changes.

Configuration (config.lua)
Features (client)
- playerInfo: /info menu (ox_lib) and client-side info UI
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

Features (server)
- serverMain: Core server helpers (health check/logs); playerInfo export/callbacks are separately gated by playerInfo
- saveArmor: Save armor on unload and restore on load via qbx_core metadata
- weaponDropServer: Handle weapon drop creation using ox_inventory

Usage
- Commands
  - /info: Shows player info (requires ox_lib and playerInfo=true)
  - /gsr_ping: Health check to confirm server-side script is responsive

- Export (server)
  - exports['gldnrmz-smallresources']:GetPlayerInfo(src)
    Returns table: { name, cid, job, jobGrade, gang, gangGrade } when qb-core is available and playerInfo=true

- Callback (server via ox_lib)
  - lib.callback.register('gldnrmz:server:getPlayerInfo', function(source) ... end)
    Access via client lib.callback('gldnrmz:server:getPlayerInfo', ...)

- Keybinds
  - Leap: Press R to perform a leap (no SHIFT required)
  - W Start: Press W to start the engine if you are in the driver seat

Notes
- All features are protected by config toggles; setting a toggle to false will safely disable its script.
- Player info features require both qb-core (for player data) and ox_lib (for context UI and callbacks).
- Armor persistence requires qbx_core and uses its metadata storage.
- Weapon drop server logic requires ox_inventory.

Troubleshooting
- If /info does nothing, verify ox_lib is started and playerInfo=true.
- If server export/callback returns nil, ensure qb-core is started and playerInfo=true.
- If armor is not restored, verify qbx_core is started and saveArmor=true.
- If weapon drops are not created, ensure ox_inventory is started and weaponDropServer=true.

Files & Structure
- client/*: Client-side features (guarded by Config.features)
- server/*: Server-side features and exports/callbacks (guarded by Config.features)
- config.lua: Centralized feature toggles and settings
- fxmanifest.lua: Manifest includes shared config and ox_lib init

License
- MIT or your preferred license. Replace this section if you need a specific license.