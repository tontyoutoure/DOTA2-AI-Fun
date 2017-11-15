function formless_copy_skill(keys)
  local caster = keys.caster
  local ability = keys.ability
  local target = keys.target
  local originalLevel = ability:GetLevel()
  local targetAbilityIndex = formless_get_real_skill_index(keys)

  if(targetAbilityIndex <0) then
	ability:EndCooldown()
	return
  end

  local targetAbility = target:GetAbilityByIndex(targetAbilityIndex)
  if targetAbility ~= nil and caster ~= target then
    local targetAbilityName = targetAbility:GetAbilityName()
    caster:AddAbility(targetAbilityName)
    caster:SwapAbilities(ability:GetAbilityName(), targetAbilityName, false, true)
    caster:FindAbilityByName(targetAbilityName):SetLevel(originalLevel)
  else
	ability:EndCooldown()
  end
end

function formless_unus(keys)
  keys.abilityIndexToCopy = 0
  formless_copy_skill(keys)
end

function formless_duos(keys)
  keys.abilityIndexToCopy = 1
  formless_copy_skill(keys)
end

function formless_tertius(keys)
  keys.abilityIndexToCopy = 2
  formless_copy_skill(keys)
end

function formless_denique(keys)
  keys.abilityIndexToCopy = 3
  formless_copy_skill(keys)
end

tHero = {}
tHero["npc_dota_hero_abaddon"] = {0, 1, -1, 5}
tHero["npc_dota_hero_abyssal_underlord"] = {0, 1, 2, -1} -- multiple ability
tHero["npc_dota_hero_ancient_apparition"] = {0, 1, 2, -1} -- two in one
tHero["npc_dota_hero_alchemist"] = {0, -1, 2, 5} -- two in one
tHero["npc_dota_hero_antimage"] = {0, 1, 2, 5}
tHero["npc_dota_hero_axe"] = {0, 1, -1, 5} -- buggy passive
tHero["npc_dota_hero_bane"] = {0, 1, 2, 5}
tHero["npc_dota_hero_batrider"] = {0, 1, 2, 5}
tHero["npc_dota_hero_bloodseeker"] = {0, 1, 2, -1} -- no agharim charge
tHero["npc_dota_hero_bounty_hunter"] = {0, 1, 2, 5}
tHero["npc_dota_hero_bristleback"] = {0, 1, 2, 5}
tHero["npc_dota_hero_broodmother"] = {0, -1, 2, 5} -- net won't disappear
tHero["npc_dota_hero_centaur"] = {0, 1, 2, 5}
tHero["npc_dota_hero_chaos_knight"] = {0, 1, 2, 5}
tHero["npc_dota_hero_chen"] = {0, 1, 2, 5}
tHero["npc_dota_hero_clinkz"] = {0, 1, 2, 5}
tHero["npc_dota_hero_crystal_maiden"] = {0, 1, 2, 5}
tHero["npc_dota_hero_dark_seer"] = {0, 1, 2, 5}
tHero["npc_dota_hero_dazzle"] = {0, 1, 2, 5}
tHero["npc_dota_hero_death_prophet"] = {0, 1, 2, -1} -- forget while casting is buggy
tHero["npc_dota_hero_doom_bringer"] = {-1, 1, 2, 5} --no devoured unit ability
tHero["npc_dota_hero_dragon_knight"] = {0, 1, 2, 5}
tHero["npc_dota_hero_drow_ranger"] = {0, 1, 2, 5}
tHero["npc_dota_hero_earth_spirit"] = {-1, -1, -1, -1} --no stone no life
tHero["npc_dota_hero_earthshaker"] = {0, 1, 2, 5}
tHero["npc_dota_hero_elder_titan"] = {-1, -1, 2, 5} -- two in one, spirit cannot return from hero	
tHero["npc_dota_hero_ember_spirit"] = {0, 1, 2, -1} -- ulti no charge and cannot return	
tHero["npc_dota_hero_enchantress"] = {0, 1, 2, 5}
tHero["npc_dota_hero_faceless_void"] = {0, 1, -1, 5} -- passive cannot proc from far
tHero["npc_dota_hero_furion"] = {0, 1, 2, 5}
tHero["npc_dota_hero_gyrocopter"] = {0, 1, 2, 5}
tHero["npc_dota_hero_huskar"] = {0, 1, 2, 5}
tHero["npc_dota_hero_invoker"] = {-1, -1, -2, -5}
tHero["npc_dota_hero_jakiro"] = {0, 1, 2, 5}
tHero["npc_dota_hero_juggernaut"] = {0, 1, 2, 5}
tHero["npc_dota_hero_keeper_of_the_light"] = {0, 1, 2, -1} -- ulti no use	
tHero["npc_dota_hero_kunkka"] = {0, 1, -1, 5} -- two in one
tHero["npc_dota_hero_legion_commander"] = {0, 1, -1, 5}
tHero["npc_dota_hero_leshrac"] = {0, 1, -1, 5}	-- no agharim charge
tHero["npc_dota_hero_lich"] = {0, 1, 2, 5}
tHero["npc_dota_hero_life_stealer"] = {0, 1, 2, -1} -- two in one	
tHero["npc_dota_hero_lina"] = {0, 1, -1, 5}
tHero["npc_dota_hero_lion"] = {0, 1, 2, 5}
tHero["npc_dota_hero_lone_druid"] = {0, 1, 2, -1} -- two in one	
tHero["npc_dota_hero_luna"] = {0, -1, 2, 5} --passive change attack projectile	
tHero["npc_dota_hero_lycan"] = {0, 1, 2, 5}
tHero["npc_dota_hero_magnataur"] = {0, 1, -1, 5} --buggy 
tHero["npc_dota_hero_medusa"] = {0, 1, 2, 5}
tHero["npc_dota_hero_meepo"] = {0, 1, 2, -1} --super buggy ulti	
tHero["npc_dota_hero_mirana"] = {-1, 1, 2, 5}	-- no agharim charge
tHero["npc_dota_hero_monkey_king"] = {0, -1, -1, 5} -- multiple ability buggy passive
tHero["npc_dota_hero_morphling"] = {0, -1, -1, -1} -- two in one and multiple ability	
tHero["npc_dota_hero_naga_siren"] = {0, 1, 2, -1} -- two in one
tHero["npc_dota_hero_necrolyte"] = {0, 1, 2, 5}
tHero["npc_dota_hero_nevermore"] = {-1, 3, 4, 5} --multiple ability
tHero["npc_dota_hero_night_stalker"] = {0, 1, 2, 5}
tHero["npc_dota_hero_nyx_assassin"] = {0, 1, 2, 5}
tHero["npc_dota_hero_obsidian_destroyer"] = {0, -1, 2, 5} -- no agharim charge
tHero["npc_dota_hero_ogre_magi"] = {0, 1, 2, -1}  --buggy passive
tHero["npc_dota_hero_omniknight"] = {0, 1, 2, 5}
tHero["npc_dota_hero_oracle"] = {0, 1, 2, 5}
tHero["npc_dota_hero_phantom_assassin"] = {0, 1, 2, 5}
tHero["npc_dota_hero_phantom_lancer"] = {0, 1, 2, 5}
tHero["npc_dota_hero_phoenix"] = {-1, -1, -1, 5} -- two in one and multiple ability	
tHero["npc_dota_hero_puck"] = {0, 1, 2, 5} --  multiple ability, cannot move to orb	
tHero["npc_dota_hero_pudge"] = {0, 1, 2, 5}
tHero["npc_dota_hero_queenofpain"] = {0, 1, 2, 5}
tHero["npc_dota_hero_rattletrap"] = {0, 1, 2, 5}
tHero["npc_dota_hero_razor"] = {0, 1, 2, 5}
tHero["npc_dota_hero_riki"] = {0, 1, 2, 5}
tHero["npc_dota_hero_sand_king"] = {0, 1, 2, 5}
tHero["npc_dota_hero_shadow_shaman"] = {0, 1, 2, 5}
tHero["npc_dota_hero_shredder"] = {0, 1, 2, -1} -- two in one and multiple ability		
tHero["npc_dota_hero_silencer"] = {0, 1, 2, 5}
tHero["npc_dota_hero_skeleton_king"] = {0, 1, 2, 5}
tHero["npc_dota_hero_skywrath_mage"] = {0, 1, 2, 5}
tHero["npc_dota_hero_slardar"] = {0, 1, 2, 5}
tHero["npc_dota_hero_slark"] = {0, 1, 2, 5}
tHero["npc_dota_hero_sniper"] = {0, 1, 2, 5}
tHero["npc_dota_hero_spectre"] = {0, 1, 2, 5}
tHero["npc_dota_hero_storm_spirit"] = {0, 1, 2, -1}
tHero["npc_dota_hero_templar_assassin"] = {0, 1, 2, 5}  --  multiple ability
tHero["npc_dota_hero_terrorblade"] = {0, 1, 2, 5}
tHero["npc_dota_hero_tidehunter"] = {0, 1, 2, 5}
tHero["npc_dota_hero_tiny"] = {0, 1, 2, 5}
tHero["npc_dota_hero_troll_warlord"] = {0, -1, 3, 5} --  multiple ability
tHero["npc_dota_hero_tusk"] = {0, -1, 2, 5} --  multiple ability	
tHero["npc_dota_hero_undying"] = {0, 1, 2, 5}
tHero["npc_dota_hero_ursa"] = {0, 1, 2, 5}
tHero["npc_dota_hero_vengefulspirit"] = {0, 1, 2, 5}
tHero["npc_dota_hero_venomancer"] = {0, 1, 2, 5}
tHero["npc_dota_hero_viper"] = {0, 1, 2, 5}
tHero["npc_dota_hero_warlock"] = {0, 1, 2, 5}
tHero["npc_dota_hero_weaver"] = {0, 1, 2, 5}
tHero["npc_dota_hero_winter_wyvern"] = {0, 1, 2, 5}
tHero["npc_dota_hero_witch_doctor"] = {0, 1, 2, 5}
tHero["npc_dota_hero_zuus"] = {0, 1, 2, 5} -- real ulti
			
tHero["npc_dota_hero_spirit_breaker"] = {0, 1, 2, 5}
tHero["npc_dota_hero_enigma"] = {-1, -1, -1, -1}  -- no target
tHero["npc_dota_hero_beastmaster"] = {-1, 3, 4, 5} --multiple ability	
tHero["npc_dota_hero_arc_warden"] = {0, 1, 2, 5}
tHero["npc_dota_hero_windrunner"] = {0, 1, 2, 5}
tHero["npc_dota_hero_sven"] = {0, 1, 2, 5}
tHero["npc_dota_hero_disruptor"] = {0, 1, 2, 5}
tHero["npc_dota_hero_wisp"] = {-1, -1, -1, -1}	
tHero["npc_dota_hero_treant"] = {0, 1, 2, 5}
tHero["npc_dota_hero_brewmaster"] = {-1, -1, -1, -1}
tHero["npc_dota_hero_night_stalker"] = {0, 1, -1, -1} --aura is problematic.
tHero["npc_dota_hero_shadow_demon"] = {0, 1, 2, -1} --ulti is buggy
tHero["npc_dota_hero_techies"] = {0, 1, -1, 5} --swindle is dangerous
tHero["npc_dota_hero_tinker"] = {0, 1, 2, -1} -- ulti will make it meele hero	
tHero["npc_dota_hero_visage"] = {-1, 1, 2, -1} -- don't transform
tHero["npc_dota_hero_rubick"] = {0, 1, -1, 5} --cleric, buggy passive
tHero["npc_dota_hero_pugna"] = {0, -1, 3, 5}  --multiple abilities

function formless_get_real_skill_index(keys)
	local targetName = keys.target:GetName()
	if tHero[targetName] ~=nil then
		return tHero[targetName][keys.abilityIndexToCopy+1]
	end
	return keys.abilityIndexToCopy
end
