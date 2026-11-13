-- Server half of /info: looks up the citizen ID the client can't see on its own

if not Config.features.playerInfo then return end

local Framework = exports.community_bridge:Framework()

--- ESX (1.13.3+) keeps a short citizen ID as the player's SSN, but only on the server.
--- QBCore / Qbox citizen IDs are already in the client's player data, so this returns nil for them.
lib.callback.register('gldnrmz-smallresources:server:getCitizenId', function(src)
    local ok, player = pcall(Framework.GetPlayer, src)
    if not ok or type(player) ~= 'table' or type(player.getSSN) ~= 'function' then return nil end

    local okSsn, ssn = pcall(player.getSSN)
    if okSsn and type(ssn) == 'string' and ssn ~= '' then return ssn end
    return nil
end)
