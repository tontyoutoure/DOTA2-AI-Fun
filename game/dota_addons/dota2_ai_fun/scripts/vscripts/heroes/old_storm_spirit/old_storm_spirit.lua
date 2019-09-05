LinkLuaModifier('modifier_old_storm_spirit_electric_rave','heroes/old_storm_spirit/old_storm_spirit_modifiers',LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_storm_spirit_barrier','heroes/old_storm_spirit/old_storm_spirit_modifiers',LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_storm_spirit_barrier_passive','heroes/old_storm_spirit/old_storm_spirit_modifiers',LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_storm_spirit_overload','heroes/old_storm_spirit/old_storm_spirit_modifiers',LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_storm_spirit_overload_slow','heroes/old_storm_spirit/old_storm_spirit_modifiers',LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_old_storm_spirit_lightning_grapple','heroes/old_storm_spirit/old_storm_spirit_modifiers',LUA_MODIFIER_MOTION_HORIZONTAL)

old_storm_spirit_electric_rave = class({})
function old_storm_spirit_electric_rave:OnToggle()
	local hCaster = self:GetCaster()
	if(self:GetToggleState()) then
		hCaster:AddNewModifier(hCaster, self, 'modifier_old_storm_spirit_electric_rave', nil)
		self:SetActivated(false)
		Timers:CreateTimer(self:GetCooldownTimeRemaining(), function () self:SetActivated(true) end)
	else
		hCaster:RemoveModifierByName('modifier_old_storm_spirit_electric_rave')
	end
end

function old_storm_spirit_electric_rave:ResetToggleOnRespawn()
	return true
end


old_storm_spirit_barrier = class({})
function old_storm_spirit_barrier:GetIntrinsicModifierName() return "modifier_old_storm_spirit_barrier_passive" end
function old_storm_spirit_barrier:OnSpellStart()
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, 'modifier_old_storm_spirit_barrier', {Duration = self:GetSpecialValueFor('duration')})
end
old_storm_spirit_overload = class({})
function old_storm_spirit_overload:GetIntrinsicModifierName() return "modifier_old_storm_spirit_overload" end
function old_storm_spirit_overload:OnUpgrade() 
	local hModifier = self:GetCaster():FindModifierByName("modifier_old_storm_spirit_overload")
	if hModifier:GetStackCount() > self:GetSpecialValueFor('attack_needed') then
		hModifier:SetStackCount(self:GetSpecialValueFor('attack_needed'))
	end
end
old_storm_spirit_lightning_grapple = class({})
function old_storm_spirit_lightning_grapple:OnSpellStart()
	local tTargets = FindUnitsInRadius()
end