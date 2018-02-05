hHero = PlayerResource:GetPlayer(0):GetAssignedHero()
for k, v in pairs(hHero:FindAllModifiers()) do
	if v.GetPriority then print(v:GetPriority()) end
end