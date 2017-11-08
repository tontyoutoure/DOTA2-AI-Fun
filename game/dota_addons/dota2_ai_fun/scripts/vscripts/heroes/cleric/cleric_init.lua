LinkLuaModifier("modifier_cleric_magic_mirror", "heroes/cleric/cleric_modifiers.lua", LUA_MODIFIER_MOTION_NONE)


function ClericTalentManager(keys)
	if PlayerResource:GetPlayer(keys.player-1):GetAssignedHero():GetName() ~= "npc_dota_hero_rubick" then return end
	local hHero = PlayerResource:GetPlayer(keys.player-1):GetAssignedHero()
	print("hoho")
	if keys.abilityname == "special_bonus_cleric_5" then
		local iLevel = hHero:FindAbilityByName("cleric_berserk"):GetLevel()
		hHero:RemoveAbility("cleric_berserk")
		hHero:AddAbility("cleric_berserk_aoe"):SetLevel(iLevel)
	end
end

ListenToGameEvent( "dota_player_learned_ability", ClericTalentManager, nil )

function ClericInit(hHero, context)
	if hHero:IsRealHero() then
		local hMagicMirror = hHero:FindAbilityByName("cleric_magic_mirror")
		hHero:AddNewModifier(hHero, hMagicMirror, "modifier_cleric_magic_mirror", {})
	end	
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_cleric", {})	
end