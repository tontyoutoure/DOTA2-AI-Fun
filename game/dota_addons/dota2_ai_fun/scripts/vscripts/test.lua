hHero = PlayerResource:GetPlayer(0):GetAssignedHero()
tTest = Entities:FindAllByName("npc_dota_ward_base")
for i, v in ipairs(tTest) do
print(v:GetOwner():GetPlayerID())
end
--[[
for i = 0, 23 do
	if hHero:GetAbilityByIndex(i) then
		print(i, hHero:GetAbilityByIndex(i):GetName())
	end
end

--]]