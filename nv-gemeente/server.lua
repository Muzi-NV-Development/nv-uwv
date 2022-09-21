ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('nv-gemeente:server:getKey', function(source, cb)
    cb(antikey)
end)

ESX.RegisterServerCallback('nv-gemeente:server:getItems', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemcount = xPlayer.getInventoryItem(item).count
    print(item)
    if itemcount > 0 then
        cb(true)
    end
    cb(false)
end)


RegisterNetEvent('nv-gemeente:server:giveCardToPlayer')
AddEventHandler('nv-gemeente:server:giveCardToPlayer', function(item, key)
    local xPlayer = ESX.GetPlayerFromId(source)
    if key == antikey then
        xPlayer.addInventoryItem(item, 1)
    else
    end
end)    