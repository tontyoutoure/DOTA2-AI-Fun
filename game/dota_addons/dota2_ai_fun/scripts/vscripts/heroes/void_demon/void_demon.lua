LinkLuaModifier("modifier_void_demon_time_void", "heroes/void_demon/void_demon_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_demon_degen_aura", "heroes/void_demon/void_demon_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_demon_degen_aura_slow", "heroes/void_demon/void_demon_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_demon_mass_haste", "heroes/void_demon/void_demon_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_demon_mass_haste_accelerate", "heroes/void_demon/void_demon_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_demon_mass_haste_fly_aura", "heroes/void_demon/void_demon_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_demon_mass_haste_fly", "heroes/void_demon/void_demon_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

void_demon_time_void = class({})

function void_demon_time_void:GetCooldown(iLevel)
	if not self.hSpecial then
		self.hSpecial = Entities:First()
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_unique_void_demon_1" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
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

void_demon_mass_haste = class({})

function void_demon_mass_haste:GetIntrinsicModifierName()
	return "modifier_void_demon_mass_haste" 
end

function void_demon_mass_haste:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	else
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
end

function void_demon_mass_haste:GetCooldown()
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor('cooldown_scepter')
	else
		return 0
	end
end

function void_demon_mass_haste:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:EmitSound('Hero_Nightstalker.Darkness')
	hCaster:AddNewModifier(hCaster, self, 'modifier_void_demon_mass_haste_fly_aura', {Duration = self:GetSpecialValueFor('fly_duration_scepter')})
end


function void_demon_quake_OnSpellStart(keys)
	local hAbility = keys.ability
	local hCaster = keys.caster 
	local vPoint = keys.target_points[1]
	ProcsArroundingMagicStick(hCaster)
	hCaster.hQuakeThinker = CreateModifierThinker(hCaster, hAbility, "modifier_void_demon_quake_aura_lua", {}, vPoint, hCaster:GetTeamNumber(), false)

	local tAllModifiers = hCaster.hQuakeThinker:FindAllModifiers()
	tAllModifiers[1].iRadius = hAbility:GetSpecialValueFor("radius")
	tAllModifiers[1].fDamage = hAbility:GetSpecialValueFor("damage")
end

function void_demon_quake_OnChannelFinish(keys)
	local hCaster = keys.caster 
	hCaster.hQuakeThinker:RemoveSelf()
end

void_demon_degen_aura = class({})
function void_demon_degen_aura:GetIntrinsicModifierName() return 'modifier_void_demon_degen_aura' end