LinkLuaModifier("modifier_fluid_engineer_bowel_hydraulics", "heroes/fluid_engineer/fluid_engineer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

fluid_engineer_bowel_hydraulics_lua = class({})


function fluid_engineer_bowel_hydraulics_lua:CastFilterResultTarget(hTarget)
	if IsClient () then 
		return UF_SUCCESS
	end
	if self:GetCaster() == hTarget then 
		return UF_FAIL_CUSTOM 
	end
end

function fluid_engineer_bowel_hydraulics_lua:GetCustomCastErrorTarget(hTarget)
	return "error_cannot_self_cast"
end



function fluid_engineer_bowel_hydraulics_lua:OnSpellStart()
	if self:GetCursorTarget():TriggerSpellAbsorb( self ) then return end
	local hTarget = self:GetCursorTarget()
	local hCaster = self:GetCaster()
	local hModifier = hTarget:AddNewModifier(hCaster, self, "modifier_fluid_engineer_bowel_hydraulics", {Duration = 0.04+self:GetSpecialValueFor("count_down")})
	hModifier.fDoT = self:GetSpecialValueFor("damage_over_time")
	hModifier.fDamage = self:GetSpecialValueFor("damage")
	hModifier:SetStackCount(self:GetSpecialValueFor("count_down"))
end