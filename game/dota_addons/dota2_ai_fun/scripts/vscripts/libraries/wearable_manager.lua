-- Library Usage:
-- When spawn unit, use WearableManager:RemoveOriginalWearables(hUnit) to remove it's original wearables
--
-- Modifier_wearable_hider_while_model_changes is a modifier which will hide all wearable when model changes, e.g., hexed by Lion. It should be add to the unit when it is first spawned using hUnit:AddNewModifier(hUnit, nil, "modifier_wearable_hider_while_model_changes", {}).sOriginalModel = "path/to/orginal/model.vmdl". The sOriginalModel field of the modifier should be updated every time the original model of the unit is changed.
--
-- New wearable could be added using WearableManager:AddNewWearable(). It need at least two parameters: the handle of the unit and the index of the wearable in script/items/items_game.txt. A third parameter could be given to change the material group of the wearable. A fourth parameter could be given to specify the particle effects you want to add other than the original particles. More info could be found above the function declaration
--
-- You can remove a wearable by its index in items_game.txt with WearableManager:RemoveWearableByIndex(hUnit, sWearableIndex) or remove all wearable with WearableManager:RemoveAllWearable(hUnit).
--
-- Also, WearableManager:PrintAllPrecaches(hUnit) will print all precaches you need for the wearables the unit has in addon_game_mode.lua file.

_G.GameItems = LoadKeyValues("scripts/items/items_game.txt")

LinkLuaModifier("modifier_wearable_hider_while_model_changes", "libraries/wearable_manager.lua", LUA_MODIFIER_MOTION_NONE)
modifier_wearable_hider_while_model_changes = class({})
function modifier_wearable_hider_while_model_changes:DeclareFunctions()
	return {MODIFIER_EVENT_ON_MODEL_CHANGED}
end

function modifier_wearable_hider_while_model_changes:IsHidden() return true end
function modifier_wearable_hider_while_model_changes:RemoveOnDeath() return false end
function modifier_wearable_hider_while_model_changes:IsPurgable() return false end

function modifier_wearable_hider_while_model_changes:OnModelChanged()
	if not self.sOriginalModel then return end
	local hParent = self:GetParent()
	if self.sOriginalModel == self:GetParent():GetModelName() then	
		for k, v in pairs(hParent.tWearables) do
			v.wearable:RemoveEffects(EF_NODRAW)
			for k1, v1 in pairs(v.particles) do
				
				local hAttach
				if v1.attach_entity == "parent" then
					hAttach = hParent
				else
					hAttach = v.wearable
				end
				v1.particle_index = ParticleManager:CreateParticle(v1.system, v1.attach_type, hAttach)
				if v1.control_points then 
					for k2, v2 in pairs(v1.control_points) do
						ParticleManager:SetParticleControlEnt(v1.particle_index, v2.control_point_index, hAttach, PATTACH_POINT_FOLLOW, v2.attachment, hAttach:GetAbsOrigin(), true)
					end		
				end
			end
		end	
	else
		for k, v in pairs(hParent.tWearables) do
			v.wearable:AddEffects(EF_NODRAW)
			for k1, v1 in pairs(v.particles) do
				ParticleManager:DestroyParticle(v1.particle_index, true)
			end
		end
	end
end



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

function WearableManager:AddNewWearable(hUnit, sWearableIndex, sStyle, tOptionalParticleList)	
-- valve did a small trick, new cosmetics will not load their particles, because their key in visuals are the same. 
-- We could load the particles by ourselves.
-- Addtional Particles should be look like {{attach_entity = "self", system = "path/to/.vpcf", attach_type = SOMETHING_LIKE_PATTACH_CUSTOMORIGIN_FOLLOW ,control_points = {{control_point_index = 0, attachment = 'attachment_in_vmdl_files'}, {control_point_index = 1, attachment = 'another_attachment_in_vmdl_files'}}}}
	sStyle = sStyle or "0"
	if type(sWearableIndex)~="string" or type(sStyle) ~= "string" then
		error("Runtime Error: parameter type dismatch")
	end
	hUnit.tWearables = hUnit.tWearables or {}
	local hWearable
	local sModel
	local tParticles = {}
	if GameItems.items[sWearableIndex].visuals and GameItems.items[sWearableIndex].visuals.styles then
		sModel = GameItems.items[sWearableIndex].visuals.styles[sStyle].model_player or GameItems.items[sWearableIndex].model_player
		hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", {model = sModel})
		hWearable:FollowEntity(hUnit, true)
		if GameItems.items[sWearableIndex].visuals.styles[sStyle].skin then
			hWearable:SetMaterialGroup(tostring(GameItems.items[sWearableIndex].visuals.styles[sStyle].skin))
		end
		for k, v in pairs(GameItems.items[sWearableIndex].visuals) do
			if type(v) == "table" and v.type == "particle_create" and tostring(v.style) == sStyle then
				table.insert(tParticles, {system = v.modifier})
			end
		end
	else
		sModel = GameItems.items[sWearableIndex].model_player
		hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", {model = sModel})
		hWearable:FollowEntity(hUnit, true)
		if GameItems.items[sWearableIndex].visuals then
			for k, v in pairs(GameItems.items[sWearableIndex].visuals) do
				if type(v) == "table" and v.type == "particle_create" then
					table.insert(tParticles, {system = v.modifier})
				end
			end
		end
	end
	
	if tOptionalParticleList then
		tParticles = {}
		for k, v in pairs(tOptionalParticleList) do
			local hAttach
			if v.attach_entity == "parent" then
				hAttach = hUnit
			else
				hAttach = hWearable
			end
			local particle_index = ParticleManager:CreateParticle(v.system, v.attach_type, hAttach)
			if v.control_points then
				for k1, v1 in pairs(v.control_points) do
					ParticleManager:SetParticleControlEnt(particle_index, v1.control_point_index, hAttach, PATTACH_POINT_FOLLOW, v1.attachment, hAttach:GetAbsOrigin(), true)
				end		
			end
			table.insert(tParticles, {particle_index = particle_index, system = v.system, attach_type = v.attach_type, attach_entity = v.attach_entity, control_points = v.control_points})
		end
	else
		for k0, v0 in pairs(GameItems.attribute_controlled_attached_particles) do
			for k1, v1 in pairs(tParticles) do
				if v1.system == v0.system then
					v1.attach_type = self.tAttachPoints[v0.attach_type]
					v1.attach_entity = v0.attach_entity
					local hAttach
					if v1.attach_entity == "parent" then
						hAttach = hUnit
					else
						hAttach = hWearable
					end
					v1.particle_index = ParticleManager:CreateParticle(v1.system, v1.attach_type, hAttach)
					if v0.control_points then 
						v1.control_points = v0.control_points
						for k2, v2 in pairs(v1.control_points) do
							ParticleManager:SetParticleControlEnt(v1.particle_index, v2.control_point_index, hAttach, PATTACH_POINT_FOLLOW, v2.attachment, hAttach:GetAbsOrigin(), true)
						end					
					end
				end		
			end
		end
	end
	table.insert(hUnit.tWearables, {wearable = hWearable, style = sStyle, wearable_index = sWearableIndex, particles = tParticles, model = sModel})	
end

function WearableManager:RemoveWearableByIndex(hUnit, sWearableIndex)
	if not hUnit.tWearables then return end
	for k, v in pairs(hUnit.tWearables) do
		if v.wearable_index == sWearableIndex then
			v.wearable:RemoveSelf()
			for k1, v1 in pairs(v.particles) do 
				ParticleManager:DestroyParticle(v1.particle_index, true)
			end
			table.remove(hUnit.tWearables, k)
			break
		end
	end
end

function WearableManager:RemoveAllWearable(hUnit)
	if not hUnit.tWearables then return end
	local iWearableCount = #hUnit.tWearables 
	for i = 0, iWearableCount-1 do
		hUnit.tWearables[iWearableCount-i].wearable:RemoveSelf()
		for k1, v1 in pairs(hUnit.tWearables[iWearableCount-i].particles) do 
			ParticleManager:DestroyParticle(v1.particle_index, true)
		end		
		table.remove(hUnit.tWearables)
	end
end

function WearableManager:PrintAllPrecaches(hUnit)
	if not hUnit.tWearables then return end
	for i = 1, #hUnit.tWearables do
		print("PrecacheModel('"..hUnit.tWearables[i].model.."', context)")
		for k1, v1 in pairs(hUnit.tWearables[i].particles) do 
			print("PrecacheResource('particle', '"..v1.system.."', context)")
		end	
	end
end

function WearableManager:RemoveOriginalWearables(hUnit)
	for i, v in pairs(hUnit:GetChildren()) do
		if v:GetClassname() == 'dota_item_wearable' then
			v:RemoveSelf()
		end
	end
end