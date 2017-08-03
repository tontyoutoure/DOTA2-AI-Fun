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