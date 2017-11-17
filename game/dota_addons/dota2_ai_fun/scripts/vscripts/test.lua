hHero = PlayerResource:GetPlayer(0):GetAssignedHero()
print(hHero:GetIdealSpeed())
for i, v in ipairs(hHero:FindAllModifiers()) do
	print(v:GetName())
end



--[[
for i = 0, 23 do
	if hHero:GetAbilityByIndex(i) then
		print(i, hHero:GetAbilityByIndex(i):GetName())
	end
end

--]]