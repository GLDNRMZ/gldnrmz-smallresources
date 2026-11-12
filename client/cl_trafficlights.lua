-- Makes traffic light props frozen and unbreakable (client-side)

if not Utils.enabled('trafficLights') then return end

local cfg = Config.trafficLights

local models = {}
for i = 1, #cfg.models do
    models[cfg.models[i]] = true
end

local function lockNearbyLights()
    local objects = GetGamePool('CObject')
    for i = 1, #objects do
        local obj = objects[i]
        if models[GetEntityModel(obj)] then
            FreezeEntityPosition(obj, true)
            SetEntityCanBeDamaged(obj, false)
        end
    end
end

CreateThread(function()
    local lastCoords, lastScan = vec3(0, 0, 0), 0

    while true do
        local coords = GetEntityCoords(cache.ped)
        local now = GetGameTimer()

        if #(coords - lastCoords) >= cfg.rescanDistance or now - lastScan >= cfg.rescanInterval then
            lastCoords, lastScan = coords, now
            lockNearbyLights()
        end

        Wait(1000)
    end
end)
