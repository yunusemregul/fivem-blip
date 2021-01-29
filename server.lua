blips = blips or {}

RegisterNetEvent("fxblip:sync")
AddEventHandler("fxblip:sync", function()
    TriggerClientEvent("fxblip:sync", source, blips)
end)

RegisterNetEvent("fxblip:add")
AddEventHandler("fxblip:add", function(id, name)
    if not id or not name then return end
    if string.len(name) < 2 then return end
    if string.len(name) > 20 then return end

    local playerId = GetPlayerIdentifiers(source)[1]

    blips[playerId] = {
        id = tonumber(id),
        name = name,
        pos = GetEntityCoords(GetPlayerPed(source));
        time = os.time(),
    }

    TriggerClientEvent("fxblip:add", -1, playerId, blips[playerId])
end)

if fxBlipSystem.blipLifetime ~= 0 then
    Citizen.CreateThread(function()
        while true do
            for playerId, data in pairs(blips) do
                if (os.time() - data.time) > fxBlipSystem.blipLifeTime then
                    print("Removing "..playerId.." 's blip")
                    blips[playerId] = nil
                    TriggerClientEvent("fxblip:remove", -1, playerId)
                end
            end
    
            Citizen.Wait(1000)
        end
    end)
end