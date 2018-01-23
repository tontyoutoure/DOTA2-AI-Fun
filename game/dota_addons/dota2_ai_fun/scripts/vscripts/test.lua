hHero = PlayerResource:GetPlayer(0):GetAssignedHero()
print(Time())
print(GameRules:GetGameTime())

--[[
for i = 0, 23 do
	if hHero:GetAbilityByIndex(i) then
		print(i, hHero:GetAbilityByIndex(i):GetName())
	end
end

--]]