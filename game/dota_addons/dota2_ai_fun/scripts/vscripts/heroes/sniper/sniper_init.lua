local function SniperScepterThinkerApplier(keys)
	local hHero = PlayerResource:GetPlayer(keys.player-1):GetAssignedHero()
	if keys.abilityname == "sniper_assassinate" then
		hHero:AddNewModifier(hHero, nil, "modifier_sniper_assassinate_thinker", {})		
	end
end
function SniperInit(hHero, context)
	if not GameMode.bSniperScepterThinkerApplierSet then
		ListenToGameEvent( "dota_player_learned_ability", SniperScepterThinkerApplier, nil )
		GameMode.bSniperScepterThinkerApplierSet = true
	end
end