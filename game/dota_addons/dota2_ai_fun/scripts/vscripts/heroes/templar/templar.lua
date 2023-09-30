LinkLuaModifier("modifier_templar_chicken", "heroes/templar/templar_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_templar_chicken_strength_loss", "heroes/templar/templar_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_templar_drain", "heroes/templar/templar_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_templar_faith", "heroes/templar/templar_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
templar_chicken = class({})

function templar_chicken:GetBehavior()
	if not self.hSpecial then
		self.hSpecial = Entities:First()		
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_templar_3" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end
	end
	
	if self.hSpecial and self.hSpecial:GetSpecialValueFor("value") > 0 then
		return DOTA_ABILITY_BEHAVIOR_POINT+DOTA_ABILITY_BEHAVIOR_AOE
	else
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET		
	end
end

function templar_chicken:GetAOERadius()
	if not self.hSpecial then
		self.hSpecial = Entities:First()		
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_templar_3" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end
	end
	
	if self.hSpecial and self.hSpecial:GetSpecialValueFor("value") > 0 then
		return self.hSpecial:GetSpecialValueFor("value")		
	else
		return 0
	end	
end


function templar_chicken:OnSpellStart()
	local hCaster = self:GetCaster()
	if hCaster:HasAbility("special_bonus_templar_3") and hCaster:FindAbilityByName("special_bonus_templar_3"):GetSpecialValueFor("value") > 0 then
		local iRadius = hCaster:FindAbilityByName("special_bonus_templar_3"):GetSpecialValueFor("value")
		for k, v in ipairs(FindUnitsInRadius(hCaster:GetTeamNumber(), self:GetCursorPosition(), nil, iRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
			if v:IsIllusion() then 
				v:Kill(self, hCaster)
			else
				v:AddNewModifier(hCaster, self, "modifier_templar_chicken", {Duration = self:GetSpecialValueFor("duration")*CalculateStatusResist(v)})
				v:AddNewModifier(hCaster, self, "modifier_templar_chicken_strength_loss", {Duration = self:GetSpecialValueFor("strength_loss_duration")*CalculateStatusResist(v)})
				v:EmitSound("Hero_ShadowShaman.Hex.Target")
				ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_voodoo.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
			end
		end
	else
		local hTarget = self:GetCursorTarget()
		if hTarget:IsIllusion() then 
			hTarget:Kill(self, hCaster) 
			return
		end
		if hTarget:TriggerSpellAbsorb(self) then return end
			hTarget:AddNewModifier(hCaster, self, "modifier_templar_chicken", {Duration = self:GetSpecialValueFor("duration")*CalculateStatusResist(hTarget)})
			hTarget:AddNewModifier(hCaster, self, "modifier_templar_chicken_strength_loss", {Duration = self:GetSpecialValueFor("strength_loss_duration")*CalculateStatusResist(hTarget)})
			hTarget:EmitSound("Hero_ShadowShaman.Hex.Target")
			ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_voodoo.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	end
end

function TemplarDrainApplyWatcher(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_templar_drain", {})
end

function TemplarDrainSpellStart(keys)
		ProcsArroundingMagicStick(keys.caster)
		if keys.target:TriggerSpellAbsorb(keys.ability) then return end
		local iLifeDrain = keys.ability:GetSpecialValueFor("life_drain")
		local iManaDrain = keys.ability:GetSpecialValueFor("mana_drain")
		if keys.caster:HasAbility("special_bonus_templar_1") then
			iLifeDrain = iLifeDrain+keys.caster:FindAbilityByName("special_bonus_templar_1"):GetSpecialValueFor("value")
		end		
		if keys.caster:HasAbility("special_bonus_templar_2") then
			iManaDrain = iManaDrain+keys.caster:FindAbilityByName("special_bonus_templar_2"):GetSpecialValueFor("value")
		end
		keys.target:Script_ReduceMana(iManaDrain,keys.ability)
		keys.caster:GiveMana(iManaDrain)
		keys.caster:Heal(iLifeDrain, keys.caster)
		ApplyDamage({attacker = keys.caster, victim = keys.target, damage = iLifeDrain, damage_type = keys.ability:GetAbilityDamageType(), ability = keys.ability})
		keys.target:EmitSound("Hero_Bane.BrainSap.Target")
		keys.caster:EmitSound("Hero_Bane.BrainSap")	
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_bane/bane_sap.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
		ParticleManager:SetParticleControlEnt(iParticle, 0, keys.caster, PATTACH_POINT_FOLLOW, "attach_attack1", keys.caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(iParticle, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
end


templar_vengeance = class({})

function templar_vengeance:GetCooldown(iLevel)
	if not self.hSpecial then
		self.hSpecial = Entities:First()
		
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_templar_4" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
			self.hSpecial = Entities:Next(self.hSpecial)
		end		
	end
	if self.hSpecial then
		return self.BaseClass.GetCooldown(self, iLevel)-self.hSpecial:GetSpecialValueFor("value")
	else
		return self.BaseClass.GetCooldown(self, iLevel)
	end
end

function templar_vengeance:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	if hTarget:TriggerSpellAbsorb(self) then return end
	hCaster:EmitSound("Hero_Chen.TestOfFaith.Cast")
	hTarget:EmitSound("Hero_Chen.TestOfFaith.Target")
	ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	hTarget:AddNewModifier(hCaster, self, "modifier_stunned", {Duration = 0.01})
	ApplyDamage({victim = hTarget, attacker = hCaster, damage = hCaster:GetHealthDeficit()*self:GetSpecialValueFor("damage_multiplier"), damage_type = self:GetAbilityDamageType(), ability = self})
end



function TemplarFaithApply(keys)
	ProcsArroundingMagicStick(keys.caster)
	if keys.target:TriggerSpellAbsorb(keys.ability) then return end
	ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_penitence.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
	hModifier = keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_templar_faith", {Duration = keys.ability:GetSpecialValueFor("duration")})
	hModifier.bHasShard = CheckShard(keys.caster)
	keys.caster:EmitSound("Hero_Chen.Penitence")
	keys.target:EmitSound("Hero_Chen.PenitenceImpact")
end









