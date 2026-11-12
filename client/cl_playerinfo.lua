-- /info: shows your server ID, citizen ID, job and gang. Click an entry to copy it.

if not Utils.enabled('playerInfo') then return end

local MENU_ID = 'gldnrmz_player_info'

local function option(title, value, icon)
    value = (value ~= nil and value ~= '') and tostring(value) or 'N/A'
    return {
        title = title,
        description = value,
        icon = icon,
        onSelect = function()
            lib.setClipboard(value)
            Utils.notify(('%s copied to clipboard'):format(title), 'success')
        end,
    }
end

local function showInfo()
    local pd = QBX.PlayerData
    if not pd or not pd.citizenid then
        return Utils.notify('Your character isn\'t loaded yet.', 'error')
    end

    local char, job, gang = pd.charinfo or {}, pd.job or {}, pd.gang or {}
    local name = char.firstname and ('%s %s'):format(char.firstname, char.lastname or '') or nil

    local jobText = ('%s | %s | %s'):format(
        job.label or job.name or 'Unemployed',
        job.grade and job.grade.name or 'N/A',
        job.onduty and 'On Duty' or 'Off Duty'
    )
    local gangText = ('%s | %s'):format(
        gang.label or gang.name or 'None',
        gang.grade and gang.grade.name or 'N/A'
    )

    lib.registerContext({
        id = MENU_ID,
        title = 'Player Info',
        options = {
            option('Server ID', cache.serverId, 'hashtag'),
            option('Citizen ID', pd.citizenid, 'id-card'),
            option('Name', name, 'user'),
            option('Job', jobText, 'briefcase'),
            option('Gang', gangText, 'users'),
        },
    })
    lib.showContext(MENU_ID)
end

Utils.registerCommand('playerInfo', 'Show your player info', showInfo)
