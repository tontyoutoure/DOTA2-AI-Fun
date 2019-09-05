LinkLuaModifier("telekenetic_blob_expel_modifier", "heroes/telekenetic_blob/telekenetic_blob_expel_modifier.lua", LUA_MODIFIER_MOTION_BOTH )

telekenetic_blob_expel = class({})

function telekenetic_blob_expel:CastFilterResultLocation(vLocation)
	if IsClient () then 
		return UF_SUCCESS
	end
	local hCaster = self:GetCaster()
	local hMarkedAbility = hCaster:FindAbilityByName('telekenetic_blob_mark_target')
	if not hMarkedAbility or not hMarkedAbility.tMarkedTargets or #hMarkedAbility.tMarkedTargets == 0 then return UF_FAIL_CUSTOM end
	for _, markedTarget in pairs(hMarkedAbility.tMarkedTargets) do
		if CalcDistanceBetweenEntityOBB(markedTarget, hCaster) <= self:GetSpecialValueFor("marked_target_max_distance") and not (markedTarget:HasModifier("telekenetic_blob_throw_modifier") or markedTarget:HasModifier("telekenetic_blob_sling_modifier") or markedTarget:HasModifier("telekenetic_blob_expel_modifier") or markedTarget:HasModifier("telekenetic_blob_catapult_modifier")) then return UF_SUCCESS end
	end
	return UF_FAIL_CUSTOM
end

function telekenetic_blob_expel:GetCustomCastErrorLocation(vLocation)
	return "error_no_market_target"
end

function telekenetic_blob_expel:OnSpellStart()
	local hCaster = self:GetCaster()
	local hMarkedAbility = hCaster:FindAbilityByName('telekenetic_blob_mark_target')
	for _, markedTarget in pairs(hMarkedAbility.tMarkedTargets) do
		if CalcDistanceBetweenEntityOBB(markedTarget, hCaster) <= self:GetSpecialValueFor("marked_target_max_distance") and not (markedTarget:HasModifier("telekenetic_blob_throw_modifier") or markedTarget:HasModifier("telekenetic_blob_sling_modifier") or markedTarget:HasModifier("telekenetic_blob_expel_modifier") or markedTarget:HasModifier("telekenetic_blob_catapult_modifier")) then 
			local fDistance = (markedTarget:GetOrigin()-self:GetCursorPosition()):Length2D()
			markedTarget:AddNewModifier(hCaster, self, "telekenetic_blob_expel_modifier", {Duration = fDistance/self:GetSpecialValueFor("fly_speed")})
		end
	end
end