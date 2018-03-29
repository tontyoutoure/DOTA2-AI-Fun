hHero = PlayerResource:GetPlayer(0):GetAssignedHero() 
for k, v in pairs(Entities:FindAllByClassnameWithin("npc_dota_tower",hHero:GetOrigin(), 300)) do
	for k1, v1 in pairs(v:FindAllModifiers()) do
		print(v1:GetName())
	end
end