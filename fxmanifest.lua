fx_version 'adamant'

game 'gta5'

description 'NotPixel - Optimized sell weed to NPC'

version '1.0.2'

server_scripts {
    '@async/async.lua',
    '@mysql-async/lib/MySQL.lua',
    
    'server/server.lua',
    'config.lua'
}

client_scripts {
    'client/client.lua',
    'config.lua'
}
