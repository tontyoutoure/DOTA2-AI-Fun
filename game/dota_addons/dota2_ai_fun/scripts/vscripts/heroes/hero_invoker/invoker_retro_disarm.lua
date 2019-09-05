--[[ ============================================================================================================
	Author: wFX
	Date: February 24, 2015
	Called when Disarm is cast.  Remove the attack command from a unit.
================================================================================================================= ]]

LinkLuaModifier("modifier_invoker_retro_disarm", "heroes/hero_invoker/invoker_retro_disarm.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_retro_disarm_exort_level", "heroes/hero_invoker/invoker_retro_disarm.lua", LUA_MODIFIER_MOTION_NONE)
invoker_retro_disarm = class({})

function invoker_retro_disarm:GetIntrinsicModifierName() return 'modifier_invoker_retro_disarm_exort_level' end
function invoker_retro_disarm:GetCastRange()
	local hCaster = self:GetCaster()
	local iExortLevel = self.hModifier:GetStackCount()
	
	return iExortLevel*self:GetSpecialValueFor('cast_range_level_exort')+self:GetSpecialValueFor('cast_range_base')
end
function invoker_retro_disarm:OnSpellStart()
	print(self:GetCaster():GetName())
	local keys = {target = self:GetCursorTarget(), ability = self, caster = self:GetCaster()}
	if keys.target:TriggerSpellAbsorb(keys.ability) then
		return 
	end
	local iExortLevel
	if keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) and keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) == keys.ability then
		iExortLevel = keys.caster.iExortLevel
		if keys.caster:HasScepter() then iExortLevel = iExortLevel+1 end
	else
		iExortLevel = keys.target.iExortLevel
		if keys.caster:HasScepter() then iExortLevel = iExortLevel+1 end	
	end
	keys.target:EmitSound('DOTA_Item.HeavensHalberd.Activate')
	ParticleManager:CreateParticle('particles/units/heroes/hero_invoker/invoker_retro_disarm_impact.vpcf', PATTACH_ABSORIGIN_FOLLOW, keys.target)
	
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_invoker_retro_disarm", {Duration = iExortLevel*keys.ability:GetSpecialValueFor('duration_level_exort')*CalculateStatusResist(keys.target)})
end

modifier_invoker_retro_disarm = class({})
function modifier_invoker_retro_disarm:GetEffectName() return 'particles/units/heroes/hero_invoker/invoker_deafening_blast_disarm_debuff.vpcf' end
function modifier_invoker_retro_disarm:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_invoker_retro_disarm:CheckState()
	return {[MODIFIER_STATE_DISARMED] = true}
end


modifier_invoker_retro_disarm_exort_level = class({})
function modifier_invoker_retro_disarm_exort_level:IsHidden() return true end
function modifier_invoker_retro_disarm_exort_level:IsPurgable() return false end
function modifier_invoker_retro_disarm_exort_level:RemoveOnDeath() return false end
function modifier_invoker_retro_disarm_exort_level:OnCreated()
	self:GetAbility().hModifier = self
	if IsServer() then
		local hParent = self:GetParent()
		if hParent:HasScepter() then
			self:SetStackCount(hParent.iExortLevel+1)
		else
			self:SetStackCount(hParent.iExortLevel)
		end
	end
	self:StartIntervalThink(0.04)
end
function modifier_invoker_retro_disarm_exort_level:OnIntervalThink()
	local hParent = self:GetParent()
	if IsServer() and hParent.iExortLevel then
		if hParent:HasScepter() then
			self:SetStackCount(hParent.iExortLevel+1)
		else
			self:SetStackCount(hParent.iExortLevel)
		end
	end
end