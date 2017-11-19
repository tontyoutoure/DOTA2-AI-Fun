modifier_angelic_alliance_maximum_speed = class({})

function modifier_angelic_alliance_maximum_speed:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_angelic_alliance_maximum_speed:GetModifierMoveSpeed_Max()
	return 99999
end

function modifier_angelic_alliance_maximum_speed:GetModifierMoveSpeed_Limit()
	return 99999
end

function modifier_angelic_alliance_maximum_speed:IsHidden() return true end
function modifier_angelic_alliance_maximum_speed:IsPurgable() return false end

function modifier_angelic_alliance_maximum_speed:GetModifierMoveSpeedBonus_Constant()
	if self:GetAbility() then  
		return self:GetAbility():GetSpecialValueFor("speed")
	else
		return 0
	end
end

modifier_item_fun_sprint_shoes_lua = class({})

function modifier_item_fun_sprint_shoes_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE
	}

	return funcs
end

function modifier_item_fun_sprint_shoes_lua:GetModifierMoveSpeed_Max()
	return 99999
end

function modifier_item_fun_sprint_shoes_lua:GetModifierMoveSpeed_Limit()
	return 99999
end

function modifier_item_fun_sprint_shoes_lua:GetModifierMoveSpeedBonus_Special_Boots()
	if self:GetAbility() then  
		return self:GetAbility():GetSpecialValueFor("speed")
	else
		return 0
	end
end

function modifier_item_fun_sprint_shoes_lua:IsHidden()
	return true
end

modifier_item_fun_escutcheon_lua = class({})

function modifier_item_fun_escutcheon_lua:IsHidden()
	return true
end

function modifier_item_fun_escutcheon_lua:IsPurgable() return false end

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
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
--		MODIFIER_PROPERTY_STATUS_RESISTANCE
	}
end

function modifier_item_fun_escutcheon_lua:AllowIllusionDuplicate() return false end

function modifier_item_fun_escutcheon_lua:OnTakeDamage(keys)
	local caster = self:GetCaster()
	if self:GetParent() ~= keys.unit then return end
	local reverseChance = self:GetAbility():GetSpecialValueFor("damage_reverse")
	if math.random() < reverseChance/100 then
		caster:SetHealth(caster:GetHealth() + 2*keys.damage)
		Timers(0.04, function ()	
			caster.fScytheTime = nil
			caster.fReincarnateTime = nil 
		end)
	end
end

function modifier_item_fun_escutcheon_lua:GetModifierStatusResistance()
	return self:GetAbility():GetSpecialValueFor("status_resistance")
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
	if self:GetParent():GetHealth() > 0 then return -1 end
	local hAbility = self:GetAbility()
	local fReincarnateTime = hAbility:GetSpecialValueFor("reincarnate_time")
	if hAbility:IsCooldownReady() then
		hAbility:UseResources(false, false, true)
		self:GetParent().fReincarnateTime = fReincarnateTime
		return fReincarnateTime
	else
		return -1
	end
end

modifier_ragnarok_cleave = class({})

function modifier_ragnarok_cleave:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end
function modifier_ragnarok_cleave:IsHidden() return true end
function modifier_ragnarok_cleave:IsPurgable() return false end
function modifier_ragnarok_cleave:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_ragnarok_cleave:OnAttackLanded(keys)
	if keys.attacker ~= self:GetParent() then return end
	local hAbility = self:GetAbility()
	DoCleaveAttack(keys.attacker, keys.target, hAbility, hAbility:GetSpecialValueFor("cleave_damage")*keys.original_damage/100, hAbility:GetSpecialValueFor("cleave_start_radius"), hAbility:GetSpecialValueFor("cleave_end_radius"),hAbility:GetSpecialValueFor("cleave_distance"), "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf")	
	self:Destroy()
end

modifier_magic_hammer_mana_break = class({})

function modifier_magic_hammer_mana_break:IsHidden() return true end

function modifier_magic_hammer_mana_break:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS
	}
end

function modifier_magic_hammer_mana_break:GetModifierCastRangeBonus() return self:GetAbility():GetSpecialValueFor("bonus_cast_range") end

function modifier_magic_hammer_mana_break:GetModifierProcAttack_BonusDamage_Physical(keys)
	if keys.target:IsBuilding() or keys.attacker:GetTeamNumber() == keys.target:GetTeamNumber() or keys.target:GetMaxMana() == 0 or keys.target:IsMagicImmune() then return 0 end
	hAbility = self:GetAbility()
	local iManaBreak = hAbility:GetSpecialValueFor("mana_break")
	local fCurrentMana = keys.target:GetMana()
	if fCurrentMana > iManaBreak then
		return iManaBreak*hAbility:GetSpecialValueFor("mana_break_damage")
	else
		return fCurrentMana*hAbility:GetSpecialValueFor("mana_break_damage")
	end
end

function modifier_magic_hammer_mana_break:OnAttackLanded(keys)
	if self:GetParent() ~= keys.attacker or keys.target:IsBuilding() or keys.attacker:GetTeamNumber() == keys.target:GetTeamNumber() or keys.target:GetMaxMana() == 0 or keys.target:IsMagicImmune() then return end
	hAbility = self:GetAbility()
	local iManaBreak = hAbility:GetSpecialValueFor("mana_break")
	local fCurrentMana = keys.target:GetMana()
	if fCurrentMana > iManaBreak then
		keys.target:SetMana(fCurrentMana-iManaBreak)
	else 
		keys.target:SetMana(0)
	end
	local particle = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/am_manaburn_basher_ti_5_gold.vpcf", PATTACH_POINT, keys.target)
	keys.target:EmitSound("Hero_Antimage.ManaBreak")	
end

function modifier_magic_hammer_mana_break:AllowIllusionDuplicate() return true end

modifier_heros_bow_always_allow_attack = class({})


function modifier_heros_bow_always_allow_attack:OnCreated()
	if IsClient() then return end
	if self:GetParent():IsRangedAttacker() then 
		self.iAttackRange = 99999
	else
		self.iAttackRange = 0
	end
end
function modifier_heros_bow_always_allow_attack:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_START, MODIFIER_PROPERTY_ATTACK_RANGE_BONUS}
end

function modifier_heros_bow_always_allow_attack:OnAttackStart (keys)
	if keys.attacker~= self:GetParent() or not keys.attacker:IsRangedAttacker() then return end
	if not keys.target:HasModifier("modifier_item_fun_heros_bow_debuff") then
		self.iAttackRange = -keys.attacker:GetAttackRangeBuffer()
		Timers:CreateTimer(0.03, function() self.iAttackRange = 99999 end)
	end
end

function modifier_heros_bow_always_allow_attack:GetModifierAttackRangeBonus()
	return self.iAttackRange
end

function modifier_heros_bow_always_allow_attack:IsPurgable() return false end

modifier_angelic_alliance_spell_lifesteal = class({})

function modifier_angelic_alliance_spell_lifesteal:IsHidden() return true end
function modifier_angelic_alliance_spell_lifesteal:IsPurgable() return false end

function modifier_angelic_alliance_spell_lifesteal:DeclareFunctions()
    return  {
		MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_angelic_alliance_spell_lifesteal:OnTakeDamage(keys)
	if keys.attacker~=self:GetParent() or keys.attacker:IsIllusion() or not keys.inflictor or bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL)>0 then return end
	ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
	keys.attacker:Heal(self:GetAbility():GetSpecialValueFor("spell_lifesteal")/100*keys.damage, keys.attacker)
end


modifier_economizer_spell_lifesteal = class({})

function modifier_economizer_spell_lifesteal:IsHidden() return true end
function modifier_economizer_spell_lifesteal:IsPurgable() return false end

function modifier_economizer_spell_lifesteal:DeclareFunctions()
    return  {
		MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_economizer_spell_lifesteal:OnTakeDamage(keys)
	if keys.attacker~=self:GetParent() or keys.attacker:IsIllusion() or not keys.inflictor or bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL)>0 then return end
	ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
	keys.attacker:Heal(self:GetAbility():GetSpecialValueFor("spell_lifesteal")/100*keys.damage, keys.attacker)
end

modifier_heros_bow_minus_armor = class({})
function modifier_heros_bow_minus_armor:OnCreated()
	self.iArmorPercentage = self:GetAbility():GetSpecialValueFor("armor_percentage")
end
function modifier_heros_bow_minus_armor:DeclareFunctions()
	return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end

function modifier_heros_bow_minus_armor:GetModifierPhysicalArmorBonus()
	return self:GetParent():GetPhysicalArmorBaseValue()*self.iArmorPercentage/100
end

modifier_economizer_ultimate = class({})

function modifier_economizer_ultimate:DeclareFunctions() return {MODIFIER_PROPERTY_IS_SCEPTER} end
function modifier_economizer_ultimate:GetModifierScepter() return 1 end
function modifier_economizer_ultimate:IsHidden() return true end
function modifier_economizer_ultimate:IsPurgable() return false end
function modifier_economizer_ultimate:RemoveOnDeath() return false end
