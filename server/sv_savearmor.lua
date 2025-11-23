if not (Config and Config.features and Config.features.saveArmor) then return end

AddEventHandler('QBCore:Server:OnPlayerUnload', function()
    local src = source
    local ped = GetPlayerPed(src)
    local armor = ped and GetPedArmour(ped) or 0

    exports.qbx_core:SetMetaData(src, "armor", armor)
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end

    local armor = Player.PlayerData.metadata.armor or 0

    if armor > 0 then
        Wait(1000)
        local ped = GetPlayerPed(src)
        if ped and ped ~= 0 then
            SetPedArmour(ped, armor)
        end
    end
end)