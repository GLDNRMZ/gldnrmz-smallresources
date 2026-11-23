# gldnrmz-smallresources

A set of small gameplay tweaks for Qbox, QBCore and ESX servers. Each feature has its own on/off switch in `config.lua`, and features that are switched off don't run any code.

## 📦 Requirements

- [community_bridge](https://github.com/TheOrderFivem/community_bridge) **0.13.6+** ([Qbox](https://github.com/Qbox-project/qbx_core), [QBCore](https://github.com/qbcore-framework/qb-core) or [ESX](https://github.com/esx-framework/esx_core))
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_inventory](https://github.com/overextended/ox_inventory) (only for `weaponDrop`)

## ⚡ Installation

1. Put the folder in your resources, e.g. `[gldnrmz]/gldnrmz-smallresources`.
2. Make sure it starts after `ox_lib` and `community_bridge` (and `ox_inventory` if you use `weaponDrop`).
3. Edit `config.lua`, then restart the resource.

## ✨ Features

| Toggle | Default | What it does |
| --- | --- | --- |
| `playerInfo` | on | `/info` shows your server ID, citizen ID (the SSN on ESX), name, job and gang (QBCore / Qbox). Click an entry to copy it. |
| `autowalk` | on | `/autowalk` makes you wander like an AI ped. Moving, sprinting, jumping, aiming or getting hurt cancels it. |
| `vehicleCombat` | on | Lets players in the same vehicle shoot each other. |
| `noHelmet` | on | Stops the automatic motorcycle helmet. `qbx_smallresources` has the same feature, so you only need one of them. |
| `noVehWeapons` | on | Disables vehicle-mounted weapons. |
| `pauseMap` | on | Plays a map-reading animation while the pause menu is open. |
| `look` | on | Your head turns toward the closest player who is talking. |
| `leap` | on | Hold Sprint and press **G** to dive. Players can rebind it under Settings > Key Bindings > FiveM. |
| `trafficLights` | off | Traffic light props become frozen and unbreakable. |
| `noRoll` | off | Players who combat roll while armed are ragdolled. |
| `weaponDrop` | off | Your equipped weapon drops on the ground when you die. |
| `wStart` | off | Press W in the driver seat to start the engine. |
| `propStuck` | on | `/propfix` removes props stuck to your character. |
| `jumpSpam` | on | 25% chance to ragdoll when jumping while running. |
| `disablePunch` | off | Blocks melee unless you are locked on to a target. |
| `firstPerson` | on | Forces first person while aiming in vehicles and on bikes (on-foot and always-on are optional). Your view switches back when you stop aiming. |
| `headshots` | off | Headshots aren't instant kills. Each headshot deals a fixed share of health, so it always takes `shotsToKill` headshots (3 by default, set per weapon in `Config.headshots`) to kill a player at full health. |

Command names can be changed or disabled under `Config.commands`. Each feature's settings (chances, timings, keys, models) are further down in `config.lua`.

### Notes

- **wStart and vehicle keys:** by default, W starts any engine the player is driving. To require keys, put your keys check in `Config.wStart.canStart`.
- **weaponDrop:** the server only accepts weapon items and has a cooldown (`Config.weaponDrop.cooldown`), so a modified client can't use the event to drop other items or spam drops.
- **Armor:** this resource doesn't save armor; use your framework's (qbx_core does it built in).

## 🆕 Changelog

### 2.1.0
- Runs on Qbox, QBCore and ESX through community_bridge (2.0.0 required Qbox).
- `/info` shows the character's citizen ID on every framework (ESX: SSN).

### 2.0.0
- Requires Qbox: player data now comes from qbx_core (removed the `qb-core` bridge and broken locale include).
- Removed the armor saver. qbx_core already saves and restores armor, and the old unload handler saved for the wrong player.
- Weapon drop: now one toggle (`weaponDrop`) that covers both client and server. The server event is renamed and validated: weapons only, rate-limited, and no crash on an empty slot. It also drops only once per death.
- Fixed `disablePunch` starting duplicate per-frame loops on every spawn.
- Fixed `noRoll` starting an extra loop on every weapon switch.
- Fixed `look` resetting your head whenever any nearby player was silent, and now looks at the closest talker.
- Fixed `/autowalk` usually ignoring the keys meant to cancel it.
- `noVehWeapons` and `wStart` no longer run every frame. They only run while you're in an armed vehicle or in the driver seat.
- `pauseMap` only stops its own animation instead of clearing all tasks (which broke emotes), and removes its prop when the resource stops.
- `vehicleCombat` restores the exact original relationships instead of guessing, and only targets players in your vehicle.
- `noHelmet` uses the ped config flag and no longer errors when you leave a vehicle.
- `leap` has a cooldown and won't trigger while dead, cuffed, falling, swimming or ragdolled.
- `/propfix` reports how many props it removed. `/info` adds your name and copy-on-click.
- Commands now show chat suggestions. Tunable values were moved into `config.lua`, and global functions were removed.
- Version check handles HTTP errors and compares versions properly.

## 📄 License

**GLDNRMZ Script License** - see [LICENSE](LICENSE).

- ✅ Run it on your own server and edit it for that server
- ❌ Don't sell it, re-upload or share it (free or paid), or put it in a pack or server build
- ❌ Don't remove the credits or claim it as your own

Need something else, like a commercial license? Ask on [Discord](https://discord.gg/7YHJ7774jA).

<!-- gldnrmz-links -->
---

## 🔗 Links

<p align="center">
  <a href="https://discord.gg/7YHJ7774jA"><img src="https://img.shields.io/badge/Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white" alt="Discord" /></a>
  <a href="https://forum.cfx.re/u/gldnrmz/summary"><img src="https://img.shields.io/badge/Cfx.re-F40552?style=for-the-badge&logoColor=white" alt="Cfx.re forum" /></a>
  <a href="https://5metrics.dev/resources?search=gldnrmz"><img src="https://img.shields.io/badge/5Metrics-00BFFF?style=for-the-badge&logoColor=white" alt="5Metrics" /></a>
  <a href="https://gldnrmz.tebex.io"><img src="https://img.shields.io/badge/Tebex-FFD700?style=for-the-badge&logoColor=black" alt="Tebex store" /></a>
  <a href="https://www.buymeacoffee.com/gldnrmz"><img src="https://img.shields.io/badge/Buy%20me%20a%20coffee-FF813F?style=for-the-badge&logo=buymeacoffee&logoColor=white" alt="Buy me a coffee" /></a>
</p>
