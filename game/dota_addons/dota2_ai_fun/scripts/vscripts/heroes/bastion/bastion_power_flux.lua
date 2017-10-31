bastion_power_flux = class({})
LinkLuaModifier("modifier_bastion_power_flux_lua", "heroes/bastion/bastion_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

function bastion_power_flux:OnSpellStart(keys)
	local level = self:GetLevel()
	local caster = self:GetCaster()	
	local countNeed = self:GetSpecialValueFor("count_need")
	local maxValue = self:GetSpecialValueFor("max_value")
	local buff = caster:FindModifierByName(self:GetIntrinsicModifierName())
	local attributeStack = buff:GetStackCount()
	
	local target = self:GetCursorTarget()	
	self.powerFluxUseCount = self.powerFluxUseCount or 0
	self.powerFluxUseCount = self.powerFluxUseCount+1
	if self.powerFluxUseCount == countNeed then
		self.powerFluxUseCount = 0
		if attributeStack < self:GetSpecialValueFor("max_value") or caster:FindAbilityByName("special_bonus_bastion_1"):GetLevel() > 0 then
			buff:IncrementStackCount()
		end
	end	
	target:EmitSound("Hero_Omniknight.Purification")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 1, Vector(260, 260, 260))

	
	target:Heal(caster:GetStrength()*self:GetSpecialValueFor("heal_per_str"), caster)
end

function bastion_power_flux:GetIntrinsicModifierName()
	return "modifier_bastion_power_flux_lua"
end

function bastion_power_flux:IsHiddenWhenStolen()
	return false
end