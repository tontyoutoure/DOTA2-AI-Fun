modifier_global_hero_respawn_time = class({})

function modifier_global_hero_respawn_time:IsPurgable() return false end
function modifier_global_hero_respawn_time:IsHidden() return true end
function modifier_global_hero_respawn_time:RemoveOnDeath() return false end

function modifier_global_hero_respawn_time:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_global_hero_respawn_time:OnTakeDamage(keys)
	if keys.unit:GetHealth() == 0 and keys.unit == self:GetParent() then
		local hScytheModifier = keys.unit:FindModifierByName('modifier_necrolyte_reapers_scythe')
		if hScytheModifier then
			keys.unit.fScytheTime = hScytheModifier:GetAbility():GetLevel()*GameMode.iRespawnTimePercentage/10
		end
		if keys.unit:HasAbility('skeleton_king_reincarnation') and keys.unit:FindAbilityByName('skeleton_king_reincarnation'):IsFullyCastable() then
			keys.unit.fReincarnateTime = 3
			Timers:CreateTimer(3, function () keys.unit.fReincarnateTime = nil end)
		elseif keys.unit:HasItemInInventory('item_aegis') then
			keys.unit.fReincarnateTime = 5
			Timers:CreateTimer(5, function () keys.unit.fReincarnateTime = nil end)
		end
	end
end