LinkLuaModifier("telekenetic_blob_catapult_modifier", "heroes/telekenetic_blob/telekenetic_blob_catapult_modifier.lua", LUA_MODIFIER_MOTION_BOTH)

telekenetic_blob_catapult = class({})

function telekenetic_blob_catapult:CastFilterResultLocation(vLocation)
	if IsClient () then 
		return UF_SUCCESS
	end
	local hCaster = self:GetCaster()
	local hMarkedAbility = hCaster:FindAbilityByName('telekenetic_blob_mark_target')
	if not hMarkedAbility or not hMarkedAbility.tMarkedTargets or #hMarkedAbility.tMarkedTargets == 0 then return UF_FAIL_CUSTOM end
	for _, markedTarget in pairs(hMarkedAbility.tMarkedTargets) do
		if (not markedTarget:IsMagicImmune() or markedTarget:GetTeam() == self:GetCaster():GetTeam()) and (vLocation - markedTarget:GetOrigin()):Length2D() <= self:GetSpecialValueFor("distance") and not (markedTarget:HasModifier("telekenetic_blob_throw_modifier") or markedTarget:HasModifier("telekenetic_blob_sling_modifier") or markedTarget:HasModifier("telekenetic_blob_expel_modifier") or markedTarget:HasModifier("telekenetic_blob_catapult_modifier")) then return UF_SUCCESS end
	end
	return UF_FAIL_CUSTOM
end

function telekenetic_blob_catapult:GetCustomCastErrorLocation(vLocation)
	return "error_no_market_target"
end

function telekenetic_blob_catapult:OnSpellStart()	
	local hCaster = self:GetCaster()
	local hMarkedAbility = hCaster:FindAbilityByName('telekenetic_blob_mark_target')
	local vLocation = self:GetCursorPosition()
	for _, markedTarget in pairs(hMarkedAbility.tMarkedTargets) do
		if (not markedTarget:IsMagicImmune() or markedTarget:GetTeam() == self:GetCaster():GetTeam()) and (vLocation - markedTarget:GetOrigin()):Length2D() <= self:GetSpecialValueFor("distance") and not (markedTarget:HasModifier("telekenetic_blob_throw_modifier") or markedTarget:HasModifier("telekenetic_blob_sling_modifier") or markedTarget:HasModifier("telekenetic_blob_expel_modifier") or markedTarget:HasModifier("telekenetic_blob_catapult_modifier")) then 
			markedTarget:AddNewModifier(hCaster, self, "telekenetic_blob_catapult_modifier", {Duration = self:GetSpecialValueFor("fly_duration")})
		end
	end
end