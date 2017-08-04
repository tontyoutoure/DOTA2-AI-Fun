
hHero = PlayerResource:GetPlayer(0):GetAssignedHero()
hHero1 = PlayerResource:GetPlayer(1):GetAssignedHero()
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
--[[
hHero:SetModel('models/heroes/juggernaut/juggernaut_arcana.vmdl')
WearableManager:RemoveOriginalWearables(hHero)
WearableManager:RemoveAllWearable(hHero)

WearableManager:AddNewWearable(hHero, "4101", "0")	--weapon
WearableManager:AddNewWearable(hHero, "9059", "1")	--head
WearableManager:AddNewWearable(hHero, "4401", "0") --skirt
WearableManager:AddNewWearable(hHero, "8983", "0") --shoulder
WearableManager:AddNewWearable(hHero, "8982", "0") --bracer
print(hHero:GetActivityName(ACT_DOTA_RUN))

WearableManager:RemoveWearableByIndex(hHero, "98")
WearableManager:RemoveWearableByIndex(hHero, "7986")
WearableManager:RemoveWearableByIndex(hHero, "7979")
WearableManager:RemoveWearableByIndex(hHero, "7987")
WearableManager:RemoveWearableByIndex(hHero, "7988")
WearableManager:RemoveWearableByIndex(hHero, "7989")
]]--

hHero:EmitSound("DOTA_Item.AbyssalBlade.Activate")		
iParticle = ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_weapon_shadow/kunkka_weapon_spell_tidebringer_shadow_c.vpcf", PATTACH_POINT_FOLLOW, hHero)
ParticleManager:SetParticleControlEnt(iParticle, 1, hHero1, PATTACH_POINT_FOLLOW, "attach_origin", hHero1:GetAbsOrigin(), true)
iParticle = ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_weapon_shadow/kunkka_weapon_spell_tidebringer_shadow_d.vpcf", PATTACH_POINT_FOLLOW, hHero)
ParticleManager:SetParticleControlEnt(iParticle, 1, hHero1, PATTACH_POINT_FOLLOW, "attach_origin", hHero1:GetAbsOrigin(), true)
iParticle = ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_weapon_shadow/kunkka_weapon_spell_tidebringer_shadow_c.vpcf", PATTACH_POINT_FOLLOW, hHero)
ParticleManager:SetParticleControlEnt(iParticle, 1, hHero1, PATTACH_POINT_FOLLOW, "attach_origin", hHero1:GetAbsOrigin(), true)
iParticle = ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_weapon_shadow/kunkka_weapon_spell_tidebringer_shadow_c.vpcf", PATTACH_POINT_FOLLOW, hHero)
ParticleManager:SetParticleControlEnt(iParticle, 1, hHero1, PATTACH_POINT_FOLLOW, "attach_origin", hHero1:GetAbsOrigin(), true)
iParticle = ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_weapon_shadow/kunkka_weapon_spell_tidebringer_shadow_c.vpcf", PATTACH_POINT_FOLLOW, hHero)
ParticleManager:SetParticleControlEnt(iParticle, 1, hHero1, PATTACH_POINT_FOLLOW, "attach_origin", hHero1:GetAbsOrigin(), true)