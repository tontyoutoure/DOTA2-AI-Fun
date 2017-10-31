modifier_ramza_dark_knight_hp_boost = class({})

function modifier_ramza_dark_knight_hp_boost:IsHidden() return true end
function modifier_ramza_dark_knight_hp_boost:RemoveOnDeath() return false end
function modifier_ramza_dark_knight_hp_boost:IsPurgable() return false end

function modifier_ramza_dark_knight_hp_boost:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
	}
end

function modifier_ramza_dark_knight_hp_boost:GetModifierExtraHealthPercentage()
	self.fExtraHealth = self.fExtraHealth or self:GetAbility():GetSpecialValueFor("extra_health_percentage")/100
	return self.fExtraHealth
end

modifier_ramza_dark_knight_vehemence = class({})
function modifier_ramza_dark_knight_hp_boost:IsPurgable() return false end
function modifier_ramza_dark_knight_vehemence:IsDebuff() return false end
function modifier_ramza_dark_knight_vehemence:GetStatusEffectName() return "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf" end
function modifier_ramza_dark_knight_vehemence:GetEffectName() return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf" end
function modifier_ramza_dark_knight_vehemence:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_ramza_dark_knight_vehemence:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_ramza_dark_knight_vehemence:GetModifierTotalDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("outgoing_damage_percentage")
end

function modifier_ramza_dark_knight_vehemence:GetModifierIncomingDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("incoming_damage_percentage")
end