"use strict";
var sActivatingPanel
var sSelectingPart

var DOTA_ATTRIBUTE_STRENGTH = 0
var DOTA_ATTRIBUTE_AGILITY = 1
var DOTA_ATTRIBUTE_INTELLECT = 2

var CurrentOldLine = 1
var CurrentOldColumn = 1
var CurrentNewLine = 1
var CurrentNewColumn = 1
var bSecondInited = false
var tHeroSelectionOptions
var sLanguage = $.Language()
function InitUISecond() {

	var sAvatarDir
	var tFunHeroSelectionOptions = CustomNetTables.GetTableValue('game_options', 'vote_options_result')
	if (!tFunHeroSelectionOptions.iActivateFunHeroes)
		return;
	$("#HeroSelectionPanelOld").BCreateChildren('<Panel id="HeroAvatarButtonLineOld1" class="HeroAvatarButtonLine"/>')
	$("#HeroSelectionPanelNew").BCreateChildren('<Panel id="HeroAvatarButtonLineNew1" class="HeroAvatarButtonLine"/>')
	for (var sHeroName in tFunHeroInfo) {
		if (tFunHeroSelectionOptions.iActivateImbaFunHeroes == 0 && tFunHeroInfo[sHeroName].bImba) {continue}
		if (!Game.IsInToolsMode() && tFunHeroInfo[sHeroName].bDeveloping) {continue}
		if (tFunHeroInfo[sHeroName].bOld) {
			$("#HeroAvatarButtonLineOld"+CurrentOldLine.toString()).BCreateChildren('<Button id="HeroAvatarBtn'+tFunHeroInfo[sHeroName].sCapitalName+'" class="HeroAvatarButton" onactivate="HeroDescription(&quot;'+tFunHeroInfo[sHeroName].sCapitalName+'&quot;, true);"/>') 
			CurrentOldColumn = CurrentOldColumn+1;
			if(CurrentOldColumn>4){
				CurrentOldColumn=1;
				CurrentOldLine = CurrentOldLine+1;
				$("#HeroSelectionPanelOld").BCreateChildren('<Panel id="HeroAvatarButtonLineOld'+CurrentOldLine.toString()+'" class="HeroAvatarButtonLine"/>')
			}
		}
		else{
			$("#HeroAvatarButtonLineNew"+CurrentNewLine.toString()).BCreateChildren('<Button id="HeroAvatarBtn'+tFunHeroInfo[sHeroName].sCapitalName+'" class="HeroAvatarButton" onactivate="HeroDescription(&quot;'+tFunHeroInfo[sHeroName].sCapitalName+'&quot;, true);"/>')
			CurrentNewColumn = CurrentNewColumn+1;
			if(CurrentNewColumn>4){
				CurrentNewColumn=1;
				CurrentNewLine = CurrentNewLine+1;
				$("#HeroSelectionPanelNew").BCreateChildren('<Panel id="HeroAvatarButtonLineNew'+CurrentNewLine.toString()+'" class="HeroAvatarButtonLine"/>')
			}
		}
		
		if (tFunHeroInfo[sHeroName].bNewAvatar) {
			sAvatarDir="file://{images}/custom_game/loading_screen/npc_dota_hero_"+sHeroName+".png"
		}
		else {
			sAvatarDir="file://{images}/heroes/npc_dota_hero_"+sHeroName+".png"
		}
		$("#HeroAvatarBtn"+tFunHeroInfo[sHeroName].sCapitalName).BCreateChildren('<Image id="HeroAvatar'+tFunHeroInfo[sHeroName].sCapitalName+'" class="HeroAvatar" src="'+sAvatarDir+'"/>')
		$("#HeroAvatarBtn"+tFunHeroInfo[sHeroName].sCapitalName).BCreateChildren('<Panel id="HeroAvatarCover'+tFunHeroInfo[sHeroName].sCapitalName+'" class="HeroAvatarCover"/>')
		HeroDescriptionInit(tFunHeroInfo[sHeroName].sName, sHeroName, tFunHeroInfo[sHeroName].sCapitalName);
	}
	$("#FunHeroSelectButtonContainer").visible = true; 
	
	$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("BottomPanels").style.marginRight="570px"
}

function HeroDescriptionInit(sFunHeroName, sHeroName, sHeroNameCapital) {
	var tFunHeroAbilities = CustomNetTables.GetTableValue("fun_hero_stats", sFunHeroName+"_abilities");
	var tFunHeroStats = CustomNetTables.GetTableValue("fun_hero_stats", sFunHeroName);
	var tFunHeroScepterInfo = CustomNetTables.GetTableValue("fun_hero_stats", sFunHeroName+"_scepter_infos");
	$("#HeroDescriptionPopPanelContainer").BCreateChildren("<Panel id='HeroDescriptionPopPanel"+sHeroNameCapital+"' class = 'HeroDescriptionPopPanel' hittest='true'/>")
	var sPanelName = '#HeroDescriptionPopPanel'+sHeroNameCapital
	$(sPanelName).BCreateChildren('<Panel id="HeroNameLine'+sHeroNameCapital+'" class="HeroNameLine"/>')
	$("#HeroNameLine"+sHeroNameCapital).BCreateChildren('<Label id="HeroName'+sHeroNameCapital+'" class="HeroName" text="#npc_dota_hero_'+sHeroName+'_long"/>')
	$("#HeroNameLine"+sHeroNameCapital).BCreateChildren('<Panel id="HeroPrimaryAttribute'+sHeroNameCapital+'" class="HeroAttributeContainer"/>')
	if (tFunHeroStats.PrimaryAttribute == DOTA_ATTRIBUTE_STRENGTH) {
		$("#HeroPrimaryAttribute"+sHeroNameCapital).AddClass("HeroPrimaryAttributeStrength")
	}
	else if (tFunHeroStats.PrimaryAttribute == DOTA_ATTRIBUTE_AGILITY) {
		$("#HeroPrimaryAttribute"+sHeroNameCapital).AddClass("HeroPrimaryAttributeAgility")
	}
	else if (tFunHeroStats.PrimaryAttribute == DOTA_ATTRIBUTE_INTELLECT) {
		$("#HeroPrimaryAttribute"+sHeroNameCapital).AddClass("HeroPrimaryAttributeIntelligence")
	}
	else {
		$("#HeroPrimaryAttribute"+sHeroNameCapital).visible = false
	}
	
	
	$(sPanelName).BCreateChildren('<Label id="HeroBio'+sHeroNameCapital+'" class="HeroBio" text="#npc_dota_hero_'+sHeroName+'_bio"/>')	
	var aTalents = [];
	if (tFunHeroAbilities) {
		$(sPanelName).BCreateChildren('<Label class="HeroAbilityTitle" text="#DOTA_SHOP_CATEGORY_ABILITIES"/>')
		$(sPanelName).BCreateChildren('<Panel id="HeroAbilityContainer'+sHeroNameCapital+'" class="AbilityLine"/>')
		for (var i = 1; i < 24; i++) {
			if (tFunHeroAbilities[i.toString()]){
				if(tFunHeroAbilities[i.toString()].search("special_bonus") < 0 ){
					if (tFunHeroAbilities[i.toString()].search("generic_hidden") < 0) {
		//				$("#HeroAbilityContainer"+sHeroNameCapital).BCreateChildren('<DOTAAbilityImage id="Ability'+sHeroNameCapital+i.toString()+'" class="AbilityIcon" abilityname="'+tFunHeroAbilities[i.toString()]+'" onmouseover="DOTAShowAbilityTooltip('+tFunHeroAbilities[i.toString()]+')" onmouseout="DOTAHideAbilityTooltip()"/>')
						$("#HeroAbilityContainer"+sHeroNameCapital).BCreateChildren('<Panel id="AbilityIconContainer'+sHeroNameCapital+i.toString()+'" class="AbilityIconContainer"/>')
						$("#AbilityIconContainer"+sHeroNameCapital+i.toString()).BCreateChildren('<DOTAAbilityImage id="Ability'+sHeroNameCapital+i.toString()+'" class="AbilityIcon" abilityname="'+tFunHeroAbilities[i.toString()]+'" onmouseover="DOTAShowAbilityTooltip('+tFunHeroAbilities[i.toString()]+')" onmouseout="DOTAHideAbilityTooltip()"/>')
					}
				}
				else
				{
					aTalents.unshift(tFunHeroAbilities[i.toString()])
				}
			}
		} 
	}
//	$("#HeroAbilityContainer"+sHeroNameCapital).BCreateChildren('<Panel id="Talent'+sHeroNameCapital+'" class="TalentBranch"/>')
	
	if (tFunHeroScepterInfo){ 
		$(sPanelName).BCreateChildren('<Panel class="HeroScepterInfoContainer" id="HeroScepterInfoContainer'+sHeroNameCapital+'"/>')
		var i = 1
		while (tFunHeroScepterInfo[i.toString()]) {
			$("#HeroScepterInfoContainer"+sHeroNameCapital).BCreateChildren('<Panel class="HeroScepterAbilityContainer" id="HeroScepterAbilityContainer'+sHeroNameCapital+i.toString()+'"/>')
			$("#HeroScepterAbilityContainer"+sHeroNameCapital+i.toString()).BCreateChildren('<Panel class="HeroScepterAbilityTitleContainer" id="HeroScepterAbilityTitleContainer'+sHeroNameCapital+i.toString()+'"/>')
			
			var sAbilityName = $.Localize("#DOTA_Tooltip_Ability_"+tFunHeroScepterInfo[i.toString()].sAbilityName).toUpperCase()
			$("#HeroScepterAbilityTitleContainer"+sHeroNameCapital+i.toString()).BCreateChildren('<Label class="HeroScepterAbilityTitleUpgrade" id="HeroScepterAbilityTitleUpgrade'+sHeroNameCapital+i.toString()+'" text="#scepter_info_title"/>')
			$("#HeroScepterAbilityTitleContainer"+sHeroNameCapital+i.toString()).BCreateChildren('<Label class="HeroScepterAbilityTitleName" id="HeroScepterAbilityTitleName'+sHeroNameCapital+i.toString()+'" text="'+sAbilityName+'"/>')
			$("#HeroScepterAbilityContainer"+sHeroNameCapital+i.toString()).BCreateChildren('<Label class="HeroScepterAbilityDescription" id="HeroScepterAbilityDescription'+sHeroNameCapital+i.toString()+'" text="#DOTA_Tooltip_Ability_'+tFunHeroScepterInfo[i.toString()].sAbilityName+'_aghanim_description"/>')
			i=i+1
		}
	}
	
	if (aTalents.length) {
		$(sPanelName).BCreateChildren('<Panel class="HeroTalentContainer" id="HeroTalentContainer'+sHeroNameCapital+'"/>')
	//	$("#Talent"+sHeroNameCapital).SetPanelEvent("onmouseover", function (){$("#HeroTalentContainer"+sHeroNameCapital).visible=true})
	//	$("#Talent"+sHeroNameCapital).SetPanelEvent("onmouseout", function (){$("#HeroTalentContainer"+sHeroNameCapital).visible=false})
		
		$("#HeroTalentContainer"+sHeroNameCapital).BCreateChildren('<Label class="HeroTalentTitle" text="#DOTA_AbilityBuild_Talent_Title"/>')
		var iTalent = 0
		for (var iLevel = 25; iLevel > 5; iLevel=iLevel-5) {
			$("#HeroTalentContainer"+sHeroNameCapital).BCreateChildren('<Panel class="HeroTalentLine" id="HeroTalentLine'+sHeroNameCapital+iLevel.toString()+'"/>')
			
			$("#HeroTalentLine"+sHeroNameCapital+iLevel.toString()).BCreateChildren('<Panel class="HeroTalentLeft" id="HeroTalentLeft'+sHeroNameCapital+iLevel.toString()+'"/>')
			$("#HeroTalentLeft"+sHeroNameCapital+iLevel.toString()).BCreateChildren('<Label class="HeroTalentContentLabel" text="#DOTA_Tooltip_ability_'+aTalents[iTalent++]+'"/>')		
			$("#HeroTalentLine"+sHeroNameCapital+iLevel.toString()).BCreateChildren('<Panel class="HeroTalentMiddle" id="HeroTalentMiddle'+sHeroNameCapital+iLevel.toString()+'"/>')
			$("#HeroTalentMiddle"+sHeroNameCapital+iLevel.toString()).BCreateChildren('<Label class="HeroTalentReqLabel" text="'+iLevel.toString()+'"/>')
			$("#HeroTalentLine"+sHeroNameCapital+iLevel.toString()).BCreateChildren('<Panel class="HeroTalentRight" id="HeroTalentRight'+sHeroNameCapital+iLevel.toString()+'"/>')
			$("#HeroTalentRight"+sHeroNameCapital+iLevel.toString()).BCreateChildren('<Label class="HeroTalentContentLabel" text="#DOTA_Tooltip_ability_'+aTalents[iTalent++]+'"/>')		
		}	
	}
	$(sPanelName).BCreateChildren('<Button id="HeroSelection'+sHeroNameCapital+'" class="HeroSelectionButton" onactivate="HeroSelection(&quot;npc_dota_hero_'+sHeroName+'&quot;, &quot;'+sHeroNameCapital+'&quot;);"/>')
	$("#HeroSelection"+sHeroNameCapital).BCreateChildren('<Label id="HeroSelectionLabel" text="#select_hero"/>')
	if (sHeroNameCapital == 'Invoker') {
		$(sPanelName).BCreateChildren('<Button id="EnableWearable'+sHeroNameCapital+'" class="HeroSelectionButton" onactivate="EnableWearable(&quot;npc_dota_hero_'+sHeroName+'&quot;, &quot;'+sHeroNameCapital+'&quot;);" onmouseover="DOTAShowTextTooltip(#InvokerRetroChangeWearable_enable_tooltip)" onmouseout="DOTAHideTextTooltip()"/>')
		$("#EnableWearable"+sHeroNameCapital).BCreateChildren('<Label text="#InvokerRetroChangeWearable_enable"/>')
		$("#EnableWearable"+sHeroNameCapital).visible = true
		$(sPanelName).BCreateChildren('<Button id="DisableWearable'+sHeroNameCapital+'" class="HeroUnselectionButton" onactivate="DisableWearable(&quot;npc_dota_hero_'+sHeroName+'&quot;, &quot;'+sHeroNameCapital+'&quot;);"/>')
		$("#DisableWearable"+sHeroNameCapital).BCreateChildren('<Label text="#InvokerRetroChangeWearable_disable" />')
	}
}

function EnableWearable(sHeroName, sHeroPart) {
	$("#EnableWearable"+sHeroPart).visible = false
	$("#DisableWearable"+sHeroPart).visible = true
	GameEvents.SendCustomGameEventToServer("enable_wearables_change", {
		"hero_name": sHeroName,
		"player_id": Players.GetLocalPlayer(),
	})
}

function DisableWearable(sHeroName, sHeroPart) {
	$("#EnableWearable"+sHeroPart).visible = true
	$("#DisableWearable"+sHeroPart).visible = false
	GameEvents.SendCustomGameEventToServer("disable_wearables_change", {
		"hero_name": sHeroName,
		"player_id": Players.GetLocalPlayer(),
	})
}


function HeroDescription(sPanelIDSuffix, bEmitSound){ 
	var hPanel = $("#HeroDescriptionPopPanel"+sPanelIDSuffix) 
	var hContainer = $("#HeroDescriptionPopPanelContainer")
	var aCursorPosition = GameUI.GetCursorPosition();
	if (hPanel.visible) {
		hPanel.visible = false;
		hContainer.visible = false;
		sActivatingPanel = null;
		if(bEmitSound) {
			Game.EmitSound('ui_team_select_cancel_and_lock')
		}
		if ($("#HeroAvatarBtn"+sPanelIDSuffix)) {
			$("#HeroAvatarBtn"+sPanelIDSuffix).RemoveClass('HeroAvatarButtonActive')
		}
	}
	else {
		if (sActivatingPanel)
			HeroDescription(sActivatingPanel, false);
		hPanel.visible = true;
		hContainer.visible = true;
		sActivatingPanel = sPanelIDSuffix;
		Game.EmitSound('ui_team_select_lock_and_start')
		if ($("#HeroAvatarBtn"+sPanelIDSuffix)) {
			$("#HeroAvatarBtn"+sPanelIDSuffix).AddClass('HeroAvatarButtonActive')
		}
	}
}
function HideHeroSelection() {
	if ( $('#HeroSelectionContainer').visible == true ) {
		OnFunHeroSelectButtonActivated()
	}
	$("#FunHeroSelectButtonContainer").visible = false
}

function OnFunHeroSelectButtonActivated() {
	if ( $('#HeroSelectionContainer').visible == true ) {
		$('#HeroSelectionContainer').visible = false;
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("MainHeroPickScreenContents").visible=true
		$('#HeroSelectionBlocker').visible = false;
		$('#FunHeroSelectButtonLabel').text=$.Localize('select_fun_hero')
		Game.EmitSound('ui_team_select_cancel_and_lock')
		if (sActivatingPanel)
			HeroDescription(sActivatingPanel, false);
	}
	else {
		$('#HeroSelectionContainer').visible = true;
		$('#HeroSelectionBlocker').visible = true;
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("MainHeroPickScreenContents").visible=false
		Game.EmitSound('ui_team_select_lock_and_start')
		$('#FunHeroSelectButtonLabel').text=$.Localize('select_ordinary_hero')
	}
}


function OnFunHeroRandomButtonActivated() {
	var aHeros = []
	HideHeroSelection()
	for (var s in tFunHeroInfo) 
		aHeros.push(s)
	var sHeroName = aHeros[Math.floor(Math.random()*aHeros.length)]
	GameEvents.SendCustomGameEventToServer("fun_hero_selection", {
		"hero_name": 'npc_dota_hero_'+sHeroName,
		"player_id": Players.GetLocalPlayer(),
		"language": sLanguage,
		"random": true,
	})
}

function HeroSelection(sHeroName, sHeroPart) {
	HideHeroSelection()
	GameEvents.SendCustomGameEventToServer("fun_hero_selection", {
		"hero_name": sHeroName,
		"player_id": Players.GetLocalPlayer(),
		"language": sLanguage
	})
}

function HeroUnselection(sHeroName, sHeroPart) {
	GameEvents.SendCustomGameEventToServer("fun_hero_unselection", {
		"hero_name": sHeroName,
		"player_id": Players.GetLocalPlayer()
	})
	$("#HeroSelection"+sSelectingPart).style.visibility = 'visible';
	$("#HeroUnselection"+sSelectingPart).style.visibility = 'collapse';
	$("#HeroAvatarCover"+sSelectingPart).style.visibility = 'collapse';
	sSelectingPart = null;
	if (sHeroPart=='Invoker') {
		DisableWearable(sHeroName, sHeroPart)
		$("#EnableWearable"+sHeroPart).visible = false
	}
}
function SelectOldHeroesActivate(){
	$("#HeroTypeSelectionBtnOld").hittest=false;
	$("#HeroTypeSelectionBtnOld").AddClass("HeroTypeSelectionBtnActivated");
	$("#HeroTypeSelectionBtnLabelOld").AddClass("fontcolorwhite2");
	$("#HeroSelectionPanelOld").visible=true;
	$("#HeroTypeSelectionBtnNew").hittest=true;
	$("#HeroTypeSelectionBtnNew").RemoveClass("HeroTypeSelectionBtnActivated");
	$("#HeroTypeSelectionBtnLabelNew").RemoveClass("fontcolorwhite2");
	$("#HeroSelectionPanelNew").visible=false;
}
function SelectNewHeroesActivate(){
	$("#HeroTypeSelectionBtnNew").hittest=false;
	$("#HeroTypeSelectionBtnNew").AddClass("HeroTypeSelectionBtnActivated");
	$("#HeroTypeSelectionBtnLabelNew").AddClass("fontcolorwhite2");
	$("#HeroSelectionPanelNew").visible=true;
	$("#HeroTypeSelectionBtnOld").hittest=true;
	$("#HeroTypeSelectionBtnOld").RemoveClass("HeroTypeSelectionBtnActivated");
	$("#HeroTypeSelectionBtnLabelOld").RemoveClass("fontcolorwhite2");
	$("#HeroSelectionPanelOld").visible=false;
}

function ShowGameOption() {
	if (sActivatingPanel)
		HeroDescription(sActivatingPanel, false);
	$("#ShowGameOptionButton").visible=false;
	$("#HideGameOptionButton").visible=true;
	$("#game_options_container").visible=true;
	Game.EmitSound('ui_team_select_lock_and_start')
}

function HideGameOption(bEmitSound) {
	$("#ShowGameOptionButton").visible=true;
	$("#HideGameOptionButton").visible=false;
	$("#game_options_container").visible=false;
	if(bEmitSound){
		Game.EmitSound('ui_team_select_cancel_and_lock')
	}
}

function BestWorstStatsSelectionOptionsBtnActivate() {
	Game.EmitSound('ui_team_select_lock_and_start')
	$("#HeroSelectionPanelContainer").visible=false;
	GameEvents.SendCustomGameEventToServer( "net_table_change_value", { "table_name" : "game_options", "table_key" : "selection_options", "table_value":{"best_worst_stats":true} } );
	GameEvents.SendCustomGameEventToAllClients("host_set_hero_selection_option", {"best_worst_stats":true})
	$('#radiant_player_number_dropdown').SetSelected('0')
	$('#dire_player_number_dropdown').SetSelected('0')
	$('#bot_has_fun_item').SetSelected(false)
	$('#ban_fun_items').SetSelected(true)
}

function SelectBestStatsActivated() { 
	$('#SelectBestStatsButton').AddClass('HeroTypeSelectionBtnActivated')
	$('#SelectWorstStatsButton').RemoveClass('HeroTypeSelectionBtnActivated')
	GameEvents.SendCustomGameEventToServer("fun_hero_selection", {
		"hero_name": 'npc_dota_hero_monkey_king',
		"player_id": Players.GetLocalPlayer(),
		"language": sLanguage
	})
}

function SelectWorstStatsActivated() {
	GameEvents.SendCustomGameEventToServer("fun_hero_selection", {
		"hero_name": 'npc_dota_hero_troll_warlord',
		"player_id": Players.GetLocalPlayer(),
		"language": sLanguage
	})
	$('#SelectBestStatsButton').RemoveClass('HeroTypeSelectionBtnActivated')
	$('#SelectWorstStatsButton').AddClass('HeroTypeSelectionBtnActivated')
}

InitUISecond()