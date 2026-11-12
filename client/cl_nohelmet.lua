-- Stops your character from putting on a helmet automatically when riding a motorcycle

if not Utils.enabled('noHelmet') then return end

local PUT_ON_MOTORCYCLE_HELMET = 35

---@param ped number
local function apply(ped)
    if not ped or ped == 0 then return end
    SetPedConfigFlag(ped, PUT_ON_MOTORCYCLE_HELMET, false)
    SetPedHelmet(ped, false)
end

apply(cache.ped)

-- The flag lives on the ped, so re-apply when the ped is replaced (respawn, clothing/model change)
lib.onCache('ped', apply)
