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


function old_storm_spirit_lightning_grapple:GetCooldown(iLevel)
	if not self.bSpecial then
		self.hSpecial = Entities:First()		
		while self.hSpecial and (self.hSpecial:GetName() ~= "special_bonus_unique_old_storm_spirit_6" or self.hSpecial:GetCaster() ~= self:GetCaster()) do
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


function old_storm_spirit_lightning_grapple:OnSpellStart()
	local hCaster = self:GetCaster()
	local fRadius = self:GetSpecialValueFor('radius')
	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetOrigin(), nil, fRadius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local vToGo = Vector2D(self:GetCursorPosition()-hCaster:GetOrigin())
	local fMaxRange = self:GetSpecialValueFor('range')+self:GetCaster():GetCastRangeBonus()
	if vToGo:Length2D() > fMaxRange then
		vToGo = vToGo:Normalized()*fMaxRange
	end
	local fSpeed = self:GetSpecialValueFor('speed')
	hCaster:EmitSound('Hero_StormSpirit.BallLightning')
	for k, v in pairs(tTargets) do
		local hModifier = v:AddNewModifier(hCaster, self, 'modifier_old_storm_spirit_lightning_grapple', {Duration = vToGo:Length2D()/fSpeed})
		hModifier.vToGo = vToGo
		hModifier.vDestination = v:GetOrigin()+hModifier.vToGo
		hModifier.vHorizantalSpeed = fSpeed*hModifier.vToGo:Normalized()
		
	end
end


function old_storm_spirit_lightning_grapple:GetCastRange()
	if IsClient() then
		return self:GetSpecialValueFor('range')
	else
		return 99999
	end
end












