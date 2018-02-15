hHero = PlayerResource:GetPlayer(1):GetAssignedHero()
for i = 0, 23 do
	if hHero:GetAbilityByIndex(i) then
		print(hHero:GetAbilityByIndex(i):GetName(), hHero:GetAbilityByIndex(i):GetLevel())
	end
end