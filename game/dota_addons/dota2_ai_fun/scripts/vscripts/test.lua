hHero = PlayerResource:GetPlayer(0):GetAssignedHero() 
for k, v in ipairs(hHero:FindAllModifiers()) do print(v:GetName()) end