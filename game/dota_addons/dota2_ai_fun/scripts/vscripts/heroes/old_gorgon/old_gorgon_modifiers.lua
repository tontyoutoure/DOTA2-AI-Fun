modifier_old_gorgon_purge_slow = class({})
function modifier_old_gorgon_purge_slow:IsDebuff() return true end
function modifier_old_gorgon_purge_slow:IsPurgable() return true end
function modifier_old_gorgon_purge_slow:OnRefresh(keys)
	if IsClient() then return end
	local iSlowFactor = self:GetAbility():GetSpecialValueFor("slow_factor")
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("slow_duration")/iSlowFactor*(1-self:GetParent():GetStatusResistance()))
	self:SetStackCount(-iSlowFactor) 
	
end
function modifier_old_gorgon_purge_slow:OnCreated(keys)
	if IsClient() then return end
	local iSlowFactor = self:GetAbility():GetSpecialValueFor("slow_factor")
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("slow_duration")/iSlowFactor*(1-self:GetParent():GetStatusResistance()))
	self:SetStackCount(-iSlowFactor) 
end

function modifier_old_gorgon_purge_slow:DeclareFunctions()
	return {MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE, MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end
function modifier_old_gorgon_purge_slow:GetModifierIncomingPhysicalDamage_Percentage()
	return self:GetCaster():FindAbilityByName('special_bonus_unique_old_gorgon_3'):GetSpecialValueFor('value')
end

function modifier_old_gorgon_purge_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()/self:GetAbility():GetSpecialValueFor("slow_factor")*100
end

function modifier_old_gorgon_purge_slow:OnIntervalThink()
	if IsClient() then return end
	self:IncrementStackCount()
end

function modifier_old_gorgon_purge_slow:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_old_gorgon_purge_slow:GetEffectName() return "particles/items_fx/diffusal_slow.vpcf" end


modifier_old_gorgon_mana_shield = class({})

function modifier_old_gorgon_mana_shield:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end

function modifier_old_gorgon_mana_shield:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_old_gorgon_mana_shield:GetEffectName() return "particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf" end

function modifier_old_gorgon_mana_shield:IsDebuff() return false end

function modifier_old_gorgon_mana_shield:IsPurgable() return false end

function modifier_old_gorgon_mana_shield:RemoveOnDeath() return false end

function modifier_old_gorgon_mana_shield:OnTakeDamage(keys)
	if keys.unit ~= self:GetParent() then return end
	local fFactor
	if keys.unit:HasScepter() then
		fFactor = self:GetAbility():GetSpecialValueFor('damage_per_mana_scepter')
	else
		fFactor = self:GetAbility():GetSpecialValueFor('damage_per_mana')
	end
	if keys.unit:GetMana() > keys.original_damage then
		keys.unit:ReduceMana(keys.original_damage/fFactor)
		keys.unit:SetHealth(keys.unit:GetHealth()+keys.damage)
	else
		keys.unit:ReduceMana(keys.original_damage/fFactor)
		keys.unit:SetHealth(keys.unit:GetHealth()+keys.damage*keys.unit:GetMana()/keys.original_damage)
	end
	keys.unit:EmitSound('Hero_Medusa.ManaShield.Proc')
	ParticleManager:CreateParticle('particles/units/heroes/hero_medusa/medusa_mana_shield_impact.vpcf', PATTACH_ABSORIGIN_FOLLOW, keys.unit)
end