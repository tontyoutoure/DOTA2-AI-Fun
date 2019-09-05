LinkLuaModifier("modifier_felguard_fireblade_strike", "heroes/felguard/felguard_modifiers.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_felguard_felguard_wrath", "heroes/felguard/felguard_modifiers.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_felguard_strength_and_honor", "heroes/felguard/felguard_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_felguard_overflow", "heroes/felguard/felguard_modifiers.lua", LUA_MODIFIER_MOTION_NONE)


function FelguardFirebladeStrike(keys)
	ProcsArroundingMagicStick(keys.caster)
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end	
	local vSpeedHorizontal = 2500*Vector2D(keys.target:GetOrigin()-keys.caster:GetOrigin()):Normalized()
	local hModifier = keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_felguard_fireblade_strike", {Duration=keys.ability:GetSpecialValueFor("knock_back")/2500*CalculateStatusResist(keys.target)})
	hModifier.vSpeedHorizontal = vSpeedHorizontal
	ApplyDamage({damage = keys.ability:GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = keys.ability, attacker = keys.caster, victim = keys.target})
	ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
end

function FelguardWrath(keys)
	ProcsArroundingMagicStick(keys.caster)
	local vSpeedHorizontal = 2500*Vector2D(keys.target_points[1]-keys.caster:GetOrigin()):Normalized()
	local hModifier = keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_felguard_felguard_wrath", {Duration=Vector2D(keys.target_points[1]-keys.caster:GetOrigin()):Length2D()/2500})
	hModifier.vTarget = keys.target_points[1]
	hModifier.vSpeedHorizontal = vSpeedHorizontal
end

felguard_strength_and_honor = class({})

function felguard_strength_and_honor:GetIntrinsicModifierName() return "modifier_felguard_strength_and_honor" end
felguard_overflow = class({})

function felguard_overflow:GetBehavior()
	if self:GetCaster():HasScepter() then return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING 
end

function felguard_overflow:GetCooldown(num)
	if self:GetCaster():HasScepter() then return self:GetSpecialValueFor("cooldown_scepter") end
	return self.BaseClass.GetCooldown(self, num)
end

function felguard_overflow:GetManaCost(num)
	if self:GetCaster():HasScepter() then return self:GetSpecialValueFor("manacost_scepter") end
	return self.BaseClass.GetManaCost(self, num)
end

function felguard_overflow:OnToggle()
	local hCaster = self:GetCaster()
	if self:GetToggleState() then
		hCaster:EmitSound("Hero_Sven.GodsStrength")
		ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
		hCaster:AddNewModifier(hCaster, self, "modifier_felguard_overflow", nil)
	else
		hCaster:RemoveModifierByName("modifier_felguard_overflow")
	end
end

function felguard_overflow:OnSpellStart()
	local hCaster = self:GetCaster()
	if hCaster:HasScepter() then
	else
		hCaster:EmitSound("Hero_Sven.GodsStrength")
		ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
		hCaster:AddNewModifier(hCaster, self, "modifier_felguard_overflow", {Duration = self:GetSpecialValueFor("duration")})
	end
end