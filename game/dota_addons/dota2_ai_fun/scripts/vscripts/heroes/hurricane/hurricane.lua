LinkLuaModifier("modifier_hurricane_tempest", "heroes/hurricane/hurricane_modifiers.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_hurricane_cyclone", "heroes/hurricane/hurricane_modifiers.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_hurricane_whirlewind", "heroes/hurricane/hurricane_modifiers.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_hurricane_eyes_of_the_storm", "heroes/hurricane/hurricane_modifiers.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_hurricane_eyes_of_the_storm_upgrade", "heroes/hurricane/hurricane_modifiers.lua", LUA_MODIFIER_MOTION_BOTH)

function HurricaneTempestApply(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_hurricane_tempest", {})
end

function HurricaneCyclone(keys)
	for i, v in ipairs(keys.target_entities) do
		if v ~= keys.caster then
			v:AddNewModifier(keys.caster, keys.ability, "modifier_hurricane_cyclone", {Duration = 1})
		end
	end
end

hurricane_whirlewind = class({})
function hurricane_whirlewind:OnSpellStart()
end

function hurricane_whirlewind:GetChannelTime()
	return self:GetSpecialValueFor("duration")
end

function hurricane_whirlewind:OnChannelThink(flInterval)
	local hCaster = self:GetCaster()
	ApplyDamage({attacker = hCaster, victim = hCaster, ability = self, damage = self:GetSpecialValueFor("damage_per_second_1")*flInterval, damage_type = self:GetAbilityDamageType()})
	local tTargets = FindUnitsInRadius(hCaster:GetTeam(), hCaster:GetOrigin(), nil, self:GetSpecialValueFor("radius_4"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for i, v in ipairs(tTargets) do
		if v ~= hCaster and not v:HasModifier("modifier_hurricane_whirlewind") then 
			v:AddNewModifier(hCaster, self, "modifier_hurricane_whirlewind", {})
		end
	end
end

function HurricaneWhirewind(keys)
	for i, v in ipairs(keys.target_entities) do
		if v ~= keys.caster then
			v:AddNewModifier(keys.caster, keys.ability, "modifier_hurricane_whirlewind", {Duration = keys.ability:GetSpecialValueFor("duration")})
		end
	end
end

hurricane_eyes_of_the_storm = class({})
function hurricane_eyes_of_the_storm:GetIntrinsicModifierName() return "modifier_hurricane_eyes_of_the_storm" end

function hurricane_eyes_of_the_storm:GetAbilityDamageType()
  if not self:GetCaster():HasScepter() then 
    return DAMAGE_TYPE_MAGICAL
  else
    return DAMAGE_TYPE_PURE
  end
end


function hurricane_eyes_of_the_storm:GetCastRange()
	if not self.hSpecial then
		self.hSpecial = Entities:First()
		
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_hurricane_5" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end		
	end
	if self.hSpecial then
		return self:GetSpecialValueFor("radius")+self.hSpecial:GetSpecialValueFor("value")
	else
		return self:GetSpecialValueFor("radius")
	end
end

function hurricane_eyes_of_the_storm:OnSpellStart()
	local hCaster = self:GetCaster()
	local iDamageType = self:GetAbilityDamageType()
	local fDamage = self:GetSpecialValueFor("damage_per_distance")
	local fRadius = self:GetSpecialValueFor("radius")
	if hCaster:HasAbility("special_bonus_hurricane_5") then
		fRadius = fRadius+hCaster:FindAbilityByName("special_bonus_hurricane_5"):GetSpecialValueFor("value")
	end
	local tTargets = FindUnitsInRadius(hCaster:GetTeam(), hCaster:GetOrigin(), nil, fRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	hCaster:EmitSound("Hero_Razor.Storm.Cast")
	for i, v in ipairs(tTargets) do
		v:EmitSound("Hero_razor.lightning")
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_storm_lightning_strike.vpcf", PATTACH_ABSORIGIN, v)
		ParticleManager:SetParticleControl(iParticle, 1, Vector(0,0,1000)+hCaster:GetOrigin())
		ApplyDamage({attacker = hCaster, victim = v, damage = (v:GetOrigin()-hCaster:GetOrigin()):Length2D()*fDamage, damage_type = iDamageType, ability = self})
	end
end

hurricane_eyes_of_the_storm_upgrade = class({})
function hurricane_eyes_of_the_storm_upgrade:GetIntrinsicModifierName() return "modifier_hurricane_eyes_of_the_storm_scepter" end

function hurricane_eyes_of_the_storm_upgrade:GetAbilityDamageType()
  if not self:GetCaster():HasScepter() then 
    return DAMAGE_TYPE_MAGICAL
  else
    return DAMAGE_TYPE_PURE
  end
end


function hurricane_eyes_of_the_storm_upgrade:GetCastRange()
	if not self.hSpecial then
		self.hSpecial = Entities:First()
		
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_hurricane_5" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end		
	end
	if self.hSpecial then
		return self:GetSpecialValueFor("radius")+self.hSpecial:GetSpecialValueFor("value")
	else
		return self:GetSpecialValueFor("radius")
	end
end

function hurricane_eyes_of_the_storm_upgrade:OnSpellStart()
	local hCaster = self:GetCaster()
	local iDamageType = self:GetAbilityDamageType()
	local fDamage = self:GetSpecialValueFor("damage_per_distance")
	local fRadius = self:GetSpecialValueFor("radius")
	if hCaster:HasAbility("special_bonus_hurricane_5") then
		fRadius = fRadius+hCaster:FindAbilityByName("special_bonus_hurricane_5"):GetSpecialValueFor("value")
	end
	local tTargets = FindUnitsInRadius(hCaster:GetTeam(), hCaster:GetOrigin(), nil, fRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	hCaster:EmitSound("Hero_Razor.Storm.Cast")
	for i, v in ipairs(tTargets) do
		v:EmitSound("Hero_razor.lightning")
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_storm_lightning_strike.vpcf", PATTACH_ABSORIGIN, v)
		ParticleManager:SetParticleControl(iParticle, 1, Vector(0,0,1000)+hCaster:GetOrigin())
		ApplyDamage({attacker = hCaster, victim = v, damage = (v:GetOrigin()-hCaster:GetOrigin()):Length2D()*fDamage, damage_type = iDamageType, ability = self})
	end
end