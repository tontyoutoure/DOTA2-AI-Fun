LinkLuaModifier("telekenetic_blob_sling_modifier", "heroes/telekenetic_blob/telekenetic_blob_sling_modifier.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("telekenetic_blob_sling_knockback_modifier", "heroes/telekenetic_blob/telekenetic_blob_sling_knockback_modifier.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

telekenetic_blob_sling = class({})

function telekenetic_blob_sling:CastFilterResultLocation(vLocation)
	if IsClient () then 
		return UF_SUCCESS
	end

	local markedTarget = TelekeneticBlobGetMarkedTarget(self:GetCaster())
	if markedTarget:IsMagicImmune() and markedTarget:GetTeam() ~= self:GetCaster():GetTeam() then return UF_FAIL_MAGIC_IMMUNE_ENEMY end
	if markedTarget == nil then
		return UF_FAIL_CUSTOM
	end
	if markedTarget:HasModifier("telekenetic_blob_throw_modifier") or markedTarget:HasModifier("telekenetic_blob_sling_modifier") or markedTarget:HasModifier("telekenetic_blob_expel_modifier") or markedTarget:HasModifier("telekenetic_blob_catapult_modifier") then
		return UF_FAIL_CUSTOM
	end
end

function telekenetic_blob_sling:GetCustomCastErrorLocation(vLocation)
	local markedTarget = TelekeneticBlobGetMarkedTarget(self:GetCaster())
	if markedTarget:HasModifier("telekenetic_blob_throw_modifier") or markedTarget:HasModifier("telekenetic_blob_sling_modifier") or markedTarget:HasModifier("telekenetic_blob_expel_modifier") or markedTarget:HasModifier("telekenetic_blob_catapult_modifier") then
		return "error_marked_target_moving"
	end
	return "error_no_market_target"
end

function telekenetic_blob_sling:OnSpellStart()
	local caster = self:GetCaster()
	local markedTarget = TelekeneticBlobGetMarkedTarget(caster)
	markedTarget:AddNewModifier(caster, self, "telekenetic_blob_sling_modifier", {})
end