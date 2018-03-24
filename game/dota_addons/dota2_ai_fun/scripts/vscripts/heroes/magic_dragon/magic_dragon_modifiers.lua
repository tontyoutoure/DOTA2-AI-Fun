modifier_magic_dragon_lightning_form = class({})

function modifier_magic_dragon_lightning_form:RemoveOnDeath() return false end
function modifier_magic_dragon_lightning_form:IsHidden() return true end

function modifier_magic_dragon_lightning_form:GetStatusEffectName()
	return "particles/status_fx/status_effect_avatar.vpcf"
end	

modifier_magic_dragon_gold_dragon_hide = class({})

function modifier_magic_dragon_gold_dragon_hide:RemoveOnDeath() return false end

function modifier_magic_dragon_gold_dragon_hide:IsHidden() return true end

function modifier_magic_dragon_gold_dragon_hide:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACKED}
end

function modifier_magic_dragon_gold_dragon_hide:OnAttacked(keys)
	if keys.target~= self:GetParent() or self:GetParent():PassivesDisabled() then return end
	if keys.target:PassivesDisabled() then return end
	local damageTable = {
		victim = keys.attacker,
		attacker = keys.target,
		damage = keys.original_damage*self:GetAbility():GetSpecialValueFor("damage_return")/100,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self:GetAbility()
	}
	ApplyDamage(damageTable)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_return.vpcf", PATTACH_POINT, keys.attacker)	
	ParticleManager:SetParticleControlEnt(particle, 0, keys.target, PATTACH_POINT, "attach_hitloc", keys.attacker:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 1, keys.attacker, PATTACH_POINT, "attach_hitloc", keys.attacker:GetAbsOrigin(), true)
end

modifier_magic_dragon_black_dragon_breath = class({})

function modifier_magic_dragon_black_dragon_breath:RemoveOnDeath() return false end

function modifier_magic_dragon_black_dragon_breath:IsHidden() return true end

function modifier_magic_dragon_black_dragon_breath:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
	}
end

function modifier_magic_dragon_black_dragon_breath:GetModifierProcAttack_BonusDamage_Physical(keys)
	if keys.target:IsBuilding() or keys.attacker:GetTeamNumber() == keys.target:GetTeamNumber() or keys.target:GetMaxMana() == 0 or keys.target:IsMagicImmune() or keys.attacker:PassivesDisabled() then return 0 end
	
	local hAbility = self:GetAbility()
	local iManaBreak = hAbility:GetSpecialValueFor("mana_break")
	local fCurrentMana = keys.target:GetMana()
	if fCurrentMana > iManaBreak then
		return iManaBreak*hAbility:GetSpecialValueFor("damage_per_mana")
	else
		return fCurrentMana*hAbility:GetSpecialValueFor("damage_per_mana")
	end
end

function modifier_magic_dragon_black_dragon_breath:OnAttackLanded(keys)
	if self:GetParent() ~= keys.attacker or keys.target:IsBuilding() or keys.attacker:GetTeamNumber() == keys.target:GetTeamNumber() or keys.target:GetMaxMana() == 0 or keys.target:IsMagicImmune() or keys.attacker:PassivesDisabled() then return end
	local hAbility = self:GetAbility()
	local iManaBreak = hAbility:GetSpecialValueFor("mana_break")
	local fCurrentMana = keys.target:GetMana()
	if fCurrentMana > iManaBreak then
		keys.target:SetMana(fCurrentMana-iManaBreak)
	else 
		keys.target:SetMana(0)
	end
	local particle = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/am_manaburn_basher_ti_5.vpcf", PATTACH_POINT, keys.target)
	keys.target:EmitSound("Hero_Antimage.ManaBreak")	
end

function modifier_magic_dragon_black_dragon_breath:AllowIllusionDuplicate() return true end

modifier_magic_dragon_green_dragon_breath_slow = class({})

function modifier_magic_dragon_green_dragon_breath_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_magic_dragon_green_dragon_breath_slow:GetModifierMoveSpeedBonus_Percentage()

	self.fSlow = self.fSlow or self:GetAbility():GetSpecialValueFor("speed_slow")
	return self.fSlow
end
function modifier_magic_dragon_green_dragon_breath_slow:OnRefresh()
	self.fSlow = self:GetAbility():GetSpecialValueFor("speed_slow")
end
function modifier_magic_dragon_green_dragon_breath_slow:GetEffectName() return 		
	"particles/econ/items/viper/viper_ti7_immortal/viper_poison_debuff_ti7.vpcf" 
end

function modifier_magic_dragon_green_dragon_breath_slow:GetEffectAttachType() return PATTACH_POINT_FOLLOW end

modifier_magic_dragon_green_dragon_hide = class({})
function modifier_magic_dragon_green_dragon_hide:IsAura() return true end
function modifier_magic_dragon_green_dragon_hide:GetModifierAura() 
	return "modifier_magic_dragon_green_dragon_hide_slow" 
end
function modifier_magic_dragon_green_dragon_hide:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_magic_dragon_green_dragon_hide:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_magic_dragon_green_dragon_hide:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_magic_dragon_green_dragon_hide:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO end
function modifier_magic_dragon_green_dragon_hide:IsHidden() return true end
function modifier_magic_dragon_green_dragon_hide:RemoveOnDeath() return false end
function modifier_magic_dragon_green_dragon_hide:IsPurgable() return false end

modifier_magic_dragon_green_dragon_hide_slow = class({})

function modifier_magic_dragon_green_dragon_hide_slow:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_magic_dragon_green_dragon_hide_slow:GetStatusEffectName() return "particles/status_fx/status_effect_enchantress_untouchable.vpcf" end
function modifier_magic_dragon_green_dragon_hide_slow:GetModifierAttackSpeedBonus_Constant() 
	self.iSlow = self.iSlow or self:GetAbility():GetSpecialValueFor("attack_slow")
	if self:GetCaster():PassivesDisabled() then return 0
	else return self.iSlow end
end

modifier_magic_dragon_red_dragon_hide = class({})

function modifier_magic_dragon_red_dragon_hide:IsAura() return true end
function modifier_magic_dragon_red_dragon_hide:GetModifierAura() 
	return "modifier_magic_dragon_red_dragon_hide_impact" 
end
function modifier_magic_dragon_red_dragon_hide:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_magic_dragon_red_dragon_hide:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_magic_dragon_red_dragon_hide:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_magic_dragon_red_dragon_hide:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO end
function modifier_magic_dragon_red_dragon_hide:IsHidden() return true end
function modifier_magic_dragon_red_dragon_hide:RemoveOnDeath() return false end
function modifier_magic_dragon_red_dragon_hide:IsPurgable() return false end

modifier_magic_dragon_red_dragon_hide_impact = class({})
function modifier_magic_dragon_red_dragon_hide_impact:GetEffectName() return 	"particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard_column.vpcf" end
function modifier_magic_dragon_red_dragon_hide_impact:GetEffectAttachType() return PATTACH_POINT_FOLLOW end
function modifier_magic_dragon_red_dragon_hide_impact:OnCreated() self:StartIntervalThink(1) end
function modifier_magic_dragon_red_dragon_hide_impact:OnIntervalThink() 
	if IsClient() then return end
	local hAbility = self:GetAbility()
	if not hAbility then return end
	if self:GetCaster():PassivesDisabled() then return end
	ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = hAbility:GetSpecialValueFor("damage"), damage_type = hAbility:GetAbilityDamageType(), ability = hAbility})
end 


modifier_magic_dragon_black_dragon_hide = class({})

function modifier_magic_dragon_black_dragon_hide:DeclareFunctions() return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_magic_dragon_black_dragon_hide:IsHidden() return true end
function modifier_magic_dragon_black_dragon_hide:RemoveOnDeath() return false end
function modifier_magic_dragon_black_dragon_hide:IsPurgable() return false end
function modifier_magic_dragon_black_dragon_hide:AllowIllusionDuplicate() return true end
function modifier_magic_dragon_black_dragon_hide:GetModifierMagicalResistanceBonus() 
	if self:GetParent():PassivesDisabled() then return 0 else return self:GetAbility():GetSpecialValueFor("magic_resistence") end
end


modifier_magic_dragon_ghost_dragon_hide = class({})
function modifier_magic_dragon_ghost_dragon_hide:IsAura() return true end
function modifier_magic_dragon_ghost_dragon_hide:GetModifierAura() 
	return "modifier_magic_dragon_ghost_dragon_hide_damage_reduction" 
end
function modifier_magic_dragon_ghost_dragon_hide:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_magic_dragon_ghost_dragon_hide:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_magic_dragon_ghost_dragon_hide:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_magic_dragon_ghost_dragon_hide:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO end
function modifier_magic_dragon_ghost_dragon_hide:IsHidden() return true end
function modifier_magic_dragon_ghost_dragon_hide:RemoveOnDeath() return false end
function modifier_magic_dragon_ghost_dragon_hide:IsPurgable() return false end

modifier_magic_dragon_ghost_dragon_hide_damage_reduction = class({})
function modifier_magic_dragon_ghost_dragon_hide_damage_reduction:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end
function modifier_magic_dragon_ghost_dragon_hide_damage_reduction:GetModifierPreAttack_BonusDamage()
	self.fDamageReduction = self.fDamageReduction or self:GetAbility():GetSpecialValueFor("damage_reduction") 
	if self:GetCaster():PassivesDisabled() then return 0
	else return self.fDamageReduction end
end


modifier_magic_dragon_blue_dragon_hide = class({})
function modifier_magic_dragon_blue_dragon_hide:IsAura() return true end
function modifier_magic_dragon_blue_dragon_hide:GetModifierAura() 
	return "modifier_magic_dragon_blue_dragon_hide_speed_slow" 
end
function modifier_magic_dragon_blue_dragon_hide:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_magic_dragon_blue_dragon_hide:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_magic_dragon_blue_dragon_hide:GetAuraSearchFlags() return DOTA_UNIT_TARGET_NONE end
function modifier_magic_dragon_blue_dragon_hide:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO end
function modifier_magic_dragon_blue_dragon_hide:IsHidden() return true end
function modifier_magic_dragon_blue_dragon_hide:RemoveOnDeath() return false end
function modifier_magic_dragon_blue_dragon_hide:IsPurgable() return false end

modifier_magic_dragon_blue_dragon_hide_speed_slow = class({})
function modifier_magic_dragon_blue_dragon_hide_speed_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_magic_dragon_blue_dragon_hide_speed_slow:GetStatusEffectName() return "particles/status_fx/status_effect_frost.vpcf"  end
function modifier_magic_dragon_blue_dragon_hide_speed_slow:GetModifierMoveSpeedBonus_Percentage()
	if self:GetCaster():PassivesDisabled() then return 0 end
	return self:GetAbility():GetSpecialValueFor("speed_reduction")
end
modifier_magic_dragon_blue_dragon_breath_slow = class({})
function modifier_magic_dragon_blue_dragon_breath_slow:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end

function modifier_magic_dragon_blue_dragon_breath_slow:IsPurgable() return true end
function modifier_magic_dragon_blue_dragon_breath_slow:GetStatusEffectName() return "particles/status_fx/status_effect_frost.vpcf" end
function modifier_magic_dragon_blue_dragon_breath_slow:GetModifierMoveSpeedBonus_Percentage()
	self.fSlow = self.fSlow or self:GetAbility():GetSpecialValueFor("nova_speed_slow")
	return self.fSlow
end
function modifier_magic_dragon_blue_dragon_breath_slow:OnRefresh()
	self.fSlow = self:GetAbility():GetSpecialValueFor("nova_speed_slow")
end
function modifier_magic_dragon_blue_dragon_breath_slow:GetModifierAttackSpeedBonus_Constant()
	self.fAttack = self.fAttack or self:GetAbility():GetSpecialValueFor("attack_slow")
	return self.fAttack
end