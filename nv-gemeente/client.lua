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

        if dist < 1 then
            inRange = true
            exports['nv-assets']:doDrawText(vector3(nv.Locations['balie']['x'], nv.Locations['balie']['y'], nv.Locations['balie']['z']), '~r~E~w~ - Documenten')
            if IsControlJustPressed(0, 38) then
                setNUI(true)
            end
        elseif dist < 2 then
            inRange = true
            exports['nv-assets']:doDrawText(vector3(nv.Locations['balie']['x'], nv.Locations['balie']['y'], nv.Locations['balie']['z']), 'Documenten')
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

getCard = function(type)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5)

            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            exports['nv-assets']:doDrawText(pos, '~g~G~w~ - Kaart aanpakken')
            if IsControlJustPressed(0, 58) then
                TriggerServerEvent('nv-gemeente:server:giveCardToPlayer', type, triggerkey)
                return
            end
        end
    end)
end

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('givecart', function(data)
    ESX.TriggerServerCallback('nv-gemeente:server:getItems', function(hasItem)
        if hasItem then
            exports['nv-assets']:SendAlert('error', 'Je hebt dit item al of ga naar de politie voor aangifte!', 4000)
        else
            getCard(data.type)
        end
    end, data.type)
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
    SetBlipScale(kutserver, 0.7)
    SetBlipColour(kutserver, 6)
    SetBlipAsShortRange(kutserver, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Gemeentehuis')
    EndTextCommandSetBlipName(kutserver)
end)
