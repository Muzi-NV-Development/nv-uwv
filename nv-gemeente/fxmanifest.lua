-- Resource Metadata
fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author '🌀| TheMuzi.nl#5677'
version '1.0.0'

client_scripts {
    'client.lua',
    'config.lua'
}
server_scripts {
    'server.lua',
    'config.lua',
    '@oxmysql/lib/MySQL.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/style.css',
	'html/script.js',
	'html/reset.css'
}

