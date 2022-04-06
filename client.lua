QBCore = nil

QBCore = exports["qb-core"]:GetCoreObject()

RegisterNetEvent('QBCore:Client:UpdateObject')
AddEventHandler('QBCore:Client:UpdateObject', function()
    print("Updating Object??")
	QBCore = exports['qb-core']:GetCoreObject()
end)

-- RegisterCommand("createnewitem", function()
    
RegisterNetEvent("qb-addnewitems:client:OpenOwnerMenu", function()
    local bossMenu = {
        {
            header = "Pizzeria Boss Menu",
            isMenuHeader = true
        }
    }
    bossMenu[#bossMenu+1] = {
        header = "Create new Food Item",
        txt = "",
        params = {
            event = "qb-addnewitems:client:CreateNewItem",
        }
    }
    bossMenu[#bossMenu+1] = {
        header = "Set Food Menu",
        txt = "",
        params = {
            event = "qb-addnewitems:client:setMenu",
            args = {
                type = "food"
            },
        }
    }
    bossMenu[#bossMenu+1] = {
        header = "Set Drink Menu",
        txt = "",
        params = {
            event = "qb-addnewitems:client:setMenu",
            args = {
                type = "drink"
            },
        }
    }
    bossMenu[#bossMenu+1] = {
        header = "Set Dessert Menu",
        txt = "",
        params = {
            event = "qb-addnewitems:client:setMenu",
            args = {
                type = "dessert"
            },
        }
    }
    bossMenu[#bossMenu+1] = {
        header = "Craft Menu",
        txt = "",
        params = {
            event = "qb-addnewitems:client:CraftMenu",
        }
    }
    exports['qb-menu']:openMenu(bossMenu)
end)

RegisterNetEvent("qb-addnewitems:client:CraftMenu", function()
    local bossMenu = {
        {
            header = "Craft Menu",
            isMenuHeader = true
        }
    }
    bossMenu[#bossMenu+1] = {
        header = "Craft Food Menu",
        txt = "",
        params = {
            event = "qb-addnewitems:client:craft",
            args = {
                type = "food"
            },
        }
    }
    bossMenu[#bossMenu+1] = {
        header = "Craft Drink Menu",
        txt = "",
        params = {
            event = "qb-addnewitems:client:craft",
            args = {
                type = "drink"
            },
        }
    }
    bossMenu[#bossMenu+1] = {
        header = "Craft Dessert Menu",
        txt = "",
        params = {
            event = "qb-addnewitems:client:craft",
            args = {
                type = "dessert"
            },
        }
    }
    bossMenu[#bossMenu+1] = {
        header = "< Back",
        txt = "",
        params = {
            event = "qb-addnewitems:client:OpenOwnerMenu",
        }
    }
    exports['qb-menu']:openMenu(bossMenu)
end)

RegisterNetEvent("qb-addnewitems:client:craft", function(data)
    local p = promise.new()

    QBCore.Functions.TriggerCallback('qb-addnewitems:server:gettable', function(result)
        p:resolve(result)
    end, data.type)

    local foodTable = Citizen.Await(p)
    local foodMenu = {
        {
            header = data.type,
            isMenuHeader = true
        }
    }
    for k, v in pairs(foodTable) do
        foodMenu[#foodMenu+1] = {
            header = v.label,
            txt = "",
            params = {
                event = "qb-addnewitems:client:craftinput",
                args = {
                    name = v.name,
                    type = data.type,
                },
            }
        }
    end
    exports['qb-menu']:openMenu(foodMenu)
end)

RegisterNetEvent("qb-addnewitems:client:craftinput", function(data)
    local craftinput = exports['qb-input']:ShowInput({
        header = "Enter all the ingredients for "..data.name.. "(Make sure the item name is right)",
        submitText = "Confirm",
        inputs = {
            {
                type = 'text',
                isRequired = true,
                name = 'ingredient1',
                text = 'Ingredient 1'
            },
            {
                type = 'text',
                isRequired = true,
                name = 'ingredient2',
                text = 'Ingredient 2'
            },
            {
                type = 'text',
                isRequired = true,
                name = 'ingredient3',
                text = 'Ingredient 3'
            },
            {
                type = 'text',
                isRequired = true,
                name = 'ingredient4',
                text = 'Ingredient 4'
            },
            {
                type = 'text',
                isRequired = true,
                name = 'ingredient5',
                text = 'Ingredient 5'
            },
        }
    })
    if craftinput then
        if not craftinput.ingredient1 then return end
        if not craftinput.ingredient2 then return end
        if not craftinput.ingredient3 then return end
        if not craftinput.ingredient4 then return end
        if not craftinput.ingredient5 then return end
        TriggerServerEvent("qb-additem:server:addcrafting", data.name, craftinput.ingredient1, craftinput.ingredient2, craftinput.ingredient3, craftinput.ingredient4, craftinput.ingredient5)
    end
end)

RegisterNetEvent("qb-addnewitems:client:setMenu", function(data)
    local p = promise.new()

    QBCore.Functions.TriggerCallback('qb-addnewitems:server:gettable', function(result)
        p:resolve(result)
    end, data.type)

    local foodTable = Citizen.Await(p)

    local testoption = {}
    for k, v in pairs(foodTable) do
        local info = {}
        info.value = v.name
        info.text = v.label
        table.insert(testoption, info)
    end

    local test = exports['qb-input']:ShowInput({
        header = "Select the items",
        submitText = "Confirm",
        inputs =  {
                {
                text = "Select Items", -- text you want to be displayed as a input header
                name = "foodlist", -- name of the input should be unique otherwise it might override
                type = "checkbox", -- type of the input - Check is useful for "AND" options e.g; taxincle = gst AND business AND othertax
                options = testoption
            },
        }
    })
    if test then
        TriggerServerEvent("qb-additem:server:setItems",data.type, test)
    end
end)

RegisterNetEvent("qb-addnewitems:client:OpenStation", function(data)
    local p = promise.new()

    QBCore.Functions.TriggerCallback('qb-addnewitems:server:stationitems', function(result)
        p:resolve(result)
    end, data.station)

    local stationitems = Citizen.Await(p)

    local stationMenu = {
        {
            header = "Pizzeria Station Menu",
            isMenuHeader = true
        }
    }

    for k, v in pairs(stationitems) do
        -- print(QBCore.Shared.Items[v.item].label)
        stationMenu[#stationMenu+1] = {
            
            -- header = QBCore.Shared.Items[v.item].label,
            header = "<img src=nui://qb-inventory/html/images/"..QBCore.Shared.Items[v.item].image.." width=35px>"..QBCore.Shared.Items[v.item].label,
            txt = "</br><img src=nui://qb-inventory/html/images/"..QBCore.Shared.Items[v.ingredient1].image.." width=20px>"..QBCore.Shared.Items[v.ingredient1].label.. "</br>".."<img src=nui://qb-inventory/html/images/"..QBCore.Shared.Items[v.ingredient2].image.." width=20px>".. QBCore.Shared.Items[v.ingredient2].label..  "</br>".."<img src=nui://qb-inventory/html/images/"..QBCore.Shared.Items[v.ingredient3].image.." width=20px>".. QBCore.Shared.Items[v.ingredient3].label.. "</br>".."<img src=nui://qb-inventory/html/images/"..QBCore.Shared.Items[v.ingredient4].image.." width=20px>".. QBCore.Shared.Items[v.ingredient4].label..  "</br>".."<img src=nui://qb-inventory/html/images/"..QBCore.Shared.Items[v.ingredient5].image.." width=20px>".. QBCore.Shared.Items[v.ingredient5].label,
            -- txt = v.ingredient1,
            params = {
                event = "qb-addnewitems:client:CraftItems",
                args = {
                    station = data.station,
                    progressbartext = Config.ProgressBarName[data.station],
                    item = v.item,
                    required = {
                        v.ingredient1,
                        v.ingredient2,
                        v.ingredient3,
                        v.ingredient4,
                        v.ingredient5,
                    }
                }
            }
        }
    end
    exports['qb-menu']:openMenu(stationMenu)
end)

RegisterNetEvent("qb-addnewitems:client:CraftItems", function(data)
    QBCore.Functions.TriggerCallback("qb-addnewitems:server:get:ingredient", function(HasItems)
        if HasItems then
            local ped = PlayerPedId()
            local playerPed = PlayerPedId()
            LoadAnim(Config.Animation[data.station].dict)
            TaskPlayAnim(ped, Config.Animation[data.station].dict, Config.Animation[data.station].animname, 6.0, -6.0, -1, 46, 0, 0, 0, 0)
            FreezeEntityPosition(playerPed, true)
                QBCore.Functions.Progressbar("cutting_station", data.progressbartext , 10000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done    
                
                ClearPedTasksImmediately(ped)
                FreezeEntityPosition(playerPed, false)
            TriggerServerEvent('qb-addnewitems:server:cook', data.required, data.item)
            end)
        else
            QBCore.Functions.Notify("You don\'t have all the ingredients!", "error")
        end
    end, data.required)
end)

RegisterNetEvent("qb-addnewitems:client:CreateNewItem", function()
    local item = exports['qb-input']:ShowInput({
        header = "Enter the name of the item",
        submitText = "Confirm",
        inputs = {
            {
                type = 'text',
                isRequired = true,
                name = 'itemname',
                text = 'Item Name'
            },
            {
                type = 'text',
                isRequired = true,
                name = 'label',
                text = 'Label'
            },
            {
                type = 'number',
                isRequired = true,
                name = 'weight',
                text = 'Weight'
            },
            {
                type = 'text',
                isRequired = true,
                name = 'image',
                text = 'Image'
            },
            {
                type = 'text',
                isRequired = true,
                name = 'description',
                text = 'Description'
            },
            {
                text = "Food Type", -- text you want to be displayed as a input header
                name = "foodtype", -- name of the input should be unique otherwise it might override
                type = "radio", -- type of the input - Radio is useful for "or" options e.g; billtype = Cash OR Bill OR bank
                options = { -- The options (in this case for a radio) you want displayed, more than 6 is not recommended
                    { value = "drink", text = "Drink" }, -- Options MUST include a value and a text option
                    { value = "food", text = "Food" }, -- Options MUST include a value and a text option
                    { value = "dessert", text = "Dessert" }, -- Options MUST include a value and a text option
                }
            },
        }
    })
    if item then
        if not item.itemname then return end
        if not item.label then return end
        if not item.weight then return end
        if not item.image then return end
        if not item.description then return end
        if not item.foodtype then return end
        TriggerServerEvent("qb-additem:server:additem", item.itemname, item.label, item.weight, item.image, item.description, item.foodtype)
    end
end)

function LoadAnim(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end