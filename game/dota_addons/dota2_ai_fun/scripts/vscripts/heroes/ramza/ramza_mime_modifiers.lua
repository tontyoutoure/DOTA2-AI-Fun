modifier_ramza_mime_mimic = class({})

local tBugHeroRamzaMimic = {}
tBugHeroRamzaMimic["npc_dota_hero_alchemist"] = {0, -1, 2, 3} -- two in one
tBugHeroRamzaMimic["npc_dota_hero_ancient_apparition"] = {0, 1, 2, -1} -- two in one
tBugHeroRamzaMimic["npc_dota_hero_lone_druid"] = {0, 1, 2, -1} -- two in one	
tBugHeroRamzaMimic["npc_dota_hero_kunkka"] = {0, 1, -1, 3} -- two in one
tBugHeroRamzaMimic["npc_dota_hero_life_stealer"] = {0, 1, 2, -1} -- two in one	
tBugHeroRamzaMimic["npc_dota_hero_naga_siren"] = {0, 1, 2, -1} -- two in one	
tBugHeroRamzaMimic["npc_dota_hero_morphling"] = {0, 1, -1, -1} -- two in one and multiple ability	
tBugHeroRamzaMimic["npc_dota_hero_phoenix"] = {-1, -1, -1, 4} -- two in one and multiple ability	
tBugHeroRamzaMimic["npc_dota_hero_shredder"] = {0, 1, 2, -1} -- two in one and multiple ability		
tBugHeroRamzaMimic["npc_dota_hero_elder_titan"] = {0, -1, 2, 3} -- two in one, spirit cannot return from hero	
tBugHeroRamzaMimic["npc_dota_hero_nevermore"] = {-1, 3, 4, 5} --multiple ability
tBugHeroRamzaMimic["npc_dota_hero_abyssal_underlord"] = {0, 1, 2, -1} -- multiple ability
tBugHeroRamzaMimic["npc_dota_hero_templar_assassin"] = {0, 1, 2, 4}  --  multiple ability
tBugHeroRamzaMimic["npc_dota_hero_puck"] = {0, 1, 2, 4} --  multiple ability, cannot move to orb	
tBugHeroRamzaMimic["npc_dota_hero_troll_warlord"] = {0, -1, 3, 4} --  multiple ability
tBugHeroRamzaMimic["npc_dota_hero_tusk"] = {0, -1, 2, 5} --  multiple ability	
tBugHeroRamzaMimic["npc_dota_hero_beastmaster"] = {0, -1, 3, 4} --multiple ability	
tBugHeroRamzaMimic["npc_dota_hero_chen"] = {0, -1, 3, 4} --multiple ability
tBugHeroRamzaMimic["npc_dota_hero_monkey_king"] = {0, -1, 4, 7} -- multiple ability		
tBugHeroRamzaMimic["npc_dota_hero_axe"] = {0, 1, -1, 3} -- buggy passive
tBugHeroRamzaMimic["npc_dota_hero_abaddon"] = {0, 1, -1, 3} -- buggy passive
tBugHeroRamzaMimic["npc_dota_hero_lina"] = {0, 1, -1, 3} -- buggy passive	
tBugHeroRamzaMimic["npc_dota_hero_legion_commander"] = {0, 1, -1, 3} --buggy passive	
tBugHeroRamzaMimic["npc_dota_hero_ogre_magi"] = {0, 1, 2, -1}  --buggy passive		
tBugHeroRamzaMimic["npc_dota_hero_earth_spirit"] = {-1, -1, -1, -1} --no stone no life
tBugHeroRamzaMimic["npc_dota_hero_ember_spirit"] = {0, 1, 2, -1} -- ulti no charge and cannot return		
tBugHeroRamzaMimic["npc_dota_hero_keeper_of_the_light"] = {0, 1, 2, -1} -- ulti no use	
tBugHeroRamzaMimic["npc_dota_hero_meepo"] = {0, 1, 2, -1} --super buggy ulti
tBugHeroRamzaMimic["npc_dota_hero_invoker"] = {0, 1, 2, -1} -- super buggy ulti	
tBugHeroRamzaMimic["npc_dota_hero_death_prophet"] = {0, 1, 2, -1} -- forget while casting is buggy
tBugHeroRamzaMimic["npc_dota_hero_rubick"] = {0, 1, 2, -1} --buggy ulti
tBugHeroRamzaMimic["npc_dota_hero_leshrac"] = {0, 1, -1, 3}	-- no agharim charge
tBugHeroRamzaMimic["npc_dota_hero_mirana"] = {-1, 1, 2, 3}	-- no agharim charge
tBugHeroRamzaMimic["npc_dota_hero_obsidian_destroyer"] = {0, -1, 2, 3} -- no agharim charge
tBugHeroRamzaMimic["npc_dota_hero_bloodseeker"] = {0, 1, 2, -1} -- no agharim charge
tBugHeroRamzaMimic["npc_dota_hero_doom_bringer"] = {-1, 1, 2, 3} --no devoured unit ability
tBugHeroRamzaMimic["npc_dota_hero_broodmother"] = {0, -1, 2, 3} -- net won't disappear
tBugHeroRamzaMimic["npc_dota_hero_faceless_void"] = {0, 1, -1, 3} -- passive cannot proc from far
tBugHeroRamzaMimic["npc_dota_hero_luna"] = {0, -1, 2, 3} --passive change attack projectile	
tBugHeroRamzaMimic["npc_dota_hero_wisp"] = {-1, -1, -1, -1}	
tBugHeroRamzaMimic["npc_dota_hero_night_stalker"] = {0, 1, -1, -1} --aura is problematic.
tBugHeroRamzaMimic["npc_dota_hero_shadow_demon"] = {0, 1, 2, -1} --ulti is buggy
tBugHeroRamzaMimic["npc_dota_hero_techies"] = {0, 1, -1, 5} --swindle is dangerous
tBugHeroRamzaMimic["npc_dota_hero_tinker"] = {0, 1, 2, -1} -- ulti will make it meele hero	
tBugHeroRamzaMimic["npc_dota_hero_visage"] = {-1, 1, 2, -1} -- don't transform
tBugHeroRamzaMimic["npc_dota_hero_zuus"] = {0, 1, 2, 4} -- don't transform

RamzaMimicDeclareFunctions = function(self)
	return {
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT
	}
end

RamzaMimicGetModifierCooldownReduction_Constant = function(self)
	return 999
end

RamzaMimicGetModifierPercentageManacost = function(self)
	return -self:GetAbility():GetSpecialValueFor("mana_cost")
end













