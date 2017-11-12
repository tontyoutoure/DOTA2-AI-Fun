DOTA2_AI_FUN_SPEW = false
LinkLuaModifier("modifier_heros_bow_always_allow_attack", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angelic_alliance_spell_lifesteal", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_economizer_spell_lifesteal", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heros_bow_minus_armor", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_economizer_ultimate", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ragnarok_cleave", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angelic_alliance_maximum_speed", "fun_item_modifiers_lua.lua", LUA_MODIFIER_MOTION_NONE)
local function CheckStringInTable(s, t)
	for i = 1, #t do
		if s == t[i] then return true end
	end
	return false
end

local function ResetAbilityCharge(ability)
	--For if one of these abilities no longer have charges in the future
		
	local abilityName = ability:GetName()
	local caster = ability:GetCaster()
	local buff
	if abilityName == 'bloodseeker_rupture' then		
		buff:SetStackCount(2)	
	elseif abilityName == 'sniper_shrapnel' then
		buff = caster:FindModifierByName("modifier_sniper_shrapnel_charge_counter")
		if caster:FindAbilityByName("special_bonus_unique_sniper_2") and caster:FindAbilityByName("special_bonus_unique_sniper_2"):GetLevel() > 0 then
			buff:SetStackCount(7)
		else
			buff:SetStackCount(3)
		end
	elseif abilityName == 'gyrocopter_homing_missile' then
		buff = caster:FindModifierByName(ability:GetIntrinsicModifierName())
		if caster:FindAbilityByName("special_bonus_unique_gyrocopter_1") and caster:FindAbilityByName("special_bonus_unique_gyrocopter_1"):GetLevel() > 0 then
			buff:SetStackCount(3)
		end
	elseif abilityName == 'shadow_demon_demonic_purge' then
		buff = caster:FindModifierByName(ability:GetIntrinsicModifierName())
		if caster:HasScepter() then
			buff:SetStackCount(3)
		end
	elseif abilityName == 'ember_spirit_fire_remnant' then
		buff = caster:FindModifierByName(ability:GetIntrinsicModifierName())
		buff:SetStackCount(3)
	elseif abilityName == 'earth_spirit_stone_caller' then
		buff = caster:FindModifierByName(ability:GetIntrinsicModifierName())
		buff:SetStackCount(6)
	elseif abilityName == 'ancient_apparition_cold_feet' then
		buff = caster:FindModifierByName(ability:GetIntrinsicModifierName())		
		if caster:FindAbilityByName("special_bonus_unique_ancient_apparition_1") and caster:FindAbilityByName("special_bonus_unique_ancient_apparition_1"):GetLevel() > 0 then
			buff:SetStackCount(4)
		end
	elseif abilityName == 'obsidian_destroyer_astral_imprisonment' then
		buff = caster:FindModifierByName(ability:GetIntrinsicModifierName())
		if caster:HasScepter() then
			buff:SetStackCount(2)	
		end
	elseif abilitiesName == 'death_prophet_spirit_siphon' then
		buff = caster:FindModifierByName('modifier_death_prophet_spirit_siphon_charge_counter')
		buff:SetStackCount(ability:GetLevel())
	elseif abilitiesName == 'broodmother_spin_web' then
		buff = caster:FindModifierByName('modifier_broodmother_spin_web_charge_counter')
		buff:SetStackCount(ability:GetLevel())
	end
	
end

local bannedItems = {
	"item_black_king_bar", 
	"item_arcane_boots", 
	"item_hand_of_midas", 
	"item_helm_of_the_dominator", 
	"item_sphere", 
	"item_necronomicon", 
	"item_necronomicon_2", 
	"item_necronomicon_3", 
	"item_pipe", 
	"item_refresher",
	"chen_hand_of_god",
	"invoker_sun_strike",
	"spectre_haunt",
	"furion_wrath_of_nature",
	"rattletrap_rocket_flare",
	"zuus_thundergods_wrath",
	"zuus_cloud",
	"silencer_global_silence",
	"pet_summoner_critters",
	"ramza_arithmetician_arithmeticks_CT",
	"ramza_arithmetician_arithmeticks_multiple_of_5",
	"ramza_arithmetician_arithmeticks_multiple_of_4",
	"ramza_arithmetician_arithmeticks_multiple_of_3",
	"ramza_arithmetician_arithmeticks_level",
	"ramza_arithmetician_arithmeticks_exp",
	"ramza_geomancer_geomancy_magma_surge"
	}
		
local chargedAbilities = {
	"bloodseeker_rupture",
	"sniper_shrapnel",
	"gyrocopter_homing_missile",
	"shadow_demon_demonic_purge",
	"ember_spirit_fire_remnant",
	"earth_spirit_stone_caller",
	"ancient_apparition_cold_feet",
	"obsidian_destroyer_astral_imprisonment",
	"broodmother_spin_web",
	"death_prophet_spirit_siphon"}

function ResetCooldown(keys)	
	local caster = keys.caster
	
	if not caster:HasModifier("modifier_imbalanced_economizer") then return end
	local bIsAA = keys.ability:GetName() == "item_fun_angelic_alliance"
	local abilityCount = keys.caster:GetAbilityCount()		
	local abilityName = keys.event_ability:GetAbilityName()	
	local allModifiers = caster:FindAllModifiers()	
	local fileHandle
	-- reset ability cooldowns
	for i = 0, abilityCount-1 do
		local indexedAbility = caster:GetAbilityByIndex(i)
		if indexedAbility then
			local indexedAbilityName = indexedAbility:GetAbilityName()
			local indexedAbilityLevel = indexedAbility:GetLevel()
			if indexedAbilityLevel > 0 and CheckStringInTable(indexedAbilityName, chargedAbilities) then
				ResetAbilityCharge(indexedAbility)
			end
			if (not CheckStringInTable(indexedAbilityName, bannedItems) or bIsAA) and not indexedAbility:IsCooldownReady() then 
				
				indexedAbility:EndCooldown()
			end
		end
	end	
	
	-- reset item cooldowns
	for i = 0, 8 do
		local item = caster:GetItemInSlot(i)
		if item then
			local name = item:GetAbilityName()
			if (not CheckStringInTable(indexedAbilityName, bannedItems) or bIsAA) and not item:IsCooldownReady() then 
				
				item:EndCooldown()
			end
		end
	end
	
	-- if triggered ability is charged one, give an extra charge 
	
	if CheckStringInTable(abilityName, chargedAbilities) then
		ResetAbilityCharge(keys.event_ability)
	end
	
	-- add a short duration modifier so the triggered ability won't go into cooldown
	
	if bIsAA then
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_fun_angelic_alliance_cdr_short", {duration = 0.01})
	elseif not CheckStringInTable(abilityName, bannedItems) then
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_" .. keys.ability:GetName() .. "_cdr_short", {duration = 0.01})
	
	end
	if fileHandle then fileHandle:close() end
end

local isEscutcheonRunning = false
function EscutcheonReverseDamageReincarnate(keys)
	if isEscutcheonRunning then 
		return
	end
	isEscutcheonRunning = true


	local caster = keys.caster
	local damage = keys.damage
	local ability = keys.ability
	local reverseChance = ability:GetSpecialValueFor("damage_reverse")
	local reincarnate_time = ability:GetSpecialValueFor("reincarnate_time")
	local respawnPosition = caster:GetAbsOrigin()
	local casterGold = caster:GetGold()
	local cooldown = ability:GetCooldown(0)

	--caster:SetHealth(100)
	if math.random() < reverseChance/100 then
		caster:SetHealth(caster:GetHealth() + 2*damage)
	end
	if ability:IsCooldownReady() and caster:GetHealth() == 0 and caster:GetTimeUntilRespawn() == 0 then
		local respawnPosition = caster:GetAbsOrigin()
		local casterGold = caster:GetGold()

		ability:StartCooldown(cooldown)
		caster:SetHealth(1)
		caster:Kill(caster, nil)
		caster:SetGold(casterGold, false)
		caster:SetTimeUntilRespawn(reincarnate_time)
		caster:SetRespawnPosition(respawnPosition) 
		
		local model = "models/props_gameplay/tombstoneb01.vmdl"
		local grave = Entities:CreateByClassname("prop_dynamic")
    	grave:SetModel(model)
    	grave:SetAbsOrigin(respawnPosition)
		
		Timers:CreateTimer(reincarnate_time, function()
			grave:RemoveSelf()
		end)
		
	end

	isEscutcheonRunning = false
end

function EscutcheonReincarnateFinish(keys)
	caster = keys.caster
	caster:SetBuybackEnabled(true)
end

function OrbOfOmnipotenceStopSound(keys)
	StopSoundEvent("Hero_ObsidianDestroyer.AstralImprisonment", keys.target)
end

function EAARestoreManaRefresh(keys)
	local caster = keys.caster
	local abilityCount = keys.caster:GetAbilityCount()

	local bIsAA = keys.ability:GetName() == "item_fun_angelic_alliance"
	
	if bIsAA then 
		caster:AddNewModifier(caster, keys.ability, "modifier_angelic_alliance_maximum_speed", {Duration = 0.15}) 
	end
	
	if not caster:HasModifier("modifier_imbalanced_economizer") then return end
	
	for i = 0, abilityCount-1 do
		local indexedAbility = caster:GetAbilityByIndex(i)
		if indexedAbility and (bIsAA or not CheckStringInTable(indexedAbility, bannedItems)) then
			local indexedAbilityName = indexedAbility:GetAbilityName()
			local indexedAbilityLevel = indexedAbility:GetLevel()
			if indexedAbilityLevel > 0 and CheckStringInTable(indexedAbilityName, chargedAbilities) then 
				ResetAbilityCharge(indexedAbility)
			end
			if not indexedAbility:IsCooldownReady() then 
				indexedAbility:EndCooldown()
			end
		end
	end
	
	-- reset item cooldowns
	for i = 0, 8 do
		local item = caster:GetItemInSlot(i)
		if item and (bIsAA or not CheckStringInTable(item, bannedItems)) and not item:IsCooldownReady() then 
			item:EndCooldown()
		end
	end
end

function AngelicAllianceAngelDown(keys)
	ProjectileManager:ProjectileDodge(keys.caster)
	local target_point = keys.target_points[1]

	keys.caster:SetAbsOrigin(target_point)
	FindClearSpaceForUnit(keys.caster, target_point, false)
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_item_fun_angelic_alliance_out", {duration = 0.07})

end

function AASpellLifestealApply(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_angelic_alliance_spell_lifesteal", {Duration = 0.15})	
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_economizer_ultimate", {Duration = 0.15})
end

function EconomizerSpellLifestealApply(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_economizer_spell_lifesteal", {Duration = 0.15})
end

function HerosBowOnHit(keys)	
	if keys.target:TriggerSpellAbsorb( keys.ability ) then return end
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_item_fun_heros_bow_debuff", {Duration = keys.ability:GetSpecialValueFor("duration")})
	keys.target:EmitSound("Hero_FacelessVoid.TimeLockImpact")
	damageTable = {
		victim = keys.target,
		attacker = keys.caster,
		damage = keys.ability:GetSpecialValueFor("light_arrow_damage_mult")*keys.caster:GetAttackDamage(),
		damage_type = DAMAGE_TYPE_PURE,
		ability = keys.ability
	}
	ApplyDamage(damageTable)
	if keys.caster:IsRangedAttacker() then keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_heros_bow_always_allow_attack", {Duration = keys.ability:GetSpecialValueFor("duration")}) end
end

function DarksideDamage(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("darkside_aoe")
	local damage = ability:GetSpecialValueFor("darkside_damage")*0.01*caster:GetMaxHealth()
	local selfDamage = ability:GetSpecialValueFor("darkside_life_cost")*0.01*caster:GetMaxHealth()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	
	local damageTable = {attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability}
	for _, unit in pairs(enemies) do
		damageTable.victim = unit
		ApplyDamage(damageTable)
	end
	damageTable.damage = selfDamage
	damageTable.victim = caster
	ApplyDamage(damageTable)
end
--[[
function MagicHammerManaBreak(keys)
	local attacker = keys.attacker
	local target = keys.target
	local ability = keys.ability
	local mana_break_damage = ability:GetSpecialValueFor("mana_break_damage")
	local mana_break = ability:GetSpecialValueFor("mana_break")
	local currentMana = target:GetMana()
	local damage
	damageTable = {attacker = attacker, victim = target, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability}
	if currentMana > 0 and not target:IsMagicImmune() then
		if currentMana > mana_break then
			target:SetMana(currentMana-mana_break)
			damageTable.damage = mana_break*mana_break_damage
			ApplyDamage(damageTable)
		else
			target:SetMana(0)
			damageTable.damage = currentMana*mana_break_damage
			ApplyDamage(damageTable)
		end
	end
end
]]--
function MagicHammerSpellStart(keys)
	local iParticle = ParticleManager:CreateParticle("particles/econ/events/ti7/shivas_guard_active_ti7.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster)
	ParticleManager:SetParticleControl(iParticle, 1, Vector(900,4,350))
	local tEffectedTargets = {}
	local iRootDuration = keys.ability:GetSpecialValueFor("root_duration")
	for i = 1, 26 do
		Timers:CreateTimer(0.1*i, function()
			local tTargets = FindUnitsInRadius(keys.caster:GetTeam(), keys.caster:GetAbsOrigin(), nil, 35*i, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			for k, v in ipairs(tTargets) do
				if not tEffectedTargets[v:entindex()] then
					tEffectedTargets[v:entindex()] = true
					keys.ability:ApplyDataDrivenModifier(keys.caster, v, "modifier_item_fun_magic_hammer_root", {Duration = iRootDuration})
					
					
					v:EmitSound("Hero_NyxAssassin.ManaBurn.Target")
				end
			end
			if i == 26 then tEffectedTargets = nil end
		end)
	end
end

function MagicHammerRootBegin(keys)
	keys.target.iMagicHammerRootParticle = ParticleManager:CreateParticle("particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_purge.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
	ParticleManager:SetParticleControlEnt(keys.target.iMagicHammerRootParticle, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetOrigin(), true)
end
function MagicHammerRootEnd(keys)
	if keys.target.iMagicHammerRootParticle then
		ParticleManager:DestroyParticle(keys.target.iMagicHammerRootParticle, true)
		keys.target.iMagicHammerRootParticle = nil
	end
end

function MagicHammerManaBurn(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
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
		local iParticle1 = ParticleManager:CreateParticle("particles/msg_fx/msg_mana_loss.vpcf", PATTACH_POINT_FOLLOW, keys.target)
		ParticleManager:SetParticleControl(iParticle1, 1, Vector(1, math.floor(mana_burn), 0))
		ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, 2+math.floor(math.log10(mana_burn)), 500))
		ParticleManager:SetParticleControl(iParticle1, 3, Vector(120, 120, 200))	
	else
		target:SetMana(0)
		damageTable.damage = currentMana*mana_burn_damage
		ApplyDamage(damageTable)
		local iParticle1 = ParticleManager:CreateParticle("particles/msg_fx/msg_mana_loss.vpcf", PATTACH_POINT_FOLLOW, keys.target)
		ParticleManager:SetParticleControl(iParticle1, 1, Vector(1, math.floor(currentMana), 0))
		ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, 2+math.floor(math.log10(currentMana)), 500))
		ParticleManager:SetParticleControl(iParticle1, 3, Vector(120, 120, 200))	
	end	
end

function GenjiGloveMinibash(keys)
	if not keys.target:IsBuilding() then
		keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_bashed", {Duration = keys.ability:GetSpecialValueFor("bash_stun")})
		keys.target:EmitSound("DOTA_Item.MKB.Minibash")
		ParticleManager:CreateParticle("particles/generic_gameplay/generic_minibash.vpcf", PATTACH_OVERHEAD_FOLLOW, keys.target)
		ApplyDamage({attacker = keys.caster, victim = keys.target, ability = keys.ability, damage_type = DAMAGE_TYPE_PURE, damage = keys.ability:GetSpecialValueFor("extra_damage")})
	end
end

function BloodSwordCritApply(keys)
	if not keys.target:IsBuilding() and keys.target:GetTeamNumber() ~= keys.attacker:GetTeamNumber() then
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_item_fun_blood_sword_crit", {})
	end

end

function BloodSwordLifestealApply(keys)
	local attacker = keys.attacker
	local target = keys.target
	local ability = keys.ability
	if not target:IsBuilding() then
		if attacker:HasModifier("modifier_item_fun_blood_sword_extra_attack") then
			ability:ApplyDataDrivenModifier(attacker, attacker, "modifier_item_fun_blood_sword_extra_lifesteal", {duration = 0.03})
		else
			ability:ApplyDataDrivenModifier(attacker, attacker, "modifier_item_fun_blood_sword_lifesteal", {duration = 0.03})
		end
	end
end

function BloodSwordExtraCritParticle(keys)
	keys.target:EmitSound("Hero_PhantomAssassin.CoupDeGrace.Arcana")
	local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_arcana_swoop.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetOrigin(), true )
	ParticleManager:SetParticleControl( nFXIndex, 1, keys.target:GetOrigin() )
	ParticleManager:SetParticleControlForward( nFXIndex, 1, -keys.attacker:GetForwardVector() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 10, keys.target, PATTACH_ABSORIGIN_FOLLOW, nil, keys.target:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end

function BloodSwordExtraAttack(keys)
	if not keys.attacker.IsExtraAttacking and not keys.attacker:IsRangedAttacker() then 		
		StartAnimation(keys.attacker, {duration = 0.2, activity=ACT_DOTA_ATTACK, rate=7})
		Timers:CreateTimer(0.04, function () 
			keys.attacker.IsExtraAttacking = true
			if not keys.target:IsBuilding() and keys.target:GetTeamNumber() ~= keys.attacker:GetTeamNumber() then 
				keys.ability:ApplyDataDrivenModifier(keys.attacker, keys.attacker, "modifier_item_fun_blood_sword_extra_crit", {})
			end
			keys.attacker:PerformAttack(keys.target, true, true, true, false, true, false, true) 
			Timers:CreateTimer(0.04, function () keys.attacker.IsExtraAttacking = nil end)
		end)
	end
end

function HerosbowCreated(keys)
	if keys.caster:IsRangedAttacker() then 
		keys.ability.sOriginalProjectileName = keys.caster:GetRangedProjectileName()
		keys.caster:SetRangedProjectileName('particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf')
	end
end

function HerosbowDestroy(keys)
	if keys.caster:IsRangedAttacker() then 
		keys.caster:SetRangedProjectileName(keys.ability.sOriginalProjectileName)
	end
end

function HerosBowReduceArmor(keys)
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_heros_bow_minus_armor", {Duration = keys.ability:GetSpecialValueFor("armor_reduction_duration")})
end

function Economizer2UltimateSpellLifestealApply(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_economizer_spell_lifesteal", {Duration = 0.15})
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_economizer_ultimate", {Duration = 0.15})
end

function RagnarokCleaveApply(keys)	
	if keys.ability.hModifier and not keys.ability.hModifier:IsNull() then 
		keys.ability.hModifier:Destroy()
		keys.ability.hModifier = nil
	end
	if keys.caster:IsRangedAttacker() then return end
	keys.ability.hModifier = keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ragnarok_cleave", {Duration = 3})
end

function RagnarokMaimApply(keys)
	if keys.target:IsBuilding() then return end
	keys.target:EmitSound("DOTA_Item.Maim")
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_item_fun_ragnarok_2_ultra_maim", {Duration = keys.ability:GetSpecialValueFor("maim_duration")})
end

function TerraBladeMaimApply(keys)
	if keys.target:IsBuilding() then return end
	keys.target:EmitSound("DOTA_Item.Maim")
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_item_fun_terra_blade_ultra_maim", {Duration = keys.ability:GetSpecialValueFor("maim_duration")})
end

function AngelicAllianceDrop(keys)
	for i = 0, 8 do
		if keys.caster:GetItemInSlot(i) and keys.caster:GetItemInSlot(i):GetName() == "item_fun_angelic_alliance" then
			keys.caster:DropItemAtPositionImmediate(keys.caster:GetItemInSlot(i), keys.caster:GetOrigin())
		end
	end
end

function AAChangePurchaser(keys)
	if keys.itemname == "item_fun_angelic_alliance" then
		local hPicker = EntIndexToHScript(keys.HeroEntityIndex)
		local hItem = EntIndexToHScript(keys.ItemEntityIndex)
		if not hPicker.bIsPick then
			hPicker.bIsPick = true
			hItem:RemoveSelf()
			hPicker:AddItemByName("item_fun_angelic_alliance")
			Timers:CreateTimer(0.04, function () hPicker.bIsPick = nil end)
		end
	end
end

ListenToGameEvent("dota_item_picked_up", AAChangePurchaser, nil)

function TerraBladeReleaseProjectile(keys)
	local tInfo = 
	{
		Ability = keys.ability,
		EffectName = "particles/windrunner_spell_powershot_rainmaker.vpcf",
		vSpawnOrigin = keys.caster:GetAbsOrigin(),
		fDistance = keys.ability:GetSpecialValueFor("projectile_distance"),
		fStartRadius = keys.ability:GetSpecialValueFor("projectile_start_radius"),
		fEndRadius = keys.ability:GetSpecialValueFor("projectile_end_radius"),
		Source = keys.caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = keys.caster:GetForwardVector() * keys.ability:GetSpecialValueFor("projectile_speed"),
		bProvidesVision = true,
		iVisionRadius = 800,
		iVisionTeamNumber = keys.caster:GetTeamNumber()
	}
	projectile = ProjectileManager:CreateLinearProjectile(tInfo)
end

function TerraBladeProjectileHit(keys)
	ApplyDamage({
		damage_type=DAMAGE_TYPE_PURE,
		damage = keys.caster:GetAverageTrueAttackDamage(keys.caster),
		attacker = keys.caster,
		victim = keys.target,
		ability = keys.ability
	})
end

function TerraBladeMinibash(keys)
	if not keys.target:IsBuilding() then
		keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_bashed", {Duration = keys.ability:GetSpecialValueFor("bash_stun")})
		keys.target:EmitSound("DOTA_Item.MKB.Minibash")
		ParticleManager:CreateParticle("particles/generic_gameplay/generic_minibash.vpcf", PATTACH_OVERHEAD_FOLLOW, keys.target)
	end
end