
hHero = PlayerResource:GetPlayer(0):GetAssignedHero()
--[[
tChildren = hHero:GetChildren()
for i, v in pairs(tChildren) do
	print(v:GetName(), v:GetClassname())
	if v:GetClassname() == 'dota_item_wearable' then
		v:RemoveSelf()
	end
end


hBack = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/invoker/magus_apex/magus_apex.vmdl"})
hBack:FollowEntity(hHero, true)
]]--
--hBack:RemoveEffects(EF_NODRAW)

WearableManager:AddNewWearables(hHero, "98", "0")	
WearableManager:AddNewWearables(hHero, "7986", "1")	
WearableManager:AddNewWearables(hHero, "7979", "0")	
WearableManager:AddNewWearables(hHero, "7987", "0")	
WearableManager:AddNewWearables(hHero, "7988", "0")	
WearableManager:AddNewWearables(hHero, "7989", "0")	

--[[
WearableManager:RemoveWearableByIndex(hHero, "98")
WearableManager:RemoveWearableByIndex(hHero, "7986")
WearableManager:RemoveWearableByIndex(hHero, "7979")
WearableManager:RemoveWearableByIndex(hHero, "7987")
WearableManager:RemoveWearableByIndex(hHero, "7988")
WearableManager:RemoveWearableByIndex(hHero, "7989")
]]--