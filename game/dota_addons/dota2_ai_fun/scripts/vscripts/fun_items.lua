DOTA2_AI_FUN_SPEW = IsInToolsMode()
local function CheckStringInTable(s, t)
	for i = 1, #t do
		if s == t[i] then return true end
	end
	return false
end

local function ResetAbilityCharge(ability, caster, extraCharge, index)
	--For if one of these abilities no longer have charges in the future
	
	extraCharge = extraCharge or 0
	
	local abilityName = ability:GetName()
	local buff
	if abilityName == 'bloodseeker_rupture' then		
		buff:SetStackCount(2+extraCharge)	
	elseif abilityName == 'sniper_shrapnel' then
		buff = caster:FindModifierByName("modifier_sniper_shrapnel_charge_counter")
		if caster:GetAbilityByIndex(11):GetLevel() > 0 then
			buff:SetStackCount(7+extraCharge)
		else
			buff:SetStackCount(3+extraCharge)
		end
	elseif abilityName == 'gyrocopter_homing_missile' then
		buff = caster:FindModifierByName(ability:GetIntrinsicModifierName())
		buff:SetStackCount(3+extraCharge)
	elseif abilityName == 'shadow_demon_demonic_purge' then
		buff = caster:FindModifierByName(ability:GetIntrinsicModifierName())
		buff:SetStackCount(3+extraCharge)
	elseif abilityName == 'ember_spirit_fire_remnant' then
		buff = caster:FindModifierByName(ability:GetIntrinsicModifierName())
		buff:SetStackCount(3+extraCharge)
	elseif abilityName == 'earth_spirit_stone_caller' then
		buff = caster:FindModifierByName(ability:GetIntrinsicModifierName())
		buff:SetStackCount(6+extraCharge)
	elseif abilityName == 'ancient_apparition_cold_feet' then
		buff = caster:FindModifierByName(ability:GetIntrinsicModifierName())
		buff:SetStackCount(4+extraCharge)
	elseif abilityName == 'obsidian_destroyer_astral_imprisonment' then
		buff = caster:FindModifierByName(ability:GetIntrinsicModifierName())
		buff:SetStackCount(2+extraCharge)		
	elseif abilitiesName == 'death_prophet_spirit_siphon' then
		buff = caster:FindModifierByName('modifier_death_prophet_spirit_siphon_charge_counter')
		buff:SetStackCount(caster:GetAbilityByIndex(index):GetLevel()+extraCharge)
	elseif abilitiesName == 'broodmother_spin_web' then
		buff = caster:FindModifierByName('modifier_broodmother_spin_web_charge_counter')
		buff:SetStackCount(caster:GetAbilityByIndex(index):GetLevel()+extraCharge)
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
	"silencer_global_silence"}
		
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

function EconomizerResetCooldown(keys)	
	print(type(dofile), type(assert));
	local caster = keys.caster
	local abilityCount = keys.caster:GetAbilityCount()		
	local abilityName = keys.event_ability:GetAbilityName()	
	local allModifiers = caster:FindAllModifiers()	
	local fileHandle
	-- reset ability cooldowns
	for i = 0, abilityCount-1 do
		local indexedAbility = caster:GetAbilityByIndex(i)
		if indexedAbility then
			local indexedAbilityName = indexedAbility:GetAbilityName()
			if DOTA2_AI_FUN_SPEW then
				local sFileName = "D:/Desktop/dump_abilities_"..caster:GetName()..".log"
				
				fileHandle = fileHandle or io.open(sFileName, "w")
				if fileHandle then
					fileHandle:write("Ability Name: "..indexedAbilityName, '\n')
					PrintTable(indexedAbility:GetAbilityKeyValues(), 1, fileHandle)
				else 
					print("Ability Name: "..indexedAbilityName)
					PrintTable(indexedAbility:GetAbilityKeyValues(), 1)
				end
			end
			local indexedAbilityLevel = indexedAbility:GetLevel()
			if indexedAbilityLevel > 0 and CheckStringInTable(indexedAbilityName, chargedAbilities) then
				ResetAbilityCharge(indexedAbility, caster, 0, i)
			end
			if not CheckStringInTable(indexedAbilityName, bannedItems) and not indexedAbility:IsCooldownReady() then 
				indexedAbility:EndCooldown()
			end
		end
	end	
	
	-- reset item cooldowns
	for i = 0, 8 do
		local item = caster:GetItemInSlot(i)
		if item then
			local name = item:GetAbilityName()
			if not CheckStringInTable(name, bannedItems) and not item:IsCooldownReady() then 
				item:EndCooldown()
			end
		end
	end
	
	-- if triggered ability is charged one, give an extra charge 
	
	if CheckStringInTable(abilityName, chargedAbilities) then
		ResetAbilityCharge(keys.event_ability, caster, 1)
	end
	
	-- add a short duration modifier so the triggered ability won't go into cooldown
	
	if not CheckStringInTable(abilityName, bannedItems) then		
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_fun_economizer_cdr_short", {duration = 0.01})
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
	local sound_name = "Hero_ObsidianDestroyer.AstralImprisonment"
	local target = keys.target
	StopSoundEvent(sound_name, target)
end

function AngelicAllianceRestoreManaRefresh(keys)
	local caster = keys.caster
	local abilityCount = keys.caster:GetAbilityCount()

	caster:SetMana(caster:GetMaxMana())

	for i = 0, abilityCount-1 do
		local indexedAbility = caster:GetAbilityByIndex(i)
		if indexedAbility then
			local indexedAbilityName = indexedAbility:GetAbilityName()
			local indexedAbilityLevel = indexedAbility:GetLevel()
			if indexedAbilityLevel > 0 and CheckStringInTable(indexedAbilityName, chargedAbilities) then 
				ResetAbilityCharge(indexedAbility, caster, 0, i)
			end
			if not indexedAbility:IsCooldownReady() then 
				indexedAbility:EndCooldown()
			end
		end
	end
	
	-- reset item cooldowns
	for i = 0, 8 do
		local item = caster:GetItemInSlot(i)
		if item and not item:IsCooldownReady() then 
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

function BloodSwordLifestealApply(keys)
	local attacker = keys.attacker
	local target = keys.target
	local ability = keys.ability
	if not target:IsBuilding() then
		ability:ApplyDataDrivenModifier(attacker, attacker, "modifier_item_fun_blood_sword_lifesteal", {duration = 0.03})
	end
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

function MagicHammerManaBurn(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local mana_burn = ability:GetSpecialValueFor("mana_burn")
	local mana_burn_damage = ability:GetSpecialValueFor("mana_burn_damage")
	local currentMana = target:GetMana()
	damageTable = {attacker = caster, victim = target, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability}
	if currentMana > mana_burn then
		target:SetMana(currentMana-mana_burn)
		damageTable.damage = mana_burn*mana_burn_damage
		ApplyDamage(damageTable)
	else
		target:SetMana(0)
		damageTable.damage = currentMana*mana_burn_damage
		ApplyDamage(damageTable)
	end	
end

function RagnarokCreated(keys)	
	if not keys.caster:IsRangedAttacker() then
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_item_fun_ragnarok_cleave", {duration = -1})
	end
end

function RagnarokDestroy(keys)
	if not keys.caster:IsRangedAttacker() then
		keys.caster:RemoveModifierByName("modifier_item_fun_ragnarok_cleave")
	end
end

function RagnarokThinkGetCleave(keys)	
	if not keys.caster:IsRangedAttacker() and not keys.caster:HasModifier("modifier_item_fun_ragnarok_cleave") then
		for i=0, 5, 1 do
			local current_item = keys.caster:GetItemInSlot(i)
			if current_item ~= nil then
				if current_item:GetName() == "item_fun_ragnarok" then
					keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_item_fun_ragnarok_cleave", {duration = -1})
				end
			end
		end
	end
end

function RagnarokThinkRemoveCleave(keys)
end