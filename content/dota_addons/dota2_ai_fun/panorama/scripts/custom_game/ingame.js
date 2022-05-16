"use strict"; 
var Ingame={};
Ingame.bInitialized = false; 

Ingame.Initialize = function() {
	Ingame.tLoadingGameOption = CustomNetTables.GetTableValue( 'game_options', 'loading_game_options' );
	Ingame.tVoteOptionsResult = CustomNetTables.GetTableValue( 'game_options', 'vote_options_result' );
//	$.Msg(Ingame.tLoadingGameOption)
	
	if (!(Ingame.tLoadingGameOption.enable_lottery)) {
		var aMainShopItems = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('GridBasicItemsCategory').FindChildrenWithClassTraverse('MainShopItem');
		for (i in aMainShopItems) {
			if (aMainShopItems[i].FindChild('ItemImage').itemname.search('lottery') >= 0)
				aMainShopItems[i].visible=false
		}
	}
	if (!(Ingame.tLoadingGameOption.passive_skill_book)) {
		var aMainShopItems = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('GridBasicItemsCategory').FindChildrenWithClassTraverse('MainShopItem');
		for (i in aMainShopItems) {
			if (aMainShopItems[i].FindChild('ItemImage').itemname.search('passive_skill_book') >= 0)
				aMainShopItems[i].visible=false
		}
	}
	if (this.tVoteOptionsResult.iBanFunItems == 1) {
		var aMainShopItems = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('GridUpgradesCategory').FindChildrenWithClassTraverse('MainShopItem');
		for (i in aMainShopItems) {
			if (aMainShopItems[i].FindChild('ItemImage').itemname.search('_fun_') >= 0)
				aMainShopItems[i].visible=false
		}
	}
	else {
		var aUpgradeItems = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('GridUpgradesCategory').FindChildrenWithClassTraverse('MainShopItem');
		for (i in aUpgradeItems) {
			aUpgradeItems[i].style.marginBottom='0px';
			aUpgradeItems[i].style.marginTop='0px';
		}
	}





	Ingame.tInfomationTabs = {'#GameOptionIngameContainer' : true}
	for (var i in aGameOptionList) {
		for (var j in aGameOptionList[i]) {
			if (aGameOptionList[i][j].type == 'dropdown') {
				$.CreatePanelWithProperties('Panel', $("#LoadingGameOptionContainer"), "game_option_label_container_"+aGameOptionList[i][j].id,{id:"game_option_label_container_"+aGameOptionList[i][j].id, class:"GameOptionLabelContainer"})
				$.CreatePanelWithProperties('Label', $("#game_option_label_container_"+aGameOptionList[i][j].id), "game_option_key_label_"+aGameOptionList[i][j].id,{class:"GameOptionKeyLabel", id:"game_option_key_label_"+aGameOptionList[i][j].id})
				$("#game_option_key_label_"+aGameOptionList[i][j].id).text=$.Localize(aGameOptionList[i][j].id)+$.Localize("GameOptionColon")
				$.CreatePanelWithProperties('Label', $("#game_option_label_container_"+aGameOptionList[i][j].id), "game_option_value_label_"+aGameOptionList[i][j].id,{class:"GameOptionValueLabel", id:"game_option_value_label_"+aGameOptionList[i][j].id})
				if (aGameOptionList[i][j].id.indexOf('percentage') > 0) {
					$("#game_option_value_label_"+aGameOptionList[i][j].id).text=Ingame.tLoadingGameOption[aGameOptionList[i][j].id]+"%"
				}
				else {
					$("#game_option_value_label_"+aGameOptionList[i][j].id).text=Ingame.tLoadingGameOption[aGameOptionList[i][j].id]
				}
			}
			else if (aGameOptionList[i][j].type == 'toggle') {
				$.CreatePanelWithProperties('Panel', $("#LoadingGameOptionContainer"), "game_option_label_container_"+aGameOptionList[i][j].id,{id:"game_option_label_container_"+aGameOptionList[i][j].id, class:"GameOptionLabelContainer"})
				$.CreatePanelWithProperties('Label', $("#game_option_label_container_"+aGameOptionList[i][j].id), "game_option_key_label_"+aGameOptionList[i][j].id,{class:"GameOptionKeyLabel", id:"game_option_key_label_"+aGameOptionList[i][j].id})
				$("#game_option_key_label_"+aGameOptionList[i][j].id).text=$.Localize(aGameOptionList[i][j].id)+$.Localize("GameOptionColon")
				$.CreatePanelWithProperties('Label', $("#game_option_label_container_"+aGameOptionList[i][j].id), "game_option_value_label_"+aGameOptionList[i][j].id,{class:"GameOptionValueLabel", id:"game_option_value_label_"+aGameOptionList[i][j].id})
				if (Ingame.tLoadingGameOption[aGameOptionList[i][j].id] == "1") {
					$("#game_option_value_label_"+aGameOptionList[i][j].id).text=$.Localize('GameUI_Yes')
				}
				else {
					$("#game_option_value_label_"+aGameOptionList[i][j].id).text=$.Localize('GameUI_No')
				}
			}
		}
	}
	for (var i in aVoteOptions) {
			$.CreatePanelWithProperties('Panel', $("#VoteOptionContainer"), "game_option_label_container_vote_"+i.toString(),{id:"game_option_label_container_vote_"+i.toString(), class:"GameOptionLabelContainer"})
			$.CreatePanelWithProperties('Label', $("#game_option_label_container_vote_"+i.toString()), "game_option_vote_key_label_"+i.toString(),{class:"GameOptionKeyLabel", id:"game_option_vote_key_label_"+i.toString()})
			$("#game_option_vote_key_label_"+i.toString()).text=$.Localize(aVoteOptions[i].name)+$.Localize("GameOptionColon")		
			$.CreatePanelWithProperties('Label', $("#game_option_label_container_vote_"+i.toString()), "game_option_vote_value_label_"+i.toString(),{class:"GameOptionValueLabel", id:"game_option_vote_value_label_"+i.toString()})
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
function Testf(keys) {
	$.Msg(keys)
}
//		GameEvents.Subscribe( "item_preview_closed", Testf);

Ingame.Initialize();
var t=Game.GetLocalPlayerInfo()