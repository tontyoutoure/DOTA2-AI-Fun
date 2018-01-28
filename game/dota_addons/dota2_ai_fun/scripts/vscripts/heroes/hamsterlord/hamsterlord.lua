LinkLuaModifier("modifier_hamsterlord_injure_knees_slow", "heroes/hamsterlord/hamsterlord_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hamsterlord_injure_knees", "heroes/hamsterlord/hamsterlord_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hamsterlord_injure_knees_stun", "heroes/hamsterlord/hamsterlord_modifiers.lua", LUA_MODIFIER_MOTION_VERTICAL)
LinkLuaModifier("modifier_hamsterlord_take_nap", "heroes/hamsterlord/hamsterlord_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hamsterlord_take_nap_buff", "heroes/hamsterlord/hamsterlord_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hamsterlord_hamster_courage_of_the_hamster", "heroes/hamsterlord/hamsterlord_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hamsterlord_hamster_terror_of_the_hamster", "heroes/hamsterlord/hamsterlord_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hamsterlord_hamster_courage_of_the_hamster_buff", "heroes/hamsterlord/hamsterlord_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hamsterlord_hamster_terror_of_the_hamster_debuff", "heroes/hamsterlord/hamsterlord_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hamsterlord_hamster_flaming_hamster_grenade", "heroes/hamsterlord/hamsterlord_modifiers.lua", LUA_MODIFIER_MOTION_BOTH)


function HamsterlordPizzaHouseDeliverBoyGatherTips( keys )
	if keys.caster:PassivesDisabled() then return end	
	local iGold = keys.ability:GetSpecialValueFor("tip_per_hit")
	PlayerResource:ModifyGold(keys.caster:GetOwner():GetPlayerID(), iGold, false, DOTA_ModifyGold_Unspecified)
	local iParticle1 = ParticleManager:CreateParticle("particles/msg_fx/msg_gold.vpcf", PATTACH_POINT_FOLLOW, keys.caster)
	ParticleManager:SetParticleControl(iParticle1, 1, Vector(0, iGold, 0))
	ParticleManager:SetParticleControl(iParticle1, 2, Vector(1, math.floor(math.log10(iGold))+2, 100))
	ParticleManager:SetParticleControl(iParticle1, 3, Vector(255, 230, 0))
end

hamsterlord_injure_knees = class({})
function hamsterlord_injure_knees:OnUpgrade()
	local hCaster = self:GetCaster()
	if hCaster:IsIllusion() then return end
	hCaster:AddNewModifier(hCaster, self, "modifier_hamsterlord_injure_knees", {})
end

hamsterlord_take_nap = class({})
function hamsterlord_take_nap:OnSpellStart()	
	local hCaster = self:GetCaster()
	tOrder = {
		UnitIndex = hCaster:entindex(),
		OrderType = DOTA_UNIT_ORDER_STOP 
	}
	ExecuteOrderFromTable(tOrder)
	hCaster:AddNewModifier(hCaster, self, "modifier_hamsterlord_take_nap" , {Duration = self:GetSpecialValueFor("max_nap_time")})
end

hamsterlord_pizza_house_delivery = class({})
function hamsterlord_pizza_house_delivery:OnSpellStart()
	local iSummonCount = self:GetSpecialValueFor("summon_count")
	local hCaster = self:GetCaster()
	local vSummonerPostion = hCaster:GetOrigin()
	local vForward = hCaster:GetForwardVector()
	hCaster:EmitSound("DOTA_Item.Necronomicon.Activate")
	for i = 1, iSummonCount do
		local vSummonSpot = vSummonerPostion+vForward:Normalized()*150
		local hUnit = CreateUnitByName("hamsterlord_pizza_house_deliver_boy", vSummonSpot, true, hCaster, hCaster, hCaster:GetTeamNumber())
		hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
		FindClearSpaceForUnit(hUnit, hUnit:GetOrigin(), true)
		hUnit:SetForwardVector(vForward)
		hUnit:AddNewModifier(hCaster, self, "modifier_kill", {Duration = self:GetSpecialValueFor("duration")})
		if hCaster:HasAbility("special_bonus_hamsterlord_2") and hCaster:FindAbilityByName("special_bonus_hamsterlord_2"):GetLevel() > 0 then
			hUnit:AddAbility("hamsterlord_pizza_house_deliver_boy_gather_tips_upgraded"):SetLevel(1)
		else
			hUnit:AddAbility("hamsterlord_pizza_house_deliver_boy_gather_tips"):SetLevel(1)
		end
		ParticleManager:CreateParticle("particles/items_fx/necronomicon_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, hUnit)
	end
end

hamsterlord_call_of_hamster = class({})
function hamsterlord_call_of_hamster:OnSpellStart()
	local iSummonCount = self:GetSpecialValueFor("summon_count")
	local hCaster = self:GetCaster()
	local vSummonerPostion = hCaster:GetOrigin()
	local vForward = hCaster:GetForwardVector()
	local iHealth = self:GetSpecialValueFor("health")
	local iArmor = self:GetSpecialValueFor("armor")
	local iDamage = self:GetSpecialValueFor("damage")
	
	if hCaster:HasScepter() then 
		iSummonCount = self:GetSpecialValueFor("summon_count_scepter")
	end
	
	if hCaster:HasAbility("special_bonus_hamsterlord_4") then
		iSummonCount = iSummonCount+hCaster:FindAbilityByName("special_bonus_hamsterlord_4"):GetSpecialValueFor("value")
	end
	for i = 1, iSummonCount do
		local vSummonSpot = vSummonerPostion+vForward:Normalized()*150
		hUnit = CreateUnitByName("hamsterlord_hamster", vSummonSpot, true, hCaster, hCaster, hCaster:GetTeamNumber())
		hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
		FindClearSpaceForUnit(hUnit, hUnit:GetOrigin(), true)
		hUnit:SetMaxHealth(iHealth)
		hUnit:SetBaseMaxHealth(iHealth)
		hUnit:SetHealth(iHealth)
		hUnit:SetPhysicalArmorBaseValue(iArmor)
		hUnit:SetBaseDamageMax(iDamage-4)
		hUnit:SetBaseDamageMin(iDamage+5)
		hUnit:SetMaximumGoldBounty(self:GetSpecialValueFor("gold_bounty"))
		hUnit:SetMinimumGoldBounty(self:GetSpecialValueFor("gold_bounty"))
		hUnit:SetForwardVector(vForward)
		if self:GetLevel() == 1 then
			hUnit:FindAbilityByName("hamsterlord_hamster_courage_of_the_hamster"):SetLevel(1)
			hUnit:FindAbilityByName("hamsterlord_hamster_terror_of_the_hamster"):SetLevel(0)
			hUnit:FindAbilityByName("hamsterlord_hamster_flaming_hamster_grenade"):SetLevel(0)
		elseif self:GetLevel() == 2 then
			hUnit:CreatureLevelUp(1)
			hUnit:FindAbilityByName("hamsterlord_hamster_courage_of_the_hamster"):SetLevel(2)
			hUnit:FindAbilityByName("hamsterlord_hamster_terror_of_the_hamster"):SetLevel(1)
			hUnit:FindAbilityByName("hamsterlord_hamster_flaming_hamster_grenade"):SetLevel(0)
		else
			hUnit:CreatureLevelUp(2)
			hUnit:FindAbilityByName("hamsterlord_hamster_courage_of_the_hamster"):SetLevel(3)
			hUnit:FindAbilityByName("hamsterlord_hamster_terror_of_the_hamster"):SetLevel(2)
			hUnit:FindAbilityByName("hamsterlord_hamster_flaming_hamster_grenade"):SetLevel(1)
		end
		if hCaster["hHamster"..tostring(i)] and not hCaster["hHamster"..tostring(i)]:IsNull() and hCaster["hHamster"..tostring(i)]:IsAlive() then 
			hCaster["hHamster"..tostring(i)]:ForceKill(false)
			hCaster["hHamster"..tostring(i)] = hUnit
		else
			hCaster["hHamster"..tostring(i)] = hUnit
		end
		
		hCaster:EmitSound("Hero_LoneDruid.SpiritBear.Cast")
		ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, hUnit)
	end
end

function HamsterlordUpgradePassive(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_"..keys.ability:GetName(), {})
end

function HamsterlordHamsterFlamingHamsterGrenade(keys)
	PrintTable(keys)
	local fDuration = 0.5
	local fHeight = 300
	local hModifier = keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_hamsterlord_hamster_flaming_hamster_grenade", {Duration = fDuration})
	hModifier.vHorizantalSpeed = (keys.target_points[1]-keys.caster:GetOrigin())/fDuration
	hModifier.vVerticalSpeed = Vector(0, 0, 2*fHeight/fDuration)
	hModifier.vVerticalAcceleration = Vector(0, 0, -4*fHeight/fDuration/fDuration)
	hModifier.vDestination = keys.target_points[1]
end
