# qb-addnewitems
Create Dynamic items on runtime and saves it in json so can be fetched back on restarts

This is WIP and just so that developers have idea on how to create items on runtime.

This is just a basic script with which you can create items on runtime in server and they are saved in json file. This is not a drag and drop resource. This is just to give you an idea of the new adding items on runtime work.

For the script to work, you must be on latest qb-core or have this commit https://github.com/qbcore-framework/qb-core/commit/ae29c94a40b6260b6135603f567a52a4983fb834

Add this block of code on top in inventory/server/main.lua

```lua
RegisterNetEvent('QBCore:Server:UpdateObject', function()
    if source ~= '' then return false end -- Safety check if the event was not called from the server.
    QBCore = exports['qb-core']:GetCoreObject()
end)
```

TODO

- add options to craft the items (Done)
- create 3 seperate json files for items selected before restarts ( done)
- make the new items useable
- check if the item is already in crafting.json (done)