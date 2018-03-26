LinkLuaModifier("modifier_spongebob_krabby_food", "heroes/spongebob/spongebob_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spongebob_spongify", "heroes/spongebob/spongebob_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
spongebob_krabby_food = class({})

function spongebob_krabby_food:GetBehavior()
	self.hSpecial = Entities:First()
	
	while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_spongebob_3" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
		self.hSpecial = Entities:Next(self.hSpecial)
	end		
	if self.hSpecial and self.hSpecial:GetSpecialValueFor("value") > 0 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	else
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
end
function spongebob_krabby_food:GetManaCost(iLevel)
	if IsClient() then
		if self:GetCaster():HasScepter() then
			if iLevel >= 0 then			
				return 300-iLevel*100
			else 
				return 0
			end
		else
			return self.BaseClass.GetManaCost(self, iLevel)
		end
	else
		if self:GetCaster():HasScepter() then
			return self:GetLevelSpecialValueFor("manacost_scepter", iLevel)
		else
			return self.BaseClass.GetManaCost(self, iLevel)
		end
	end
end
function spongebob_krabby_food:OnSpellStart()
	local hCaster = self:GetCaster()
	if hCaster:HasAbility("special_bonus_spongebob_3") and hCaster:FindAbilityByName("special_bonus_spongebob_3"):GetSpecialValueFor("value") > 0 then
		for k, v in pairs(FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false))
		do
			v:EmitSound("DOTA_Item.HealingSalve.Activate")
			v:AddNewModifier(hCaster, self, "modifier_spongebob_krabby_food", {Duration = self:GetSpecialValueFor("duration")})
		end
	else
		self:GetCursorTarget():EmitSound("DOTA_Item.HealingSalve.Activate")
		self:GetCursorTarget():AddNewModifier(hCaster, self, "modifier_spongebob_krabby_food", {Duration = self:GetSpecialValueFor("duration")})
	end
end

spongebob_karate_chop = class({})
function spongebob_karate_chop:GetCastRange()
	return self:GetSpecialValueFor("range")
end
function spongebob_karate_chop:GetCooldown(iLevel)
	self.hSpecial = Entities:First()
	
	while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_spongebob_4" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
		self.hSpecial = Entities:Next(self.hSpecial)
	end		
	if self.hSpecial then
		return self.BaseClass.GetCooldown(self, iLevel)-self.hSpecial:GetSpecialValueFor("value")
	else
		return self.BaseClass.GetCooldown(self, iLevel)
	end
end
function spongebob_karate_chop:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	if hTarget:TriggerSpellAbsorb(self) then return end
	ApplyDamage({victim = hTarget, ability = self, attacker = hCaster, damage_type = self:GetAbilityDamageType(), damage = self:GetSpecialValueFor("damage")})
	hTarget:ReduceMana(self:GetSpecialValueFor("mana_loss"))
	hTarget:AddNewModifier(hCaster, self, "modifier_stunned", {Duration = self:GetSpecialValueFor("stun_duration")*CalculateStatusResist(hTarget)})	
	hTarget:EmitSound("Hero_Sven.StormBoltImpact")	
	local iParticle = ParticleManager:CreateParticle("particles/econ/items/troll_warlord/troll_warlord_ti7_axe/troll_ti7_axe_bash_explosion_swish.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:SetParticleControlEnt(iParticle, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_origin", hTarget:GetAbsOrigin(), true)
end

function SpongeBobJellyfishNet(keys)
	if keys.caster:PassivesDisabled() then return end
	local iChance
	local iDuration
	if keys.target:IsBuilding() or keys.target:GetTeam() == keys.caster:GetTeam() then return end
	if keys.caster:IsIllusion() then 
		if keys.target:IsHero() then
			iChance = keys.ability:GetSpecialValueFor("chance_illusion_hero")
			iDuration = keys.ability:GetSpecialValueFor("hero_duration")
		else
			iChance = keys.ability:GetSpecialValueFor("chance_illusion")
			iDuration = keys.ability:GetSpecialValueFor("duration")
		end
	else
		if keys.target:IsHero() then
			iChance = keys.ability:GetSpecialValueFor("chance_hero")
			iDuration = keys.ability:GetSpecialValueFor("hero_duration")
		else
			iChance = keys.ability:GetSpecialValueFor("chance")
			iDuration = keys.ability:GetSpecialValueFor("duration")
		end
	end
	if keys.caster:HasAbility("special_bonus_spongebob_1") then
		iDuration = iDuration+keys.caster:FindAbilityByName("special_bonus_spongebob_1"):GetSpecialValueFor("value")
	end
	if RandomInt(1, 100) <= iChance then
		keys.target:EmitSound("Hero_NagaSiren.Ensnare.Target")
		keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_naga_siren_ensnare", {Duration = iDuration})
	end
end

spongebob_spongify = class({})

function spongebob_spongify:GetIntrinsicModifierName()
	return "modifier_spongebob_spongify"
end

