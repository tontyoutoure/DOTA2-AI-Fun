-- Library Usage:
-- When spawn unit, use WearableManager:RemoveOriginalWearables(hUnit) to remove it's original wearables
--
-- Modifier_wearable_hider_while_model_changes is a modifier which will hide all wearable when model changes, e.g., hexed by Lion. It should be add to the unit when it is first spawned using hUnit:AddNewModifier(hUnit, nil, "modifier_wearable_hider_while_model_changes", {}).sOriginalModel = "path/to/orginal/model.vmdl". The sOriginalModel field of the modifier should be updated every time the original model of the unit is changed.
--
-- New wearable could be added using WearableManager:AddNewWearable(). It accept two parameters: the handle of the unit and a table contains information of the wearable. 
-- If the library works in tools mode, it will load the items_game.txt file, which contains information of the wearables. The second parameter could be as simple as {ID = "12345"}. If the wearable has multiple style, you could specify it like {ID = "12345", style = "1"}. Generally speaking this will be sufficient to load the wearable and it's particles. However for new cosmetics, Valve somewhat hide their particle information. You will have to add particle information by yourself. The format of the second parameter will then become {ID = "12345", style(optional) = "1", particle_systems = {{system = "path/to/.vpcf", attach_type = SOMETHING_LIKE_PATTACH_CUSTOMORIGIN_FOLLOW, attach_entity(optional, default value is "self", which means it will attach to the wearable. If this value is "parent", it will attach to parent) = "parent" ,control_points(optional) = {{control_point_index = 0, attach_type(optional, default value is PATTACH_POINT_FOLLOW) = SOMETHING_LIKE_PATTACH_POINT_FOLLOW, attachment(optional) = "the_attachment_name_in_model_file"}, {(other control points)}}}, {(other systems)}}}. Notice in this scenario, you have to dig how to add the particles. The items_game.txt file itself contains particles the wearable uses (just cannot be load into lua), you can test them by yourself. After adding new variable, it's information will be stored in the hUnit.tWearables table.
-- You can remove an added wearable by its index in items_game.txt with WearableManager:RemoveWearableByIndex(hUnit, sID) or remove all wearable with WearableManager:RemoveAllWearable(hUnit).
-- After successfully add a wearable, you can output the information about the variable so you can use them in non-tools mode so you don't have to load the big-ass items_game.txt file into your vscript system during playtime. Information of a single wearable could be WearableManager:PrintWearableInfo(tWearableInfo). tWearableInfo is a element in the hUnit.tWearables table. A second parameter could be added to specify the output file handle. A third parameter could be added to specify the nesting level (default is 0). You can also output all wearable infos on a unit by using WearableManager:PrintAllWearableInfos(hUnit, hFile, iNestLevel). The output info table could be directly used by WearableManager:AddNewWearable() without loading items_game.txt
--
-- Also, WearableManager:PrintAllPrecaches(hUnit) will print precaches you need for the wearables the unit has in addon_game_mode.lua file. Notice that some cosmetics (like arcana) contains particles not with type of "particle_create", and these particles may be called by a special animation of the model. In order not to get bunch of red crosses when these animation happenes, you will have to precache these particles as well.

if IsInToolsMode() then _G.GameItems = LoadKeyValues("scripts/items/items_game.txt") end
--_G.GameItems = LoadKeyValues("scripts/items/items_game.txt")

local INDENT = '\t'

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
			for k1, v1 in pairs(v.particle_systems) do
				
				local hAttach
				if v1.attach_entity == "parent" then
					hAttach = hParent
				else
					hAttach = v.wearable
				end
				v1.particle_index = ParticleManager:CreateParticle(v1.system, v1.attach_type, hAttach)
				if v1.control_points then 
					for k2, v2 in pairs(v1.control_points) do
						ParticleManager:SetParticleControlEnt(v1.particle_index, v2.control_point_index, hAttach, v2.attach_type, v2.attachment, hAttach:GetAbsOrigin(), true)
					end		
				end
			end
		end	
	else
		for k, v in pairs(hParent.tWearables) do
			v.wearable:AddEffects(EF_NODRAW)
			for k1, v1 in pairs(v.particle_systems) do
				ParticleManager:DestroyParticle(v1.particle_index, true)
			end
		end
	end
end

WearableManager = {}
WearableManager.tAttachTypesReverse = {}
for k, v in pairs(_G) do
	if string.sub(k, 1, 7) == "PATTACH" then
		WearableManager.tAttachTypesReverse[v] = k
	end
end

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

function WearableManager:AddParticleSystem(hWearable, hUnit, hParticleSystem)
	local hBaseAttach
	--find base attach
	if hParticleSystem.attach_entity == "parent" then
		hBaseAttach = hUnit
	else
		hBaseAttach = hWearable
	end
	local particle_index = ParticleManager:CreateParticle(hParticleSystem.system, hParticleSystem.attach_type, hBaseAttach)
	
	for k, v in hParticleSystem.control_points do
		local hAttach = v.attach_entity or hBaseAttach
	end
	
	return particle_index
end


function WearableManager:AddNewWearable(hUnit, tInput)		
	hUnit.tWearables = hUnit.tWearables or {}	
	
	local hWearable
	local sModel = tInput.model
	local sSkin = tInput.skin
	local tOptionalParticleList = tInput.particle_systems
	local sID = tInput.ID
	local sStyle = tInput.style or "0"	
	local tParticles = {}
	
	if sModel then
		hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", {model = sModel})
		hWearable:FollowEntity(hUnit, true)
		if sSkin then 
			hWearable:SetMaterialGroup(sSkin)
		end
	else	
		if GameItems.items[sID].visuals and GameItems.items[sID].visuals.styles then
			sModel = GameItems.items[sID].visuals.styles[sStyle].model_player or GameItems.items[sID].model_player
			hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", {model = sModel})
			hWearable:FollowEntity(hUnit, true)
			
			if GameItems.items[sID].visuals.styles[sStyle].skin then
				sSkin = tostring(GameItems.items[sID].visuals.styles[sStyle].skin)
				hWearable:SetMaterialGroup(sSkin)
			end
			for k, v in pairs(GameItems.items[sID].visuals) do
				if type(v) == "table" and v.type == "particle_create" and tostring(v.style) == sStyle then
					table.insert(tParticles, {system = v.modifier})
				end
			end
		else
			sModel = GameItems.items[sID].model_player
			hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", {model = sModel})
			hWearable:FollowEntity(hUnit, true)
			if GameItems.items[sID].visuals then
				for k, v in pairs(GameItems.items[sID].visuals) do
					if type(v) == "table" and v.type == "particle_create" then
						table.insert(tParticles, {system = v.modifier})
					end
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
					v1.attach_type = v1.attach_type or PATTACH_POINT_FOLLOW
					ParticleManager:SetParticleControlEnt(particle_index, v1.control_point_index, hAttach, v1.attach_type, v1.attachment, hAttach:GetAbsOrigin(), true)
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
							v2.attach_type = self.tAttachPoints[v2.attach_type]
							ParticleManager:SetParticleControlEnt(v1.particle_index, v2.control_point_index, hAttach, v2.attach_type, v2.attachment, hAttach:GetAbsOrigin(), true)
						end					
					end
				end		
			end
		end
	end
	table.insert(hUnit.tWearables, {wearable = hWearable, style = sStyle, ID = sID, particle_systems = tParticles, model = sModel, skin = sSkin})	
end

function WearableManager:RemoveWearableByIndex(hUnit, sID)
	if not hUnit.tWearables then return end
	for k, v in pairs(hUnit.tWearables) do
		if v.ID == sID then
			v.wearable:RemoveSelf()
			for k1, v1 in pairs(v.particle_systems) do 
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
		for k1, v1 in pairs(hUnit.tWearables[iWearableCount-i].particle_systems) do 
			ParticleManager:DestroyParticle(v1.particle_index, true)
		end		
		table.remove(hUnit.tWearables)
	end
end

function WearableManager:PrintAllPrecaches(hUnit)
	if not hUnit.tWearables then return end
	for i = 1, #hUnit.tWearables do
		print("PrecacheModel('"..hUnit.tWearables[i].model.."', context)")
		for k1, v1 in pairs(hUnit.tWearables[i].particle_systems) do 
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

function WearableManager:PrintWearableInfo(hWearableEntity, hFile, iNestLevel, bPrintComma)
	iNestLevel = iNestLevel or 0
	local sStart = '{ID = "'..hWearableEntity.ID..'", style = "' ..hWearableEntity.style..'", model = "'..hWearableEntity.model..'", '
	local sSkin
	if hWearableEntity.skin then
		sSkin = 'skin = "'..hWearableEntity.skin..'", '
	else
		sSkin = ''
	end
	local sParticles = 'particle_systems = {'
	if #hWearableEntity.particle_systems ~= 0 then
		for k, v in pairs(hWearableEntity.particle_systems) do
			local sParticle = '{system = "'..v.system..'", attach_type = '..self.tAttachTypesReverse[v.attach_type]..', '
			if v.attach_entity then sParticle = sParticle..'attach_entity = "'..v.attach_entity..'", ' end
			if v.control_points then
				local sControlPoints = 'control_points = {'
				for k1, v1 in pairs(v.control_points) do
					sControlPoints = sControlPoints..'{control_point_index = '..tostring(v1.control_point_index)..', attach_type = '..self.tAttachTypesReverse[v1.attach_type]..', '
					if v1.attachment then sControlPoints = sControlPoints..'attachment = "'..v1.attachment..'"' end
					sControlPoints = sControlPoints..'}, '
				end
				sControlPoints = sControlPoints..'}'
				sParticle = sParticle..sControlPoints
			end			
			sParticle =  sParticle ..'}, '
			sParticles = sParticles..sParticle
		end		
	end
	sParticles = sParticles..'}'
	local sEnd = '}'
	
	local sOut = sStart..sSkin..sParticles..sEnd
	
	if bPrintComma then sOut = sOut..',' end
	if hFile then
		hFile:write(string.rep(INDENT, iNestLevel)..sOut..'\n')
	else
		print(string.rep(INDENT, iNestLevel)..sOut)
	end	
end

function WearableManager:PrintAllWearableInfos(hUnit, hFile, iNestLevel)
	iNestLevel = iNestLevel or 0
	if hFile then
		hFile:write(string.rep(INDENT, iNestLevel)..'{\n')
	else
		print(string.rep(INDENT, iNestLevel)..'{')
	end	
	for i = 1, #hUnit.tWearables do
		self:PrintWearableInfo(hUnit.tWearables[i], hFile, iNestLevel+1, true)
	end
	if hFile then
		hFile:write(string.rep(INDENT, iNestLevel)..'}\n')
	else
		print(string.rep(INDENT, iNestLevel)..'}')
	end	
end
















