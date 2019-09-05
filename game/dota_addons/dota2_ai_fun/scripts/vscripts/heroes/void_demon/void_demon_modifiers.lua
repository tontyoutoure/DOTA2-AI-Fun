modifier_void_demon_quake_slow_lua = class({})

function modifier_void_demon_quake_slow_lua:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end 

function modifier_void_demon_quake_slow_lua:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("quake_slow_percentage")
end

modifier_void_demon_quake_aura_lua = class({})

function modifier_void_demon_quake_aura_lua:IsAura()
	return true
end

function modifier_void_demon_quake_aura_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_void_demon_quake_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC
end

function modifier_void_demon_quake_aura_lua:GetModifierAura()
	return "modifier_void_demon_quake_slow_lua"
end

function modifier_void_demon_quake_aura_lua:GetAuraRadius()
	self.iRadius = self.iRadius or 100
	return self.iRadius
end

function modifier_void_demon_quake_aura_lua:OnCreated()
	self:StartIntervalThink(1)
end

function modifier_void_demon_quake_aura_lua:OnIntervalThink()
	if IsClient() then return end
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()
	hParent:EmitSound("Hero_Leshrac.Split_Earth")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_ABSORIGIN, hParent)
	ParticleManager:SetParticleControl(particle, 1, Vector(self.iRadius, self.iRadius, self.iRadius))
	local tUnits = FindUnitsInRadius(hCaster:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.iRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE , FIND_ANY_ORDER, false)
	for k, v in pairs(tUnits) do
		local tDamageTable = {
			victim = v, 
			attacker = hCaster,
			ability = hAbility,
			damage_type = DAMAGE_TYPE_PURE,
			damage = self.fDamage
		}
		
		ApplyDamage(tDamageTable)
	end
end

modifier_void_demon_mass_haste_fly_aura = class({})
function modifier_void_demon_mass_haste_fly_aura:DeclareFunctions() return {MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS} end
function modifier_void_demon_mass_haste_fly_aura:GetActivityTranslationModifiers() return 'haste' end
function modifier_void_demon_mass_haste_fly_aura:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_void_demon_mass_haste_fly_aura:GetEffectName() return 'particles/units/heroes/hero_night_stalker/nightstalker_dark_buff.vpcf' end

function modifier_void_demon_mass_haste_fly_aura:IsAura() return true end
function modifier_void_demon_mass_haste_fly_aura:GetModifierAura() 
	return "modifier_void_demon_mass_haste_fly" 
end
function modifier_void_demon_mass_haste_fly_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_void_demon_mass_haste_fly_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_void_demon_mass_haste_fly_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_void_demon_mass_haste_fly_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO end
function modifier_void_demon_mass_haste_fly_aura:IsHidden() return false end
function modifier_void_demon_mass_haste_fly_aura:RemoveOnDeath() return false end
function modifier_void_demon_mass_haste_fly_aura:IsPurgable() return false end

modifier_void_demon_mass_haste_fly = class({})
function modifier_void_demon_mass_haste_fly:CheckState() return {[MODIFIER_STATE_FLYING]=true} end
function modifier_void_demon_mass_haste_fly:OnCreated() self:StartIntervalThink(FrameTime()) end 
function modifier_void_demon_mass_haste_fly:OnIntervalThink() 
	if IsClient() then return end
	local hParent = self:GetParent() 
	AddFOWViewer(hParent:GetTeam(), hParent:GetOrigin(), hParent:GetCurrentVisionRange(),FrameTime(), false) 
end
modifier_void_demon_mass_haste = class({})

function modifier_void_demon_mass_haste:IsAura() return true end
function modifier_void_demon_mass_haste:GetModifierAura() 
	return "modifier_void_demon_mass_haste_accelerate" 
end
function modifier_void_demon_mass_haste:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_void_demon_mass_haste:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_void_demon_mass_haste:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_void_demon_mass_haste:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO end
function modifier_void_demon_mass_haste:IsHidden() return true end
function modifier_void_demon_mass_haste:RemoveOnDeath() return false end
function modifier_void_demon_mass_haste:IsPurgable() return false end

modifier_void_demon_mass_haste_accelerate = class({})
function modifier_void_demon_mass_haste_accelerate:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_void_demon_mass_haste_accelerate:GetModifierMoveSpeedBonus_Percentage() 
	if self:GetCaster():PassivesDisabled() then return 0 else return self:GetAbility():GetSpecialValueFor("movespeed_bonus") end
end
function modifier_void_demon_mass_haste_accelerate:GetModifierAttackSpeedBonus_Constant()
	if self:GetCaster():PassivesDisabled() then return 0 else return self:GetAbility():GetSpecialValueFor("attackspeed_bonus") end
end
	
function modifier_void_demon_mass_haste_accelerate:GetEffectName() return "particles/generic_gameplay/rune_haste_owner.vpcf" end
function modifier_void_demon_mass_haste_accelerate:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

modifier_void_demon_time_void = class({})

function modifier_void_demon_time_void:IsPurgable() return true end
function modifier_void_demon_time_void:IsDebuff() return true end
function modifier_void_demon_time_void:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_void_demon_time_void:GetEffectName() return "particles/units/heroes/hero_night_stalker/nightstalker_void.vpcf" end

function modifier_void_demon_time_void:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end

function modifier_void_demon_time_void:OnRefresh()
	self.fSlow = self:GetAbility():GetSpecialValueFor("movespeed_slow")
end

function modifier_void_demon_time_void:GetModifierMoveSpeedBonus_Percentage()
	self.fSlow = self.fSlow or self:GetAbility():GetSpecialValueFor("movespeed_slow")
	return self.fSlow
end

function modifier_void_demon_time_void:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("attackspeed_slow") end

void_demon_degen_aura = class({})
function void_demon_degen_aura:GetIntrinsicModifierName() return "modifier_void_demon_degen_aura" end

modifier_void_demon_degen_aura = class({})


function modifier_void_demon_degen_aura:IsHidden() return true end
function modifier_void_demon_degen_aura:IsAura() return true end
function modifier_void_demon_degen_aura:GetAuraSearchFlags()return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end

function modifier_void_demon_degen_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_void_demon_degen_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end

function modifier_void_demon_degen_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_void_demon_degen_aura:GetModifierAura() return "modifier_void_demon_degen_aura_slow" end

modifier_void_demon_degen_aura_slow = class({})

function modifier_void_demon_degen_aura_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end

function modifier_void_demon_degen_aura_slow:GetModifierMoveSpeedBonus_Percentage()
	if self:GetCaster():PassivesDisabled() then return 0 end
	if not self.hSpecial then
		self.hSpecial = Entities:First()
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_void_demon_2" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end	
	end

	if self.hSpecial then
		self.fSlow = (self.hSpecial:GetSpecialValueFor("value")+1)*self:GetAbility():GetSpecialValueFor("movement")
	else
		self.fSlow = self:GetAbility():GetSpecialValueFor("movement")
	end
	
	return self.fSlow
end

function modifier_void_demon_degen_aura_slow:GetModifierAttackSpeedBonus_Constant()
	if self:GetCaster():PassivesDisabled() then return 0 end
	if not self.hSpecial then
		self.hSpecial = Entities:First()
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_void_demon_2" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end	
	end
	if self.hSpecial then
		return (self.hSpecial:GetSpecialValueFor("value")+1)*self:GetAbility():GetSpecialValueFor("attack")
	else
		return self:GetAbility():GetSpecialValueFor("attack")
	end
end

function modifier_void_demon_degen_aura_slow:GetEffectName() return "particles/degen_aura_debuff.vpcf" end
function modifier_void_demon_degen_aura_slow:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end