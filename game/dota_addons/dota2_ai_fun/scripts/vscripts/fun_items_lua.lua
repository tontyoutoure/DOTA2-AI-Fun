LinkLuaModifier("modifier_item_fun_sprint_shoes_lua", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_sprint_shoes_lua_vision", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_escutcheon_lua", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_escutcheon_reincarnate_protection_hooker", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_escutcheon_reincarnate_protection", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_ragnarok_lua", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_ban_regen", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_ragnarok_2_lua", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_ragnarok_ultra_maim", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_terra_blade", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_terra_blade_ultra_maim", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_papyrus_scarab", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_papyrus_scarab_aura_emitter_1", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_papyrus_scarab_aura_emitter_2", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_papyrus_scarab_aura_emitter_3", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_papyrus_scarab_aura_1", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_papyrus_scarab_aura_2", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_papyrus_scarab_aura_3", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_bs", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_tree_planting_suite", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)

local tClassFunItems = {}
item_fun_sprint_shoes = class(tClassFunItems)

function item_fun_sprint_shoes:GetIntrinsicModifierName()
	return "modifier_item_fun_sprint_shoes_lua"
end

function item_fun_sprint_shoes:GetChannelTime()
	if IsClient() or (self:GetCursorPosition()-self:GetCaster():GetOrigin()):Length2D() > self:GetSpecialValueFor("blink_distance") or self.hModifier:GetStackCount() > 0 then
		return self:GetSpecialValueFor("channel_time")
	else
		return 0
	end
end 

function item_fun_sprint_shoes:GetAbilityTextureName(keys) 
	if self.hModifier and not self.hModifier:IsNull() and self.hModifier:GetStackCount() > 0 then
		return "item_fun_sprint_shoes_broken"
	end
	return "item_fun_sprint_shoes"
end

function item_fun_sprint_shoes:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorPosition() 
	if (caster:GetOrigin()-target):Length2D() < self:GetSpecialValueFor("blink_distance") and self.hModifier:GetStackCount() == 0 and not caster:IsRooted() then	
		EmitSoundOnLocationWithCaster(caster:GetOrigin(), "Hero_Wisp.TeleportIn.Arc", caster)
		ParticleManager:SetParticleControl(ParticleManager:CreateParticle("particles/econ/items/wisp/wisp_relocate_teleport_ti7.vpcf", PATTACH_ABSORIGIN, caster), 0, caster:GetOrigin())
		ProjectileManager:ProjectileDodge(caster)
		FindClearSpaceForUnit(caster, target, true) 
		EmitSoundOnLocationWithCaster(target, "Hero_Wisp.TeleportOut.Arc", caster)
		local iParticle = ParticleManager:CreateParticle("particles/econ/items/wisp/wisp_relocate_teleport_ti7_out.vpcf", PATTACH_WORLDORIGIN, nil) 
		ParticleManager:SetParticleControl(iParticle, 0, target) 
		return	
	end
	StartAnimation(caster, {activity = ACT_DOTA_TELEPORT, duration = self:GetSpecialValueFor("channel_time"), rate = 3/self:GetSpecialValueFor("channel_time")})
	caster:EmitSound("Hero_Wisp.Relocate.Arc")
	self.iParticle2 = ParticleManager:CreateParticle("particles/econ/items/wisp/wisp_relocate_channel_ti7.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(self.iParticle2, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", caster:GetOrigin(), true)
	
	self.hTarget = CreateUnitByName("npc_dummy_unit", target, false, caster, caster, caster:GetTeamNumber())
	self.hTarget:EmitSound("Hero_Wisp.Relocate.Arc")
	AddFOWViewer(caster:GetTeamNumber(), target, 100, 2, false)
	self.iParticle1 = ParticleManager:CreateParticle("particles/econ/items/wisp/wisp_relocate_marker_ti7_endpoint.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(self.iParticle1, 0, target)
end

function item_fun_sprint_shoes:OnChannelFinish(bInterrupted)
	
	local caster = self:GetCaster()
	local target = self:GetCursorPosition()	
	caster:StopSound("Hero_Wisp.Relocate.Arc")
	self.hTarget:StopSound("Hero_Wisp.Relocate.Arc")
	if self.iParticle1 then
		ParticleManager:DestroyParticle(self.iParticle1, false)
		ParticleManager:DestroyParticle(self.iParticle2, false)
	end
	UTIL_Remove(self.hTarget)
	EndAnimation(caster)
	StartAnimation(caster, {activity = ACT_DOTA_TELEPORT_END, duration = 0.75, rate=1.5})
	
	if bInterrupted then return end 
	EmitSoundOnLocationWithCaster(caster:GetOrigin(), "Hero_Wisp.TeleportIn.Arc", caster)
	ParticleManager:SetParticleControl(ParticleManager:CreateParticle("particles/econ/items/wisp/wisp_relocate_teleport_ti7.vpcf", PATTACH_ABSORIGIN, caster), 0, caster:GetOrigin())
	ProjectileManager:ProjectileDodge(caster)
	FindClearSpaceForUnit(caster, target, true)
	EmitSoundOnLocationWithCaster(target, "Hero_Wisp.TeleportOut.Arc", caster)
	local iParticle = ParticleManager:CreateParticle("particles/econ/items/wisp/wisp_relocate_teleport_ti7_out.vpcf", PATTACH_CUSTOMORIGIN, caster) 
	ParticleManager:SetParticleControl(iParticle, 0, target) 
end

item_fun_escutcheon = class(tClassFunItems)

function item_fun_escutcheon:GetIntrinsicModifierName()
	return "modifier_item_fun_escutcheon_lua"
end

item_fun_ragnarok = class(tClassFunItems)

function item_fun_ragnarok:GetIntrinsicModifierName()
	return "modifier_item_fun_ragnarok_lua"
end

item_fun_ragnarok_2 = class(tClassFunItems)

function item_fun_ragnarok_2:GetIntrinsicModifierName()
	return "modifier_item_fun_ragnarok_2_lua"
end

item_fun_terra_blade = class(tClassFunItems)
function item_fun_terra_blade:GetIntrinsicModifierName() return "modifier_item_fun_terra_blade" end
function item_fun_terra_blade:OnProjectileHit(hTarget, vLocation)

	if not hTarget then return end
	--[[
	local bOriginalTarget = false
	for i = 1, math.ceil(self:GetSpecialValueFor("projectile_distance")/self:GetSpecialValueFor("projectile_speed")/self:GetSpecialValueFor("minimum_at"))+2 do
		if self.tProjectiles[i] and self.tProjectiles[i][1] == hTarget:entindex() and (vLocation-self.tProjectiles[i][3]-self.tProjectiles[i][4]*(GameRules:GetGameTime()-self.tProjectiles[i][2])):Length2D() < 100 then
			bOriginalTarget = true
			break
		end
	end
	--]]
--	if not bOriginalTarget then		
		ApplyDamage({
			damage_type = DAMAGE_TYPE_PURE,
			damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()),
			attacker = self:GetCaster(),
			victim = hTarget,
			ability = self,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
		})
--	end
end



item_yasha_and_kaya = class({})
function item_yasha_and_kaya:GetIntrinsicModifierName() return "modifier_item_yasha_and_kaya" end
function item_yasha_and_kaya:OnSpellStart() 
	local hCaster = self:GetCaster()
	local iSlot
	for iSlot = 0,8 do 
		if hCaster:GetItemInSlot(iSlot) == self then
			break
		end
	end
	self:RemoveSelf()
	local hNewItem = hCaster:AddItemByName('item_kaya_and_sange')
	local iSlotNew
	for iSlotNew = 0,8 do 
		if hCaster:GetItemInSlot(iSlotNew) == hNewItem then
			break
		end
	end
	if iSlotNew ~= iSlot then
		hCaster:SwapItems(iSlotNew, iSlot)
	end
	hNewItem:SetPurchaseTime(-10)
end


item_kaya_and_sange = class({})
function item_kaya_and_sange:GetIntrinsicModifierName() return "modifier_item_kaya_and_sange" end
function item_kaya_and_sange:OnSpellStart() 
	local hCaster = self:GetCaster()
	local iSlot
	for iSlot = 0,8 do 
		if hCaster:GetItemInSlot(iSlot) == self then
			break
		end
	end
	self:RemoveSelf()
	local hNewItem = hCaster:AddItemByName('item_sange_and_yasha')
	local iSlotNew
	for iSlotNew = 0,8 do 
		if hCaster:GetItemInSlot(iSlotNew) == hNewItem then
			break
		end
	end
	if iSlotNew ~= iSlot then
		hCaster:SwapItems(iSlotNew, iSlot)
	end
	hNewItem:SetPurchaseTime(-10)
end


item_sange_and_yasha = class({})
function item_sange_and_yasha:GetIntrinsicModifierName() return "modifier_item_sange_and_yasha" end
function item_sange_and_yasha:OnSpellStart() 
	local hCaster = self:GetCaster()
	local iSlot
	for iSlot = 0,8 do 
		if hCaster:GetItemInSlot(iSlot) == self then
			break
		end
	end
	self:RemoveSelf()
	local hNewItem = hCaster:AddItemByName('item_yasha_and_kaya')
	local iSlotNew
	for iSlotNew = 0,8 do 
		if hCaster:GetItemInSlot(iSlotNew) == hNewItem then
			break
		end
	end
	if iSlotNew ~= iSlot then
		hCaster:SwapItems(iSlotNew, iSlot)
	end
	hNewItem:SetPurchaseTime(-10)
end

item_fun_papyrus_scarab = class(tClassFunItems)
function item_fun_papyrus_scarab:GetIntrinsicModifierName()
	return "modifier_item_fun_papyrus_scarab"
end	
function item_fun_papyrus_scarab:CastFilterResult()
	if IsClient() then return UF_SUCCESS end
	local hCaster = self:GetCaster()
	local fRange = self:GetSpecialValueFor('transform_range')
	local tUnitsNearby = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetOrigin(), nil, fRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_ANY_ORDER, false)
	if (not hCaster.tPapyrusScarabMinions or #hCaster.tPapyrusScarabMinions == 0) and #tUnitsNearby == 0 then
		return UF_FAIL_CUSTOM
	end
		return UF_SUCCESS
end
function item_fun_papyrus_scarab:GetCustomCastError()
	return 'error_papyrus_scarab_no_units_no_minions'
end




function item_fun_papyrus_scarab:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster.tPapyrusScarabMinions = hCaster.tPapyrusScarabMinions or {}
	local fRange = self:GetSpecialValueFor('transform_range')
	local fHealRatio = self:GetSpecialValueFor('transform_regenerate_percentage')/100
	if #(hCaster.tPapyrusScarabMinions) > 0 then
--		CustomGameEventManager:Send_ServerToAllClients("panorama_print", {count=#(hCaster.tPapyrusScarabMinions)})
		hCaster:EmitSound('Item.GuardianGreaves.Activate')
		ParticleManager:CreateParticle('particles/warmage.vpcf',PATTACH_ABSORIGIN_FOLLOW,hCaster)
		local tAllNearbyAllies = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetOrigin(), nil, fRange, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for i, v in ipairs(hCaster.tPapyrusScarabMinions) do
			if v and not v:IsNull() and v:IsAlive() then 
				local fHeal = v:GetHealth()*fHealRatio
				for i1, v1 in ipairs(tAllNearbyAllies) do
					if v1:IsHero() then
						ParticleManager:CreateParticle('particles/warmage_mana.vpcf',PATTACH_ABSORIGIN_FOLLOW,hCaster)
					else
						ParticleManager:CreateParticle('particles/warmage_mana_nonhero.vpcf',PATTACH_ABSORIGIN_FOLLOW,hCaster)
					end
					v1:EmitSound('Item.GuardianGreaves.Target')
					v1:Heal(fHeal, hCaster)				
					SendOverheadEventMessage(v1:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, v1, fHeal, nil)
					v1:SetMana(v1:GetMana()+fHeal)
					SendOverheadEventMessage(v1:GetPlayerOwner(), OVERHEAD_ALERT_MANA_ADD, v1, fHeal, nil)
				end			
--				CustomGameEventManager:Send_ServerToAllClients("panorama_print", {num_middle=i})
				local iParticle = ParticleManager:CreateParticle('particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_necro_souls_hero.vpcf', PATTACH_ABSORIGIN_FOLLOW, v)
				ParticleManager:SetParticleControlEnt(iParticle, 1, hCaster, PATTACH_POINT_FOLLOW, 'attach_hitloc', Vector(0,0,0),true)
				v:EmitSoundParams('Hero_Nevermore.RequiemOfSouls',1,0.2,1)
				hCaster.tPapyrusScarabMinions[i]:Kill(self,hCaster)
				hCaster.tPapyrusScarabMinions[i] = nil
--				CustomGameEventManager:Send_ServerToAllClients("panorama_print", {num_destroyed=i})
			end
		end
	end
	
	
	
	
	local tUnitsNearby = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetOrigin(), nil, fRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_ANY_ORDER, false)

	if #tUnitsNearby > self:GetSpecialValueFor('transform_count') then
		table.sort(tUnitsNearby, function (hUnita, hUnitb) return hUnita:GetMaximumGoldBounty()+hUnita:GetMinimumGoldBounty() > hUnitb:GetMaximumGoldBounty()+hUnitb:GetMinimumGoldBounty() end)
		local i = 1
		while i <= self:GetSpecialValueFor('transform_count') do
			local hUnit = tUnitsNearby[i]
			local vLocation = hUnit:GetAbsOrigin()
			local vForwardDirection = hUnit:GetForwardVector()
			local sName = hUnit:GetUnitName()
			local fHealth = hUnit:GetHealth()
			local fMaxHealth = hUnit:GetMaxHealth()
			local fAttackMin = hUnit:GetBaseDamageMin()
			local fAttackMax = hUnit:GetBaseDamageMax()
			local iGoldBountyMin = hUnit:GetMinimumGoldBounty()
			local iGoldBountyMax = hUnit:GetMaximumGoldBounty()
			UTIL_Remove(hUnit)
			local hNewUnit = CreateUnitByName(sName, vLocation, true, hCaster, nil, hCaster:GetTeamNumber())
			hNewUnit:SetOwner(hCaster)
			hNewUnit:SetBaseDamageMin(fAttackMin)
			hNewUnit:SetBaseDamageMax(fAttackMax)
			hNewUnit:SetMaxHealth(fMaxHealth)
			hNewUnit:SetBaseMaxHealth(fMaxHealth)
			hNewUnit:SetMinimumGoldBounty(iGoldBountyMin)
			hNewUnit:SetMaximumGoldBounty(iGoldBountyMax)
			hNewUnit:SetHealth(fHealth)
			hNewUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
			hNewUnit:SetForwardVector(vForwardDirection)
			hNewUnit:EmitSound("DOTA_Item.HotD.Activate")
			hNewUnit:EmitSound("DOTA_Item.Hand_Of_Midas")
			local iParticle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
			ParticleManager:SetParticleControlEnt(iParticle, 0, hNewUnit, PATTACH_POINT_FOLLOW, "follow_origin", hCaster:GetOrigin(), true)
			ParticleManager:SetParticleControlEnt(iParticle, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hNewUnit:GetOrigin(), true)			
			local iGold = hNewUnit:GetGoldBounty()*self:GetSpecialValueFor('transform_bonus_percentage')/100
			PlayerResource:ModifyGold(hCaster:GetPlayerOwnerID(), iGold, false, DOTA_ModifyGold_CreepKill)
			SendOverheadEventMessage(hNewUnit:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, hNewUnit, iGold, nil)
--			CustomGameEventManager:Send_ServerToAllClients("panorama_print", {exper=hNewUnit:GetDeathXP()*self:GetSpecialValueFor('transform_bonus_percentage')/100})
			hCaster:GetPlayerOwner():GetAssignedHero():AddExperience(hNewUnit:GetDeathXP()*self:GetSpecialValueFor('transform_bonus_percentage')/100, DOTA_ModifyXP_CreepKill, true, true)
			table.insert(hCaster.tPapyrusScarabMinions, hNewUnit);
			i = i+1;
		end
	else 		
		local i = 1
		while i <= #tUnitsNearby do
			local hUnit = tUnitsNearby[i]
			local vLocation = hUnit:GetAbsOrigin()
			local vForwardDirection = hUnit:GetForwardVector()
			local sName = hUnit:GetUnitName()
			local fHealth = hUnit:GetHealth()
			local fMaxHealth = hUnit:GetMaxHealth()
			local fAttackMin = hUnit:GetBaseDamageMin()
			local fAttackMax = hUnit:GetBaseDamageMax()
			local iGoldBountyMin = hUnit:GetMinimumGoldBounty()
			local iGoldBountyMax = hUnit:GetMaximumGoldBounty()
			UTIL_Remove(hUnit)
			local hNewUnit = CreateUnitByName(sName, vLocation, true, hCaster, nil, hCaster:GetTeamNumber())
			hNewUnit:SetOwner(hCaster)
			hNewUnit:SetBaseDamageMin(fAttackMin)
			hNewUnit:SetBaseDamageMax(fAttackMax)
			hNewUnit:SetMaxHealth(fMaxHealth)
			hNewUnit:SetBaseMaxHealth(fMaxHealth)
			hNewUnit:SetMinimumGoldBounty(iGoldBountyMin)
			hNewUnit:SetMaximumGoldBounty(iGoldBountyMax)
			hNewUnit:SetHealth(fHealth)
			hNewUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
			hNewUnit:SetForwardVector(vForwardDirection)
			hNewUnit:EmitSound("DOTA_Item.HotD.Activate")
			hNewUnit:EmitSound("DOTA_Item.Hand_Of_Midas")
			local iParticle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
			ParticleManager:SetParticleControlEnt(iParticle, 0, hNewUnit, PATTACH_POINT_FOLLOW, "follow_origin", hCaster:GetOrigin(), true)
			ParticleManager:SetParticleControlEnt(iParticle, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hNewUnit:GetOrigin(), true)			
			local iGold = hNewUnit:GetGoldBounty()*self:GetSpecialValueFor('transform_bonus_percentage')/100
			PlayerResource:ModifyGold(hCaster:GetPlayerOwnerID(), iGold, false, DOTA_ModifyGold_CreepKill)
			SendOverheadEventMessage(hNewUnit:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, hNewUnit, iGold, nil)
--			CustomGameEventManager:Send_ServerToAllClients("panorama_print", {exper=hNewUnit:GetDeathXP()*self:GetSpecialValueFor('transform_bonus_percentage')/100})
			hCaster:GetPlayerOwner():GetAssignedHero():AddExperience(hNewUnit:GetDeathXP()*self:GetSpecialValueFor('transform_bonus_percentage')/100, DOTA_ModifyXP_CreepKill, true, true)
			table.insert(hCaster.tPapyrusScarabMinions, hNewUnit);
			i = i+1;
		end
	end
end

item_fun_bs = class({})
function item_fun_bs:GetBehavior()
	if self.hModifier and not self.hModifier:IsNull() and self.hModifier:GetStackCount() > self:GetSpecialValueFor('aoe_min_need') then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET+DOTA_ABILITY_BEHAVIOR_AOE
	else
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
end


function item_fun_bs:GetAOERadius()
	if self.hModifier and not self.hModifier:IsNull() and self.hModifier:GetStackCount() > self:GetSpecialValueFor('aoe_min_need') then
		return self.hModifier:GetStackCount()*self:GetSpecialValueFor('aoe_per_charge')
	else
		return 0
	end
end

function item_fun_bs:GetCooldown()
	if self.hModifier and not self.hModifier:IsNull() then 
		local fCD = self:GetSpecialValueFor('cooldown_base')-self:GetSpecialValueFor('cooldown_reduction_per_charge')*self.hModifier:GetStackCount()
		if fCD < self:GetSpecialValueFor('cooldown_min') then fCD = self:GetSpecialValueFor('cooldown_min') end
		return fCD
	else
		return self:GetSpecialValueFor('cooldown_base')
	end
end


function item_fun_bs:GetIntrinsicModifierName() return "modifier_item_fun_bs" end

function item_fun_bs:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget:TriggerSpellAbsorb(self) then return end
	local iRadius = self:GetAOERadius()
	local hCaster = self:GetCaster()
	local fDamage = self:GetSpecialValueFor('damage_base')+self:GetSpecialValueFor('damage_per_charge')*self:GetCurrentCharges()
	if iRadius == 0 then
		hTarget:EmitSound('DOTA_Item.Dagon5.Target')
		if hCaster:GetTeam() == hTarget:GetTeam() then
			local iParticle = ParticleManager:CreateParticle('particles/econ/events/ti5/dagon_lvl2_ti5.vpcf', PATTACH_ABSORIGIN_FOLLOW, hTarget)
			ParticleManager:SetParticleControlEnt(iParticle, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
			ParticleManager:SetParticleControlEnt(iParticle, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true)
			ParticleManager:SetParticleControl(iParticle, 2, Vector(800,0,0))
			hTarget:Heal(fDamage, hCaster)
		else
			local iParticle = ParticleManager:CreateParticle('particles/items/dagon_lvl2_ti5.vpcf', PATTACH_ABSORIGIN_FOLLOW, hTarget)
			ParticleManager:SetParticleControlEnt(iParticle, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
			ParticleManager:SetParticleControlEnt(iParticle, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true)
			ParticleManager:SetParticleControl(iParticle, 2, Vector(800,0,0))
			ApplyDamage({attacker = hCaster, victim = hTarget, ability = self, damage = fDamage, damage_type = DAMAGE_TYPE_MAGICAL})
		end
	else
		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hTarget:GetOrigin(), nil, iRadius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		hTarget:EmitSound('DOTA_Item.Dagon5.Target')
		hTarget:EmitSound('DOTA_Item.Dagon5.Target')
		for k, v in pairs(tTargets) do
			if hCaster:GetTeam() == v:GetTeam() then
				local iParticle = ParticleManager:CreateParticle('particles/econ/events/ti5/dagon_lvl2_ti5.vpcf', PATTACH_ABSORIGIN_FOLLOW, v)
				ParticleManager:SetParticleControlEnt(iParticle, 1, v, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
				ParticleManager:SetParticleControlEnt(iParticle, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true)
				ParticleManager:SetParticleControl(iParticle, 2, Vector(800,0,0))
				v:Heal(fDamage, hCaster)
			else
				local iParticle = ParticleManager:CreateParticle('particles/items/dagon_lvl2_ti5.vpcf', PATTACH_ABSORIGIN_FOLLOW, v)
				ParticleManager:SetParticleControlEnt(iParticle, 1, v, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
				ParticleManager:SetParticleControlEnt(iParticle, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true)
				ParticleManager:SetParticleControl(iParticle, 2, Vector(800,0,0))
				ApplyDamage({attacker = hCaster, victim = v, ability = self, damage = fDamage, damage_type = DAMAGE_TYPE_MAGICAL})
			end
		end
	end

end

item_tree_planting_suite = class({})
function item_tree_planting_suite:GetIntrinsicModifierName()
	return "modifier_item_tree_planting_suite"
end

function item_tree_planting_suite:CastFilterResultLocation(vLocation)
	if IsClient() then return UF_SUCCESS end
	local tTrees = GridNav:GetAllTreesAroundPoint(vLocation,5,true)
	if #tTrees == 0 then return UF_SUCCESS else return UF_FAIL_CUSTOM end
end
function item_tree_planting_suite:GetCustomCastErrorLocation(vLocation)
	return "dota_hud_error_no_trees_here"
end

function item_tree_planting_suite:OnSpellStart()
	self:SetCurrentCharges(self:GetCurrentCharges()-1)
	local vPos = self:GetCursorPosition()
	CreateTempTree(vPos, self:GetSpecialValueFor('tree_duration'))
	local tTrees = GridNav:GetAllTreesAroundPoint(vPos,1,true)
	tTrees[1]:SetModel('models/props_tree/ti7/ggbranch.vmdl')
	tTrees[1]:SetRenderColor(RandomInt(1,255),RandomInt(1,255),RandomInt(1,255))
	tTrees[1]:SetForwardVector(Vector(1,0,0))
	tTrees[1].bPlanted = true
end






