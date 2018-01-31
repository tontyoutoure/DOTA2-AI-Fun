
LinkLuaModifier("modifier_rider_backstab", "heroes/rider/rider_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rider_bloodrage", "heroes/rider/rider_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rider_drag", "heroes/rider/rider_modifiers.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_rider_run_down", "heroes/rider/rider_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rider_run_down_target", "heroes/rider/rider_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
rider_backstab = class({})
function rider_backstab:OnUpgrade()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_rider_backstab", {})
end

rider_bloodrage=class({})
function rider_bloodrage:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	local hCaster = self:GetCaster()
	if hTarget:GetTeam() == hCaster:GetTeam() then
		hTarget:AddNewModifier(hCaster, self, "modifier_rider_bloodrage", {Duration = self:GetSpecialValueFor("duration")})
		hTarget:EmitSound("hero_bloodseeker.bloodRage")
	else
		if hTarget:TriggerSpellAbsorb(self) then return end
		hTarget:AddNewModifier(hCaster, self, "modifier_rider_bloodrage", {Duration = self:GetSpecialValueFor("duration")*CalculateStatusResist(hTarget)})
		hTarget:EmitSound("hero_bloodseeker.bloodRage")
	end
end

rider_drag = class({})

function rider_drag:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget:TriggerSpellAbsorb(self) then return end
	local hCaster = self:GetCaster()
	hCaster:EmitSound("Hero_ShadowShaman.Shackles.Cast")
	local iDuration = self:GetSpecialValueFor("duration")
	if hCaster:HasAbility("special_bonus_unique_rider_1") then
		iDuration = iDuration+hCaster:FindAbilityByName("special_bonus_unique_rider_1"):GetSpecialValueFor("value")
	end
	hTarget:AddNewModifier(hCaster, self, "modifier_rider_drag", {Duration = iDuration*CalculateStatusResist(hTarget)})
end

rider_run_down = class({})
function rider_run_down:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget:TriggerSpellAbsorb(self) then return end
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_rider_run_down", {iTargetEntIndex = hTarget:entindex(), iAcceleration = selrider_run_down})
	hTarget:AddNewModifier(hCaster, self, "modifier_rider_run_down_target", {})
end















