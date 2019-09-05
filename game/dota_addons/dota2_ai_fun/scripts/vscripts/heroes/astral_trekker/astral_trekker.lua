LinkLuaModifier("modifier_astral_trekker_entrapment", "heroes/astral_trekker/astral_trekker_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_astral_trekker_war_stomp_changer", "heroes/astral_trekker/astral_trekker_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_astral_trekker_war_stomp_talented_changer", "heroes/astral_trekker/astral_trekker_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_astral_trekker_giant_growth", "heroes/astral_trekker/astral_trekker_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_astral_trekker_pulverize", "heroes/astral_trekker/astral_trekker_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_astral_trekker_pulverize_break", "heroes/astral_trekker/astral_trekker_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

astral_trekker_entrapment = class({})
function astral_trekker_entrapment:GetBehavior()
	if not self.hSpecial then
		self.hSpecial = Entities:First()
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_astral_trekker_1" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end
	end
	if self.hSpecial and self.hSpecial:GetSpecialValueFor("value") > 0 then return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET+DOTA_ABILITY_BEHAVIOR_AOE
	else return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
end
--function astral_trekker_entrapment:ProcsMagicStick() return true end

function astral_trekker_entrapment:OnSpellStart()
	self:ProcsMagicStick()
	if not self.hSpecial then
		self.hSpecial = Entities:First()
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_astral_trekker_1" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end
	end
	
	local hCaster = self:GetCaster()
	hCaster:EmitSound("Hero_NagaSiren.Ensnare.Cast")
	local iAOE 
	if self.hSpecial then iAOE = self.hSpecial:GetSpecialValueFor("value") else iAOE = 0 end
	local hTarget = self:GetCursorTarget()

	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hTarget:GetOrigin(), nil, iAOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for i, v in ipairs(tTargets) do
		ProjectileManager:CreateTrackingProjectile({
		Target = v,
		Source = hCaster,
		Ability = self,
		EffectName = "particles/units/heroes/hero_siren/siren_net_projectile.vpcf",
		iMoveSpeed = self:GetSpecialValueFor("net_speed"),
		vSourceLoc= hCaster:GetAbsOrigin(),                -- Optional (HOW)
		bDrawsOnMinimap = false,                          -- Optional
		bDodgeable = false,                                -- Optional
		bIsAttack = false,                                -- Optional
		bVisibleToEnemies = true,                         -- Optional
		bReplaceExisting = false,                         -- Optional
		flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
		bProvidesVision = true,                           -- Optional
		iVisionRadius = 400,                              -- Optional
		iVisionTeamNumber = hCaster:GetTeamNumber(),       -- Optional
		ExtraData = {bIsTarget = (v==hTarget)}
		})
	end

end

function astral_trekker_entrapment:OnProjectileHit_ExtraData(hTarget, vLocation, tExtraData)
	if tExtraData.bIsTarget > 0 then
		if hTarget:TriggerSpellAbsorb( self ) then return end
	end
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_astral_trekker_entrapment", {Duration = self:GetSpecialValueFor("duration")*CalculateStatusResist(hTarget)})
	hTarget:EmitSound("Hero_NagaSiren.Ensnare.Target")
end



function astral_trekker_giant_growth_activate(keys)
	ProcsArroundingMagicStick(keys.caster)
	local hCaster = keys.caster
	keys.ability.ProcsMagicStick = function (self) return true end
	for i = 1, 30 do
		Timers(i/24, function ()
			hCaster:SetModelScale(hCaster:GetModelScale()+0.02) 			
			
		end)
	end	
end

function astral_trekker_giant_growth_deactivate(keys)
	local hCaster = keys.caster
	for i = 1, 30 do
		Timers(i/24, function () 
			hCaster:SetModelScale(hCaster:GetModelScale()-0.02)
		end)
	end
	
end

astral_trekker_war_stomp = class({})
astral_trekker_war_stomp_talented = class({})
function astral_trekker_war_stomp:GetCastRange() return self:GetSpecialValueFor("radius") end
function astral_trekker_war_stomp_talented:GetCastRange() return self:GetSpecialValueFor("radius") end
local AstralTrekkerWarStomp = function (self)
	local iRadius = self:GetSpecialValueFor("radius")
	local hCaster = self:GetCaster()
	if hCaster:FindAbilityByName("special_bonus_astral_trekker_2") and hCaster:FindAbilityByName("special_bonus_astral_trekker_2"):GetSpecialValueFor("value") > 0 then
		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetOrigin(), nil, iRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for i, v in ipairs(tTargets) do
			v:AddNewModifier(hCaster, self, "modifier_stunned", {Duration = self:GetSpecialValueFor("stun_duration")*CalculateStatusResist(v)})
			ApplyDamage({
				attacker = hCaster,
				victim = v,
				ability = self,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage = self:GetSpecialValueFor("damage")
			})
		end
		hCaster:EmitSound("Hero_Centaur.HoofStomp")
		ParticleManager:SetParticleControl(ParticleManager:CreateParticle("particles/econ/items/centaur/centaur_ti6_gold/centaur_ti6_warstomp_gold.vpcf", PATTACH_ABSORIGIN, hCaster), 1, Vector(iRadius, iRadius, iRadius))
	else
		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetOrigin(), nil, iRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for i, v in ipairs(tTargets) do
			v:AddNewModifier(hCaster, self, "modifier_stunned", {Duration = self:GetSpecialValueFor("stun_duration")*CalculateStatusResist(v)})
			ApplyDamage({
				attacker = hCaster,
				victim = v,
				ability = self,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage = self:GetSpecialValueFor("damage")
			})
		end
		hCaster:EmitSound("Hero_Centaur.HoofStomp")
		ParticleManager:SetParticleControl(ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_ABSORIGIN, hCaster), 1, Vector(iRadius, iRadius, iRadius))
	end
end

astral_trekker_war_stomp.OnSpellStart = AstralTrekkerWarStomp
astral_trekker_war_stomp_talented.OnSpellStart = AstralTrekkerWarStomp

--function astral_trekker_war_stomp:ProcsMagicStick() return true end
--function astral_trekker_war_stomp_talented:ProcsMagicStick() return true end

function astral_trekker_war_stomp:GetIntrinsicModifierName() return "modifier_astral_trekker_war_stomp_changer" end
function astral_trekker_war_stomp_talented:GetIntrinsicModifierName() return "modifier_astral_trekker_war_stomp_talented_changer" end

astral_trekker_pulverize = class({})
function astral_trekker_pulverize:GetIntrinsicModifierName() return "modifier_astral_trekker_pulverize" end

