modifier_global_hero_respawn_time = class({})

function modifier_global_hero_respawn_time:GetDuration() return -1 end

function modifier_global_hero_respawn_time:IsHidden() return false end

function modifier_global_hero_respawn_time:RemoveOnDeath() return false end

function modifier_global_hero_respawn_time:DeclareFunctions()
	return {MODIFIER_PROPERTY_RESPAWNTIME_PERCENTAGE}
end

function modifier_global_hero_respawn_time:GetModifierPercentageRespawnTime() 
	print("now", GameMode.iRespawnTimePercentage )
	return GameMode.iRespawnTimePercentage 
end