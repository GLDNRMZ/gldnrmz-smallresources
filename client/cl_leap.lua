if type(Config) == 'table' and Config.features and not Config.features.leap then
    return
end

local isLeaping = false
local dict = 'anim@sports@ballgame@handball@'

local function doLeap()
    lib.requestAnimDict(dict, 2000)
    TaskPlayAnim(cache.ped, dict, 'ball_rstop_r_slide', 8.0, 8.0, -1, 2, 0, false, false, false)
    Wait(GetAnimDuration(dict, 'ball_rstop_r_slide') * 1000)
    TaskPlayAnim(cache.ped, dict, 'ball_get_up', 8.0, 8.0, -1, 01, 0, false, false, false)
    Wait(GetAnimDuration(dict, 'ball_get_up') * 500)
    StopAnimTask(cache.ped, dict, 'ball_get_up', 1.0)
    RemoveAnimDict(dict)
    isLeaping = false
end

lib.addKeybind({
    name = 'doleap',
    description = 'Yeeeeeeeeeeet',
    defaultKey = 'G',
    onPressed = function()
        -- SHIFT + R
        if IsControlPressed(1, 21) and not isLeaping then
            isLeaping = true
            doLeap()
        end
    end,
})