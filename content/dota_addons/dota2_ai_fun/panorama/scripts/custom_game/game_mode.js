"use strict";
$.GetContextPanel().GetParent().GetParent().FindChildTraverse("ChatLinesContainer").hittest=false
var GameOptions = {}

function IsBothTeamHasHuman() {
	var aTeamIDs = Game.GetAllTeamIDs()
	var bReturn = true
	for (var i = 0; i < aTeamIDs.length; i++) {
		bReturn = bReturn && Game.GetTeamDetails(aTeamIDs[i]).team_num_players > 0
	}
	return bReturn
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
	
	for (var i in aGameOptionList) { 
		$("#GameOptionSubpanelContainerInner").BCreateChildren('<Panel id="'+aGameOptionList[i].id+'_Container" class="GameOptionsSubPanel"/>')
		$("#"+aGameOptionList[i].id+'_Container').BCreateChildren('<Label text="#'+aGameOptionList[i].id+'"/>')
		if (aGameOptionList[i].type == "toggle") {
			$("#"+aGameOptionList[i].id+'_Container').BCreateChildren('<ToggleButton id="'+aGameOptionList[i].id+'" class="GameOptionsToggle"/>')	
			$("#"+aGameOptionList[i].id).checked = aGameOptionList[i].default_value
			GameOptions[aGameOptionList[i].id] = aGameOptionList[i].default_value
			SetOptionInputEvent(aGameOptionList[i].id)
		}		
		else if (aGameOptionList[i].type == "dropdown") {
			$("#"+aGameOptionList[i].id+'_Container').BCreateChildren('<DropDown id="'+aGameOptionList[i].id+'" class="GameOptionsDropdown"/>')	
			for (var j in aGameOptionList[i].options) {
				var dropdownlabel = $.CreatePanel('Label', $("#"+aGameOptionList[i].id), aGameOptionList[i].options[j].toString())
				if (aGameOptionList[i].percentage)
					dropdownlabel.text = aGameOptionList[i].options[j].toString()+"%";
				else
					dropdownlabel.text = aGameOptionList[i].options[j].toString();
				$("#"+aGameOptionList[i].id).AddOption(dropdownlabel)
			}
			$("#"+aGameOptionList[i].id).SetSelected(aGameOptionList[i].default_value.toString())
			GameOptions[aGameOptionList[i].id] = aGameOptionList[i].default_value.toString()
			SetOptionInputEvent(aGameOptionList[i].id, aGameOptionList[i].linked_equal_player_id)		
		}
	}
	if ( CheckForHostPrivileges() ) {GameEvents.SendCustomGameEventToServer("loading_game_options",GameOptions);	}
	$.GetContextPanel().GetParent().GetParent().FindChildTraverse("ChatLinesArea").style.opacity = 0.5
}

function SetOptionInputEvent(sSelf, sLink) {
	if ($("#"+sSelf).paneltype == "ToggleButton") {
		$("#"+sSelf).SetPanelEvent('onactivate',function () {
			GameOptions[sSelf] = $("#"+sSelf).checked
			delete GameOptions.btoVote
			GameEvents.SendCustomGameEventToServer("loading_game_options",GameOptions);	
			GameEvents.SendCustomGameEventToAllClients("loading_set_options_for_client",GameOptions);	
		})
	}
	else if ($("#"+sSelf).paneltype == "DropDown") {
		if (sLink) {
			$("#"+sSelf).SetPanelEvent('oninputsubmit', function () {
				GameOptions[sSelf] = $("#"+sSelf).GetSelected().id
				delete GameOptions.btoVote
				GameEvents.SendCustomGameEventToServer("loading_game_options",GameOptions);	
				GameEvents.SendCustomGameEventToAllClients("loading_set_options_for_client",GameOptions);	
				if (IsBothTeamHasHuman()){ $("#"+sLink).SetSelected($("#"+sSelf).GetSelected().id)
			}});
		}
		else {
			$("#"+sSelf).SetPanelEvent('oninputsubmit', function () {
				GameOptions[sSelf] = $("#"+sSelf).GetSelected().id
				delete GameOptions.btoVote
				GameEvents.SendCustomGameEventToServer("loading_game_options",GameOptions);	
				GameEvents.SendCustomGameEventToAllClients("loading_set_options_for_client",GameOptions);	
			});
		}
	}	
		
}

InitializeUI({PlayerID:0})
function LockGameOptions() 
{

	Game.SetRemainingSetupTime(0)
	GameEvents.SendCustomGameEventToServer("confirm_game_options",{});	
	return 
	
}


function UpdateGameOptions(keys) {
	for (var i in aGameOptionList) {
		if (aGameOptionList[i].type == "dropdown") {	
			$("#"+aGameOptionList[i].id).SetSelected(keys[aGameOptionList[i].id])
		}
		else if (aGameOptionList[i].type == "toggle") {
			$("#"+aGameOptionList[i].id).checked = keys[aGameOptionList[i].id]
		}
	}		
}

function StartGameOptionVote(keys) {
	$("#GameOptionHider").visible=true;
	$("#LockOptionsBtn").visible=false;
	$("#HostSettingGameOptions").visible=false;
	$('#GameOptionVoteContainer').visible = true;
	$('#GameOptionVoteLabelNay').text = $.Localize('#deny_game_options')+(0).toString()
	$('#GameOptionVoteLabelYay').text = $.Localize('#confirm_game_options')+(0).toString()
	if (!(CheckForHostPrivileges())) {
		$('#GameOptionVoteButtonYay').visible = false;
		$('#GameOptionVoteButtonNay').visible = false;		
	}
}

function UpdateGameOptionSetTime(keys) {
	$('#LockOptionsBtnLabel').text = $.Localize('#lock_game_options')+' - '+keys.iTime 
	$('#HostSettingGameOptionsLabel').text = $.Localize('#host_setting_game_options')+' - '+keys.iTime 
}

function OnGameOptionVoteButtonYayActivated() {
	GameEvents.SendCustomGameEventToServer("loading_game_options",{vote : 1});	
	$('#GameOptionVoteButtonYay').visible = false;
	$('#GameOptionVoteButtonNay').visible = false;	
}
function OnGameOptionVoteButtonNayActivated() {
	GameEvents.SendCustomGameEventToServer("loading_game_options",{vote : 0});	
	$('#GameOptionVoteButtonYay').visible = false;
	$('#GameOptionVoteButtonNay').visible = false;	
}


function SetLoadingGameOptionVote(keys) {
}

function PanoramaPrint(keys) {
	$.Msg("Print request from sever: ", keys)
}

GameEvents.Subscribe( "player_connect_full", InitializeUI);
GameEvents.Subscribe( "loading_set_options_for_client", UpdateGameOptions);
GameEvents.Subscribe("panorama_print", PanoramaPrint)
GameEvents.Subscribe("start_loading_game_option_vote", StartGameOptionVote)
GameEvents.Subscribe("set_loading_game_option_vote", SetLoadingGameOptionVote)
//GameEvents.Subscribe("update_game_option_set_time", UpdateGameOptionSetTime)
