LinkLuaModifier("telekenetic_blob_sling_modifier", "heroes/telekenetic_blob/telekenetic_blob_sling_modifier.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("telekenetic_blob_sling_knockback_modifier", "heroes/telekenetic_blob/telekenetic_blob_sling_knockback_modifier.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

telekenetic_blob_sling = class({})

function telekenetic_blob_sling:CastFilterResultLocation(vLocation)
	if IsClient () then 
		return UF_SUCCESS
	end

	local markedTarget = TelekeneticBlobGetMarkedTarget(self:GetCaster())
	if markedTarget == nil then
		return UF_FAIL_CUSTOM
	end
end

function telekenetic_blob_sling:GetCustomCastErrorLocation(vLocation)
	return "error_no_market_target"
end

function telekenetic_blob_sling:OnSpellStart()
	local caster = self:GetCaster()
	local markedTarget = TelekeneticBlobGetMarkedTarget(caster)
	markedTarget:AddNewModifier(caster, self, "telekenetic_blob_sling_modifier", {})
end