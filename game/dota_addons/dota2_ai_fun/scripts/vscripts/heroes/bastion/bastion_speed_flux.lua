bastion_speed_flux = class({})
LinkLuaModifier("modifier_bastion_speed_flux_lua", "heroes/bastion/bastion_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bastion_speed_flux_speed_boost_lua", "heroes/bastion/bastion_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

function bastion_speed_flux:OnSpellStart()
	local level = self:GetLevel()
	local caster = self:GetCaster()
	ProcsArroundingMagicStick(caster)
	local countNeed = self:GetSpecialValueFor("count_need")
	local maxValue = self:GetSpecialValueFor("max_value")
	
	local duration = caster:GetAgility()*self:GetSpecialValueFor("duration_per_agi")	
	local buff = caster:FindModifierByName(self:GetIntrinsicModifierName())
	local attributeStack = buff:GetStackCount()
	local target = self:GetCursorTarget()
	
	self.speedFluxUseCount = self.speedFluxUseCount or 0
	self.speedFluxUseCount = self.speedFluxUseCount + 1
	if self.speedFluxUseCount == countNeed then
		self.speedFluxUseCount = 0
		if attributeStack < self:GetSpecialValueFor("max_value") or caster:FindAbilityByName("special_bonus_bastion_1"):GetLevel() > 0 then
			buff:IncrementStackCount()
		end
	end
	
	caster:EmitSound('Hero_OgreMagi.Bloodlust.Cast')
	target:EmitSound('Hero_OgreMagi.Bloodlust.Target')
	target:AddNewModifier(caster, self, "modifier_bastion_speed_flux_speed_boost_lua", {Duration = duration})
end

function bastion_speed_flux:GetIntrinsicModifierName()
	return "modifier_bastion_speed_flux_lua"
end

function bastion_speed_flux:IsHiddenWhenStolen()
	return true
end