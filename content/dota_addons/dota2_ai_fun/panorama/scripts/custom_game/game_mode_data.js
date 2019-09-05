"use strict"; 
var aGameOptionList = [
	{"id":"radiant_gold_multiplier", "linked_equal_player_id":"dire_gold_multiplier", "type":"dropdown", "options":[1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 6, 7, 8, 9, 10], "default_value":1},
	{"id":"dire_gold_multiplier", "linked_equal_player_id":"radiant_gold_multiplier", "type":"dropdown", "options":[1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 6, 7, 8, 9, 10], "default_value":1},
	{"id":"radiant_xp_multiplier", "linked_equal_player_id":"dire_xp_multiplier", "type":"dropdown", "options":[1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 6, 7, 8, 9, 10], "default_value":1},
	{"id":"dire_xp_multiplier", "linked_equal_player_id":"radiant_xp_multiplier", "type":"dropdown", "options":[1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 6, 7, 8, 9, 10], "default_value":1},
	{"id":"radiant_player_number", "linked_equal_player_id":"dire_player_number", "type":"dropdown", "options":[12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], "default_value":12},
	{"id":"dire_player_number", "linked_equal_player_id":"radiant_player_number", "type":"dropdown", "options":[12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], "default_value":12},
	{"id":"respawn_time_percentage", "type":"dropdown", "options":[100, 90, 80, 70, 60, 50, 40, 30, 20, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], "percentage":true, "default_value":100},
	{"id":"tower_power", "type":"dropdown", "options":[1, 2, 3, 4, 5, 6, 7, 8, 9, 10], "default_value":1},
	{"id":"tower_endure", "type":"dropdown", "options":[1, 2, 3, 4, 5, 6, 7, 8, 9, 10], "default_value": 1},
	{"id":"max_level", "type":"dropdown", "options":[25, 50, 100, 200, 400, 800, 1600, 3200, 6400], "default_value" : 25},
	{"id":"imbalanced_economizer", "type":"toggle", "default_value":false},
	{"id":"bot_has_fun_item", "type":"toggle", "default_value":true},
	{"id":"universal_shop", "type":"toggle", "default_value":false},
	{"id":"fast_courier", "type":"toggle", "default_value":true},
	{"id":"dynamic_exp_gold", "type":"toggle", "default_value":false},
]


var aVoteOptions = [
	{name:'#wheter_activate_fun_heroes',options:['#aifun_vote_no', '#aifun_vote_yes'], lua_name:'iActivateFunHeroes'}, 
	{name:'#wheter_activate_imba_fun_heroes',options:['#aifun_vote_no', '#aifun_vote_yes'], tooltip:"#imba_fun_heroes_tooltip", lua_name:'iActivateImbaFunHeroes'},
//	{name:'#game_setting', options:['#aifun_vote_5', '#aifun_vote_12', '#aifun_vote_host'], tooltips:['#aifun_vote_55_tooltip', '#aifun_vote_12_tooltip', '']},
	{name:'#wheter_ban_fun_items',options:['#aifun_vote_no', '#aifun_vote_yes'], lua_name:'iBanFunItems'},					
] 


//$.Msg("game mode data loaded")