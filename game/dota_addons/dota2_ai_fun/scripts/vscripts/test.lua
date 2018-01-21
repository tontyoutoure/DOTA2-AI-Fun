hHero = PlayerResource:GetPlayer(0):GetAssignedHero()
for k, v in pairs(Entities:FindAllInSphere(hHero:GetOrigin(), 400)) do
	if v:GetName() == "npc_dota_warlock_golem" then
		for k1, v1 in pairs(v:FindAllModifiers()) do
			print(v1:GetName())
		end
	end
end
--[[
for i = 0, 23 do
	if hHero:GetAbilityByIndex(i) then
		print(i, hHero:GetAbilityByIndex(i):GetName())
	end
end

--]]