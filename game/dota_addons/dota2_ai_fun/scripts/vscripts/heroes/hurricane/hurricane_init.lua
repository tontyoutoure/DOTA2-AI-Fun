local tNewAbilities = {
	"hurricane_tempest",
	"hurricane_cyclone",
	"hurricane_whirlewind",
	"generic_hidden",
	"generic_hidden",
	"hurricane_eyes_of_the_storm",
	"special_bonus_gold_income_120",
	"special_bonus_exp_boost_30",
	"special_bonus_unique_hurricane_1",
	"special_bonus_unique_hurricane_2",
	"special_bonus_unique_hurricane_3",
	"special_bonus_unique_hurricane_4",
	"special_bonus_spell_immunity",
	"special_bonus_unique_hurricane_5"
}

local tHeroBaseStats = {
	MovementSpeed = 305,
	AttackRate = 1.6,
	AttackDamageMin = 6,
	AttackDamageMax = 51,
	AttributeBaseStrength = 26,
	AttributeBaseAgility = 14,
	AttributeBaseIntelligence = 16,
	AttributeStrengthGain = 3.2,
	AttributeAgilityGain = 1.8,
	AttributeIntelligenceGain = 1.6,
	ArmorPhysical = 2,
	PrimaryAttribute = DOTA_ATTRIBUTE_STRENGTH,
	AttackAnimationPoint = 0,
	Model = 'models/heroes/attachto_ghost/pa_gravestone_ghost.vmdl',
	ModelScale = 15,
	DisableWearables = true
}

CustomNetTables:SetTableValue("fun_hero_stats", "hurricane_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "hurricane", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("hurricane", tNewAbilities)
function HurricaneAddParticle(keys)
	if IsClient() then return end
	if EntIndexToHScript(keys.entindex):GetName() == "npc_dota_hero_disruptor" then
		local hHero = EntIndexToHScript(keys.entindex)
--		hHero:AddNewModifier(hHero, nil, 'modifier_hurricane_sound_manager', {})
		hHero.iParticle1 = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_ti6/invoker_tornado_ti6_funnel.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHero)	
		ParticleManager:SetParticleControlEnt(hHero.iParticle1, 3, hHero, PATTACH_POINT_FOLLOW, 'follow_origin' ,hHero:GetAbsOrigin(), true)
		hHero.iParticle2 = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_ti6/invoker_tornado_ti6_base.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHero)	
		ParticleManager:SetParticleControlEnt(hHero.iParticle2, 3, hHero, PATTACH_POINT_FOLLOW, 'follow_origin' ,hHero:GetAbsOrigin(), true)
	end
end

function HurricaneRemoveParticle(keys)
	if IsClient() then return end
	if EntIndexToHScript(keys.entindex_killed):GetName() == "npc_dota_hero_disruptor" then
		local hHero = EntIndexToHScript(keys.entindex_killed)
--		hHero:RemoveModifierByName('modifier_hurricane_sound_manager')
		ParticleManager:DestroyParticle(hHero.iParticle1 ,false)
		ParticleManager:DestroyParticle(hHero.iParticle2 ,false)
	end
end
LinkLuaModifier("modifier_hurricane_model_scale_manager", "heroes/hurricane/hurricane_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

HurricaneInit = function (hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_hurricane", {})
	if not GameMode.bHurricanParticleListenerSet then
		GameMode.bHurricanParticleListenerSet = true
		ListenToGameEvent("npc_spawned", HurricaneAddParticle, nil)
		ListenToGameEvent("entity_killed", HurricaneRemoveParticle, nil)
	end
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)
	hHero:AddNewModifier(hHero, nil, "modifier_hurricane_model_scale_manager", {})
end


