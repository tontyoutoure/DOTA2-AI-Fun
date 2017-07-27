LinkLuaModifier("telekenetic_blob_expel_modifier", "heroes/telekenetic_blob/telekenetic_blob_expel_modifier.lua", LUA_MODIFIER_MOTION_BOTH )

telekenetic_blob_expel = class({})

function telekenetic_blob_expel:CastFilterResultLocation(vLocation)
	if IsClient () then 
		return UF_SUCCESS
	end
		
	local caster = self:GetCaster()
	local markedTarget = TelekeneticBlobGetMarkedTarget(caster)
	if markedTarget == nil or CalcDistanceBetweenEntityOBB(markedTarget, caster) > self:GetSpecialValueFor("marked_target_max_distance") then
		return UF_FAIL_CUSTOM
	end
end

function telekenetic_blob_expel:GetCustomCastErrorLocation(vLocation)
	local caster = self:GetCaster()
	local markedTarget = TelekeneticBlobGetMarkedTarget(caster)
	if markedTarget == nil then
		return "error_no_market_target"
	end

	return "error_marked_target_too_faraway"
end

function telekenetic_blob_expel:OnSpellStart()
	local caster = self:GetCaster()
	local markedTarget = TelekeneticBlobGetMarkedTarget(caster)
	markedTarget:AddNewModifier(caster, self, "telekenetic_blob_expel_modifier", {})
end