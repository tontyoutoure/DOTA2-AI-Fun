RAMZA_JOB_SQUIRE = 1
RAMZA_JOB_CHEMIST = 2
RAMZA_JOB_KNIGHT = 3
RAMZA_JOB_ARCHER = 4
RAMZA_JOB_WHITE_MAGE = 5
RAMZA_JOB_BLACK_MAGE = 6
RAMZA_JOB_MONK = 7
RAMZA_JOB_THIEF = 8
RAMZA_JOB_MYSTIC = 9
RAMZA_JOB_TIME_MAGE = 10
RAMZA_JOB_ORATOR = 11
RAMZA_JOB_SUMMONER = 12
RAMZA_JOB_GEOMANCER = 13
RAMZA_JOB_DRAGOON = 14
RAMZA_JOB_SAMURAI = 15
RAMZA_JOB_NINJA = 16
RAMZA_JOB_ARITHMETICIAN = 17
RAMZA_JOB_MIME = 18
RAMZA_JOB_DARK_KNIGHT = 19
RAMZA_JOB_ONION_KNIGHT = 20

SELECT_JOB = 0;
SELECT_SECONDARY_SKILL = 1;

RAMZA_MENU_STATE_NORMAL = 0
RAMZA_MENU_STATE_UPGRADE = 1
RAMZA_MENU_STATE_PRIMARY = 2
RAMZA_MENU_STATE_SECONDARY = 3

CRamzaJob.tJobNames = {
	"ramza_job_squire",
	"ramza_job_chemist",
	"ramza_job_knight",
	"ramza_job_archer",
	"ramza_job_white_mage",
	"ramza_job_black_mage",
	"ramza_job_monk",
	"ramza_job_thief",
	"ramza_job_mystic",
	"ramza_job_time_mage",
	"ramza_job_orator",
	"ramza_job_summoner",
	"ramza_job_geomancer",
	"ramza_job_dragoon",
	"ramza_job_samurai",
	"ramza_job_ninja",
	"ramza_job_arithmetician",
	"ramza_job_mime",
	"ramza_job_dark_knight",
	"ramza_job_onion_knight"
}

CRamzaJob.tModifierJobKeep = {
	["ramza_white_mage_reraise"] = true;
}

CRamzaJob.tTimeMageAbilities = {
	ramza_time_mage_time_magicks_haste = true,
	ramza_time_mage_time_magicks_slow = true,
	ramza_time_mage_time_magicks_immobilize = true,
	ramza_time_mage_time_magicks_gravity = true,
	ramza_time_mage_time_magicks_quick = true,
	ramza_time_mage_time_magicks_stop = true,
	ramza_time_mage_time_magicks_meteor = true,
	ramza_time_mage_teleport = true
}

CRamzaJob.tRamzaJobReqirement = {0, 200, 400, 700, 1100, 1600, 2200, 3000, 4000}

CRamzaJob.tRamzaChangeJobRequirements = {
	{},
	{},
	{[RAMZA_JOB_SQUIRE] = 2},
	{[RAMZA_JOB_SQUIRE] = 2},
	{[RAMZA_JOB_CHEMIST] = 2},
	{[RAMZA_JOB_CHEMIST] = 2},
	{[RAMZA_JOB_KNIGHT] = 3},
	{[RAMZA_JOB_ARCHER] = 3},
	{[RAMZA_JOB_WHITE_MAGE] = 3},
	{[RAMZA_JOB_BLACK_MAGE] = 3},
	{[RAMZA_JOB_MYSTIC] = 3},
	{[RAMZA_JOB_TIME_MAGE] = 3},
	{[RAMZA_JOB_MONK] = 4},
	{[RAMZA_JOB_THIEF] = 4},
	{[RAMZA_JOB_KNIGHT] = 4, [RAMZA_JOB_MONK] = 5, [RAMZA_JOB_DRAGOON] = 2},
	{[RAMZA_JOB_ARCHER] = 4, [RAMZA_JOB_THIEF] = 5, [RAMZA_JOB_GEOMANCER] = 2},
	{[RAMZA_JOB_WHITE_MAGE] = 5, [RAMZA_JOB_BLACK_MAGE] = 5, [RAMZA_JOB_MYSTIC] = 4, [RAMZA_JOB_TIME_MAGE] = 4},
	{[RAMZA_JOB_SQUIRE] = 8, [RAMZA_JOB_CHEMIST] = 8, [RAMZA_JOB_ORATOR] = 5, [RAMZA_JOB_SUMMONER] = 5, [RAMZA_JOB_GEOMANCER] = 5, [RAMZA_JOB_DRAGOON] = 5},
	{[RAMZA_JOB_KNIGHT] = 9, [RAMZA_JOB_BLACK_MAGE] = 9, [RAMZA_JOB_SAMURAI] = 8, [RAMZA_JOB_NINJA] = 8, [RAMZA_JOB_GEOMANCER] = 8, [RAMZA_JOB_DRAGOON] = 8},
	{[RAMZA_JOB_SQUIRE] = 6, [RAMZA_JOB_CHEMIST] = 6}	
}


CRamzaJob.tJobModels = {
	{	-- Squire
		model = "models/heroes/dragon_knight/dragon_knight.vmdl",
		model_scale = 0.84,
		--[[
		wearables = {
			{ID = "66"},
			{ID = "67"}
		},
		]]--
		wearables = {
			{ID = "66", style = "0", model = "models/heroes/dragon_knight/weapon.vmdl", particle_systems = {}},
			{ID = "67", style = "0", model = "models/heroes/dragon_knight/shield.vmdl", particle_systems = {}},
		},
	},
	{	-- Chemist
		model = "models/heroes/sniper/sniper.vmdl",
		model_scale = 0.84,
		--[[
		wearables = {
			{ID = "9093"},
			{ID = "9097"},
			{ID = "9197", particle_systems = {{system = "particles/econ/items/sniper/sniper_immortal_cape/sniper_immortal_cape_ambient.vpcf", attach_type = PATTACH_CUSTOMORIGIN_FOLLOW, attach_entity = "self", control_points = {{control_point_index = 0, attachment = 'ArbitraryChain1_plc1'}}}}},
			{ID = "9095"},
			{ID = "9096"}
		},
		]]--
		wearables = {
			{ID = "9093", style = "0", model = "models/items/sniper/witch_hunter_set_head/witch_hunter_set_head.vmdl", particle_systems = {{system = "particles/econ/items/sniper/sniper_witch_hunter/sniper_witch_hunter_head_ambient.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "self", control_points = {{control_point_index = 2, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_head"}, {control_point_index = 1, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_eye_r"}, {control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_eye_l"}, }}, }},
			{ID = "9097", style = "0", model = "models/items/sniper/witch_hunter_set_weapon/witch_hunter_set_weapon.vmdl", particle_systems = {}},
			{ID = "9455", style = "0", model = "models/items/sniper/sniper_cape_immortal/sniper_cape_immortal.vmdl", skin = "1", particle_systems = {{system = "particles/econ/items/sniper/sniper_immortal_cape_golden/sniper_immortal_cape_golden_ambient.vpcf", attach_type = PATTACH_CUSTOMORIGIN_FOLLOW, attach_entity = "self", control_points = {{control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "ArbitraryChain1_plc1"}, }}, }},
			{ID = "9095", style = "0", model = "models/items/sniper/witch_hunter_set_arms/witch_hunter_set_arms.vmdl", particle_systems = {}},
			{ID = "9096", style = "0", model = "models/items/sniper/witch_hunter_set_shoulder/witch_hunter_set_shoulder.vmdl", particle_systems = {}},
		},
	},
	{	-- Knight
		model = "models/heroes/dragon_knight/dragon_knight.vmdl",
		model_scale = 0.84,
		--[[
		wearables = {
			{ID = "7438"},
			{ID = "9135"},
			{ID = "5084"},
			{ID = "7440"},
			{ID = "7439"},
			{ID = "8798"}
		},
		]]--
		wearables = 		{
			{ID = "7438", style = "0", model = "models/items/dragon_knight/dragon_lord_head/dragon_lord_head.vmdl", skin = "0", particle_systems = {{system = "particles/econ/items/dragon_knight/dragon_lord/dragon_lord_ambient_golden.vpcf", attach_type = PATTACH_ABSORIGIN_FOLLOW, attach_entity = "parent", control_points = {{control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_head"}, }}, }},
			{ID = "9135", style = "0", model = "models/items/dragon_knight/aurora_warrior_set_weapon/aurora_warrior_set_weapon.vmdl", particle_systems = {{system = "particles/econ/items/dragon_knight/dk_aurora_warrior/dk_aurora_warrior_weapon_ambient.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "self", control_points = {{control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_weapon"}, }}, }},
			{ID = "5084", style = "0", model = "models/items/dragon_knight/dragon_shield/dragon_shield.vmdl", particle_systems = {{system = "particles/econ/items/dragon_knight/dragon_shield/dragon_knight_dragon_shield_ambient.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "self", control_points = {{control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_gem"}, }}, }},
			{ID = "7440", style = "0", model = "models/items/dragon_knight/dragon_lord_shoulder/dragon_lord_shoulder.vmdl", skin = "0", particle_systems = {}},
			{ID = "7439", style = "0", model = "models/items/dragon_knight/dragon_lord_arms/dragon_lord_arms.vmdl", skin = "0", particle_systems = {}},
			{ID = "8798", style = "0", model = "models/items/dragon_knight/oblivion_blazer_back/oblivion_blazer_back.vmdl", particle_systems = {}},
		} ,
	},
	{	-- Archer
		attack_projectile = "particles/units/heroes/hero_clinkz/clinkz_base_attack.vpcf",
		model = "models/heroes/clinkz/clinkz.vmdl",
		model_scale = 0.65,
		--[[
		wearables = {
			{ID = "9162", particle_systems = {{system = "particles/econ/items/clinkz/clinkz_maraxiform/clinkz_maraxiform_ambient.vpcf", attach_entity = "self", attach_type = PATTACH_CUSTOMORIGIN_FOLLOW, control_points = {{control_point_index = 2, attachment = 'attach_top'}, {control_point_index = 5, attachment = 'attach_door_inside'}, {control_point_index = 6, attachment = 'attach_drip'}}}}},
			{ID = "7916", style = "1"},
			{ID = "7917", style = "1"},
			{ID = "7918", style = "1"},
			{ID = "7919", style = "1"}
		},
		]]--
		wearables = 		{
			{ID = "9162", style = "0", model = "models/items/clinkz/ti7_clinkz_immortal/ti7_clinkz_immortal.vmdl", particle_systems = {{system = "particles/econ/items/clinkz/clinkz_maraxiform/clinkz_maraxiform_ambient.vpcf", attach_type = PATTACH_CUSTOMORIGIN_FOLLOW, attach_entity = "self", control_points = {{control_point_index = 2, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_top"}, {control_point_index = 5, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_door_inside"}, {control_point_index = 6, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_drip"}, }}, }},
			{ID = "7916", style = "1", model = "models/items/clinkz/ti6_clinkz_weapon/ti6_clinkz_weapon.vmdl", skin = "1", particle_systems = {}},
			{ID = "7917", style = "1", model = "models/items/clinkz/ti6_clinkz_gloves/ti6_clinkz_gloves.vmdl", skin = "1", particle_systems = {}},
			{ID = "7918", style = "1", model = "models/items/clinkz/ti6_clinkz_head/ti6_clinkz_head.vmdl", skin = "1", particle_systems = {}},
			{ID = "7919", style = "1", model = "models/items/clinkz/ti6_clinkz_shoulder/ti6_clinkz_shoulder.vmdl", skin = "1", particle_systems = {}},
		} ,
	},
	{	-- White Mage
		attack_projectile = "particles/units/heroes/hero_keeper_of_the_light/keeper_base_attack.vpcf",
		model = "models/heroes/invoker/invoker.vmdl",
		model_scale = 0.74,
		wearables = {
			{ID = "98", style = "0", model = "models/heroes/invoker/invoker_head.vmdl", particle_systems = {}},
			{ID = "5867", style = "0", model = "models/items/invoker/iceforged_hair/iceforged_hair.vmdl", particle_systems = {}},
			{ID = "5494", style = "0", model = "models/items/invoker/arcane_drapings/arcane_drapings.vmdl", particle_systems = {}},
			{ID = "5491", style = "0", model = "models/items/invoker/arcane_shield/arcane_shield.vmdl", particle_systems = {}},
			{ID = "7821", style = "0", model = "models/items/invoker/immortal_arms_ti7/immortal_arms_ti7.vmdl", particle_systems = {{system = "particles/econ/items/invoker/invoker_ti7/invoker_ti7_bracer_ambient.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "self", control_points = {
				{control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_hand_l"}, 
				{control_point_index = 1, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_hand_r"},
			}}}},
			{ID = "6079", style = "0", model = "models/items/invoker/wraps_of_the_eastern_range/wraps_of_the_eastern_range.vmdl", particle_systems = {}},
		},
	},
	{	-- Black Mage
		attack_projectile = "particles/units/heroes/hero_lina/lina_base_attack.vpcf",
		model = "models/heroes/invoker/invoker.vmdl",
		model_scale = 0.74,
		--[[
		wearables = {
			{ID = "98"},
			{ID = "6441"},
			{ID = "7979"},
			{ID = "5156"},
			{ID = "7988"},
			{ID = "7989"}
		},
		]]--
		wearables = {
			{ID = "98", style = "0", model = "models/heroes/invoker/invoker_head.vmdl", particle_systems = {}},
			{ID = "6441", style = "0", model = "models/items/invoker/sempiternal_revelations_hat/sempiternal_revelations_hat.vmdl", particle_systems = {}},
			{ID = "7979", style = "0", model = "models/items/invoker/dark_artistry/dark_artistry_cape_model.vmdl", particle_systems = {{system = "particles/econ/items/invoker/invoker_ti6/invoker_ti6_cape_ambient.vpcf", attach_type = PATTACH_ABSORIGIN, attach_entity = "self", control_points = {{control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_spine"}, }}, }},
			{ID = "5156", style = "0", model = "models/items/invoker/immortal_armor/immortal_armor.vmdl", particle_systems = {}},
			{ID = "7988", style = "0", model = "models/items/invoker/dark_artistry/dark_artistry_bracer_model.vmdl", particle_systems = {}},
			{ID = "7989", style = "0", model = "models/items/invoker/dark_artistry/dark_artistry_belt_model.vmdl", particle_systems = {}},
		},
	},
	{	-- Monk
		model = "models/heroes/blood_seeker/blood_seeker.vmdl",
		model_scale=0.88,
		wearables = {
			{ID = "8736", style = "1", model = "models/items/blood_seeker/bloodseeker_relentless_hunter_head/bloodseeker_relentless_hunter_head.vmdl", particle_systems = {{system = "particles/econ/items/bloodseeker/bloodseeker_relentless_hunter/bloodseeker_relentless_hunter_ambient.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "self", control_points = {{control_point_index = 4, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_l_feathers"}, {control_point_index = 3, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_feathers"}, {control_point_index = 5, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_r_feathers"}, {control_point_index = 2, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_r_eye"}, {control_point_index = 1, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_l_eye"}, {control_point_index = 0, attach_type = PATTACH_ABSORIGIN_FOLLOW, }, }}, }},
			{ID = "8838", style = "0", model = "models/items/blood_seeker/bloodseeker_relentless_hunter_shoulder/bloodseeker_relentless_hunter_shoulder.vmdl", particle_systems = {}},
			{ID = "8837", style = "0", model = "models/items/blood_seeker/bloodseeker_relentless_hunter_belt/bloodseeker_relentless_hunter_belt.vmdl", particle_systems = {}},
			{ID = "8836", style = "0", model = "models/items/blood_seeker/bloodseeker_relentless_hunter_back/bloodseeker_relentless_hunter_back.vmdl", particle_systems = {}},
			{ID = "8835", style = "0", model = "models/items/blood_seeker/bloodseeker_relentless_hunter_arms/bloodseeker_relentless_hunter_arms.vmdl", particle_systems = {}},
		},
	},
	{	-- Thief
		model = "models/heroes/rikimaru/rikimaru.vmdl",
		model_scale = 0.870000,
		wearables = {
			{ID = "7990", style = "0", model = "models/items/rikimaru/ti6_blink_strike/riki_ti6_blink_strike.vmdl", skin = "1", particle_systems = {{system = "particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_ambient_gold.vpcf", attach_type = PATTACH_ABSORIGIN_FOLLOW, attach_entity = "self", control_points = {{control_point_index = 2, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_blade_r"}, {control_point_index = 1, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_blade_l"}, {control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_back"}, }}, }},
			{ID = "9434", style = "0", model = "models/items/rikimaru/riki_cunning_corsair_ti_2017_head/riki_cunning_corsair_ti_2017_head.vmdl", particle_systems = {{system = "particles/econ/items/riki/riki_cunning_crosair/riki_cunning_crosair_head_ambient.vpcf", attach_type = PATTACH_ABSORIGIN_FOLLOW, attach_entity = "self", }, }},
			{ID = "4823", style = "0", model = "models/items/rikimaru/weapon_yasha/weapon_yasha.vmdl", particle_systems = {}},
			{ID = "4824", style = "0", model = "models/items/rikimaru/offhand_sange/offhand_sange.vmdl", particle_systems = {}},
			{ID = "7162", style = "0", model = "models/items/rikimaru/haze_atrocity_tail/haze_atrocity_tail.vmdl", particle_systems = {{system = "particles/econ/items/riki/riki_haze_atrocity/riki_versuta_tail_smoke.vpcf", attach_type = PATTACH_POINT_FOLLOW, attach_entity = "self", control_points = {{control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_tail_smoke"}, }}, }},
		},
	},
	{	-- Mystic
		attack_projectile = "particles/units/heroes/hero_oracle/oracle_base_attack.vpcf",
		model = "models/heroes/oracle/oracle.vmdl",
		model_scale = 1,
		wearables = {
			{ID = "547", style = "0", model = "models/heroes/oracle/back_item.vmdl", particle_systems = {}},
			{ID = "548", style = "0", model = "models/heroes/oracle/head_item.vmdl", particle_systems = {}},
			{ID = "546", style = "0", model = "models/heroes/oracle/armor.vmdl", particle_systems = {}},
			{ID = "9232", style = "0", model = "models/items/oracle/ti7_immortal_weapon/oracle_ti7_immortal_weapon.vmdl", particle_systems = {{system = "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_ambient.vpcf", attach_entity = "parent", attach_type = PATTACH_ABSORIGIN_FOLLOW, control_points = {{control_point_index = 1, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_head"}, {control_point_index = 2, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_attack1"}, {control_point_index = 3, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_back"}}}}},
		}
	},
	{	-- Time Mage
		attack_projectile = "particles/units/heroes/hero_silencer/silencer_base_attack.vpcf",
		model = "models/heroes/silencer/silencer.vmdl",
		model_scale = 0.740000,
		wearables = {
			{ID = "8033", style = "0", model = "models/items/silencer/ti6_helmet/mesh/ti6_helmet.vmdl", particle_systems = {{system = "particles/econ/items/silencer/silencer_ti6/silencer_ti6_witness_ambient.vpcf", attach_type = PATTACH_CUSTOMORIGIN_FOLLOW, attach_entity = "self", control_points = {{control_point_index = 2, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_eye_r"}, {control_point_index = 1, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_eye_l"}, {control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_head"}, }}, }},
			{ID = "8124", style = "0", model = "models/items/silencer/bts_final_utterance_arms/bts_final_utterance_arms.vmdl", particle_systems = {}},
			{ID = "9111", style = "0", model = "models/items/silencer/the_hazhadal_magebreaker_belt/the_hazhadal_magebreaker_belt.vmdl", particle_systems = {}},
			{ID = "9110", style = "0", model = "models/items/silencer/the_hazhadal_magebreaker_off_hand/the_hazhadal_magebreaker_off_hand.vmdl", particle_systems = {}},
			{ID = "9114", style = "0", model = "models/items/silencer/the_hazhadal_magebreaker_shoulder/the_hazhadal_magebreaker_shoulder.vmdl", particle_systems = {}},
			{ID = "9109", style = "0", model = "models/items/silencer/the_hazhadal_magebreaker_weapon/the_hazhadal_magebreaker_weapon.vmdl", particle_systems = {}},
		}
	},
	{	-- Orator
		attack_projectile = "particles/units/heroes/hero_shadowshaman/shadowshaman_base_attack.vpcf",
		model = "models/heroes/shadowshaman/shadowshaman.vmdl",
		model_scale = 0.91,
		wearables = {
			{ID = "251", style = "0", model = "models/heroes/shadowshaman/head.vmdl", particle_systems = {}},
			{ID = "6915", style = "0", model = "models/items/shadowshaman/sheep_stick/sheep_stick.vmdl", particle_systems = {{system = "particles/econ/items/shadow_shaman/shadow_shaman_sheepstick/shadowshaman_stick_sheepstick.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "parent", control_points = {{control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_attack1"}, }}, }},
			{ID = "9885", style = "0", model = "models/items/shadowshaman/eyedancer_wrath_arms/eyedancer_wrath_arms.vmdl", particle_systems = {}},
			{ID = "9886", style = "0", model = "models/items/shadowshaman/eyedancer_wrath_belt/eyedancer_wrath_belt.vmdl", particle_systems = {}},
			{ID = "9887", style = "0", model = "models/items/shadowshaman/eyedancer_wrath_offhand/eyedancer_wrath_offhand.vmdl", particle_systems = {{system = "particles/econ/items/shadow_shaman/shadow_shaman_spiteful/shadowshaman_stick_spite_l.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "self", control_points = {{control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_attack2"}, }}, }},
			{ID = "8341", style = "1", model = "models/items/shadowshaman/eyedancer_wrath_head/eyedancer_wrath_head.vmdl", particle_systems = {{system = "particles/econ/items/shadow_shaman/shadow_shaman_spiteful/shadowshaman_stick_spite_head.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "self", control_points = {{control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_head"}, }}, }},
		},
	},
	{	-- Summoner
		attack_projectile = "particles/units/heroes/hero_keeper_of_the_light/keeper_base_attack.vpcf",
		model = "models/heroes/keeper_of_the_light/keeper_of_the_light.vmdl",
		model_scale = 0.8,
		wearables = {
			{ID = "9198", style = "0", model = "models/items/keeper_of_the_light/ti7_immortal_mount/kotl_ti7_immortal_horse.vmdl", particle_systems = {{system = "particles/econ/items/keeper_of_the_light/kotl_ti7_illuminate/kotl_ti7_immortal_ambient.vpcf", attach_entity = "self", attach_type = PATTACH_ABSORIGIN_FOLLOW}, {system = "particles/econ/items/keeper_of_the_light/kotl_ti7_illuminate/kotl_ti7_immortal_footsteps.vpcf", attach_entity = "self", attach_type = PATTACH_ABSORIGIN_FOLLOW}}},
			{ID = "9125", style = "0", model = "models/items/keeper_of_the_light/keeper_of_the_light_light_messenger_weapon/keeper_of_the_light_light_messenger_weapon.vmdl", particle_systems = {}},
			{ID = "9127", style = "0", model = "models/items/keeper_of_the_light/keeper_of_the_light_light_messenger_head/keeper_of_the_light_light_messenger_head.vmdl", particle_systems = {}},
			{ID = "9128", style = "0", model = "models/items/keeper_of_the_light/keeper_of_the_light_light_messenger_belt/keeper_of_the_light_light_messenger_belt.vmdl", particle_systems = {}},
		}
	},
	{	-- Geomancer
		attack_projectile = "particles/units/heroes/hero_warlock/warlock_base_attack.vpcf",
		model = "models/heroes/warlock/warlock.vmdl",
		model_scale = 0.930000,
		wearables = {
			{ID = "8947", style = "0", model = "models/items/warlock/mystery_of_the_lost_ores_off_hand/mystery_of_the_lost_ores_off_hand.vmdl", particle_systems = {{system = "particles/econ/items/warlock/warlock_lost_ores/warlock_lost_ores_offhand_glow.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "parent", control_points = {{control_point_index = 1, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_hitloc"}, {control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_attack2"}, }}, }},
			{ID = "8946", style = "0", model = "models/items/warlock/mystery_of_the_lost_ores_belt/mystery_of_the_lost_ores_belt.vmdl", particle_systems = {}},
			{ID = "8944", style = "0", model = "models/items/warlock/mystery_of_the_lost_ores_shoulder/mystery_of_the_lost_ores_shoulder.vmdl", particle_systems = {}},
			{ID = "8943", style = "0", model = "models/items/warlock/mystery_of_the_lost_ores_back/mystery_of_the_lost_ores_back.vmdl", particle_systems = {}},
			{ID = "8942", style = "0", model = "models/items/warlock/mystery_of_the_lost_ores_arms/mystery_of_the_lost_ores_arms.vmdl", particle_systems = {}},
			{ID = "8941", style = "0", model = "models/items/warlock/mystery_of_the_lost_ores_head/mystery_of_the_lost_ores_head.vmdl", particle_systems = {}},
			{ID = "7886", style = "0", model = "models/items/warlock/ceaseless/ceaseless.vmdl", particle_systems = {{system = "particles/econ/items/warlock/warlock_staff_ceaseless_ambient/warlock_ceaseless_ambient_glow.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "self", control_points = {{control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_core"}, }}, }},
		}
	},
	{	-- Dragoon
		model = "models/heroes/phantom_lancer/phantom_lancer.vmdl",
		model_scale = 0.84,
		--[[
		wearables = {
			{ID = "7557"},
			{ID = "127"},
			{ID = "7749"},
			{ID = "7746"},
			{ID = "7747"},
		},
		]]--
		wearables = {
			{ID = "7557", style = "0", model = "models/items/phantom_lancer/immortal_ti6/mesh/phantom_lancer_immortal_spear_mdoel.vmdl", particle_systems = {{system = "particles/econ/items/phantom_lancer/phantom_lancer_immortal_ti6/phantom_lancer_immortal_ti6.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "self", control_points = {{control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_weapon"}, }}, }},
			{ID = "127", style = "0", model = "models/heroes/phantom_lancer/phantom_lancer_head.vmdl", particle_systems = {}},
			{ID = "7817", style = "0", model = "models/items/phantom_lancer/phantom_lancer_ti7_immortal_shoulder/phantom_lancer_ti7_immortal_shoulder.vmdl", particle_systems = {{system = "particles/econ/items/phantom_lancer/ti7_immortal_shoulder/pl_ti7_immortal_ambient.vpcf", attach_type = PATTACH_ABSORIGIN_FOLLOW, attach_entity = "self"}}},
			{ID = "7746", style = "0", model = "models/items/phantom_lancer/vagabond_arms/vagabond_arms.vmdl", particle_systems = {}},
			{ID = "7747", style = "0", model = "models/items/phantom_lancer/vagabond_pants/vagabond_pants.vmdl", particle_systems = {}},
		},
	},
	{	-- Samurai
		model = "models/heroes/juggernaut/juggernaut_arcana.vmdl",
		model_scale = 0.85,
		--[[
		wearables = {
			{ID = "4401"},
			{ID = "4101"},
			{ID = "8983"},
			{ID = "8982"},
			{ID = "9059", style = "1", particle_systems = {{system = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_ambient.vpcf", attach_type = PATTACH_ABSORIGIN_FOLLOW, attach_entity = "self", control_points = {{control_point_index = 0, attachment = "attach_hitloc"}}}, {system = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_body_ambient.vpcf", attach_type = PATTACH_ABSORIGIN_FOLLOW, attach_entity = "parent"}}}
		},
		]]--
		
		wearables = 		{
			{ID = "4401", style = "0", model = "models/items/juggernaut/thousand_faces_hakama/thousand_faces_hakama.vmdl", particle_systems = {}},
			{ID = "4101", style = "0", model = "models/items/juggernaut/generic_wep_broadsword.vmdl", particle_systems = {{system = "particles/econ/items/juggernaut/jugg_sword_script/jugg_weapon_glow_variation_script.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "parent", control_points = {{control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_sword"}, }}, }},
			{ID = "8983", style = "0", model = "models/items/juggernaut/armor_for_the_favorite_back/armor_for_the_favorite_back.vmdl", particle_systems = {{system = "particles/econ/items/juggernaut/armor_of_the_favorite/juggernaut_favorite_shoulder_ambient.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "parent", control_points = {{control_point_index = 0, attach_type = PATTACH_ABSORIGIN_FOLLOW, }, }}, }},
			{ID = "8982", style = "0", model = "models/items/juggernaut/armor_for_the_favorite_arms/armor_for_the_favorite_arms.vmdl", particle_systems = {}},
			{ID = "9059", style = "1", model = "models/items/juggernaut/arcana/juggernaut_arcana_mask.vmdl", skin = "1", particle_systems = {{system = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_ambient.vpcf", attach_type = PATTACH_ABSORIGIN_FOLLOW, attach_entity = "self", control_points = {{control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_hitloc"}, }}, {system = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_body_ambient.vpcf", attach_type = PATTACH_ABSORIGIN_FOLLOW, attach_entity = "parent", }, }},
		},
		model_material_group = 1,
	},
	{	-- Ninja
		model = "models/heroes/bounty_hunter/bounty_hunter.vmdl",
		model_scale = 0.84,
		--[[
		wearables = {
			{ID = "8424"},
			{ID = "8433"},
			{ID = "8439"},
			{ID = "8458"},
			{ID = "8461"},
			{ID = "8464"},
			
		},
		]]--
		wearables = {
			{ID = "8424", style = "0", model = "models/items/bounty_hunter/bounty_scout_offhand/bounty_scout_offhand.vmdl", particle_systems = {}},
			{ID = "8433", style = "0", model = "models/items/bounty_hunter/bounty_scout_shoulder/bounty_scout_shoulder.vmdl", particle_systems = {}},
			{ID = "8439", style = "0", model = "models/items/bounty_hunter/bounty_scout_back/bounty_scout_back.vmdl", particle_systems = {}},
			{ID = "8458", style = "0", model = "models/items/bounty_hunter/bounty_scout_weapon/bounty_scout_weapon.vmdl", particle_systems = {}},
			{ID = "8461", style = "0", model = "models/items/bounty_hunter/bounty_scout_armor/bounty_scout_armor.vmdl", particle_systems = {}},
			{ID = "8464", style = "0", model = "models/items/bounty_hunter/bounty_scout_head/bounty_scout_head.vmdl", particle_systems = {}},
		},
	},
	{	-- Arithmetician
		attack_projectile = "particles/econ/items/rubick/rubick_staff_wandering/rubick_base_attack_whset.vpcf",
		model = "models/heroes/rubick/rubick.vmdl",
		model_scale = 0.7,
		--[[
		wearables = {
			{ID = "7026"},
			{ID = "7507"},
			{ID = "8108"},
			{ID = "8592"},
			{ID = "8393"}
		},
		]]--
		wearables = {
			{ID = "7026", style = "0", model = "models/items/rubick/harlequin_head_black/harlequin_head_black.vmdl", particle_systems = {}},
			{ID = "7507", style = "0", model = "models/items/rubick/force_staff/force_staff.vmdl", particle_systems = {{system = "particles/econ/items/rubick/rubick_force_gold_ambient/rubick_force_ambient_gold.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "self", control_points = {{control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_staff_ambient"}, }}, }},
			{ID = "8108", style = "0", model = "models/items/rubick/golden_ornithomancer_mantle/golden_ornithomancer_mantle.vmdl", particle_systems = {{system = "particles/econ/items/rubick/rubick_ornithomancer_gold/rubick_ornithomancer_gold_ambient.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "parent", control_points = {{control_point_index = 1, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_thorax"}, {control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_hitloc"}, }}, }},
			{ID = "8592", style = "0", model = "models/items/rubick/puppet_master_doll/puppet_master_doll.vmdl", particle_systems = {{system = "particles/econ/items/rubick/rubick_puppet_master/rubick_doll_puppet_ambient.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "self", control_points = {{control_point_index = 2, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_doll_mouth"}, {control_point_index = 1, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_doll_eye_r"}, {control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_doll_eye_l"}, }}, }},
			{ID = "8393", style = "0", model = "models/items/rubick/gemini_juggler_shoulder/gemini_juggler_shoulder.vmdl", particle_systems = {}},
		},
	},
	{	-- Mime
		attack_projectile = "particles/units/heroes/hero_bane/bane_projectile.vpcf",
		model = "models/heroes/bane/bane.vmdl",
		model_scale = 0.93,
		--[[
		wearables = {
			{ID = "7941"},
			{ID = "7942"},
			{ID = "7943"},
			{ID = "7692"}
		},
		]]--
		wearables = {
			{ID = "7941", style = "0", model = "models/items/bane/heir_of_terror_bane_head/heir_of_terror_bane_head.vmdl", particle_systems = {}},
			{ID = "7942", style = "0", model = "models/items/bane/heir_of_terror_bane_arms/heir_of_terror_bane_arms.vmdl", particle_systems = {}},
			{ID = "7943", style = "0", model = "models/items/bane/heir_of_terror_bane_back/heir_of_terror_bane_back.vmdl", particle_systems = {}},
			{ID = "7692", style = "0", model = "models/items/bane/slumbering_terror/slumbering_terror.vmdl", particle_systems = {{system = "particles/econ/items/bane/slumbering_terror/bane_slumbering_terror_ambient.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "self", control_points = {{control_point_index = 0, attach_type = PATTACH_ABSORIGIN_FOLLOW, }, {control_point_index = 2, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_elbow_l"}, {control_point_index = 1, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_elbow_r"}, }}, }},
		},
	},
	{	-- Dark Knight
		model = "models/heroes/abaddon/abaddon.vmdl",
		model_scale = 0.78,
		--[[
		wearables = 		
		{
			{ID = "5561"},
			{ID = "6408"},
			{ID = "6409"},
			{ID = "6410", particle_systems = {{system = "particles/units/heroes/hero_abaddon/abaddon_ambient.vpcf", attach_entity = "parent", attach_type = PATTACH_ABSORIGIN_FOLLOW}}},
			{ID = "6411"},
		},]]--
		wearables = 		{
			{ID = "5561", style = "0", model = "models/items/abaddon/phantoms_reaper/phantoms_reaper.vmdl", particle_systems = {{system = "particles/units/heroes/hero_abaddon/abaddon_blade.vpcf", attach_type = PATTACH_CUSTOMORIGIN, attach_entity = "parent", control_points = {{control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_attack1"}, }}, }},
			{ID = "6408", style = "0", model = "models/items/abaddon/alliance_abba_back/alliance_abba_back.vmdl", particle_systems = {}},
			{ID = "6409", style = "0", model = "models/items/abaddon/alliance_abba_head/alliance_abba_head.vmdl", particle_systems = {}},
			{ID = "6410", style = "0", model = "models/items/abaddon/alliance_abba_mount/alliance_abba_mount.vmdl", particle_systems = {{system = "particles/units/heroes/hero_abaddon/abaddon_ambient.vpcf", attach_type = PATTACH_ABSORIGIN_FOLLOW, attach_entity = "parent", }, }},
			{ID = "6411", style = "0", model = "models/items/abaddon/alliance_abba_shoulder/alliance_abba_shoulder.vmdl", particle_systems = {}},
		},
	},
	{	-- Onion knight
		model = "models/heroes/kunkka/kunkka.vmdl",
		model_scale = 0.84,
		--[[
		wearables = {
			{ID = "5670"},
			{ID = "5321", particle_systems = {{system = "particles/econ/items/kunkka/kunkka_weapon_shadow/kunkka_weapon_tidebringer_shadow.vpcf", attach_type = PATTACH_ABSORIGIN_FOLLOW, attach_entity = "parent", control_points = {{control_point_index = 2, attachment = "attach_sword"}, {control_point_index = 0, attachment = "attach_tidebringer"}, {control_point_index = 1, attachment = "attach_tidebringer_2"}}}}},
			{ID = "5373"},
			{ID = "9115", particle_systems = {{system = "particles/econ/items/kunkka/kunkka_immortal/kunkka_immortal_ambient.vpcf", attach_type = PATTACH_CUSTOMORIGIN_FOLLOW, attach_entity = "self", control_points = {{control_point_index = 0, attachment = "attach_shark"}, {control_point_index = 3, attachment = "attach_shark_eye_l"}, {control_point_index = 6, attachment = "attach_shark_eye_r"}}}}},
			{ID = "5669"},
			{ID = "4500"},
			{ID = "5385"},
			{ID = "5661"}
		},
		]]--
		wearables = {
			{ID = "5670", style = "0", model = "models/items/kunkka/singsingkunkkaset_head/singsingkunkkaset_head.vmdl", particle_systems = {}},
			{ID = "5321", style = "0", model = "models/items/kunkka/kunkka_shadow_blade/kunkka_shadow_blade.vmdl", particle_systems = {{system = "particles/econ/items/kunkka/kunkka_weapon_shadow/kunkka_weapon_tidebringer_shadow.vpcf", attach_type = PATTACH_ABSORIGIN_FOLLOW, attach_entity = "parent", control_points = {{control_point_index = 2, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_sword"}, {control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_tidebringer"}, {control_point_index = 1, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_tidebringer_2"}, }}, }},
			{ID = "5373", style = "0", model = "models/items/kunkka/singkunkkabackfinal/singkunkkabackfinal.vmdl", particle_systems = {}},
			{ID = "9115", style = "0", model = "models/items/kunkka/kunkka_immortal/kunkka_shoulder_immortal.vmdl", skin = "0", particle_systems = {{system = "particles/econ/items/kunkka/kunkka_immortal/kunkka_immortal_ambient.vpcf", attach_type = PATTACH_CUSTOMORIGIN_FOLLOW, attach_entity = "self", control_points = {{control_point_index = 0, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_shark"}, {control_point_index = 3, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_shark_eye_l"}, {control_point_index = 6, attach_type = PATTACH_POINT_FOLLOW, attachment = "attach_shark_eye_r"}, }}, }},
			{ID = "5669", style = "0", model = "models/items/kunkka/singsingkunkkaset_gloves/singsingkunkkaset_gloves.vmdl", particle_systems = {}},
			{ID = "4500", style = "0", model = "models/items/kunkka/singkunkabelt_final/singkunkabelt_final.vmdl", particle_systems = {}},
			{ID = "5385", style = "0", model = "models/items/kunkka/singsingkunkkaset__cannon/singsingkunkkaset__cannon.vmdl", particle_systems = {}},
			{ID = "5661", style = "0", model = "models/items/kunkka/singsingkunkkaset_boots/singsingkunkkaset_boots.vmdl", particle_systems = {}},
		},
	},
}



CRamzaJob.tJobStats = {
	{	--Squire
		primary_attribute = DOTA_ATTRIBUTE_STRENGTH,
		base_str = 19,
		base_agi = 19,
		base_int = 19,
		gain_str = 2.5,
		gain_agi = 2.5,
		gain_int = 2.5,
		armor = 1,
		attack_range = 150,
		attack_point = 0.39,
		attack_cap = DOTA_UNIT_CAP_MELEE_ATTACK,
		move_speed = 300,
	},
	{	--Chemist
		primary_attribute = DOTA_ATTRIBUTE_INTELLECT,
		base_str = 15,
		base_agi = 17,
		base_int = 23,
		gain_str = 2.2,
		gain_agi = 1.7,
		gain_int = 2.7,
		armor = 0,
		attack_range = 600,
		attack_point = 0.17,
		attack_cap = DOTA_UNIT_CAP_MELEE_ATTACK,

		move_speed = 280,
	},
	{	--Knight
		primary_attribute = DOTA_ATTRIBUTE_STRENGTH,
		base_str = 27,
		base_agi = 16,
		base_int = 12,
		gain_str = 3.4,
		gain_agi = 2.1,
		gain_int = 1.1,
		armor = 0,
		attack_range = 150,
		attack_point = 0.5,
		attack_cap = DOTA_UNIT_CAP_MELEE_ATTACK,
		move_speed = 300,
	},
	{	--Archer
		primary_attribute = DOTA_ATTRIBUTE_AGILITY,
		base_str = 11,
		base_agi = 30,
		base_int = 14,
		gain_str = 1.5,
		gain_agi = 3.6,
		gain_int = 1.5,
		armor = 0,
		attack_range = 625,
		attack_point = 0.72,
		attack_cap = DOTA_UNIT_CAP_RANGED_ATTACK,
		move_speed = 305,
	},
	{	-- White Mage
		primary_attribute = DOTA_ATTRIBUTE_INTELLECT,
		base_str = 11,
		base_agi = 11,
		base_int = 33,
		gain_str = 1.6,
		gain_agi = 1.3,
		gain_int = 3.7,
		armor = 1,
		attack_range = 550,
		attack_point = 0.59,
		attack_cap = DOTA_UNIT_CAP_RANGED_ATTACK,
		move_speed = 290,
	},
	{	-- Black Mage
		primary_attribute = DOTA_ATTRIBUTE_INTELLECT,
		base_str = 13,
		base_agi = 11,
		base_int = 31,
		gain_str = 2.3,
		gain_agi = 1.1,
		gain_int = 3.2,
		armor = 1,
		attack_range = 500,
		attack_point = 0.59,
		attack_cap = DOTA_UNIT_CAP_RANGED_ATTACK,
		move_speed = 300,
	},
	{	--Monk
		primary_attribute = DOTA_ATTRIBUTE_STRENGTH,
		base_str = 23,
		base_agi = 23,
		base_int = 9,
		gain_str = 2.9,
		gain_agi = 2.6,
		gain_int = 1.1,
		armor = 0,
		attack_range = 150,
		attack_point = 0.43,
		attack_cap = DOTA_UNIT_CAP_MELEE_ATTACK,
		move_speed = 300,
	},
	{	--Thief
		primary_attribute = DOTA_ATTRIBUTE_AGILITY,
		base_str = 10,
		base_agi = 33,
		base_int = 12,
		gain_str = 1.6,
		gain_agi = 3.6,
		gain_int = 1.4,
		armor = 1,
		attack_range = 150,
		attack_point = 0.3,
		attack_cap = DOTA_UNIT_CAP_MELEE_ATTACK,
		move_speed = 305,
	},
	{	--Mystic
		primary_attribute = DOTA_ATTRIBUTE_INTELLECT,
		base_str = 15,
		base_agi = 13,
		base_int = 27,
		gain_str = 1.9,
		gain_agi = 1.3,
		gain_int = 3.4,
		armor = 1,
		attack_range = 575,
		attack_point = 0.3,
		attack_cap = DOTA_UNIT_CAP_RANGED_ATTACK,
		move_speed = 285,
	},
	{	--Time Mage
		primary_attribute = DOTA_ATTRIBUTE_INTELLECT,
		base_str = 12,
		base_agi = 19,
		base_int = 24,
		gain_str = 1.4,
		gain_agi = 2.3,
		gain_int = 2.9,
		armor = 1,
		attack_range = 500,
		attack_point = 0.5,
		attack_cap = DOTA_UNIT_CAP_RANGED_ATTACK,
		move_speed = 295,
	},
	{	--Orator
		primary_attribute = DOTA_ATTRIBUTE_INTELLECT,
		base_str = 17,
		base_agi = 18,
		base_int = 20,
		gain_str = 2.1,
		gain_agi = 1.7,
		gain_int = 2.8,
		armor = 1,
		attack_range = 400,
		attack_point = 0.2,
		attack_cap = DOTA_UNIT_CAP_RANGED_ATTACK,
		move_speed = 305,
	},
	{	--Summoner
		primary_attribute = DOTA_ATTRIBUTE_INTELLECT,
		base_str = 13,
		base_agi = 17,
		base_int = 25,
		gain_str = 1.6,
		gain_agi = 1.7,
		gain_int = 3.3,
		armor = 0,
		attack_range = 600,
		attack_point = 0.55,
		attack_cap = DOTA_UNIT_CAP_RANGED_ATTACK,
		move_speed = 300,
	},
	{	--Geomancer
		primary_attribute = DOTA_ATTRIBUTE_STRENGTH,
		base_str = 24,
		base_agi = 13,
		base_int = 18,
		gain_str = 2.8,
		gain_agi = 1.7,
		gain_int = 1.8,
		armor = 1,
		attack_range = 500,
		attack_point = 0.55,
		attack_cap = DOTA_UNIT_CAP_RANGED_ATTACK,
		move_speed = 310,
	},
	{	--Dragoon
		primary_attribute = DOTA_ATTRIBUTE_AGILITY,
		base_str = 22,
		base_agi = 22,
		base_int = 11,
		gain_str = 2.8,
		gain_agi = 2.5,
		gain_int = 1.0,
		armor = 0,
		attack_range = 150,
		attack_point = 0.3,
		attack_cap = DOTA_UNIT_CAP_MELEE_ATTACK,
		move_speed = 315,
	},
	{	--Samurai
		primary_attribute = DOTA_ATTRIBUTE_STRENGTH,
		base_str = 23,
		base_agi = 18,
		base_int = 14,
		gain_str = 3.3,
		gain_agi = 2.0,
		gain_int = 1.0,
		armor = 0,
		attack_range = 150,
		attack_point = 0.33,
		attack_cap = DOTA_UNIT_CAP_MELEE_ATTACK,
		move_speed = 315,
	},
	{	--Ninja
		primary_attribute = DOTA_ATTRIBUTE_AGILITY,
		base_str = 15,
		base_agi = 28,
		base_int = 12,
		gain_str = 1.7,
		gain_agi = 3.6,
		gain_int = 1.0,
		armor = 0,
		attack_range = 150,
		attack_point = 0.3,
		attack_cap = DOTA_UNIT_CAP_MELEE_ATTACK,
		move_speed = 320,
	},
	{	-- Arithmetician
		primary_attribute = DOTA_ATTRIBUTE_INTELLECT,
		base_str = 8,
		base_agi = 7,
		base_int = 40,
		gain_str = 1.3,
		gain_agi = 1,
		gain_int = 4,
		armor = 0,
		attack_range = 700,
		attack_point = 0.4,
		attack_cap = DOTA_UNIT_CAP_RANGED_ATTACK,
		move_speed = 295,
	},
	{	--Mime
		primary_attribute = DOTA_ATTRIBUTE_INTELLECT,
		base_str = 18,
		base_agi = 18,
		base_int = 18,
		gain_str = 2.4,
		gain_agi = 2.4,
		gain_int = 2.4,
		armor = 1,
		attack_range = 600,
		attack_point = 0.3,
		attack_cap = DOTA_UNIT_CAP_RANGED_ATTACK,

		move_speed = 300,
	},
	{	--Dark Knight
		primary_attribute = DOTA_ATTRIBUTE_STRENGTH,
		base_str = 30,
		base_agi = 30,
		base_int = 30,
		gain_str = 3.3,
		gain_agi = 3.3,
		gain_int = 3.3,
		armor = 0,
		attack_range = 150,
		attack_point = 0.433,
		attack_cap = DOTA_UNIT_CAP_MELEE_ATTACK,

		move_speed = 300,
	},
	{	--Onion knight
		primary_attribute = DOTA_ATTRIBUTE_AGILITY,
		base_str = 40,
		base_agi = 40,
		base_int = 40,
		gain_str = 5.3,
		gain_agi = 5.3,
		gain_int = 5.3,		
		armor = 1,
		attack_range = 150,
		attack_cap = DOTA_UNIT_CAP_MELEE_ATTACK,
		attack_point = 0.433,
		move_speed = 345,
	}
	
}



CRamzaJob.tJobCommands = {
	{	-- Squire: Fundaments Lvl 1 - Stone, Rush|nLvl 2 - Focus|nLvl 3 - Counter Tackle|nLvl 4 - Tailwind|nLvl 5 - Defend|nLvl 6 - Chant|nLvl 7 - Move +1|nLvl 8 - Shout|nMastered - |c00ff8000Ultima
		{"ramza_squire_fundamental_stone", "ramza_squire_fundamental_rush"},
		{"ramza_squire_fundamental_focus"},
		{},
		{"ramza_squire_fundamental_tailwind"},
		{},
		{"ramza_squire_fundamental_chant"},
		{},
		{"ramza_squire_fundamental_shout"},
		{"ramza_squire_fundamental_ultima"}
	},
	{	-- Chemist: Items|r|nLvl 1 - Potion, Ether|nLvl 2 - Hi-Potion|nLvl 3 - Auto-Potion|nLvl 4 - Hi-Ether|nLvl 5 - Treasure Hunter|nLvl 6 - Remedy|nLvl 7 - Throw Items|nLvl 8 - Phoenix Down|nMastered - |c00ff8000Elixir
		{"ramza_chemist_items_potion", "ramza_chemist_items_ether"},
		{"ramza_chemist_items_hipotion"},
		{},
		{"ramza_chemist_items_hiether"},
		{},
		{"ramza_chemist_items_remedy"},
		{},
		{"ramza_chemist_items_phoenix_down"},
		{"ramza_chemist_items_elixir"}
	},
	{	-- Knight: Arts of War|r|nLvl 1 - Rend Power, Rend Magick|nLvl 2 - Rend Speed|nLvl 3 - Parry|nLvl 4 - Rend MP|nLvl 5 - Heavy Armor|nLvl 6 - Rend Armor|nLvl 7 - Knight Sword|nLvl 8 - Rend Weapon|nMastered - |c00ff8000Rend Helm
		{"ramza_knight_aow_rend_power", "ramza_knight_aow_rend_magick"},
		{"ramza_knight_aow_rend_speed"},
		{},
		{"ramza_knight_aow_rend_mp"},
		{},
		{"ramza_knight_aow_rend_armor"},
		{},
		{"ramza_knight_aow_rend_weapon"},
		{"ramza_knight_aow_rend_helm"}
	},
	{	-- Archer: Aim|r|nLvl 1 - Aim +2|nLvl 2 - Aim +4|nLvl 3 - Adrenaline Rush|nLvl 4 - Aim +6|nLvl 5 - Archer's Bane|nLvl 6 - Aim +7|nLvl 7 - Concentration|nLvl 8 - Aim +10|nMastered - |c00ff8000Aim +20
		{"ramza_archer_aim_2"},
		{"ramza_archer_aim_4"},
		{},
		{"ramza_archer_aim_6"},
		{},
		{"ramza_archer_aim_7"},
		{},
		{"ramza_archer_aim_10"},
		{"ramza_archer_aim_20"}
	},
	{	-- White Mage: White Magicks|r|nLvl 1 - Cure, Regen|nLvl 2 - Protect, Shell|nLvl 3 - Regenerate|nLvl 4 - Cura|nLvl 5 - Arcane Defense|nLvl 6 - Wall|nLvl 7 - Reraise|nLvl 8 - Curaga|nMastered - |c00ff8000Holy
		{"ramza_white_mage_white_magicks_cure", "ramza_white_mage_white_magicks_regen"},
		{"ramza_white_mage_white_magicks_protect", "ramza_white_mage_white_magicks_shell"},
		{},
		{"ramza_white_mage_white_magicks_cura"},
		{},
		{"ramza_white_mage_white_magicks_wall"},
		{},
		{"ramza_white_mage_white_magicks_curaga"},
		{"ramza_white_mage_white_magicks_holy"}
	},
	{	-- Black Mage: Black Magicks|r|nLvl 1 - Fire, Blizzard|nLvl 2 - Thunder|nLvl 3 - Arcane Strength|nLvl 4 - Poison|nLvl 5 - Magick Counter|nLvl 6 - Toad|nLvl 7 - Death|nLvl 8 - Firaga, Blizzaga, Thundaga|nMastered - |c00ff8000Flare
		{"ramza_black_mage_black_magicks_fire", "ramza_black_mage_black_magicks_blizzard"},
		{"ramza_black_mage_black_magicks_thunder"},
		{},
		{"ramza_black_mage_black_magicks_poison"},
		{},
		{"ramza_black_mage_black_magicks_toad"},
		{},
		{"ramza_black_mage_black_magicks_firaga", "ramza_black_mage_black_magicks_blizzaga", "ramza_black_mage_black_magicks_thundaga"},		
		{"ramza_black_mage_black_magicks_flare"},		
	},
	{	-- Monk: Martial Arts|r|nLvl 1 - Pummel|nLvl 2 - Purification|nLvl 3 - Brawler|nLvl 4 - Aurablast|nLvl 5 - Lifefont|nLvl 6 - Chakra|nLvl 7 - Critical: Recover HP|nLvl 8 - Shockwave|nMastered - |c00ff8000Doom Fist
		{"ramza_monk_martial_arts_pummel"},
		{"ramza_monk_martial_arts_purification"},
		{},
		{"ramza_monk_martial_arts_aurablast"},
		{},
		{"ramza_monk_martial_arts_chakra"},
		{},
		{"ramza_monk_martial_arts_shockwave"},
		{"ramza_monk_martial_arts_doom_fist"},
	},
	{	-- Thief: Steal|r|nLvl 1 - Steal Gil|nLvl 2 - Steal Heart|nLvl 3 - Move +2|nLvl 4 - Steal EXP|nLvl 5 - Vigilance|nLvl 6 - Steal Armor|nLvl 7 - Gil Snapper|nLvl 8 - Steal Weapon|nMastered - |c00ff8000Steal Accessory
		{"ramza_thief_steal_gil"},
		{"ramza_thief_steal_heart"},
		{},
		{"ramza_thief_steal_exp"},
		{},
		{"ramza_thief_steal_armor"},
		{},
		{"ramza_thief_steal_weapon"},
		{"ramza_thief_steal_accessory"},
	},
	{	-- Mystic:  Mystic Arts|r|nLvl 1 - Umbra|nLvl 2 - Empowerment|nLvl 3 - Defense Boost|nLvl 4 - Disbelief|nLvl 5 - Manafont|nLvl 6 - Hesitation|nLvl 7 - Absorb MP|nLvl 8 - Quiescence|nMastered - |c00ff8000Invigoration
		{"ramza_mystic_mystic_arts_umbra"},
		{"ramza_mystic_mystic_arts_empowerment"},
		{},
		{"ramza_mystic_mystic_arts_disbelief"},
		{},
		{"ramza_mystic_mystic_arts_hesitation"},
		{},
		{"ramza_mystic_mystic_arts_quiescence"},
		{"ramza_mystic_mystic_arts_invigoration"},
	},
	{	-- Time Mage: Time Magicks|r|nLvl 1 - Haste, Slow|nLvl 2 - Immobilize|nLvl 3 - Mana Shield|nLvl 4 - Gravity|nLvl 5 - Teleport|nLvl 6 - Quick|nLvl 7 - Swiftness|nLvl 8 - Stop|nMastered - |c00ff8000Meteor
		{"ramza_time_mage_time_magicks_haste", "ramza_time_mage_time_magicks_slow"},
		{"ramza_time_mage_time_magicks_immobilize"},
		{},
		{"ramza_time_mage_time_magicks_gravity"},
		{},
		{"ramza_time_mage_time_magicks_quick"},
		{},
		{"ramza_time_mage_time_magicks_stop"},
		{"ramza_time_mage_time_magicks_meteor"},
	},
	{	-- Orator: Speechcraft|r|nLvl 1 - Praise, Preach|nLvl 2 - Mimic Darlavon|nLvl 3 - Enlighten|nLvl 4 - Entice|nLvl 5 - Intimidate|nLvl 6 - Beg|nLvl 7 - Beast Tongue|nLvl 8 - Stall|nMastered - |c00ff8000Condemn
		{"ramza_orator_speechcraft_praise", "ramza_orator_speechcraft_preach"},
		{"ramza_orator_speechcraft_mimic_darlavon"},
		{},
		{"ramza_orator_speechcraft_entice"},
		{},
		{"ramza_orator_speechcraft_beg"},
		{},
		{"ramza_orator_speechcraft_stall"},
		{"ramza_orator_speechcraft_condemn"},
	},
	{	-- Summoner: Summon|r|nLvl 1 - Moogle|nLvl 2 - Shiva, Ifrit|nLvl 3 - Critical: Recover MP|nLvl 4 - Ramuh|nLvl 5 - Lich|nLvl 6 - Golem|nLvl 7 - Odin|nLvl 8 - Bahamut|nMastered - |c00ff8000Zodiark
		{"ramza_summoner_summon_moogle"},
		{"ramza_summoner_summon_shiva", "ramza_summoner_summon_ifrit"},
		{},
		{"ramza_summoner_summon_ramuh"},
		{},
		{"ramza_summoner_summon_golem"},
		{},
		{"ramza_summoner_summon_bahamut"},
		{"ramza_summoner_summon_zodiark"},
	},
	{	-- Geomancer: Geomancy|r|nLvl 1 - Sinkhole|nLvl 2 - Torrent|nLvl 3 - Contortion|nLvl 4 - Will-o'-the-Wisp|nLvl 5 - Attack Boost|nLvl 6 - Sandstorm|nLvl 7 - Wind Blast|nLvl 8 - Tanglevine|nMastered - |c00ff8000Magma Surge
		{"ramza_geomancer_geomancy_sinkhole"},
		{"ramza_geomancer_geomancy_torrent"},
		{},
		{"ramza_geomancer_geomancy_willothewisp"},
		{},
		{"ramza_geomancer_geomancy_sand_storm"},
		{},
		{"ramza_geomancer_geomancy_tanglevine"},
		{"ramza_geomancer_geomancy_magma_surge"},
	}, 
	{	-- Dragoon: Jump|r|nLvl 1 - Jump|nLvl 2 - Jump 2|nLvl 3 - Polearm|nLvl 4 - Jump 3|nLvl 5 - Ignore Elevation|nLvl 6 - Jump 4|nLvl 7 - Dragonheart|nLvl 8 - Jump 5|nMastered - |c00ff8000Jump 8
		{"ramza_dragoon_jump1"},
		{"ramza_dragoon_jump2"},
		{},
		{"ramza_dragoon_jump3"},
		{},
		{"ramza_dragoon_jump4"},
		{},
		{"ramza_dragoon_jump5"},
		{"ramza_dragoon_jump8"},
	},
	{	-- Samurai: Iaido|r|nLvl 1 - Ashura|nLvl 2 - Osafune|nLvl 3 - Doublehand|nLvl 4 - Murasame|nLvl 5 - Shirahadori|nLvl 6 - Kiku-ichimonji|nLvl 7 - Bonecrusher|nLvl 8 - Masamune|nMastered - |c00ff8000Chirijiraden
		{"ramza_samurai_iaido_ashura"},
		{"ramza_samurai_iaido_osafune"},
		{},
		{"ramza_samurai_iaido_murasame"},
		{},
		{"ramza_samurai_iaido_kikuichimonji"},
		{},
		{"ramza_samurai_iaido_masamune"},
		{"ramza_samurai_iaido_chirijiraden"},
	},
	{	-- Ninja: Throw|r|nLvl 1 - Shuriken|nLvl 2 - Axe|nLvl 3 - Reflexes|nLvl 4 - Book|nLvl 5 - Vanish|nLvl 6 - Polearm|nLvl 7 - Dual Wield|nLvl 8 - Bomb|nMastered - |c00ff8000Ninja Blade
		{"ramza_ninja_throw_shuriken"},
		{"ramza_ninja_throw_axe"},
		{},
		{"ramza_ninja_throw_book"},
		{},
		{"ramza_ninja_throw_polearm"},
		{},
		{"ramza_ninja_throw_bomb"},
		{"ramza_ninja_throw_ninja_blade"},
	},
	{	-- arithmetician: Arithmeticks|r|nLvl 1 - CT|nLvl 2 - Multiple of 5|nLvl 3 - Accrue EXP|nLvl 4 - Level|nLvl 5 - Soulbind|nLvl 6 - Multiple of 4|nLvl 7 - EXP Boost|nLvl 8 - Multiple of 3|nMastered - |c00ff8000EXP
		{"ramza_arithmetician_arithmeticks_CT"},
		{"ramza_arithmetician_arithmeticks_multiple_of_5"},
		{},
		{"ramza_arithmetician_arithmeticks_level"},
		{},
		{"ramza_arithmetician_arithmeticks_multiple_of_4"},
		{},
		{"ramza_arithmetician_arithmeticks_multiple_of_3"},
		{"ramza_arithmetician_arithmeticks_exp"},
	},
	{	-- Mime: Mimic|r|nLvl 1 - 100% Mana Cost|nLvl 2 - 90% Mana Cost|nLvl 3 - 80% Mana Cost|nLvl 4 - 70% Mana Cost|nLvl 5 - 60% Mana Cost|nLvl 6 - 50% Mana Cost|nLvl 7 - 40% Mana Cost|nLvl 8 - 20% Mana Cost|nMastered - |c00ff80000% Mana Cost
		{"ramza_mime_mimic_100_mana_cost"},
		{"ramza_mime_mimic_90_mana_cost"},
		{"ramza_mime_mimic_80_mana_cost"},
		{"ramza_mime_mimic_70_mana_cost"},
		{"ramza_mime_mimic_60_mana_cost"},
		{"ramza_mime_mimic_50_mana_cost"},
		{"ramza_mime_mimic_40_mana_cost"},
		{"ramza_mime_mimic_20_mana_cost"},
		{"ramza_mime_mimic_0_mana_cost"},
	},
	{	-- Dark Knight: Darkness|r|nLvl 1 - Sanguine Sword|nLvl 2 - Infernal Strike|nLvl 3 - HP Boost|nLvl 4 - Crushing Blow|nLvl 5 - Vehemence|nLvl 6 - Abyssal Blade|nLvl 7 - Move +3|nLvl 8 - Unholy Sacrifice|nMastered - |c00ff8000Shadowblade
		{"ramza_dark_knight_darkness_sanguine_sword"},
		{"ramza_dark_knight_darkness_infernal_strike"},
		{},
		{"ramza_dark_knight_darkness_crushing_blow"},
		{},
		{"ramza_dark_knight_darkness_abyssal_blade"},
		{},
		{"ramza_dark_knight_darkness_unholy_sacrifice"},
		{"ramza_dark_knight_darkness_shadowblade"},
	},
	{	-- Onion Knight: None|r|nLvl 1 - +5 Stats|nLvl 2 - +10 Stats|nLvl 3 - +15 Stats|nLvl 4 - +20 Stats|nLvl 5 - +25 Stats|nLvl 6 - +30 Stats|nLvl 7 - +35 Stats|nLvl 8 - +50 Stats|nMastered - |c00ff8000+75 Stats
		{"ramza_onion_knight_stat5"},
		{"ramza_onion_knight_stat10"},
		{"ramza_onion_knight_stat15"},
		{"ramza_onion_knight_stat20"},
		{"ramza_onion_knight_stat25"},
		{"ramza_onion_knight_stat30"},
		{"ramza_onion_knight_stat35"},
		{"ramza_onion_knight_stat50"},
		{"ramza_onion_knight_stat75"},
	}
}


CRamzaJob.tOtherAbilities = {	
	{	-- Squire
		{}, {}, {"ramza_squire_counter_tackle"}, {}, {"ramza_squire_defend"}, {}, {"ramza_squire_move1"}, {}, {}
	},
	{	-- Chemist
		{}, {}, {"ramza_chemist_autopotion"}, {}, {"ramza_chemist_treasure_hunter"}, {}, {"ramza_chemist_throw_items"}, {}, {}
	},
	{	-- Knight
		{}, {}, {"ramza_knight_parry"}, {}, {"ramza_knight_heavy_armor"}, {}, {"ramza_knight_knight_sword"}, {}, {}
	},
	{	-- Archer
		{}, {}, {"ramza_archer_adrenaline_rush"}, {}, {"ramza_archer_archers_bane"}, {}, {"ramza_archer_concentration"}, {}, {}
	},
	{	-- White Mage
		{}, {}, {"ramza_white_mage_regenerate"}, {}, {"ramza_white_mage_arcane_defense"}, {}, {"ramza_white_mage_reraise"}, {}, {}
	},
	{	-- Black Mage: 
		{}, {}, {"ramza_black_mage_magick_counter"}, {}, {"ramza_black_mage_death"}, {}, {"ramza_black_mage_arcane_strength"}, {}, {}
	},
	{	-- Monk
		{}, {}, {"ramza_monk_brawler"}, {}, {"ramza_monk_lifefont"}, {}, {"ramza_monk_critical_recover_hp"}, {}, {}
	},
	{	-- Thief
		{}, {}, {"ramza_thief_move2"}, {}, {"ramza_thief_vigilance"}, {}, {"ramza_thief_gil_snapper"}, {}, {}
	},
	{	-- Mystic
		{}, {}, {"ramza_mystic_defense_boost"}, {}, {"ramza_mystic_manafont"}, {}, {"ramza_mystic_absorb_mp"}, {}, {}
	},
	{	-- Time Mage
		{}, {}, {"ramza_time_mage_mana_shield"}, {}, {"ramza_time_mage_teleport"}, {}, {"ramza_time_mage_swiftness"}, {}, {}
	},
	{	-- Orator
		{}, {}, {"ramza_orator_enlighten"}, {}, {"ramza_orator_intimidate"}, {}, {"ramza_orator_beast_tongue"}, {}, {}
	},
	{	-- Summoner
		{}, {}, {"ramza_summoner_critical_recover_mp"}, {}, {"ramza_summoner_lich"}, {}, {"ramza_summoner_odin"}, {}, {}
	},
	{	-- Geomancer
		{}, {}, {"ramza_geomancer_contortion"}, {}, {"ramza_geomancer_attack_boost"}, {}, {"ramza_geomancer_wind_blast"}, {}, {}
	},
	{	-- Dragoon
		{}, {}, {"ramza_dragoon_polearm"}, {}, {"ramza_dragoon_ignore_elevation"}, {}, {"ramza_dragoon_dragonheart"}, {}, {}
	},
	{	-- Samurai
		{}, {}, {"ramza_samurai_doublehand"}, {}, {"ramza_samurai_shirahadori"}, {}, {"ramza_samurai_bonecrusher"}, {}, {}
	},
	{	-- Ninja
		{}, {}, {"ramza_ninja_reflexes"}, {}, {"ramza_ninja_vanish"}, {}, {"ramza_ninja_dual_wield"}, {}, {}
	},
	{	-- arithmetician
		{}, {}, {"ramza_arithmetician_accrue_exp"}, {}, {"ramza_arithmetician_soulbind"}, {}, {"ramza_arithmetician_exp_boost"}, {}, {}
	},
	{	-- Mime
		{}, {}, {}, {}, {}, {}, {}, {}, {}
	},
	{	-- Dark Knight
		{}, {}, {"ramza_dark_knight_hp_boost"}, {}, {"ramza_dark_knight_vehemence"}, {}, {"ramza_dark_knight_move3"}, {}, {}
	},
	{	-- Onion Knight
		{}, {}, {}, {}, {}, {}, {}, {}, {}
	}
}

CRamzaJob.tOtherAbilityCastable = {
	ramza_chemist_treasure_hunter = true,
	ramza_white_mage_reraise = true,
	ramza_black_mage_death = true,
	ramza_time_mage_teleport = true,
	ramza_orator_enlighten = true,
	ramza_orator_intimidate = true,
	ramza_summoner_lich = true,
	ramza_summoner_odin = true,
	ramza_geomancer_contortion = true,
	ramza_geomancer_wind_blast = true	
}

CRamzaJob.tOtherAbilityHasToggleModifiers = {
	ramza_squire_defend = true,
	ramza_chemist_autopotion = true,
	ramza_time_mage_mana_shield = true,
	ramza_ninja_vanish = true,
	ramza_dark_knight_vehemence = true
}
