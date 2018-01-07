LinkLuaModifier("modifier_void_demon_time_void", "heroes/void_demon/void_demon_time_void.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_demon_degen_aura", "heroes/void_demon/void_demon_time_void.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_demon_degen_aura_slow", "heroes/void_demon/void_demon_time_void.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_demon_mass_haste", "heroes/void_demon/void_demon_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_demon_mass_haste_accelerate", "heroes/void_demon/void_demon_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
void_demon_time_void = class({})

function void_demon_time_void:GetCooldown(iLevel)
	if not self.hSpecial then
		self.hSpecial = Entities:First()
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_void_demon_1" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end	
	end	
	if self.hSpecial then
		return self.BaseClass.GetCooldown(self, iLevel)-self.hSpecial:GetSpecialValueFor("value")
	else
		return self.BaseClass.GetCooldown(self, iLevel)
	end
end

function void_demon_time_void:OnSpellStart()
	if self:GetCursorTarget():TriggerSpellAbsorb( self ) then return end
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:EmitSound("Hero_Nightstalker.Void")
	local damageTable = {
		attacker = hCaster,
		victim = hTarget,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
		damage = self:GetSpecialValueFor("damage")
	}
	ApplyDamage(damageTable)
	hTarget:AddNewModifier(hCaster, self, "modifier_stunned", {Duration = 0.01})
	hTarget:AddNewModifier(hCaster, self, "modifier_void_demon_time_void", {Duration = self:GetSpecialValueFor("duration")*CalculateStatusResist(hTarget)})
end

modifier_void_demon_time_void = class({})

function modifier_void_demon_time_void:IsPurgable() return true end
function modifier_void_demon_time_void:IsDebuff() return true end
function modifier_void_demon_time_void:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_void_demon_time_void:GetEffectName() return "particles/units/heroes/hero_night_stalker/nightstalker_void.vpcf" end

function modifier_void_demon_time_void:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end

function modifier_void_demon_time_void:GetModifierMoveSpeedBonus_Percentage()
	local fResist
	if IsClient() then 
		fResist = -self:GetStackCount()/1000
	else
		fResist = CalculateStatusResist(self:GetParent())
		self:SetStackCount(-fResist*1000)
	end
	self.fSlow = self.fSlow or self:GetAbility():GetSpecialValueFor("movespeed_slow")
	return fResist*self.fSlow
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
	
	local fResist
	if IsClient() then 
		fResist = -self:GetStackCount()/1000
	else
		fResist = CalculateStatusResist(self:GetParent())
		self:SetStackCount(-fResist*1000)
	end
	
	if self.hSpecial then
		self.fSlow = (self.hSpecial:GetSpecialValueFor("value")+1)*self:GetAbility():GetSpecialValueFor("movement")
	else
		self.fSlow = self:GetAbility():GetSpecialValueFor("movement")
	end
	
	return fResist*self.fSlow
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

function VoidDemonMassHasteApply(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_void_demon_mass_haste", {})
end