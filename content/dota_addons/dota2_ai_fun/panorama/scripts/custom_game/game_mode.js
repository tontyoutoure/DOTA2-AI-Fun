"use strict";
$.GetContextPanel().GetParent().GetParent().FindChildTraverse("ChatLinesContainer").hittest=false
var tGameOptionList = {
	"radiant_gold_multiplier":{"type":"dropdown", "option":[1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5]},
	"dire_gold_multiplier":{"type":"dropdown", "option":[1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5]},
	"radiant_xp_multiplier":{"type":"dropdown", "option":[1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5]},
	"dire_xp_multiplier":{"type":"dropdown", "option":[1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5]},
	"radiant_player_number":{"type":"dropdown", "option":[10, 9, 8, 7, 6, 5, 4, 3, 2, 1]},
	"dire_player_number":{"type":"dropdown", "option":[10, 9, 8, 7, 6, 5, 4, 3, 2, 1]},
	"respawn_time_percentage":{"type":"dropdown", "option":[100, 70, 40, 10, 7, 4, 1, 0], "percentage":true},
	"tower_power":{"type":"dropdown", "option":[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]},
	"tower_endure":{"type":"dropdown", "option":[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]},
	"max_level":{"type":"dropdown", "option":[25, 50, 100, 200, 400, 800, 1600]},
	"imbalanced_economizer":{"type":"toggle"},
	"bot_attack_tower_pick_rune":{"type":"toggle"},
	"bot_has_fun_item":{"type":"toggle"},
	"universal_shop":{"type":"toggle"},
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
	var sOption
	if (keys.PlayerID != Game.GetLocalPlayerID()) {return}
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
	$.GetContextPanel().GetParent().GetParent().FindChildTraverse("LoadingScreenChat").visible=false
	
	$("#ChatHideButtonHide").visible=false;
	$("#ChatHideButtonShow").visible=true;
	GameEvents.SendCustomGameEventToAllClients("LoadingScreenTeamHide", {iPlayerID:Players.GetLocalPlayer()})
}

function ShowChatTeamActivate() {
	$.GetContextPanel().GetParent().GetParent().FindChildTraverse("LoadingScreenChat").visible=true
	$("#ChatHideButtonHide").visible=true;
	$("#ChatHideButtonShow").visible=false;
	GameEvents.SendCustomGameEventToAllClients("LoadingScreenTeamShow", {iPlayerID:Players.GetLocalPlayer()})
}
function LockGameOptions()
{
	var GameOptions = {}
	var GameOptionsForClient = {}
	for (var sOptionName in tGameOptionList) {
		if (tGameOptionList[sOptionName].type == "dropdown") {			
			GameOptions[sOptionName] = $("#"+sOptionName+"_dropdown").GetSelected().id
			GameOptionsForClient[sOptionName] = $("#"+sOptionName+"_dropdown").tabindex
		}
		else if (tGameOptionList[sOptionName].type == "toggle") {
			GameOptions[sOptionName] = $("#"+sOptionName).checked
			GameOptionsForClient[sOptionName] = $("#"+sOptionName).checked
		}
	}		
	GameEvents.SendCustomGameEventToServer("loading_set_options",GameOptions);	
	GameEvents.SendCustomGameEventToAllClients("loading_set_options_for_client",GameOptionsForClient);	
	$("#GameOptionHider").visible=true;
	$("#LockOptionsBtn").visible=false;
	$("#UnlockOptionsBtn").visible=true;
	Game.EmitSound('ui_team_select_lock_and_start')
}

function UnlockGameOptions(){	
	$("#GameOptionHider").visible=false;
	$("#LockOptionsBtn").visible=true;
	$("#UnlockOptionsBtn").visible=false;
	Game.EmitSound('ui_team_select_cancel_and_lock')
}

function UpdateGameOptions(keys) {
	for (var sOptionName in tGameOptionList) {
		if (tGameOptionList[sOptionName].type == "dropdown") {	
			$("#"+sOptionName+"_dropdown").tabindex = keys[sOptionName]
		}
		else if (tGameOptionList[sOptionName].type == "toggle") {
			$("#"+sOptionName).checked = keys[sOptionName]
		}
	}		
}

function PanoramaPrint(keys) {
	$.Msg("Print request from sever: ", keys)
}
function OnGameStateChange(keys) {
//	$.Msg(Game.GetState())
}
GameEvents.Subscribe( "game_rules_state_change", OnGameStateChange);
GameEvents.Subscribe( "player_connect_full", InitializeUI);
GameEvents.Subscribe( "loading_set_options_for_client", UpdateGameOptions);
GameEvents.Subscribe("panorama_print", PanoramaPrint)