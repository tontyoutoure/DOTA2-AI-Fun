LinkLuaModifier("modifier_conjurer_water_element", "heroes/conjurer/conjurer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjurer_phoenix_immolation_aura", "heroes/conjurer/conjurer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjurer_phoenix_immolation", "heroes/conjurer/conjurer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjurer_phoenix_splash", "heroes/conjurer/conjurer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjurer_phoenix_reincarnation", "heroes/conjurer/conjurer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjurer_phoenix_reincarnation_phoenix", "heroes/conjurer/conjurer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjurer_phoenix_reincarnation_egg", "heroes/conjurer/conjurer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjurer_golem_hardened_skin", "heroes/conjurer/conjurer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjurer_golem_split", "heroes/conjurer/conjurer_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

conjurer_water_elemental = class({})
function conjurer_water_elemental:OnSpellStart()
	local iCount = self:GetSpecialValueFor("summon_count")
	local hCaster = self:GetCaster()
	local vSummonerPostion = hCaster:GetOrigin()
	local vForward = hCaster:GetForwardVector()
	hCaster:EmitSound("Hero_Morphling.Replicate")
	for i = 1, iCount do
		local vSummonSpot = vSummonerPostion+vForward:Normalized()*150
		local sName = "conjurer_water_elemental_lv_"..tostring(self:GetLevel())
		local hUnit = CreateUnitByName(sName, vSummonSpot, true, hCaster, hCaster, hCaster:GetTeamNumber())
		hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
		FindClearSpaceForUnit(hUnit, hUnit:GetOrigin(), true)
		hUnit:SetForwardVector(vForward)
		hUnit:AddNewModifier(hCaster, self, "modifier_kill", {Duration = self:GetSpecialValueFor("duration")})
		hUnit:AddNewModifier(hCaster, self, "modifier_conjurer_water_element", {})
		if hCaster:HasAbility("special_bonus_unique_conjurer_1") then
			hUnit:FindModifierByName("modifier_conjurer_water_element"):SetStackCount(hCaster:FindAbilityByName("special_bonus_unique_conjurer_1"):GetSpecialValueFor("value"))
		end
		ParticleManager:CreateParticle("particles/items_fx/necronomicon_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, hUnit)
	end
end

conjurer_phoenix = class({})
function conjurer_phoenix:GetCooldown(num)	
	if IsClient() then 
		if self:GetCaster():HasScepter() then
			return 80
		end
	else
		if self:GetCaster():HasScepter() then
			return self:GetLevelSpecialValueFor("cooldown_scepter", num)
		end
	end
	
	return self.BaseClass.GetCooldown(self, num)
end
function conjurer_phoenix:OnSpellStart()
	local iCount = self:GetSpecialValueFor("summon_count")
	local hCaster = self:GetCaster()
	local vSummonerPostion = hCaster:GetOrigin()
	local vForward = hCaster:GetForwardVector()
	local iHealth
	local iDamage
	local iArmor
	if hCaster:HasScepter() then
		iHealth = self:GetSpecialValueFor("hit_point_scepter")
		iDamage = self:GetSpecialValueFor("phoenix_damage_scepter")
		iArmor = self:GetSpecialValueFor("armor_scepter")
	else
		iHealth = self:GetSpecialValueFor("hit_point")
		iDamage = self:GetSpecialValueFor("phoenix_damage")
		iArmor = self:GetSpecialValueFor("armor")
	end
	hCaster:EmitSound("Hero_Phoenix.FireSpirits.Cast")
	for i = 1, iCount do
		local vSummonSpot = vSummonerPostion+vForward:Normalized()*150+Vector(RandomFloat(-50, 50), RandomFloat(-50, 50), 0)
		local hUnit = CreateUnitByName("conjurer_phoenix", vSummonSpot, true, hCaster, hCaster, hCaster:GetTeamNumber())
		hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
		FindClearSpaceForUnit(hUnit, hUnit:GetOrigin(), true)
		hUnit:SetForwardVector(vForward)
		hUnit:AddNewModifier(hCaster, self, "modifier_kill", {Duration = self:GetSpecialValueFor("duration")})
		hUnit:SetMaxHealth(iHealth)
		hUnit:SetBaseMaxHealth(iHealth)
		hUnit:SetHealth(iHealth)
		hUnit:SetBaseDamageMin(iDamage-7)
		hUnit:SetBaseDamageMax(iDamage+7)
		hUnit:SetPhysicalArmorBaseValue(iArmor)
		hUnit.iDuration = self:GetSpecialValueFor("duration")
		if hCaster:HasAbility("special_bonus_unique_conjurer_5") and hCaster:FindAbilityByName("special_bonus_unique_conjurer_5"):GetLevel() > 0 then
			hUnit:AddAbility("conjurer_phoenix_reincarnation"):SetLevel(1)
		end 
		ParticleManager:CreateParticle("particles/items_fx/necronomicon_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, hUnit)
	end
end

function ConjurerPhoenixImmolationApply(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_conjurer_phoenix_immolation_aura", {})
end

function ConjurerPhoenixSplashApply(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_conjurer_phoenix_splash", {})
end

function ConjurerPhoenixReincarnationApply(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_conjurer_phoenix_reincarnation", {})
end

function ConjurerGolemHardenedSkinApply(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_conjurer_golem_hardened_skin", {})
end

function ConjurerGolemSplitApply(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_conjurer_golem_split", {})
end

conjurer_golem_hurl_boulder=class({})
function conjurer_golem_hurl_boulder:OnSpellStart()
	local info = 
	{
		Target = self:GetCursorTarget(),
		Source = self:GetCaster(),
		Ability = self,	
		EffectName = "particles/neutral_fx/mud_golem_hurl_boulder.vpcf",
		iMoveSpeed = self:GetSpecialValueFor("fly_speed"),
		vSourceLoc= self:GetCaster():GetAbsOrigin(),                -- Optional (HOW)
		bDrawsOnMinimap = false,                          -- Optional
		bDodgeable = true,                                -- Optional
		bIsAttack = false,                                -- Optional
		bVisibleToEnemies = true,                         -- Optional
		bReplaceExisting = false,                         -- Optional
		flExpireTime = GameRules:GetGameTime() + 20,      -- Optional but recommended
		bProvidesVision = false,                           -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)
	self:GetCaster():EmitSound("n_mud_golem.Boulder.Cast")
end

function conjurer_golem_hurl_boulder:OnProjectileHit(hTarget, vLocation)	
	if hTarget:TriggerSpellAbsorb( self ) then return end
	local damageTable = {
		damage = self:GetSpecialValueFor("damage"),
		damage_type = DAMAGE_TYPE_MAGICAL,
		victim = hTarget,
		attacker = self:GetCaster(),
		ability = self
	}
	ApplyDamage(damageTable)
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {Duration = self:GetSpecialValueFor("stun_duration")*CalculateStatusResist(hTarget)})
	hTarget:EmitSound("n_mud_golem.Boulder.Target")
end

function ConjurerGolemColorLinstener(keys)
	if IsClient() then return end
	local hUnit = EntIndexToHScript(keys.entindex) 
	if hUnit:GetUnitName() == "conjurer_golem_lv_2" then
		hUnit:SetRenderColor(15, 82, 186)
	end
	if hUnit:GetUnitName() == "conjurer_golem_lv_3" then
		hUnit:SetRenderColor(224, 17, 95)
	end
	if hUnit:GetUnitName() == "conjurer_golem_lv_4" then
		ParticleManager:CreateParticle("particles/econ/events/league_teleport_2014/teleport_ring_league_silver_glow.vpcf", PATTACH_ABSORIGIN_FOLLOW, hUnit)
		ParticleManager:CreateParticle("particles/econ/events/league_teleport_2014/teleport_ring_league_silver_glow.vpcf", PATTACH_ABSORIGIN_FOLLOW, hUnit)
		ParticleManager:CreateParticle("particles/econ/events/league_teleport_2014/teleport_ring_league_silver_glow.vpcf", PATTACH_ABSORIGIN_FOLLOW, hUnit)
		ParticleManager:CreateParticle("particles/econ/events/league_teleport_2014/teleport_ring_league_silver_glow.vpcf", PATTACH_ABSORIGIN_FOLLOW, hUnit)
	end
end

ListenToGameEvent('npc_spawned', ConjurerGolemColorLinstener, nil)
	
conjurer_summon_golem = class({})
function conjurer_summon_golem:OnSpellStart()
	local iCount = self:GetSpecialValueFor("summon_count")
	local hCaster = self:GetCaster()
	local vSummonerPostion = hCaster:GetOrigin()
	local vForward = hCaster:GetForwardVector()
	hCaster:EmitSound("n_mud_golem.Boulder.Cast")
	hCaster:EmitSound("n_mud_golem.Boulder.Target")
	for i = 1, iCount do
		local vSummonSpot = vSummonerPostion+vForward:Normalized()*150
		local sName = "conjurer_golem_lv_"..tostring(self:GetLevel())
		local hUnit = CreateUnitByName(sName, vSummonSpot, true, hCaster, hCaster, hCaster:GetTeamNumber())
		hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
		FindClearSpaceForUnit(hUnit, hUnit:GetOrigin(), true)
		hUnit:SetForwardVector(vForward)
		hUnit.iDuration = self:GetSpecialValueFor("duration")
		hUnit:AddNewModifier(hCaster, self, "modifier_kill", {Duration = hUnit.iDuration}) 
		if hCaster:HasAbility("special_bonus_unique_conjurer_3") and hCaster:FindAbilityByName("special_bonus_unique_conjurer_3"):GetLevel() > 0 and self:GetLevel() > 1 then
			hUnit:AddAbility("conjurer_golem_split"):SetLevel(1)
		end 
	end
end

conjurer_conjure_image = class({})
local tAddModifierList = {"modifier_dragon_knight_dragon_form", "modifier_lone_druid_true_form", "modifier_terrorblade_metamorphosis", "modifier_legion_commander_duel_damage_boost", "modifier_silencer_int_steal", "modifier_pudge_flesh_heap", "modifier_item_armlet_unholy_strength"}
function conjurer_conjure_image:OnSpellStart()
	local iCount = self:GetSpecialValueFor("illusion_count")
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local sName = hTarget:GetUnitName()
	local vSummonerPostion = hCaster:GetOrigin()
	local vForward = hCaster:GetForwardVector()
	local iOutgoingDamage = self:GetLevelSpecialValueFor( "illusion_outgoing_damage", self:GetLevel() - 1 )
	local iIncomingDamage = self:GetLevelSpecialValueFor( "illusion_incoming_damage", self:GetLevel() - 1 )
	local iDuration = self:GetSpecialValueFor("illusion_duration")
	if hTarget:IsHero() then
		local tIllusions = CreateIllusions(hCaster, hTarget, {outgoing_damage = iOutgoingDamage-100, incoming_damage=iIncomingDamage-100, duration = iDuration, bounty_base = 0, bounty_growth=2}, iCount, 1, true, true);
	else
		for i = 1, iCount do	
			local vSummonSpot = vSummonerPostion+vForward:Normalized()*150
			
			local hIllusion = CreateUnitByName(sName, vSummonSpot, true, hCaster, hTarget, hCaster:GetTeamNumber())
			hIllusion:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
			hIllusion:SetMaxHealth(hTarget:GetMaxHealth())
			hIllusion:SetMaxMana(hTarget:GetMaxMana())
			hIllusion:SetMaximumGoldBounty(0)
			hIllusion:SetMinimumGoldBounty(0)
			hIllusion:SetBaseDamageMax(hTarget:GetBaseDamageMax())
			hIllusion:SetBaseDamageMin(hTarget:GetBaseDamageMin())
			hIllusion:SetHealth(hTarget:GetHealth())
			hIllusion:SetMana(hTarget:GetHealth())
			hIllusion:AddNewModifier(hCaster, self, "modifier_illusion", { duration = iDuration, outgoing_damage = iOutgoingDamage-100, incoming_damage = iIncomingDamage-100 })
			hIllusion:MakeIllusion()
		end
	end
end




 