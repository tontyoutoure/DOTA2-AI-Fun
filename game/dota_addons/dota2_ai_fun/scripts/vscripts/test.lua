
hHero = PlayerResource:GetPlayer(0):GetAssignedHero()
count = 0
for i = 0, 23 do
	if hHero:GetAbilityByIndex(i) then print(hHero:GetAbilityByIndex(i):GetName())
	count = count+1
	end
end

print(count)