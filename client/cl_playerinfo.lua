if type(Config) == 'table' and Config.features and not Config.features.playerInfo then
    return
end

local QBCore = exports['qb-core']:GetCoreObject()

local function toStr(v)
    return v ~= nil and tostring(v) or 'N/A'
end

local function getInfo()
    local pd = QBCore.Functions.GetPlayerData() or {}
    local char = pd.charinfo or {}
    local job = pd.job or {}
    local gang = pd.gang or {}

    local cid = pd.citizenid or char.citizenid
    local serverId = GetPlayerServerId(PlayerId())

    return {
        serverId = serverId,
        citizenId = cid or 'Unknown',
        jobLabel = job.label or job.name or 'Unemployed',
        jobGrade = (job.grade and job.grade.name) or 'N/A',
        onDuty = job.onduty and 'On Duty' or 'Off Duty',
        gangLabel = gang.label or gang.name or 'None',
        gangGrade = (gang.grade and gang.grade.name) or 'N/A',
    }
end

local function showInfoMenu()
    local info = getInfo()

    lib.registerContext({
        id = 'qbx_player_info',
        title = 'Player Info',
        options = {
            {
                title = 'Server ID',
                description = toStr(info.serverId),
                icon = 'id-card'
            },
            {
                title = 'Citizen ID',
                description = info.citizenId,
                icon = 'id-card'
            },
            {
                title = 'Job',
                description = ('%s | %s | %s'):format(info.jobLabel, info.jobGrade, info.onDuty),
                icon = 'briefcase'
            },
            {
                title = 'Gang',
                description = ('%s | %s'):format(info.gangLabel, info.gangGrade),
                icon = 'users'
            }
        }
    })

    lib.showContext('qbx_player_info')
end

local cmdInfoName = (Config and Config.commands and Config.commands.playerInfo and Config.commands.playerInfo.command) or 'info'
local cmdInfoEnabled = not (Config and Config.commands and Config.commands.playerInfo and Config.commands.playerInfo.enabled == false)

if cmdInfoEnabled then
RegisterCommand(cmdInfoName, function()
    showInfoMenu()
end, false)
end