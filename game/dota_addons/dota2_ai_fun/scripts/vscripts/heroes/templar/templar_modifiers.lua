modifier_templar_chicken = class({})
function modifier_templar_chicken:IsPurgable() return false end

function modifier_templar_chicken:CheckState()
	return {	
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_HEXED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_SILENCED] = true
	}
end

function modifier_templar_chicken:DeclareFunctions()
	return {	
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
	}
end

function modifier_templar_chicken:GetModifierModelChange()
	return "models/items/courier/mighty_chicken/mighty_chicken.vmdl"
end

function modifier_templar_chicken:GetModifierMoveSpeedOverride()
	return 140
end

modifier_templar_chicken_strength_loss = class({})
function modifier_templar_chicken_strength_loss:IsPurgable() return false end
function modifier_templar_chicken_strength_loss:DeclareFunctions()
	return {	
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
end
function modifier_templar_chicken_strength_loss:GetModifierBonusStats_Strength() 
	return self:GetAbility():GetSpecialValueFor("strength_loss")
end


modifier_templar_drain = class({})

function modifier_templar_drain:IsPurgable() return false end
function modifier_templar_drain:RemoveOnDeath() return false end
function modifier_templar_drain:IsHidden() return true end

function modifier_templar_drain:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_templar_drain:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	if hParent:HasScepter() and hParent:HasAbility("templar_drain") then
		local iLevel = hParent:FindAbilityByName("templar_drain"):GetLevel()
		hParent:RemoveAbility("templar_drain")
		hParent:AddAbility("templar_drain_upgrade"):SetLevel(iLevel)
	end
	if not hParent:HasScepter() and hParent:HasAbility("templar_drain_upgrade") then
		local iLevel = hParent:FindAbilityByName("templar_drain_upgrade"):GetLevel()
		hParent:RemoveAbility("templar_drain_upgrade")
		hParent:AddAbility("templar_drain"):SetLevel(iLevel)	
	end
end

modifier_templar_faith = class({})
function modifier_templar_faith:IsPurgable() return true end
function modifier_templar_faith:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_templar_faith:GetEffectName() return "particles/units/heroes/hero_chen/chen_penitence_debuff.vpcf" end
function modifier_templar_faith:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

local tPointTrue = {
	sandking_burrowstrike = true, 
	zuus_lightning_bolt = true, 
	tiny_toss_tree = true,
	lion_impale = true,
	furion_wrath_of_nature = true,
	spectre_spectral_dagger = true	
}

function modifier_templar_faith:OnTakeDamage(keys)
	if not keys.inflictor or keys.inflictor:GetName() == "templar_faith" then 
		return 
	end
	
	if keys.unit == self:GetParent() or keys.attacker == self:GetParent() then
		local hAbility = self:GetAbility()
		ApplyDamage({damage = self:GetParent():GetIntellect()*hAbility:GetSpecialValueFor("intellect_damage"), damage_type = hAbility:GetAbilityDamageType(), ability = hAbility, attacker = keys.attacker, victim = keys.unit})
	end
end






