
modifier_astral_trekker_entrapment = class({})

function modifier_astral_trekker_entrapment:CheckState() return {[MODIFIER_STATE_ROOTED] = true, [MODIFIER_STATE_INVISIBLE] = false} end

function modifier_astral_trekker_entrapment:IsDebuff() return true end

function modifier_astral_trekker_entrapment:IsPurgable() return true end

function modifier_astral_trekker_entrapment:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_astral_trekker_entrapment:GetEffectName() return "particles/units/heroes/hero_siren/siren_net.vpcf" end

modifier_astral_trekker_war_stomp_changer = class({})
modifier_astral_trekker_war_stomp_talented_changer = class({})
function modifier_astral_trekker_war_stomp_changer:IsHidden() return true end
function modifier_astral_trekker_war_stomp_talented_changer:IsHidden() return true end
function modifier_astral_trekker_war_stomp_changer:IsPurgable() return false end
function modifier_astral_trekker_war_stomp_talented_changer:IsPurgable() return false end
function modifier_astral_trekker_war_stomp_changer:OnCreated() self:StartIntervalThink(0.1) end
function modifier_astral_trekker_war_stomp_talented_changer:OnCreated() self:StartIntervalThink(0.1) end

function modifier_astral_trekker_war_stomp_changer:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
--	print(hParent:HasAbility("special_bonus_unique_astral_trekker_2"), hParent:FindAbilityByName("special_bonus_unique_astral_trekker_2"):GetLevel())
	if hParent:HasAbility("special_bonus_unique_astral_trekker_2") and hParent:FindAbilityByName("special_bonus_unique_astral_trekker_2"):GetLevel() > 0 then
		local iLevel = hParent:FindAbilityByName("astral_trekker_war_stomp"):GetLevel()
		hParent:RemoveAbility("astral_trekker_war_stomp")
		hParent:AddAbility("astral_trekker_war_stomp_talented"):SetLevel(iLevel)
		self:Destroy()
	end
end

function modifier_astral_trekker_war_stomp_talented_changer:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	if (not hParent:HasAbility("special_bonus_unique_astral_trekker_2")) or hParent:FindAbilityByName("special_bonus_unique_astral_trekker_2"):GetLevel() == 0 then
		local iLevel = hParent:FindAbilityByName("astral_trekker_war_stomp_talented"):GetLevel()
		hParent:RemoveAbility("astral_trekker_war_stomp_talented")
		hParent:AddAbility("astral_trekker_war_stomp"):SetLevel(iLevel)
		self:Destroy()
	end
end

modifier_astral_trekker_pulverize = class({})

function modifier_astral_trekker_pulverize:IsHidden() return true end
function modifier_astral_trekker_pulverize:IsPurgable() return false end
function modifier_astral_trekker_pulverize:RemoveOnDeath() return false end
function modifier_astral_trekker_pulverize:CheckState() 
	if self:GetParent():PassivesDisabled() or not self:GetParent():HasScepter() then 
		return {}
	else
		return {[MODIFIER_STATE_CANNOT_MISS] = true}
	end
end
function modifier_astral_trekker_pulverize:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_astral_trekker_pulverize:OnAttackLanded(keys)
	if keys.attacker:IsIllusion() or keys.attacker ~= self:GetParent() or keys.attacker:PassivesDisabled() or keys.target:IsBuilding() or keys.attacker:GetTeam() == keys.target:GetTeam() then return end
	local hAbility = self:GetAbility()
	local tTargets = FindUnitsInRadius(keys.attacker:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for k, v in ipairs(tTargets) do
		ApplyDamage({damage = hAbility:GetSpecialValueFor("damage"), attacker = keys.attacker, victim = v, damage_type = hAbility:GetAbilityDamageType(), ability = hAbility})
		if keys.attacker:HasScepter() then
			v:AddNewModifier(keys.attacker, hAbility, "modifier_astral_trekker_pulverize_break", {Duration = hAbility:GetSpecialValueFor('break_duration_scepter')*(1-v:GetStatusResistance())})
		end
	end
end

modifier_astral_trekker_pulverize_break = class({})
function modifier_astral_trekker_pulverize_break:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_astral_trekker_pulverize_break:GetEffectName() return "particles/items3_fx/silver_edge_slow.vpcf" end

function modifier_astral_trekker_pulverize_break:IsPurgable() return false end
function modifier_astral_trekker_pulverize_break:CheckState() return {[MODIFIER_STATE_PASSIVES_DISABLED] = true} end