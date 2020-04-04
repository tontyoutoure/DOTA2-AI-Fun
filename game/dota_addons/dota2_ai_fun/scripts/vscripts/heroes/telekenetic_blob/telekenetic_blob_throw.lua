LinkLuaModifier("telekenetic_blob_throw_modifier", "heroes/telekenetic_blob/telekenetic_blob_throw_modifier.lua", LUA_MODIFIER_MOTION_BOTH )

telekenetic_blob_throw = class({})

function telekenetic_blob_throw:CastFilterResultTarget(hTarget)

	if IsClient () then 
		return UF_SUCCESS
	end
	local hCaster = self:GetCaster()
	local hMarkedAbility = hCaster:FindAbilityByName('telekenetic_blob_mark_target')
	if not hMarkedAbility or not hMarkedAbility.tMarkedTargets or #hMarkedAbility.tMarkedTargets == 0 then return UF_FAIL_CUSTOM end
	for _, markedTarget in pairs(hMarkedAbility.tMarkedTargets) do
		if (not markedTarget:IsMagicImmune() or markedTarget:GetTeam() == self:GetCaster():GetTeam()) and not markedTarget:IsAncient() and not markedTarget:IsHero() and markedTarget ~= hTarget and CalcDistanceBetweenEntityOBB(hTarget, markedTarget) <= self:GetSpecialValueFor("distance") and	not (markedTarget:HasModifier("telekenetic_blob_throw_modifier") or markedTarget:HasModifier("telekenetic_blob_sling_modifier") or markedTarget:HasModifier("telekenetic_blob_expel_modifier") or markedTarget:HasModifier("telekenetic_blob_catapult_modifier")) then return UF_SUCCESS end
	end
	return UF_FAIL_CUSTOM
end

function telekenetic_blob_throw:GetCustomCastErrorTarget(hTarget)
	return "error_no_market_target"
end

function telekenetic_blob_throw:OnSpellStart()
    if self:GetCursorTarget():TriggerSpellAbsorb(self) then
		return
	end
	local caster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	 
	local hCaster = self:GetCaster()
	local hMarkedAbility = hCaster:FindAbilityByName('telekenetic_blob_mark_target')
	for _, markedTarget in pairs(hMarkedAbility.tMarkedTargets) do
		if CalcDistanceBetweenEntityOBB(hTarget, markedTarget) <= self:GetSpecialValueFor("distance") and (not markedTarget:IsMagicImmune() or markedTarget:GetTeam() == self:GetCaster():GetTeam()) and not markedTarget:IsAncient() and not markedTarget:IsHero() and markedTarget ~= hTarget  and	not (markedTarget:HasModifier("telekenetic_blob_throw_modifier") or markedTarget:HasModifier("telekenetic_blob_sling_modifier") or markedTarget:HasModifier("telekenetic_blob_expel_modifier") or markedTarget:HasModifier("telekenetic_blob_catapult_modifier")) then 
			markedTarget:AddNewModifier(hCaster, self, "telekenetic_blob_throw_modifier", {Duration = self:GetSpecialValueFor("fly_duration")}) 
		end		
	end
end


function telekenetic_blob_throw:OnHorizontalMotionInterrupted()
	self:Destroy()
end