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
SELECT_SECONDARY_ABILITY = 1;

RAMZA_MENU_STATE_NORMAL = 0
RAMZA_MENU_STATE_UPGRADE = 1
RAMZA_MENU_STATE_PRIMARY = 2
RAMZA_MENU_STATE_SECONDARY = 3

CRamzaJob = {}

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
		attack_cap = DOTA_UNIT_CAP_MELEE_ATTACK,
		model = "models/heroes/dragon_knight/dragon_knight.vmdl",
		model_scale = 0.84,
		wearables = {
			{ID = "66"},
			{ID = "67"}
		},
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
		attack_cap = DOTA_UNIT_CAP_MELEE_ATTACK,
		model = "models/heroes/sniper/sniper.vmdl",
		model_scale = 0.84,
		wearables = {
			{ID = "9093"},
			{ID = "9097"},
			{ID = "9197", particle_systems = {{system = "particles/econ/items/sniper/sniper_immortal_cape/sniper_immortal_cape_ambient.vpcf", attach_type = PATTACH_CUSTOMORIGIN_FOLLOW, attach_entity = "self", control_points = {{control_point_index = 0, attachment = 'ArbitraryChain1_plc1'}}}}},
			{ID = "9095"},
			{ID = "9096"}
		},
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
		attack_cap = DOTA_UNIT_CAP_MELEE_ATTACK,
		model = "models/heroes/dragon_knight/dragon_knight.vmdl",
		model_scale = 0.84,
		wearables = {
			{ID = "7438"},
			{ID = "9135"},
			{ID = "5084"},
			{ID = "7440"},
			{ID = "7439"},
			{ID = "8798"}
		},
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
		attack_cap = DOTA_UNIT_CAP_RANGED_ATTACK,
		attack_projectile = "particles/units/heroes/hero_clinkz/clinkz_base_attack.vpcf",
		model = "models/heroes/clinkz/clinkz.vmdl",
		model_scale = 0.65,
		wearables = {
			{ID = "9162", particle_systems = {{system = "particles/econ/items/clinkz/clinkz_maraxiform/clinkz_maraxiform_ambient.vpcf", attach_entity = "self", attach_type = PATTACH_CUSTOMORIGIN_FOLLOW, control_points = {{control_point_index = 2, attachment = 'attach_top'}, {control_point_index = 5, attachment = 'attach_door_inside'}, {control_point_index = 6, attachment = 'attach_drip'}}}}},
			{ID = "7916", style = "1"},
			{ID = "7917", style = "1"},
			{ID = "7918", style = "1"},
			{ID = "7919", style = "1"}
		},
		move_speed = 310,
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
		attack_cap = DOTA_UNIT_CAP_RANGED_ATTACK,
		attack_projectile = "particles/units/heroes/hero_keeper_of_the_light/keeper_base_attack.vpcf",
		model = "models/heroes/invoker/invoker.vmdl",
		model_scale = 0.74,
		wearables = {
			{ID = "98"},
			{ID = "5867"},
			{ID = "5494"},
			{ID = "5491"},
			{ID = "5492"},
			{ID = "6079"}
		},
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
		attack_cap = DOTA_UNIT_CAP_RANGED_ATTACK,
		attack_projectile = "particles/units/heroes/hero_lina/lina_base_attack.vpcf",
		model = "models/heroes/invoker/invoker.vmdl",
		model_scale = 0.74,
		wearables = {
			{ID = "98"},
			{ID = "6441"},
			{ID = "7979"},
			{ID = "5156"},
			{ID = "7988"},
			{ID = "7989"}
		},
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
		attack_cap = DOTA_UNIT_CAP_MELEE_ATTACK,
		model = "models/heroes/blood_seeker/blood_seeker.vmdl",
		model_scale=0.88,
		wearables = {
		},
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
		attack_cap = DOTA_UNIT_CAP_MELEE_ATTACK,
		model = "models/heroes/rikimaru/rikimaru.vmdl",
		model_scale = 0.870000,
		wearables = {
		},
		move_speed = 310,
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
		attack_cap = DOTA_UNIT_CAP_RANGED_ATTACK,
		attack_projectile = "particles/units/heroes/hero_oracle/oracle_base_attack.vpcf",
		model = "models/heroes/oracle/oracle.vmdl",
		model_scale = 1,
		wearables = {
		},
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
		attack_cap = DOTA_UNIT_CAP_RANGED_ATTACK,
		attack_projectile = "particles/units/heroes/hero_silencer/silencer_base_attack.vpcf",
		model = "models/heroes/silencer/silencer.vmdl",
		model_scale = 0.740000,
		wearables = {
		},
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
		attack_cap = DOTA_UNIT_CAP_RANGED_ATTACK,
		attack_projectile = "particles/units/heroes/hero_shadowshaman/shadowshaman_base_attack.vpcf",
		model = "models/heroes/shadowshaman/shadowshaman.vmdl",
		model_scale = 0.91,
		wearables = {
		},
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
		attack_cap = DOTA_UNIT_CAP_RANGED_ATTACK,
		attack_projectile = "particles/units/heroes/hero_keeper_of_the_light/keeper_base_attack.vpcf",
		model = "models/heroes/keeper_of_the_light/keeper_of_the_light.vmdl",
		model_scale = 0.8,
		wearables = {
		},
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
		attack_cap = DOTA_UNIT_CAP_RANGED_ATTACK,
		attack_projectile = "particles/units/heroes/hero_invoker/invoker_base_attack.vpcf",
		model = "models/heroes/warlock/warlock.vmdl",
		model_scale = 0.930000,
		wearables = {
		},
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
		attack_cap = DOTA_UNIT_CAP_MELEE_ATTACK,
		model = "models/heroes/phantom_lancer/phantom_lancer.vmdl",
		model_scale = 0.84,
		wearables = {
			{ID = "7557"},
			{ID = "127"},
			{ID = "7749"},
			{ID = "7746"},
			{ID = "7747"},
		},
		move_speed = 320,
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
		attack_cap = DOTA_UNIT_CAP_MELEE_ATTACK,
		model = "models/heroes/juggernaut/juggernaut_arcana.vmdl",
		model_scale = 0.85,
		wearables = {
		},
		model_material_group = 1,
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
		attack_cap = DOTA_UNIT_CAP_MELEE_ATTACK,
		model = "models/heroes/bounty_hunter/bounty_hunter.vmdl",
		model_scale = 0.84,
		wearables = {
		},
		move_speed = 325,
	},
	{	--arithmetician
		primary_attribute = DOTA_ATTRIBUTE_INTELLECT,
		base_str = 8,
		base_agi = 7,
		base_int = 40,
		gain_str = 1.3,
		gain_agi = 1,
		gain_int = 4,
		armor = 0,
		attack_range = 700,
		attack_cap = DOTA_UNIT_CAP_RANGED_ATTACK,
		attack_projectile = "particles/econ/items/rubick/rubick_staff_wandering/rubick_base_attack_whset.vpcf",
		model = "models/heroes/rubick/rubick.vmdl",
		model_scale = 0.7,
		wearables = {
			{ID = "7026"},
			{ID = "7507"},
			{ID = "8108"},
			{ID = "8592"},
			{ID = "8393"}
		},
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
		attack_cap = DOTA_UNIT_CAP_RANGED_ATTACK,
		attack_projectile = "particles/units/heroes/hero_bane/bane_projectile.vpcf",
		model = "models/heroes/bane/bane.vmdl",
		model_scale = 0.93,
		wearables = {
			{ID = "7941"},
			{ID = "7942"},
			{ID = "7943"},
			{ID = "7692"}
		},
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
		attack_cap = DOTA_UNIT_CAP_MELEE_ATTACK,
		model = "models/heroes/abaddon/abaddon.vmdl",
		model_scale = 0.78,
		wearables = {
			{ID = "5561"},
			{ID = "6408"},
			{ID = "6409"},
			{ID = "6410"},
			{ID = "6411"},
		},
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
		model = "models/heroes/kunkka/kunkka.vmdl",
		model_scale = 0.84,
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
		move_speed = 350,
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

function CRamzaJob:GainJobPoint(iJobPoint)
	local iPlayerID = self.hParent:GetOwner():GetPlayerID()
	self.tJobPoints[self.iCurrentJob] = self.tJobPoints[self.iCurrentJob] + iJobPoint
	local bHasLeveled = false
	while self.tJobLevels[self.iCurrentJob] < 9 and self.tRamzaJobReqirement[self.tJobLevels[self.iCurrentJob]+1] <= self.tJobPoints[self.iCurrentJob] do --Gain job level
		self.tJobLevels[self.iCurrentJob] = self.tJobLevels[self.iCurrentJob]+1
		if self.tJobLevelUnlocks[self.iCurrentJob] and self.tJobLevelUnlocks[self.iCurrentJob][self.tJobLevels[self.iCurrentJob]] then -- Update unmet job requirements
			for _, v in pairs(self.tJobLevelUnlocks[self.iCurrentJob][self.tJobLevels[self.iCurrentJob]]) do
				self.tChangeJobRequirements[v][self.iCurrentJob] = true						
				local bIsReachRequirement = true				
				for __, u in pairs(self.tChangeJobRequirements[v]) do
					bIsReachRequirement = bIsReachRequirement and u
				end
				if bIsReachRequirement then --New job acquired!
					self.tJobLevels[v] = 1
					print(self.tJobNames[v].." is acquired!") 
				end
			end
		end
		bHasLeveled = true
		print(self.tJobNames[self.iCurrentJob].." has leveled up to "..tostring(self.tJobLevels[self.iCurrentJob]))		
		
	end
	if bHasLeveled then		
		self:LevelUpSkills()
		CustomNetTables:SetTableValue("ramza_job_requirement", tostring(iPlayerID), self.tChangeJobRequirements)
		CustomNetTables:SetTableValue("ramza_job_level", tostring(iPlayerID), self.tJobLevels)
		if (self.tJobLevels[self.iCurrentJob] < 9) then
			self.hParent:FindModifierByName("modifier_ramza_job_level"):SetStackCount(self.tJobLevels[self.iCurrentJob])
		else
			self.hParent:RemoveModifierByName("modifier_ramza_job_point")
			self.hParent:RemoveModifierByName("modifier_ramza_job_level")
			self.hParent:AddNewModifier(self.hParent, nil, "modifier_ramza_job_mastered", {})
		end
	end
	if (self.tJobLevels[self.iCurrentJob] < 9) then
		self.hParent:FindModifierByName("modifier_ramza_job_point"):SetStackCount(self.tJobPoints[self.iCurrentJob])
	end
end


--function CRamzaJob:




function CRamzaJob:LevelUpSkills()
	--Level up passives
	if self.iCurrentJob ~= RAMZA_JOB_MIME and self.iCurrentJob ~= RAMZA_JOB_ONION_KNIGHT then
		for i = 1, 3 do
			if self.tJobLevels[self.iCurrentJob] >= self.tJobAbilityBuses.tOtherAbilityBusRequirements[self.iCurrentJob][i] then
				self.hParent:FindAbilityByName(self.tJobAbilityBuses.tOtherAbilityBuses[self.iCurrentJob][i]):SetLevel(1)
			end
		end
		
		if self.hParent.iMenuState == RAMZA_MENU_STATE_PRIMARY then
			for i = 1, 4 do
				if i+self.hParent.iPrimaryPointer <= #self.tJobAbilityBuses.tJobCommandBusRequirements[self.iCurrentJob] and self.tJobLevels[self.iCurrentJob] >= self.tJobAbilityBuses.tJobCommandBusRequirements[self.iCurrentJob][i+self.hParent.iPrimaryPointer] then
					self.hParent:FindAbilityByName(self.tJobAbilityBuses.tJobCommandBuses[self.iCurrentJob][i+self.hParent.iPrimaryPointer]):SetLevel(1)
				end
			end
		end		
	end
	
	--Level up job command for archer, dragoon, ninja, arithmetician, mime, onion knight
	for i = 1, 9 do
		if (
				self.iCurrentJob == RAMZA_JOB_ARCHER or 
				self.iCurrentJob == RAMZA_JOB_ARITHMETICIAN or 
				self.iCurrentJob == RAMZA_JOB_DRAGOON or 
				self.iCurrentJob == RAMZA_JOB_NINJA or 
				self.iCurrentJob == RAMZA_JOB_MIME or 
				self.iCurrentJob == RAMZA_JOB_ONION_KNIGHT) and 
			self.hParent:HasAbility(self.tJobCommands[self.iCurrentJob][i][1]) and 
			i < self.tJobLevels[self.iCurrentJob] and 
				(i < self.tJobLevels[self.iCurrentJob]-1 or 
				self.tJobCommands[self.iCurrentJob][self.tJobLevels[self.iCurrentJob]][1]) then
			local sName = self.tJobCommands[self.iCurrentJob][self.tJobLevels[self.iCurrentJob]][1] or self.tJobCommands[self.iCurrentJob][self.tJobLevels[self.iCurrentJob]-1][1]
			
			self.hParent:RemoveAbility(self.tJobCommands[self.iCurrentJob][i][1])
			if self.iCurrentJob == 20 or self.iCurrentJob == 18 then 
				self.hParent:RemoveModifierByName("modifier_"..self.tJobCommands[self.iCurrentJob][i][1])
			end
			self.hParent:AddAbility(sName):SetLevel(1)		
			if self.hParent.iMenuState == RAMZA_MENU_STATE_NORMAL then
				self.hParent:FindAbilityByName(sName):SetHidden(false)
			else	
				self.hParent:FindAbilityByName(sName):SetHidden(true)
				self.hParent.tNormalMenuState[1] = sName
			end
			break
		end
	end	
end

function CRamzaJob:New(tNewObject)
	tNewObject.tJobPoints = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	tNewObject.tJobLevels = {1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	tNewObject.tChangeJobRequirements = {}
	tNewObject.tPassiveCooldownReadyTime = {}
	for i = 1, 20 do
		tNewObject.tChangeJobRequirements[i] = {}
		for k, v in pairs(self.tRamzaChangeJobRequirements[i]) do
			tNewObject.tChangeJobRequirements[i][k] = false
		end
	end	
	tNewObject.iCurrentJob = RAMZA_JOB_SQUIRE
	tNewObject.iSecondarySkill = 0
	table.insert(self.tAllRamzas, tNewObject.hParent)
	
	setmetatable(tNewObject, {__index = self})
	return tNewObject
end

function CRamzaJob:InitNetTable()	
	local iPlayerID = self.hParent:GetOwner():GetPlayerID()	
	CustomNetTables:SetTableValue("ramza_init_job_requirement", tostring(iPlayerID), self.tRamzaChangeJobRequirements)
	CustomNetTables:SetTableValue("ramza_job_names", tostring(iPlayerID), self.tJobNames)
	CustomNetTables:SetTableValue("ramza_job_abilities", tostring(iPlayerID), self.tJobAbilities)
	CustomNetTables:SetTableValue("ramza_job_stats", tostring(iPlayerID), self.tJobStats)
	
	
	CustomNetTables:SetTableValue("ramza_job_level", tostring(iPlayerID), self.tJobLevels)
	CustomNetTables:SetTableValue("ramza_job_requirement", tostring(iPlayerID), self.tChangeJobRequirements)
	CustomNetTables:SetTableValue("ramza_current_job", tostring(iPlayerID), {self.iCurrentJob})
	CustomNetTables:SetTableValue("ramza_current_secondary_skill", tostring(iPlayerID), {self.iSecondarySkill})
end


function CRamzaJob:PrintCurrent()
	print("Current job is"..self.tJobNames[self.iCurrentJob].."(level "..tostring(self.tJobLevels[self.iCurrentJob]).."), job point is "..tostring(self.tJobPoints[self.iCurrentJob]))
end


-- hJob = CRamzaJob:New()

function CRamzaJob:Initialize()
	self.tJobAbilityBuses = {}
	self.tJobAbilities = {}
	self.tJobLevelUnlocks = {}
	self.tJobAbilityBuses.tJobCommandBuses = {}
	self.tJobAbilityBuses.tJobCommandBusRequirements = {}
	self.tJobAbilityBuses.tOtherAbilityBuses = {}
	self.tJobAbilityBuses.tOtherAbilityBusRequirements = {}
	for i = 1, 20 do
		for k, v in pairs(self.tRamzaChangeJobRequirements[i]) do
			self.tJobLevelUnlocks[k] = self.tJobLevelUnlocks[k] or {}
			self.tJobLevelUnlocks[k][v] = self.tJobLevelUnlocks[k][v] or {}
			table.insert(self.tJobLevelUnlocks[k][v], i)
		end
		
		self.tJobAbilities[i] = {}
		self.tJobAbilityBuses.tJobCommandBuses[i] = {}
		self.tJobAbilityBuses.tJobCommandBusRequirements[i] = {}
		self.tJobAbilityBuses.tOtherAbilityBuses[i] = {}
		self.tJobAbilityBuses.tOtherAbilityBusRequirements[i] = {}
		for j = 1,9 do
			self.tJobAbilities[i][j] ={}
			if #self.tJobCommands[i][j] > 0 then
				for k = 1, #self.tJobCommands[i][j] do
					table.insert(self.tJobAbilities[i][j], self.tJobCommands[i][j][k])
					table.insert(self.tJobAbilityBuses.tJobCommandBuses[i], self.tJobCommands[i][j][k])
					table.insert(self.tJobAbilityBuses.tJobCommandBusRequirements[i], j)
				end
			elseif #self.tOtherAbilities[i][j] > 0 then
				for k = 1, #self.tOtherAbilities[i][j] do
					table.insert(self.tJobAbilities[i][j], self.tOtherAbilities[i][j][k])
				end
				table.insert(self.tJobAbilityBuses.tOtherAbilityBuses[i], self.tOtherAbilities[i][j][1])				
				table.insert(self.tJobAbilityBuses.tOtherAbilityBusRequirements[i], j)
			end
		end
	end
	self.tJobAbilityBuses.tOtherAbilityBuses[18] = {"ramza_empty_2", "ramza_empty_3", "ramza_empty_4"}
	self.tJobAbilityBuses.tJobCommandBusRequirements[18] = {10, 10, 10}
	self.tJobAbilityBuses.tOtherAbilityBuses[20] = {"ramza_empty_2", "ramza_empty_3", "ramza_empty_4"}
	self.tJobAbilityBuses.tJobCommandBusRequirements[20] = {10, 10, 10}
	
	self.tAllRamzas = {}
	Convars:RegisterCommand( "ramza_max_level", Dynamic_Wrap(CRamzaJob, 'RamzaLevelMax'), "Give Ramza all job and levels", FCVAR_CHEAT )
end

function CRamzaJob:RamzaLevelMax()
	for i = 1, #self.tAllRamzas do		
		for j = 1, 20 do
			self.tAllRamzas[i].hRamzaJob.tJobPoints[j] = 4000
			self.tAllRamzas[i].hRamzaJob.tJobLevels[j] = 9
			self.tAllRamzas[i].hRamzaJob:LevelUpSkills()
		end
		self.tAllRamzas[i].hRamzaJob.tJobPoints[RAMZA_JOB_DARK_KNIGHT] = 0
		self.tAllRamzas[i].hRamzaJob.tJobLevels[RAMZA_JOB_DARK_KNIGHT] = 1
		
		CustomNetTables:SetTableValue("ramza_job_level", tostring(self.tAllRamzas[i]:GetOwner():GetPlayerID()), self.tAllRamzas[i].hRamzaJob.tJobLevels)
		CustomNetTables:SetTableValue("ramza_job_requirement", tostring(self.tAllRamzas[i]:GetOwner():GetPlayerID()), self.tAllRamzas[i].hRamzaJob.tChangeJobRequirements)
		CustomNetTables:SetTableValue("ramza_current_job", tostring(self.tAllRamzas[i]:GetOwner():GetPlayerID()), {self.tAllRamzas[i].hRamzaJob.iCurrentJob})
		CustomNetTables:SetTableValue("ramza_current_secondary_skill", tostring(self.tAllRamzas[i]:GetOwner():GetPlayerID()), {self.tAllRamzas[i].hRamzaJob.iSecondarySkill})
	end
end


function RamzaJobChangeListener(eventSourceIndex, args)
	local hRamza = PlayerResource:GetPlayer(tonumber(args.PlayerID)):GetAssignedHero()
	hRamza.hRamzaJob.iChangeJobState = tonumber(args.iState)
	hRamza.hRamzaJob.iJobToGo = tonumber(args.iJob)
	if (hRamza:HasScepter() or hRamza:GetHealthPercent() == 100 and hRamza:GetManaPercent() == 100) and not hRamza:HasModifier("modifier_ramza_dragoon_jump") then
		hRamza.hRamzaJob:ChangeJob()
	elseif hRamza:HasModifier("modifier_ramza_dragoon_jump") then
		if tonumber(args.iState) == SELECT_JOB then
			Notifications:Bottom(tonumber(args.PlayerID), {text = "#error_ramza_cant_change_job_jump", duration = 2, style = {color = "red"}})
		else
			Notifications:Bottom(tonumber(args.PlayerID), {text = "#error_ramza_cant_change_secondary_skill_jump", duration = 2, style = {color = "red"}})
		end
	else
		if tonumber(args.iState) == SELECT_JOB then
			Notifications:Bottom(tonumber(args.PlayerID), {text = "#error_ramza_cant_change_job_full", duration = 2, style = {color = "red"}})
		else
			Notifications:Bottom(tonumber(args.PlayerID), {text = "#error_ramza_cant_change_secondary_skill_full", duration = 2, style = {color = "red"}})
		end
		
	end
end

function CRamzaJob:ChangeJob()
	local iPlayerID = self.hParent:GetOwner():GetPlayerID()	
	if self.iChangeJobState == SELECT_JOB then
		
		if self.hParent:GetAbilityByIndex(5):GetName() == 'ramza_go_back_lua' then
			self.hParent:FindAbilityByName('ramza_go_back_lua'):CastAbility()
		end
		
		self.hParent:GetAbilityByIndex(1):SetActivated(true)
		self:ChangeStat()
		self:ChangeModel()		
		self.iCurrentJob = self.iJobToGo
		
		--remove secondary skill if it's job command of current job or current job can have no secondary skill
		if self.iCurrentJob == self.iSecondarySkill or self.iCurrentJob == RAMZA_JOB_MIME or self.iCurrentJob == RAMZA_JOB_ONION_KNIGHT then 
		
			self.iSecondarySkill = 0
			CustomNetTables:SetTableValue("ramza_current_secondary_skill", tostring(iPlayerID), {self.iSecondarySkill})
			local sName = self.hParent:GetAbilityByIndex(1):GetName()
			local bHasAdded = false
			if string.sub(sName, 1, 16) == "ramza_archer_aim" or string.sub(sName, 1, 17) == "ramza_ninja_throw" then
				self.hParent:AddAbility("ramza_select_secondary_skill_lua"):SetLevel(1)
				self.hParent:SwapAbilities(sName, "ramza_select_secondary_skill_lua", true, true)
				self.hParent:FindAbilityByName(sName):SetHidden(true)
				bHasAdded = true
			else
				self.hParent:RemoveAbility(sName)
			end 			
			
			if not bHasAdded then
				self.hParent:AddAbility("ramza_select_secondary_skill_lua"):SetLevel(1)
			end
			
			if self.iCurrentJob == RAMZA_JOB_MIME or self.iCurrentJob == RAMZA_JOB_ONION_KNIGHT then
				self.hParent:FindAbilityByName("ramza_select_secondary_skill_lua"):SetActivated(false)
			end
		end
		
		-- change job command
		local sName1
		if 	(self.iCurrentJob == RAMZA_JOB_ARCHER or 
				self.iCurrentJob == RAMZA_JOB_ARITHMETICIAN or 
				self.iCurrentJob == RAMZA_JOB_DRAGOON or 
				self.iCurrentJob == RAMZA_JOB_NINJA or 
				self.iCurrentJob == RAMZA_JOB_MIME or 
				self.iCurrentJob == RAMZA_JOB_ONION_KNIGHT) then
			sName1 = self.tJobCommands[self.iCurrentJob][self.tJobLevels[self.iCurrentJob]][1] or self.tJobCommands[self.iCurrentJob][self.tJobLevels[self.iCurrentJob]-1][1] 
		else
			sName1 = self.tJobNames[self.iCurrentJob]..'_JC'
		end
		local sName0 = self.hParent:GetAbilityByIndex(0):GetName()
		
		if (string.sub(sName0, 1, 16) == "ramza_archer_aim" or string.sub(sName0, 1, 17) == "ramza_ninja_throw") and  (self.hParent:FindAbilityByName(sName1)) then		
			self.hParent:FindAbilityByName(sName1):SetHidden(false)			
			self.hParent:SwapAbilities(sName0, sName1, true, true)
			self.hParent:FindAbilityByName(sName0):SetHidden(true)
		elseif (string.sub(sName0, 1, 16) == "ramza_archer_aim" or string.sub(sName0, 1, 17) == "ramza_ninja_throw") and  (not self.hParent:FindAbilityByName(sName1)) then
			self.hParent:AddAbility(sName1):SetLevel(1)
			self.hParent:SwapAbilities(sName0, sName1, true, true)
			self.hParent:FindAbilityByName(sName0):SetHidden(true)
		elseif (string.sub(sName0, 1, 16) ~= "ramza_archer_aim" or string.sub(sName0, 1, 17) ~= "ramza_ninja_throw") and  (self.hParent:FindAbilityByName(sName1)) then		
			self.hParent:FindAbilityByName(sName1):SetHidden(false)
			self.hParent:SwapAbilities(sName0, sName1, true, true)
			self.hParent:RemoveAbility(sName0)
		else		
			self.hParent:RemoveAbility(sName0)
			self.hParent:AddAbility(sName1):SetLevel(1)
		end
		
		if string.sub(sName0, 7, 18) == "onion_knight" then
			self.hParent:RemoveModifierByName("modifier_"..sName0)
		end
		
		if string.sub(sName0, 7, 10) == "mime" then
			self.hParent:RemoveModifierByName("modifier_"..sName0)
		end

		-- change other abilities
		for i = 1, 3 do
			local sName = self.hParent:GetAbilityByIndex(i+1):GetName()
			-- keep cooldown state
			if sName == "ramza_dragoon_dragonheart" then
				if self.hParent:FindAbilityByName(sName):IsCooldownReady() then
					self.tPassiveCooldownReadyTime[sName] = Time()
				else
					self.tPassiveCooldownReadyTime[sName] = Time()+self.hParent:FindAbilityByName(sName):GetCooldownTimeRemaining()
				end
			end
			self.hParent:RemoveAbility(sName)			
			if self.tOtherAbilityHasToggleModifiers[sName] then 
				self.hParent:RemoveModifierByName('modifier_'..sName)
			elseif not self.tOtherAbilityCastable[sName] then
				self.hParent:RemoveModifierByName('modifier_'..sName)				
			end
			local sName1 = self.tJobAbilityBuses.tOtherAbilityBuses[self.iCurrentJob][i]
			self.hParent:AddAbility(sName1)			
			if (sName1 == "ramza_dragoon_dragonheart") and self.tPassiveCooldownReadyTime[sName1] and self.tPassiveCooldownReadyTime[sName1] > Time() then
				self.hParent:FindAbilityByName(sName1):StartCooldown(self.tPassiveCooldownReadyTime[sName1] - Time())
			end
		end
		
		self:LevelUpSkills()
		-- renew indicator
		if (self.tJobLevels[self.iCurrentJob] < 9) then
			if self.hParent:FindModifierByName("modifier_ramza_job_mastered") then
				self.hParent:RemoveModifierByName("modifier_ramza_job_mastered")
				self.hParent:AddNewModifier(self.hParent, nil, "modifier_ramza_job_level", {})
				self.hParent:AddNewModifier(self.hParent, nil, "modifier_ramza_job_point", {})
			end
			self.hParent:FindModifierByName("modifier_ramza_job_level"):SetStackCount(self.tJobLevels[self.iCurrentJob])
			self.hParent:FindModifierByName("modifier_ramza_job_point"):SetStackCount(self.tJobPoints[self.iCurrentJob])
		else
			if not self.hParent:FindModifierByName("modifier_ramza_job_mastered") then
				self.hParent:RemoveModifierByName("modifier_ramza_job_point")
				self.hParent:RemoveModifierByName("modifier_ramza_job_level")
				self.hParent:AddNewModifier(self.hParent, nil, "modifier_ramza_job_mastered", {})
			end
		end
		
		-- tell panorama
		print("job change to", self.tJobNames[self.iCurrentJob])
		CustomNetTables:SetTableValue("ramza_current_job", tostring(iPlayerID), {self.iCurrentJob})		
		CustomGameEventManager:Send_ServerToPlayer( self.hParent:GetOwner(), "ramza_select_job", nil )
	else	
		if self.hParent:GetAbilityByIndex(5):GetName() == 'ramza_go_back_lua' then
			self.hParent:FindAbilityByName('ramza_go_back_lua'):CastAbility()
		end
		
		self.iSecondarySkill = self.iJobToGo
		
		local sName1
		if 	(self.iSecondarySkill == RAMZA_JOB_ARCHER or 
				self.iSecondarySkill == RAMZA_JOB_ARITHMETICIAN or 
				self.iSecondarySkill == RAMZA_JOB_DRAGOON or 
				self.iSecondarySkill == RAMZA_JOB_NINJA) then
			sName1 = self.tJobCommands[self.iSecondarySkill][self.tJobLevels[self.iSecondarySkill]][1] or self.tJobCommands[self.iSecondarySkill][self.tJobLevels[self.iSecondarySkill]-1][1] 
		else
			sName1 = self.tJobNames[self.iSecondarySkill]..'_JC'
		end
		
		local sName0 = self.hParent:GetAbilityByIndex(1):GetName()		
		
		if (string.sub(sName0, 1, 16) == "ramza_archer_aim" or string.sub(sName0, 1, 17) == "ramza_ninja_throw") and self.hParent:FindAbilityByName(sName1) then		
			self.hParent:FindAbilityByName(sName1):SetHidden(false)			
			self.hParent:SwapAbilities(sName0, sName1, true, true)
			self.hParent:FindAbilityByName(sName0):SetHidden(true)
		elseif (string.sub(sName0, 1, 16) == "ramza_archer_aim" or string.sub(sName0, 1, 17) == "ramza_ninja_throw") and not self.hParent:FindAbilityByName(sName1) then
			self.hParent:AddAbility(sName1):SetLevel(1)
			self.hParent:SwapAbilities(sName0, sName1, true, true)
			self.hParent:FindAbilityByName(sName0):SetHidden(true)
		elseif (string.sub(sName0, 1, 16) ~= "ramza_archer_aim" or string.sub(sName0, 1, 17) ~= "ramza_ninja_throw") and self.hParent:FindAbilityByName(sName1) then		
			self.hParent:FindAbilityByName(sName1):SetHidden(false)
			self.hParent:SwapAbilities(sName0, sName1, true, true)
			self.hParent:RemoveAbility(sName0)
		else		
			self.hParent:RemoveAbility(sName0)
			self.hParent:AddAbility(sName1):SetLevel(1)
		end

		CustomNetTables:SetTableValue("ramza_current_secondary_skill", tostring(iPlayerID), {self.iSecondarySkill})
		CustomGameEventManager:Send_ServerToPlayer( self.hParent:GetOwner(), "ramza_select_secondary_skill", nil )
	end
end


function CRamzaJob:ChangeStat()
	self.hParent:SetBaseMoveSpeed(self.tJobStats[self.iJobToGo].move_speed)
	self.hParent:SetPrimaryAttribute(self.tJobStats[self.iJobToGo].primary_attribute)
	self.hParent:SetAttackCapability(self.tJobStats[self.iJobToGo].attack_cap)
	if self.tJobStats[self.iJobToGo].attack_cap == DOTA_UNIT_CAP_RANGED_ATTACK then
		self.hParent:SetRangedProjectileName(self.tJobStats[self.iJobToGo].attack_projectile)	
	end
	self.hParent:FindModifierByName("modifier_ramza_job_manager").iBonusAttackRange = self.tJobStats[self.iJobToGo].attack_range-150;
	self.hParent:FindModifierByName("modifier_ramza_job_manager"):ForceRefresh()
	self.hParent:SetAcquisitionRange(self.tJobStats[self.iJobToGo].attack_range+200)
	self.hParent:SetPhysicalArmorBaseValue(self.tJobStats[self.iJobToGo].armor)
	local fDiffStr = self.tJobStats[self.iJobToGo].base_str-self.tJobStats[self.iCurrentJob].base_str+(self.hParent:GetLevel()-1)*(self.tJobStats[self.iJobToGo].gain_str-self.tJobStats[self.iCurrentJob].gain_str)
	local fDiffAgi = self.tJobStats[self.iJobToGo].base_agi-self.tJobStats[self.iCurrentJob].base_agi+(self.hParent:GetLevel()-1)*(self.tJobStats[self.iJobToGo].gain_agi-self.tJobStats[self.iCurrentJob].gain_agi)
	local fDiffInt = self.tJobStats[self.iJobToGo].base_int-self.tJobStats[self.iCurrentJob].base_int+(self.hParent:GetLevel()-1)*(self.tJobStats[self.iJobToGo].gain_int-self.tJobStats[self.iCurrentJob].gain_int)
	self.hParent:ModifyStrength(fDiffStr)
	self.hParent:ModifyAgility(fDiffAgi)
	self.hParent:ModifyIntellect(fDiffInt)
	self.hParent:FindModifierByName("modifier_ramza_job_manager").fStrGrowth = self.tJobStats[self.iJobToGo].gain_str
	self.hParent:FindModifierByName("modifier_ramza_job_manager").fAgiGrowth = self.tJobStats[self.iJobToGo].gain_agi
	self.hParent:FindModifierByName("modifier_ramza_job_manager").fIntGrowth = self.tJobStats[self.iJobToGo].gain_int
	self.hParent:CalculateStatBonus()
end


function CRamzaJob:ChangeModel()
	if self.iJobToGo == RAMZA_JOB_SAMURAI then
		Timers:CreateTimer(0.04, function () self.hParent:SetMaterialGroup("1") end)
	else
		Timers:CreateTimer(0.04, function () self.hParent:SetMaterialGroup("0") end)
	end
	self.hParent:SetModel(self.tJobStats[self.iJobToGo].model)
	self.hParent:SetOriginalModel(self.tJobStats[self.iJobToGo].model)
	self.hParent:FindModifierByName("modifier_wearable_hider_while_model_changes").sOriginalModel = self.tJobStats[self.iJobToGo].model
	
	
	self.hParent:SetModelScale(self.tJobStats[self.iJobToGo].model_scale)
	WearableManager:RemoveAllWearable(self.hParent)
	for k, v in pairs(self.tJobStats[self.iJobToGo].wearables) do
		local style = v.style or "0"
		WearableManager:AddNewWearable(self.hParent, v.ID, style ,v.particle_systems)
	end
	WearableManager:PrintAllPrecaches(self.hParent)
end

CRamzaJob:Initialize()
LinkLuaModifier("modifier_attribute_growth_str", "heroes/ramza/ramza_utility_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_attribute_growth_agi", "heroes/ramza/ramza_utility_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_attribute_growth_int", "heroes/ramza/ramza_utility_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_job_manager", "heroes/ramza/ramza_utility_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_job_level", "heroes/ramza/ramza_utility_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_job_mastered", "heroes/ramza/ramza_utility_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_job_point", "heroes/ramza/ramza_utility_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ramza_black_mage_black_magicks_firaga", "heroes/ramza/ramza_black_mage_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

CustomGameEventManager:RegisterListener("ramza_change_job_client_to_server", RamzaJobChangeListener)