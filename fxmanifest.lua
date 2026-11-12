fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

name 'gldnrmz-smallresources'
description 'Collection of small, toggleable gameplay tweaks'
author 'gldnrmz'
version '2.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'client/utils.lua',   -- must load before the feature files
    'client/cl_*.lua',
}

server_scripts {
    'server/*.lua',
}

dependencies {
    'ox_lib',
    'qbx_core',
}
