
modifier_frozen_heroes = class({})
function modifier_frozen_heroes:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_INVULNERABLE] = true} end
function modifier_frozen_heroes:GetTexture() return 'modifier_invulnerable' end
function modifier_frozen_heroes:IsPurgable() return false end
function modifier_frozen_heroes:GetStatusEffectName() return "particles/status_fx/status_effect_avatar.vpcf" end
function modifier_frozen_heroes:GetEffectName() return "particles/items_fx/black_king_bar_avatar.vpcf" end
function modifier_frozen_heroes:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

if IsServer() then
	tHeroInfos = LoadKeyValues('scripts/npc/npc_heroes.txt')
	tAbilityInfos = LoadKeyValues('scripts/npc/npc_abilities.txt')
	tStats = {'AttackDamageMin', 'AttackDamageMax', 'AttackRate', 'AttackAnimationPoint', 'AttackRange', 'MovementSpeed', 'MovementTurnRate', 'AttributeBaseStrength', 'AttributeStrengthGain', 'AttributeBaseIntelligence', 'AttributeIntelligenceGain', 'AttributeBaseAgility', 'AttributeAgilityGain', 'StatusHealthRegen', 'ArmorPhysical', 'MagicalResistance', 'VisionNighttimeRange', 'VisionDaytimeRange'}



	local tMaxMinStats = {}
	local ProjectileSpeed = {}

	local tBasicAbilities = {{}}
	local tUltiAbilities = {}
	local tTalents = {{},{},{},{}}
	local tUniqueTalents = {{},{},{},{}}
	local iGroup = 1
	local iHeroIndex = 1
	local iGroupSize = 10
	for k, v in pairs(tHeroInfos) do
		if k ~= 'npc_dota_hero_target_dummy' and k ~= 'npc_dota_hero_base' and k ~= 'Version' then
			for i,u in ipairs(tStats) do
				if v[u] then
					if not tMaxMinStats[u] then
						tMaxMinStats[u] = {}
						tMaxMinStats[u][1] = tonumber(v[u])
						tMaxMinStats[u][2] = tonumber(v[u])
					else
						if tMaxMinStats[u][1] > tonumber(v[u]) then tMaxMinStats[u][1] = tonumber(v[u]) end
						if tMaxMinStats[u][2] < tonumber(v[u]) then tMaxMinStats[u][2] = tonumber(v[u]) end
					end
				end
			end
			if v.ProjectileSpeed then
				if tonumber(v.ProjectileSpeed) ~= 0 then
					if not ProjectileSpeed[1] then
						ProjectileSpeed[1] = tonumber(v.ProjectileSpeed)
						ProjectileSpeed[2] = tonumber(v.ProjectileSpeed)
					else
						if ProjectileSpeed[1] > tonumber(v.ProjectileSpeed) then ProjectileSpeed[1] = tonumber(v.ProjectileSpeed) end
						if ProjectileSpeed[2] < tonumber(v.ProjectileSpeed) then ProjectileSpeed[2] = tonumber(v.ProjectileSpeed) end
					end
				end
			end
			
			local iTalentTire = 1
			
			if iHeroIndex > iGroupSize then
				iHeroIndex = 1
				iGroup = iGroup+1
				tBasicAbilities[iGroup] = {}
			else
				iHeroIndex = iHeroIndex+1
			end
			for i = 1, 24 do
				if v['Ability'..i] then
					if v['Ability'..i] == 'troll_warlord_battle_trance' or tAbilityInfos[v['Ability'..i]].AbilityType == "DOTA_ABILITY_TYPE_ULTIMATE" and not string.find(tAbilityInfos[v['Ability'..i]].AbilityBehavior, 'DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE') and not string.find(tAbilityInfos[v['Ability'..i]].AbilityBehavior, 'DOTA_ABILITY_BEHAVIOR_HIDDEN') then
						tUltiAbilities[k]=tUltiAbilities[k] or {} 					
						if tAbilityInfos[v['Ability'..i]].AbilitySpecial then
							for k1, v1 in pairs(tAbilityInfos[v['Ability'..i]].AbilitySpecial) do
								if v1.LinkedSpecialBonus then
									tUltiAbilities[k][v['Ability'..i]] = tUltiAbilities[k][v['Ability'..i]] or {}
									tUltiAbilities[k][v['Ability'..i]][v1.LinkedSpecialBonus] = true
								end
							end
						end
						if not tUltiAbilities[k][v['Ability'..i]] then
							tUltiAbilities[k][v['Ability'..i]] = 'none'
						end
					elseif tAbilityInfos[v['Ability'..i]].AbilityType == "DOTA_ABILITY_TYPE_ATTRIBUTES" then
						if string.find(v['Ability'..i],'unique') then
							local iTire = math.floor(iTalentTire)
							tUniqueTalents[iTire][v['Ability'..i]] = true
						else
							local iTire = math.floor(iTalentTire)
							table.insert(tTalents[iTire], v['Ability'..i])
						end					
						iTalentTire = iTalentTire + 0.5
					elseif not string.find(tAbilityInfos[v['Ability'..i]].AbilityBehavior, 'DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE') and not string.find(tAbilityInfos[v['Ability'..i]].AbilityBehavior, 'DOTA_ABILITY_BEHAVIOR_HIDDEN') and not tAbilityInfos[v['Ability'..i]].LinkedAbility then
						tBasicAbilities[iGroup][k]=tBasicAbilities[iGroup][k] or {} 
						if tAbilityInfos[v['Ability'..i]].AbilitySpecial then
							for k1, v1 in pairs(tAbilityInfos[v['Ability'..i]].AbilitySpecial) do
								if v1.LinkedSpecialBonus then
									tBasicAbilities[iGroup][k][v['Ability'..i]] = tBasicAbilities[iGroup][k][v['Ability'..i]] or {}
									table.insert(tBasicAbilities[iGroup][k][v['Ability'..i]],v1.LinkedSpecialBonus)
								end
							end
						end
						if not tBasicAbilities[iGroup][k][v['Ability'..i]] then
							tBasicAbilities[iGroup][k][v['Ability'..i]] = 'none'
						end
					end
				end
			end	
		end
	end

	local function FindLastUnderscore(s)
		local i = 1
		while string.find(s,'_',i) do
			i = string.find(s,'_',i)+1
		end
		return i-1
	end


	local SortFunction = function (s1, s2)
		local iLen1 = string.len(s1)
		local iLen2 = string.len(s2)
	--	print(s1, s2, iLen1, iLen2)
		local iLastUnderscoreLoc = FindLastUnderscore(s1)
		if string.sub(s1, 1, iLastUnderscoreLoc) == string.sub(s2, 1, iLastUnderscoreLoc) and tonumber(string.sub(s1, iLastUnderscoreLoc+1, -1)) and tonumber(string.sub(s2, iLastUnderscoreLoc+1, -1)) then
--			print(string.sub(s1, 1, iLastUnderscoreLoc))
			if tonumber(string.sub(s1, iLastUnderscoreLoc+1, -1)) > tonumber(string.sub(s2, iLastUnderscoreLoc+1, -1)) then
				return true
			else
				return false
			end
		end
		local iLenMin
		if iLen1 > iLen2 then
			iLenMin = iLen2
		else
			iLenMin = iLen1
		end
		for i = 1, iLenMin do
			if string.byte(string.sub(s1, i, i)) > string.byte(string.sub(s2, i, i)) then
				return true
			elseif string.byte(string.sub(s1, i, i)) < string.byte(string.sub(s2, i, i)) then
				return false
			end
		end
		if iLen1 > iLen2 then return true else return false end
	end
	table.sort(tTalents[1], SortFunction)
	table.sort(tTalents[2], SortFunction)
	table.sort(tTalents[3], SortFunction)
	table.sort(tTalents[4], SortFunction)

	local function RemoveDuplicate(aStrings)
		local i = 1
		while i < #aStrings do
		--	print(FindLastUnderscore(aStrings[i]))
		--	print(string.sub(aStrings[i], 1, FindLastUnderscore(aStrings[i])-1))
			if string.sub(aStrings[i], 1, FindLastUnderscore(aStrings[i])-1) == string.sub(aStrings[i+1], 1, FindLastUnderscore(aStrings[i+1])-1) then
				table.remove(aStrings, i+1)
			else
				i = i+1
			end
		end
	end
--	PrintTable(tTalents[1])
	RemoveDuplicate(tTalents[1])
	RemoveDuplicate(tTalents[2])
	RemoveDuplicate(tTalents[3])
	RemoveDuplicate(tTalents[4])

	local tBestBaseStats = {
		MovementSpeed = tMaxMinStats.MovementSpeed[2],
		AttackAnimationPoint = tMaxMinStats.AttackAnimationPoint[1],
		AttackRate = tMaxMinStats.AttackRate[1],
		AttackDamageMin = tMaxMinStats.AttackDamageMin[2],
		AttackDamageMax = tMaxMinStats.AttackDamageMax[2],
		AttributeBaseStrength = tMaxMinStats.AttributeBaseStrength[2],
		AttributeBaseAgility = tMaxMinStats.AttributeBaseAgility[2],
		AttributeBaseIntelligence = tMaxMinStats.AttributeBaseIntelligence[2],
		AttributeStrengthGain = tMaxMinStats.AttributeStrengthGain[2],
		AttributeAgilityGain = tMaxMinStats.AttributeAgilityGain[2],
		AttributeIntelligenceGain = tMaxMinStats.AttributeIntelligenceGain[2],
		ArmorPhysical = tMaxMinStats.ArmorPhysical[2],
		AttackRange = tMaxMinStats.AttackRange[2],
		StatusHealthRegen = tMaxMinStats.StatusHealthRegen[2],
		MagicalResistance = tMaxMinStats.MagicalResistance[2],
		ProjectileSpeed = ProjectileSpeed[2],
		MovementTurnRate = tMaxMinStats.MovementTurnRate[2],
		VisionDaytimeRange = tMaxMinStats.VisionDaytimeRange[2],
		VisionNighttimeRange = tMaxMinStats.VisionNighttimeRange[2],
	}
--	PrintTable(tBestBaseStats)
	local tWorstBaseStats = {
		MovementSpeed = tMaxMinStats.MovementSpeed[1],
		AttackAnimationPoint = tMaxMinStats.AttackAnimationPoint[2],
		AttackRate = tMaxMinStats.AttackRate[2],
		AttackDamageMin = tMaxMinStats.AttackDamageMin[1],
		AttackDamageMax = tMaxMinStats.AttackDamageMax[1],
		AttributeBaseStrength = tMaxMinStats.AttributeBaseStrength[1],
		AttributeBaseAgility = tMaxMinStats.AttributeBaseAgility[1],
		AttributeBaseIntelligence = tMaxMinStats.AttributeBaseIntelligence[1],
		AttributeStrengthGain = tMaxMinStats.AttributeStrengthGain[1],
		AttributeAgilityGain = tMaxMinStats.AttributeAgilityGain[1],
		AttributeIntelligenceGain = tMaxMinStats.AttributeIntelligenceGain[1],
		ArmorPhysical = tMaxMinStats.ArmorPhysical[1],
		AttackRange = tMaxMinStats.AttackRange[1],
		StatusHealthRegen = tMaxMinStats.StatusHealthRegen[1],
		MagicalResistance = tMaxMinStats.MagicalResistance[1],
		ProjectileSpeed = ProjectileSpeed[1],
		MovementTurnRate = tMaxMinStats.MovementTurnRate[1],
		PrimaryAttribute = DOTA_ATTRIBUTE_AGILITY,
		VisionDaytimeRange = tMaxMinStats.VisionDaytimeRange[1],
		VisionNighttimeRange = tMaxMinStats.VisionNighttimeRange[1],
	}
	
	CustomNetTables:SetTableValue("fun_hero_stats", "worst_stats_hero", tWorstBaseStats)
	CustomNetTables:SetTableValue("fun_hero_stats", "best_stats_hero", tBestBaseStats)
	local function RestoreFloat(f)
		return math.ceil(math.floor(f*100000)/10)/10000
	end
		
	for k, v in pairs(tBestBaseStats) do
		tBestBaseStats[k] = RestoreFloat(v)
	end
	for k, v in pairs(tWorstBaseStats) do
		tWorstBaseStats[k] = RestoreFloat(v)
	end
	local tNewAbilitiesBest = {}
	local tNewAbilitiesWorst = {}

	function BestStatsInit(hHero, context)
		if not hHero:IsIllusion() and not hHero:IsClone() and not hHero:HasModifier('modifier_arc_warden_tempest_double') then
			hHero:AddNewModifier(hHero, nil, "modifier_frozen_heroes", {})
		end
		hHero:AddNewModifier(hHero, nil, "modifier_attribute_growth_str_global", {}):SetStackCount(tBestBaseStats.AttributeStrengthGain*100)
		hHero:AddNewModifier(hHero, nil, "modifier_attribute_growth_agi_global", {}):SetStackCount(tBestBaseStats.AttributeAgilityGain*100)
		hHero:AddNewModifier(hHero, nil, "modifier_attribute_growth_int_global", {}):SetStackCount(tBestBaseStats.AttributeIntelligenceGain*100)
		hHero:AddNewModifier(hHero, nil, "modifier_turn_rate_change", tNewAbilitiesBest):SetStackCount(166)
		GameMode:InitiateHeroStats(hHero, tNewAbilitiesBest, tBestBaseStats)
	end

	function WorstStatsInit(hHero, context)
		if not hHero:GetPlayerOwner().bBWInited then
			hHero:AddNewModifier(hHero, nil, "modifier_frozen_heroes", {})
			hHero:GetPlayerOwner().bBWInited = true
		end
		hHero:AddNewModifier(hHero, nil, "modifier_attribute_growth_str_global", {}):SetStackCount(tWorstBaseStats.AttributeStrengthGain*100)
		hHero:AddNewModifier(hHero, nil, "modifier_attribute_growth_agi_global", {}):SetStackCount(tWorstBaseStats.AttributeAgilityGain*100)
		hHero:AddNewModifier(hHero, nil, "modifier_attribute_growth_int_global", {}):SetStackCount(tWorstBaseStats.AttributeIntelligenceGain*100)
		GameMode:InitiateHeroStats(hHero, tNewAbilitiesWorst, tWorstBaseStats)
	end

	LinkLuaModifier('modifier_frozen_heroes', 'heroes/best_worst_stats/best_worst_stats_init.lua', LUA_MODIFIER_MOTION_NONE)
	for i = 1, 4 do
		CustomNetTables:SetTableValue('game_options', 'unique_talents_'..tostring(i), tUniqueTalents[i])
		CustomNetTables:SetTableValue('game_options', 'talents_'..tostring(i), tTalents[i])
	end
	CustomNetTables:SetTableValue('game_options', 'ulti_abilities', tUltiAbilities)
	for i = 1, iGroup do
		CustomNetTables:SetTableValue('game_options', 'basic_abilities'..tostring(i), tBasicAbilities[i])
	end
	CustomNetTables:SetTableValue('game_options', 'basic_abilities_group_count', {iGroup})
	
	
	function BestWorstStatsListener(eventSourceIndex, keys)
		local hPlayer = PlayerResource:GetPlayer(keys.PlayerID)
		local hHero = hPlayer:GetAssignedHero()
		if not hHero:HasModifier('modifier_frozen_heroes') then return end
		local bBest = true
		if type(keys.abilities[tostring(0)]) == 'string' then
			tNewAbilitiesWorst[1] = keys.abilities[tostring(0)]
			tNewAbilitiesWorst[2] = keys.abilities[tostring(1)]
			tNewAbilitiesWorst[3] = keys.abilities[tostring(2)]
			tNewAbilitiesWorst[4] = "generic_hidden"
			tNewAbilitiesWorst[5] = "generic_hidden"
			tNewAbilitiesWorst[6] = keys.abilities[tostring(3)]
			bBest = false		
			local j = 7
			for i = 0, 3 do 
				if type(keys.talents[tostring(i)]) == 'string' then
					tNewAbilitiesWorst[j] = keys.talents[tostring(i)]
				else
					tNewAbilitiesWorst[j] = 'special_bonus_empty_'..tostring(j-6)
				end
				j = j+1
				tNewAbilitiesWorst[j] = 'special_bonus_empty_'..tostring(j-6)
				j = j+1
			end
		else
			tNewAbilitiesBest[1] = "generic_hidden"
			tNewAbilitiesBest[2] = "generic_hidden"
			tNewAbilitiesBest[3] = "generic_hidden"
			tNewAbilitiesBest[4] = "generic_hidden"
			tNewAbilitiesBest[5] = "generic_hidden"
			tNewAbilitiesBest[6] = "generic_hidden"
			local j = 7
			for i = 0, 3 do 
				if type(keys.talents[tostring(i)]) == 'string' then
					tNewAbilitiesBest[j] = keys.talents[tostring(i)]
				else
					tNewAbilitiesBest[j] = 'special_bonus_empty_'..tostring(j-6)
				end
				j = j+1
				tNewAbilitiesBest[j] = 'special_bonus_empty_'..tostring(j-6)
				j = j+1
			end
		end
		
		
		
		if tonumber(keys.primary_attribute) > 0 then
			tBestBaseStats.PrimaryAttribute = tonumber(keys.primary_attribute)-1
		end
		if bBest then
			BestStatsInit(hHero, nil)
		else
			WorstStatsInit(hHero, nil)
		end
		hHero:RemoveModifierByName('modifier_frozen_heroes')
	end
	
	CustomGameEventManager:RegisterListener("best_worst_stats_selected_abilities", BestWorstStatsListener)
end