local tClassHiddenNotPurgable = {IsHidden = function (self) return true end, IsPurgable = function (self) return false end}
local tClassHiddenNotPurgableNotRemoveOnDeath = {IsHidden = function (self) return true end, IsPurgable = function (self) return false end, RemoveOnDeath = function (self) return false end}

modifier_angelic_alliance_maximum_speed = class(tClassHiddenNotPurgable)
function modifier_angelic_alliance_maximum_speed:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
end

function modifier_angelic_alliance_maximum_speed:OnRefresh()
	if IsClient() then return end
	local hParent = self:GetParent()
end

function modifier_angelic_alliance_maximum_speed:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
end

function modifier_angelic_alliance_maximum_speed:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_angelic_alliance_maximum_speed:GetModifierIgnoreMovespeedLimit()
	return 1
end


function modifier_angelic_alliance_maximum_speed:GetModifierMoveSpeedBonus_Percentage()
	if self:GetAbility() then  
		return self:GetAbility():GetSpecialValueFor("movespeed_percentage")
	else
		return 0
	end
end

modifier_item_fun_sprint_shoes_lua = class(tClassHiddenNotPurgableNotRemoveOnDeath)
function modifier_item_fun_sprint_shoes_lua:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()
end
function modifier_item_fun_sprint_shoes_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_item_fun_sprint_shoes_lua:OnCreated()
	self:GetAbility().hModifier = self
	self:StartIntervalThink(FrameTime())
end
function modifier_item_fun_sprint_shoes_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_STATE_CHANGED
	}
	return funcs
end
function modifier_item_fun_sprint_shoes_lua:OnStateChanged(params)
	if IsServer() and params.unit == self:GetParent() then
--		PrintTable(params)
		if params.unit:IsRooted() then
			self:GetAbility():EndChannel(true)
		end
	end
end
function modifier_item_fun_sprint_shoes_lua:OnTakeDamage(keys)
	if keys.unit ~= self:GetParent() or keys.attacker:GetPlayerOwnerID() < 0 or keys.attacker:GetTeam() == keys.unit:GetTeam() or keys.damage == 0 then return end
	self.iLastHitTime = GameRules:GetGameTime()
	self:SetStackCount(1)
end
function modifier_item_fun_sprint_shoes_lua:OnIntervalThink()
	if IsClient() then return end
	if self.iLastHitTime and GameRules:GetGameTime()-self.iLastHitTime > self:GetAbility():GetSpecialValueFor("broken_time") then 
		self:SetStackCount(0) 
	end
	local hParent = self:GetParent()
end
function modifier_item_fun_sprint_shoes_lua:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_item_fun_sprint_shoes_lua:GetModifierMoveSpeedBonus_Percentage_Unique()
	if self:GetAbility() then  
		return self:GetAbility():GetSpecialValueFor("movespeed_percentage")
	else
		return 0
	end
end

modifier_item_fun_escutcheon_lua = class(tClassHiddenNotPurgableNotRemoveOnDeath)

function modifier_item_fun_escutcheon_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_fun_escutcheon_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS, 
		MODIFIER_PROPERTY_MANA_BONUS, 
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL, 
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL, 
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_REINCARNATION,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
--		MODIFIER_PROPERTY_STATUS_RESISTANCE,
		MODIFIER_EVENT_ON_RESPAWN,
	}
end
function modifier_item_fun_escutcheon_lua:GetAbsoluteNoDamagePhysical(keys) 
	if not keys.attacker or not keys.target or keys.damage < 0 or keys.damage_type ~= DAMAGE_TYPE_PHYSICAL then return 0 end
	local caster = self:GetCaster()
--	if self:GetParent() ~= keys.unit then return end
	local reverseChance = self:GetAbility():GetSpecialValueFor("damage_reverse")
	if math.random() < reverseChance/100 then
		caster:Heal(keys.damage, caster)
		SendOverheadEventMessage(caster:GetPlayerOwner(), OVERHEAD_ALERT_HEAL , caster, keys.damage, nil)
		return 1
	end

	return 0
end

function modifier_item_fun_escutcheon_lua:GetAbsoluteNoDamageMagical(keys) 
	if not keys.attacker or not keys.target or keys.damage_type ~= DAMAGE_TYPE_MAGICAL then return 0 end
	local caster = self:GetCaster()
--	if self:GetParent() ~= keys.unit then return end
	local reverseChance = self:GetAbility():GetSpecialValueFor("damage_reverse")
	if math.random() < reverseChance/100 then
		caster:Heal(keys.damage, caster)
		SendOverheadEventMessage(caster:GetPlayerOwner(), OVERHEAD_ALERT_HEAL , caster, keys.damage, nil)
		return 1
	end

	return 0
end

function modifier_item_fun_escutcheon_lua:GetAbsoluteNoDamagePure(keys) 
	if not keys.attacker or not keys.target or keys.damage_type ~= DAMAGE_TYPE_PURE then return 0 end
	local caster = self:GetCaster()
--	if self:GetParent() ~= keys.unit then return end
	local reverseChance = self:GetAbility():GetSpecialValueFor("damage_reverse")
	if math.random() < reverseChance/100 then
		caster:Heal(keys.damage, caster)
		SendOverheadEventMessage(caster:GetPlayerOwner(), OVERHEAD_ALERT_HEAL , caster, keys.damage, nil)
		return 1
	end

	return 0
end


function modifier_item_fun_escutcheon_lua:GetModifierStatusResistance()
	return self:GetAbility():GetSpecialValueFor("status_resistance")
end

function modifier_item_fun_escutcheon_lua:OnCreated()
	self:SetStackCount(1)
	self:StartIntervalThink(0.04)
end

function modifier_item_fun_escutcheon_lua:OnIntervalThink()
	if IsClient() then return end
	self:SetStackCount(#self:GetParent():FindAllModifiersByName(self:GetName()))
end


function modifier_item_fun_escutcheon_lua:GetModifierHealthRegenPercentage()
	return self:GetAbility():GetSpecialValueFor("health_regen_percentage")/self:GetStackCount()
end

function modifier_item_fun_escutcheon_lua:GetModifierTotalPercentageManaRegen()
	return self:GetAbility():GetSpecialValueFor("mana_regen_percentage")/self:GetStackCount()
end


function modifier_item_fun_escutcheon_lua:GetModifierManaBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_mana")
end

function modifier_item_fun_escutcheon_lua:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_item_fun_escutcheon_lua:ReincarnateTime()
	if IsClient() or self:GetParent():IsIllusion() then return -1 end	
	self.bAfterRespawn = true
	local hParent = self:GetParent()
	if hParent:GetHealth() > 0 then return -1 end
	local hAbility = self:GetAbility()
	local fReincarnateTime = hAbility:GetSpecialValueFor("reincarnate_time")
	self.bAfterRespawn = true
	if hAbility:IsCooldownReady() then
		hAbility:UseResources(false, false, true)
		hParent.fReincarnateTime = fReincarnateTime
		return fReincarnateTime
	else
		return -1
	end
end
function modifier_item_fun_escutcheon_lua:OnRespawn(keys)
	if self:GetParent() == keys.unit and self.bAfterRespawn then
		self.bAfterRespawn = nil
		keys.unit:AddNewModifier(keys.unit, self:GetAbility(), "modifier_item_fun_escutcheon_reincarnate_protection", {duration = self:GetAbility():GetSpecialValueFor("protection_duration")})
	end
end

modifier_item_fun_escutcheon_reincarnate_protection = class({})

function modifier_item_fun_escutcheon_reincarnate_protection:IsHidden() return false end
function modifier_item_fun_escutcheon_reincarnate_protection:IsPurgable() return false end
function modifier_item_fun_escutcheon_reincarnate_protection:RemoveOnDeath() return true end
function modifier_item_fun_escutcheon_reincarnate_protection:OnCreated(keys)
	if IsClient() then return end
	hParent = self:GetParent()
	self.iParticle = ParticleManager:CreateParticle("particles_bak/escutcheon_reincarnate_protection.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(self.iParticle, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetOrigin(), true)
end
function modifier_item_fun_escutcheon_reincarnate_protection:OnDestroy()
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle, false)
end
function modifier_item_fun_escutcheon_reincarnate_protection:DeclareFunctions()
	return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, MODIFIER_PROPERTY_STATUS_RESISTANCE}
end
function modifier_item_fun_escutcheon_reincarnate_protection:GetModifierStatusResistance()
	return self:GetAbility():GetSpecialValueFor("protection_status_resistance")
end
function modifier_item_fun_escutcheon_reincarnate_protection:GetModifierIncomingDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("protection_damage_reduction")
end
function modifier_item_fun_escutcheon_reincarnate_protection:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

modifier_ragnarok_cleave = class(tClassHiddenNotPurgable)

function modifier_ragnarok_cleave:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end
function modifier_ragnarok_cleave:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end


modifier_magic_hammer_mana_break = class(tClassHiddenNotPurgable)

function modifier_magic_hammer_mana_break:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
--		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING
	}
end

function modifier_magic_hammer_mana_break:GetModifierCastRangeBonusStacking() return self:GetAbility():GetSpecialValueFor("bonus_cast_range") end

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


modifier_heros_bow_active = class({})
function modifier_heros_bow_active:IsPurgable() return true end
function modifier_heros_bow_active:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end 
function modifier_heros_bow_active:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_heros_bow_active:GetEffectName() return "particles/econ/events/ti7/force_staff_ti7.vpcf" end
function modifier_heros_bow_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_heros_bow_active:OnCreated(keys)
	if IsClient() then return end	
	self.vSpeedHorizontal = keys.fSpeedHorizontal*self:GetParent():GetForwardVector()
	self:ApplyHorizontalMotionController()
	self:GetParent():EmitSound("DOTA_Item.ForceStaff.Activate")
end

function modifier_heros_bow_active:OnDestroy()
	if IsClient() then return end	
	local hParent = self:GetParent()
	hParent:RemoveHorizontalMotionController(self)
	FindClearSpaceForUnit(hParent, hParent:GetOrigin(), false)
end


function modifier_heros_bow_active:UpdateHorizontalMotion(me, dt)	
	GridNav:DestroyTreesAroundPoint(me:GetOrigin(), 150, true)
	me:SetOrigin(me:GetOrigin()+dt*self.vSpeedHorizontal)
end

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
	return {MODIFIER_PROPERTY_ATTACK_RANGE_BONUS, MODIFIER_EVENT_ON_ORDER}
end

function modifier_heros_bow_always_allow_attack:OnOrder(keys)
	if keys.unit~= self:GetParent() then return end
	if keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET and keys.target:HasModifier("modifier_item_fun_heros_bow_debuff") and keys.unit:IsRangedAttacker() then
		self.iAttackRange = 99999
	else
		self.iAttackRange = 0
	end
end


function modifier_heros_bow_always_allow_attack:GetModifierAttackRangeBonus()
	return self.iAttackRange
end

function modifier_heros_bow_always_allow_attack:IsPurgable() return false end

modifier_item_fun_heros_bow_debuff = class({})
function modifier_item_fun_heros_bow_debuff:IsPurgable() return true end
function modifier_item_fun_heros_bow_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, MODIFIER_PROPERTY_PROVIDES_FOW_POSITION, MODIFIER_PROPERTY_DISABLE_HEALING} end
function modifier_item_fun_heros_bow_debuff:GetModifierIncomingDamage_Percentage() return self:GetAbility():GetSpecialValueFor("damage_amp") end
function modifier_item_fun_heros_bow_debuff:GetModifierProvidesFOWVision() return 1 end
function modifier_item_fun_heros_bow_debuff:GetDisableHealing() return 1 end
--function modifier_item_fun_heros_bow_debuff:CheckState() return {[MODIFIER_STATE_MUTED] = true} end
function modifier_item_fun_heros_bow_debuff:OnCreated() 
	if IsClient() or not self:GetCaster():IsRangedAttacker() then return end	
	self.vOriginalPos = self:GetCaster():GetOrigin()
	self:StartIntervalThink(0.04)
end
function modifier_item_fun_heros_bow_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_item_fun_heros_bow_debuff:GetEffectName() return "particles/items4_fx/nullifier_mute.vpcf" end
function modifier_item_fun_heros_bow_debuff:OnIntervalThink()	
	if IsClient() or not self:GetCaster():IsRangedAttacker() then return end	
	local hCaster = self:GetCaster()
	local me = self:GetParent()
	if (me:GetOrigin()-self.vOriginalPos):Length2D() < self:GetAbility():GetSpecialValueFor("minimum_distance") and not me:IsMagicImmune() and not me:IsInvulnerable() then
		local vEndLocation = self.vOriginalPos+Vector2D(me:GetOrigin()-self.vOriginalPos):Normalized()*self:GetAbility():GetSpecialValueFor("minimum_distance")
		FindClearSpaceForUnit(me, vEndLocation, true)
	end
	self:GetParent():Purge(true, false, false, false, false)
end

local tCleaveAbilityList = {
	felguard_overflow = true,
	item_bfury = true,
	item_fun_ragnarok_2 = true,
	kunkka_tidebringer = true,
	magnataur_empower = true
}

modifier_angelic_alliance_spell_lifesteal = class(tClassHiddenNotPurgable)


function modifier_angelic_alliance_spell_lifesteal:DeclareFunctions()
    return  {
		MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_angelic_alliance_spell_lifesteal:OnTakeDamage(keys)
	if keys.attacker~=self:GetParent() or keys.attacker:IsIllusion() or not keys.inflictor or bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL)>0 then return end
	local sName = keys.inflictor:GetName()
	if string.match(sName, "cleave") or tCleaveAbilityList[sName] then return end
	ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
	keys.attacker:Heal(self:GetAbility():GetSpecialValueFor("spell_lifesteal")/100*keys.damage, keys.attacker)
end

modifier_economizer_spell_lifesteal = class(tClassHiddenNotPurgable)


function modifier_economizer_spell_lifesteal:DeclareFunctions()
    return  {
		MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_economizer_spell_lifesteal:OnTakeDamage(keys)
	if keys.attacker~=self:GetParent() or keys.attacker:IsIllusion() or not keys.inflictor or bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL)>0  then return end
	local sName = keys.inflictor:GetName()
	if string.match(sName, "cleave") or tCleaveAbilityList[sName] then return end
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

modifier_economizer_ultimate = class(tClassHiddenNotPurgableNotRemoveOnDeath)

function modifier_economizer_ultimate:DeclareFunctions() return {MODIFIER_PROPERTY_IS_SCEPTER} end
function modifier_economizer_ultimate:GetModifierScepter() return 1 end

modifier_angelic_alliance_death_drop = class(tClassHiddenNotPurgableNotRemoveOnDeath)
function modifier_angelic_alliance_death_drop:DeclareFunctions() return {MODIFIER_EVENT_ON_DEATH} end
function modifier_angelic_alliance_death_drop:OnDeath(keys)
	if keys.unit ~= self:GetParent() or keys.reincarnate or keys.unit:IsIllusion() then return end
	for i = 0, 8 do
		if keys.unit:GetItemInSlot(i) and keys.unit:GetItemInSlot(i):GetName() == "item_fun_angelic_alliance" then
			keys.unit:DropItemAtPositionImmediate(keys.unit:GetItemInSlot(i), keys.unit:GetOrigin())
		end
	end
end
modifier_item_fun_magic_hammer_root = class({})

function modifier_item_fun_magic_hammer_root:CheckState()
	return {[MODIFIER_STATE_ROOTED] = true}
end

local function MagicHammerManaBurn(caster, target, ability)
	local mana_burn = ability:GetSpecialValueFor("mana_burn")
	local mana_burn_damage = ability:GetSpecialValueFor("mana_burn_damage")
	local currentMana = target:GetMana()
	target:EmitSound("DOTA_Item.DiffusalBlade.Activate")
--	ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	damageTable = {attacker = caster, victim = target, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability}
	if currentMana > mana_burn then
		target:SetMana(currentMana-mana_burn)
		damageTable.damage = mana_burn*mana_burn_damage
		ApplyDamage(damageTable)
		
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS , target, mana_burn, nil)
	else
		target:SetMana(0)
		damageTable.damage = currentMana*mana_burn_damage
		ApplyDamage(damageTable)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS , target, currentMana, nil)
	end	
end

function modifier_item_fun_magic_hammer_root:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	MagicHammerManaBurn(self:GetCaster(), hParent, self:GetAbility())
	self.iParticle = ParticleManager:CreateParticle("particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_purge.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(self.iParticle, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetOrigin(), true)
	self:StartIntervalThink(CalculateStatusResist(hParent))
end

function modifier_item_fun_magic_hammer_root:OnIntervalThink()
	if IsClient() then return end
	MagicHammerManaBurn(self:GetCaster(), self:GetParent(), self:GetAbility())
end

function modifier_item_fun_magic_hammer_root:OnDestroy()
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.iParticle, true)
end

modifier_item_fun_ban_regen = class({})
function modifier_item_fun_ban_regen:IsPurgable() return false end
function modifier_item_fun_ban_regen:OnDestroy() if IsServer() then self.hParent.hModifier = nil end end
function modifier_item_fun_ban_regen:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
local function OnTakeDamageTBR(self, keys)
	if keys.unit ~= self:GetParent() or keys.attacker:GetPlayerOwnerID() < 0 or keys.attacker:GetTeam() == keys.unit:GetTeam() or keys.damage == 0 then return end
	
	local fTime
	if self:GetParent():IsRangedAttacker() then
		fTime = self:GetAbility():GetSpecialValueFor('ban_regen_time_ranged')
	else
		fTime = self:GetAbility():GetSpecialValueFor('ban_regen_time_meele')
	end
	if self.hModifier then
		self.hModifier:SetDuration(fTime, true)
	else
		self.hModifier = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), 'modifier_item_fun_ban_regen',{Duration = fTime})
		self.hModifier.hParent = self
	end
	
end

local GetHealthRegenTBR = function(self)
	if self:GetStackCount()%2 > 0 then
		return 0
	else
		return self:GetAbility():GetSpecialValueFor("health_regen")/math.floor(self:GetStackCount()/2)
	end
end
local OnIntervalThinkTBR = function(self)
	if IsClient() then return end
	local iCount = 2*#self:GetParent():FindAllModifiersByName(self:GetName())
	if self.hModifier then iCount = iCount+1 end
	self:SetStackCount(iCount)
end

modifier_item_fun_terra_blade = class(tClassHiddenNotPurgableNotRemoveOnDeath)
function modifier_item_fun_terra_blade:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_fun_terra_blade:CheckState() return {[MODIFIER_STATE_CANNOT_MISS] = true} end
function modifier_item_fun_terra_blade:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
--		MODIFIER_PROPERTY_STATUS_RESISTANCE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
--		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
--		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end
modifier_item_fun_terra_blade.OnTakeDamage = OnTakeDamageTBR
modifier_item_fun_terra_blade.OnIntervalThink = OnIntervalThinkTBR
modifier_item_fun_terra_blade.GetModifierHealthRegenPercentage = GetHealthRegenTBR
function modifier_item_fun_terra_blade:OnAttackLanded(keys)
	if keys.attacker ~= self:GetParent() or keys.attacker:GetTeam() == keys.target:GetTeam() or keys.target:IsBuilding() or keys.attacker:IsIllusion() then return end
	keys.ability = self:GetAbility()
--	keys.target:EmitSound("DOTA_Item.Maim")
--	keys.target:AddNewModifier(keys.attacker, keys.ability, "modifier_item_fun_terra_blade_ultra_maim", {Duration = keys.ability:GetSpecialValueFor("maim_duration")*CalculateStatusResist(keys.target)})

	keys.target:AddNewModifier(keys.attacker, keys.ability, "modifier_bashed", {Duration = keys.ability:GetSpecialValueFor("bash_stun")*CalculateStatusResist(keys.target)})
	keys.target:EmitSound("DOTA_Item.MKB.Minibash")
	ParticleManager:CreateParticle("particles/generic_gameplay/generic_minibash.vpcf", PATTACH_OVERHEAD_FOLLOW, keys.target)
	
end

function modifier_item_fun_terra_blade:OnAttack(keys)
	if keys.attacker ~= self:GetParent() or keys.attacker:GetTeam() == keys.target:GetTeam() or keys.target:IsBuilding() or keys.attacker:IsIllusion() then return end
	keys.ability = self:GetAbility()
	keys.ability.iCounter = keys.ability.iCounter or 0
	if (keys.ability.iCounter == keys.ability:GetSpecialValueFor("projectile_interval")) then
		keys.ability.iCounter = 0
	end
	keys.ability.iCounter = keys.ability.iCounter+1
	if keys.ability.iCounter ~= 1 then return end
	local tInfo = 
	{
		Ability = keys.ability,
		EffectName = "particles/windrunner_spell_powershot_rainmaker.vpcf",
		vSpawnOrigin = keys.attacker:GetAbsOrigin(),
		fDistance = keys.ability:GetSpecialValueFor("projectile_distance"),
		fStartRadius = keys.ability:GetSpecialValueFor("projectile_start_radius"),
		fEndRadius = keys.ability:GetSpecialValueFor("projectile_end_radius"),
		Source = keys.attacker,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = keys.attacker:GetForwardVector() * keys.ability:GetSpecialValueFor("projectile_speed"),
		bProvidesVision = true,
		iVisionRadius = 800,
		iVisionTeamNumber = keys.attacker:GetTeamNumber(),
		ExtraData = {TargetEntIndex = keys.target:entindex()}
	}
	keys.ability.tProjectiles = keys.ability.tProjectiles or {}
	local iMax = math.ceil(keys.ability:GetSpecialValueFor("projectile_distance")/keys.ability:GetSpecialValueFor("projectile_speed")/keys.ability:GetSpecialValueFor("minimum_at"))+2
	for i = 1, iMax-1 do
		keys.ability.tProjectiles[iMax+1-i] = keys.ability.tProjectiles[iMax-i] 
	end
	keys.ability.tProjectiles[1] = {keys.target:entindex(), GameRules:GetGameTime(), tInfo.vSpawnOrigin, tInfo.vVelocity} 

	projectile = ProjectileManager:CreateLinearProjectile(tInfo)

end

if IsServer() then
	tValidOrder = {
		[DOTA_UNIT_ORDER_CONTINUE] = true, 
		[DOTA_UNIT_ORDER_CAST_TOGGLE] = true, 
		[DOTA_UNIT_ORDER_PICKUP_ITEM] = true, 
		[DOTA_UNIT_ORDER_CAST_TARGET] = true, 
		[DOTA_UNIT_ORDER_PICKUP_RUNE] = true, 
		[DOTA_UNIT_ORDER_MOVE_TO_TARGET] = true, 
		[DOTA_UNIT_ORDER_PATROL] = true, 
		[DOTA_UNIT_ORDER_DROP_ITEM] = true, 
		[DOTA_UNIT_ORDER_GIVE_ITEM] = true, 
		[DOTA_UNIT_ORDER_CAST_NO_TARGET] = true, 
		[DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO] = true,
		[DOTA_UNIT_ORDER_MOVE_TO_POSITION] = true,
		[DOTA_UNIT_ORDER_CAST_POSITION] = true,
		[DOTA_UNIT_ORDER_CAST_TARGET_TREE] = true,
		[DOTA_UNIT_ORDER_MOVE_TO_DIRECTION] = true,
	}
end
function modifier_item_fun_terra_blade:OnOrder(keys)
	if self:GetParent() ~= keys.unit then return end
	local hAbility = self:GetAbility()
	if tValidOrder[keys.order_type] or (keys.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET and not keys.unit:IsAttackingEntity(keys.target)) then
		self:GetAbility().iCounter = 0
	end
	
end

function modifier_item_fun_terra_blade:OnCreated()
	self:SetStackCount(2)
	self:StartIntervalThink(0.04)
	-- use sange to add status resistance, strength and damage
	if IsClient() then return end
	self.hSangeModifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_sange", {})
end

function modifier_item_fun_terra_blade:OnDestroy()
	if IsClient() then return end
	self.hSangeModifier:Destroy()
end

function modifier_item_fun_terra_blade:GetModifierHPRegenAmplify_Percentage() return self:GetAbility():GetSpecialValueFor("hp_regen_amp_base")/math.floor(self:GetStackCount()/2) end
function modifier_item_fun_terra_blade:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor("bonus_agility") end
function modifier_item_fun_terra_blade:GetModifierEvasion_Constant() return self:GetAbility():GetSpecialValueFor("evasion") end
function modifier_item_fun_terra_blade:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage") end
function modifier_item_fun_terra_blade:GetModifierConstantManaRegen() return self:GetAbility():GetSpecialValueFor("manaregen") end
function modifier_item_fun_terra_blade:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") end
function modifier_item_fun_terra_blade:GetModifierBaseAttackTimeConstant() return self:GetAbility():GetSpecialValueFor("bat") end
function modifier_item_fun_terra_blade:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("bonus_strength") end
function modifier_item_fun_terra_blade:GetModifierHealthBonus() return self:GetAbility():GetSpecialValueFor("bonus_health") end
function modifier_item_fun_terra_blade:GetModifierMoveSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("movement_speed_bonus_constant")/math.floor(self:GetStackCount()/2) end
function modifier_item_fun_terra_blade:GetModifierBaseDamageOutgoing_Percentage() return self:GetAbility():GetSpecialValueFor("bonus_damage_percentage")/math.floor(self:GetStackCount()/2) end



modifier_item_fun_terra_blade.GetModifierHealthRegenPercentage = GetHealthRegenTBR

function modifier_item_fun_terra_blade:GetModifierStatusResistance() return self:GetAbility():GetSpecialValueFor("status_resistance") end
modifier_item_fun_terra_blade_ultra_maim = class({})
function modifier_item_fun_terra_blade_ultra_maim:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end
function modifier_item_fun_terra_blade_ultra_maim:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("maim_movement_percentage") end
function modifier_item_fun_terra_blade_ultra_maim:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("maim_attack") end
function modifier_item_fun_terra_blade_ultra_maim:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_fun_terra_blade_ultra_maim:GetEffectName() return "particles/items2_fx/sange_maim.vpcf" end

modifier_item_fun_ragnarok_lua = class(tClassHiddenNotPurgableNotRemoveOnDeath)
function modifier_item_fun_ragnarok_lua:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end 

function modifier_item_fun_ragnarok_lua:OnCreated()
	self:SetStackCount(2)
	self:StartIntervalThink(0.04)
end

function modifier_item_fun_ragnarok_lua:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end
function modifier_item_fun_ragnarok_lua:GetModifierConstantHealthRegen() return self:GetAbility():GetSpecialValueFor("health_regen") end
function modifier_item_fun_ragnarok_lua:GetModifierHPRegenAmplify_Percentage() return self:GetAbility():GetSpecialValueFor("hp_regen_amp")/math.floor(self:GetStackCount()/2) end
function modifier_item_fun_ragnarok_lua:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("bonus_strength") end
function modifier_item_fun_ragnarok_lua:GetModifierHealthBonus() return self:GetAbility():GetSpecialValueFor("bonus_health") end
function modifier_item_fun_ragnarok_lua:GetModifierBaseDamageOutgoing_Percentage() return self:GetAbility():GetSpecialValueFor("bonus_damage_percentage")/math.floor(self:GetStackCount()/2) end

modifier_item_fun_ragnarok_lua.OnTakeDamage = OnTakeDamageTBR
modifier_item_fun_ragnarok_lua.OnIntervalThink = OnIntervalThinkTBR
modifier_item_fun_ragnarok_lua.GetModifierHealthRegenPercentage = GetHealthRegenTBR


modifier_item_fun_ragnarok_2_lua = class(tClassHiddenNotPurgableNotRemoveOnDeath)
function modifier_item_fun_ragnarok_2_lua:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
-- Use sange to add strength, damage and status resist
function modifier_item_fun_ragnarok_2_lua:OnCreated()
	self:SetStackCount(2)
	self:StartIntervalThink(0.04)
	if IsClient() then return end
	self.hSangeModifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_sange", {})
end

function modifier_item_fun_ragnarok_2_lua:OnDestroy()
	if IsClient() then return end
	self.hSangeModifier:Destroy()
end


function modifier_item_fun_ragnarok_2_lua:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
--		MODIFIER_PROPERTY_STATUS_RESISTANCE,
--		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
--		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end
function modifier_item_fun_ragnarok_2_lua:GetModifierHPRegenAmplify_Percentage() return self:GetAbility():GetSpecialValueFor("hp_regen_amp_base")/math.floor(self:GetStackCount()/2) end
function modifier_item_fun_ragnarok_2_lua:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("bonus_strength") end
function modifier_item_fun_ragnarok_2_lua:GetModifierHealthBonus() return self:GetAbility():GetSpecialValueFor("bonus_health") end
function modifier_item_fun_ragnarok_2_lua:GetModifierBaseDamageOutgoing_Percentage() return self:GetAbility():GetSpecialValueFor("bonus_damage_percentage")/math.floor(self:GetStackCount()/2) end

modifier_item_fun_ragnarok_2_lua.OnTakeDamage = OnTakeDamageTBR
modifier_item_fun_ragnarok_2_lua.OnIntervalThink = OnIntervalThinkTBR
modifier_item_fun_ragnarok_2_lua.GetModifierHealthRegenPercentage = GetHealthRegenTBR
function modifier_item_fun_ragnarok_2_lua:GetModifierStatusResistance() return self:GetAbility():GetSpecialValueFor("status_resistance") end
function modifier_item_fun_ragnarok_2_lua:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage") end
function modifier_item_fun_ragnarok_2_lua:GetModifierConstantManaRegen() return self:GetAbility():GetSpecialValueFor("manaregen") end

function modifier_item_fun_ragnarok_2_lua:OnAttackLanded(keys)
	if keys.attacker ~= self:GetParent() or keys.attacker:IsIllusion() or keys.attacker:IsRangedAttacker() or keys.target:GetTeam() == keys.attacker:GetTeam() or keys.target:IsBuilding() then return end
	local hAbility = self:GetAbility()
	local fCleaveDistance = hAbility:GetSpecialValueFor("cleave_distance")
	local fCleaveStartRadius = hAbility:GetSpecialValueFor("cleave_start_radius")
	local fCleaveEndRadius = hAbility:GetSpecialValueFor("cleave_end_radius")
	if keys.attacker:HasModifier("modifier_phantom_assassin_stiflingdagger_caster") then
		local tCleavedEntityList = {[keys.target:entindex()]=true}
		local fLineWidth
		local iLineNum = 20
		if fCleaveEndRadius > fCleaveStartRadius then
			fLineWidth = fCleaveEndRadius/(iLineNum-1)*2
		else		
			fLineWidth = fCleaveStartRadius/(iLineNum-1)*2
		end
		local vFront=Vector2D(keys.target:GetOrigin()-keys.attacker:GetOrigin()):Normalized()
		local vLeft = Vector(0,0,0).Cross(Vector(0, 0, 1), vFront)
		local vRight = Vector(0,0,0).Cross(vFront, Vector(0, 0, 1))
		local vStartLeft = keys.target:GetOrigin()+vLeft*fCleaveStartRadius
		local vEndLeft = keys.target:GetOrigin()+vLeft*fCleaveEndRadius+vFront*fCleaveDistance
		local vStartInterval = fCleaveStartRadius/(iLineNum-1)*2*vRight
		local vEndInterval = fCleaveEndRadius/(iLineNum-1)*2*vRight
		for i = 1, iLineNum do
			
--			DebugDrawLine(vStartLeft+(i-1)*vStartInterval, vEndLeft+(i-1)*vEndInterval, 255,255,5,false,3)
			local tTargets = FindUnitsInLine(keys.attacker:GetTeam(), vStartLeft+(i-1)*vStartInterval, vEndLeft+(i-1)*vEndInterval, nil, fLineWidth, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
			for i, v in ipairs(tTargets) do
				if not tCleavedEntityList[v:entindex()] then
					tCleavedEntityList[v:entindex()] = true
					ApplyDamage({damage = hAbility:GetSpecialValueFor("cleave_damage")*keys.original_damage/100, damage_type = DAMAGE_TYPE_PHYSICAL, attacker = keys.attacker, victim = v, ability = hAbility, damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL})
				end
			end
		end
		return
	else		
		local iParticle = ParticleManager:CreateParticle('particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf', PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
		local tCleavedEntityList = {[keys.target:entindex()]=true}
		local fLineWidth
		local iLineNum = 20
		if fCleaveEndRadius > fCleaveStartRadius then
			fLineWidth = fCleaveEndRadius/(iLineNum-1)*2
		else		
			fLineWidth = fCleaveStartRadius/(iLineNum-1)*2
		end
		
		local vFront=Vector2D(keys.attacker:GetForwardVector()):Normalized()
		local vLeft = Vector(0,0,0).Cross(Vector(0, 0, 1), vFront)
		local vRight = Vector(0,0,0).Cross(vFront, Vector(0, 0, 1))
		local vStartLeft = keys.attacker:GetOrigin()+vLeft*fCleaveStartRadius
		local vEndLeft = keys.attacker:GetOrigin()+vLeft*fCleaveEndRadius+vFront*fCleaveDistance
		local vStartInterval = fCleaveStartRadius/(iLineNum-1)*2*vRight
		local vEndInterval = fCleaveEndRadius/(iLineNum-1)*2*vRight
		local iCleaveTargetParticleNum = 17
		for i = 1, iLineNum do
			
--			DebugDrawLine(vStartLeft+(i-1)*vStartInterval, vEndLeft+(i-1)*vEndInterval, 255,255,5,false,3)
			local tTargets = FindUnitsInLine(keys.attacker:GetTeam(), vStartLeft+(i-1)*vStartInterval, vEndLeft+(i-1)*vEndInterval, nil, fLineWidth, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
			for i, v in ipairs(tTargets) do
				if not tCleavedEntityList[v:entindex()] then
					tCleavedEntityList[v:entindex()] = true
					ParticleManager:SetParticleControlEnt(iParticle, iCleaveTargetParticleNum, v, PATTACH_POINT_FOLLOW, "attach_hitloc",v:GetOrigin(),true)
					iCleaveTargetParticleNum = iCleaveTargetParticleNum+1
					ApplyDamage({damage = hAbility:GetSpecialValueFor("cleave_damage")*keys.original_damage/100, damage_type = DAMAGE_TYPE_PHYSICAL, attacker = keys.attacker, victim = v, ability = hAbility, damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL})
				end
			end
		end
		return
		
	end
--	DoCleaveAttack(keys.attacker, keys.target, hAbility, hAbility:GetSpecialValueFor("cleave_damage")*keys.original_damage/100, fCleaveStartRadius, fCleaveEndRadius, fCleaveDistance, "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf")	
end

modifier_item_fun_papyrus_scarab = class(tClassHiddenNotPurgableNotRemoveOnDeath)
function modifier_item_fun_papyrus_scarab:DeclareFunctions() return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_MANA_BONUS,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
}
end

function modifier_item_fun_papyrus_scarab:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor('bonus_movement') end
function modifier_item_fun_papyrus_scarab:GetModifierManaBonus() return self:GetAbility():GetSpecialValueFor('bonus_mana') end
function modifier_item_fun_papyrus_scarab:GetModifierPhysicalArmorBonus() return self:GetAbility():GetSpecialValueFor('bonus_armor') end
function modifier_item_fun_papyrus_scarab:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor('bonus_attack_speed') end
function modifier_item_fun_papyrus_scarab:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor('bonus_all_stats') end
function modifier_item_fun_papyrus_scarab:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor('bonus_all_stats') end
function modifier_item_fun_papyrus_scarab:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor('bonus_all_stats') end
function modifier_item_fun_papyrus_scarab:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor('bonus_attack_speed') end

function modifier_item_fun_papyrus_scarab:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_fun_papyrus_scarab:OnCreated()
	if IsClient() then return end
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	if hCaster:IsIllusion() or hCaster:IsTempestDouble() then return end
	self.hEmitter1 = self:GetCaster():AddNewModifier(hCaster, hAbility, 'modifier_item_fun_papyrus_scarab_aura_emitter_1', {})
	self.hEmitter2 = self:GetCaster():AddNewModifier(hCaster, hAbility, 'modifier_item_fun_papyrus_scarab_aura_emitter_2', {})
	self.hEmitter3 = self:GetCaster():AddNewModifier(hCaster, hAbility, 'modifier_item_fun_papyrus_scarab_aura_emitter_3', {})
end
function modifier_item_fun_papyrus_scarab:OnDestroy()
	if IsClient() then return end
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	if hCaster:IsIllusion() or hCaster:IsTempestDouble() then return end
	self.hEmitter1:Destroy()
	self.hEmitter2:Destroy()
	self.hEmitter3:Destroy()
end

modifier_item_fun_papyrus_scarab_aura_1 = class({})
function modifier_item_fun_papyrus_scarab_aura_1:IsPurgable() return false end
function modifier_item_fun_papyrus_scarab_aura_1:DeclareFunctions() return {
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
}
end

function modifier_item_fun_papyrus_scarab_aura_1:GetModifierConstantHealthRegen() return self:GetAbility():GetSpecialValueFor('aura_health_regen') end
function modifier_item_fun_papyrus_scarab_aura_1:GetModifierConstantManaRegen() return self:GetAbility():GetSpecialValueFor('aura_mana_regen') end
function modifier_item_fun_papyrus_scarab_aura_1:GetModifierBaseDamageOutgoing_Percentage() return self:GetAbility():GetSpecialValueFor('aura_damage') end
function modifier_item_fun_papyrus_scarab_aura_1:GetModifierPhysicalArmorBonus() return self:GetAbility():GetSpecialValueFor('aura_positive_armor') end
function modifier_item_fun_papyrus_scarab_aura_1:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor('aura_attack_speed') end
function modifier_item_fun_papyrus_scarab_aura_1:OnTooltip() return self:GetAbility():GetSpecialValueFor('aura_lifesteal') end
function modifier_item_fun_papyrus_scarab_aura_1:OnTakeDamage(keys)
	if keys.attacker ~= self:GetParent() or keys.unit:IsBuilding() or keys.unit:GetTeam() == keys.attacker:GetTeam() then return end
	if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
		local fHeal = keys.damage*self:GetAbility():GetSpecialValueFor('aura_lifesteal')/100
		if keys.unit:IsIllusion() then fHeal = fHeal/3 end
		keys.attacker:Heal(fHeal, self:GetAbility())
		ParticleManager:CreateParticle('particles/generic_gameplay/generic_lifesteal.vpcf', PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
	else
		if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) == 0 then
			local fHeal = keys.damage*self:GetAbility():GetSpecialValueFor('aura_lifesteal')/100
			if keys.unit:IsIllusion() then fHeal = fHeal/3 end
			keys.attacker:Heal(fHeal, self:GetAbility())
			ParticleManager:CreateParticle('particles/items3_fx/octarine_core_lifesteal.vpcf', PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
		end
	end
end

modifier_item_fun_papyrus_scarab_aura_2 = class({})
function modifier_item_fun_papyrus_scarab_aura_2:GetModifierPhysicalArmorBonus() return  self:GetAbility():GetSpecialValueFor('aura_negative_armor') end
function modifier_item_fun_papyrus_scarab_aura_2:IsPurgable() return false end
function modifier_item_fun_papyrus_scarab_aura_2:DeclareFunctions() return {
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end




modifier_item_fun_papyrus_scarab_aura_emitter_1 = class(tClassHiddenNotPurgableNotRemoveOnDeath)
function modifier_item_fun_papyrus_scarab_aura_emitter_1:IsAura() return true end
function modifier_item_fun_papyrus_scarab_aura_emitter_1:GetModifierAura() return "modifier_item_fun_papyrus_scarab_aura_1" end
function modifier_item_fun_papyrus_scarab_aura_emitter_1:GetAuraRadius() return self:GetAbility():GetSpecialValueFor('aura_radius') end
function modifier_item_fun_papyrus_scarab_aura_emitter_1:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_fun_papyrus_scarab_aura_emitter_1:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_item_fun_papyrus_scarab_aura_emitter_1:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_item_fun_papyrus_scarab_aura_emitter_1:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

modifier_item_fun_papyrus_scarab_aura_emitter_2 = class(tClassHiddenNotPurgableNotRemoveOnDeath)
function modifier_item_fun_papyrus_scarab_aura_emitter_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_fun_papyrus_scarab_aura_emitter_2:IsAura() return true end
function modifier_item_fun_papyrus_scarab_aura_emitter_2:GetModifierAura() return "modifier_item_fun_papyrus_scarab_aura_2" end
function modifier_item_fun_papyrus_scarab_aura_emitter_2:GetAuraRadius() return self:GetAbility():GetSpecialValueFor('aura_radius') end
function modifier_item_fun_papyrus_scarab_aura_emitter_2:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_fun_papyrus_scarab_aura_emitter_2:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_BUILDING end
function modifier_item_fun_papyrus_scarab_aura_emitter_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

modifier_item_fun_papyrus_scarab_aura_emitter_3 = class(tClassHiddenNotPurgableNotRemoveOnDeath)
function modifier_item_fun_papyrus_scarab_aura_emitter_3:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_fun_papyrus_scarab_aura_emitter_3:IsAura() 
	if self.bAuraActivated then
		return true
	else
		return false
	end
end
function modifier_item_fun_papyrus_scarab_aura_emitter_3:GetModifierAura() return "modifier_item_fun_papyrus_scarab_aura_3" end
function modifier_item_fun_papyrus_scarab_aura_emitter_3:GetAuraRadius() return self:GetAbility():GetSpecialValueFor('aura_radius_2') end
function modifier_item_fun_papyrus_scarab_aura_emitter_3:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_fun_papyrus_scarab_aura_emitter_3:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO end
function modifier_item_fun_papyrus_scarab_aura_emitter_3:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_fun_papyrus_scarab_aura_emitter_3:GetAuraEntityReject(hTarget)
	if (not string.find(hTarget:GetUnitName(), 'hero')) and hTarget:GetPlayerOwnerID() == self:GetParent():GetPlayerOwnerID() then return false else return true end
end

function modifier_item_fun_papyrus_scarab_aura_emitter_3:OnCreated()
	self:GetAbility().hModifierAuraEmitter3 = self
	self:StartIntervalThink(0.04)
end

local PAPYRUS_SCARAB_DAMAGE = 1
local PAPYRUS_SCARAB_ARMOR = 2
local PAPYRUS_SCARAB_ATTACK_SPPED = 3
local PAPYRUS_SCARAB_MOVEMENT_SPEED = 4
local PAPYRUS_SCARAB_MANA = 5
local PAPYRUS_SCARAB_MANA_REGEN = 6
local PAPYRUS_SCARAB_SPELL_AMP = 7
local PAPYRUS_SCARAB_HEALTH = 8
local PAPYRUS_SCARAB_HEALTH_REGEN = 9
local PAPYRUS_SCARAB_MAGIC_RESIST = 10

function modifier_item_fun_papyrus_scarab_aura_emitter_3:OnIntervalThink()
	if IsServer() then 
		local hCaster = self:GetCaster()
		local fStrength = hCaster:GetStrength()
		local fIntellect = hCaster:GetIntellect()
		local fAgility = hCaster:GetAgility()
		local hGameMode = GameRules:GetGameModeEntity()
		local fRatio = self:GetAbility():GetSpecialValueFor("aura_stat_bonus")/100
		self.iCount = self.iCount or 0
		self.iCount = self.iCount+1
		if self.iCount > PAPYRUS_SCARAB_MAGIC_RESIST then
			self.bAuraActivated = true
			self.iCount = PAPYRUS_SCARAB_DAMAGE
		end
		local iNumModifiers = 0
		for i,v in pairs(hCaster:FindAllModifiers()) do
			if v:GetName() == self:GetName() then iNumModifiers = iNumModifiers+1 end
		end
		fRatio = fRatio*iNumModifiers
		if self.iCount == PAPYRUS_SCARAB_DAMAGE then
			self:SetStackCount(PAPYRUS_SCARAB_DAMAGE+16*math.ceil(fRatio*hCaster:GetBonusDamageFromPrimaryStat()))
		elseif self.iCount == PAPYRUS_SCARAB_ARMOR then
			self:SetStackCount(PAPYRUS_SCARAB_ARMOR+16*math.ceil(fRatio*hGameMode:GetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ARMOR, hCaster)*fAgility*10))
		elseif self.iCount == PAPYRUS_SCARAB_ATTACK_SPPED then
			self:SetStackCount(PAPYRUS_SCARAB_ATTACK_SPPED+16*math.ceil(fRatio*hGameMode:GetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ATTACK_SPEED, hCaster)*fAgility))
		elseif self.iCount == PAPYRUS_SCARAB_MOVEMENT_SPEED then
			self:SetStackCount(PAPYRUS_SCARAB_MOVEMENT_SPEED+16*math.ceil(fRatio*hGameMode:GetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_MOVE_SPEED_PERCENT, hCaster)*fAgility*1000))
		elseif self.iCount == PAPYRUS_SCARAB_HEALTH then
			self:SetStackCount(PAPYRUS_SCARAB_HEALTH+16*math.ceil(fRatio*hGameMode:GetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP, hCaster)*fStrength))
		elseif self.iCount == PAPYRUS_SCARAB_HEALTH_REGEN then
			self:SetStackCount(PAPYRUS_SCARAB_HEALTH_REGEN+16*math.ceil(fRatio*hGameMode:GetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP_REGEN, hCaster)*fStrength*10))
		elseif self.iCount == PAPYRUS_SCARAB_MAGIC_RESIST then
			self:SetStackCount(PAPYRUS_SCARAB_MAGIC_RESIST+16*math.ceil(fRatio*hGameMode:GetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_MAGIC_RESISTANCE_PERCENT, hCaster)*fStrength*1000))
		elseif self.iCount == PAPYRUS_SCARAB_MANA_REGEN then
			self:SetStackCount(PAPYRUS_SCARAB_MANA_REGEN+16*math.ceil(fRatio*hGameMode:GetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA_REGEN, hCaster)*fIntellect*10))
		elseif self.iCount == PAPYRUS_SCARAB_SPELL_AMP then
			self:SetStackCount(PAPYRUS_SCARAB_SPELL_AMP+16*math.ceil(fRatio*hGameMode:GetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_SPELL_AMP_PERCENT, hCaster)*fIntellect*10))
		elseif self.iCount == PAPYRUS_SCARAB_MANA then
			self:SetStackCount(PAPYRUS_SCARAB_MANA+16*math.ceil(fRatio*hGameMode:GetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA, hCaster)*fIntellect))
		end
	end
	if self:GetStackCount()%16 == PAPYRUS_SCARAB_DAMAGE then
		self.iDamage = math.floor(self:GetStackCount()/16)
	elseif  self:GetStackCount()%16 == PAPYRUS_SCARAB_ARMOR then
		self.fArmor = math.floor(self:GetStackCount()/16)/10
	elseif  self:GetStackCount()%16 == PAPYRUS_SCARAB_ATTACK_SPPED then
		self.iAttackSpeed = math.floor(self:GetStackCount()/16)
	elseif  self:GetStackCount()%16 == PAPYRUS_SCARAB_MOVEMENT_SPEED then
		self.fMoveSpeed = math.floor(self:GetStackCount()/16)/10
	elseif  self:GetStackCount()%16 == PAPYRUS_SCARAB_HEALTH then
		self.iHealth = math.floor(self:GetStackCount()/16)
	elseif  self:GetStackCount()%16 == PAPYRUS_SCARAB_HEALTH_REGEN then
		self.fHealthRegen = math.floor(self:GetStackCount()/16)/10
	elseif  self:GetStackCount()%16 == PAPYRUS_SCARAB_MAGIC_RESIST then
		self.fMagicalResistance = math.floor(self:GetStackCount()/16)/10
	elseif  self:GetStackCount()%16 == PAPYRUS_SCARAB_MANA_REGEN then
		self.fManaRegen = math.floor(self:GetStackCount()/16)/10
	elseif  self:GetStackCount()%16 == PAPYRUS_SCARAB_SPELL_AMP then
		self.fSpellAmp = math.floor(self:GetStackCount()/16)/10
	elseif  self:GetStackCount()%16 == PAPYRUS_SCARAB_MANA then
		self.iMana = math.floor(self:GetStackCount()/16)
	end
end


modifier_item_fun_papyrus_scarab_aura_3 = class({})
function modifier_item_fun_papyrus_scarab_aura_3:IsPurgable() return false end

function modifier_item_fun_papyrus_scarab_aura_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
--		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

function modifier_item_fun_papyrus_scarab_aura_3:GetModifierPreAttack_BonusDamage()
	return self:GetAbility().hModifierAuraEmitter3.iDamage
end

function modifier_item_fun_papyrus_scarab_aura_3:GetModifierPhysicalArmorBonus()
	return self:GetAbility().hModifierAuraEmitter3.fArmor
end

function modifier_item_fun_papyrus_scarab_aura_3:GetModifierAttackSpeedBonus_Constant()	
	return self:GetAbility().hModifierAuraEmitter3.iAttackSpeed
end

function modifier_item_fun_papyrus_scarab_aura_3:GetModifierMoveSpeedBonus_Percentage()	
	return self:GetAbility().hModifierAuraEmitter3.fMoveSpeed
end

function modifier_item_fun_papyrus_scarab_aura_3:OnTooltip()
	if self:GetParent():GetMaxHealth() < 100 then 
		return 0 
	else
		return self:GetAbility().hModifierAuraEmitter3.iHealth
	end
end


function modifier_item_fun_papyrus_scarab_aura_3:GetModifierConstantHealthRegen()	
	return self:GetAbility().hModifierAuraEmitter3.fHealthRegen
end

function modifier_item_fun_papyrus_scarab_aura_3:GetModifierMagicalResistanceBonus()	
	return self:GetAbility().hModifierAuraEmitter3.fMagicalResistance
end

function modifier_item_fun_papyrus_scarab_aura_3:GetModifierManaBonus()	
	return self:GetAbility().hModifierAuraEmitter3.iMana
end

function modifier_item_fun_papyrus_scarab_aura_3:GetModifierConstantManaRegen()	
	return self:GetAbility().hModifierAuraEmitter3.fManaRegen
end

function modifier_item_fun_papyrus_scarab_aura_3:GetModifierSpellAmplify_Percentage()	
	return self:GetAbility().hModifierAuraEmitter3.fSpellAmp
end

function modifier_item_fun_papyrus_scarab_aura_3:OnCreated()
	self:StartIntervalThink(0.04)
end

function modifier_item_fun_papyrus_scarab_aura_3:OnIntervalThink()
	if IsClient() then return false end
	local hParent = self:GetParent()
	if hParent:GetMaxHealth() < 100 then return end
	self.iParentOriginalHealth = self.iParentOriginalHealth or hParent:GetMaxHealth()
	if hParent:GetMaxHealth()-self.iParentOriginalHealth ~= self:GetAbility().hModifierAuraEmitter3.iHealth then
		local fRatio = hParent:GetHealth()/hParent:GetMaxHealth()
		hParent:SetMaxHealth(self.iParentOriginalHealth+self:GetAbility().hModifierAuraEmitter3.iHealth)
		hParent:SetHealth(fRatio*(self.iParentOriginalHealth+self:GetAbility().hModifierAuraEmitter3.iHealth))
	end
end

function modifier_item_fun_papyrus_scarab_aura_3:OnDestroy()
	if IsClient() then return false end
	local hParent = self:GetParent()
	if hParent:GetMaxHealth() < 100 then return end
	local fRatio = hParent:GetHealth()/hParent:GetMaxHealth()
	hParent:SetMaxHealth(self.iParentOriginalHealth)
	hParent:SetHealth(self.iParentOriginalHealth*fRatio)
end

modifier_item_fun_bs = class(tClassHiddenNotPurgable)
function modifier_item_fun_bs:DeclareFunctions()
	return {MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
			MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE_SOURCE,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
			MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT,
			MODIFIER_EVENT_ON_DEATH}
end
function modifier_item_fun_bs:GetModifierConstantManaRegen() local hAbility = self:GetAbility() return hAbility:GetSpecialValueFor('mana_regen')+self:GetStackCount()*hAbility:GetSpecialValueFor('regen_per_charge') end
function modifier_item_fun_bs:GetModifierConstantHealthRegen() return self:GetStackCount()*self:GetAbility():GetSpecialValueFor('regen_per_charge') end
function modifier_item_fun_bs:GetModifierHPRegenAmplify_PercentageSource() return self:GetAbility():GetSpecialValueFor('heal_increase') end
function modifier_item_fun_bs:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor('bonus_all') end
function modifier_item_fun_bs:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor('bonus_all') end
function modifier_item_fun_bs:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor('bonus_all')+self:GetAbility():GetSpecialValueFor('bonus_int') end

function modifier_item_fun_bs:GetModifierMPRegenAmplify_Percentage()
	return 100
end
function modifier_item_fun_bs:OnDeath(keys)
	if keys.unit ~= self:GetParent() or keys.reincarnate or keys.unit:IsIllusion() then return end
	local hAbility = self:GetAbility()
	hAbility:SetCurrentCharges(hAbility:GetCurrentCharges()-hAbility:GetSpecialValueFor('death_charge_loss'))
	if hAbility:GetCurrentCharges() <= 0 then
		hAbility:SetCurrentCharges(0)
	end
	self:SetStackCount(self:GetAbility():GetCurrentCharges())
end

function modifier_item_fun_bs:OnCreated()
	self:GetAbility().hModifier = self
	self:SetStackCount(self:GetAbility():GetCurrentCharges())
	if IsServer() then
		self.hHLModifier = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_holy_locket", nil)
	end
end

function modifier_item_fun_bs:OnDestroy()
	if IsServer() then
		self.hHLModifier:Destroy()
	end
end


function modifier_item_fun_bs:OnTakeDamageKillCredit(keys)
	if keys.attacker == self:GetParent() and keys.attacker:GetTeam() ~= keys.target:GetTeam() and keys.target:IsRealHero() and keys.damage > keys.target:GetHealth() and self:GetAbility() == keys.attacker:FindItemInInventory('item_fun_bs') and keys.target:IsAlive() then
		local hAbility = self:GetAbility()
		hAbility:SetCurrentCharges(hAbility:GetCurrentCharges()+hAbility:GetSpecialValueFor('kill_charge'))
		self:SetStackCount(hAbility:GetCurrentCharges())
	end
end


modifier_item_tree_planting_suite = class(tClassHiddenNotPurgableNotRemoveOnDeath)
function modifier_item_tree_planting_suite:OnCreated()
	self:StartIntervalThink(FrameTime())
end
function modifier_item_tree_planting_suite:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	for i = 0, 15 do
		local hItem = hParent:GetItemInSlot(i)
		if hItem and hItem:GetName() == "item_branches" then
			hItem:RemoveSelf()
			self:GetAbility():SetCurrentCharges(self:GetAbility():GetCurrentCharges()+1)
		end
	end
end

