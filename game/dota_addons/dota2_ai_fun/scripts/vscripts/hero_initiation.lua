if not IsClient() then 
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
			
	function GameMode:InitializeFunHero(hHero)
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
		
		if hHero:GetName() == "npc_dota_hero_arc_warden" then
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
	end

	hero_attribute_gain_manager = class({})

	function hero_attribute_gain_manager:OnHeroLevelUp()
		local hCaster = self:GetCaster()
		hCaster:SetBaseStrength(hCaster:GetBaseStrength()+self.AttributeStrenthGain-hCaster:GetStrengthGain())
		hCaster:SetBaseAgility(hCaster:GetBaseAgility()+self.AttributeAgilityGain-hCaster:GetAgilityGain())
		hCaster:SetBaseIntellect(hCaster:GetBaseIntellect()+self.AttributeIntelligenceGain-hCaster:GetIntellectGain())	
	end

	function GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
			
			local sName = hHero:GetName()	
			for i = 0, 23 do
				if hHero:GetAbilityByIndex(i) then
					hHero:RemoveAbility(hHero:GetAbilityByIndex(i):GetName())
				end
			end	
			for i, v in ipairs(tNewAbilities) do hHero:AddAbility(v) end
			local tModifiers = hHero:FindAllModifiers()
			for i, v in ipairs(tModifiers) do
				if string.find(v:GetName(), "special_bonus") then
					v:Destroy()
				end
			end
			
			if not tHeroBaseStats.bNoAttributeManager then
			
				local hAttributeManager = hHero:AddAbility("hero_attribute_gain_manager")
				hAttributeManager:SetLevel(1)
				hAttributeManager.AttributeStrenthGain = tHeroBaseStats.AttributeStrenthGain
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
				hHero:SetBaseStrength(tHeroBaseStats.AttributeBaseStrength+(iLevel-1)*(tHeroBaseStats.AttributeStrenthGain-hHero:GetPlayerOwner():GetAssignedHero():GetStrengthGain()))
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
			if tHeroBaseStats.AttackAnimationPoint then hHero:AddNewModifier(hHero, nil, "modifier_attack_point_change", {}):SetStackCount(tHeroBaseStats.AttackAnimationPoint*100)	end
			if tHeroBaseStats.ProjectileModel then hHero:SetRangedProjectileName(tHeroBaseStats.ProjectileModel) end
			local iAttackRange = hHero:GetAttackRange()
			if tHeroBaseStats.AttackRange then	hHero:AddNewModifier(hHero, nil, "modifier_attack_range_change", {}):SetStackCount(tHeroBaseStats.AttackRange - iAttackRange)	end
			if tHeroBaseStats.ModelScale then hHero:SetModelScale(tHeroBaseStats.ModelScale) end
			if tHeroBaseStats.DisableWearables then WearableManager:RemoveOriginalWearables(hHero) end
			if tHeroBaseStats.Model then hHero:SetModel(tHeroBaseStats.Model) hHero:SetOriginalModel(tHeroBaseStats.Model) end
	end

end