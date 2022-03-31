exports["qb-target"]:AddBoxZone("pizzeria_laptop",vector3(797.13, -751.51, 31.27), 0.6, 1, {
    name="pizzeria_laptop",
    heading=101,
    --debugPoly=true,
    minZ=27.47,
    maxZ=31.47
},{
    options = {
        {
            event = "qb-addnewitems:client:OpenOwnerMenu",
            icon = "fas fa-laptop",
            label = "Item Creation",
            -- job = ""

        },
    },
    distance = 2.5
})

exports["qb-target"]:AddBoxZone("foodstation",vector3(809.28, -761.17, 26.78), 1, 1, {
    name="foodstation",
    heading=0,
    --debugPoly=true,
    minZ=23.18,
    maxZ=27.18
},{
    options = {
        {
            event = "qb-addnewitems:client:OpenStation",
            icon = "fas fa-laptop",
            label = "Food Station",
            station = "food"
            -- job = ""

        },
    },
    distance = 2.5
})

exports["qb-target"]:AddBoxZone("drinkstation",vector3(808.86, -765.37, 26.78), 0.9, 0.5, {
    name="drinkstation",
    heading=275,
    --debugPoly=true,
    minZ=23.38,
    maxZ=27.38
},{
    options = {
        {
            event = "qb-addnewitems:client:OpenStation",
            icon = "fas fa-laptop",
            label = "Drink Station",
            station = "drink"
            -- job = ""

        },
    },
    distance = 2.5
})
