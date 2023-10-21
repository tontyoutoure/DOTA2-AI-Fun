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

function modifier_pet_summoner_critters:IsPurgable() return false end
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

function modifier_pet_summoner_mittens_meow:GetEffectName() return "particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf" end

function modifier_pet_summoner_mittens_meow:GetModifierPreAttack_BonusDamage() 
	if self:GetCaster():PassivesDisabled() then
		return 0 
	else 
		return self:GetAbility():GetSpecialValueFor("bonus_damage") 
	end
end

modifier_pet_summoner_fix_boo_boo_shield = class({})
function modifier_pet_summoner_fix_boo_boo_shield:IsPurgable() return true end
function modifier_pet_summoner_fix_boo_boo_shield:IsHidden() return false end
function modifier_pet_summoner_fix_boo_boo_shield:RemoveOnDeath() return true end
function modifier_pet_summoner_fix_boo_boo_shield:GetEffectName() return "particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf" end
function modifier_pet_summoner_fix_boo_boo_shield:OnCreated(keys)
	if IsClient() then return end
	self:StartIntervalThink(0.03)
	self:SetHasCustomTransmitterData(true)
	self.shield = keys.fShield
end

function modifier_pet_summoner_fix_boo_boo_shield:OnRefresh(keys)
	if IsClient() then return end
	self.shield = keys.fShield
end

function modifier_pet_summoner_fix_boo_boo_shield:AddCustomTransmitterData()
    return {
        shield = self.shield,
    }
end

function modifier_pet_summoner_fix_boo_boo_shield:HandleCustomTransmitterData( data )
	-- print(self.shield)
    self.shield = data.shield
end

function modifier_pet_summoner_fix_boo_boo_shield:OnIntervalThink()
    self:SendBuffRefreshToClients()
end

function modifier_pet_summoner_fix_boo_boo_shield:DeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_TAKEDAMAGE
		MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT
	}
end
function modifier_pet_summoner_fix_boo_boo_shield:GetModifierIncomingDamageConstant(keys)
	if not IsServer() then 
		return self.shield 
	end
	
	if keys.damage < self.shield then
		self.shield = self.shield - keys.damage
		return -keys.damage
	else
		self:Destroy()
		return -self.shield
	end
end