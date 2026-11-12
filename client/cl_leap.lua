-- Sprint + key to dive/slide forward

if not Utils.enabled('leap') then return end

local cfg = Config.leap
local DICT = 'anim@sports@ballgame@handball@'
local SPRINT = 21

local busy, lastLeap = false, 0

local function canLeap(ped)
    return IsPedOnFoot(ped)
        and not IsPedRagdoll(ped)
        and not IsPedFalling(ped)
        and not IsPedSwimming(ped)
        and not IsPedClimbing(ped)
        and not IsPedInParachuteFreeFall(ped)
        and not Utils.isIncapacitated(ped)
end

local function doLeap()
    if not Utils.requestAnimDict(DICT) then return end
    local ped = cache.ped

    TaskPlayAnim(ped, DICT, 'ball_rstop_r_slide', 8.0, 8.0, -1, 2, 0, false, false, false)
    Wait(math.floor(GetAnimDuration(DICT, 'ball_rstop_r_slide') * 1000))

    TaskPlayAnim(ped, DICT, 'ball_get_up', 8.0, 8.0, -1, 1, 0, false, false, false)
    Wait(math.floor(GetAnimDuration(DICT, 'ball_get_up') * 500))

    StopAnimTask(ped, DICT, 'ball_get_up', 1.0)
    RemoveAnimDict(DICT)
end

lib.addKeybind({
    name = 'doleap', -- kept from 1.x so existing player bindings carry over
    description = cfg.requireSprint and 'Leap (hold Sprint)' or 'Leap',
    defaultKey = cfg.key,
    onPressed = function()
        if busy then return end
        if cfg.requireSprint and not IsControlPressed(0, SPRINT) then return end
        if GetGameTimer() - lastLeap < cfg.cooldown then return end
        if not canLeap(cache.ped) then return end

        busy, lastLeap = true, GetGameTimer()
        CreateThread(function()
            local ok, err = pcall(doLeap)
            if not ok then Utils.debug('Leap failed:', err) end
            busy = false
        end)
    end,
})
