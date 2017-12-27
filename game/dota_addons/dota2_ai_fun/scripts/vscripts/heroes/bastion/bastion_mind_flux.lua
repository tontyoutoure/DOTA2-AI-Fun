bastion_mind_flux = class({})

LinkLuaModifier("modifier_bastion_mind_flux_lua", "heroes/bastion/bastion_modifiers.lua", LUA_MODIFIER_MOTION_NONE)




function bastion_mind_flux:OnSpellStart()
	local level = self:GetLevel()
	local caster = self:GetCaster()
	ProcsArroundingMagicStick(caster)
	local countNeed = self:GetSpecialValueFor("count_need")
	local maxValue = self:GetSpecialValueFor("max_value")
	
	local mana = caster:GetIntellect()*self:GetSpecialValueFor("mana_per_int")	
	local buff = caster:FindModifierByName(self:GetIntrinsicModifierName())
	local attributeStack = buff:GetStackCount()
	local target = self:GetCursorTarget()
	self.mindFluxUseCount = self.mindFluxUseCount or 0
	self.mindFluxUseCount = self.mindFluxUseCount + 1
	if self.mindFluxUseCount == countNeed then
		self.mindFluxUseCount = 0
		if caster:FindAbilityByName("special_bonus_bastion_1"):GetLevel() > 0 or attributeStack < self:GetSpecialValueFor("max_value") then
			buff:IncrementStackCount()
		end
	end
	
	local currentMana = target:GetMana()
	local maxMana = target:GetMaxMana()
	if mana + currentMana < maxMana then
		target:SetMana(mana + currentMana)
	else
		target:SetMana(maxMana)
	end
	target:EmitSound("Hero_KeeperOfTheLight.ChakraMagic.Target")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_chakra_magic.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT, "follow_origin", target:GetAbsOrigin(), true)
end

function bastion_mind_flux:GetIntrinsicModifierName()
	return "modifier_bastion_mind_flux_lua"
end

function bastion_mind_flux:IsHiddenWhenStolen()
	return false
end