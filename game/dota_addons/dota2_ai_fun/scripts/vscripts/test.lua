
SendToServerConsole("dota_create_unit npc_dota_hero_spirit_breaker")
SendToServerConsole("dota_create_unit npc_dota_hero_enigma")
SendToServerConsole("dota_create_unit npc_dota_hero_beastmaster")
SendToServerConsole("dota_create_unit npc_dota_hero_arc_warden")
SendToServerConsole("dota_create_unit npc_dota_hero_windrunner")
SendToServerConsole("dota_create_unit npc_dota_hero_sven")
SendToServerConsole("dota_create_unit npc_dota_hero_disruptor")
SendToServerConsole("dota_create_unit npc_dota_hero_wisp")
SendToServerConsole("dota_create_unit npc_dota_hero_treant")
SendToServerConsole("dota_create_unit npc_dota_hero_brewmaster")
SendToServerConsole("dota_create_unit npc_dota_hero_night_stalker")
SendToServerConsole("dota_create_unit npc_dota_hero_shadow_demon")
SendToServerConsole("dota_create_unit npc_dota_hero_techies")
SendToServerConsole("dota_create_unit npc_dota_hero_tinker")
SendToServerConsole("dota_create_unit npc_dota_hero_visage")
SendToServerConsole("dota_create_unit npc_dota_hero_rubick")
SendToServerConsole("dota_create_unit npc_dota_hero_pugna")
hHero = PlayerResource:GetPlayer(0):GetAssignedHero()
--[[
for i = 0, 23 do
	if hHero:GetAbilityByIndex(i) then
		print(i, hHero:GetAbilityByIndex(i):GetName())
	end
end

--]]