if not Config.versionCheck then return end

local RESOURCE = GetCurrentResourceName()
local VERSION_URL = ('https://raw.githubusercontent.com/GLDNRMZ/%s/main/version.txt'):format(RESOURCE)

---@return integer[]
local function parse(version)
    local parts = {}
    for n in version:gmatch('%d+') do parts[#parts + 1] = tonumber(n) end
    return parts
end

--- -1 if a < b, 0 if equal, 1 if a > b
local function compare(a, b)
    local pa, pb = parse(a), parse(b)
    for i = 1, math.max(#pa, #pb) do
        local x, y = pa[i] or 0, pb[i] or 0
        if x ~= y then return x < y and -1 or 1 end
    end
    return 0
end

CreateThread(function()
    local current = GetResourceMetadata(RESOURCE, 'version', 0) or '0.0.0'

    PerformHttpRequest(VERSION_URL, function(status, body)
        if status ~= 200 or not body then
            return print(('^3[GLDNRMZ] Could not check the version of %s (HTTP %s)^0'):format(RESOURCE, status))
        end

        local latest = body:gsub('%s', '')
        if compare(current, latest) < 0 then
            print(('^1[GLDNRMZ] %s is out of date! Latest: %s | Current: %s^0'):format(RESOURCE, latest, current))
        else
            print(('^2[GLDNRMZ] %s is up to date (%s)^0'):format(RESOURCE, current))
        end
    end, 'GET')
end)
