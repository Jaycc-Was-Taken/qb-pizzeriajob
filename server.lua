QBCore = exports["qb-core"]:GetCoreObject()

local ItemsTable = {}
local FoodTable = {"TEST"}
local DrinkTable = {}
local DessertTable = {}
local CraftTable = {}

local function GetCraftingItems(itemname)
    for k, v in pairs(CraftTable) do
        print("in function", v.item)
        if v.item == itemname then
            return v
        end
    end
end

RegisterNetEvent('QBCore:Server:UpdateObject', function()
    if source ~= '' then return false end -- Safety check if the event was not called from the server.
    QBCore = exports['qb-core']:GetCoreObject()
end)

QBCore.Functions.CreateCallback("qb-addnewitems:server:gettable", function(source, cb, type)
    local returnTable = {}
    print("type", type)
    for k, v in pairs(ItemsTable) do
        if v.foodtype == type then
            returnTable[#returnTable+1] = v
        end
    end
    print(json.encode(returnTable))
    cb(returnTable)
end)

QBCore.Functions.CreateCallback("qb-addnewitems:server:stationitems", function(source, cb, station)
    local returnTable = {}
    print("station", station)
    if station == "food" then
        for k, v in pairs(FoodTable) do
            local craftitems = GetCraftingItems(v)
            if craftitems ~= nil then
                returnTable[#returnTable+1] = craftitems
            end
        end
        print("return", json.encode(returnTable))
        cb(returnTable)
    elseif station == "drink" then
        cb(DrinkTable)
    elseif station == "dessert" then
        cb(DessertTable)
    end
    -- cb(returnTable)
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)
    local LoadJson = json.decode(LoadResourceFile(GetCurrentResourceName(), 'crafting.json'))
    CraftTable = LoadJson
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)
    local LoadJson = json.decode(LoadResourceFile(GetCurrentResourceName(), 'items.json'))
    ItemsTable = LoadJson
    for k, v in pairs(ItemsTable) do
        local infotable = {
            name = v.name,
            type = 'item',
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            label = v.label,
            weight = v.weight,
            image = v.image,
            description = v.description
        }
        exports["qb-core"]:AddItem(infotable.name, infotable)
    end
    
end)


RegisterServerEvent("qb-additem:server:additem", function(itemName, label, weight, image, description, foodtype)
    local infotable = {
        name = itemName,
        type = 'item',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
        label = label,
        weight = weight,
        image = image,
        description = description
    }
    exports["qb-core"]:AddItem(infotable.name, infotable)

    infotable.foodtype = foodtype
    table.insert(ItemsTable, infotable)
    SaveResourceFile(GetCurrentResourceName(), "items.json", json.encode(ItemsTable), -1)
end)

RegisterServerEvent("qb-additem:server:addcrafting", function(itemName, ingredient1, ingredient2, ingredient3,ingredient4, ingredient5)
    -- local infotable = {
    --     name = itemName,
    --     type = 'item',
    --     unique = false,
    --     useable = true,
    --     shouldClose = true,
    --     combinable = nil,
    --     label = label,
    --     weight = weight,
    --     image = image,
    --     description = description
    -- }
    local infotable = {
        item = itemName,
        ingredient1 = ingredient1,
        ingredient2 = ingredient2,
        ingredient3 = ingredient3,
        ingredient4 = ingredient4,
        ingredient5 = ingredient5
    }
    -- exports["qb-core"]:AddItem(infotable.name, infotable)

    -- infotable.foodtype = foodtype
    table.insert(CraftTable, infotable)
    SaveResourceFile(GetCurrentResourceName(), "crafting.json", json.encode(CraftTable), -1)
end)


RegisterServerEvent("qb-additem:server:setItems", function(type, list)

    for k, v in pairs(list) do
        if v == "true" then
            if type == "food" then
                table.insert(FoodTable, k)
            elseif type == "drink" then
                table.insert(DrinkTable, k)
            elseif type == "dessert" then
                table.insert(DessertTable, k)
            end
        end
    end
end)


QBCore.Functions.CreateCallback('qb-addnewitems:server:get:ingredient', function(source, cb, items)
    local testData = {}

    for k, v in pairs(items) do
        if testData[v] == nil then
            testData[v] = {}
            testData[v].amount = 1
        else
            testData[v].amount = testData[v].amount + 1
        end
    end
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local items = items
    local hasItems = true
    for k, v in pairs(testData) do
        if Ply.Functions.GetItemByName(k) ~= nil then
            hasItems = hasItems and (Ply.Functions.GetItemByName(k).amount >= v.amount)
        else
            hasItems = hasItems and false 
        end
    end
    cb(hasItems)
end)

RegisterNetEvent("qb-addnewitems:server:cook")
AddEventHandler("qb-addnewitems:server:cook", function(items, giveitem)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    removedItems = {}
    local removed = true
    for k, v in pairs(items) do
        if Player.Functions.RemoveItem(v, 1) then
            table.insert(removedItems, {item = v, amount = 1})
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[v], "remove")
            removed = removed and true
        else
            removed = removed and false
        end
    end

    if removed then
        Player.Functions.AddItem(giveitem, 1)
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[giveitem], "add")
    else
        for k, v in pairs(removedItems) do
            Player.Functions.AddItem(v.item, v.amount)
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[v.item], "add")
        end
        TriggerClientEvent('QBCore:Notify', source, "Looks like you dropped some items!", "error")
    end
end)