LinkLuaModifier("telekenetic_blob_catapult_modifier", "heroes/telekenetic_blob/telekenetic_blob_catapult_modifier.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("telekenetic_blob_catapult_stun_modifier", "heroes/telekenetic_blob/telekenetic_blob_catapult_modifier.lua", LUA_MODIFIER_MOTION_NONE)

telekenetic_blob_catapult = class({})

function telekenetic_blob_catapult:CastFilterResultLocation(vLocation)
	if IsClient () then 
		return UF_SUCCESS
	end

	local markedTarget = TelekeneticBlobGetMarkedTarget(self:GetCaster())
	if markedTarget == nil or (vLocation - markedTarget:GetOrigin()):Length2D() > self:GetSpecialValueFor("distance") then
		return UF_FAIL_CUSTOM
	end
end

function telekenetic_blob_catapult:GetCustomCastErrorLocation(vLocation)
	local markedTarget = TelekeneticBlobGetMarkedTarget(self:GetCaster())
	if markedTarget == nil then
		return "error_no_market_target"
	end

	return "error_marked_target_too_faraway"
end

function telekenetic_blob_catapult:OnSpellStart()
	local caster = self:GetCaster()
	local markedTarget = TelekeneticBlobGetMarkedTarget(caster)
	markedTarget:AddNewModifier(caster, self, "telekenetic_blob_catapult_modifier", {})
end