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

function modifier_persuasive_lagmonster_lua:IsPurgable() return false end
function modifier_persuasive_lagmonster_lua:IsPurgeException() return false end

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
	hModifier = hParent:AddNewModifier(hCaster, hAbility, "modifier_stunned", {Duration = self:GetDuration()})
end

function modifier_persuasive_lagmonster_lua:OnTakeDamage(keys)
	self.fTotalDamage = self.fTotalDamage or 0
	if self:GetParent() ~= keys.unit then return end
	if self:GetCaster():FindAbilityByName("special_bonus_persuasive_1") then
		self.fTotalDamage = self.fTotalDamage + keys.damage*(self:GetCaster():FindAbilityByName("special_bonus_persuasive_1"):GetSpecialValueFor("value")/100+1)
	else
		self.fTotalDamage = self.fTotalDamage + keys.damage
	end
end

modifier_persuasive_high_stakes = class({})

function modifier_persuasive_high_stakes:IsHidden() return true end
function modifier_persuasive_high_stakes:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE} end

function modifier_persuasive_high_stakes:GetModifierPhysicalArmorBonus() 
	if self:GetParent():PassivesDisabled() then return 0 else return self:GetAbility():GetSpecialValueFor("armor") end
end

function modifier_persuasive_high_stakes:GetModifierPreAttack_CriticalStrike() 
	if self:GetParent():PassivesDisabled() then return 0 else return self:GetAbility():GetSpecialValueFor("crit") end
end

function modifier_persuasive_high_stakes:OnAttackLanded(keys) 
	if keys.attacker ~= self:GetParent() or self:GetAbility():GetLevel() == 0 or keys.attacker:PassivesDisabled() then return end
	keys.attacker:EmitSound("DOTA_Item.Daedelus.Crit")
end
modifier_persuasive_swindle_lua=class({})
function modifier_persuasive_swindle_lua:IsPurgable() return false end
function modifier_persuasive_swindle_lua:IsHidden() return true end
function modifier_persuasive_swindle_lua:RemoveOnDeath() return false end
function modifier_persuasive_swindle_lua:OnCreated()
	self:StartIntervalThink(0.04)
end
function modifier_persuasive_swindle_lua:OnIntervalThink()
	if IsClient() then return end
	if not self:GetParent():HasModifier('modifier_item_ultimate_scepter_consumed') and self:GetParent():HasModifier("modifier_item_ultimate_scepter") then
		self:GetParent():AddNewModifier(self:GetParent(),self:GetParent():FindModifierByName('modifier_item_ultimate_scepter'):GetAbility(), "modifier_item_ultimate_scepter_consumed", nil)
	end
end