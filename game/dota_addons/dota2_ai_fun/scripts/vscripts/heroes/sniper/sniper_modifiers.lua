modifier_sniper_assassinate_thinker = class({})

function modifier_sniper_assassinate_thinker:IsHidden() return true end
function modifier_sniper_assassinate_thinker:IsPurgable() return false end
function modifier_sniper_assassinate_thinker:RemoveOnDeath() return false end

function modifier_sniper_assassinate_thinker:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_sniper_assassinate_thinker:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	if hParent:HasScepter() and hParent:HasAbility("sniper_assassinate") then
		local iLevel = hParent:FindAbilityByName("sniper_assassinate"):GetLevel()
		hParent:RemoveAbility("sniper_assassinate")
		hParent:AddAbility("sniper_assassinate_upgrade"):SetLevel(iLevel)
		if hParent:HasAbility("special_bonus_unique_sniper_4") and hParent:FindAbilityByName("special_bonus_unique_sniper_4"):GetLevel() > 0 then
			hParent:FindAbilityByName("sniper_assassinate_upgrade"):SetOverrideCastPoint(0.5)
		end
	end
	
	if not hParent:HasScepter() and hParent:HasAbility("sniper_assassinate_upgrade") then
		local iLevel = hParent:FindAbilityByName("sniper_assassinate_upgrade"):GetLevel()
		hParent:RemoveAbility("sniper_assassinate_upgrade")
		hParent:AddAbility("sniper_assassinate"):SetLevel(iLevel)	
	end
	
	if hParent:HasAbility("special_bonus_unique_sniper_4") and hParent:FindAbilityByName("special_bonus_unique_sniper_4"):GetLevel() > 0 and not self.bSetCastPoint then
		if hParent:HasAbility("sniper_assassinate_upgrade") then
			hParent:FindAbilityByName("sniper_assassinate_upgrade"):SetOverrideCastPoint(0.5)
		end
		self.bSetCastPoint = true
	end
end

modifier_sniper_assassinate_target = class({})
function modifier_sniper_assassinate_target:IsPurgable() return false end
function modifier_sniper_assassinate_target:DeclareFunctions() return {MODIFIER_EVENT_ON_DEATH} end

function modifier_sniper_assassinate_target:OnDeath(keys)
	local hParent = self:GetParent()
	if keys.target ~= hParent then return end
	local hAbility = self.GetAbility()
	if hAbility.tTargets then
		for i, v in ipairs(hAbility.tTargets) do
			if v == hParent() then 
				table.remove(hAbility.tTargets, i)
			end
		end
	end
end
function modifier_sniper_assassinate_target:CheckState() return {[MODIFIER_STATE_INVISIBLE] = false, [MODIFIER_STATE_PROVIDES_VISION] = true} end

function modifier_sniper_assassinate_target:OnCreated()
	self.iParticle = ParticleManager:CreateParticleForTeam("particles/econ/items/sniper/sniper_charlie/sniper_crosshair_charlie.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetCaster():GetTeamNumber())
end

function modifier_sniper_assassinate_target:OnDestroy()
	ParticleManager:DestroyParticle(self.iParticle, true)
end
modifier_assassinate_caster_crit = class({})

function modifier_assassinate_caster_crit:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE} end

function modifier_assassinate_caster_crit:GetModifierPreAttack_CriticalStrike() return self:GetAbility():GetSpecialValueFor("scepter_crit_bonus") end