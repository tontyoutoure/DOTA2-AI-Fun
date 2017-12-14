-- Create the class for the game mode, unused in this example as the functions for the quest are global

require('heroes/telekenetic_blob/telekenetic_blob_util')
require('internal/util')
require('gamemode')

-- If something was being created via script such as a new npc, it would need to be precached here
function Precache( context )

	PrecacheModel("models/heroes/invoker/invoker_head.vmdl", context)
	PrecacheModel("models/items/invoker/magus_apex/magus_apex.vmdl", context)
	PrecacheResource("particle", "particles/units/heroes/hero_morphling/morphling_base_attack.vpcf", context)
	PrecacheUnitByNameSync("npc_dota_hero_obsidian_destroyer", context)
	PrecacheUnitByNameSync("npc_dota_hero_omniknight", context)
	PrecacheUnitByNameSync("npc_dota_hero_bloodseeker", context)
	PrecacheUnitByNameSync("npc_dota_hero_lone_druid", context)
	PrecacheResource("particle", "particles/windrunner_spell_powershot_rainmaker.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_enchantress.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_faceless_void.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context)
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
	PrecacheResource("particle", "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_purge.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_arcana_swoop.vpcf", context)
	PrecacheResource("particle", "particles/blood_sword.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_chen/chen_penitence_debuff.vpcf", context)
	-- for bastion
	PrecacheResource("particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_chakra_magic.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_keeper_of_the_light.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_razor/razor_unstable_current.vpcf", context)	
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_chen.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf", context)

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
	PrecacheResource("particle", "particles/units/heroes/hero_oracle/oracle_base_attack.vpcf", context)
	
	PrecacheResource("particle", "particles/econ/items/clinkz/clinkz_maraxiform/clinkz_maraxiform_searing_arrow.vpcf", context)
	
	PrecacheResource("particle", "particles/units/heroes/hero_brewmaster/brewmaster_hurl_boulder.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_brewmaster.vsndevts", context) -- Hero_Brewmaster.ThunderClap Brewmaster_Earth.Boulder.Target
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
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_doombringer.vsndevts", context)  --Hero_DoomBringer.ScorchedEarthAura Hero_DoomBringer.Doom
	PrecacheResource("particle",  "particles/units/heroes/hero_dazzle/dazzle_poison_debuff.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_dazzle.vsndevts", context)  -- Hero_Dazzle.Poison_Touch
	PrecacheResource("particle", "particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_explosion_arcana1.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_frostgrow_arcana1.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_lion.vsndevts", context) -- Hero_Lion.Voodoo
	
	PrecacheResource("particle", "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/centaur/centaur_ti6_gold/centaur_ti6_warstomp_gold.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_centaur.vsndevts", context) -- Hero_Centaur.HoofStomp
	PrecacheResource("particle", "particles/status_fx/status_effect_brewmaster_thunder_clap.vpcf", context)
	
	PrecacheResource("particle", "particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_phantom_assassin.vsndevts", context) -- Hero_PhantomAssassin.CoupDeGrace Hero_PhantomAssassin.Dagger.Target Hero_PhantomAssassin.Dagger.Cast
	PrecacheResource("particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context)
	PrecacheUnitByNameAsync('npc_dota_hero_abaddon', function(...) end)
	PrecacheResource("particle", "particles/econ/items/legion/legion_overwhelming_odds_ti7/legion_commander_odds_ti7_hero.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_legion_commander.vsndevts", context) -- Hero_LegionCommander.Overwhelming.Location.ti7
	PrecacheResource("particle", "particles/econ/items/legion/legion_overwhelming_odds_ti7/legion_commander_odds_ti7.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_bane/bane_sap.vpcf", context)
	
	PrecacheUnitByNameAsync('npc_dota_hero_juggernaut', function(...) end)
	PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_arcana/jugg_arcana_haste.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_body_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_idle_rare.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_death_model.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_death_light.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_loadout_rare_model.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_idle_rare_energy.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_teleport_end_light.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_teleport_end_model.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_teleport_light.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_teleport_model.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_trigger.vpcf", context)
	
	PrecacheResource("particle", "particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_bounty_hunter/bounty_hunter_windwalk.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_bounty_hunter.vsndevts", context) -- Hero_BountyHunter.WindWalk Hero_BountyHunter.Shuriken.Impact Hero_BountyHunter.Shuriken
	
	PrecacheResource("particle", "particles/units/heroes/hero_bounty_hunter/bounty_hunter_suriken_toss.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_troll_warlord/troll_warlord_base_attack.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_lone_druid/lone_druid_base_attack.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_enchantress/enchantress_base_attack.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_techies/techies_base_attack.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_stifling_dagger_arcana.vpcf", context)	
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_enchantress.vsndevts", context) -- Hero_Enchantress.Attack Hero_Enchantress.ProjectileImpact
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_techies.vsndevts", context) -- Hero_Techies.Attack Hero_Techies.ProjectileImpact
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_troll_warlord.vsndevts", context) -- Hero_TrollWarlord.WhirlingAxes.Ranged Hero_TrollWarlord.ProjectileImpact
	PrecacheResource("particle", "particles/units/heroes/hero_invoker/invoker_death.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/invoker/invoker_ti7/invoker_ti7_bracer_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/sven/sven_warcry_ti5/sven_warcry_armor_buff_model_ti_5.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff_warp.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_sven.vsndevts", context) -- Hero_Sven.WarCry
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_huskar.vsndevts", context) -- Hero_Huskar.Inner_Vitality
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_arc_warden.vsndevts", context) -- Hero_ArcWarden.MagneticField.Cast
	PrecacheResource("soundfile", "soundevents/game_sounds_ramza.vsndevts", context)
	-- Hero_Chen.PenitenceImpact
	PrecacheResource("particle", "particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", context)
	
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_chaos_knight.vsndevts", context) -- Hero_ChaosKnight.ChaosBolt.Cast
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_magnataur.vsndevts", context) -- Hero_Magnataur.ShockWave.Cast Hero_Magnataur.ShockWave.Target 
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_riki.vsndevts", context)
	PrecacheResource("particle", "particles/econ/items/magnataur/shock_of_the_anvil/magnataur_shockanvil_hit.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/magnataur/shock_of_the_anvil/magnataur_shockanvil.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf", context)
	PrecacheResource("particle", "particles/status_fx/status_effect_doom.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/troll_warlord/troll_warlord_ti7_axe/troll_ti7_axe_bash_explosion.vpcf", context)
	PrecacheUnitByNameSync("npc_dota_hero_oracle", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_invoker.vsndevts", context) -- chaos meteor
	PrecacheResource("particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_skywrath_mage.vsndevts", context) -- Hero_SkywrathMage.ConcussiveShot.Target
	PrecacheResource("particle", "particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_enigma.vsndevts", context) -- Hero_Enigma.Black_Hole Hero_Enigma.Black_Hole.Cast
	PrecacheResource("particle", "particles/econ/items/medusa/medusa_daughters/medusa_daughters_mana_shield.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_medusa.vsndevts", context) -- Hero_Medusa.ManaShield.On Hero_Medusa.ManaShield.Off
	PrecacheResource("particle", "particles/units/heroes/hero_clinkz/clinkz_strafe.vpcf", context)	
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_clinkz.vsndevts", context) -- Hero_Clinkz.Strafe
	PrecacheResource("particle", "particles/econ/items/silencer/silencer_ti6/silencer_last_word_ti6_silence.vpcf", context)	
	PrecacheResource("particle", "particles/units/heroes/hero_oracle/oracle_fatesedict_disarm.vpcf", context)	
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_death_prophet.vsndevts", context) -- Hero_DeathProphet.Silence
	PrecacheResource("particle", "particles/econ/items/treant_protector/ti7_shoulder/treant_ti7_crimson_livingarmor.vpcf", context)	
	PrecacheResource("particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", context)	
	PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_slash_tgt.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts", context)-- Hero_Crystal.CrystalNova
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_treant.vsndevts", context)
	PrecacheResource("particle", "particles/status_fx/status_effect_templar_slow.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_serrakura/juggernaut_omni_slash_petals_serrakura.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_serrakura/juggernaut_omni_slash_tgt_serrakura.vpcf", context)
	
	PrecacheResource("particle", "particles/econ/items/invoker/invoker_ti6/invoker_tornado_ti6_funnel.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_lycan/lycan_howl_buff.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/kunkka/kunkka_weapon_whaleblade/kunkka_spell_torrent_splash_whaleblade.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_egset.vpcf", context)
	PrecacheResource("soundfile",	"soundevents/game_sounds_heroes/game_sounds_sandking.vsndevts", context) -- Ability.SandKing_SandStorm.loop Ability.SandKing_SandStorm.start
	
	PrecacheResource("soundfile",	"soundevents/game_sounds_heroes/game_sounds_silencer.vsndevts", context) 
	PrecacheResource("soundfile",	"soundevents/game_sounds_heroes/game_sounds_shadowshaman.vsndevts", context) 
	PrecacheResource("soundfile",	"soundevents/game_sounds_heroes/game_sounds_warlock.vsndevts", context) 
	PrecacheResource("soundfile",	"soundevents/game_sounds_heroes/game_sounds_phantom_lancer.vsndevts", context) 
	PrecacheResource("soundfile",	"soundevents/game_sounds_heroes/game_sounds_rubick.vsndevts", context) 
	PrecacheResource("soundfile",	"soundevents/game_sounds_heroes/game_sounds_sniper.vsndevts", context) 
	PrecacheResource("particle", "particles/units/heroes/hero_warlock/warlock_base_attack.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/phantom_lancer/ti7_immortal_shoulder/pl_ti7_edge_boost.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_enigma/enigma_midnight_pulse.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/necrolyte/necro_sullen_harvest/necro_ti7_immortal_scythe_start.vpcf", context)
	
	PrecacheResource("soundfile",	"soundevents/game_sounds_heroes/game_sounds_necrolyte.vsndevts", context) -- Hero_Necrolyte.ReapersScythe.Cast
	PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_fortunes_tout/jugg_healling_ward_fortunes_tout_gold_hero_heal.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_fortunes_tout/jugg_healing_ward_fortunes_tout_ward_gold.vpcf", context)
	PrecacheResource("soundfile",	"soundevents/game_sounds_heroes/game_sounds_nevermore.vsndevts", context)
	PrecacheResource("particle", "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_wings.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf", context)
	PrecacheResource("soundfile",	"soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts", context) -- 	
	PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_dual_breath_fire.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_snow_arcana1.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/mirana/mirana_starstorm_bow/mirana_starstorm_starfall_attack.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_mirana/mirana_starfall_moonray.vpcf", context)
	PrecacheResource("soundfile",	"soundevents/game_sounds_heroes/game_sounds_mirana.vsndevts", context) -- 	
	
	PrecacheResource("particle", "particles/units/heroes/hero_phantom_lancer/pl_attack_blur.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_phantom_lancer/pl_attack_blur_1.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_phantom_lancer/pl_attack_blur_2.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_phantom_lancer/pl_attack_blur_3.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_phantom_lancer/pl_attack_blur_4.vpcf", context)
	
	PrecacheResource("particle", "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_antimage/antimage_spellshield.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/axe/axe_cinder/axe_cinder_battle_hunger.vpcf", context)
	
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ember_spirit.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_hit.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash.vpcf", context)
	PrecacheResource("particle", "particles/status_fx/status_effect_gods_strength.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/ember_spirit/ember_spirit_vanishing_flame/ember_spirit_vanishing_flame_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_portrait_model.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_razor/razor_storm_lightning_strike.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_razor.vsndevts", context)
	
	PrecacheResource("particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_explosion.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_debuff.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf", context)
	
	PrecacheResource("particle", "particles/units/heroes/hero_shadowshaman/shadowshaman_voodoo.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_chen/chen_penitence.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", context)
	PrecacheResource("particle", "particles/healing_flask_modified.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_naga_siren.vsndevts", context)
end


-- Create the game mode class when we activate
function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
end

