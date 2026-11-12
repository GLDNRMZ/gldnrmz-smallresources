-- Forces first person while aiming (on foot, in vehicles, on bikes) or at all times.
-- Your previous camera view is restored when you stop aiming.
-- Based on Forced-First-Person by vipex.v (GPL-3.0).

if not Utils.enabled('firstPerson') then return end

local cfg = Config.firstPerson
local FIRST_PERSON = 4
local WEAPON_UNARMED = `WEAPON_UNARMED`

-- Always first person: re-apply to whatever view context is active every frame.
if cfg.always then
    CreateThread(function()
        while true do
            SetCamViewModeForContext(GetCamActiveViewModeContext(), FIRST_PERSON)
            Wait(0)
        end
    end)
    return
end

if not (cfg.onFootAiming or cfg.vehicleAiming or cfg.bikeAiming) then return end

local function shouldForce()
    if not cache.vehicle then return cfg.onFootAiming end
    if IsPedOnAnyBike(cache.ped) then return cfg.bikeAiming end
    return cfg.vehicleAiming
end

local INPUT_AIM = 25
local INPUT_VEH_AIM = 68

local function aimHeld()
    return IsControlPressed(0, INPUT_AIM) or IsDisabledControlPressed(0, INPUT_AIM)
        or IsControlPressed(0, INPUT_VEH_AIM) or IsDisabledControlPressed(0, INPUT_VEH_AIM)
end

-- Free-aim state drops when entering a vehicle, so in a vehicle the held aim button also counts.
local function isAiming()
    if IsPlayerFreeAiming(cache.playerId) then return true end
    return cache.vehicle and aimHeld() or false
end

local ON_FOOT_CONTEXT = 0
local RESTORE_MS = 750 -- keep re-applying the old view this long; the vehicle aim cam can override a single set

---@type { context: number, mode: number }?
local saved
---@type { context: number, mode: number, untilTime: number }?
local restoring

local function applyMode(context, mode)
    SetCamViewModeForContext(context, mode)
    -- Vehicle contexts also need the follow-vehicle cam set, or the aim cam can leave first person stuck.
    if context ~= ON_FOOT_CONTEXT and cache.vehicle then
        SetFollowVehicleCamViewMode(mode)
    end
end

local function restore()
    if not saved then return end
    applyMode(saved.context, saved.mode)
    restoring = { context = saved.context, mode = saved.mode, untilTime = GetGameTimer() + RESTORE_MS }
    saved = nil
end

CreateThread(function()
    while true do
        local aiming = cache.weapon and isAiming() and shouldForce()

        if aiming then
            local context = GetCamActiveViewModeContext()
            if not saved or saved.context ~= context then
                restore()
                -- If a restore was still running for this context, its mode is the original view.
                local mode = (restoring and restoring.context == context) and restoring.mode
                    or GetCamViewModeForContext(context)
                saved = { context = context, mode = mode }
            end
            restoring = nil
            SetCamViewModeForContext(context, FIRST_PERSON)
        else
            restore()
            if restoring then
                if GetGameTimer() < restoring.untilTime then
                    applyMode(restoring.context, restoring.mode)
                else
                    restoring = nil
                end
            end
        end

        Wait((aiming or restoring) and 0 or (cache.weapon and 0 or 500))
    end
end)

-- Stops players from carrying third-person aim into a vehicle (holding aim through the entry included).
if cfg.disarmOnEnter and (cfg.vehicleAiming or cfg.bikeAiming) then
    local hasOxInventory = GetResourceState('ox_inventory') == 'started'
    local blockingAim = false

    local function disarm()
        -- ox_inventory re-equips weapons removed with natives, so holster through it.
        if hasOxInventory then
            TriggerEvent('ox_inventory:disarm', true)
        else
            SetCurrentPedWeapon(cache.ped, WEAPON_UNARMED, true)
        end
    end

    -- Blocks aim until the button is released, which drops any third-person aim cam carried in.
    local function blockAimUntilReleased()
        if blockingAim then return end
        blockingAim = true
        CreateThread(function()
            while aimHeld() do
                DisableControlAction(0, INPUT_AIM, true)
                DisableControlAction(0, INPUT_VEH_AIM, true)
                DisablePlayerFiring(cache.playerId, true)
                Wait(0)
            end
            blockingAim = false
        end)
    end

    local function handleEntryAim()
        if cache.weapon and (IsPlayerFreeAiming(cache.playerId) or aimHeld()) then
            disarm()
            blockAimUntilReleased()
        end
    end

    CreateThread(function()
        while true do
            if cache.weapon and not cache.vehicle and IsPedGettingIntoAVehicle(cache.ped) then
                handleEntryAim()
                Wait(0)
            else
                Wait(100)
            end
        end
    end)

    lib.onCache('vehicle', function(vehicle)
        if vehicle then handleEntryAim() end
    end)
end

AddEventHandler('onResourceStop', function(resource)
    if resource == cache.resource then restore() end
end)
