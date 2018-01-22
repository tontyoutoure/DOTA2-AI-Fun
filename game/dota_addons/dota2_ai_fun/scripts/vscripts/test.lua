hHero = PlayerResource:GetPlayer(0):GetAssignedHero()
PrintAllModifiers(0)
PrintAllAbilities(0)

--[[
for i = 0, 23 do
	if hHero:GetAbilityByIndex(i) then
		print(i, hHero:GetAbilityByIndex(i):GetName())
	end
end

--]]