local tNewAbilities = {
	"hurricane_tempest",
	"hurricane_cyclone",
	"hurricane_whirlewind",
	"generic_hidden",
	"generic_hidden",
	"hurricane_eyes_of_the_storm",
	"special_bonus_gold_income_25",
	"special_bonus_exp_boost_20",
	"special_bonus_hurricane_1",
	"special_bonus_hurricane_2",
	"special_bonus_hurricane_3",
	"special_bonus_hurricane_4",
	"special_bonus_spell_immunity",
	"special_bonus_hurricane_5"
}

local tHeroBaseStats = {
	MovementSpeed = 310,
	AttackRate = 1.7,
	AttackDamageMin = 6,
	AttackDamageMax = 51,
	AttributeBaseStrength = 26,
	AttributeBaseAgility = 14,
	AttributeBaseIntelligence = 16,
	AttributeStrenthGain = 2.9,
	AttributeAgilityGain = 1.8,
	AttributeIntelligenceGain = 1.6,
	ArmorPhysical = 2,
	PrimaryAttribute = DOTA_ATTRIBUTE_STRENGTH,
	AttackAnimationPoint = 0.4,
	Model = 'models/heroes/attachto_ghost/attachto_ghost.vmdl',
	DisableWearables = true
}

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
LinkLuaModifier("modifier_hurricane_sound_manager", "heroes/hurricane/hurricane_init.lua", LUA_MODIFIER_MOTION_NONE)

modifier_hurricane_sound_manager = class({})

function modifier_hurricane_sound_manager:IsPurgable() return false end
function modifier_hurricane_sound_manager:IsHidden() return true end

function modifier_hurricane_sound_manager:OnCreated()
	if IsClient() then return end
	self:GetParent():EmitSound('n_creep_Wildkin.Tornado')
	self:StartIntervalThink(30)
end

function modifier_hurricane_sound_manager:OnIntervalThink()
	if IsClient() then return end
	self:GetParent():StopSound('n_creep_Wildkin.Tornado')
	self:GetParent():EmitSound('n_creep_Wildkin.Tornado')
end

function modifier_hurricane_sound_manager:OnDestroy()
	if IsClient() then return end
	self:GetParent():StopSound('n_creep_Wildkin.Tornado')
end

HurricaneInit = function (hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_hurricane", {})
	if not GameMode.bHurricanParticleListenerSet then
		GameMode.bHurricanParticleListenerSet = true
		ListenToGameEvent("npc_spawned", HurricaneAddParticle, nil)
		ListenToGameEvent("entity_killed", HurricaneRemoveParticle, nil)
	end
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
end


