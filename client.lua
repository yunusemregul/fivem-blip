local validBlipIds = {1,8,16,36,38,40,43,50,51,52,56,60,61,66,67,68,71,72,73,75,76,77,78,79,80,84,85,88,89,90,93,94,100,102,103,106,108,109,110,119,120,121,122,126,127,133,135,136,140,141,147,149,150,151,152,153,154,155,156,157,158,159,160,162,163,164,171,173,174,175,181,184,188,197,198,205,206,207,225,226,229,238,251,255,266,267,269,270,273,274,277,279,280,285,303,304,305,306,307,308,310,311,313,314,315,316,318,350,351,352,354,355,356,357,358,359,360,361,362,363,365,367,368,369,370,371,372,374,375,376,377,378,379,380,381,382,383,384,385,387,388,389,390,398,400,401,402,403,404,405,408,409,410,411,415,417,418,419,420,421,427,430,431,432,433,434,435,436,437,439,440,441,442,445,446,455,456,458,459,460,461,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,512,513,514,515,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,657,658,659,660,661,662,663,664,665,666,667,668,669}

blips = blips or {}

local function deleteBlip(playerId)
    print("Removing "..playerId.." 's blip")
    RemoveBlip(blips[playerId])
    blips[playerId] = nil
end

local function createBlip(playerId, data)
    if blips[playerId] then
        deleteBlip(playerId)
    end
    print("Creating "..playerId.." 's blip named "..data.name)

    local blip = AddBlipForCoord(data.pos.x, data.pos.y, data.pos.z)
    SetBlipSprite(blip, data.id)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, true)
    
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.name)
    EndTextCommandSetBlipName(blip)
    
    blips[playerId] = blip
end

AddEventHandler('playerSpawned', function()
    Wait(3500)
    TriggerServerEvent("fxblip:sync")
end)

RegisterNetEvent("fxblip:sync")
AddEventHandler("fxblip:sync", function(data)
    for playerId, data in pairs(data) do
        createBlip(playerId, data)
    end
end)

RegisterNetEvent("fxblip:add")
AddEventHandler("fxblip:add", createBlip)

RegisterNetEvent("fxblip:remove")
AddEventHandler("fxblip:remove", deleteBlip)

RegisterCommand("addblip", function(source, argList)
    if (#argList < 2) then
        TriggerEvent("chatMessage", "BLIP", {255, 0, 0}, "Kullanım: /addblip id isim")
        return
    end

    local name = ""

    if (#argList >= 2) then
        for i=2,#argList do
            name = name..argList[i]

            if (i ~= #argList) then
                name = name.." "
            end
        end
    end
    
    if (string.len(name) < 2) then
        TriggerEvent("chatMessage", "BLIP", {255, 0, 0}, "Blip adı 2 karakterden az olamaz.")
        return
    end

    if (string.len(name) > 20) then
        TriggerEvent("chatMessage", "BLIP", {255, 0, 0}, "Blip adı 20 karakterden fazla olamaz.")
        return
    end

    local isBlipIdValid = false
    for i=1,#validBlipIds do
        if (validBlipIds[i]==tonumber(argList[1])) then
            isBlipIdValid = true
            break
        end
    end

    if (isBlipIdValid) then
        print("Adding blip with following info: id="..argList[1].." name="..name)
        TriggerServerEvent("fxblip:add", argList[1], name)
    else
        TriggerEvent("chatMessage", "BLIP", {255, 0, 0}, "Girdiginiz ID de bir blip bulunmuyor.")
        return
    end
end)