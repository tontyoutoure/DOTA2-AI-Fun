LinkLuaModifier("modifier_flame_lord_enflame", "heroes/flame_lord/flame_lord_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_flame_lord_liquid_fire_debuff", "heroes/flame_lord/flame_lord_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_flame_lord_fire_storm_debuff", "heroes/flame_lord/flame_lord_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
local function FlameLordEnflameOnSpellStart(self)
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_flame_lord_enflame", {Duration = self:GetSpecialValueFor("duration")})
end

local function FlameLordEnflameCastFilterResultTarget(self, hTarget)
	if hTarget == self:GetCaster() then 
		return UF_FAIL_CUSTOM
	elseif hTarget:IsBuilding() then
		return UF_FAIL_BUILDING
	end
end

local function FlameLordEnflameGetCustomCastErrorTarget(self, hTarget)
	return "#dota_hud_error_cant_cast_on_self"
end

local FlameLordEnflameGetAOERadius = function (self)
	if self:GetCaster():HasScepter() then return self:GetSpecialValueFor("radius_scepter") else return self:GetSpecialValueFor("radius") end
end

flame_lord_enflame = class({})
flame_lord_enflame.GetAOERadius = FlameLordEnflameGetAOERadius
flame_lord_enflame.OnSpellStart = FlameLordEnflameOnSpellStart
flame_lord_enflame.CastFilterResultTarget = FlameLordEnflameCastFilterResultTarget
flame_lord_enflame.GetCustomCastErrorTarget = FlameLordEnflameGetCustomCastErrorTarget

flame_lord_enflame_talented = class({})
flame_lord_enflame_talented.GetAOERadius = FlameLordEnflameGetAOERadius
flame_lord_enflame_talented.OnSpellStart = FlameLordEnflameOnSpellStart
flame_lord_enflame_talented.CastFilterResultTarget = FlameLordEnflameCastFilterResultTarget
flame_lord_enflame_talented.GetCustomCastErrorTarget = FlameLordEnflameGetCustomCastErrorTarget

local FlameLordFireStormOnSpellStart = function (self)
	self.fCastTime = GameRules:GetGameTime()
	self.vPos = self:GetCursorPosition()
	self.fDamage = self:GetSpecialValueFor("damage")
	self.iWave = 0
end

local FlameLordFireStormWave = function (hAbility)
	local iRadius = hAbility:GetSpecialValueFor("radius")
	local hCaster = hAbility:GetCaster()
	local iParticle = ParticleManager:CreateParticle("particles/flame_lord/flame_lord_firestorm_wave.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(iParticle, 0, hAbility.vPos)
	ParticleManager:SetParticleControl(iParticle, 4, Vector(iRadius, 0, 0))
	EmitSoundOnLocationWithCaster(hAbility.vPos, "Hero_AbyssalUnderlord.Firestorm", hAbility:GetCaster())
	local tTargets
	if hCaster:HasAbility("special_bonus_unique_flame_lord_2") and hCaster:FindAbilityByName("special_bonus_unique_flame_lord_2"):GetLevel() > 0 then
		tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hAbility.vPos, nil, iRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING+DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	else
		tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hAbility.vPos, nil, iRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	end
	for k, v in ipairs(tTargets) do		
		ApplyDamage({attacker = hCaster, victim = v, ability = hAbility, damage_type = hAbility:GetAbilityDamageType(), damage = hAbility.fDamage})
		v:AddNewModifier(hCaster, hAbility, "modifier_flame_lord_fire_storm_debuff", {Duration = CalculateStatusResist(v)})
	end
end


local FlameLordFireStormOnChannelThink = function (self, fInterval)
	if GameRules:GetGameTime()-self.fCastTime > self.iWave then
		FlameLordFireStormWave(self)
		self.iWave = self.iWave+1	
	end
end

local FlameLordFireStormGetChannelAnimation = function(self)
	return ACT_DOTA_CHANNEL_ABILITY_3
end

local FlameLordFireStormGetChannelTime = function(self)
	return self:GetSpecialValueFor("wave_count")-1
end

local FlameLordFireStormOnChannelFinish = function(self, bInterrupted)
	if not bInterrupted then
		FlameLordFireStormWave(self)
	end
end

local FlameLordFireStormGetAOERadius = function(self)
	return self:GetSpecialValueFor("radius")
end

flame_lord_fire_storm_talented = class({})
flame_lord_fire_storm_talented.OnSpellStart = FlameLordFireStormOnSpellStart
flame_lord_fire_storm_talented.OnChannelThink = FlameLordFireStormOnChannelThink
flame_lord_fire_storm_talented.GetChannelAnimation = FlameLordFireStormGetChannelAnimation
flame_lord_fire_storm_talented.GetChannelTime = FlameLordFireStormGetChannelTime
flame_lord_fire_storm_talented.GetAOERadius = FlameLordFireStormGetAOERadius
flame_lord_fire_storm_talented.OnChannelFinish = FlameLordFireStormOnChannelFinish

flame_lord_fire_storm = class({})
flame_lord_fire_storm.OnSpellStart = FlameLordFireStormOnSpellStart
flame_lord_fire_storm.OnChannelThink = FlameLordFireStormOnChannelThink
flame_lord_fire_storm.GetChannelAnimation = FlameLordFireStormGetChannelAnimation
flame_lord_fire_storm.GetChannelTime = FlameLordFireStormGetChannelTime
flame_lord_fire_storm.GetAOERadius = FlameLordFireStormGetAOERadius
flame_lord_fire_storm.OnChannelFinish = FlameLordFireStormOnChannelFinish

FlameLordLiquidFireLanded = function(keys)
	if keys.caster:PassivesDisabled() or keys.target:GetTeam() == keys.caster:GetTeam() or keys.target:IsMagicImmune() then return end
	if keys.target:IsHero() then
		keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_flame_lord_liquid_fire_debuff", {Duration = keys.ability:GetSpecialValueFor("duration_hero")*CalculateStatusResist(keys.target)})
	else
		keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_flame_lord_liquid_fire_debuff", {Duration = keys.ability:GetSpecialValueFor("duration_non_hero")*CalculateStatusResist(keys.target)})
	end
end


flame_lord_flameshot = class({})
function flame_lord_flameshot:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:EmitSound("Hero_OgreMagi.Ignite.Cast")
	if self.hSpecial and self.hSpecial:GetLevel() > 0 then
		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), self:GetCursorPosition(), nil, self.hSpecial:GetSpecialValueFor("value"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for k, v in ipairs(tTargets) do
			ProjectileManager:CreateTrackingProjectile{	
				Target = v,
				Source = hCaster,
				Ability = self,	
				EffectName = "particles/hw_fx/hw_rosh_fireball.vpcf",
				iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
				vSourceLoc= hCaster:GetAbsOrigin(),                -- Optional (HOW)
				bDrawsOnMinimap = false,                          -- Optional
				bDodgeable = true,                                -- Optional
				bVisibleToEnemies = true,                         -- Optional
				flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
				bProvidesVision = false,                      -- Optional	
				ExtraData = {bIsTarget = 0}
			}
		end
	else
		if self:GetCursorTarget():TriggerSpellAbsorb(self) then return end
		ProjectileManager:CreateTrackingProjectile{	
			Target = self:GetCursorTarget(),
			Source = hCaster,
			Ability = self,	
			EffectName = "particles/hw_fx/hw_rosh_fireball.vpcf",
			iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
			vSourceLoc= hCaster:GetAbsOrigin(),                -- Optional (HOW)
			bDrawsOnMinimap = false,                          -- Optional
			bDodgeable = true,                                -- Optional
			bVisibleToEnemies = true,                         -- Optional
			flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
			bProvidesVision = false,                      -- Optional	
			ExtraData = {bIsTarget = 1}		
		}
	end	
end

function flame_lord_flameshot:OnProjectileHit_ExtraData(hTarget, vLocation, tExtraData)
	if tExtraData.bIsTarget > 0 then
		if hTarget:TriggerSpellAbsorb( self ) then return end
	end
	if hTarget:IsMagicImmune() then return end
	local iStunDuration = self:GetSpecialValueFor("stun_duration")
	local hCaster = self:GetCaster()
	hTarget:AddNewModifier(hCaster, self, "modifier_stunned", {Duration = iStunDuration*CalculateStatusResist(hTarget)})
	ApplyDamage({
		victim = hTarget,
		attacker = hCaster,
		ability = self,
		damage_type = self:GetAbilityDamageType(),
		damage = self:GetSpecialValueFor("damage")
	})
	local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_POINT_FOLLOW, hTarget)
	ParticleManager:SetParticleControl(iParticle, 1, hTarget:GetAbsOrigin())
	hTarget:EmitSound("Hero_OgreMagi.Fireblast.Target")
end

function flame_lord_flameshot:GetBehavior()
	if not self.bFoundSpecial then
		self.hSpecial = Entities:First()	
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_unique_flame_lord_3" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end	
		self.bFoundSpecial = true		
	end
	if self.hSpecial and self.hSpecial:GetLevel() > 0 then
		return DOTA_ABILITY_BEHAVIOR_AOE+DOTA_ABILITY_BEHAVIOR_POINT
	else
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
end

function flame_lord_flameshot:GetAOERadius()
	if not self.bFoundSpecial then
		self.hSpecial = Entities:First()	
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_unique_flame_lord_3" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end	
		self.bFoundSpecial = true		
	end
	if self.hSpecial then
		return self.hSpecial:GetSpecialValueFor("value")
	else
		return 0
	end
end