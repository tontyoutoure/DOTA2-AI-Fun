LinkLuaModifier("modifier_ramza_arithmetician_soulbind", "heroes/ramza/ramza_arithmetician_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_arithmetician_exp_boost", "heroes/ramza/ramza_arithmetician_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_arithmetician_accrue_exp", "heroes/ramza/ramza_arithmetician_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("", "heroes/ramza/ramza_arithmetician_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

RamzaArithmeticianSoulbindApply = function(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_arithmetician_soulbind", {})
end


RamzaArithmeticianAccrueEXPApply = function(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_arithmetician_accrue_exp", {})
end

RamzaArithmeticianEXPBoostApply = function(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_arithmetician_exp_boost", {})
end


local RamzaArithmeticksCalculateDamage = function(tFactors, tValues, fIntelligence)
	local fRet = 0
	for i = 1, #tFactors do
		for j = 1, #tValues do
			if tValues[j]%tFactors[i] == 0 then
				fRet = fRet+1
			end
		end
	end
	fRet = fRet*fIntelligence
	return fRet
end

RamzaArithmeticianArithmeticks = function(keys)
	local sName = keys.ability:GetName()
	ProcsArroundingMagicStick(keys.caster)
	local tEnemyHeros = {}
	for i = 0, PlayerResource:GetPlayerCount()-1 do 
		local hHero = PlayerResource:GetPlayer(i):GetAssignedHero()
		if keys.caster:GetTeamNumber() ~= hHero:GetTeamNumber() then
			table.insert(tEnemyHeros, hHero)
		end
	end
	
	local iRamzaArithmeticianLevel = keys.caster.hRamzaJob.tJobLevels[RAMZA_JOB_ARITHMETICIAN]
	for k, v in pairs(tEnemyHeros) do
		local damageTable = {
			ability = keys.ability,
			victim = v,
			attacker = keys.caster,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS
		}
		local iMoveSpeed = math.ceil(v:GetIdealSpeed())
		local iLevel = v:GetLevel()
		local iEXP = PlayerResource:GetTotalEarnedXP(v:GetPlayerID())
		local tFactors = {}
		local tValues = {iMoveSpeed}
		damageTable.damage = iMoveSpeed
		if sName ~= "ramza_arithmetician_arithmeticks_CT" then table.insert(tFactors, 5) end
		if sName ~= "ramza_arithmetician_arithmeticks_CT" and sName ~= "ramza_arithmetician_arithmeticks_multiple_of_5" then 
			table.insert(tValues, iLevel) 
			damageTable.damage = damageTable.damage+iLevel*10
		end
		if sName ~= "ramza_arithmetician_arithmeticks_CT" and sName ~= "ramza_arithmetician_arithmeticks_multiple_of_5" and sName ~= "ramza_arithmetician_arithmeticks_level" then table.insert(tFactors, 4) end
		if sName == "ramza_arithmetician_arithmeticks_multiple_of_3" or sName == "ramza_arithmetician_arithmeticks_exp" then table.insert(tFactors, 3) end
		if sName == "ramza_arithmetician_arithmeticks_exp" then 
			table.insert(tValues, iEXP)
			damageTable.damage = damageTable.damage+iEXP
		end
		
		damageTable.damage = damageTable.damage+RamzaArithmeticksCalculateDamage(tFactors, tValues, keys.caster:GetIntellect())
		ApplyDamage(damageTable)
	end
end