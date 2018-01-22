LinkLuaModifier("modifier_ramza_summoner_lich", "heroes/ramza/ramza_summoner_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_summoner_odin", "heroes/ramza/ramza_summoner_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_summoner_odin_tracker", "heroes/ramza/ramza_summoner_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_summoner_shiva", "heroes/ramza/ramza_summoner_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_summoner_shiva_slow", "heroes/ramza/ramza_summoner_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_summoner_golem_slow", "heroes/ramza/ramza_summoner_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_summoner_critical_recover_mp", "heroes/ramza/ramza_summoner_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

function RamzaSummonerCriticalRecoverMPApply(keys)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_summoner_critical_recover_mp", {})
end

function RamzaSummonerLich(keys)
	ProcsArroundingMagicStick(keys.caster)
	local hThinker = CreateUnitByName("npc_dummy_unit", keys.target_points[1], true, keys.caster, keys.caster, keys.caster:GetTeamNumber())
	hThinker:SetOriginalModel("models/heroes/lich/lich.vmdl")
	local tWearables = 
	{
		{ID = "7576", style = "0", model = "models/items/lich/lich_immortal/lich_immortal.vmdl", particle_systems = {{system = "particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_ambient.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "parent", control_points = {{control_point_index = 1, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_portrait"}, {control_point_index = 0, attach_type = PATTACH_ABSORIGIN_FOLLOW, attachment = "attach_hitloc"}, }}, }},
		{ID = "8521", style = "0", model = "models/items/lich/blizzard_tyrant_head/blizzard_tyrant_head.vmdl", skin = "0", particle_systems = {}},
		{ID = "8523", style = "0", model = "models/items/lich/blizzard_tyrant_belt/blizzard_tyrant_belt.vmdl", skin = "0", particle_systems = {}},
		{ID = "8522", style = "0", model = "models/items/lich/blizzard_tyrant_back/blizzard_tyrant_back.vmdl", skin = "0", particle_systems = {{system = "particles/econ/items/lich/blizzard_of_the_tyrant/blyzard_of_the_tyrant_back_face.vpcf", attach_type = PATTACH_ABSORIGIN_FOLLOW, attach_entity = "parent", }, }},
		{ID = "8519", style = "0", model = "models/items/lich/blizzard_tyrant_arms/blizzard_tyrant_arms.vmdl", skin = "0", particle_systems = {}},
	}		
	for k, v in pairs(tWearables) do
		WearableManager:AddNewWearable(hThinker, v)
	end
	StartAnimation(hThinker, {duration = 15, activity=ACT_DOTA_GENERIC_CHANNEL_1, rate=1})
--	WearableManager:PrintAllPrecaches(hThinker)
--	WearableManager:PrintAllWearableInfos(hThinker)
	hThinker:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_summoner_lich", {Duration = keys.ability:GetSpecialValueFor("duration"), fPercentageDamage = keys.ability:GetSpecialValueFor("percentage_damage"), fRadius = keys.ability:GetSpecialValueFor("radius")})
	hThinker:SetForwardVector(keys.caster:GetForwardVector())
end
function RamzaSummonerOdin(keys)
	ProcsArroundingMagicStick(keys.caster)
	local hThinker = CreateUnitByName("npc_dummy_unit", keys.target_points[1], true, keys.caster, keys.caster, keys.caster:GetTeamNumber())
	hThinker:SetOriginalModel("models/heroes/abaddon/abaddon.vmdl")
	hThinker:SetThink(function() print("hoho") end, 0.1)
	
	local tWearables = 
	{
		{ID = "5561", style = "0", model = "models/items/abaddon/phantoms_reaper/phantoms_reaper.vmdl", particle_systems = {{system = "particles/units/heroes/hero_abaddon/abaddon_blade.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "parent", control_points = {{control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_attack1"}, }}, }},
		{ID = "6408", style = "0", model = "models/items/abaddon/alliance_abba_back/alliance_abba_back.vmdl", particle_systems = {}},
		{ID = "6409", style = "0", model = "models/items/abaddon/alliance_abba_head/alliance_abba_head.vmdl", particle_systems = {}},
		{ID = "6410", style = "0", model = "models/items/abaddon/alliance_abba_mount/alliance_abba_mount.vmdl", particle_systems = {{system = "particles/units/heroes/hero_abaddon/abaddon_ambient.vpcf", attach_type = PATTACH_ABSORIGIN_FOLLOW, attach_entity = "parent", }, }},
		{ID = "6411", style = "0", model = "models/items/abaddon/alliance_abba_shoulder/alliance_abba_shoulder.vmdl", particle_systems = {}},
	}		
	for k, v in pairs(tWearables) do
		WearableManager:AddNewWearable(hThinker, v)
	end
	hThinker:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_summoner_odin", {Duration = keys.ability:GetSpecialValueFor("delay"), fRadius = keys.ability:GetSpecialValueFor("radius")})
	hThinker:SetForwardVector(keys.caster:GetForwardVector())
end

function RamzaSummonerMoogle(keys)
	ProcsArroundingMagicStick(keys.caster)
	local hThinker = CreateUnitByName("npc_dummy_unit", keys.target_points[1], true, keys.caster, keys.caster, keys.caster:GetTeamNumber())
	hThinker:SetOriginalModel("models/items/juggernaut/ward/fortunes_tout/fortunes_tout.vmdl")
	Timers:CreateTimer(0.04, function () hThinker:SetMaterialGroup("1") end)
	hThinker:SetForwardVector(keys.caster:GetForwardVector())
	keys.ability:ApplyDataDrivenModifier(keys.caster, hThinker, "modifier_ramza_summoner_summon_moogle_aura", {})
end

function RamzaSummonerMoogleStop(keys)
	keys.target:EmitSound("Hero_Juggernaut.FortunesTout.Stop")
	keys.target:StopSound("Hero_Juggernaut.FortunesTout.Loop")
	UTIL_Remove(keys.target)
end

function RamzaSummonerShiva(keys)
	ProcsArroundingMagicStick(keys.caster)
	local hThinker = CreateUnitByName("npc_dummy_unit", keys.target_points[1], true, keys.caster, keys.caster, keys.caster:GetTeamNumber())
	hThinker:SetModel("models/heroes/crystal_maiden/crystal_maiden_arcana.vmdl")
	hThinker:SetOriginalModel("models/heroes/crystal_maiden/crystal_maiden_arcana.vmdl")
	local tWearables = {
		{ID = "7385", style = "0", model = "models/heroes/crystal_maiden/crystal_maiden_arcana_back.vmdl", particle_systems = {}},
		{ID = "6686", style = "0", model = "models/items/crystal_maiden/cowl_of_ice/cowl_of_ice.vmdl", particle_systems = {{system = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/crystal_maiden_cowl_ambient.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "self", control_points = {{control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_head"}, }}, }},
		{ID = "9205", style = "0", model = "models/items/crystal_maiden/immortal_shoulders/cm_immortal_shoulders.vmdl", particle_systems = {}},
		{ID = "6784", style = "0", model = "models/items/crystal_maiden/ward_staff/ward_staff.vmdl", particle_systems = {{system = "particles/econ/items/crystal_maiden/crystal_maiden_ward_staff/crystal_maiden_ward_staff_ambient.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "parent", control_points = {{control_point_index = 2, attach_type = PATTACH_ABSORIGIN_FOLLOW, }, {control_point_index = 1, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_staff_base"}, {control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_staff_tip"}, }}, }},
		{ID = "8398", style = "0", model = "models/items/crystal_maiden/lumini_polare_arms/lumini_polare_arms.vmdl", particle_systems = {}},
	}
	for k, v in pairs(tWearables) do
		WearableManager:AddNewWearable(hThinker, v)
	end
	StartAnimation(hThinker, {duration = 7, activity=ACT_DOTA_CAST_ABILITY_4, rate=1, translate = "wardstaff"})
	Timers:CreateTimer(7, function () UTIL_Remove(hThinker) end)
	--WearableManager:PrintAllWearableInfos(hThinker)
	hThinker:SetForwardVector(keys.caster:GetForwardVector())
	hThinker:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_summoner_shiva", {Duration = keys.ability:GetSpecialValueFor("duration"), fDamage = keys.ability:GetSpecialValueFor("damage"), fMoveSlow = keys.ability:GetSpecialValueFor("move_slow"), fAttackSlow = keys.ability:GetSpecialValueFor("attack_slow"), fSlowDuration = keys.ability:GetSpecialValueFor("slow_duration"), fRadius = keys.ability:GetSpecialValueFor("radius")})
	
	
end

function RamzaSummonerIfrit(keys)
	ProcsArroundingMagicStick(keys.caster)
	local fDelay = keys.ability:GetSpecialValueFor("delay")
	local fRadius = keys.ability:GetSpecialValueFor("radius")
	local fDamage = keys.ability:GetSpecialValueFor("damage")
	local hThinker = CreateUnitByName("npc_dummy_unit", keys.target_points[1], true, keys.caster, keys.caster, keys.caster:GetTeamNumber())
	hThinker:SetModel("models/heroes/shadow_fiend/shadow_fiend_arcana.vmdl")
	hThinker:SetOriginalModel("models/heroes/shadow_fiend/shadow_fiend_arcana.vmdl")
	local tWearables = {
		{ID = "6996", style = "0", model = "models/heroes/shadow_fiend/head_arcana.vmdl", particle_systems = {{system = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_ambient_eyes.vpcf", attach_type = PATTACH_CUSTOMORIGIN_FOLLOW, attach_entity = "parent", control_points = {{control_point_index = 2, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_eyeR"}, {control_point_index = 1, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_eyeL"}, }}, {system = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_ambient.vpcf", attach_type = PATTACH_ABSORIGIN_FOLLOW, attach_entity = "parent", control_points = {{control_point_index = 5, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_wing_L1"}, {control_point_index = 4, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_wing_L0"}, {control_point_index = 6, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_wing_L2"}, {control_point_index = 3, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_wing_R2"}, {control_point_index = 7, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_head"}, {control_point_index = 2, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_wing_R1"}, {control_point_index = 1, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_wing_R0"}, }}, }},
		{ID = "8259", style = "0", model = "models/items/shadow_fiend/arms_deso/arms_deso.vmdl", particle_systems = {{system = "particles/econ/items/shadow_fiend/sf_desolation/shadow_fiend_desolation_ambient.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "parent", control_points = {{control_point_index = 3, attach_type = PATTACH_ABSORIGIN_FOLLOW, }, {control_point_index = 1, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_arm_R"}, {control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_arm_L"}, }}, }},
		{ID = "9020", style = "0", model = "models/items/nevermore/ferrum_chiroptera_shoulder/ferrum_chiroptera_shoulder.vmdl", particle_systems = {{system = "particles/econ/items/shadow_fiend/sf_ferrum/shadow_fiend_ferrum_shoulder_ambient.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "self", control_points = {{control_point_index = 4, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_hitloc"}, {control_point_index = 3, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_arm_r"}, {control_point_index = 5, attach_type = PATTACH_ABSORIGIN_FOLLOW, }, {control_point_index = 2, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_arm_l"}, {control_point_index = 1, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_shoulder_r"}, {control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_shoulder_l"}, }}, }},
	}
	for k, v in pairs(tWearables) do
		WearableManager:AddNewWearable(hThinker, v)
	end
--	WearableManager:PrintAllWearableInfos(hThinker)
	StartAnimation(hThinker, {duration = 2.44, activity=ACT_DOTA_CAST_ABILITY_6, rate=1, translate = "arcana"})
	ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_wings.vpcf", PATTACH_ABSORIGIN_FOLLOW, hThinker)
	hThinker:EmitSound("Hero_Nevermore.ROS.Arcana.Cast")
	hThinker:EmitSound("Hero_Nevermore.ROS_Cast_Flames")
	Timers:CreateTimer(2.4, function () UTIL_Remove(hThinker) end)
	hThinker:SetForwardVector(keys.caster:GetForwardVector())
	Timers:CreateTimer(fDelay, function ()
		local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), hThinker:GetAbsOrigin(), none, fRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local damageTable = {
			damage = fDamage,
			ability = keys.ability,
			attacker = keys.caster,
			damage_type = DAMAGE_TYPE_MAGICAL
		}
		for k, v in pairs(tTargets) do
			v:EmitSound("Hero_Nevermore.Shadowraze.Arcana")
			v:EmitSound("Hero_Nevermore.Raze_Flames")
			damageTable.victim = v
			ApplyDamage(damageTable)
			ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf", PATTACH_ABSORIGIN, v)
		end
	end)
end

function RamzaSummonerRamuh(keys)
	ProcsArroundingMagicStick(keys.caster)
	local fRadius = keys.ability:GetSpecialValueFor("radius")
	local fDamage = keys.ability:GetSpecialValueFor("damage")
	local fDuration = keys.ability:GetSpecialValueFor("stun_duration")
	local hThinker = CreateUnitByName("npc_dummy_unit", keys.target_points[1], true, keys.caster, keys.caster, keys.caster:GetTeamNumber())
	hThinker:SetModel("models/heroes/zeus/zeus_arcana.vmdl")
	hThinker:SetOriginalModel("models/heroes/zeus/zeus_arcana.vmdl")
	local tWearables = {
		{ID = "6914", style = "0", model = "models/heroes/zeus/zeus_hair_arcana.vmdl", particle_systems = {{system = "particles/econ/items/zeus/arcana_chariot/zeus_arcana_chariot.vpcf", attach_type = PATTACH_ABSORIGIN_FOLLOW, attach_entity = "parent", control_points = {{control_point_index = 0, attach_type = PATTACH_ABSORIGIN_FOLLOW, }, }}, }},
		{ID = "5412", style = "0", model = "models/items/zeus/lightning_weapon/mesh/zeus_lightning_weapon_model.vmdl", particle_systems = {{system = "particles/econ/items/zeus/lightning_weapon_fx/zues_immortal_lightning_weapon.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "self", control_points = {{control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_attack1"}, }}, }},
		{ID = "9039", style = "0", model = "models/items/zuus/the_return_of_the_king_of_gods_belt/the_return_of_the_king_of_gods_belt.vmdl", skin = "1", particle_systems = {}},
		{ID = "9038", style = "0", model = "models/items/zuus/the_return_of_the_king_of_gods_arms/the_return_of_the_king_of_gods_arms.vmdl", skin = "1", particle_systems = {}},
		{ID = "9037", style = "0", model = "models/items/zuus/the_return_of_the_king_of_gods_back/the_return_of_the_king_of_gods_back.vmdl", skin = "1", particle_systems = {}},
	}
	for k, v in pairs(tWearables) do
		WearableManager:AddNewWearable(hThinker, v)
	end
--	WearableManager:PrintAllWearableInfos(hThinker)
	StartAnimation(hThinker, {duration = 1.1, activity=ACT_DOTA_CAST_ABILITY_5, rate=1, translate = "lightning"})
	hThinker:SetForwardVector(keys.caster:GetForwardVector())
	Timers:CreateTimer(0.93, function () hThinker:RemoveSelf() end)
	hThinker:EmitSound("Hero_Zuus.GodsWrath.PreCast.Arcana")
	local iParticle0 = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, hThinker)
	ParticleManager:SetParticleControlEnt(iParticle0, 0, hThinker, PATTACH_POINT_FOLLOW, "follow_origin", hThinker:GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticle0, 1, hThinker, PATTACH_POINT_FOLLOW, "follow_origin", hThinker:GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticle0, 3, hThinker, PATTACH_POINT_FOLLOW, "follow_origin", hThinker:GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticle0, 6, hThinker, PATTACH_POINT_FOLLOW, "follow_origin", hThinker:GetOrigin(), true)
	Timers:CreateTimer(0.4, function ()
		hThinker:EmitSound("Hero_Zuus.GodsWrath")
		local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), hThinker:GetAbsOrigin(), none, fRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local damageTable = {
			damage = fDamage,
			ability = keys.ability,
			attacker = keys.caster,
			damage_type = DAMAGE_TYPE_MAGICAL
		}		
		for k, v in pairs(tTargets) do
			v:EmitSound("Hero_Zuus.GodsWrath.Target")
			damageTable.victim = v
			ApplyDamage(damageTable)
			local iParticle = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath.vpcf", PATTACH_CUSTOMORIGIN, v)
			ParticleManager:SetParticleControl(iParticle, 1, v:GetAbsOrigin())
			ParticleManager:SetParticleControl(iParticle, 0, v:GetAbsOrigin()+Vector(0,0,1000))
			v:AddNewModifier(keys.caster, keys.ability, "modifier_stunned", {Duration = fDuration*CalculateStatusResist(v)})
			v:Purge(true, false, false, false, false)
		end
	end)
end

function RamzaSummonerGolem(keys)	
	ProcsArroundingMagicStick(keys.caster)
	local fRadius = keys.ability:GetSpecialValueFor("radius")
	local fDamage = keys.ability:GetSpecialValueFor("damage")
	local fDuration = keys.ability:GetSpecialValueFor("slow_duration")
	local hThinker = CreateUnitByName("npc_dummy_unit", keys.target_points[1], true, keys.caster, keys.caster, keys.caster:GetTeamNumber())
	hThinker:SetOriginalModel("models/creeps/neutral_creeps/n_creep_golem_a/neutral_creep_golem_a.vmdl")
	StartAnimation(hThinker, {duration = 1.4, activity=ACT_DOTA_CAST_ABILITY_2, rate=2})
	Timers:CreateTimer(0.35, function ()
		hThinker:EmitSound("Hero_Brewmaster.ThunderClap")		
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap.vpcf", PATTACH_ABSORIGIN, hThinker)
		ParticleManager:SetParticleControl(iParticle, 1, Vector(fRadius, fRadius, fRadius))
		local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), hThinker:GetAbsOrigin(), none, fRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
		local damageTable = {
			damage = fDamage,
			ability = keys.ability,
			attacker = keys.caster,
			damage_type = DAMAGE_TYPE_MAGICAL
		}	
		for k, v in pairs(tTargets) do
			v:EmitSound("Hero_Brewmaster.ThunderClap.Target")
			damageTable.victim = v
			ApplyDamage(damageTable)
			v:AddNewModifier(keys.caster, keys.ability, "modifier_ramza_summoner_golem_slow", {Duration = fDuration*CalculateStatusResist(v)})
		end
	end)
	Timers:CreateTimer(1, function () hThinker:RemoveSelf() end)
end

function RamzaSummonerBahamut(keys)
	ProcsArroundingMagicStick(keys.caster)
	local fRadius = keys.ability:GetSpecialValueFor("radius")
	local fDamage = keys.ability:GetSpecialValueFor("damage")	
	local fDistance = keys.ability:GetSpecialValueFor("distance")	
	local fSpeed = keys.ability:GetSpecialValueFor("speed")	
	local hThinker = CreateUnitByName("npc_dummy_unit", keys.target_points[1], true, keys.caster, keys.caster, keys.caster:GetTeamNumber())
	hThinker:SetOriginalModel("models/creeps/neutral_creeps/n_creep_black_dragon/n_creep_black_dragon.vmdl")
	StartAnimation(hThinker, {duration = 1.4, activity=ACT_DOTA_CAST_ABILITY_1, rate=1})
	hThinker:SetForwardVector(Vector2D(hThinker:GetOrigin()-keys.caster:GetOrigin()))
	local hDummyAbility = hThinker:AddAbility("ramza_summoner_bahamut_dummy")
	Timers:CreateTimer(0.3, function () 
		hThinker:EmitSound("Hero_DragonKnight.BreathFire")
		ProjectileManager:CreateLinearProjectile({
			Ability = hDummyAbility,
			EffectName = "particles/units/heroes/hero_jakiro/jakiro_dual_breath_fire.vpcf",
			vSpawnOrigin = hThinker:GetAbsOrigin(),
			fDistance = fDistance,
			fStartRadius = fRadius,
			fEndRadius = fRadius,
			Source = keys.caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = false,
			vVelocity = fSpeed*Vector2D(hThinker:GetForwardVector()):Normalized(),
			bProvidesVision = false,
			ExtraData = {damage = fDamage, casterIndex = keys.caster:entindex(), abilityIndex = keys.ability:entindex()}
		})
	end)
	Timers:CreateTimer(1.5, function () hThinker:RemoveSelf() end)
	
end

ramza_summoner_bahamut_dummy = class({})

function ramza_summoner_bahamut_dummy:OnProjectileHit_ExtraData(hTarget, vLocation, tExtraData)
	if hTarget then 
		local damageTable = {
			damage = tExtraData.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			attacker = EntIndexToHScript(tExtraData.casterIndex),
			victim = hTarget,
			ability = EntIndexToHScript(tExtraData.abilityIndex)
		}
		ApplyDamage(damageTable)
	end
end

function RamzaSummonerZodiark(keys)
	ProcsArroundingMagicStick(keys.caster)
	local vLocation = keys.target_points[1]
	local fRadius = keys.ability:GetSpecialValueFor("radius")
	local fDamage = keys.ability:GetSpecialValueFor("damage")	
	local hThinker = CreateUnitByName("npc_dummy_unit", keys.target_points[1], true, keys.caster, keys.caster, keys.caster:GetTeamNumber())
	
	
	hThinker:SetOriginalModel("models/courier/venoling/venoling_flying.vmdl")
	Timers:CreateTimer(0.04, function () hThinker:SetMaterialGroup("1") end)
	hThinker:SetModelScale(3)
--	WearableManager:PrintAllWearableInfos(hThinker)
	StartAnimation(hThinker, {duration = 1.5, activity = ACT_DOTA_RUN, rate=1})	
	hThinker:SetForwardVector(keys.caster:GetForwardVector())
	
	Timers:CreateTimer(0.5, function ()
		hThinker:EmitSound("Hero_Mirana.Starstorm.Cast")
		ParticleManager:CreateParticle("particles/units/heroes/hero_mirana/mirana_starfall_moonray.vpcf", PATTACH_ABSORIGIN_FOLLOW, hThinker)
		for i = 1, 200 do
			local vStar = Vector(vLocation.x+RandomFloat(-fRadius, fRadius), vLocation.y+RandomFloat(-fRadius, fRadius), vLocation.z)
			if (vStar-vLocation):Length2D() < fRadius then
				local iParticle = ParticleManager:CreateParticle("particles/econ/items/mirana/mirana_starstorm_bow/mirana_starstorm_starfall_attack.vpcf", PATTACH_CUSTOMORIGIN, hThinker)
				ParticleManager:SetParticleControl(iParticle, 0, GetGroundPosition(vStar, nil))
			end
		end
	end)
	Timers:CreateTimer(1.07, function ()
		for i = 1, 50 do
			hThinker:EmitSound("Hero_Mirana.Starstorm.Impact")
		end
		local tTargets = FindUnitsInRadius(keys.caster:GetTeamNumber(), hThinker:GetAbsOrigin(), none, fRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
		local damageTable = {
			damage = fDamage,
			ability = keys.ability,
			attacker = keys.caster,
			damage_type = DAMAGE_TYPE_MAGICAL
		}	
		for k, v in pairs(tTargets) do
			damageTable.victim = v
			ApplyDamage(damageTable)
		end
	
	end)
	
	Timers:CreateTimer(1.5, function () hThinker:RemoveSelf() end)
end