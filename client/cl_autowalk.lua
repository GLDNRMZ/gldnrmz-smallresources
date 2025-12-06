-- Auto-walk command: makes your player wander like an AI ped

if not (Config and Config.features and Config.features.autowalk) then return end

local function playerPed()
    return PlayerPedId()
end

local autowalk = false

local function stopAutowalk()
    local ped = playerPed()
    ClearPedTasks(ped)
    autowalk = false
end

local function startAutowalk()
    local ped = playerPed()
    if ped == 0 or not IsPedOnFoot(ped) or IsEntityDead(ped) then return end

    autowalk = true
    SetPedKeepTask(ped, true)
    -- Standard wander task used by AI peds
    TaskWanderStandard(ped, 10.0, 10)

    -- Monitor for conditions or user input to cancel
    CreateThread(function()
        while autowalk do
            ped = playerPed()
            if ped == 0 then break end

            -- Cancel if player state changes
            if IsPedInAnyVehicle(ped) or IsPedSwimming(ped) or IsPedRagdoll(ped) or IsEntityDead(ped) then
                stopAutowalk()
                break
            end

            -- Cancel on player movement inputs or sprint
            if IsControlJustPressed(0, 30)  -- move left
                or IsControlJustPressed(0, 31) -- move down
                or IsControlJustPressed(0, 32) -- move up
                or IsControlJustPressed(0, 33) -- move right
                or IsControlJustPressed(0, 34) -- strafe left
                or IsControlJustPressed(0, 35) -- strafe right
                or IsControlJustPressed(0, 21) -- sprint
                or IsControlJustPressed(0, 22) -- jump
            then
                stopAutowalk()
                break
            end

            Wait(100)
        end
    end)
end

local cmdAutoWalkName = (Config and Config.commands and Config.commands.autoWalk and Config.commands.autoWalk.command) or 'autowalk'
local cmdAutoWalkEnabled = not (Config and Config.commands and Config.commands.autoWalk and Config.commands.autoWalk.enabled == false)

if cmdAutoWalkEnabled then
RegisterCommand(cmdAutoWalkName, function()
    if autowalk then
        stopAutowalk()
    else
        startAutowalk()
    end
end, false)
end

-- Clean up if resource stops while autowalking
AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and autowalk then
        stopAutowalk()
    end
end)