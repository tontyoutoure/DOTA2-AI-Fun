"use strict"; 

var aSelfVote = [
	{self_vote:1},
	{self_vote:1},
//	{self_vote:3},
	{self_vote:0},	
]
var iPlayerCount
var bLockHided
function InitializeVote () {
	for (var i=0;i < aVoteOptions.length;i++) {
		$('#VoteListContainer').BCreateChildren('<Panel id="SingleVote'+i.toString()+'" class="SingleVoteContainer"/>')
		
		if (aVoteOptions[i].tooltip) {			
			$('#SingleVote'+i.toString()).BCreateChildren('<Panel class="SingleVoteTitleContainer" id="SingleVoteTitleContainer'+i.toString()+'" onmouseover="DOTAShowTextTooltip('+aVoteOptions[i].tooltip+');" onmouseout="DOTAHideTextTooltip();"/>')
		}
		else {
			$('#SingleVote'+i.toString()).BCreateChildren('<Panel class="SingleVoteTitleContainer" id="SingleVoteTitleContainer'+i.toString()+'"/>')
		}
		$('#SingleVoteTitleContainer'+i.toString()).BCreateChildren('<Label text="'+aVoteOptions[i].name+'"/>')
		for (var j = 0; j < aVoteOptions[i].options.length; j++) {			
			if (aVoteOptions[i].tooltip) {
				$('#SingleVote'+i.toString()).BCreateChildren('<Button class="VoteOptionContainer" id="VoteOptionContainer'+i.toString()+'_'+j.toString()+'" onmouseover="DOTAShowTextTooltip('+aVoteOptions[i].tooltip+');" onmouseout="DOTAHideTextTooltip();"/>');
			}
			else {
				$('#SingleVote'+i.toString()).BCreateChildren('<Button class="VoteOptionContainer" id="VoteOptionContainer'+i.toString()+'_'+j.toString()+'"/>');
			}
			$('#VoteOptionContainer'+i.toString()+'_'+j.toString()).vote_index = i
			$('#VoteOptionContainer'+i.toString()+'_'+j.toString()).choice_index = j
			$.RegisterEventHandler('Activated', $('#VoteOptionContainer'+i.toString()+'_'+j.toString()), OnVoteActivated)
			$('#VoteOptionContainer'+i.toString()+'_'+j.toString()).BCreateChildren('<Panel class="VoteOptionChoiceContainer" id="VoteOptionChoiceContainer'+i.toString()+'_'+j.toString()+'"/>')
			$('#VoteOptionChoiceContainer'+i.toString()+'_'+j.toString()).BCreateChildren('<Label id="VoteOptionChoice'+i.toString()+'_'+j.toString()+'" text=""/>')
			$('#VoteOptionContainer'+i.toString()+'_'+j.toString()).BCreateChildren('<Panel class="VoteOptionTitleContainer" id="VoteOptionTitleContainer'+i.toString()+'_'+j.toString()+'"/>')
			$('#VoteOptionTitleContainer'+i.toString()+'_'+j.toString()).BCreateChildren('<Label text="'+aVoteOptions[i].options[j]+'"/>')
			
			
			$('#VoteOptionContainer'+i.toString()+'_'+j.toString()).BCreateChildren('<Panel class="VoteOptionCounterContainer" id="VoteOptionCounterContainer'+i.toString()+'_'+j.toString()+'"/>')
			$('#VoteOptionCounterContainer'+i.toString()+'_'+j.toString()).BCreateChildren('<Label id="VoteCounter'+i.toString()+'_'+j.toString()+'" text="0"/>')
		}		
	}
	for (var i=0;i < aVoteOptions.length;i++) {
		MakeVote(i, aSelfVote[i].self_vote, true)
	}
	$('#VoteContainer').visible = true;
}

function OnVoteActivated(hPanel, fCallback) {
	MakeVote(hPanel.vote_index, hPanel.choice_index)
}
function MakeVote(vote_index, choice_index, bSilent) {
	GameEvents.SendCustomGameEventToServer("vote_make_choice", {vote_index:vote_index, choice_index:choice_index})
	if (!bSilent)
		Game.EmitSound('ui_team_select_lock_and_start');
	if (aSelfVote[vote_index] >= 0) {
		$('#VoteOptionChoice'+vote_index.toString()+'_'+aSelfVote[vote_index].toString()).text = '';
		$.Msg(vote_index,choice_index)
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
		if (tVoteResult[i.toString()]) {
			for (var j = 0; j < aVoteOptions[i].options.length; j++) {
				if (tVoteResult[i.toString()][j.toString()] || tVoteResult[i.toString()][j.toString()]===0) {
					$('#VoteCounter'+i.toString()+'_'+j.toString()).text = tVoteResult[i.toString()][j.toString()];
				}
			}
		}
	}
	GameEvents.SendCustomGameEventToAllClients("loading_vote_full", {})
}

function OnVoteConfirm() {
	iPlayerCount = GetPlayerCount()
	$('#VoteBlocker').visible = true
	$('#VoteConfirmButtonContainer').visible = false
	GameEvents.SendCustomGameEventToServer("vote_confirm", {iPlayerCount:iPlayerCount})
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
	
	$("#bot_has_fun_item").checked=true;  
	$("#fast_courier").checked=true;  
	if (Game.GetLocalPlayerInfo() === undefined) {
		$.Schedule(1, InitializeUI);
		return;
	} else if (Game.GetLocalPlayerInfo().player_has_host_privileges) {
		$("#game_options_container").visible=true;
		$("#GameOptionHider").visible=false;
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
	Game.SetRemainingSetupTime( 120 )
}

//InitializeVote ()
GameEvents.Subscribe("player_connect_full", InitializeVote); 
GameEvents.Subscribe("update_vote_result", UpdateVoteResult); 
GameEvents.Subscribe("update_vote_time", UpdateVoteTime); 
GameEvents.Subscribe("update_vote_confirmed_players", UpdateVoteConfirmedPlayers); 
GameEvents.Subscribe("vote_end", VoteEnd); 
