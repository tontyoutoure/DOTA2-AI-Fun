LinkLuaModifier("telekenetic_blob_throw_modifier", "heroes/telekenetic_blob/telekenetic_blob_throw_modifier.lua", LUA_MODIFIER_MOTION_BOTH )

telekenetic_blob_throw = class({})

function telekenetic_blob_throw:CastFilterResultTarget(hTarget)
	if IsClient () then 
		return UF_SUCCESS
	end
	
	local caster = self:GetCaster()
	local markedTarget = TelekeneticBlobGetMarkedTarget(caster)
	if markedTarget:IsMagicImmune() and markedTarget:GetTeam() ~= self:GetCaster():GetTeam() then return UF_FAIL_MAGIC_IMMUNE_ENEMY end
	if markedTarget == nil or markedTarget:IsAncient() or markedTarget:IsHero() or markedTarget == hTarget or CalcDistanceBetweenEntityOBB(hTarget, markedTarget) > self:GetSpecialValueFor("distance") then
		return UF_FAIL_CUSTOM 
	end
	
	if markedTarget:HasModifier("telekenetic_blob_throw_modifier") or markedTarget:HasModifier("telekenetic_blob_sling_modifier") or markedTarget:HasModifier("telekenetic_blob_expel_modifier") or markedTarget:HasModifier("telekenetic_blob_catapult_modifier") then
		return UF_FAIL_CUSTOM
	end
end

function telekenetic_blob_throw:GetCustomCastErrorTarget(hTarget)
	local caster = self:GetCaster()
	local markedTarget = TelekeneticBlobGetMarkedTarget(caster)
	if markedTarget == nil then
		return "error_no_market_target"
	end

	if markedTarget:IsAncient() or markedTarget:IsHero() then
		return "error_marked_target_is_hero_or_ancient"
	end

	if markedTarget == hTarget then
		return "error_marked_target_cannot_be_target"
	end
	if markedTarget:HasModifier("telekenetic_blob_throw_modifier") or markedTarget:HasModifier("telekenetic_blob_sling_modifier") or markedTarget:HasModifier("telekenetic_blob_expel_modifier") or markedTarget:HasModifier("telekenetic_blob_catapult_modifier") then
		return "error_marked_target_moving"
	end
	return "error_marked_target_too_faraway"
end

function telekenetic_blob_throw:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local markedTarget = TelekeneticBlobGetMarkedTarget(caster)
		
    if target:TriggerSpellAbsorb(self) then
		return
	end

	self.throw_target = target	

	markedTarget:AddNewModifier(caster, self, "telekenetic_blob_throw_modifier", {Duration = self:GetSpecialValueFor("fly_duration")})
end


function telekenetic_blob_throw:OnHorizontalMotionInterrupted()
	self:Destroy()
end