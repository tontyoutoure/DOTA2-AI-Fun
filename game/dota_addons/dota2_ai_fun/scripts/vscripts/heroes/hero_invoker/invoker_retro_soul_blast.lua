--[[ ============================================================================================================
	Author: Rook
	Date: February 25, 2015
	Called when Soul Blast is cast.  Damages the target enemy unit, and heals Invoker.
================================================================================================================= ]]
LinkLuaModifier("modifier_invoker_retro_soul_blast_wex_level", "heroes/hero_invoker/invoker_retro_soul_blast.lua", LUA_MODIFIER_MOTION_NONE)
modifier_invoker_retro_soul_blast_wex_level = class({})
function modifier_invoker_retro_soul_blast_wex_level:IsHidden() return true end
function modifier_invoker_retro_soul_blast_wex_level:IsPurgable() return false end
function modifier_invoker_retro_soul_blast_wex_level:RemoveOnDeath() return false end
function modifier_invoker_retro_soul_blast_wex_level:OnCreated()
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
function modifier_invoker_retro_soul_blast_wex_level:OnIntervalThink()
	local hParent = self:GetParent()
	if IsServer() and hParent.iWexLevel then
		if hParent:HasScepter() then
			self:SetStackCount(hParent.iWexLevel+1)
		else
			self:SetStackCount(hParent.iWexLevel)
		end
	end
end

invoker_retro_soul_blast = class({})
function invoker_retro_soul_blast:GetIntrinsicModifierName() return 'modifier_invoker_retro_soul_blast_wex_level' end

function invoker_retro_soul_blast:GetCastRange()
	return self.hModifier:GetStackCount()*self:GetSpecialValueFor('cast_range_level_wex')+self:GetSpecialValueFor('cast_range_base')
end

function invoker_retro_soul_blast:OnSpellStart()
	local keys = {caster = self:GetCaster(), target = self:GetCursorTarget(), ability = self}
	
	if keys.target:TriggerSpellAbsorb(keys.ability) then
		return 
	end
	
	local iExortLevel
	if keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) and keys.ability == keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) then
		iExortLevel = keys.caster.iExortLevel
		if keys.caster:HasScepter() then iExortLevel = iExortLevel+1 end
	else
		iExortLevel = keys.target.iExortLevel
		if keys.caster:HasScepter() then iExortLevel = iExortLevel+1 end	
	end
	
	local iQuasLevel
	if keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) and keys.ability == keys.caster:FindAbilityByName(keys.ability:GetAbilityName()) then
		iQuasLevel = keys.caster.iQuasLevel
		if keys.caster:HasScepter() then iQuasLevel = iQuasLevel+1 end
	else
		iQuasLevel = keys.target.iQuasLevel
		if keys.caster:HasScepter() then iQuasLevel = iQuasLevel+1 end	
	end
	keys.caster:EmitSound("Hero_Bane.BrainSap")
	keys.target:EmitSound("Hero_Bane.BrainSap.Target")
	iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_bane/bane_sap.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster)
	ParticleManager:SetParticleControlEnt(iParticle, 0, keys.caster, PATTACH_POINT_FOLLOW, 'attach_attack1', keys.caster:GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticle, 1, keys.target, PATTACH_POINT_FOLLOW, 'attach_hitloc', keys.target:GetOrigin(), true)
	

	local damage = keys.ability:GetSpecialValueFor("damage_level_exort")*iExortLevel  --Damage dealt increases per level of Exort.
	local healing = keys.ability:GetSpecialValueFor("heal_level_quas")*iQuasLevel  --Damage dealt increases per level of Quas.
	
	ApplyDamageTestDummy({victim = keys.target, attacker = keys.caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = keys.ability})
	keys.caster:Heal(healing, keys.caster)
	SendOverheadEventMessage(keys.caster:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, keys.caster, healing, nil)
end