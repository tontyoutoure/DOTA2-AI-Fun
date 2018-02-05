modifier_flame_lord_enflame = class()

function modifier_flame_lord_enflame:OnCreated()
	if IsClient() then return end
	self:StartIntervalThink(0.1)
end

function modifier_flame_lord_enflame:OnIntervalThink()
	if IsClient() then return end
	local hCaster = self:GetCaster()
	local iRadius
	local hAbility = self:GetAbility()
	if hCaster:HasScepter() then
		iRadius = hAbility:GetSpecialValueFor("radius")
	else
		iRadius = hAbility:GetSpecialValueFor("radius_scepter")
	end
	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), self:GetParent():GetOrigin(), nil, iRadius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for k, v in ipairs(tTargets) do
	
end