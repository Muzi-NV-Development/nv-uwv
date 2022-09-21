ESX = nil
PlayerData = {}
local isLoggedIn = false
local npc = nil
local triggerkey = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()


    ESX.TriggerServerCallback('nv-gemeente:server:getKey', function(key)
        triggerkey = key
    
    end)
end) 

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer) 
  	PlayerData = xPlayer
	isLoggedIn = true
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false

        local dist = #(vector3(nv.Locations['balie']['x'], nv.Locations['balie']['y'], nv.Locations['balie']['z']) - pos)

        if dist < 3 then
            inRange = true
            exports['nv-assets']:doDrawText(vector3(nv.Peds['a_f_y_business_01']['x'], nv.Peds['a_f_y_business_01']['y'], nv.Peds['a_f_y_business_01']['z'] + 2), 'Uitzendbureau')
            exports['nv-assets']:doDrawText(vector3(nv.Locations['balie']['x'], nv.Locations['balie']['y'], nv.Locations['balie']['z']), '~r~E~w~ - Balie')
            if IsControlJustPressed(0, 38) then
                setNUI(true)
            end
        end
        if not inRange then Citizen.Wait(1500) end
    end
end)

setNUI = function(bool)
    SendNUIMessage({
        action = 'open'
    })
    SetNuiFocus(true, true)
end

setPedAnimBack = function()
    exports['nv-assets']:RequestAnimationDict('amb@world_human_clipboard@male@idle_b')
    TaskPlayAnim(npc, 'amb@world_human_clipboard@male@idle_b', 'idle_d', 5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
end



RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('givecart', function(data)
    exports['nv-assets']:SendAlert('error', 'Je bent aangenomen bij ' .. data.type ..'!' , 4000)
    TriggerServerEvent('nv-jobcenter:server:giveJob', triggerkey, data.type)
end)




Citizen.CreateThread(function()
    for k,v in pairs(nv.Peds) do
        RequestModel(GetHashKey(k))
        while not HasModelLoaded(GetHashKey(k)) do
            Wait(1)
        end

        npc = CreatePed(4, k, v['x'], v['y'], v['z'], v['h'], false, true)
        FreezeEntityPosition(npc, true)
        SetPedDropsWeaponsWhenDead(npc, false)
        SetPedDiesWhenInjured(npc, false)
        FreezeEntityPosition(npc, true)
        exports['nv-assets']:RequestAnimationDict('amb@world_human_clipboard@male@idle_b')
        TaskPlayAnim(npc, 'amb@world_human_clipboard@male@idle_b', 'idle_d', 5.0, 1.5, 1.0, 49, 0.0, 0, 0, 0)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    if npc ~= nil then
        DeletePed(npc)
    end
end)
  

Citizen.CreateThread(function()
    kutserver = AddBlipForCoord(nv.Locations['balie']['x'], nv.Locations['balie']['y'], nv.Locations['balie']['z'])
    SetBlipSprite(kutserver, 480)
    SetBlipDisplay(kutserver, 4)
    SetBlipScale(kutserver, 0.5)
    SetBlipColour(kutserver, 45)
    SetBlipAsShortRange(kutserver, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Uitzendbureau')
    EndTextCommandSetBlipName(kutserver)
end)
