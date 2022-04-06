fx_version 'cerulean'
game 'gta5'

description 'QB-add items'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'config.lua'
}

client_scripts {
    'client.lua',
    'zones.lua',
    'cl_useableitems.lua'
}

server_scripts {
    'server.lua'
}


