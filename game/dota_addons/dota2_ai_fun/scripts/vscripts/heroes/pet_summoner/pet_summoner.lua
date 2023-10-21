LinkLuaModifier("modifier_pet_summoner_critters", "heroes/pet_summoner/pet_summoner_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pet_summoner_mittens_meow_aura", "heroes/pet_summoner/pet_summoner_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pet_summoner_mittens_meow", "heroes/pet_summoner/pet_summoner_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pet_summoner_fix_boo_boo_shield", "heroes/pet_summoner/pet_summoner_modifiers.lua", LUA_MODIFIER_MOTION_NONE)


function PetSummonerCritters (keys)
	ProcsArroundingMagicStick(keys.caster)
	local tTargets
	local iOwnerID = keys.caster:GetPlayerOwnerID()
	local iDuration = keys.ability:GetSpecialValueFor("duration")
	if keys.caster:HasScepter() then
		tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.caster:GetAbsOrigin(), none, 99999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE , FIND_UNITS_EVERYWHERE, false)
		for k, v in pairs(tTargets) do
			v:AddNewModifier(keys.caster, keys.ability, "modifier_pet_summoner_critters", {Duration = iDuration*CalculateStatusResist(v)})
			v:EmitSound("DOTA_Item.Sheepstick.Activate")
		end
	else
		tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.caster:GetAbsOrigin(), none, 99999, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE , FIND_UNITS_EVERYWHERE, false)
		for k, v in pairs(tTargets) do
			if v:GetPlayerOwnerID() ~= iOwnerID then
				v:AddNewModifier(keys.caster, keys.ability, "modifier_pet_summoner_critters", {Duration = iDuration*CalculateStatusResist(v)})
				v:EmitSound("DOTA_Item.Sheepstick.Activate")
			end
		end
	end
end

function PetSummonerMittensMeowApply (keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_pet_summoner_mittens_meow_aura", {})
end

function PetSummonerFixBooBoo(keys)
	ProcsArroundingMagicStick(keys.caster)
	local iOwnerID = keys.caster:GetPlayerOwnerID()
	local iHeal = keys.ability:GetSpecialValueFor("heal")
	local bHasShard = CheckShard(keys.caster)
	if bHasShard then iHeal = iHeal + keys.ability:GetSpecialValueFor("extra_heal_shard") end
	local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.caster:GetAbsOrigin(), none, 99999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE , FIND_UNITS_EVERYWHERE, false)
	for k, v in pairs(tTargets) do
		if v:GetPlayerOwnerID() == iOwnerID then
		
			local fHealAmount
			local fShield = 0
			if v:GetMaxHealth()-v:GetHealth() > iHeal then
				fHealAmount = iHeal
			else
				fHealAmount = v:GetMaxHealth()-v:GetHealth()
				fShield = iHeal-fHealAmount
				if bHasShard then v:AddNewModifier(keys.caster, keys.ability, "modifier_pet_summoner_fix_boo_boo_shield", {Duration = keys.ability:GetSpecialValueFor("shield_duration_shard"), fShield = fShield}) end
			end
			v:Heal(fHealAmount, keys.caster)
			v:EmitSound("Hero_Windrunner.BlowYouAKiss")
			ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/wr_taunt_kiss_heart.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
			-- if fHealAmount > 0 then
			-- 	iParticle = ParticleManager:CreateParticleForPlayer("particles/msg_fx/msg_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, v, v:GetPlayerOwner())
			-- 	ParticleManager:SetParticleControl(iParticle, 1, Vector(10, fHealAmount, 0))
			-- 	ParticleManager:SetParticleControl(iParticle, 2, Vector(1, math.floor(math.log10(fHealAmount))+2,0))
			-- 	ParticleManager:SetParticleControl(iParticle, 3, Vector(60, 255, 60))
			-- end
		end
	end
end

function PetSummonerPets(keys)
	ProcsArroundingMagicStick(keys.caster)
	keys.caster:EmitSound("DOTA_Item.Necronomicon.Activate")
	keys.caster.tSummons = keys.caster.tSummons or {}	
	
	
	if not keys.caster:FindAbilityByName("special_bonus_pet_summoner_1") or keys.caster:FindAbilityByName("special_bonus_pet_summoner_1"):GetLevel() == 0 then
		if keys.caster.tSummons.hMouMou and not keys.caster.tSummons.hMouMou:IsNull() and keys.caster.tSummons.hMouMou:IsAlive() then keys.caster.tSummons.hMouMou:ForceKill(false) end
		if keys.caster.tSummons.hSnowball and not keys.caster.tSummons.hSnowball:IsNull() and keys.caster.tSummons.hSnowball:IsAlive() then keys.caster.tSummons.hSnowball:ForceKill(false) end
		if keys.caster.tSummons.hTequila and not keys.caster.tSummons.hTequila:IsNull() and keys.caster.tSummons.hTequila:IsAlive() then keys.caster.tSummons.hTequila:ForceKill(false) end
	end
	local vSummonSpot = keys.caster:GetOrigin()+keys.caster:GetForwardVector():Normalized()*150
	local sLevel = tostring(keys.ability:GetLevel())
	keys.caster.tSummons.hMouMou = CreateUnitByName("npc_pet_summoner_mou_mou_lv_"..sLevel, vSummonSpot, true, keys.caster, keys.caster, keys.caster:GetTeamNumber())
	keys.caster.tSummons.hSnowball = CreateUnitByName("npc_pet_summoner_snowball_lv_"..sLevel, vSummonSpot, true, keys.caster, keys.caster, keys.caster:GetTeamNumber())
	keys.caster.tSummons.hTequila = CreateUnitByName("npc_pet_summoner_tequila_lv_"..sLevel, vSummonSpot, true, keys.caster, keys.caster, keys.caster:GetTeamNumber())
	keys.caster.tSummons.hMouMou:SetControllableByPlayer(keys.caster:GetPlayerOwnerID(), true)
	keys.caster.tSummons.hSnowball:SetControllableByPlayer(keys.caster:GetPlayerOwnerID(), true)
	keys.caster.tSummons.hTequila:SetControllableByPlayer(keys.caster:GetPlayerOwnerID(), true)
	FindClearSpaceForUnit(keys.caster.tSummons.hMouMou, keys.caster.tSummons.hMouMou:GetOrigin(), true)
	FindClearSpaceForUnit(keys.caster.tSummons.hSnowball, keys.caster.tSummons.hSnowball:GetOrigin(), true)
	keys.caster.tSummons.hMouMou:SetForwardVector(keys.caster:GetForwardVector())
	keys.caster.tSummons.hSnowball:SetForwardVector(keys.caster:GetForwardVector())
	keys.caster.tSummons.hTequila:SetForwardVector(keys.caster:GetForwardVector())
	
	if not keys.caster:FindAbilityByName("special_bonus_pet_summoner_2") or keys.caster:FindAbilityByName("special_bonus_pet_summoner_2"):GetLevel() == 0 then
		keys.caster.tSummons.hMouMou:AddNewModifier(keys.caster, keys.ability, "modifier_kill", {Duration = keys.ability:GetSpecialValueFor("duration")})
		keys.caster.tSummons.hSnowball:AddNewModifier(keys.caster, keys.ability, "modifier_kill", {Duration = keys.ability:GetSpecialValueFor("duration")})
		keys.caster.tSummons.hTequila:AddNewModifier(keys.caster, keys.ability, "modifier_kill", {Duration = keys.ability:GetSpecialValueFor("duration")})
	end
	
end

function PetSummonerPetRemoveInvisible (keys)
	if keys.target:HasModifier('modifier_invisible') then keys.target:RemoveModifierByName("modifier_invisible") end
	keys.ability:UseResources(true, true, true, true)
	keys.target.iLastAttackTime = Time()
end


function PetSummonerPetInvisibleCheck(keys)
	if not keys.target:HasModifier('modifier_invisible') and keys.ability:IsCooldownReady() then 
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_invisible", {}) 
	end
end

function PetSummonerTequilaFrostAttackTargetCheck(keys)
	if keys.target:IsBuilding() then return end
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_pet_summoner_tequila_frost_attack_slow", {Duration = keys.ability:GetSpecialValueFor("duration")})
end

function PetSummonerTequilaFrostAttackTargetCheck(keys)
	if keys.target:IsBuilding() then return end
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_pet_summoner_tequila_frost_attack_slow", {Duration = keys.ability:GetSpecialValueFor("duration")})
end

function PetSummonerMoumouBiteTargetCheck(keys)
	if keys.target:IsBuilding() then return end
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_pet_summoner_mou_mou_bite", {Duration = keys.ability:GetSpecialValueFor("duration")})
	keys.target:EmitSound("DOTA_Item.Maim")
end