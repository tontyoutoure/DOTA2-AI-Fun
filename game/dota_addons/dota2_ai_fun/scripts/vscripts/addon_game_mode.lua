-- Create the class for the game mode, unused in this example as the functions for the quest are global

require('heroes/telekenetic_blob/telekenetic_blob_util')
require('internal/util')
require('gamemode')

-- If something was being created via script such as a new npc, it would need to be precached here
function Precache( context )
	PrecacheUnitByNameSync("npc_dota_hero_obsidian_destroyer", context)
	PrecacheUnitByNameSync("npc_dota_hero_omniknight", context)
	PrecacheUnitByNameSync("npc_dota_hero_bloodseeker", context)
	
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_enchantress.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_faceless_void.vsndevts", context)
	PrecacheResource("particle", "particles/econ/items/enchantress/enchantress_virgas/ench_impetus_virgas.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/am_manaburn_basher_ti_5_gold.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_antimage.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_nyx_assassin.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_pugna/pugna_ward_attack.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/wisp/wisp_relocate_teleport_ti7.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/wisp/wisp_relocate_teleport_ti7_out.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_wisp.vsndevts", context)
	PrecacheResource("soundfile", "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf", context)
	
	-- for bastion
	PrecacheResource("particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_chakra_magic.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_keeper_of_the_light.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_razor/razor_unstable_current.vpcf", context)	
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_chen.vsndevts", context)

	-- for intimidator
	PrecacheResource("particle", "particles/econ/items/razor/razor_punctured_crest_golden/razor_static_link_new_arc_blade_golden.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/legion/legion_fallen/legion_fallen_press.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_legion_commander.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_death_prophet/death_prophet_spiritsiphon.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard_column.vpcf", context)
	
	-- for persuasive
	PrecacheResource("particle", "particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/sniper/sniper_charlie/sniper_assassinate_charlie.vpcf", context)
	PrecacheResource("particle", "particles/status_fx/status_effect_maledict.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_witchdoctor.vsndevts", context)
	
	-- for void demon
	PrecacheResource("particle", "particles/units/heroes/hero_omniknight/omniknight_degen_aura_debuff.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_leshrac.vsndevts", context)
	
	-- for astral trekker

	
	-- for terran marine
	PrecacheResource("particle", "particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_trail_smk.vpcf", context)
	
	-- for magic dragon
	PrecacheResource("particle", "particles/status_fx/status_effect_enchantress_untouchable.vpcf", context)
	PrecacheResource("particle", "particles/status_fx/status_effect_frost.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_ember_spirit/emberspirit_flame_shield_aoe_impact.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_centaur/centaur_return.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/viper/viper_ti7_immortal/viper_poison_debuff_ti7.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_viper.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_lich.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_lich/lich_frost_nova.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_jakiro.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context)
	PrecacheResource("soundfile", "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", context)
	PrecacheResource("soundfile", "particles/econ/items/antimage/antimage_weapon_basher_ti5/am_manaburn_basher_ti_5.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet_frozen.vpcf", context)	
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ancient_apparition.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_morphling/morphling_morph_agi_ring.vpcf", context)	
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_lone_druid.vsndevts", context)
	PrecacheResource("particle", "particles/econ/items/viper/viper_ti7_immortal/viper_poison_attack_ti7.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/razor/razor_ti6/razor_base_attack_ti6.vpcf", context)
	PrecacheResource("particle", "particles/neutral_fx/black_dragon_attack.vpcf", context)
	
	-- for fluid engineer
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_tidehunter.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_tidehunter/tidehunter_gush.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_kunkka.vsndevts", context)
	PrecacheResource("particle", "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf", context)
	
	-- for ramza
	PrecacheResource("particle", "particles/units/heroes/hero_clinkz/clinkz_base_attack.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_base_attack.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_lina/lina_base_attack.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_shadowshaman/shadowshaman_base_attack.vpcf",context)
	PrecacheResource("particle", "particles/units/heroes/hero_silencer/silencer_base_attack.vpcf",context)
	PrecacheResource("particle", "particles/econ/items/rubick/rubick_staff_wandering/rubick_base_attack_whset.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_base_attack.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_invoker/invoker_base_attack.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/necrolyte/necronub_base_attack/necrolyte_base_attack_ka.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_bane/bane_projectile.vpcf", context)
	
	PrecacheResource("particle", "particles/econ/items/clinkz/clinkz_maraxiform/clinkz_maraxiform_searing_arrow.vpcf", context)
	
	PrecacheResource("particle", "particles/units/heroes/hero_brewmaster/brewmaster_hurl_boulder.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_brewmaster.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_magnataur.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_windrunner.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_empower.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/windrunner/windrunner_cape_cascade/windrunner_windrun_cascade.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/sven/sven_warcry_ti5/sven_warcry_buff_ti_5.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_centaur/centaur_return.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_chen/chen_hand_of_god.vpcf", context)
	PrecacheResource("particle", "particles/status_fx/status_effect_beserkers_call.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_axe.vsndevts", context)
	PrecacheResource("particle", "particles/econ/items/axe/axe_helm_shoutmask/axe_beserkers_call_buff_shout_mask.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7.vpcf", context)	
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_elder_titan.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_earth_spirit.vsndevts", context)
	
	
	PrecacheResource("particle", "particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_phoenix/phoenix_supernova_egg.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts", context) -- Hero_Phoenix.SuperNova.Begin, Hero_Phoenix.SuperNova.Cast Hero_Phoenix.SuperNova.Explode	
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_slark.vsndevts", context) -- Hero_Slark.DarkPact.Cast
	PrecacheResource("particle", "particles/econ/events/ti6/mekanism_ti6.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_chen/chen_holy_persuasion.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/slark/slark_head_immortal/slark_immortal_dark_pact_pulses.vpcf", context)
	
	PrecacheResource("particle", "particles/econ/items/storm_spirit/storm_spirit_orchid_hat/storm_orchid_silenced.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_bane/bane_enfeeble.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_bane.vsndevts", context) -- Hero_NyxAssassin.ManaBurn.Target
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_slardar.vsndevts", context) -- Hero_Slardar.Amplify_Damage
	PrecacheResource("particle", "particles/units/heroes/hero_slardar/slardar_amp_damage.vpcf", context) 
	
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_lich.vsndevts", context) -- Ability.DarkRitual Ability.FrostNova
	PrecacheResource("particle", "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_lich/lich_dark_ritual.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts", context) -- Hero_OgreMagi.Fireblast.Target
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_earthshaker.vsndevts", context)  -- Hero_EarthShaker.EchoSlam
	PrecacheResource("particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_immortal_lightning.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context)  -- Hero_Zuus.LightningBolt
	PrecacheResource("particle", "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_doom_bringer/doom_scorched_earth.vpcf", context)	
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_doombringer.vsndevts", context)  --Hero_DoomBringer.ScorchedEarthAura
	PrecacheResource("particle",  "particles/units/heroes/hero_dazzle/dazzle_poison_debuff.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_dazzle.vsndevts", context)  -- Hero_Dazzle.Poison_Touch
	PrecacheResource("particle", "particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_explosion_arcana1.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_frostgrow_arcana1.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_lion.vsndevts", context) -- Hero_Lion.Voodoo
	
	
end


-- Create the game mode class when we activate
function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
end

