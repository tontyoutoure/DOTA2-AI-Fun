modifier_ramza_arithmetician_soulbind = class({})

function modifier_ramza_arithmetician_soulbind:IsHidden() return true end
function modifier_ramza_arithmetician_soulbind:RemoveOnDeath() return false end
function modifier_ramza_arithmetician_soulbind:IsPurgable() return false end

function modifier_ramza_arithmetician_soulbind:DeclareFunctions() 
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_ramza_arithmetician_soulbind:GetModifierIncomingDamage_Percentage()
	return -50
end

function modifier_ramza_arithmetician_soulbind:OnTakeDamage(keys)
	if keys.unit ~= self:GetParent() then return end
	damageTable = {
		victim = keys.attacker,
		damage = keys.original_damage/2,
		attacker = keys.unit,
		ability = self:GetAbility(),
		damage_type = keys.damage_type,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL
	}
	ApplyDamage(damageTable)	
end

modifier_ramza_arithmetician_accrue_exp = class({})

function modifier_ramza_arithmetician_accrue_exp:IsHidden() return true end
function modifier_ramza_arithmetician_accrue_exp:RemoveOnDeath() return false end
function modifier_ramza_arithmetician_accrue_exp:IsPurgable() return false end

function modifier_ramza_arithmetician_accrue_exp:OnCreated()
	if IsClient() then return end
	self.iPecentageDistanceXP = self:GetAbility():GetSpecialValueFor("percentage_distance_xp")
	self.vPreviousPosition = self:GetParent():GetOrigin()
	self:StartIntervalThink(0.25)
end

function modifier_ramza_arithmetician_accrue_exp:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	local fDistance = self.vPreviousPosition.Length(hParent:GetOrigin() - self.vPreviousPosition)
	hParent:AddExperience(fDistance*self.iPecentageDistanceXP/100, DOTA_ModifyXP_Unspecified, false , true)
	self.vPreviousPosition = hParent:GetOrigin()
end


modifier_ramza_arithmetician_exp_boost = class({})

function modifier_ramza_arithmetician_exp_boost:IsHidden() return true end
function modifier_ramza_arithmetician_exp_boost:RemoveOnDeath() return false end
function modifier_ramza_arithmetician_exp_boost:IsPurgable() return false end

function modifier_ramza_arithmetician_exp_boost:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_EXP_RATE_BOOST
	}
end


function modifier_ramza_arithmetician_exp_boost:GetModifierPercentageExpRateBoost()
	self.fExpBoost = self.fExpBoost or self:GetAbility():GetSpecialValueFor("percentage_extra_xp")
	return self.fExpBoost
end