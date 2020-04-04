modifier_old_holy_knight_purge_slow = class({})
function modifier_old_holy_knight_purge_slow:IsDebuff() return true end
function modifier_old_holy_knight_purge_slow:IsPurgable() return true end
function modifier_old_holy_knight_purge_slow:OnRefresh(keys)
	if IsClient() then return end
	local iSlowFactor = self:GetAbility():GetSpecialValueFor("slow_factor")
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("slow_duration")/iSlowFactor*(1-self:GetParent():GetStatusResistance()))
	self:SetStackCount(-iSlowFactor) 
	
end
function modifier_old_holy_knight_purge_slow:OnCreated(keys)
	if IsClient() then return end
	local iSlowFactor = self:GetAbility():GetSpecialValueFor("slow_factor")
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("slow_duration")/iSlowFactor*(1-self:GetParent():GetStatusResistance()))
	self:SetStackCount(-iSlowFactor) 
end

function modifier_old_holy_knight_purge_slow:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_old_holy_knight_purge_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()/self:GetAbility():GetSpecialValueFor("slow_factor")*100
end

function modifier_old_holy_knight_purge_slow:OnIntervalThink()
	if IsClient() then return end
	self:IncrementStackCount()
end

function modifier_old_holy_knight_purge_slow:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_old_holy_knight_purge_slow:GetEffectName() return "particles/items_fx/diffusal_slow.vpcf" end



local function CheckForCritChance(hModifier)
	local iChance = hModifier:GetAbility():GetSpecialValueFor("crit_chance")
	if iChance == 0 then return false end
	if not hModifier.iChance or hModifier.iChance ~= iChance then
		hModifier.iChance = iChance
		hModifier.hRNG = PseudoRNG.create(iChance/100)		
	end
	return true
end

modifier_old_holy_knight_critical_strike = class({})

function modifier_old_holy_knight_critical_strike:IsHidden() return true end
function modifier_old_holy_knight_critical_strike:IsPurgable() return false end
function modifier_old_holy_knight_critical_strike:RemoveOnDeath() return false end

function modifier_old_holy_knight_critical_strike:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}
end 
function modifier_old_holy_knight_critical_strike:OnCreated()
	if IsClient() then return end
	CheckForCritChance(self)
	self.tCritRecords = {}
end

function modifier_old_holy_knight_critical_strike:OnAttackStart(keys)
	if self:GetParent() ~= keys.attacker then return end
	if not CheckForCritChance(self) then return end
	self.bCrit = false
	if keys.target:GetTeam()~=keys.attacker:GetTeam() and not keys.target:IsBuilding() and self.hRNG:Next() then
		self.bCrit = true
	end
end



function modifier_old_holy_knight_critical_strike:GetModifierPreAttack_CriticalStrike(keys)
	local iMultiplier = self:GetAbility():GetSpecialValueFor("crit_multiplier")
	if self:GetParent():HasAbility("special_bonus_unique_old_holy_knight_1") then
		iMultiplier = iMultiplier+self:GetParent():FindAbilityByName("special_bonus_unique_old_holy_knight_1"):GetSpecialValueFor("value")
	end
	if self.bCrit then
		self.bCrit = false
		self.tCritRecords[keys.record] = true
		return self:GetAbility():GetSpecialValueFor("crit_multiplier")
	else
		return false
	end
end

function modifier_old_holy_knight_critical_strike:OnAttackLanded(keys)
	if self:GetParent() ~= keys.attacker then return end
	if self.tCritRecords[keys.record] then
		self.tCritRecords[keys.record] = nil
		if CheckTalent(keys.attacker, "special_bonus_unique_old_holy_knight_4") > 0 then
			if not keys.target:IsConsideredHero() and not keys.target:IsMagicImmune() and (not keys.target:IsAncient() or keys.attacker:HasScepter()) and keys.target:GetName() ~= "npc_dota_roshan" then
				keys.target:Kill(self:GetAbility(), keys.attacker)
				PersueUnit(keys.attacker, keys.target, CheckTalent(keys.attacker, "special_bonus_unique_old_holy_knight_3"), true, "Hero_Chen.HolyPersuasionEnemy", "particles/units/heroes/hero_chen/chen_holy_persuasion.vpcf")
			end
		end
	end
end