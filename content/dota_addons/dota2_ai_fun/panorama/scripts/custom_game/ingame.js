"use strict"; 
var Ingame={};
Ingame.bInitialized = false;

Ingame.Initialize = function() {
	var aItems = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('GridUpgradesCategory').FindChildrenWithClassTraverse('MainShopItem');
	for (i in aItems) {
		aItems[i].style.marginBottom='0px';
		aItems[i].style.marginTop='0px';
	}
	Ingame.tLoadingGameOption = CustomNetTables.GetTableValue( 'game_options', 'loading_game_options' );
	Ingame.tVoteOptionsResult = CustomNetTables.GetTableValue( 'game_options', 'vote_options_result' );
	Ingame.tInfomationTabs = {'#GameOptionIngameContainer' : true}
	for (var i in aGameOptionList) {
		if (aGameOptionList[i].type == 'dropdown') {
			$("#LoadingGameOptionContainer").BCreateChildren('<Panel id="game_option_label_container_'+aGameOptionList[i].id+'" class="GameOptionLabelContainer"/>')
			$("#game_option_label_container_"+aGameOptionList[i].id).BCreateChildren('<Label class="GameOptionKeyLabel" id="game_option_key_label_'+aGameOptionList[i].id+'"/>')
			$("#game_option_key_label_"+aGameOptionList[i].id).text=$.Localize(aGameOptionList[i].id)+$.Localize("GameOptionColon")
			$("#game_option_label_container_"+aGameOptionList[i].id).BCreateChildren('<Label class="GameOptionValueLabel" id="game_option_value_label_'+aGameOptionList[i].id+'"/>')
			if (aGameOptionList[i].id.indexOf('percentage') > 0) {
				$("#game_option_value_label_"+aGameOptionList[i].id).text=Ingame.tLoadingGameOption[aGameOptionList[i].id]+"%"
			}
			else {
				$("#game_option_value_label_"+aGameOptionList[i].id).text=Ingame.tLoadingGameOption[aGameOptionList[i].id]
			}
		}
		else if (aGameOptionList[i].type == 'toggle') {
			$("#LoadingGameOptionContainer").BCreateChildren('<Panel id="game_option_label_container_'+aGameOptionList[i].id+'" class="GameOptionLabelContainer"/>')
			$("#game_option_label_container_"+aGameOptionList[i].id).BCreateChildren('<Label class="GameOptionKeyLabel" id="game_option_key_label_'+aGameOptionList[i].id+'"/>')
			$("#game_option_key_label_"+aGameOptionList[i].id).text=$.Localize(aGameOptionList[i].id)+$.Localize("GameOptionColon")
			$("#game_option_label_container_"+aGameOptionList[i].id).BCreateChildren('<Label class="GameOptionValueLabel" id="game_option_value_label_'+aGameOptionList[i].id+'"/>')
			if (Ingame.tLoadingGameOption[aGameOptionList[i].id] == "1") {
				$("#game_option_value_label_"+aGameOptionList[i].id).text=$.Localize('GameUI_Yes')
			}
			else {
				$("#game_option_value_label_"+aGameOptionList[i].id).text=$.Localize('GameUI_No')
			}
		}
	}
	for (var i in aVoteOptions) {
			$("#VoteOptionContainer").BCreateChildren('<Panel id="game_option_label_container_vote_'+i.toString()+'" class="GameOptionLabelContainer"/>')
			$("#game_option_label_container_vote_"+i.toString()).BCreateChildren('<Label class="GameOptionKeyLabel" id="game_option_vote_key_label_'+i.toString()+'"/>')
			$("#game_option_vote_key_label_"+i.toString()).text=$.Localize(aVoteOptions[i].name)+$.Localize("GameOptionColon")		
			$("#game_option_label_container_vote_"+i.toString()).BCreateChildren('<Label class="GameOptionValueLabel" id="game_option_vote_value_label_'+i.toString()+'"/>')
			$("#game_option_vote_value_label_"+i.toString()).text=$.Localize(aVoteOptions[i].options[this.tVoteOptionsResult[aVoteOptions[i].lua_name]])
	}
	   

	if (Ingame.tLoadingGameOption && Ingame.tVoteOptionsResult)
		Ingame.bInitialized = true;
}


Ingame.OnShowGameOptionActivate = function() {
	if (!Ingame.bInitialized)
		Ingame.Initialize();
	if ($("#GameOptionIngameContainer").visible ) {
		Ingame.ChangeTabState('#GameOptionIngameContainer', false)
	}
	else {
		Ingame.ChangeTabState('#GameOptionIngameContainer', true)
	} 
} 

Ingame.ChangeTabState = function (sSelectedTabName, bOpen) {
//	$.Msg(this.tInfomationTabs,sSelectedTabName)
	for (var sTabName in this.tInfomationTabs) {
		if (sTabName == sSelectedTabName)
			$(sTabName).visible = bOpen;
		else
			$(sTabName).visible = false;
	}
}

Ingame.Initialize(); 