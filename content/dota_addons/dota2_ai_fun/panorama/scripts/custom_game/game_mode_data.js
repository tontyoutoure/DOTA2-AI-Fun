"use strict"; 
var aGameOptionList = [
	[
		{"id":"radiant_gold_multiplier", "type":"dropdown", "options":[1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 6, 7, 8, 9, 10, 17, 32, 56, 100, 170, 320, 560, 1000], "default_value":1},
		{"id":"dire_gold_multiplier", "type":"dropdown", "options":[1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 6, 7, 8, 9, 10, 17, 32, 56, 100, 170, 320, 560, 1000], "default_value":1},
		{"id":"radiant_xp_multiplier",  "type":"dropdown", "options":[1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 6, 7, 8, 9, 10, 17, 32, 56, 100, 170, 320, 560, 1000], "default_value":1},
		{"id":"dire_xp_multiplier",  "type":"dropdown", "options":[1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 6, 7, 8, 9, 10, 17, 32, 56, 100, 170, 320, 560, 1000], "default_value":1},
		{"id":"radiant_gold_start","type":"dropdown", "options":[600, 1000, 1700, 3200, 6000, 10000, 17000, 32000,60000,100000], "default_value":600},
		{"id":"dire_gold_start",  "type":"dropdown", "options":[600, 1000, 1700, 3200, 6000, 10000, 17000, 32000, 60000,100000], "default_value":600},
		{"id":"radiant_lvl_start","type":"dropdown", "options":[1, 2, 3, 4, 5, 6, 10, 12, 15, 18, 20, 25, 30, 56, 100, 170, 320, 560, 1000], "default_value":1},
		{"id":"dire_lvl_start",  "type":"dropdown", "options":[1, 2, 3, 4, 5, 6, 10, 12, 15, 18, 20, 25, 30, 56, 100, 170, 320, 560, 1000], "default_value":1},
		{"id":"radiant_player_number",  "type":"dropdown", "options":[12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], "default_value":12, "toolsmode_default_value":1},
		{"id":"dire_player_number", "type":"dropdown", "options":[12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], "default_value":12, "toolsmode_default_value":1},
		{"id":"radiant_fun_item_total_price_thresold", "linked_equal_player_id":"dire_fun_item_total_price_thresold", "type":"dropdown", "options":[0, 10000, 15000, 30000, 45000, 60000, 75000, 90000, 150000, 200000, 1000000], "default_value" : 1000000},
		{"id":"dire_fun_item_total_price_thresold", "linked_equal_player_id":"radiant_fun_item_total_price_thresold", "type":"dropdown", "options":[0, 10000, 15000, 30000, 45000, 60000, 75000, 90000, 150000, 200000, 1000000], "default_value" : 1000000},
		
	
	],
	[
		{"id":"respawn_time_percentage", "type":"dropdown", "options":[100, 90, 80, 70, 60, 50, 40, 30, 20, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], "percentage":true, "default_value":100},
		{"id":"buyback_cooldown", "type":"dropdown", "options":[480, 420, 360, 300, 240, 180, 120, 60, 50, 40, 30, 20, 10, 0], "default_value":480},
		{"id":"tower_power", "type":"dropdown", "options":[1, 2, 3, 4, 5, 6, 7, 8, 9, 10], "default_value":1},
		{"id":"tower_endure", "type":"dropdown", "options":[1, 2, 3, 4, 5, 6, 7, 8, 9, 10], "default_value": 1},
		{"id":"extra_tower", type:"dropdown", "options":[0,1,2,3,4,5,6,7,8,9,10],"default_value":0},
		{"id":"max_level", "type":"dropdown", "options":[30, 50, 100, 200, 400, 800, 1600], "default_value" : 30},
	],
	[
		{"id":"imbalanced_economizer", "type":"toggle", "default_value":false},
		{"id":"bot_has_fun_item", "type":"toggle", "default_value":true},
		{"id":"universal_shop", "type":"toggle", "default_value":false},
		{"id":"fast_courier", "type":"toggle", "default_value":true},
		{"id":"bot_protection", "type":"toggle", "default_value":true},
		{"id":"anti_diving", "type":"toggle", "default_value":true},
		{"id":"enable_lottery", "type":"toggle", "default_value":true},
		{"id":"extra_tower_phased", "type":"toggle", "default_value":true},
	]
//	{"id":"dynamic_exp_gold", "type":"toggle", "default_value":false},
]


var aVoteOptions = [
	{name:'#wheter_activate_fun_heroes',options:['#aifun_vote_no', '#aifun_vote_yes'], lua_name:'iActivateFunHeroes'}, 
	{name:'#wheter_activate_imba_fun_heroes',options:['#aifun_vote_no', '#aifun_vote_yes'], tooltip:"#imba_fun_heroes_tooltip", lua_name:'iActivateImbaFunHeroes'},
//	{name:'#wheter_ban_fun_items',options:['#aifun_vote_no', '#aifun_vote_yes'], lua_name:'iBanFunItems'},					
] 


//$.Msg("game mode data loaded")