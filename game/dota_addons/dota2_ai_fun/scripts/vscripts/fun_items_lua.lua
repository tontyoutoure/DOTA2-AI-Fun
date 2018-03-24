LinkLuaModifier("modifier_item_fun_sprint_shoes_lua", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_sprint_shoes_lua_vision", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_escutcheon_lua", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_escutcheon_regen_lua", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_ragnarok_lua", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_ragnarok_ultra_maim", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_terra_blade", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fun_terra_blade_ultra_maim", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
item_fun_sprint_shoes = class({})

function item_fun_sprint_shoes:GetIntrinsicModifierName()
	return "modifier_item_fun_sprint_shoes_lua"
end

function item_fun_sprint_shoes:GetChannelTime()
	if IsClient() or self:GetCaster():IsRooted() or (self:GetCursorPosition()-self:GetCaster():GetOrigin()):Length2D() > self:GetSpecialValueFor("blink_distance") or self.hModifier:GetStackCount() > 0 then
		return self:GetSpecialValueFor("channel_time")
	else
		return 0
	end
end 

function item_fun_sprint_shoes:GetAbilityTextureName(keys) 
	if self.hModifier and self.hModifier:GetStackCount() > 0 then
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

item_fun_escutcheon = class({})

function item_fun_escutcheon:GetIntrinsicModifierName()
	return "modifier_item_fun_escutcheon_lua"
end

item_fun_ragnarok = class({})

function item_fun_ragnarok:GetIntrinsicModifierName()
	return "modifier_item_fun_ragnarok_lua"
end

item_fun_terra_blade = class({})
function item_fun_terra_blade:GetIntrinsicModifierName() return "modifier_item_fun_terra_blade" end
function item_fun_terra_blade:OnProjectileHit(hTarget, vLocation)
	if not hTarget then return end
	local bOriginalTarget = false
	for i = 1, math.ceil(self:GetSpecialValueFor("projectile_distance")/self:GetSpecialValueFor("projectile_speed")/self:GetSpecialValueFor("minimum_at"))+2 do
		if self.tProjectiles[i] and self.tProjectiles[i][1] == hTarget:entindex() and (vLocation-self.tProjectiles[i][3]-self.tProjectiles[i][4]*(GameRules:GetGameTime()-self.tProjectiles[i][2])):Length2D() < 100 then
			bOriginalTarget = true
			break
		end
	end
	if not bOriginalTarget then		
		ApplyDamage({
			damage_type = DAMAGE_TYPE_PURE,
			damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()),
			attacker = self:GetCaster(),
			victim = hTarget,
			ability = self,
			damage_flag = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		})
	end
end




