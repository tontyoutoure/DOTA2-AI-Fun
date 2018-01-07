modifier_pet_summoner_critters = class({})

function modifier_pet_summoner_critters:CheckState()
	return {	
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_HEXED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_SILENCED] = true
	}
end

function modifier_pet_summoner_critters:DeclareFunctions()
	return {	
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
	}
end

function modifier_pet_summoner_critters:GetModifierModelChange()
	return "models/items/courier/courier_janjou/courier_janjou.vmdl"
end

function modifier_pet_summoner_critters:GetModifierMoveSpeedOverride()
	return 140
end

function modifier_pet_summoner_critters:GetModifierProvidesFOWVision() return 1 end

function modifier_pet_summoner_critters:IsPurgable() return true end
function modifier_pet_summoner_critters:GetTexture() return "lion_voodoo" end

modifier_pet_summoner_mittens_meow_aura = class({})

function modifier_pet_summoner_mittens_meow_aura:IsPurgable() return false end
function modifier_pet_summoner_mittens_meow_aura:RemoveOnDeath() return false end
function modifier_pet_summoner_mittens_meow_aura:IsHidden() return true end

function modifier_pet_summoner_mittens_meow_aura:IsAura() return true end

function modifier_pet_summoner_mittens_meow_aura:GetModifierAura()
	return "modifier_pet_summoner_mittens_meow"
end

function modifier_pet_summoner_mittens_meow_aura:GetAuraRadius() return 99999 end

function modifier_pet_summoner_mittens_meow_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_pet_summoner_mittens_meow_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO end

function modifier_pet_summoner_mittens_meow_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end

function modifier_pet_summoner_mittens_meow_aura:GetAuraEntityReject(hTarget)
	if hTarget:GetPlayerOwnerID() == self:GetParent():GetPlayerOwnerID() then return false else return true end
end

modifier_pet_summoner_mittens_meow = class({})

function modifier_pet_summoner_mittens_meow:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end

function modifier_pet_summoner_mittens_meow:GetModifierPreAttack_BonusDamage() 
	if self:GetCaster():PassivesDisabled() then
		return 0 
	else 
		return self:GetAbility():GetSpecialValueFor("bonus_damage") 
	end
end