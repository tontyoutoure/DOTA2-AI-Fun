LinkLuaModifier("modifier_astral_trekker_war_stomp_changer", "heroes/astral_trekker/astral_trekker_giant_growth.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_astral_trekker_war_stomp_talented_changer", "heroes/astral_trekker/astral_trekker_giant_growth.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_astral_trekker_giant_growth", "heroes/astral_trekker/astral_trekker_giant_growth.lua", LUA_MODIFIER_MOTION_NONE)


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

modifier_astral_trekker_war_stomp_changer = class({})
modifier_astral_trekker_war_stomp_talented_changer = class({})
function modifier_astral_trekker_war_stomp_changer:IsHidden() return true end
function modifier_astral_trekker_war_stomp_talented_changer:IsHidden() return true end
function modifier_astral_trekker_war_stomp_changer:OnCreated() self:StartIntervalThink(0.1) end
function modifier_astral_trekker_war_stomp_talented_changer:OnCreated() self:StartIntervalThink(0.1) end

function modifier_astral_trekker_war_stomp_changer:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
--	print(hParent:HasAbility("special_bonus_astral_trekker_2"), hParent:FindAbilityByName("special_bonus_astral_trekker_2"):GetLevel())
	if hParent:HasAbility("special_bonus_astral_trekker_2") and hParent:FindAbilityByName("special_bonus_astral_trekker_2"):GetLevel() > 0 then
		local iLevel = hParent:FindAbilityByName("astral_trekker_war_stomp"):GetLevel()
		hParent:RemoveAbility("astral_trekker_war_stomp")
		hParent:AddAbility("astral_trekker_war_stomp_talented"):SetLevel(iLevel)
		self:Destroy()
	end
end

function modifier_astral_trekker_war_stomp_talented_changer:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	if (not hParent:HasAbility("special_bonus_astral_trekker_2")) or hParent:FindAbilityByName("special_bonus_astral_trekker_2"):GetLevel() == 0 then
		local iLevel = hParent:FindAbilityByName("astral_trekker_war_stomp_talented"):GetLevel()
		hParent:RemoveAbility("astral_trekker_war_stomp_talented")
		hParent:AddAbility("astral_trekker_war_stomp"):SetLevel(iLevel)
		self:Destroy()
	end
end

function AstralTrekkerPulverize(keys)
	if keys.caster:PassivesDisabled() then return end
	for k, v in ipairs(keys.target_entities) do
		ApplyDamage({damage = keys.ability:GetSpecialValueFor("damage"), attacker = keys.caster, victim = v, damage_type = keys.ability:GetAbilityDamageType(), ability = keys.ability})
	end
end