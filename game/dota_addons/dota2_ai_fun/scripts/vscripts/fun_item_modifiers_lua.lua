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
function modifier_item_fun_sprint_shoes_lua:OnCreated()
	self:GetAbility().hModifier = self
	self:StartIntervalThink(FrameTime())
end
function modifier_item_fun_sprint_shoes_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end
function modifier_item_fun_sprint_shoes_lua:OnTakeDamage(keys)
	if keys.unit ~= self:GetParent() or keys.attacker:GetPlayerOwnerID() < 0 or keys.attacker:GetPlayerOwnerID() == keys.unit:GetPlayerOwnerID() then return end
	self.iLastHitTime = GameRules:GetGameTime()
	self:SetStackCount(1)
end
function modifier_item_fun_sprint_shoes_lua:OnIntervalThink()
	if IsClient() then return end
	if self.iLastHitTime and GameRules:GetGameTime()-self.iLastHitTime > self:GetAbility():GetSpecialValueFor("broken_time") then 
		self:SetStackCount(0) 
	end
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
function modifier_item_fun_escutcheon_lua:GetModifierStatusResistance() return 80 end
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
					ApplyDamage({damage = hAbility:GetSpecialValueFor("cleave_damage")*keys.original_damage/100, damage_type = DAMAGE_TYPE_PHYSICAL, attacker = keys.attacker, victim = v, ability = hAbility, damage_flag = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL})
				end
			end
		end
		return 
	end
	DoCleaveAttack(keys.attacker, keys.target, hAbility, hAbility:GetSpecialValueFor("cleave_damage")*keys.original_damage/100, fCleaveStartRadius, fCleaveEndRadius, fCleaveDistance, "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf")	
end

modifier_magic_hammer_mana_break = class({})

function modifier_magic_hammer_mana_break:IsHidden() return true end

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

function modifier_magic_hammer_mana_break:AllowIllusionDuplicate() return true end

modifier_heros_bow_active = class({})
function modifier_heros_bow_active:IsPurgable() return false end
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
function modifier_item_fun_heros_bow_debuff:IsPurgable() return false end
function modifier_item_fun_heros_bow_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, MODIFIER_PROPERTY_PROVIDES_FOW_POSITION} end
function modifier_item_fun_heros_bow_debuff:GetModifierIncomingDamage_Percentage() return self:GetAbility():GetSpecialValueFor("damage_amp") end
function modifier_item_fun_heros_bow_debuff:GetModifierProvidesFOWVision() return 1 end
function modifier_item_fun_heros_bow_debuff:CheckState() return {[MODIFIER_STATE_MUTED] = true} end
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
end

local tCleaveAbilityList = {
	felguard_overflow = true,
	item_bfury = true,
	item_fun_ragnarok_2 = true,
	kunkka_tidebringer = true,
	magnataur_empower = true
}

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
	local sName = keys.inflictor:GetName()
	if string.match(sName, "cleave") or tCleaveAbilityList[sName] then return end
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

modifier_economizer_ultimate = class({})

function modifier_economizer_ultimate:DeclareFunctions() return {MODIFIER_PROPERTY_IS_SCEPTER} end
function modifier_economizer_ultimate:GetModifierScepter() return 1 end
function modifier_economizer_ultimate:IsHidden() return true end
function modifier_economizer_ultimate:IsPurgable() return false end
function modifier_economizer_ultimate:RemoveOnDeath() return false end

modifier_angelic_alliance_death_drop = class({})
function modifier_angelic_alliance_death_drop:IsHidden() return true end
function modifier_angelic_alliance_death_drop:IsPurgable() return false end
function modifier_angelic_alliance_death_drop:RemoveOnDeath() return false end
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

modifier_item_fun_terra_blade = class({})
function modifier_item_fun_terra_blade:IsHidden() return true end
function modifier_item_fun_terra_blade:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_fun_terra_blade:CheckState() return {[MODIFIER_STATE_CANNOT_MISS] = true} end
function modifier_item_fun_terra_blade:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_item_fun_terra_blade:OnAttackLanded(keys)
	if keys.attacker ~= self:GetParent() or keys.attacker:GetTeam() == keys.target:GetTeam() or keys.target:IsBuilding() or keys.attacker:IsIllusion() then return end
	keys.ability = self:GetAbility()
	keys.target:EmitSound("DOTA_Item.Maim")
	keys.target:AddNewModifier(keys.attacker, keys.ability, "modifier_item_fun_terra_blade_ultra_maim", {Duration = keys.ability:GetSpecialValueFor("maim_duration")*CalculateStatusResist(keys.target)})

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
	self:SetStackCount(1)
	self:StartIntervalThink(0.04)
end

function modifier_item_fun_terra_blade:OnIntervalThink()
	if IsClient() then return end
	self:SetStackCount(#self:GetParent():FindAllModifiersByName(self:GetName()))
end

function modifier_item_fun_terra_blade:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor("bonus_agility") end
function modifier_item_fun_terra_blade:GetModifierEvasion_Constant() return self:GetAbility():GetSpecialValueFor("evasion") end
function modifier_item_fun_terra_blade:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage") end
function modifier_item_fun_terra_blade:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") end
function modifier_item_fun_terra_blade:GetModifierBaseAttackTimeConstant() return self:GetAbility():GetSpecialValueFor("bat") end
function modifier_item_fun_terra_blade:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("bonus_strength") end
function modifier_item_fun_terra_blade:GetModifierHealthBonus() return self:GetAbility():GetSpecialValueFor("bonus_health") end
function modifier_item_fun_terra_blade:GetModifierConstantManaRegen() return self:GetAbility():GetSpecialValueFor("manaregen") end
function modifier_item_fun_terra_blade:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("movement_speed_percent_bonus")/self:GetStackCount() end
function modifier_item_fun_terra_blade:GetModifierBaseDamageOutgoing_Percentage() return self:GetAbility():GetSpecialValueFor("bonus_damage_percentage")/self:GetStackCount() end
function modifier_item_fun_terra_blade:GetModifierHealthRegenPercentage() return self:GetAbility():GetSpecialValueFor("health_regen")/self:GetStackCount() end

modifier_item_fun_terra_blade_ultra_maim = class({})
function modifier_item_fun_terra_blade_ultra_maim:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end
function modifier_item_fun_terra_blade_ultra_maim:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("maim_movement_percentage") end
function modifier_item_fun_terra_blade_ultra_maim:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("maim_attack") end
function modifier_item_fun_terra_blade_ultra_maim:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_fun_terra_blade_ultra_maim:GetEffectName() return "particles/items2_fx/sange_maim.vpcf" end



