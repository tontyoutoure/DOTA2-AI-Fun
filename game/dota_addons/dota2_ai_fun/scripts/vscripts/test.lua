hHero = PlayerResource:GetPlayer(1):GetAssignedHero()
for k, v in ipairs(Entities:FindAllInSphere(hHero:GetOrigin(), 400)) do
	
	if v:GetClassname() == "dota_item_drop" then print((v:GetOrigin()-hHero:GetOrigin()):Length2D()) hHero:PickupDroppedItem(v) end
end

--[[
for i = 0, 23 do
	if hHero:GetAbilityByIndex(i) then
		print(i, hHero:GetAbilityByIndex(i):GetName())
	end
end

--]]