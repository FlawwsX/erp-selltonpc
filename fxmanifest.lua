fx_version 'adamant'
game 'gta5'
description 'Optimized sell drugs to NPC'
version '1.0.4'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/server.lua',
    'config.lua'
}

client_scripts {
    'client/client.lua',
    'config.lua'
}
