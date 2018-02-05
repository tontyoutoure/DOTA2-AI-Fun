"use strict";


function ShowGameOptions() {
	$("#game_options_container").style.visibility='visible';	
	$("#GameOptionShowButton").style.visibility='collapse';	
}


function CheckForHostPrivileges() {
	var player_info = Game.GetLocalPlayerInfo();
	if ( !player_info ) {
		return undefined;
	} else {
		return player_info.player_has_host_privileges;
	}
}

function InitializeUI(keys) {
	if (keys.PlayerID != Game.GetLocalPlayerID()) {return}
	$.Msg(CheckForHostPrivileges())
	var is_host = CheckForHostPrivileges();
	if (is_host === undefined) {
		$.Schedule(1, InitializeUI);
		return;
	} else if (is_host) {
		$("#game_options_container").style.visibility='visible';		
	}
	// Hides battlecuck crap
	var hit_test_blocker = $.GetContextPanel().GetParent().FindChild("SidebarAndBattleCupLayoutContainer");

	if (hit_test_blocker) {
		hit_test_blocker.hittest = false;
		hit_test_blocker.hittestchildren = false;
	}
	$("#ChatHideButtonHide").visible=true;
	var iScreenWidth = 	Game.GetScreenWidth()
	var iScreenHeight = Game.GetScreenHeight()
	if (iScreenWidth/iScreenHeight < (16/10+4/3)/2){
		$("#ChatHideButtonContainer").SetHasClass("ChatHideButtonContainerPos4_3", true)
	}
	else if ((iScreenWidth/iScreenHeight < (16/10+16/9)/2)){
		$("#ChatHideButtonContainer").SetHasClass("ChatHideButtonContainerPos16_10", true)  
	}
	else {
		$("#ChatHideButtonContainer").SetHasClass("ChatHideButtonContainerPos16_9", true)
	}
}

function HideChatTeamActivate() {
	$.GetContextPanel().GetParent().GetParent().FindChildTraverse("LoadingScreenChat").visible=false;
	$("#ChatHideButtonHide").visible=false;
	$("#ChatHideButtonShow").visible=true;
	GameEvents.SendCustomGameEventToClient("LoadingScreenTeamHide", Players.GetLocalPlayer()+1, {})
}

function ShowChatTeamActivate() {
	$.GetContextPanel().GetParent().GetParent().FindChildTraverse("LoadingScreenChat").visible=true;
	$("#ChatHideButtonHide").visible=true;
	$("#ChatHideButtonShow").visible=false;
	GameEvents.SendCustomGameEventToClient("LoadingScreenTeamShow", Players.GetLocalPlayer()+1, {})
}

$("#bot_attack_tower_pick_rune").checked=true;
function set_game_options()
{
	GameEvents.SendCustomGameEventToServer("loading_set_options",{
		"host_privilege": CheckForHostPrivileges(),
		"game_options":{
			"radiant_gold_multiplier": $("#radiant_gold_multiplier_dropdown").GetSelected().id,
			"dire_gold_multiplier": $("#dire_gold_multiplier_dropdown").GetSelected().id,
			"radiant_xp_multiplier": $("#radiant_xp_multiplier_dropdown").GetSelected().id,
			"dire_xp_multiplier": $("#dire_xp_multiplier_dropdown").GetSelected().id,
			"radiant_player_number": $("#radiant_player_number_dropdown").GetSelected().id,
			"dire_player_number": $("#dire_player_number_dropdown").GetSelected().id,
			"respawn_time_percentage": $("#respawn_time_percentage_dropdown").GetSelected().id,
			"tower_power": $("#tower_power_dropdown").GetSelected().id,
			"tower_endure": $("#tower_endure_dropdown").GetSelected().id,			
			"max_level": $("#max_level_dropdown").GetSelected().id,
			"imbalanced_economizer": $("#imbalanced_economizer").checked,
			"bot_attack_tower_pick_rune": $("#bot_attack_tower_pick_rune").checked,
			"bot_has_fun_item": $("#bot_has_fun_item").checked,
			"universal_shop": $("#universal_shop").checked
		}	
	});
	$("#game_options_container").style.visibility='collapse';
	$("#GameOptionShowButton").style.visibility='visible';	
}


GameEvents.Subscribe( "player_connect_full", InitializeUI);