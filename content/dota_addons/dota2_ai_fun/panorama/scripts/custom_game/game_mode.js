"use strict";
$.GetContextPanel().GetParent().GetParent().FindChildTraverse("ChatLinesContainer").hittest=false
var GameOptions = {}
var aGameOptionPages = []
var iCurrentGameOptionPage = 0
var tGameOptionsControlDropDowns = {}
var tGameOptionsControlToggles = {}
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

function AddDropDown(tDropDown, hParent) {
	$.CreatePanelWithProperties('Panel', hParent, tDropDown.id+"_Container",{id:tDropDown.id+"_Container", class:"GameOptionsSubPanel_DropDown"})
	$.CreatePanelWithProperties('Label', $("#"+tDropDown.id+'_Container'), '',{text:"#"+tDropDown.id})
	
	$.CreatePanelWithProperties('DropDown', $("#"+tDropDown.id+'_Container'), tDropDown.id,{id:tDropDown.id, class:"GameOptionsDropdown"})
	for (var j in tDropDown.options) {
		var dropdownlabel = $.CreatePanel('Label', $("#"+tDropDown.id), tDropDown.options[j].toString())
		if (tDropDown.percentage)
			dropdownlabel.text = tDropDown.options[j].toString()+"%";
		else
			dropdownlabel.text = tDropDown.options[j].toString();
		$("#"+tDropDown.id).AddOption(dropdownlabel)
	}
	$("#"+tDropDown.id).SetSelected(tDropDown.default_value.toString())
	GameOptions[tDropDown.id] = tDropDown.default_value.toString()
	if (Game.IsInToolsMode() && tDropDown.toolsmode_default_value) {
		$("#"+tDropDown.id).SetSelected(tDropDown.toolsmode_default_value.toString())
		GameOptions[tDropDown.id] = tDropDown.toolsmode_default_value.toString()
	}
	tGameOptionsControlDropDowns[tDropDown.id] = $("#"+tDropDown.id)
	SetOptionInputEvent(tDropDown.id)		
}

function AddToggle(tToggle, hParent) {
	$.CreatePanelWithProperties('Panel', hParent, tToggle.id+"_Container",{id:tToggle.id+"_Container", class:"GameOptionsSubPanel_Toggle"})
	$.CreatePanelWithProperties('Label', $("#"+tToggle.id+'_Container'), '',{text:"#"+tToggle.id})
	
	$.CreatePanelWithProperties('ToggleButton', $("#"+tToggle.id+'_Container'), tToggle.id,{id:tToggle.id, class:"GameOptionsToggle"})
	$("#"+tToggle.id).checked = tToggle.default_value
	GameOptions[tToggle.id] = tToggle.default_value

	if (Game.IsInToolsMode() && tToggle.toolsmode_default_value) {
		$("#"+tToggle.id).checked = tToggle.toolsmode_default_value
		GameOptions[tToggle.id] = tToggle.toolsmode_default_value
	}
	tGameOptionsControlToggles[tToggle.id] = $("#"+tToggle.id)
	SetOptionInputEvent(tToggle.id)
}



function InitializeUI(keys) {
	$.Msg("Initializing Game Options UI")
	var sOption
	if (keys.PlayerID != Game.GetLocalPlayerID()) {return}
	// Hides battlecuck crap
	var hit_test_blocker = $.GetContextPanel().GetParent().FindChild("SidebarAndBattleCupLayoutContainer");

	if (hit_test_blocker) {
		hit_test_blocker.hittest = false;
		hit_test_blocker.hittestchildren = false;
	}
	for (var i in aGameOptionList) {
		$.CreatePanelWithProperties('Panel', $("#GameOptionSubpanelContainerMiddle"), "GameOptionSubpanelContainerInner"+i.toString(),{class:"GameOptionSubpanelContainerInner", id:"GameOptionSubpanelContainerInner"+i.toString()})
		for (var j in aGameOptionList[i]) {
			if (aGameOptionList[i][j].type == "toggle") {
				AddToggle(aGameOptionList[i][j], $("#GameOptionSubpanelContainerInner"+i.toString()))
			}
			else if (aGameOptionList[i][j].type == "dropdown") {
				AddDropDown(aGameOptionList[i][j], $("#GameOptionSubpanelContainerInner"+i.toString()))
			}
		}
		aGameOptionPages.push($("#GameOptionSubpanelContainerInner"+i.toString()))
	}
	$("#GameOptionSubpanelContainerInner0").visible = true;
	$("#PreviousPageBtn").visible = true;
	$("#NextPageBtn").visible = true;
	if ( CheckForHostPrivileges() ) {GameEvents.SendCustomGameEventToServer("loading_game_options",GameOptions);	}
	$.GetContextPanel().GetParent().GetParent().FindChildTraverse("ChatLinesArea").style.opacity = 0.5
}




function SetOptionInputEvent(sSelf) {
	if ($("#"+sSelf).paneltype == "ToggleButton") {
		$("#"+sSelf).SetPanelEvent('onactivate',function () {
			GameOptions[sSelf] = $("#"+sSelf).checked
			delete GameOptions.btoVote
			GameEvents.SendCustomGameEventToServer("loading_game_options",GameOptions);	
			GameEvents.SendCustomGameEventToAllClients("loading_set_options_for_client",GameOptions);	
		})
	}
	else if ($("#"+sSelf).paneltype == "DropDown") {

		$("#"+sSelf).SetPanelEvent('oninputsubmit', function () {
			GameOptions[sSelf] = $("#"+sSelf).GetSelected().id
			delete GameOptions.btoVote
			GameEvents.SendCustomGameEventToServer("loading_game_options",GameOptions);	
			GameEvents.SendCustomGameEventToAllClients("loading_set_options_for_client",GameOptions);	
		});
	}	
		
}


function GameOptionsNextPage() {
	aGameOptionPages[iCurrentGameOptionPage].visible=false
	iCurrentGameOptionPage = iCurrentGameOptionPage+1
	aGameOptionPages[iCurrentGameOptionPage].visible=true
	if (iCurrentGameOptionPage > 0) {
		$('#PreviousPageBtn').style.width = "49%"
	}
	if (iCurrentGameOptionPage == aGameOptionPages.length-1) {
		$('#NextPageBtn').visible = false
	}
}

function GameOptionsPreviousPage() {
	aGameOptionPages[iCurrentGameOptionPage].visible=false
	iCurrentGameOptionPage = iCurrentGameOptionPage-1
	aGameOptionPages[iCurrentGameOptionPage].visible=true
	if (iCurrentGameOptionPage == 0) {
		$('#PreviousPageBtn').style.width = "0%"
	}
	if (iCurrentGameOptionPage < aGameOptionPages.length-1) {
		$('#NextPageBtn').visible = true
	}
}



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


var LatestScheduler
var iFadingTime = 3
function HideUploadDownloadNotification() {
	$('#UploadDownloadNotificationPanel'+a.toString).visible = false
}

 

function GenerateOptionJson()
{
	$("#GameOptionJsonInput").text = JSON.stringify(GameOptions)
	// $.Msg($("#GameOptionJsonInput").text )
	$('#UploadDownloadNotificationLabel').text = $.Localize("#json_generated")
	$("#UploadDownloadNotificationPanel").visible = true
}

function GameOptionJsonOnfocus()
{
	$("#GameOptionJsonInput").SelectAll()
	$('#UploadDownloadNotificationLabel').text = $.Localize("#json_selected")
	$("#UploadDownloadNotificationPanel").visible = true
}

function GameOptionJsonOnblur()
{
	if ($("#GameOptionJsonInput").text.length > 0) 
	{
		$('#UploadDownloadNotificationLabel').text = $.Localize("#json_not_empty")
		$("#UploadDownloadNotificationPanel").visible = true
		GameOptions = JSON.parse($("#GameOptionJsonInput").text)
		GameEvents.SendCustomGameEventToServer("loading_game_options",GameOptions);	
	}
	else
	{
		$("#UploadDownloadNotificationPanel").visible = false
	}
}


GameEvents.Subscribe( "player_connect_full", InitializeUI);
GameEvents.Subscribe( "loading_set_options_for_client", UpdateGameOptions);
GameEvents.Subscribe("panorama_print", PanoramaPrint)
GameEvents.Subscribe("start_loading_game_option_vote", StartGameOptionVote)
GameEvents.Subscribe("set_loading_game_option_vote", SetLoadingGameOptionVote)
//GameEvents.Subscribe("update_game_option_set_time", UpdateGameOptionSetTime)
//InitializeUI({PlayerID:0})