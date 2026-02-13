fx_version 'adamant'

game 'gta5'
author 'Lyds'
description 'ATM Robbery Script'
version '1.0.0'

client_scripts {
  '@okokBanking/config.lua',
  'client.lua',
}

server_scripts {
  'server.lua'
}

dependencies {
  'qb-core',
  'ps-ui',
  'ox_target',
  'okokBanking'
}