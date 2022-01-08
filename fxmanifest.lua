fx_version 'cerulean'
game 'gta5'

name         'qb-decay'
author       'Joe Szymkowicz'
version      '0.0.1'

lua54 'yes'

dependencies {
	"cron",
}

server_scripts {
    'config.lua',
	'server/main.lua'
}