LinkLuaModifier("modifier_old_gorgon_purge_slow", "heroes/old_gorgon/old_gorgon_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_old_gorgon_mana_shield", "heroes/old_gorgon/old_gorgon_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

old_gorgon_purge = class({})

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
			hTarget:AddNewModifier(hCaster, hAbility, "modifier_old_gorgon_purge_slow", {Duration = hAbility:GetSpecialValueFor("slow_duration")*(1-hTarget:GetStatusResistance())})
		end
	end
end

function old_gorgon_purge:OnSpellStart()	
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	if hTarget:TriggerSpellAbsorb( self ) then return end
	hTarget:EmitSound("DOTA_Item.DiffusalBlade.Activate")
	PurgeUnit(hTarget, hCaster, self)
end

old_gorgon_mana_shield = class({})
function old_gorgon_mana_shield:OnToggle()
	local keys = {caster = self:GetCaster(), ability = self}
	if keys.caster:HasModifier("modifier_old_gorgon_mana_shield") then
		keys.caster:EmitSound("Hero_Medusa.ManaShield.Off")
		keys.caster:RemoveModifierByName("modifier_old_gorgon_mana_shield")
--		self:StartCooldown(self:GetCooldown(self:GetLevel())*keys.caster:GetCooldownReduction())
	else
		keys.caster:EmitSound("Hero_Medusa.ManaShield.On")
		keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_old_gorgon_mana_shield", {})
	end

end
old_gorgon_chain_lightning = class({})

function old_gorgon_chain_lightning:GetCooldown(iLevel)
	if not self.bSpecial then
		self.hSpecial = Entities:First()		
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_unique_old_gorgon_1" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end
		self.bSpecial = true
	end
	if self.hSpecial then
		return self.BaseClass.GetCooldown(self, iLevel)-self.hSpecial:GetSpecialValueFor("value")
	else
		return self.BaseClass.GetCooldown(self, iLevel)
	end
end
function old_gorgon_chain_lightning:OnSpellStart()
	
	local hTarget = self:GetCursorTarget()
	if hTarget:TriggerSpellAbsorb( self ) then return end
	local hAttacker = self:GetCaster()
	local hAbility = self
	local fFactor = 1-self:GetSpecialValueFor('damage_percent_loss')/100
	local fDamage = hAbility:GetSpecialValueFor("initial_damage")
	local fDelay = hAbility:GetSpecialValueFor("jump_delay")
	if CheckTalent(hAttacker, 'special_bonus_unique_old_gorgon_2') > 0 then
		hTarget:AddNewModifier(hAttacker, hAbility, 'modifier_stunned', {Duration = (1-hTarget:GetStatusResistance())*CheckTalent(hAttacker, 'special_bonus_unique_old_gorgon_2')})
	end
	local damageTable = {
		victim = hTarget,
		damage = fDamage,
		attacker = hAttacker,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = hAbility
	}
	
	ApplyDamage(damageTable)
	hTarget:EmitSound("Hero_Zuus.ArcLightning.Target")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_POINT_FOLLOW, hTarget)
	ParticleManager:SetParticleControlEnt(particle, 0, hAttacker, PATTACH_POINT_FOLLOW, "attach_attack1", hAttacker:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
	
	Timers:CreateTimer(fDelay, function () ChainLightningBounce(hAttacker, hTarget, hAbility:GetSpecialValueFor("jump_range"), fDamage*fFactor, hAbility:GetSpecialValueFor("bounce"), {hTarget}, hAbility, fDelay, fFactor) end)
end

function ChainLightningBounce(hCaster, hSource, iRadius, fDamage, iBounce, tTargets, hAbility, fDelay, fFactor)
	if iBounce == 0 then return end
	tAvailable = FindUnitsInRadius(hCaster:GetTeamNumber(), hSource:GetAbsOrigin(), nil, iRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	math.randomseed(GameRules:GetGameTime())
	for i = 1, #tTargets do
		local iRemove
		for j = 1, #tAvailable do
			if tTargets[i] == tAvailable[j] then iRemove = j end
		end
		if iRemove then
			table.remove(tAvailable, iRemove)
		end
	end	
	
	if #tAvailable == 0 then return end
	local hTarget = tAvailable[math.random(#tAvailable)]
	if CheckTalent(hCaster, 'special_bonus_unique_old_gorgon_2') > 0 then
		hTarget:AddNewModifier(hCaster, hAbility, 'modifier_stunned', {Duration = (1-hTarget:GetStatusResistance())*CheckTalent(hCaster, 'special_bonus_unique_old_gorgon_2')})
	end
	local damageTable = {
		victim = hTarget,
		damage = fDamage,
		attacker = hCaster,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = hAbility
	}
	ApplyDamage(damageTable)
	hTarget:EmitSound("Hero_Zuus.ArcLightning.Target")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_POINT_FOLLOW, hTarget)
	ParticleManager:SetParticleControlEnt(particle, 0, hSource, PATTACH_POINT_FOLLOW, "attach_hitloc", hSource:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
	tTargets[#tTargets+1] = hTarget
	iBounce = iBounce-1
	Timers:CreateTimer(fDelay, function () ChainLightningBounce(hCaster, hTarget, iRadius, fDamage*fFactor, iBounce, tTargets, hAbility, fDelay, fFactor) end)
end

function GoldDragonBreathLightning(keys)

end