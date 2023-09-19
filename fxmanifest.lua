fx_version 'cerulean'
game 'gta5'

name         'qb-decay'
author       'Joe Szymkowicz'
version      '0.0.4'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
    	'config.lua',
	'server/main.lua'
}
