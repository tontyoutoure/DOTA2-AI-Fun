modifier_global_hero_respawn_time = class({})
function modifier_global_hero_respawn_time:OnCreated()
	self.fBuyBackExtraRespawnTime = 0
	self:StartIntervalThink(0.04)
end
function modifier_global_hero_respawn_time:OnIntervalThink()
	if IsClient() or self:GetParent():IsAlive() then return end
	self.fRespawnTime = self:GetParent():GetTimeUntilRespawn()
end
function modifier_global_hero_respawn_time:IsPurgable() return false end
function modifier_global_hero_respawn_time:IsHidden() return true end
function modifier_global_hero_respawn_time:RemoveOnDeath() return false end

function modifier_global_hero_respawn_time:DeclareFunctions()
	return {MODIFIER_EVENT_ON_DEATH, MODIFIER_EVENT_ON_RESPAWN}
end

function modifier_global_hero_respawn_time:OnRespawn(keys)
	if keys.unit ~= self:GetParent() then return end 
	self.fBuyBackExtraRespawnTime = self.fRespawnTime*0.25
--	print(self.fBuyBackExtraRespawnTime)
end

local CalculateLevelRespawnTime = function (iLevel)
	local tDOTARespawnTime = {5, 7, 9, 13, 16, 26, 28, 30, 32, 34, 36, 48,52,54,56,58,60,70,74,76, 78, 82, 86, 90, 100}
	if iLevel <= 25 then return tDOTARespawnTime[iLevel] end
	return iLevel*4
end

function modifier_global_hero_respawn_time:OnDeath(keys)
	if keys.unit ~= self:GetParent() or keys.reincarnate then return end
	local iRespawnTime = CalculateLevelRespawnTime(keys.unit:GetLevel())
	
	if keys.unit:FindModifierByName('modifier_necrolyte_reapers_scythe') then
		iRespawnTime = iRespawnTime+keys.unit:FindModifierByName('modifier_necrolyte_reapers_scythe'):GetAbility():GetSpecialValueFor("respawn_constant")
	end
	
	for i = 0, 5 do
		local hItem = keys.unit:GetItemInSlot(i)
		if hItem and hItem:GetAbilityName() == "item_bloodstone" then
			local bstimereduce =  hItem:GetCurrentCharges()* hItem:GetSpecialValueFor("respawn_time_reduction")
			iRespawnTime = iRespawnTime-bstimereduce
			break
		end
	end 
	keys.unit:SetTimeUntilRespawn(GameMode.iRespawnTimePercentage/100*iRespawnTime+self.fBuyBackExtraRespawnTime)
end

modifier_imbalanced_economizer = class({})
function modifier_imbalanced_economizer:IsPurgable() return false end
function modifier_imbalanced_economizer:IsHidden() return true end
function modifier_imbalanced_economizer:RemoveOnDeath() return false end

modifier_bot_attack_tower_pick_rune = class({})
function modifier_bot_attack_tower_pick_rune:IsPurgable() return false end
function modifier_bot_attack_tower_pick_rune:IsHidden() return true end
function modifier_bot_attack_tower_pick_rune:RemoveOnDeath() return false end

function modifier_bot_attack_tower_pick_rune:OnCreated()
	if IsClient() then return end
	self:StartIntervalThink(0.04)
end

function modifier_bot_attack_tower_pick_rune:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	local tTowers = FindUnitsInRadius(hParent:GetTeam(), hParent:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
	
	if hParent:GetHealth()/hParent:GetMaxHealth() > 0.2 and tTowers[1] and tTowers[1]:GetClassname() ~= "npc_dota_healer" and FindUnitsInRadius(tTowers[1]:GetTeam(), tTowers[1]:GetAbsOrigin(), nil, 750, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NOT_SUMMONED, FIND_CLOSEST, false)[1] and not FindUnitsInRadius(tTowers[1]:GetTeam(), tTowers[1]:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)[1] and not FindUnitsInRadius(hParent:GetTeam(), hParent:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)[1] then
		if self.hTarget == tTowers[1] then return end
		self.bSentCommand = true
		self.hTarget = tTowers[1]
		local tOrder = 
			{
				UnitIndex = hParent:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = self.hTarget:entindex()
			}
		hParent:SetForceAttackTarget(nil)
		ExecuteOrderFromTable(tOrder)
		hParent:SetForceAttackTarget(self.hTarget)
	elseif Entities:FindAllByClassnameWithin("dota_item_rune", hParent:GetOrigin(), 500)[1] then
		local hRune = Entities:FindAllByClassnameWithin("dota_item_rune", hParent:GetOrigin(), 500)[1]
		local tOrder = 
		{
			UnitIndex = hParent:entindex(),
			OrderType = DOTA_UNIT_ORDER_PICKUP_RUNE,
			TargetIndex = hRune:entindex()
		}
		ExecuteOrderFromTable(tOrder)		
	elseif self.bSentCommand then	
		hParent:SetForceAttackTarget(nil)
		self.bSentCommand = false
		self.hTarget = nil
	end
end

modifier_tower_endure = class({})

function modifier_tower_endure:IsPurgable() return false end
function modifier_tower_endure:IsDebuff() return false end
function modifier_tower_endure:GetTexture() return "tower_endure" end
function modifier_tower_endure:OnCreated()
	if IsClient() then return end
	local hParent = self:GetParent()
	local iHealth = hParent:GetMaxHealth()	
	Timers:CreateTimer(0.04, function ()
		hParent:SetMaxHealth(self:GetStackCount()*iHealth)
		hParent:SetBaseMaxHealth(self:GetStackCount()*iHealth)
		hParent:SetHealth(self:GetStackCount()*iHealth)
	end)
end

function modifier_tower_endure:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_tower_endure:GetModifierHealthRegenPercentage()
	return 1*(self:GetStackCount()-1)/2
end

function modifier_tower_endure:GetModifierPhysicalArmorBonus()	
	local sName = self:GetParent():GetName()
	
	if string.match(sName, "healer") then		
		return 20*(self:GetStackCount()-1)/2
	elseif string.match(sName, "fort") then		
		return 15*(self:GetStackCount()-1)/2
	elseif string.match(sName, "range") then		
		return 10*(self:GetStackCount()-1)/2
	elseif string.match(sName, "melee") then		
		return 15*(self:GetStackCount()-1)/2
	elseif string.match(sName, "1") then 
		return 14*(self:GetStackCount()-1)/2
	elseif string.match(sName, "[2-3]") then		
		return 16*(self:GetStackCount()-1)/2
	elseif string.match(sName, "4") then		
		return 24*(self:GetStackCount()-1)/2
	end
end

function modifier_tower_endure:OnTooltip()
	return (self:GetStackCount()-1)*100
end

modifier_tower_power = class({})


function modifier_tower_power:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TOOLTIP		
	}
end

function modifier_tower_power:IsPurgable() return false end
function modifier_tower_power:IsDebuff() return false end
function modifier_tower_power:GetTexture() return "tower_power" end
function modifier_tower_power:OnAttackLanded(keys)
	if keys.attacker ~= self:GetParent() then return end
	local tTargets = FindUnitsInRadius(keys.attacker:GetTeamNumber(), keys.target:GetOrigin(), nil, (self:GetStackCount()-1)*75, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	
	for i, v in ipairs(tTargets) do
		if v ~= keys.target then
			ApplyDamage({
				attacker = keys.attacker,
				victim = v,
				damage = keys.damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				damage_flag = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR
			})
		end
	end
end

function modifier_tower_power:OnTooltip()
	return 75*(self:GetStackCount()-1)
end

function modifier_tower_power:GetModifierAttackSpeedBonus_Constant() return 500/9*(self:GetStackCount()-1) end


function modifier_tower_power:GetModifierBaseDamageOutgoing_Percentage()
	return 100*(self:GetStackCount()-1)
end

local tNotUpgrade = {
	item_aegis = true,
	item_courier = true,
	item_boots_of_elves = true,
	item_belt_of_strength = true,
	item_blade_of_alacrity = true,
	item_blades_of_attack = true,
	item_blight_stone = true,
	item_blink = true,
	item_boots = true,
	item_bottle = true,
	item_broadsword = true,
	item_chainmail = true,
	item_cheese = true,
	item_circlet = true,
	item_clarity = true,
	item_claymore = true,
	item_cloak = true,
	item_demon_edge = true,
	item_dust = true,
	item_eagle = true,
	item_enchanted_mango = true,
	item_energy_booster = true,
	item_faerie_fire = true,
	item_flying_courier = true,
	item_gauntlets = true,
	item_gem = true,
	item_ghost = true,
	item_gloves = true,
	item_flask = true,
	item_helm_of_iron_will = true,
	item_hyperstone = true,
	item_infused_raindrop = true,
	item_branches = true,
	item_javelin = true,
	item_magic_stick = true,
	item_mantle = true,
	item_mithril_hammer = true,
	item_lifesteal = true,
	item_mystic_staff = true,
	item_ward_observer = true,
	item_ogre_axe = true,
	item_orb_of_venom = true,
	item_platemail = true,
	item_point_booster = true,
	item_quarterstaff = true,
	item_quelling_blade = true,
	item_reaver = true,
	item_ring_of_health = true,
	item_ring_of_protection = true,
	item_ring_of_regen = true,
	item_robe = true,
	item_relic = true,
	item_sobi_mask = true,
	item_ward_sentry = true,
	item_shadow_amulet = true,
	item_slippers = true,
	item_smoke_of_deceit = true,
	item_staff_of_wizardry = true,
	item_stout_shield = true,
	item_talisman_of_evasion = true,
	item_tango = true,
	item_tango_single = true,
	item_tome_of_knowledge = true,
	item_tpscroll = true,
	item_ultimate_orb = true,
	item_vitality_booster = true,
	item_void_stone = true,
	item_wind_lace = true
}

local tFunItems = {
	item_fun_economizer = {"item_octarine_core","item_mystic_staff","item_staff_of_wizardry","item_robe","item_mantle"},
	item_fun_economizer_2 = {"item_fun_economizer","item_ultimate_scepter","item_kaya"},
	item_fun_genji_gloves = {"item_slippers","item_boots_of_elves","item_blade_of_alacrity","item_eagle","item_butterfly"},
	item_fun_genji_gloves_2 = {"item_fun_genji_gloves","item_monkey_king_bar","item_yasha"},
	item_fun_ragnarok = {"item_gauntlets","item_belt_of_strength","item_ogre_axe","item_reaver","item_heart"},
	item_fun_ragnarok_2 = {"item_fun_ragnarok", "item_bfury", "item_sange"},
	item_fun_escutcheon = {"item_pipe","item_crimson_guard","item_aeon_disk","item_soul_booster"},
	item_fun_angelic_alliance = {"item_fun_orb_of_omnipotence","item_fun_sprint_shoes","item_fun_economizer","item_rapier"},
	item_fun_blood_sword = {"item_greater_crit","item_satanic","item_echo_sabre","item_echo_sabre"},
	item_fun_heros_bow = {"item_ethereal_blade","item_dragon_lance","item_moon_shard","item_desolator"},
	item_fun_magic_hammer = {"item_rod_of_atos","item_shivas_guard","item_diffusal_blade_2","item_aether_lens"},
	item_fun_terra_blade = {"item_fun_ragnarok_2","item_fun_genji_gloves_2"},	
}

local tBotFunItems = {
	npc_dota_hero_axe = {"item_fun_ragnarok","item_fun_ragnarok_2","item_fun_magic_hammer","item_fun_escutcheon"},
	npc_dota_hero_bane = {"item_fun_magic_hammer","item_fun_economizer","item_fun_economizer_2","item_fun_escutcheon"},
	npc_dota_hero_bloodseeker = {"item_fun_genji_gloves","item_fun_genji_gloves_2","item_fun_ragnarok","item_fun_ragnarok_2","item_fun_blood_sword","item_fun_escutcheon"},
	npc_dota_hero_crystal_maiden = {"item_fun_magic_hammer","item_fun_economizer","item_fun_economizer_2","item_fun_escutcheon"},
	npc_dota_hero_drow_ranger = {"item_fun_genji_gloves","item_fun_genji_gloves_2","item_fun_blood_sword","item_fun_heros_bow"},
	npc_dota_hero_earthshaker = {"item_fun_magic_hammer","item_fun_economizer","item_fun_economizer_2","item_fun_escutcheon"},
	npc_dota_hero_juggernaut = {"item_fun_genji_gloves","item_fun_genji_gloves_2","item_fun_ragnarok","item_fun_ragnarok_2","item_fun_blood_sword","item_fun_economizer","item_fun_economizer_2"},
	npc_dota_hero_nevermore = {"item_fun_genji_gloves","item_fun_genji_gloves_2","item_fun_blood_sword","item_fun_heros_bow"},
	npc_dota_hero_pudge = {"item_fun_ragnarok","item_fun_ragnarok_2","item_fun_magic_hammer","item_fun_escutcheon"},
	npc_dota_hero_razor = {"item_fun_ragnarok","item_fun_ragnarok_2","item_fun_genji_gloves","item_fun_genji_gloves_2","item_fun_heros_bow"},
	npc_dota_hero_sand_king = {"item_fun_magic_hammer","item_fun_economizer","item_fun_economizer_2","item_fun_escutcheon"},
	npc_dota_hero_sven = {"item_fun_blood_sword","item_fun_genji_gloves","item_fun_genji_gloves_2","item_fun_ragnarok","item_fun_ragnarok_2"},
	npc_dota_hero_tiny = {"item_fun_magic_hammer","item_fun_genji_gloves","item_fun_genji_gloves_2","item_fun_ragnarok","item_fun_ragnarok_2"},
	npc_dota_hero_vengefulspirit = {"item_fun_magic_hammer","item_fun_genji_gloves","item_fun_genji_gloves_2","item_fun_escutcheon"},
	npc_dota_hero_windrunner = {"item_fun_economizer","item_fun_economizer_2","item_fun_magic_hammer","item_fun_heros_bow"},
	npc_dota_hero_zuus = {"item_fun_economizer","item_fun_economizer_2","item_fun_magic_hammer","item_fun_escutcheon"},
	npc_dota_hero_kunkka = {"item_fun_blood_sword","item_fun_ragnarok","item_fun_ragnarok_2","item_fun_genji_gloves","item_fun_genji_gloves_2"},
	npc_dota_hero_lina = {"item_fun_economizer","item_fun_economizer_2","item_fun_magic_hammer","item_fun_escutcheon"},
	npc_dota_hero_lion = {"item_fun_economizer","item_fun_economizer_2","item_fun_magic_hammer","item_fun_escutcheon"},
	npc_dota_hero_lich = {"item_fun_economizer","item_fun_economizer_2","item_fun_magic_hammer","item_fun_escutcheon"},
	npc_dota_hero_tidehunter = {"item_fun_economizer","item_fun_economizer_2","item_fun_magic_hammer","item_fun_escutcheon"},
	npc_dota_hero_witch_doctor = {"item_fun_economizer","item_fun_economizer_2","item_fun_magic_hammer","item_fun_escutcheon"},
	npc_dota_hero_sniper = {"item_fun_blood_sword","item_fun_genji_gloves","item_fun_genji_gloves_2","item_fun_heros_bow"},
	npc_dota_hero_necrolyte = {"item_fun_economizer","item_fun_economizer_2","item_fun_magic_hammer","item_fun_escutcheon"},
	npc_dota_hero_warlock = {"item_fun_economizer","item_fun_economizer_2","item_fun_magic_hammer","item_fun_escutcheon"},
	npc_dota_hero_skeleton_king  = {"item_fun_blood_sword","item_fun_genji_gloves","item_fun_genji_gloves_2","item_fun_heros_bow"},
	npc_dota_hero_death_prophet = {"item_fun_economizer","item_fun_economizer_2","item_fun_magic_hammer","item_fun_escutcheon"},
	npc_dota_hero_phantom_assassin = {"item_fun_blood_sword","item_fun_escutcheon","item_fun_genji_gloves","item_fun_genji_gloves_2"},
	npc_dota_hero_viper = {"item_fun_heros_bow","item_fun_escutcheon","item_fun_genji_gloves","item_fun_genji_gloves_2"},
	npc_dota_hero_luna = {"item_fun_blood_sword","item_fun_heros_bow","item_fun_genji_gloves","item_fun_genji_gloves_2"},
	npc_dota_hero_dragon_knight = {"item_fun_blood_sword","item_fun_economizer","item_fun_economizer_2","item_fun_heros_bow"},
	npc_dota_hero_dazzle = {"item_fun_economizer","item_fun_economizer_2","item_fun_magic_hammer","item_fun_escutcheon"},
	npc_dota_hero_omniknight = {"item_fun_economizer","item_fun_economizer_2","item_fun_ragnarok","item_fun_ragnarok_2","item_fun_escutcheon"},
	npc_dota_hero_bounty_hunter = {"item_fun_blood_sword","item_fun_heros_bow","item_fun_economizer","item_fun_economizer_2"},
	npc_dota_hero_jakiro = {"item_fun_economizer","item_fun_economizer_2","item_fun_magic_hammer","item_fun_escutcheon"},
	npc_dota_hero_chaos_knight = {"item_fun_ragnarok","item_fun_ragnarok_2","item_fun_genji_gloves","item_fun_genji_gloves_2","item_fun_economizer","item_fun_economizer_2"},
	npc_dota_hero_bristleback = {"item_fun_escutcheon","item_fun_ragnarok","item_fun_ragnarok_2","item_fun_magic_hammer"},
	npc_dota_hero_skywrath_mage = {"item_fun_economizer","item_fun_economizer_2","item_fun_magic_hammer","item_fun_escutcheon"},
	npc_dota_hero_oracle = {"item_fun_economizer","item_fun_economizer_2","item_fun_magic_hammer","item_fun_escutcheon"},
}

local tItemUpgrades = {
	item_fun_economizer = {"item_fun_economizer_2"},
	item_fun_genji_gloves = {"item_fun_genji_gloves_2", "item_fun_terra_blade"},
	item_fun_ragnarok = {"item_fun_ragnarok_2", "item_fun_terra_blade"},
	item_fun_genji_gloves_2 = {"item_fun_terra_blade"},
	item_fun_ragnarok_2 = {"item_fun_terra_blade"},
}

local function FindItemByName(hHero, sName)
	for i = 0, 8 do
		if hHero:GetItemInSlot(i) and hHero:GetItemInSlot(i):GetName() == sName then return hHero:GetItemInSlot(i) end
	end
	return nil
end

local function CheckFunItems(hHero, sFunItem)
	if FindItemByName(hHero, sFunItem) then return end
	if tItemUpgrades[sFunItem] then 
		for i, v in ipairs(tItemUpgrades[sFunItem]) do
			if FindItemByName(hHero, v) then return end
		end
	end
	local tHasComponent = {}
	local tLackComponent = {}
	for j = 1, #tFunItems[sFunItem] do
		local hItem = FindItemByName(hHero, tFunItems[sFunItem][j])
--		print(hItem, tFunItems[sFunItem][j])
		if hItem and not tNotUpgrade[hItem:GetName()] then 
			table.insert(tHasComponent, hItem)
		else
			table.insert(tLackComponent, tFunItems[sFunItem][j])
		end
	end
--	print(#tLackComponent, #tHasComponent, #tFunItems[sFunItem])
	local iGoldRemaining = 0
	for k, v in ipairs(tLackComponent) do
		iGoldRemaining = iGoldRemaining+GetItemCost(v)
	end
	if hHero:GetGold() > iGoldRemaining then
--		print(hHero:GetGold(), iGoldRemaining)
		for i, v in ipairs(tHasComponent) do
			hHero:RemoveItem(v)
		end
		hHero:AddItemByName(sFunItem)
		PlayerResource:SpendGold(hHero:GetPlayerOwnerID(), iGoldRemaining, DOTA_ModifyGold_PurchaseItem)
	end
end

modifier_bot_get_fun_items = class({})

function modifier_bot_get_fun_items:OnCreated()
	self:StartIntervalThink(1.5)
end

function modifier_bot_get_fun_items:IsPurgable() return false end
function modifier_bot_get_fun_items:IsHidden() return true end
function modifier_bot_get_fun_items:RemoveOnDeath() return false end

function modifier_bot_get_fun_items:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	local sHeroName = hParent:GetName()
	if hParent:HasModifier("modifier_fountain_aura_buff") or GameMode.iUniversalShop == 1 and tBotFunItems[sHeroName] then
		for i, v in ipairs(tBotFunItems[sHeroName]) do
			CheckFunItems(hParent, v)
		end
	end
end

modifier_bot_use_fun_items = class({})
function modifier_bot_use_fun_items:OnCreated()
	self:StartIntervalThink(0.04)
end

function modifier_bot_use_fun_items:IsPurgable() return false end
function modifier_bot_use_fun_items:IsHidden() return true end
function modifier_bot_use_fun_items:RemoveOnDeath() return false end

function modifier_bot_use_fun_items:OnIntervalThink()
	if IsClient() then return end
	local hParent = self:GetParent()
	
	for k, v in pairs(Entities:FindAllByClassnameWithin("dota_item_drop", hParent:GetOrigin(), 800)) do
		if v:GetContainedItem():GetAbilityName() == "item_fun_angelic_alliance" then
			if (hParent:GetOrigin()-v:GetOrigin()):Length2D() < 140 then
				local iMinimumCost = 99999
				local hMinimumCostItem
				local bHasEmpty = false
				for i = 0, 8 do
					if not hParent:GetItemInSlot(i) then
						bHasEmpty = true
						break
					else						
						if iMinimumCost > hParent:GetItemInSlot(i):GetCost() then
							iMinimumCost = hParent:GetItemInSlot(i):GetCost()
							hMinimumCostItem = hParent:GetItemInSlot(i)
						end
					end
				end
--				print(bHasEmpty, iMinimumCost, hMinimumCostItem:GetName())
				if bHasEmpty then
					hParent:PickupDroppedItem(v)
				else
					hParent:DropItemAtPositionImmediate(hMinimumCostItem, hParent:GetOrigin())
					hParent:PickupDroppedItem(v)
				end
			else
				hParent:MoveToPosition(v:GetOrigin())
			end
		end
	end
	
	local hItem = FindItemByName(hParent, "item_fun_blood_sword")
	if hItem and hItem:IsCooldownReady() then
		local tTargets = FindUnitsInRadius(hParent:GetTeam(), hParent:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
		if #tTargets > 0 then
			hParent:CastAbilityNoTarget(hItem, hParent:GetPlayerOwnerID())
		end
	end
	
	hItem = FindItemByName(hParent, "item_fun_magic_hammer")
	if hItem and hItem:IsCooldownReady() then
		local tTargets = FindUnitsInRadius(hParent:GetTeam(), hParent:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
		if #tTargets > 0 then
			hParent:CastAbilityNoTarget(hItem, hParent:GetPlayerOwnerID())
		end
	end
	
	hItem = FindItemByName(hParent, "item_fun_heros_bow")
	if hItem and hItem:IsCooldownReady() then
		local tTargets = FindUnitsInRadius(hParent:GetTeam(), hParent:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
		if #tTargets > 0 then
			hParent:CastAbilityOnTarget(tTargets[1], hItem, hParent:GetPlayerOwnerID())
		end
	end
	
	hItem = FindItemByName(hParent, "item_fun_angelic_alliance")
	if hItem and hItem:IsCooldownReady() then
		local tTargets = FindUnitsInRadius(hParent:GetTeam(), hParent:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
		if #tTargets > 0 then
			if hParent:IsRangedAttacker() then 
				hParent:CastAbilityOnPosition(tTargets[1]:GetOrigin()+600*(hParent:GetOrigin()-tTargets[1]:GetOrigin()):Normalized(), hItem, hParent:GetPlayerOwnerID()) 
			else
				hParent:CastAbilityOnPosition(tTargets[1]:GetOrigin(), hItem, hParent:GetPlayerOwnerID()) 
			end
		end
	end
end

modifier_attack_point_change = class({})
function modifier_attack_point_change:IsPurgable() return false end
function modifier_attack_point_change:IsHidden() return true end
function modifier_attack_point_change:RemoveOnDeath() return false end
function modifier_attack_point_change:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT} end
function modifier_attack_point_change:GetModifierAttackPointConstant() 
	return self:GetStackCount()/1000
end

modifier_attack_time_change = class({})
function modifier_attack_time_change:IsPurgable() return false end
function modifier_attack_time_change:IsHidden() return true end
function modifier_attack_time_change:RemoveOnDeath() return false end
function modifier_attack_time_change:DeclareFunctions() return {MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT} end
function modifier_attack_time_change:GetModifierBaseAttackTimeConstant() 
	return self:GetStackCount()/100
end


modifier_attack_range_change = class({})
function modifier_attack_range_change:IsPurgable() return false end
function modifier_attack_range_change:IsHidden() return true end
function modifier_attack_range_change:RemoveOnDeath() return false end
function modifier_attack_range_change:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACK_RANGE_BONUS} end
function modifier_attack_range_change:GetModifierAttackRangeBonus() return self:GetStackCount() end

modifier_axe_thinker = class({})
function modifier_axe_thinker:IsPurgable() return false end
function modifier_axe_thinker:IsHidden() return true end
function modifier_axe_thinker:RemoveOnDeath() return false end
function modifier_axe_thinker:OnCreated()
	if IsClient() then return end
	self:StartIntervalThink(0.04)
end

function modifier_axe_thinker:DeclareFunctions() return {MODIFIER_EVENT_ON_ABILITY_EXECUTED} end

local function ThinkForAxeAbilities(hAxe)
	local hAbility1 = hAxe:GetAbilityByIndex(0)
	local hAbility2 = hAxe:GetAbilityByIndex(1)
	local hAbility6 = hAxe:GetAbilityByIndex(5)
	if hAxe:IsSilenced() or hAxe:IsStunned() or hAbility1:IsInAbilityPhase() or hAbility2:IsInAbilityPhase() or hAbility6:IsInAbilityPhase() then return end
	local iRange2 = hAbility2:GetCastRange()
	local iThreshold = hAbility6:GetSpecialValueFor("kill_threshold")
	if hAbility6:IsFullyCastable() then
		local tAllHeroes = FindUnitsInRadius(hAxe:GetTeam(), hAxe:GetOrigin(), nil, hAbility6:GetCastRange()+150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		
		for i, v in ipairs(tAllHeroes) do
			if v:GetHealth() < iThreshold then
				hAxe:CastAbilityOnTarget(v, hAbility6, hAxe:GetPlayerOwnerID())
				hAxe.IsCasting = true
				return
			end
		end
	end
	if hAbility1:IsFullyCastable() then

		local tAllHeroes = FindUnitsInRadius(hAxe:GetTeam(), hAxe:GetOrigin(), nil, hAbility1:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		local iCount = #tAllHeroes
		for i = 1, iCount do
			if tAllHeroes[iCount+1-i]:IsStunned() or tAllHeroes[iCount+1-i]:IsHexed() then table.remove(tAllHeroes, iCount+1-i) end
		end
		
		if #tAllHeroes > 0 then
			hAxe:CastAbilityNoTarget(hAbility1, hAxe:GetPlayerOwnerID())
			return
		end
	end
	if hAbility2:IsFullyCastable() then
		local tAllHeroes = FindUnitsInRadius(hAxe:GetTeam(), hAxe:GetOrigin(), nil, hAbility2:GetCastRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for i, v in ipairs(tAllHeroes) do
			hAxe:CastAbilityOnTarget(v, hAbility2, hAxe:GetPlayerOwnerID())
			return
		end
	end
end

function modifier_axe_thinker:OnIntervalThink()
	if IsClient() then return end
	ThinkForAxeAbilities(self:GetParent())
end



















