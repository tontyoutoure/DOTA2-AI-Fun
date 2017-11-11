LinkLuaModifier("modifier_fluid_engineer_salad_lunch", "heroes/fluid_engineer/fluid_engineer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

fluid_engineer_salad_lunch_lua = class({})
function fluid_engineer_salad_lunch_lua:CastFilterResultTarget(hTarget)
	return true
end
function fluid_engineer_salad_lunch_lua:OnSpellStart()
	local hTree = self:GetCursorTarget()
	local hCaster = self:GetCaster()
	hTree:CutDown(hCaster:GetOwner():GetTeamNumber())
	hCaster:Heal(self:GetSpecialValueFor("restore"), hCaster)
	hCaster:ReduceMana(-self:GetSpecialValueFor("restore"))
	local hModifier = hCaster:AddNewModifier(hCaster, self, "modifier_fluid_engineer_salad_lunch", {Duration = self:GetSpecialValueFor("duration")})
	if hModifier:GetStackCount() < self:GetSpecialValueFor("int_stack_cap") then
		hModifier:SetStackCount(hModifier:GetStackCount()+1)
	end
end