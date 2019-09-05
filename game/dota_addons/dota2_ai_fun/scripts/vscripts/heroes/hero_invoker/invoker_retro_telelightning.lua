
LinkLuaModifier("modifier_invoker_retro_telelightning_wex_level", "heroes/hero_invoker/invoker_retro_telelightning.lua", LUA_MODIFIER_MOTION_NONE)
modifier_invoker_retro_telelightning_wex_level = class({})
function modifier_invoker_retro_telelightning_wex_level:IsHidden() return true end
function modifier_invoker_retro_telelightning_wex_level:IsPurgable() return false end
function modifier_invoker_retro_telelightning_wex_level:RemoveOnDeath() return false end
function modifier_invoker_retro_telelightning_wex_level:OnCreated()
	self:GetAbility().hModifier = self
	if IsServer() then
		local hParent = self:GetParent()
		if hParent:HasScepter() then
			self:SetStackCount(hParent.iWexLevel+1)
		else
			self:SetStackCount(hParent.iWexLevel)
		end
	end
	self:StartIntervalThink(0.04)
end
function modifier_invoker_retro_telelightning_wex_level:OnIntervalThink()
	local hParent = self:GetParent()
	if IsServer() and hParent.iWexLevel then
		if hParent:HasScepter() then
			self:SetStackCount(hParent.iWexLevel+1)
		else
			self:SetStackCount(hParent.iWexLevel)
		end
	end
end
invoker_retro_telelightning = class({})
function invoker_retro_telelightning:GetIntrinsicModifierName() return 'modifier_invoker_retro_telelightning_wex_level' end
function invoker_retro_telelightning:GetCastRange() return self.hModifier:GetStackCount()*self:GetSpecialValueFor('cast_range_level_wex')+self:GetSpecialValueFor('cast_range_base') end

function invoker_retro_telelightning:OnSpellStart()
	local keys = {caster = self:GetCaster(), ability = self, target = self:GetCursorTarget()}
	
	if keys.target:TriggerSpellAbsorb(keys.ability) then
		return 
	end
	
	local iWexLevel
	if keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) and keys.ability == keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) then
		iWexLevel = keys.caster.iWexLevel
		if keys.caster:HasScepter() then iWexLevel = iWexLevel+1 end
	else
		iWexLevel = keys.target.iWexLevel
		if keys.caster:HasScepter() then iWexLevel = iWexLevel+1 end	
	end
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
		
	local particle = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf",PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z))
	ParticleManager:SetParticleControl(particle, 1, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z))
	caster:EmitSound("Hero_Zuus.ArcLightning.Cast")
	target:EmitSound("Hero_Zuus.ArcLightning.Target")
	local target_point = target:GetAbsOrigin()
	local point_difference_normalized = (caster:GetAbsOrigin() - target_point):Normalized()
	local point_to_place_caster = GetGroundPosition(target_point + (point_difference_normalized * 64), nil)
	local caster_point = caster:GetOrigin()

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = ability:GetSpecialValueFor("damage_level_wex")*iWexLevel,
		damage_type = ability:GetAbilityDamageType(),
		ability = self
	}
	ApplyDamageTestDummy(damageTable)
	Timers:CreateTimer(keys.ability:GetSpecialValueFor('delay'), function () 		
		FindClearSpaceForUnit(caster, point_to_place_caster, false)	
		local iParticle = ParticleManager:CreateParticle('particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_phantom_strike_start.vpcf', PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(iParticle, 0, caster_point)
		iParticle = ParticleManager:CreateParticle('particles/units/heroes/hero_invoker/pa_arcana_phantom_strike_end.vpcf', PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(iParticle, 0, point_to_place_caster)
	end)
end