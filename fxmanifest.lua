fx_version 'adamant'

game 'gta5'

description 'NotPixel - Scripts mashed up'

version '1.0.0'

server_scripts {
    '@async/async.lua',
    '@mysql-async/lib/MySQL.lua',
    
    'server/server.lua'
}

client_scripts {
    'client/client.lua'
}