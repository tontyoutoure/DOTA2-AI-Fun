LinkLuaModifier("telekenetic_blob_sling_modifier", "heroes/telekenetic_blob/telekenetic_blob_sling_modifier.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("telekenetic_blob_sling_knockback_modifier", "heroes/telekenetic_blob/telekenetic_blob_sling_knockback_modifier.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

telekenetic_blob_sling = class({})

function telekenetic_blob_sling:CastFilterResultLocation(vLocation)
	if IsClient () then 
		return UF_SUCCESS
	end
	local hCaster = self:GetCaster()
	local hMarkedAbility = hCaster:FindAbilityByName('telekenetic_blob_mark_target')
	if not hMarkedAbility or not hMarkedAbility.tMarkedTargets or #hMarkedAbility.tMarkedTargets == 0 then return UF_FAIL_CUSTOM end
	for _, markedTarget in pairs(hMarkedAbility.tMarkedTargets) do
		if (not markedTarget:IsMagicImmune() or markedTarget:GetTeam() == self:GetCaster():GetTeam()) and not (markedTarget:HasModifier("telekenetic_blob_throw_modifier") or markedTarget:HasModifier("telekenetic_blob_sling_modifier") or markedTarget:HasModifier("telekenetic_blob_expel_modifier") or markedTarget:HasModifier("telekenetic_blob_catapult_modifier")) then return UF_SUCCESS end
	end
	return UF_FAIL_CUSTOM
end

function telekenetic_blob_sling:GetCustomCastErrorLocation(vLocation)
	return "error_no_market_target"
end

function telekenetic_blob_sling:OnSpellStart()
	local hCaster = self:GetCaster()
	local hMarkedAbility = hCaster:FindAbilityByName('telekenetic_blob_mark_target')
	for _, markedTarget in pairs(hMarkedAbility.tMarkedTargets) do
	
		if (not markedTarget:IsMagicImmune() or markedTarget:GetTeam() == self:GetCaster():GetTeam()) and not (markedTarget:HasModifier("telekenetic_blob_throw_modifier") or markedTarget:HasModifier("telekenetic_blob_sling_modifier") or markedTarget:HasModifier("telekenetic_blob_expel_modifier") or markedTarget:HasModifier("telekenetic_blob_catapult_modifier")) then 
			local fDistance = (markedTarget:GetOrigin()-self:GetCursorPosition()):Length2D()
			if fDistance > self:GetSpecialValueFor("sling_distance") then fDistance = self:GetSpecialValueFor("sling_distance") end
			markedTarget:AddNewModifier(hCaster, self, "telekenetic_blob_sling_modifier", {Duration = fDistance/self:GetSpecialValueFor("sling_speed")})
		end
	end
end