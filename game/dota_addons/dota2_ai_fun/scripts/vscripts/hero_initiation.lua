hero_attribute_gain_manager = class({})

function hero_attribute_gain_manager:OnHeroLevelUp()
	local hCaster = self:GetCaster()
	hCaster:SetBaseStrength(hCaster:GetBaseStrength()+self.AttributeStrengthGain-hCaster:GetStrengthGain())
	hCaster:SetBaseAgility(hCaster:GetBaseAgility()+self.AttributeAgilityGain-hCaster:GetAgilityGain())
	hCaster:SetBaseIntellect(hCaster:GetBaseIntellect()+self.AttributeIntelligenceGain-hCaster:GetIntellectGain())	
end

if not IsClient() then 

	tAbilityKeyValues = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
	function GameMode:FunHeroScepterUpgradeInfo(sHeroName, tAbilities)
		local tScepterInfos = {}
		local tShardInfos = {}
		for i, v in ipairs(tAbilities) do
			if string.sub(v,1,13) ~= "special_bonus" and v ~= "generic_hidden" and tAbilityKeyValues[v].HasScepterUpgrade == 1 then 
				local tScepterInfoSingle = {}
				table.insert(tScepterInfos, tScepterInfoSingle)
				tScepterInfoSingle.sAbilityName = v
				if tAbilityKeyValues[v].AbilitySpecial then
					for k1, v1 in pairs(tAbilityKeyValues[v].AbilitySpecial) do
						for k2, v2 in pairs(v1) do
							if string.match(k2, "scepter") then
								tScepterInfoSingle.tScepterSpecials = tScepterInfoSingle.tScepterSpecials or {}
								local tScepterSpecialSingle = {}
								table.insert(tScepterInfoSingle.tScepterSpecials, tScepterSpecialSingle)
								tScepterSpecialSingle.sSpecialName = k2 
								tScepterSpecialSingle.sSpecialValue = string.gsub(v2, " ", "/")						
							end
						end
					end
				end
			end
			if string.sub(v,1,13) ~= "special_bonus" and v ~= "generic_hidden" and tAbilityKeyValues[v].HasShardUpgrade == 1 then 
				local tShardInfoSingle = {}
				table.insert(tShardInfos, tShardInfoSingle)
				tShardInfoSingle.sAbilityName = v
				if tAbilityKeyValues[v].AbilitySpecial then
					for k1, v1 in pairs(tAbilityKeyValues[v].AbilitySpecial) do
						for k2, v2 in pairs(v1) do
							if string.match(k2, "shard") then
								tShardInfoSingle.tShardSpecials = tShardInfoSingle.tShardSpecials or {}
								local tShardSpecialSingle = {}
								table.insert(tShardInfoSingle.tShardSpecials, tShardSpecialSingle)
								tShardSpecialSingle.sSpecialName = k2 
								tShardSpecialSingle.sSpecialValue = string.gsub(v2, " ", "/")						
							end
						end
					end
				end
			end
		end
		if #tScepterInfos > 0 then
--			print(sHeroName)
--			PrintTable(tScepterInfos)
			CustomNetTables:SetTableValue("fun_hero_stats", sHeroName.."_scepter_infos", tScepterInfos)
			CustomNetTables:SetTableValue("fun_hero_stats", sHeroName.."_shard_infos", tShardInfos)

		end
	end


	require('heroes/astral_trekker/astral_trekker_init')
	require('heroes/bastion/bastion_init')
	require('heroes/fluid_engineer/fluid_engineer_init')
	require('heroes/formless/formless_init')
	require('heroes/intimidator/intimidator_init')
	require('heroes/magic_dragon/magic_dragon_init')
	require('heroes/mana_fiend/mana_fiend_init')
	require('heroes/persuasive/persuasive_init')
	require('heroes/telekenetic_blob/telekenetic_blob_init')
	require('heroes/terran_marine/terran_marine_init')
	require('heroes/void_demon/void_demon_init')
	require('heroes/ramza/ramza_init')
	require('heroes/cleric/cleric_init')
	require('heroes/pet_summoner/pet_summoner_init')
	require('heroes/felguard/felguard_init')
	require('heroes/el_dorado/el_dorado_init')
	require('heroes/hurricane/hurricane_init')
	require('heroes/capslockftw/capslockftw_init')
	require('heroes/templar/templar_init')
	require('heroes/spongebob/spongebob_init')
	require('heroes/hamsterlord/hamsterlord_init')
	require('heroes/exsoldier/exsoldier_init')
	require('heroes/gambler/gambler_init')
	require('heroes/old_lifestealer/old_lifestealer_init')
	require('heroes/rider/rider_init')
	require('heroes/siglos/siglos_init')
	require('heroes/flame_lord/flame_lord_init')
	require('heroes/conjurer/conjurer_init')
	require('heroes/avatar_of_vengeance/avatar_of_vengeance_init')
	require('heroes/hero_invoker/invoker_retro_init')
	require('heroes/old_silencer/old_silencer_init')
	require('heroes/old_stealth_assassin/old_stealth_assassin_init')
	require('heroes/old_holy_knight/old_holy_knight_init')
	require('heroes/best_worst_stats/best_worst_stats_init')
	require('heroes/old_butcher/old_butcher_init')
	require('heroes/kahmeka/kahmeka_init')
	require('heroes/old_storm_spirit/old_storm_spirit_init')
	require('heroes/old_gorgon/old_gorgon_init')
	require('heroes/god_of_wind/god_of_wind_init')
			
	function GameMode:InitializeFunHero(hHero)
		if hHero:GetPlayerOwner().bRandom then
			hHero:AddItemByName('item_faerie_fire'):SetPurchaseTime(-10)
			hHero:AddItemByName('item_enchanted_mango'):SetPurchaseTime(-10)
		end
		if hHero:GetName() == "npc_dota_hero_spirit_breaker" then
			AstralTrekkerInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_shadow_demon" then
			BastionInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_beastmaster"  then
			FluidEngineerInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_wisp" then
			FormlessInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_treant" then
			IntimidatorInit(hHero, self)		
		end
		
		if hHero:GetName() == "npc_dota_hero_visage" then
			MagicDragonInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_viper" then
			ManaFiendInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_techies" then
			PersuasiveInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_enigma" then
			TelekeneticBlobInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_tinker" then
			TerranMarineInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_night_stalker" then
			VoidDemonInit(hHero, self)
		end
			
		if hHero:GetName() == "npc_dota_hero_dragon_knight" then
			RamzaInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_oracle" then
			ClericInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_windrunner" then
			PetSummonerInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_sven" then
			FelguardInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_pugna" then
			ElDoradoInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_disruptor" then
			HurricaneInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_nevermore" then
			CAPSLOCKFTWInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_omniknight" then
			TemplarInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_meepo" then
			SpongeBobInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_tusk" then
			HampsterLordInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_juggernaut" then
			ExsoldierInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_rubick" then
			GamblerInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_life_stealer" then
			OldLifestealerInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_chaos_knight" then
			RiderInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_skywrath_mage" then
			SiglosInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_warlock" then
			FlameLordInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_keeper_of_the_light" then
			ConjurerInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_spectre" then
			AvatarOfVengeanceInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_invoker" then
			InvokerRetroInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_silencer" then
			OldSilencerInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_riki" then
			OldStealthAssassinInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_chen" then
			OldHolyKnightInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_monkey_king" then
			BestStatsInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_troll_warlord" then
			WorstStatsInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_pudge" then
			OldButcherInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_batrider" then
			KahmekaInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_storm_spirit" then
			OldStormSpiritInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_medusa" then
			OldGorgonInit(hHero, self)
		end
		
		if hHero:GetName() == "npc_dota_hero_furion" then
			GodOfWindInit(hHero, self)
		end
	end


	function GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
		
		local sName = hHero:GetName()	
		for i = 0, 23 do
			if hHero:GetAbilityByIndex(i) then
				hHero:RemoveAbility(hHero:GetAbilityByIndex(i):GetName())
			end
		end 
		for i, v in ipairs(tNewAbilities) do 
			hHero:AddAbility(v) 
		end
		FixAbilities(hHero)
		
		local tModifiers = hHero:FindAllModifiers()
		for i, v in ipairs(tModifiers) do
			if string.find(v:GetName(), "special_bonus") then
				v:Destroy()
			end
		end
		
		if not tHeroBaseStats.bNoAttributeManager then
		
			local hAttributeManager = hHero:AddAbility("hero_attribute_gain_manager")
			hAttributeManager:SetLevel(1)
			hAttributeManager.AttributeStrengthGain = tHeroBaseStats.AttributeStrengthGain
			hAttributeManager.AttributeAgilityGain = tHeroBaseStats.AttributeAgilityGain
			hAttributeManager.AttributeIntelligenceGain = tHeroBaseStats.AttributeIntelligenceGain
		
		end
		
		
		Timers:CreateTimer(0.5, function() 
			hHero:SetBaseMoveSpeed(tHeroBaseStats.MovementSpeed)
		end)
		if tHeroBaseStats.PrimaryAttribute then
			Timers:CreateTimer(0.5, function() 
				hHero:SetPrimaryAttribute(tHeroBaseStats.PrimaryAttribute)
			end)
		end
		
		Timers:CreateTimer(0.04, function() 
			if hHero ~= hHero:GetPlayerOwner():GetAssignedHero() then 
				for i = 0, 23 do
					if hHero:GetAbilityByIndex(i) and not hHero:GetName() == "npc_dota_hero_dragon_knight" then
						hHero:GetAbilityByIndex(i):SetLevel(hHero:GetPlayerOwner():GetAssignedHero():GetAbilityByIndex(i):GetLevel())
					end
				end
				hHero:SetAbilityPoints(0)
				hHero:SetHealth(hHero:GetPlayerOwner():GetAssignedHero():GetHealth())
				hHero:SetMana(hHero:GetPlayerOwner():GetAssignedHero():GetMana())
			end
		end)
		
		if hHero:IsIllusion() then
			local iLevel = hHero:GetPlayerOwner():GetAssignedHero():GetLevel()
			hHero:SetBaseStrength(tHeroBaseStats.AttributeBaseStrength+(iLevel-1)*(tHeroBaseStats.AttributeStrengthGain-hHero:GetPlayerOwner():GetAssignedHero():GetStrengthGain()))
			hHero:SetBaseAgility(tHeroBaseStats.AttributeBaseAgility+(iLevel-1)*(tHeroBaseStats.AttributeAgilityGain-hHero:GetPlayerOwner():GetAssignedHero():GetAgilityGain()))
			hHero:SetBaseIntellect(tHeroBaseStats.AttributeBaseIntelligence+(iLevel-1)*(tHeroBaseStats.AttributeIntelligenceGain-hHero:GetPlayerOwner():GetAssignedHero():GetIntellectGain()))
		else
			hHero:SetBaseAgility(tHeroBaseStats.AttributeBaseAgility)
			hHero:SetBaseStrength(tHeroBaseStats.AttributeBaseStrength)
			hHero:SetBaseIntellect(tHeroBaseStats.AttributeBaseIntelligence)
		end
		hHero:SetPhysicalArmorBaseValue(tHeroBaseStats.ArmorPhysical)
		hHero:SetBaseDamageMin(tHeroBaseStats.AttackDamageMin)
		hHero:SetBaseDamageMax(tHeroBaseStats.AttackDamageMax)
		hHero:SetBaseAttackTime(tHeroBaseStats.AttackRate)
		
		if tHeroBaseStats.AttackCapabilities then hHero:SetAttackCapability(tHeroBaseStats.AttackCapabilities) end
		if tHeroBaseStats.VisionDaytimeRange then hHero:SetDayTimeVisionRange(tHeroBaseStats.VisionDaytimeRange) end
		if tHeroBaseStats.VisionNighttimeRange then hHero:SetNightTimeVisionRange(tHeroBaseStats.VisionNighttimeRange) end
		if tHeroBaseStats.AttackAnimationPoint then hHero:AddNewModifier(hHero, nil, "modifier_attack_point_change", {}):SetStackCount(tHeroBaseStats.AttackAnimationPoint*1000)	end
		if tHeroBaseStats.ProjectileModel then hHero:SetRangedProjectileName(tHeroBaseStats.ProjectileModel) end
		local iAttackRange = hHero:Script_GetAttackRange()
		if tHeroBaseStats.AttackRange and not hHero:HasModifier('modifier_attack_range_change') then hHero:AddNewModifier(hHero, nil, "modifier_attack_range_change", {}):SetStackCount(tHeroBaseStats.AttackRange - iAttackRange)	end
		local iProjectileSpeed = hHero:GetProjectileSpeed()
		if tHeroBaseStats.ProjectileSpeed and not hHero:HasModifier('modifier_projectile_speed_change') then hHero:AddNewModifier(hHero, nil, "modifier_projectile_speed_change", {}):SetStackCount(tHeroBaseStats.ProjectileSpeed - iProjectileSpeed) end
		
		
		if tHeroBaseStats.AttackSpeedBonus and not hHero:HasModifier('modifier_attack_speed_change') then hHero:AddNewModifier(hHero, nil, "modifier_attack_speed_change", {}):SetStackCount(tHeroBaseStats.AttackSpeedBonus) end
		
		
		if tHeroBaseStats.ModelScale then hHero:SetModelScale(tHeroBaseStats.ModelScale) end
		if tHeroBaseStats.DisableWearables then WearableManager:RemoveOriginalWearables(hHero) end
		if tHeroBaseStats.Model then hHero:SetModel(tHeroBaseStats.Model) hHero:SetOriginalModel(tHeroBaseStats.Model) end
		if tHeroBaseStats.StatusHealthRegen then hHero:SetBaseHealthRegen(tHeroBaseStats.StatusHealthRegen) end
		if tHeroBaseStats.MagicalResistance then hHero:SetBaseMagicalResistanceValue(tHeroBaseStats.MagicalResistance) end
		if tHeroBaseStats.VisionNighttimeRange then hHero:SetNightTimeVisionRange(tHeroBaseStats.VisionNighttimeRange) end
		if tHeroBaseStats.VisionDaytimeRange then hHero:SetDayTimeVisionRange(tHeroBaseStats.VisionDaytimeRange) end
		
	end
end






















