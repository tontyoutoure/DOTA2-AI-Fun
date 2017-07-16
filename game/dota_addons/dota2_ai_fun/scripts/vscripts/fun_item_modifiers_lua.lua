modifier_item_fun_sprint_shoes_lua = class({})
-- Adopted from SpellLibrary. Great thanks for the authors: Perry and Noya!

function modifier_item_fun_sprint_shoes_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}

	return funcs
end

function modifier_item_fun_sprint_shoes_lua:GetModifierMoveSpeed_Max()
	return self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_item_fun_sprint_shoes_lua:GetModifierMoveSpeed_Limit()
	return self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_item_fun_sprint_shoes_lua:GetModifierMoveSpeed_Absolute()
	return self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_item_fun_sprint_shoes_lua:IsHidden()
	return true
end

modifier_item_fun_escutcheon_lua = class({})

function modifier_item_fun_escutcheon_lua:IsHidden()
	return true
end

function modifier_item_fun_escutcheon_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_fun_escutcheon_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS, 
		MODIFIER_PROPERTY_MANA_BONUS, 
		MODIFIER_EVENT_ON_TAKEDAMAGE, 
		MODIFIER_PROPERTY_REINCARNATION,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE}
end

function modifier_item_fun_escutcheon_lua:OnTakeDamage(keys)
	local caster = self:GetCaster()
	if self:GetParent() ~= keys.unit then return end
	local reverseChance = self:GetAbility():GetSpecialValueFor("damage_reverse")
	if math.random() < reverseChance/100 then
		caster:SetHealth(caster:GetHealth() + 2*keys.damage)
	end
end

function modifier_item_fun_escutcheon_lua:OnCreated()
	self:GetParent().iEcutcheonCount = self:GetParent().iEcutcheonCount or 0
	self:GetParent().iEcutcheonCount = self:GetParent().iEcutcheonCount+1
end

function modifier_item_fun_escutcheon_lua:OnDestroy()
	self:GetParent().iEcutcheonCount = self:GetParent().iEcutcheonCount-1
end

function modifier_item_fun_escutcheon_lua:GetModifierHealthRegenPercentage()
	return self:GetAbility():GetSpecialValueFor("health_regen_percentage")/self:GetParent().iEcutcheonCount
end

function modifier_item_fun_escutcheon_lua:GetModifierTotalPercentageManaRegen()
	return self:GetAbility():GetSpecialValueFor("mana_regen_percentage")/self:GetParent().iEcutcheonCount
end


function modifier_item_fun_escutcheon_lua:GetModifierManaBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_mana")
end

function modifier_item_fun_escutcheon_lua:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_item_fun_escutcheon_lua:ReincarnateTime()
	if IsClient() then return -1 end
	local ability = self:GetAbility()
	if ability:IsCooldownReady() then
--		Timers:CreateTimer(3.06, function () ability:UseResources(false, false, true)end)
		ability:UseResources(false, false, true)
		return 3
	else
		return -1
	end
end


modifier_item_fun_escutcheon_regen_lua = class({})


modifier_item_fun_ragnarok_lua = class({})

function modifier_item_fun_ragnarok_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_item_fun_ragnarok_lua:OnAttackLanded(keys)
	if keys.attacker ~= self:GetParent() then return end
	if keys.attacker:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK then return end
	local hAbility = self:GetAbility()
	DoCleaveAttack(keys.attacker, keys.target, hAbility, hAbility:GetSpecialValueFor("cleave_damage")*keys.original_damage/100, hAbility:GetSpecialValueFor("cleave_start_radius"), hAbility:GetSpecialValueFor("cleave_end_radius"),hAbility:GetSpecialValueFor("cleave_distance"), "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf")	
end

function modifier_item_fun_ragnarok_lua:OnCreated()
	self:GetParent().iRagnarokCount = self:GetParent().iRagnarokCount or 0
	self:GetParent().iRagnarokCount = self:GetParent().iRagnarokCount+1
end

function modifier_item_fun_ragnarok_lua:OnDestroy()
	self:GetParent().iRagnarokCount = self:GetParent().iRagnarokCount-1
end

function modifier_item_fun_ragnarok_lua:GetModifierBaseDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")/self:GetParent().iRagnarokCount
end

function modifier_item_fun_ragnarok_lua:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_strength")
end


function modifier_item_fun_ragnarok_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_fun_ragnarok_lua:IsHidden()
	return true
end
















