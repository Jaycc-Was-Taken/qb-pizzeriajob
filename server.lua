QBCore = exports["qb-core"]:GetCoreObject()

local ItemsTable = {}
local FoodTable = {}
local DrinkTable = {}
local DessertTable = {}
local CraftTable = {}

local function GetCraftingItems(itemname)
    for k, v in pairs(CraftTable) do
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
    for k, v in pairs(ItemsTable) do
        if v.foodtype == type then
            returnTable[#returnTable+1] = v
        end
    end
    cb(returnTable)
end)

QBCore.Functions.CreateCallback("qb-addnewitems:server:stationitems", function(source, cb, station)
    local returnTable = {}
    if station == "food" then
        for k, v in pairs(FoodTable) do
            local craftitems = GetCraftingItems(v)
            if craftitems ~= nil then
                returnTable[#returnTable+1] = craftitems
            end
        end
        cb(returnTable)
    elseif station == "drink" then
        for k, v in pairs(DrinkTable) do
            local craftitems = GetCraftingItems(v)
            if craftitems ~= nil then
                returnTable[#returnTable+1] = craftitems
            end
        end
        cb(returnTable)
    elseif station == "dessert" then
        for k, v in pairs(DessertTable) do
            local craftitems = GetCraftingItems(v)
            if craftitems ~= nil then
                returnTable[#returnTable+1] = craftitems
            end
        end
        cb(returnTable)
    end
    -- cb(returnTable)
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)
    local LoadJson = json.decode(LoadResourceFile(GetCurrentResourceName(), 'json/crafting.json'))
    local LoadJson2 = json.decode(LoadResourceFile(GetCurrentResourceName(), 'json/food.json'))
    local LoadJson3 = json.decode(LoadResourceFile(GetCurrentResourceName(), 'json/drink.json'))
    local LoadJson4 = json.decode(LoadResourceFile(GetCurrentResourceName(), 'json/dessert.json'))
    CraftTable = LoadJson
    FoodTable = LoadJson2
    DrinkTable = LoadJson3
    DessertTable = LoadJson4
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)
    local LoadJson = json.decode(LoadResourceFile(GetCurrentResourceName(), 'json/items.json'))
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
    SaveResourceFile(GetCurrentResourceName(), "json/items.json", json.encode(ItemsTable), -1)
end)

local function HasCrafting(itemName)
    for k, v in pairs(CraftTable) do
        if v.item == itemName then
            return k
        end
    end
end

RegisterServerEvent("qb-additem:server:addcrafting", function(itemName, ingredient1, ingredient2, ingredient3,ingredient4, ingredient5)

    local index = HasCrafting(itemName)
    local infotable = {}    
    if QBCore.Shared.Items[ingredient1] ~= nil and QBCore.Shared.Items[ingredient1] ~= nil and QBCore.Shared.Items[ingredient3] ~= nil and QBCore.Shared.Items[ingredient4] ~= nil and QBCore.Shared.Items[ingredient5] ~= nil then
        if index ~= nil then
            CraftTable[index].ingredient1 = ingredient1
            CraftTable[index].ingredient2 = ingredient2
            CraftTable[index].ingredient3 = ingredient3
            CraftTable[index].ingredient4 = ingredient4
            CraftTable[index].ingredient5 = ingredient5
        else
            infotable = {
                item = itemName,
                ingredient1 = ingredient1,
                ingredient2 = ingredient2,
                ingredient3 = ingredient3,
                ingredient4 = ingredient4,
                ingredient5 = ingredient5
            }
            -- exports["qb-core"]:AddItem(infotable.name, infotable)
            table.insert(CraftTable, infotable)
        end
    else
        local missingIngredients = { QBCore.Shared.Items[ingredient1] == nil and "Ingredient1" or "", QBCore.Shared.Items[ingredient2] == nil and "Ingredient2" or "", QBCore.Shared.Items[ingredient3] == nil and "Ingredient3" or "", QBCore.Shared.Items[ingredient4] == nil and "Ingredient4" or "", QBCore.Shared.Items[ingredient5] == nil and "Ingredient5" or "" }
        TriggerClientEvent("QBCore:Notify", source, table.concat(missingIngredients, " ") .." doesnt exist.", "error")
    end
    -- infotable.foodtype = foodtype
    
    SaveResourceFile(GetCurrentResourceName(), "json/crafting.json", json.encode(CraftTable), -1)
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
    SaveResourceFile(GetCurrentResourceName(), "json/food.json", json.encode(FoodTable), -1)
    SaveResourceFile(GetCurrentResourceName(), "json/drink.json", json.encode(DrinkTable), -1)
    SaveResourceFile(GetCurrentResourceName(), "json/dessert.json", json.encode(DessertTable), -1)
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