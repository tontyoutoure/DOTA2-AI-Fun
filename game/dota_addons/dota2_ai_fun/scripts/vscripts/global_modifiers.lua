modifier_global_hero_respawn_time = class({})

function modifier_global_hero_respawn_time:IsPurgable() return false end
function modifier_global_hero_respawn_time:IsHidden() return true end
function modifier_global_hero_respawn_time:RemoveOnDeath() return false end

function modifier_global_hero_respawn_time:DeclareFunctions()
	return {MODIFIER_PROPERTY_RESPAWNTIME_PERCENTAGE}
end

function modifier_global_hero_respawn_time:GetModifierPercentageRespawnTime()
	return self.fRespawnTime
end