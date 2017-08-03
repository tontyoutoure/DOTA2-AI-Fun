


_G.GameItems = LoadKeyValues("scripts/items/items_game.txt")

WearableManager = {}

WearableManager.tAttachPoints = {	
	customorigin = PATTACH_CUSTOMORIGIN,
	customorigin_follow = PATTACH_CUSTOMORIGIN_FOLLOW,
	absorigin = PATTACH_ABSORIGIN,
	absorigin_follow = PATTACH_ABSORIGIN_FOLLOW,
	rootbone_follow = PATTACH_ROOTBONE_FOLLOW,
	renderorigin_follow = PATTACH_RENDERORIGIN_FOLLOW,
	point_follow = PATTACH_POINT_FOLLOW,
	worldorigin = PATTACH_WORLDORIGIN	
}

function WearableManager:AddNewWearables(hHero, sWearableIndex, sStyle)	
	sStyle = sStyle or "0"
	if type(sWearableIndex)~="string" or type(sStyle) ~= "string" then
		error("Runtime Error: parameter type dismatch")
	end
	hHero.tWearables = hHero.tWearables or {}
	local hWearable
	local tParticles = {}
	if GameItems.items[sWearableIndex].visuals and GameItems.items[sWearableIndex].visuals.styles then
		hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", {model = GameItems.items[sWearableIndex].visuals.styles[sStyle].model_player})
		hWearable:FollowEntity(hHero, true)
		hWearable:SetMaterialGroup(tostring(GameItems.items[sWearableIndex].visuals.styles[sStyle].skin))
		for k, v in pairs(GameItems.items[sWearableIndex].visuals) do
			if type(v) == "table" and v.type == "particle_create" and tostring(v.style) == sStyle then
				table.insert(tParticles, {system = v.modifier})
			end
		end
	else
		hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", {model = GameItems.items[sWearableIndex].model_player})
		hWearable:FollowEntity(hHero, true)
		if GameItems.items[sWearableIndex].visuals then
			for k, v in pairs(GameItems.items[sWearableIndex].visuals) do
				if type(v) == "table" and v.type == "particle_create" then
					table.insert(tParticles, {system = v.modifier})
				end
			end
		end
	end
	for k0, v0 in pairs(GameItems.attribute_controlled_attached_particles) do
		for k1, v1 in pairs(tParticles) do
			if v1.system == v0.system then
				v1.attach_type = self.tAttachPoints[v0.attach_type]
				print(v0.attach_type, v1.attach_type, v1.system)
				v1.particle_index = ParticleManager:CreateParticle(v1.system, v1.attach_type, hWearable)
				if v0.control_points then 
					v1.control_points = v0.control_points
					for k2, v2 in pairs(v1.control_points) do
						ParticleManager:SetParticleControlEnt(v1.particle_index, v2.control_point_index, hWearable, PATTACH_POINT_FOLLOW, v2.attachment, hWearable:GetAbsOrigin(), true)
					end					
				end
			end		
		end
	end
	
	table.insert(hHero.tWearables, {wearable = hWearable, style = sStyle, wearable_index = sWearableIndex, particles = tParticles})	
end

function WearableManager:RemoveWearableByIndex(hHero, sWearableIndex)
	if not hHero.tWearables then return end
	for k, v in pairs(hHero.tWearables) do
		if v.wearable_index == sWearableIndex then
			v.wearable:RemoveSelf()
			for k1, v1 in pairs(v.particles) do 
				ParticleManager:DestroyParticle(v1.particle_index, true)
			end
			table.remove(hHero.tWearables, k)
			break
		end
	end
end

function WearableManager:RemoveAllWearable(hHero)
	if not hHero.tWearables then return end
	local iWearableCount = #hHero.tWearables 
	for i = 0, iWearableCount-1 do
		hHero.tWearables[iWearableCount-i].wearable:RemoveSelf()
		for k1, v1 in pairs(hHero.tWearables[iWearableCount-i].particles) do 
			ParticleManager:DestroyParticle(v1.particle_index, true)
		end		
		table.remove(hHero.tWearables)
	end
end