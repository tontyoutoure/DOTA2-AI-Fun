"use strict";

(function () {
	InitializeUI()

	// Hides battlecuck crap
	var hit_test_blocker = $.GetContextPanel().GetParent().FindChild("SidebarAndBattleCupLayoutContainer");

	if (hit_test_blocker) {
		hit_test_blocker.hittest = false;
		hit_test_blocker.hittestchildren = false;
	}
})();

function InitializeUI() {
	var is_host = CheckForHostPrivileges();
	if (is_host === undefined) {
		$.Schedule(1, InitializeUI);
		return;
	} else if (is_host) {
		$("#game_options_container").style.visibility='visible';		
	}
}



function CheckForHostPrivileges() {
	var player_info = Game.GetLocalPlayerInfo();
	if ( !player_info ) {
		return undefined;
	} else {
		return player_info.player_has_host_privileges;
	}
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
			"max_level": $("#max_level_dropdown").GetSelected().id,
			"imbalanced_economizer": $("#imbalanced_economizer").checked,
			"bot_attack_tower_pick_rune": $("#bot_attack_tower_pick_rune").checked,
			"bot_has_fun_item": $("#bot_has_fun_item").checked,
			"universal_shop": $("#universal_shop").checked
		}	
	});
	$("#game_options_container").style.visibility='collapse';
}

var sActivatingPanel

function HeroDescription(sPanelID){
	var hPanel = $(sPanelID)
	var hContainer = $("#HeroDescriptionPopPanelContainer")
	var aCursorPosition = GameUI.GetCursorPosition();
	if (hPanel.style.visibility == 'visible') {
		hPanel.style.visibility = 'collapse';
		hContainer.style.visibility = 'collapse';
		sActivatingPanel = null;
	}
	else {		
		if (sActivatingPanel)
			HeroDescription(sActivatingPanel);
		hPanel.style.visibility = 'visible';
		hContainer.style.visibility = 'visible';
		sActivatingPanel = sPanelID;
		$.Msg(hPanel.GetPositionWithinWindow());
	}
}