fx_version 'cerulean'
game 'gta5'

name         'qb-decay'
author       'Joe Szymkowicz'
version      '0.0.3'

lua54 'yes'

dependencies {
	"cron",
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
    	'config.lua',
	'server/main.lua'
}
