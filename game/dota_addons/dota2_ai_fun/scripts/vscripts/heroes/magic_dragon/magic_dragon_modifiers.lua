--[[
modifier_magic_dragon_undead_form = class({})
modifier_magic_dragon_ice_form = class({})
modifier_magic_dragon_fire_form = class({})
]]--
modifier_magic_dragon_lightning_form = class({})

function modifier_magic_dragon_lightning_form:RemoveOnDeath() return false end
function modifier_magic_dragon_lightning_form:IsHidden() return true end

function modifier_magic_dragon_lightning_form:GetStatusEffectName()
	return "particles/status_fx/status_effect_avatar.vpcf"
end	
	
	
--[[
modifier_magic_dragon_anti_magic_form = class({})
modifier_magic_dragon_magic_form = class({})

function modifier_magic_dragon_undead_form:RemoveOnDeath() return false end
function modifier_magic_dragon_ice_form:RemoveOnDeath() return false end
function modifier_magic_dragon_fire_form:RemoveOnDeath() return false end
function modifier_magic_dragon_anti_magic_form:RemoveOnDeath() return false end
function modifier_magic_dragon_magic_form:RemoveOnDeath() return false end

function modifier_magic_dragon_undead_form:IsHidden() return true end
function modifier_magic_dragon_ice_form:IsHidden() return true end
function modifier_magic_dragon_fire_form:IsHidden() return true end
function modifier_magic_dragon_anti_magic_form:IsHidden() return true end
function modifier_magic_dragon_magic_form:IsHidden() return true end




function modifier_magic_dragon_undead_form:DeclareFunctions()
	return {MODIFIER_PROPERTY_MODEL_CHANGE}
end

function modifier_magic_dragon_undead_form:GetModifierModelChange()
	return "models/heroes/visage/visage.vmdl"
end

function modifier_magic_dragon_undead_form:OnCreated()
	if IsClient() then return end
	
	local hParent = self:GetParent()
	HideWearables(hParent)
	hParent:SetRenderColor(255, 255, 255)
	hParent:SetModelScale(1.2)
	hParent:SetRangedProjectileName("particles/units/heroes/hero_visage/visage_base_attack.vpcf")
end


function modifier_magic_dragon_ice_form:DeclareFunctions()
	return {MODIFIER_PROPERTY_MODEL_CHANGE}
end

function modifier_magic_dragon_ice_form:GetModifierModelChange()
	return "models/items/dragon_knight/aurora_warrior_set_dragon_style2_aurora_warrior_set/aurora_warrior_set_dragon_style2_aurora_warrior_set.vmdl"
end

function modifier_magic_dragon_ice_form:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	HideWearables(hParent)
	Timers:CreateTimer(0.03, function () hParent:SetMaterialGroup("2") end)
	hParent:SetRenderColor(255, 255, 255)
	hParent:SetModelScale(1)
	hParent:SetRangedProjectileName("particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost.vpcf")
end


function modifier_magic_dragon_fire_form:DeclareFunctions()
	return {MODIFIER_PROPERTY_MODEL_CHANGE}
end

function modifier_magic_dragon_fire_form:GetModifierModelChange()
	return "models/items/dragon_knight/fireborn_dragon/fireborn_dragon.vmdl"
end

function modifier_magic_dragon_fire_form:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	HideWearables(hParent)
	Timers:CreateTimer(0.03, function () hParent:SetMaterialGroup("1") end)
	hParent:SetRenderColor(255, 255, 255)
	hParent:SetModelScale(1)
	hParent:SetRangedProjectileName("particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf")
end


function modifier_magic_dragon_lightning_form:DeclareFunctions()
	return {MODIFIER_PROPERTY_MODEL_CHANGE}
end

function modifier_magic_dragon_lightning_form:GetModifierModelChange()
	return "models/items/dragon_knight/dragon_immortal_1/dragon_immortal_1.vmdl"
end

function modifier_magic_dragon_lightning_form:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	HideWearables(hParent)
	hParent:SetRenderColor(185, 110, 255)
	hParent:SetModelScale(1)
	hParent:SetRangedProjectileName("particles/econ/items/razor/razor_ti6/razor_base_attack_ti6.vpcf")
end


function modifier_magic_dragon_anti_magic_form:DeclareFunctions()
	return {MODIFIER_PROPERTY_MODEL_CHANGE}
end

function modifier_magic_dragon_anti_magic_form:GetModifierModelChange()
	return "models/items/dragon_knight/aurora_warrior_set_dragon_style2_aurora_warrior_set/aurora_warrior_set_dragon_style2_aurora_warrior_set.vmdl"
end

function modifier_magic_dragon_anti_magic_form:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	HideWearables(hParent)
	hParent:SetRenderColor(0, 0, 0)
	hParent:SetModelScale(1)
	hParent:SetRangedProjectileName("particles/neutral_fx/black_dragon_attack.vpcf")
end


function modifier_magic_dragon_magic_form:DeclareFunctions()
	return {MODIFIER_PROPERTY_MODEL_CHANGE}
end

function modifier_magic_dragon_magic_form:GetModifierModelChange()
	return "models/items/dragon_knight/oblivion_blazer_dragon/oblivion_blazer_dragon.vmdl"
end

function modifier_magic_dragon_magic_form:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	HideWearables(hParent)
	hParent:SetMaterialGroup("0")
	hParent:SetRenderColor(255, 255, 255)
	hParent:SetModelScale(1)
	hParent:SetRangedProjectileName("particles/econ/items/viper/viper_ti7_immortal/viper_poison_attack_ti7.vpcf")
end

]]--
modifier_magic_dragon_gold_dragon_hide = class({})

function modifier_magic_dragon_gold_dragon_hide:RemoveOnDeath() return false end

function modifier_magic_dragon_gold_dragon_hide:IsHidden() return true end

function modifier_magic_dragon_gold_dragon_hide:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACKED}
end

function modifier_magic_dragon_gold_dragon_hide:OnAttacked(keys)
	if keys.target~= self:GetParent() or self:GetParent():PassivesDisabled() then return end
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

























