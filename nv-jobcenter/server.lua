ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



ESX.RegisterServerCallback('nv-gemeente:server:getKey', function(source, cb)
    cb(antikey)
end)



RegisterServerEvent('nv-jobcenter:server:giveJob')
AddEventHandler('nv-jobcenter:server:giveJob', function(key, job)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if key == antikey then
        xPlayer.setJob(job, 0)
    else
    end
end)