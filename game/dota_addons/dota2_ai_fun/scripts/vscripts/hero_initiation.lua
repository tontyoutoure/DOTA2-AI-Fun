function GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
		
		local sName = hHero:GetName()		
		
		ListenToGameEvent('dota_player_gained_level', function (keys)		
			local hStatChangedHero = PlayerResource:GetPlayer(keys.player-1):GetAssignedHero()
			if hStatChangedHero:GetName() == sName and PlayerResource:GetPlayer(keys.player-1).bIsPlayingFunHero then
				hStatChangedHero:SetBaseStrength(hStatChangedHero:GetBaseStrength()+tHeroBaseStats.AttributeStrenthGain-hStatChangedHero:GetStrengthGain())
				hStatChangedHero:SetBaseAgility(hStatChangedHero:GetBaseAgility()+tHeroBaseStats.AttributeAgilityGain-hStatChangedHero:GetAgilityGain())
				hStatChangedHero:SetBaseIntellect(hStatChangedHero:GetBaseIntellect()+tHeroBaseStats.AttributeIntelligenceGain-hStatChangedHero:GetIntellectGain())
			end		
		end, nil)	
		
		for i = 0, 23 do
			if hHero:GetAbilityByIndex(i) then
				hHero:RemoveAbility(hHero:GetAbilityByIndex(i):GetName())
			end
		end
		for i, v in ipairs(tNewAbilities) do hHero:AddAbility(v) end
		
		Timers:CreateTimer(0.5, function() 
			hHero:SetBaseMoveSpeed(tHeroBaseStats.MovementSpeed)
			hHero:SetPrimaryAttribute(tHeroBaseStats.PrimaryAttribute)
		end)
		
		hHero:SetBaseAgility(tHeroBaseStats.AttributeBaseAgility)
		hHero:SetBaseStrength(tHeroBaseStats.AttributeBaseStrength)
		hHero:SetBaseIntellect(tHeroBaseStats.AttributeBaseIntelligence)
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