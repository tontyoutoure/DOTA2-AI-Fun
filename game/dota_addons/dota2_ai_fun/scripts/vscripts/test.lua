hHero0 = PlayerResource:GetPlayer(0):GetAssignedHero()
tAbilities = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
for k, v in pairs(tAbilities.siglos_mind_control.AbilitySpecial) do
	print(k, type(k))
	for k1, v1 in pairs(v) do
		print(k1, v1)
	end
end
