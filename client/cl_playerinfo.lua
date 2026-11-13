-- /info: shows your server ID, citizen ID, job and gang. Click an entry to copy it.

if not Utils.enabled('playerInfo') then return end

local MENU_ID = 'gldnrmz_player_info'

--- `display` is what the menu shows; clicking always copies the full `value`.
local function option(title, value, icon, display)
    value = (value ~= nil and value ~= '') and tostring(value) or 'N/A'
    return {
        title = title,
        description = display or value,
        icon = icon,
        onSelect = function()
            lib.setClipboard(value)
            Utils.notify(('%s copied to clipboard'):format(title), 'success')
        end,
    }
end

--- QBCore / Qbox: the citizen ID is the player identifier.
--- ESX: the citizen ID is the character's SSN (ESX 1.13.3+), which only the server can read.
--- Older ESX without SSNs falls back to the long `char1:<license>` identifier, shown shortened.
local function idOption(id)
    local okName, fw = pcall(Framework.GetResourceName)
    if not okName or fw ~= 'es_extended' then
        return option('Citizen ID', id, 'id-card')
    end

    local ssn = lib.callback.await('gldnrmz-smallresources:server:getCitizenId', false)
    if ssn then return option('Citizen ID', ssn, 'id-card') end

    id = tostring(id)
    local short = #id > 24 and ('%s…%s'):format(id:sub(1, 12), id:sub(-7)) or id
    return option('Identifier', id, 'id-card', short)
end

local function showInfo()
    local ok, citizenId = pcall(Framework.GetPlayerIdentifier)
    if not ok or not citizenId then
        return Utils.notify('Your character isn\'t loaded yet.', 'error')
    end

    local _, first, last = pcall(Framework.GetPlayerName)
    local name = first and ('%s %s'):format(first, last or '') or nil

    local _, job = pcall(Framework.GetPlayerJobData)
    job = type(job) == 'table' and job or {}
    local jobText = ('%s | %s | %s'):format(
        job.jobLabel or job.jobName or 'Unemployed',
        job.gradeLabel or job.gradeName or 'N/A',
        job.onDuty and 'On Duty' or 'Off Duty'
    )

    -- Gangs only exist on QBCore / Qbox
    local _, pd = pcall(Framework.GetPlayerData)
    local gang = type(pd) == 'table' and type(pd.gang) == 'table' and pd.gang or nil
    local gangText = gang and ('%s | %s'):format(
        gang.label or gang.name or 'None',
        gang.grade and gang.grade.name or 'N/A'
    ) or nil

    lib.registerContext({
        id = MENU_ID,
        title = 'Player Info',
        options = {
            option('Server ID', cache.serverId, 'hashtag'),
            idOption(citizenId),
            option('Name', name, 'user'),
            option('Job', jobText, 'briefcase'),
            gangText and option('Gang', gangText, 'users') or nil,
        },
    })
    lib.showContext(MENU_ID)
end

Utils.registerCommand('playerInfo', 'Show your player info', showInfo)
