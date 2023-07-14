local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add("testdecay", "Description", {}, true, function(source, args)
    local src = source
    
    DegradeInventoryItems()
    DegradeStashItems()
    DegradeTrunkItems()
    DegradeGloveboxItems()
end, "god")

function DegradeInventoryItems()
    local results = MySQL.Sync.fetchAll('SELECT citizenid, inventory FROM players', {})
	if results[1] ~= nil then
        local citizenid = nil
        for k = 1, #results, 1 do
            row = results[k]
            citizenid = row.citizenid
            local sentItems = {}
            local items = nil
            local isOnline = QBCore.Functions.GetPlayerByCitizenId(citizenid)
            if isOnline then
                items = isOnline.PlayerData.items

                for a, item in pairs(items) do
                    local itemInfo = QBCore.Shared.Items[item.name:lower()]
                    if item.info ~= nil and item.info.quality ~= nil then
                        local degradeAmount = QBCore.Shared.Items[item.name:lower()]["degrade"] ~= nil and QBCore.Shared.Items[item.name:lower()]["degrade"] or 0.0
                        if item.info.quality == 0.0 then
                            --do nothing
                        elseif (item.info.quality - degradeAmount) > 0.0 then
                            item.info.quality = item.info.quality - degradeAmount
                        elseif (item.info.quality - degradeAmount) <= 0.0 then
                            item.info.quality = 0.0
                        end
                    else
                        if type(item.info) == 'table' then
                            item.info.quality = 100.0
                        elseif type(item.info) == 'string' and item.info == '' then
                            item.info = {}
                            item.info.quality = 100.0
                        end
                    end
        
                    local modifiedItem = {
                        name = itemInfo["name"],
                        amount = tonumber(item.amount),
                        info = item.info ~= nil and item.info or "",
                        label = itemInfo["label"],
                        description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
                        weight = itemInfo["weight"], 
                        type = itemInfo["type"], 
                        unique = itemInfo["unique"], 
                        useable = itemInfo["useable"], 
                        image = itemInfo["image"],
                        slot = item.slot,
                    }
        
                    table.insert(sentItems, modifiedItem)
                end

                isOnline.Functions.SetInventory(sentItems)
                TriggerClientEvent("inventory:client:UpdatePlayerInventory", isOnline.PlayerData.source, false)
            else
                if row.inventory ~= nil then
                    row.inventory = json.decode(row.inventory)
                    if row.inventory ~= nil then 
                        for l = 1, #row.inventory, 1 do
                            item = row.inventory[l]
                            local itemInfo = QBCore.Shared.Items[item.name:lower()]
                            if itemInfo ~= nil then
                                if item.info ~= nil and item.info.quality ~= nil then
                                    local degradeAmount = QBCore.Shared.Items[item.name:lower()]["degrade"] ~= nil and QBCore.Shared.Items[item.name:lower()]["degrade"] or 0.0
                                    if item.info.quality == 0.0 then
                                        --do nothing
                                    elseif (item.info.quality - degradeAmount) > 0.0 then
                                        item.info.quality = item.info.quality - degradeAmount
                                    elseif (item.info.quality - degradeAmount) <= 0.0 then
                                        item.info.quality = 0.0
                                    end
                                else
                                    if type(item.info) == 'table' then
                                        item.info.quality = 100.0
                                    elseif type(item.info) == 'string' and item.info == '' then
                                        item.info = {}
                                        item.info.quality = 100.0
                                    end
                                end

                                local modifiedItem = {
                                    name = itemInfo["name"],
                                    amount = tonumber(item.amount),
                                    info = item.info ~= nil and item.info or "",
                                    label = itemInfo["label"],
                                    description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
                                    weight = itemInfo["weight"], 
                                    type = itemInfo["type"], 
                                    unique = itemInfo["unique"], 
                                    useable = itemInfo["useable"], 
                                    image = itemInfo["image"],
                                    slot = item.slot,
                                }

                                table.insert(sentItems, modifiedItem)
                            end
                        end
                        MySQL.Async.execute('UPDATE players SET inventory = ? WHERE citizenid = ?', { json.encode(sentItems), citizenid })
                    end
                end
            end
            Citizen.Wait(500)
        end
	end
end

function DegradeStashItems()
    local results = MySQL.Sync.fetchAll('SELECT * FROM stashitems', {})
	if results[1] ~= nil then
        local id = nil
        for k = 1, #results, 1 do
            row = results[k]
            id = row.id
            local items = {}
            if row.items ~= nil then
                row.items = json.decode(row.items)
                if row.items ~= nil then 
                    for l, p in pairs(row.items) do
                        item = row.items[l]
                        local itemInfo = QBCore.Shared.Items[item.name:lower()]
                        if item.info ~= nil and item.info.quality ~= nil then
                            local degradeAmount = QBCore.Shared.Items[item.name:lower()]["degrade"] ~= nil and QBCore.Shared.Items[item.name:lower()]["degrade"] or 0.0
                            if item.info.quality == 0.0 then
                                --do nothing
                            elseif (item.info.quality - degradeAmount) > 0.0 then
                                item.info.quality = item.info.quality - degradeAmount
                            elseif (item.info.quality - degradeAmount) <= 0.0 then
                                item.info.quality = 0.0
                            end
                        else
                            if type(item.info) == 'table' then
                                item.info.quality = 100.0
                            elseif type(item.info) == 'string' and item.info == '' then
                                item.info = {}
                                item.info.quality = 100.0
                            end

                        end

                        local modifiedItem = {
                            name = itemInfo["name"],
                            amount = tonumber(item.amount),
                            info = item.info ~= nil and item.info or "",
                            label = itemInfo["label"],
                            description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
                            weight = itemInfo["weight"], 
                            type = itemInfo["type"], 
                            unique = itemInfo["unique"], 
                            useable = itemInfo["useable"], 
                            image = itemInfo["image"],
                            slot = item.slot,
                        }

                        table.insert(items, modifiedItem)
                    end
                end
            end
            MySQL.Async.execute('UPDATE stashitems SET items = ? WHERE id = ?', { json.encode(items), id })
            Citizen.Wait(500)
        end
	end
end

function DegradeGloveboxItems()
    local results = MySQL.Sync.fetchAll('SELECT * FROM gloveboxitems', {})
	if results[1] ~= nil then
        local id = nil
        for k = 1, #results, 1 do
            row = results[k]
            id = row.id
            local items = {}
            if row.items ~= nil then
                row.items = json.decode(row.items)
                if row.items ~= nil then 
                    for l, p in pairs(row.items) do
                        item = row.items[l]
                        local itemInfo = QBCore.Shared.Items[item.name:lower()]
                        if item.info ~= nil and item.info.quality ~= nil then
                            local degradeAmount = QBCore.Shared.Items[item.name:lower()]["degrade"] ~= nil and QBCore.Shared.Items[item.name:lower()]["degrade"] or 0.0
                            if item.info.quality == 0.0 then
                                --do nothing
                            elseif (item.info.quality - degradeAmount) > 0.0 then
                                item.info.quality = item.info.quality - degradeAmount
                            elseif (item.info.quality - degradeAmount) <= 0.0 then
                                item.info.quality = 0.0
                            end
                        else
                            if type(item.info) == 'table' then
                                item.info.quality = 100.0
                            elseif type(item.info) == 'string' and item.info == '' then
                                item.info = {}
                                item.info.quality = 100.0
                            end

                        end

                        local modifiedItem = {
                            name = itemInfo["name"],
                            amount = tonumber(item.amount),
                            info = item.info ~= nil and item.info or "",
                            label = itemInfo["label"],
                            description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
                            weight = itemInfo["weight"], 
                            type = itemInfo["type"], 
                            unique = itemInfo["unique"], 
                            useable = itemInfo["useable"], 
                            image = itemInfo["image"],
                            slot = item.slot,
                        }

                        table.insert(items, modifiedItem)
                    end
                end
            end
            MySQL.Async.execute('UPDATE gloveboxitems SET items = ? WHERE id = ?', { json.encode(items), id })
            Citizen.Wait(500)
        end
	end
end

function DegradeTrunkItems()
    local results = MySQL.Sync.fetchAll('SELECT * FROM trunkitems', {})
	if results[1] ~= nil then
        local id = nil
        for k = 1, #results, 1 do
            row = results[k]
            id = row.id
            local items = {}
            if row.items ~= nil then
                row.items = json.decode(row.items)
                if row.items ~= nil then
                    for l, p in pairs(row.items) do
                        item = row.items[l]
                        local degradeAmount = QBCore.Shared.Items[item.name:lower()]["degrade"] ~= nil and QBCore.Shared.Items[item.name:lower()]["degrade"] or 0.0
                        local itemInfo = QBCore.Shared.Items[item.name:lower()]
                        if item.info ~= nil and item.info.quality ~= nil and degradeAmount > 0.0 then
                            if item.info.quality == 0.0 then
                                --do nothing
                            elseif (item.info.quality - degradeAmount) > 0.0 then
                                item.info.quality = item.info.quality - degradeAmount
                            elseif (item.info.quality - degradeAmount) <= 0.0 then
                                item.info.quality = 0.0
                            end
                        else
                            if type(item.info) == 'table' then
                                item.info.quality = 100.0
                            elseif type(item.info) == 'string' and item.info == '' then
                                item.info = {}
                                item.info.quality = 100.0
                            end

                        end

                        local modifiedItem = {
                            name = itemInfo["name"],
                            amount = tonumber(item.amount),
                            info = item.info ~= nil and item.info or "",
                            label = itemInfo["label"],
                            description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
                            weight = itemInfo["weight"], 
                            type = itemInfo["type"], 
                            unique = itemInfo["unique"], 
                            useable = itemInfo["useable"], 
                            image = itemInfo["image"],
                            slot = item.slot,
                        }

                        table.insert(items, modifiedItem)
                    end
                end
            end
            MySQL.Async.execute('UPDATE trunkitems SET items = ? WHERE id = ?', { json.encode(items), id })
            Citizen.Wait(500)
        end
	end
end

function DegradeAllTables()
    DegradeInventoryItems()
    Citizen.Wait(500)
    DegradeStashItems()
    Citizen.Wait(500)
    DegradeTrunkItems()
    Citizen.Wait(500)
    DegradeGloveboxItems()
end

lib.cron.new('* 10,22 * * *', function()
    DegradeAllTables()
end)
