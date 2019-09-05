LinkLuaModifier("modifier_old_holy_knight_purge_slow", "heroes/old_holy_knight/old_holy_knight_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_old_holy_knight_critical_strike", "heroes/old_holy_knight/old_holy_knight_modifiers.lua", LUA_MODIFIER_MOTION_NONE)


old_holy_knight_purge = class({})

function old_holy_knight_purge:GetBehavior()
	if not self.bSpecial then
		self.hSpecial = Entities:First()		
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_unique_old_holy_knight_2" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end	
		self.bSpecial = true	
	end
	if self.hSpecial and self.hSpecial:GetLevel() > 0 then
		return DOTA_ABILITY_BEHAVIOR_POINT+DOTA_ABILITY_BEHAVIOR_AOE
	else
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
end

local function PurgeUnit(hTarget, hCaster, hAbility)
	hTarget:EmitSound("DOTA_Item.DiffusalBlade.Activate")
	if hTarget:GetTeam() == hCaster:GetTeam() then
		hTarget:Purge(false, true, false, false, false)
		ParticleManager:CreateParticle("particles/generic_gameplay/generic_purge.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	else
		hTarget:Purge(true, false, false, false, false)
		ParticleManager:CreateParticle("particles/generic_gameplay/generic_purge.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
		if hTarget:HasModifier("modifier_kill") then
			hTarget:Kill(hAbility, hCaster)
		else
			hTarget:AddNewModifier(hCaster, hAbility, "modifier_old_holy_knight_purge_slow", {Duration = hAbility:GetSpecialValueFor("slow_duration")*(1-hTarget:GetStatusResistance())})
		end
	end
end

function old_holy_knight_purge:GetAOERadius()
	if self.hSpecial then
		return self.hSpecial:GetSpecialValueFor("value")
	else
		return 0
	end	
end

function old_holy_knight_purge:OnSpellStart()	
	if self.hSpecial and self.hSpecial:GetLevel() > 0 then
		local hCaster = self:GetCaster()
		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), self:GetCursorPosition(), nil, self.hSpecial:GetSpecialValueFor("value"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES, FIND_ANY_ORDER, false)
		for k, v in ipairs(tTargets) do
			v:EmitSound("DOTA_Item.DiffusalBlade.Activate")
			PurgeUnit(v, hCaster, self)
		end
	else
		local hCaster = self:GetCaster()
		local hTarget = self:GetCursorTarget()
		if hTarget:TriggerSpellAbsorb( self ) then return end
		hTarget:EmitSound("DOTA_Item.DiffusalBlade.Activate")
		PurgeUnit(hTarget, hCaster, self)
	end
end

old_holy_knight_holy_light = class({})
function old_holy_knight_holy_light:CastFilterResultTarget(hTarget)
	if hTarget == self:GetCaster() then
		return UF_FAIL_CUSTOM
	else
		return UF_SUCCESS
	end
end
function old_holy_knight_holy_light:GetCustomCastErrorTarget(hTarget)
	return "dota_hud_error_cant_cast_on_self"
end
function old_holy_knight_holy_light:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local iHeal = self:GetSpecialValueFor("heal")
	local iDamage = self:GetSpecialValueFor("damage")
	local hSpecial = self:GetCaster():FindAbilityByName("special_bonus_unique_old_holy_knight_0")
	if hSpecial then
		iHeal = iHeal+hSpecial:GetSpecialValueFor("value")
		iDamage = iDamage+hSpecial:GetSpecialValueFor("value")
	end
	ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	hTarget:EmitSound("Hero_Chen.TestOfFaith.Target")
	hCaster:EmitSound("Hero_Chen.TestOfFaith.hCaster")
	if hTarget:GetTeam() == hCaster:GetTeam() then
		hTarget:Heal(iHeal,hCaster)
		SendOverheadEventMessage(hTarget:GetPlayerOwner(), OVERHEAD_ALERT_HEAL , hTarget, iHeal, nil)		
	else
		ApplyDamage({attacker = hCaster, victim = hTarget, ability = self, damage_type = DAMAGE_TYPE_MAGICAL, damage = iDamage})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE , hTarget, iDamage, nil)	
	end
end

old_holy_knight_critical_strike = class({})
function old_holy_knight_critical_strike:GetIntrinsicModifierName() return "modifier_old_holy_knight_critical_strike" end

old_holy_knight_holy_persuation = class({})
function old_holy_knight_holy_persuation:CastFilterResultTarget(hTarget)
	if IsClient() then return UF_SUCCESS end
	if hTarget:IsHero() then return UF_FAIL_HERO
	elseif hTarget:GetTeam() == self:GetCaster():GetTeam() then return UF_FAIL_FRIENDLY
	elseif hTarget:IsAncient() and not self:GetCaster():HasScepter() then return UF_FAIL_ANCIENT
	elseif hTarget:IsConsideredHero() then return UF_FAIL_CONSIDERED_HERO
	elseif hTarget:GetClassname() == "npc_dota_roshan" then return UF_FAIL_CUSTOM
	else return UF_SUCCESS
	end
end
function old_holy_knight_holy_persuation:GetCustomCastErrorTarget(hTarget)
	return "dota_hud_error_cant_cast_on_roshan"
end


function old_holy_knight_holy_persuation:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hCaster:EmitSound("Hero_Chen.HolyPersuasionCast")
	local tUnits = FindUnitsInRadius(hCaster:GetTeamNumber(), hTarget:GetOrigin(), nil, self:GetSpecialValueFor("range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, FIND_CLOSEST, false)
	PersueUnit(hCaster, hTarget, CheckTalent(hCaster, "special_bonus_unique_old_holy_knight_3"), true, "Hero_Chen.HolyPersuasionEnemy", "particles/units/heroes/hero_chen/chen_holy_persuasion.vpcf")
	local iPersuedUnits = 1
	local iMaxPersuedUnit = self:GetSpecialValueFor("count")
	for k, v in ipairs(tUnits) do
		if  v ~= hTarget and (not v:IsAncient() or hCaster:HasScepter()) then
			iPersuedUnits = iPersuedUnits+1
			if iPersuedUnits > iMaxPersuedUnit
				then return
			end
			PersueUnit(hCaster, v, CheckTalent(hCaster, "special_bonus_unique_old_holy_knight_3"), true, "Hero_Chen.HolyPersuasionEnemy", "particles/units/heroes/hero_chen/chen_holy_persuasion.vpcf")
		end
	end
end