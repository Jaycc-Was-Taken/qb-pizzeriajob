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


