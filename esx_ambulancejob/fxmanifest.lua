fx_version 'adamant'

game 'gta5'

description 'ESX Ambulance Job'

version '1.7.5'

shared_scripts { 
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua'
}


server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}

client_scripts {
	'client/main.lua',
	'client/job.lua',
	'client/vehicle.lua',
}

dependencies {
	'es_extended',
	'esx_skin',
	'esx_vehicleshop'
}


ui_page "html/index.html"

files {
    "html/index.html",
    "html/style.css",
    "html/script.js",
    'html/HarmoniaSansProCyr-Bold.ttf',
	'html/HarmoniaSansProCyr-Light.ttf',
	'html/HarmoniaSansProCyr-Regular.ttf'
}


exports {
	'openAmbulance',
	'OpenMobileAmbulanceActionsMenu',
	'IsPlayerDead',
	'IsPedDead'
  }
  export "startUI"