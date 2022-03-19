"use strict"; 

var aSelfVote = [1,1,0]
var iPlayerCount
var bLockHided
function InitializeVote () {
	$.Msg("InitializeVote")
	for (var i=0;i < aVoteOptions.length;i++) {
		$.CreatePanelWithProperties('Panel', $('#VoteListContainer'), "SingleVote"+i.toString(),{id:"SingleVote"+i.toString(), class:"SingleVoteContainer"})
		
		if (aVoteOptions[i].tooltip) {			
			$.CreatePanelWithProperties('Panel', $('#SingleVote'+i.toString()), "SingleVoteTitleContainer"+i.toString(),{class:"SingleVoteTitleContainer", id:"SingleVoteTitleContainer"+i.toString(), onmouseover:"DOTAShowTextTooltip("+aVoteOptions[i].tooltip+");", onmouseout:"DOTAHideTextTooltip();"});
		}
		else {
			$.CreatePanelWithProperties('Panel', $('#SingleVote'+i.toString()), "SingleVoteTitleContainer"+i.toString(),{class:"SingleVoteTitleContainer", id:"SingleVoteTitleContainer"+i.toString()})
		}
		$.CreatePanelWithProperties('Label', $('#SingleVoteTitleContainer'+i.toString()), '',{text:aVoteOptions[i].name})
		for (var j = 0; j < aVoteOptions[i].options.length; j++) {			
			if (aVoteOptions[i].tooltip) {
				$.CreatePanelWithProperties('Button', $('#SingleVote'+i.toString()), "VoteOptionContainer"+i.toString()+"_"+j.toString(),{class:"VoteOptionContainer", id:"VoteOptionContainer"+i.toString()+"_"+j.toString(), onmouseover:"DOTAShowTextTooltip("+aVoteOptions[i].tooltip+");", onmouseout:"DOTAHideTextTooltip();"});
			}
			else {
				$.CreatePanelWithProperties('Button', $('#SingleVote'+i.toString()), "VoteOptionContainer"+i.toString()+"_"+j.toString(),{class:"VoteOptionContainer", id:"VoteOptionContainer"+i.toString()+"_"+j.toString()});
			}
			$('#VoteOptionContainer'+i.toString()+'_'+j.toString()).vote_index = i
			$('#VoteOptionContainer'+i.toString()+'_'+j.toString()).choice_index = j
			$.RegisterEventHandler('Activated', $('#VoteOptionContainer'+i.toString()+'_'+j.toString()), OnVoteActivated)
			$.CreatePanelWithProperties('Panel', $('#VoteOptionContainer'+i.toString()+'_'+j.toString()), "VoteOptionChoiceContainer"+i.toString()+"_"+j.toString(),{class:"VoteOptionChoiceContainer", id:"VoteOptionChoiceContainer"+i.toString()+"_"+j.toString()})
			$.CreatePanelWithProperties('Label', $('#VoteOptionChoiceContainer'+i.toString()+'_'+j.toString()), "VoteOptionChoice"+i.toString()+"_"+j.toString(),{id:"VoteOptionChoice"+i.toString()+"_"+j.toString(), text:""})
			$.CreatePanelWithProperties('Panel', $('#VoteOptionContainer'+i.toString()+'_'+j.toString()), "VoteOptionTitleContainer"+i.toString()+"_"+j.toString(),{class:"VoteOptionTitleContainer", id:"VoteOptionTitleContainer"+i.toString()+"_"+j.toString()})
			$.CreatePanelWithProperties('Label', $('#VoteOptionTitleContainer'+i.toString()+'_'+j.toString()), '',{text:aVoteOptions[i].options[j]})
			
			
			$.CreatePanelWithProperties('Panel', $('#VoteOptionContainer'+i.toString()+'_'+j.toString()), "VoteOptionCounterContainer"+i.toString()+"_"+j.toString(),{class:"VoteOptionCounterContainer", id:"VoteOptionCounterContainer"+i.toString()+"_"+j.toString()})
			$.CreatePanelWithProperties('Label', $('#VoteOptionCounterContainer'+i.toString()+'_'+j.toString()), "VoteCounter"+i.toString()+"_"+j.toString(),{id:"VoteCounter"+i.toString()+"_"+j.toString(), text:"0"})
		}		
	}
	for (var i=0;i < aVoteOptions.length;i++) {
		MakeVote(i, aSelfVote[i], true)
	}
	if (Players.GetLocalPlayer() > 0) {
		$('#VoteContentContainer').visible = false
		$('#VoteConfirmButtonContainer').visible = false
		
	}
	$('#VoteContainer').visible = true;
	GameEvents.SendCustomGameEventToAllClients("loading_vote_full", {})
}

function OnVoteActivated(hPanel, fCallback) {
	MakeVote(hPanel.vote_index, hPanel.choice_index)
}

function MakeVote(vote_index, choice_index, bSilent) {
	if (!bSilent)
		Game.EmitSound('ui_team_select_lock_and_start');
	if (aSelfVote[vote_index] >= 0) {
		$('#VoteOptionChoice'+vote_index.toString()+'_'+aSelfVote[vote_index].toString()).text = '';
		$('#VoteOptionChoice'+vote_index.toString()+'_'+choice_index.toString()).text = $.Localize('#your_choice');
		aSelfVote[vote_index] = choice_index;		
	}
	else {
		$('#VoteOptionChoice'+vote_index.toString()+'_'+choice_index.toString()).text = $.Localize('#your_choice');
		aSelfVote[vote_index] = choice_index;		
	}
}

function UpdateVoteResult(tVoteResult) {
	for (var i = 0; i < aVoteOptions.length; i++) {
		if (tVoteResult[(i+1).toString()]) {
			for (var j = 0; j < aVoteOptions[i].options.length; j++) {
				if (tVoteResult[(i+1).toString()][j.toString()] || tVoteResult[(i+1).toString()][j.toString()]===0) {
					$('#VoteCounter'+i.toString()+'_'+j.toString()).text = tVoteResult[(i+1).toString()][j.toString()];
				}
			}
		}
	}
}

function OnVoteConfirm() {
	iPlayerCount = GetPlayerCount()
	$('#VoteBlocker').visible = true
	$('#VoteConfirmButtonContainer').visible = false
	GameEvents.SendCustomGameEventToServer("vote_confirm", {iPlayerCount:iPlayerCount,aVoteResult:aSelfVote})
}


function GetPlayerCount() {
	var iMaxPlayer = 0
	for ( var i = 0; i < Players.GetMaxPlayers(); i++) {
		if (Game.GetPlayerInfo(i)) 
			iMaxPlayer++;
	}
	return iMaxPlayer
}

function UpdateVoteTime(keys) {
	$('#VoteTimeLeftLabel').text = $.Localize('#vote_time_remaining')+keys.iTime
}

function UpdateVoteConfirmedPlayers(keys) {
	if ($('#VoteConfirmButtonContainer').visible === false && $('#VoteConfirmCount').visible === false) {
		$('#VoteConfirmCount').visible = true
	}
	$('#VoteConfirmCountLabel').text = $.Localize('#confirmed_players')+keys.iConfirmedPlayerCount+'/'+keys.iPlayerCount
}

function InitUISecond(keys) {
	$("#bot_has_fun_item").checked=true;  
	$("#fast_courier").checked=true;  
	if (Game.GetLocalPlayerInfo() === undefined) {
		$.Schedule(1, InitializeUI);
		return;
	} else if (Game.GetLocalPlayerInfo().player_has_host_privileges) {
		$("#game_options_container").visible=true;
		$("#GameOptionHider").visible=false;
		$("#LockOptionsBtn").visible=true;
		$("#UnlockOptionsBtn").visible=false;
	}
	else
	{
		$("#game_options_container").visible=true;
		$("#GameOptionHider").visible=true;
		$("#LockOptionsBtn").visible=false;
		$("#UnlockOptionsBtn").visible=false;
	}	
}
function VoteEnd(keys) {
	$('#VoteContainer').visible = false	
	GameEvents.SendCustomGameEventToAllClients("LoadingScreenTeamHide", {iPlayerID:Players.GetLocalPlayer()})
	
	if (Game.GetLocalPlayerInfo() === undefined) {
		$.Schedule(1, InitializeUI);
		return;
	} else if (Game.GetLocalPlayerInfo().player_has_host_privileges) {
		$("#game_options_container").visible=true;
//		$("#GameOptionHider").visible=false;
		$("#LockOptionsBtn").visible=true;
		$("#HostSettingGameOptions").visible=false;
	}
	else
	{
		$("#game_options_container").visible=false;
		$("#GameOptionHider").visible=true;
		$("#LockOptionsBtn").visible=false;
		$("#HostSettingGameOptions").visible=true;
		
	}	
	$.GetContextPanel().GetParent().GetParent().FindChildTraverse("LoadingScreenChat").style.horizontalAlign='right'
	if (Game.IsInToolsMode())
		Game.SetRemainingSetupTime( 9999);
	else
		Game.SetRemainingSetupTime( 120);
}

//InitializeVote ()
GameEvents.Subscribe("player_connect_full", InitializeVote); 
GameEvents.Subscribe("update_vote_result", UpdateVoteResult); 
GameEvents.Subscribe("update_vote_time", UpdateVoteTime); 
GameEvents.Subscribe("update_vote_confirmed_players", UpdateVoteConfirmedPlayers); 
GameEvents.Subscribe("vote_end", VoteEnd); 
