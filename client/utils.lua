-- Shared helpers for the client feature files (loaded first by fxmanifest)

Utils = {}

local RESOURCE = GetCurrentResourceName()

---@param feature string
---@return boolean
function Utils.enabled(feature)
    return Config.features[feature] == true
end

function Utils.debug(...)
    if not Config.debug then return end
    print(('^3[%s]^0'):format(RESOURCE), ...)
end

---@param description string
---@param type? 'inform'|'success'|'error'|'warning'
---@param title? string
function Utils.notify(description, type, title)
    lib.notify({ title = title, description = description, type = type or 'inform' })
end

--- True when the player is dead, downed or cuffed and shouldn't start actions.
---@param ped? number
---@return boolean
function Utils.isIncapacitated(ped)
    ped = ped or cache.ped
    if IsEntityDead(ped) or IsPedFatallyInjured(ped) or IsPedCuffed(ped) then
        return true
    end

    local meta = QBX.PlayerData.metadata
    return meta ~= nil and (meta.isdead or meta.inlaststand or meta.ishandcuffed) == true
end

--- Loads an anim dict without throwing. Returns false on timeout.
---@param dict string
---@return boolean
function Utils.requestAnimDict(dict)
    local ok = pcall(lib.requestAnimDict, dict, 2000)
    if not ok then Utils.debug('Failed to load anim dict', dict) end
    return ok
end

--- Loads a model without throwing. Returns false on timeout.
---@param model number|string
---@return boolean
function Utils.requestModel(model)
    local ok = pcall(lib.requestModel, model, 2000)
    if not ok then Utils.debug('Failed to load model', model) end
    return ok
end

local suggestions = {}

--- Registers a command from Config.commands[key] (skipped if disabled).
---@param key string
---@param help string
---@param handler fun(source: number, args: string[], raw: string)
function Utils.registerCommand(key, help, handler)
    local cmd = Config.commands[key]
    if not cmd or cmd.enabled == false or not cmd.command then return end

    RegisterCommand(cmd.command, handler, false)

    local name = '/' .. cmd.command
    TriggerEvent('chat:addSuggestion', name, help)
    suggestions[#suggestions + 1] = name
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= RESOURCE then return end
    for i = 1, #suggestions do
        TriggerEvent('chat:removeSuggestion', suggestions[i])
    end
end)
