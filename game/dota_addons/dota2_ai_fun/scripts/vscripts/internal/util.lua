local CHARGE_RADIUS = 1200

function IsDebugSpewOn()
	local spew = Convars:GetInt('dota2aifun_spew') or -1
	if spew == -1 and DOTA2_AI_FUN_SPEW then
		spew = 1
	end

	if spew == 1 then
		return true
	end
	return false
end


function DebugPrint(...)
	local spew = Convars:GetInt('dota2aifun_spew') or -1
	if spew == -1 and DOTA2_AI_FUN_SPEW then
		spew = 1
	end

	if spew == 1 then
		print(...)
	end
end

function DebugPrintTable(...)
	local spew = Convars:GetInt('dota2aifun_spew') or -1
	if spew == -1 and DOTA2_AI_FUN_SPEW then
		spew = 1
	end

	if spew == 1 then
		PrintTable(...)
	end
end

if IsInToolsMode() then
	function PrintTable(t, indent, fileHandle, done)
		--print ( string.format ('PrintTable type %s', type(keys)) )
		if type(t) ~= "table" then return end

		done = done or {}
		done[t] = true
		indent = indent or 0
		fileHandle = fileHandle or io.stdout
		local l = {}
		for k, v in pairs(t) do
			table.insert(l, k)
		end

		table.sort(l)
		for k, v in ipairs(l) do
			-- Ignore FDesc
			if v ~= 'FDesc' then
				local value = t[v]

				if type(value) == "table" and not done[value] then
					done [value] = true
					if fileHandle == io.stdout then 
						print(string.rep ("\t", indent)..tostring(v)..":")
					end
					fileHandle:write(string.rep ("\t", indent)..tostring(v)..":".."\n")
					PrintTable (value, indent + 2, fileHandle, done)
				elseif type(value) == "userdata" and not done[value] then
					done [value] = true
					if fileHandle == io.stdout then
						print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
					end
					fileHandle:write(string.rep ("\t", indent)..tostring(v)..": "..tostring(value).."\n")
					PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, fileHandle, done)
				else
					if t.FDesc and t.FDesc[v] then
						if fileHandle == io.stdout then
							print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
						end
						fileHandle:write(string.rep ("\t", indent)..tostring(t.FDesc[v]).."\n")
					else
						if fileHandle == io.stdout then
							print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
						end
						fileHandle:write(string.rep ("\t", indent)..tostring(v)..": "..tostring(value).."\n")
					end
				end
			end
		end
	end
else
	function PrintTable(t, indent, done)
	  --print ( string.format ('PrintTable type %s', type(keys)) )
	  if type(t) ~= "table" then return end

	  done = done or {}
	  done[t] = true
	  indent = indent or 0

	  local l = {}
	  for k, v in pairs(t) do
		table.insert(l, k)
	  end

	  table.sort(l)
	  for k, v in ipairs(l) do
		-- Ignore FDesc
		if v ~= 'FDesc' then
		  local value = t[v]

		  if type(value) == "table" and not done[value] then
			done [value] = true
			print(string.rep ("\t", indent)..tostring(v)..":")
			PrintTable (value, indent + 2, done)
		  elseif type(value) == "userdata" and not done[value] then
			done [value] = true
			print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
			PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
		  else
			if t.FDesc and t.FDesc[v] then
			  print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
			else
			  print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
			end
		  end
		end
	  end
	end
end
-- Colors
COLOR_NONE = '\x06'
COLOR_GRAY = '\x06'
COLOR_GREY = '\x06'
COLOR_GREEN = '\x0C'
COLOR_DPURPLE = '\x0D'
COLOR_SPINK = '\x0E'
COLOR_DYELLOW = '\x10'
COLOR_PINK = '\x11'
COLOR_RED = '\x12'
COLOR_LGREEN = '\x15'
COLOR_BLUE = '\x16'
COLOR_DGREEN = '\x18'
COLOR_SBLUE = '\x19'
COLOR_PURPLE = '\x1A'
COLOR_ORANGE = '\x1B'
COLOR_LRED = '\x1C'
COLOR_GOLD = '\x1D'


function DebugAllCalls()
		if not GameRules.DebugCalls then
				print("Starting DebugCalls")
				GameRules.DebugCalls = true

				debug.sethook(function(...)
						local info = debug.getinfo(2)
						local src = tostring(info.short_src)
						local name = tostring(info.name)
						if name ~= "__index" then
								print("Call: ".. src .. " -- " .. name .. " -- " .. info.currentline)
						end
				end, "c")
		else
				print("Stopped DebugCalls")
				GameRules.DebugCalls = false
				debug.sethook(nil, "c")
		end
end




--[[Author: Noya
	Date: 09.08.2015.
	Hides all dem hats
]]
function HideWearables( hero )
	local children = hero:GetChildren()
	for k,child in pairs(children) do
	   if child:GetClassname() == "dota_item_wearable" then
		   child:AddEffects(EF_NODRAW)
	   end
	end
end

function ShowWearables( unit )

	for i,v in pairs(unit.hiddenWearables) do
		v:RemoveEffects(EF_NODRAW)
	end
end

--[[Autohor: tontyoutoure
	Date:08.01.2017
	Print all modifiers
]]

function PrintAllModifiers( PlayerID )
	local tModifiers = PlayerResource:GetPlayer(PlayerID):GetAssignedHero():FindAllModifiers()
	for i, v in pairs(tModifiers) do print(v:GetName()) end

end


function PrintAllAbilities( PlayerID )
	local tModifiers = PlayerResource:GetPlayer(PlayerID):GetAssignedHero():FindAllModifiers()
	for i = 0, 23 do
		if PlayerResource:GetPlayer(PlayerID):GetAssignedHero():GetAbilityByIndex(i) then
			print(PlayerResource:GetPlayer(PlayerID):GetAssignedHero():GetAbilityByIndex(i):GetName())
		end
	end

end

function Vector2D(v3D)
	return Vector(Vector(0,0,0).Dot(Vector(1,0,0), v3D), Vector(0,0,0).Dot(Vector(0,1,0), v3D),0)
end

function CalculateStatusResist(hUnit)
	return 1-hUnit:GetStatusResistance()
end

function ProcsArroundingMagicStick(hUnit)
	local tUnits =  FindUnitsInRadius(hUnit:GetTeamNumber(), hUnit:GetOrigin(), nil, CHARGE_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
	for i, v in ipairs(tUnits) do
	 if v:CanEntityBeSeenByMyTeam(hUnit) then
		for i = 0, 9 do
			if v:GetItemInSlot(i) and v:GetItemInSlot(i):GetName() == "item_magic_stick" then
				CHARGE_RADIUS = v:GetItemInSlot(i):GetSpecialValueFor("charge_radius")
				if v:GetItemInSlot(i):GetCurrentCharges() < v:GetItemInSlot(i):GetSpecialValueFor("max_charges") then
					v:GetItemInSlot(i):SetCurrentCharges(v:GetItemInSlot(i):GetCurrentCharges()+1)
					break
				end
			end
			if v:GetItemInSlot(i) and v:GetItemInSlot(i):GetName() == "item_magic_wand" then
				CHARGE_RADIUS = v:GetItemInSlot(i):GetSpecialValueFor("charge_radius")
				if v:GetItemInSlot(i):GetCurrentCharges() < v:GetItemInSlot(i):GetSpecialValueFor("max_charges") then
					v:GetItemInSlot(i):SetCurrentCharges(v:GetItemInSlot(i):GetCurrentCharges()+1)
					break
				end
			end
		end
	 end
	end
end

function CheckTalent(hHero, sTalentName)
	if hHero:HasAbility(sTalentName) then return hHero:FindAbilityByName(sTalentName):GetSpecialValueFor("value") end
	return 0
end

function GetExtraCastRange(hHero)
	local iExtraRange = 0
	local bCalculatedAetherLens = false
	for _, v in ipairs(hHero:FindAllModifiers()) do
		if v:GetName() == "modifier_special_bonus_cast_range" then
			iExtraRange = iExtraRange+v:GetAbility():GetSpecialValueFor("value")
		end
		if v:GetName() == "modifier_item_aether_lens" and not bCalculatedAetherLens then
			iExtraRange = iExtraRange+v:GetAbility():GetSpecialValueFor("cast_range_bonus")
			bCalculatedAetherLens = true
		end
		
	end
	return iExtraRange
end

function PersueUnit(hCaster, hTarget, fExtraLife, bFullLife, sSound, sParticle)
	local vLocation = hTarget:GetAbsOrigin()
	local sName = hTarget:GetUnitName()
	local fHealth = hTarget:GetHealth()
	local fMaxHealth = hTarget:GetMaxHealth()+fExtraLife
	local fAttackMin = hTarget:GetBaseDamageMin()
	local fAttackMax = hTarget:GetBaseDamageMax()
	local iGoldBountyMin = hTarget:GetMinimumGoldBounty()
	local iGoldBountyMax = hTarget:GetMaximumGoldBounty()
	UTIL_Remove(hTarget)
	local hNewUnit = CreateUnitByName(sName, vLocation, true, hCaster, nil, hCaster:GetTeamNumber())
	hNewUnit:SetOwner(hCaster)
	hNewUnit:SetBaseDamageMin(fAttackMin)
	hNewUnit:SetBaseDamageMax(fAttackMax)
	hNewUnit:SetMaxHealth(fMaxHealth)
	hNewUnit:SetBaseMaxHealth(fMaxHealth)
	hNewUnit:SetMinimumGoldBounty(iGoldBountyMin)
	hNewUnit:SetMaximumGoldBounty(iGoldBountyMax)
	if bFullLife then
		hNewUnit:SetHealth(fMaxHealth)
	else
		hNewUnit:SetHealth(fHealth)
	end	
	hNewUnit:SetControllableByPlayer(hCaster:GetPlayerID(), true)
	hNewUnit:EmitSound(sSound)
	ParticleManager:CreateParticle(sParticle, PATTACH_ABSORIGIN_FOLLOW, hNewUnit)
end


local brokenPassiveModifierAbilities = {
	drow_ranger_marksmanship = "modifier_drow_ranger_marksmanship",
	juggernaut_blade_dance = "modifier_juggernaut_blade_dance",
	legion_commander_moment_of_courage = "modifier_legion_commander_moment_of_courage",
	axe_counter_helix = "modifier_axe_counter_helix",
	abaddon_frostmourne = "modifier_abaddon_frostmourne",
	monkey_king_jingu_mastery = "modifier_monkey_king_quadruple_tap",
	necrolyte_heartstopper_aura = "modifier_necrolyte_heartstopper_aura",
	lina_fiery_soul = "modifier_lina_fiery_soul",
	visage_gravekeepers_cloak = "modifier_visage_gravekeepers_cloak",

}

function AddAbilitySafely(hHero, sAbility)
	print(sAbility)
	local hAbility = hHero:AddAbility(sAbility)
	local hSecondary
	if hAbility:GetAssociatedSecondaryAbilities() then
		hSecondary = hHero:AddAbility(hAbility:GetAssociatedSecondaryAbilities())
		hSecondary:SetHidden(true)
	end
	if hAbility:GetAssociatedPrimaryAbilities() then
		hHero:AddAbility(hAbility:GetAssociatedPrimaryAbilities())
	end
	if brokenPassiveModifierAbilities[sAbility] then
		Timer(0.1, function()
			if hHero:HasAbility(sAbility) then
				hHero:RemoveModifierByName(brokenPassiveModifierAbilities[sAbility])
				hHero:AddNewModifier(hHero, hHero:FindAbilityByName(sAbility), brokenPassiveModifierAbilities[sAbility], {})
			end
		end)
	end
end

function FixAbilities(hHero)
	local iShowdAbilities = 0
	for i = 0, 23 do
		if hHero:GetAbilityByIndex(i) and not hHero:GetAbilityByIndex(i):IsHidden() then
			if not hHero:GetAbilityByIndex(i):IsAttributeBonus() then
				iShowdAbilities = iShowdAbilities+1
			end
			if hHero:GetAbilityByIndex(i):GetAssociatedSecondaryAbilities() and not hHero:HasAbility(hHero:GetAbilityByIndex(i):GetAssociatedSecondaryAbilities()) then
				hHero:AddAbility(hHero:GetAbilityByIndex(i):GetAssociatedSecondaryAbilities()):SetHidden(true)
			end
		end
		for _, v1 in ipairs(hHero:FindAllModifiers()) do
			if hHero:GetAbilityByIndex(i) and string.match(v1:GetName(), hHero:GetAbilityByIndex(i):GetName()) then
				v1:Destroy()
			end
		end
	end
	hHero:AddNewModifier(hHero, nil, 'modifier_ability_layout_change', nil):SetStackCount(iShowdAbilities)
end

function ApplyDamageTestDummy(keys)
	if keys.attacker.hDummyMaster and not keys.attacker.hDummyMaster:IsNull() then
		keys.attacker = keys.attacker.hDummyMaster
		ApplyDamage(keys)		
	else
		ApplyDamage(keys)
	end
end

tItemTable = {0, 1, 2, 3, 4, 5, 6, 7, 8, 15}
print("Util loaded")

 