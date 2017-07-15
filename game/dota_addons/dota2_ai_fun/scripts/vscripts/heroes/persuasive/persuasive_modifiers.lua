modifier_persuasive_kill_steal_lua = class({})
function modifier_persuasive_kill_steal_lua:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT}
end

function modifier_persuasive_kill_steal_lua:IsDebuff()
	return true
end

function modifier_persuasive_kill_steal_lua:GetEffectName()
	return "particles/econ/items/bounty_hunter/bounty_hunter_hunters_hoard/bounty_hunter_hoard_track_trail.vpcf"
end

function modifier_persuasive_kill_steal_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_persuasive_kill_steal_lua:OnCreated()
	if IsClient() then return end
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	UTIL_Remove(GameMode.hBugHero)
end
	

function modifier_persuasive_kill_steal_lua:OnTakeDamageKillCredit(keys)
	local hParent = self:GetParent()
	if hParent:GetHealth() < keys.damage then
		hParent:Kill(self:GetAbility(), self:GetCaster())
	end
end

modifier_persuasive_lagmonster_lua = class({})

function modifier_persuasive_lagmonster_lua:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_persuasive_lagmonster_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_maledict.vpcf"
end

function modifier_persuasive_lagmonster_lua:OnDestroy()
	if IsClient() or not self:DestroyOnExpire() then return end
	local fDuration = self:GetDuration()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	hParent:EmitSound("Hero_WitchDoctor.Maledict_Tick")
	local damageTable = 
	{
		damage = self.fTotalDamage or 0,
		attacker = hCaster,
		victim = hParent,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
		ability = hAbility
	}
	ApplyDamage(damageTable)
	hModifier = hParent:AddNewModifier(hCaster, hAbility, "modifier_persuasive_lagmonster_stun_lua", {Duration = self:GetDuration()})
	print(hModifier:GetName())
end

function modifier_persuasive_lagmonster_lua:OnTakeDamage(keys)
	self.fTotalDamage = self.fTotalDamage or 0
	if self:GetParent() ~= keys.unit then return end
	self.fTotalDamage = self.fTotalDamage + keys.damage
end

modifier_persuasive_lagmonster_stun_lua = class({})

function modifier_persuasive_lagmonster_stun_lua:CheckState()
	return {[MODIFIER_STATE_STUNNED] = true}
end

function modifier_persuasive_lagmonster_stun_lua:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_persuasive_lagmonster_stun_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_persuasive_lagmonster_stun_lua:IsStunDebuff()
	return true
end