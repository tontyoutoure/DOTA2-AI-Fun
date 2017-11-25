hHero = PlayerResource:GetPlayer(0):GetAssignedHero()
for k, v in ipairs(Entities:FindAllInSphere(hHero:GetOrigin(), 400)) do	
	if v.GetModelName then print(v:GetModelName()) end
end

--[[
for i = 0, 23 do
	if hHero:GetAbilityByIndex(i) then
		print(i, hHero:GetAbilityByIndex(i):GetName())
	end
end

--]]