modifier_vengefulspirit_command_aura_customed = class({})
function modifier_vengefulspirit_command_aura_customed:IsHidden() return true end
function modifier_vengefulspirit_command_aura_customed:RemoveOnDeath() return false end
function modifier_vengefulspirit_command_aura_customed:IsPurgable() return false end
function modifier_vengefulspirit_command_aura_customed:IsAura() if self:GetCaster():IsIllusion() then return false end return true end
function modifier_vengefulspirit_command_aura_customed:GetModifierAura() return "modifier_vengefulspirit_command_aura_effect_customed" end
function modifier_vengefulspirit_command_aura_customed:GetAuraDuration() return 0.5 end
function modifier_vengefulspirit_command_aura_customed:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_vengefulspirit_command_aura_customed:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_vengefulspirit_command_aura_customed:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_vengefulspirit_command_aura_customed:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end


modifier_vengefulspirit_command_aura_effect_customed = class({})
function modifier_vengefulspirit_command_aura_effect_customed:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}
end
function modifier_vengefulspirit_command_aura_effect_customed:GetModifierBaseDamageOutgoing_Percentage()
	if self:GetCaster():PassivesDisabled() then return 0 end
	if not self.bFoundSpecial then
		self.hSpecial = Entities:First()	
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_unique_vengeful_spirit_2" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end	
		self.bFoundSpecial = true		
	end
	
	if self.hSpecial and self.hSpecial:GetLevel() > 0 then
		return self:GetAbility():GetSpecialValueFor("bonus_damage_pct")+self.hSpecial:GetSpecialValueFor("value")
	end
	return self:GetAbility():GetSpecialValueFor("bonus_damage_pct")
end