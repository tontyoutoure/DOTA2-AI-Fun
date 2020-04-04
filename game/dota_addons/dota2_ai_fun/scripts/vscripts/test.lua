
local hHero = PlayerResource:GetPlayer(0):GetAssignedHero()


CustomGameEventManager:Send_ServerToPlayer('0', 'game_option_downloaded', GameMode.tGameOption)