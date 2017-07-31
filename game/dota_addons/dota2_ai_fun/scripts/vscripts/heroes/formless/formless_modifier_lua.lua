function formless_copy_skill(keys)
  local caster = keys.caster
  local ability = keys.ability
  local target = keys.target
  local originalLevel = ability:GetLevel()
  local targetAbilityIndex = formless_get_real_skill_index(keys)

  if(targetAbilityIndex == -1) then
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

tBugHero = {}
tBugHero["npc_dota_hero_alchemist"] = {0, -1, 2, 3} -- two in one
tBugHero["npc_dota_hero_ancient_apparition"] = {0, 1, 2, -1} -- two in one
tBugHero["npc_dota_hero_lone_druid"] = {0, 1, 2, -1} -- two in one	
tBugHero["npc_dota_hero_kunkka"] = {0, 1, -1, 3} -- two in one
tBugHero["npc_dota_hero_life_stealer"] = {0, 1, 2, -1} -- two in one	
tBugHero["npc_dota_hero_naga_siren"] = {0, 1, 2, -1} -- two in one	
tBugHero["npc_dota_hero_morphling"] = {0, 1, -1, -1} -- two in one and multiple ability	
tBugHero["npc_dota_hero_phoenix"] = {-1, -1, -1, 4} -- two in one and multiple ability	
tBugHero["npc_dota_hero_shredder"] = {0, 1, 2, -1} -- two in one and multiple ability		
tBugHero["npc_dota_hero_elder_titan"] = {0, -1, 2, 3} -- two in one, spirit cannot return from hero	
tBugHero["npc_dota_hero_nevermore"] = {-1, 3, 4, 5} --multiple ability
tBugHero["npc_dota_hero_abyssal_underlord"] = {0, 1, 2, -1} -- multiple ability
tBugHero["npc_dota_hero_templar_assassin"] = {0, 1, 2, 4}  --  multiple ability
tBugHero["npc_dota_hero_puck"] = {0, 1, 2, 4} --  multiple ability, cannot move to orb	
tBugHero["npc_dota_hero_troll_warlord"] = {0, -1, 3, 4} --  multiple ability
tBugHero["npc_dota_hero_tusk"] = {0, -1, 2, 5} --  multiple ability	
tBugHero["npc_dota_hero_beastmaster"] = {0, -1, 3, 4} --multiple ability	
tBugHero["npc_dota_hero_chen"] = {0, -1, 3, 4} --multiple ability
tBugHero["npc_dota_hero_monkey_king"] = {0, -1, 4, 7} -- multiple ability		
tBugHero["npc_dota_hero_axe"] = {0, 1, -1, 3} -- buggy passive
tBugHero["npc_dota_hero_abaddon"] = {0, 1, -1, 3} -- buggy passive
tBugHero["npc_dota_hero_lina"] = {0, 1, -1, 3} -- buggy passive	
tBugHero["npc_dota_hero_legion_commander"] = {0, 1, -1, 3} --buggy passive	
tBugHero["npc_dota_hero_ogre_magi"] = {0, 1, 2, -1}  --buggy passive		
tBugHero["npc_dota_hero_earth_spirit"] = {-1, -1, -1, -1} --no stone no life
tBugHero["npc_dota_hero_ember_spirit"] = {0, 1, 2, -1} -- ulti no charge and cannot return		
tBugHero["npc_dota_hero_keeper_of_the_light"] = {0, 1, 2, -1} -- ulti no use	
tBugHero["npc_dota_hero_meepo"] = {0, 1, 2, -1} --super buggy ulti
tBugHero["npc_dota_hero_invoker"] = {0, 1, 2, -1} -- super buggy ulti	
tBugHero["npc_dota_hero_death_prophet"] = {0, 1, 2, -1} -- forget while casting is buggy
tBugHero["npc_dota_hero_rubick"] = {0, 1, 2, -1} --buggy ulti
tBugHero["npc_dota_hero_leshrac"] = {0, 1, -1, 3}	-- no agharim charge
tBugHero["npc_dota_hero_mirana"] = {-1, 1, 2, 3}	-- no agharim charge
tBugHero["npc_dota_hero_obsidian_destroyer"] = {0, -1, 2, 3} -- no agharim charge
tBugHero["npc_dota_hero_bloodseeker"] = {0, 1, 2, -1} -- no agharim charge
tBugHero["npc_dota_hero_doom_bringer"] = {-1, 1, 2, 3} --no devoured unit ability
tBugHero["npc_dota_hero_broodmother"] = {0, -1, 2, 3} -- net won't disappear
tBugHero["npc_dota_hero_faceless_void"] = {0, 1, -1, 3} -- passive cannot proc from far
tBugHero["npc_dota_hero_luna"] = {0, -1, 2, 3} --passive change attack projectile	
tBugHero["npc_dota_hero_wisp"] = {-1, -1, -1, -1}	
tBugHero["npc_dota_hero_night_stalker"] = {0, 1, -1, -1} --aura is problematic.
tBugHero["npc_dota_hero_shadow_demon"] = {0, 1, 2, -1} --ulti is buggy
tBugHero["npc_dota_hero_techies"] = {0, 1, -1, 5} --swindle is dangerous
tBugHero["npc_dota_hero_tinker"] = {0, 1, 2, -1} -- ulti will make it meele hero	
tBugHero["npc_dota_hero_visage"] = {-1, 1, 2, -1} -- don't transform
tBugHero["npc_dota_hero_zuus"] = {0, 1, 2, 4} -- real ulti
tBugHero["npc_dota_hero_brewmaster"] = {2, 3, 4, -1}

function formless_get_real_skill_index(keys)
	local targetName = keys.target:GetName()
	if tBugHero[targetName] ~=nil then
		local skillIndexes = tBugHero[targetName]
		return skillIndexes[keys.abilityIndexToCopy+1]
	end
	return keys.abilityIndexToCopy
end
