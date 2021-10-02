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
	$.CreatePanelWithProperties('Panel', $("#HeroSelectionPanelOld"), "HeroAvatarButtonLineOld1",{id:"HeroAvatarButtonLineOld1", class:"HeroAvatarButtonLine"})
	$.CreatePanelWithProperties('Panel', $("#HeroSelectionPanelNew"), "HeroAvatarButtonLineNew1",{id:"HeroAvatarButtonLineNew1", class:"HeroAvatarButtonLine"})
	for (var sHeroName in tFunHeroInfo) {
		if (tFunHeroSelectionOptions.iActivateImbaFunHeroes == 0 && tFunHeroInfo[sHeroName].bImba) {continue}
		if (!Game.IsInToolsMode() && tFunHeroInfo[sHeroName].bDeveloping) {continue}
		if (tFunHeroInfo[sHeroName].bOld) {
			$.CreatePanelWithProperties('Button', $("#HeroAvatarButtonLineOld"+CurrentOldLine.toString()), "HeroAvatarBtn"+tFunHeroInfo[sHeroName].sCapitalName,{id:"HeroAvatarBtn"+tFunHeroInfo[sHeroName].sCapitalName, class:"HeroAvatarButton", onactivate:"HeroDescription(&quot;"+tFunHeroInfo[sHeroName].sCapitalName+"&quot;, true);"});
			CurrentOldColumn = CurrentOldColumn+1;
			if(CurrentOldColumn>4){
				CurrentOldColumn=1;
				CurrentOldLine = CurrentOldLine+1;
				$.CreatePanelWithProperties('Panel', $("#HeroSelectionPanelOld"), "HeroAvatarButtonLineOld"+CurrentOldLine.toString(),{id:"HeroAvatarButtonLineOld"+CurrentOldLine.toString(), class:"HeroAvatarButtonLine"})
			}
		}
		else{
			$.CreatePanelWithProperties('Button', $("#HeroAvatarButtonLineNew"+CurrentNewLine.toString()), "HeroAvatarBtn"+tFunHeroInfo[sHeroName].sCapitalName,{id:"HeroAvatarBtn"+tFunHeroInfo[sHeroName].sCapitalName, class:"HeroAvatarButton", onactivate:"HeroDescription(&quot;"+tFunHeroInfo[sHeroName].sCapitalName+"&quot;, true);"});
			CurrentNewColumn = CurrentNewColumn+1;
			if(CurrentNewColumn>4){
				CurrentNewColumn=1;
				CurrentNewLine = CurrentNewLine+1;
				$.CreatePanelWithProperties('Panel', $("#HeroSelectionPanelNew"), "HeroAvatarButtonLineNew"+CurrentNewLine.toString(),{id:"HeroAvatarButtonLineNew"+CurrentNewLine.toString(), class:"HeroAvatarButtonLine"})
			}
		}
		
		if (tFunHeroInfo[sHeroName].bNewAvatar) {
			sAvatarDir="file://{images}/custom_game/loading_screen/npc_dota_hero_"+sHeroName+".png"
		}
		else {
			sAvatarDir="file://{images}/heroes/npc_dota_hero_"+sHeroName+".png"
		}
		$.CreatePanelWithProperties('Image', $("#HeroAvatarBtn"+tFunHeroInfo[sHeroName].sCapitalName), "HeroAvatar"+tFunHeroInfo[sHeroName].sCapitalName,{id:"HeroAvatar"+tFunHeroInfo[sHeroName].sCapitalName, class:"HeroAvatar", src:sAvatarDir})
		$.CreatePanelWithProperties('Panel', $("#HeroAvatarBtn"+tFunHeroInfo[sHeroName].sCapitalName), "HeroAvatarCover"+tFunHeroInfo[sHeroName].sCapitalName,{id:"HeroAvatarCover"+tFunHeroInfo[sHeroName].sCapitalName, class:"HeroAvatarCover"})
		HeroDescriptionInit(tFunHeroInfo[sHeroName].sName, sHeroName, tFunHeroInfo[sHeroName].sCapitalName);
	}
	$("#FunHeroSelectButtonContainer").visible = true; 
	
	$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("BottomPanels").style.marginRight="570px"
}

function HeroDescriptionInit(sFunHeroName, sHeroName, sHeroNameCapital) {
	var tFunHeroAbilities = CustomNetTables.GetTableValue("fun_hero_stats", sFunHeroName+"_abilities");
	var tFunHeroStats = CustomNetTables.GetTableValue("fun_hero_stats", sFunHeroName);
	var tFunHeroScepterInfo = CustomNetTables.GetTableValue("fun_hero_stats", sFunHeroName+"_scepter_infos");
	$.CreatePanelWithProperties('Panel', $("#HeroDescriptionPopPanelContainer"), "HeroDescriptionPopPanel"+sHeroNameCapital,{id:"HeroDescriptionPopPanel"+sHeroNameCapital, class:'HeroDescriptionPopPanel', hittest:'true'})
	var sPanelName = '#HeroDescriptionPopPanel'+sHeroNameCapital
	$.CreatePanelWithProperties('Panel', $(sPanelName), "HeroNameLine"+sHeroNameCapital,{id:"HeroNameLine"+sHeroNameCapital, class:"HeroNameLine"})
	$.CreatePanelWithProperties('Label', $("#HeroNameLine"+sHeroNameCapital), "HeroName"+sHeroNameCapital,{id:"HeroName"+sHeroNameCapital, class:"HeroName", text:"#npc_dota_hero_"+sHeroName+"_long"})
	$.CreatePanelWithProperties('Panel', $("#HeroNameLine"+sHeroNameCapital), "HeroPrimaryAttribute"+sHeroNameCapital,{id:"HeroPrimaryAttribute"+sHeroNameCapital, class:"HeroAttributeContainer"})
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
	
	
	$.CreatePanelWithProperties('Label', $(sPanelName), "HeroBio"+sHeroNameCapital,{id:"HeroBio"+sHeroNameCapital, class:"HeroBio", text:"#npc_dota_hero_"+sHeroName+"_bio"})
	var aTalents = [];
	if (tFunHeroAbilities) {
		$.CreatePanelWithProperties('Label', $(sPanelName), '',{class:"HeroAbilityTitle", text:"#DOTA_SHOP_CATEGORY_ABILITIES"})
		$.CreatePanelWithProperties('Panel', $(sPanelName), "HeroAbilityContainer"+sHeroNameCapital,{id:"HeroAbilityContainer"+sHeroNameCapital, class:"AbilityLine"})
		for (var i = 1; i < 24; i++) {
			if (tFunHeroAbilities[i.toString()]){
				if(tFunHeroAbilities[i.toString()].search("special_bonus") < 0 ){
					if (tFunHeroAbilities[i.toString()].search("generic_hidden") < 0) {
						$.CreatePanelWithProperties('DOTAAbilityImage', $("#HeroAbilityContainer"+sHeroNameCapital), "Ability"+sHeroNameCapital+i.toString(),{id:"Ability"+sHeroNameCapital+i.toString(), class:"AbilityIcon", abilityname:tFunHeroAbilities[i.toString()], onmouseover:"DOTAShowAbilityTooltip("+tFunHeroAbilities[i.toString()]+")", onmouseout:"DOTAHideAbilityTooltip()"})
						$.CreatePanelWithProperties('Panel', $("#HeroAbilityContainer"+sHeroNameCapital), "AbilityIconContainer"+sHeroNameCapital+i.toString(),{id:"AbilityIconContainer"+sHeroNameCapital+i.toString(), class:"AbilityIconContainer"})
						$.CreatePanelWithProperties('DOTAAbilityImage', $("#AbilityIconContainer"+sHeroNameCapital+i.toString()), "Ability"+sHeroNameCapital+i.toString(),{id:"Ability"+sHeroNameCapital+i.toString(), class:"AbilityIcon", abilityname:tFunHeroAbilities[i.toString()], onmouseover:"DOTAShowAbilityTooltip("+tFunHeroAbilities[i.toString()]+")", onmouseout:"DOTAHideAbilityTooltip()"})
					}
				}
				else
				{
					aTalents.unshift(tFunHeroAbilities[i.toString()])
				}
			}
		} 
	}
	$.CreatePanelWithProperties('Panel', $("#HeroAbilityContainer"+sHeroNameCapital), "Talent"+sHeroNameCapital,{id:"Talent"+sHeroNameCapital, class:"TalentBranch"})
	
	if (tFunHeroScepterInfo){ 
		$.CreatePanelWithProperties('Panel', $(sPanelName), "HeroScepterInfoContainer"+sHeroNameCapital,{class:"HeroScepterInfoContainer", id:"HeroScepterInfoContainer"+sHeroNameCapital})
		var i = 1
		while (tFunHeroScepterInfo[i.toString()]) {
			$.CreatePanelWithProperties('Panel', $("#HeroScepterInfoContainer"+sHeroNameCapital), "HeroScepterAbilityContainer"+sHeroNameCapital+i.toString(),{class:"HeroScepterAbilityContainer", id:"HeroScepterAbilityContainer"+sHeroNameCapital+i.toString()})
			$.CreatePanelWithProperties('Panel', $("#HeroScepterAbilityContainer"+sHeroNameCapital+i.toString()), "HeroScepterAbilityTitleContainer"+sHeroNameCapital+i.toString(),{class:"HeroScepterAbilityTitleContainer", id:"HeroScepterAbilityTitleContainer"+sHeroNameCapital+i.toString()})
			
			var sAbilityName = $.Localize("#DOTA_Tooltip_Ability_"+tFunHeroScepterInfo[i.toString()].sAbilityName).toUpperCase()
			$.CreatePanelWithProperties('Label', $("#HeroScepterAbilityTitleContainer"+sHeroNameCapital+i.toString()), "HeroScepterAbilityTitleUpgrade"+sHeroNameCapital+i.toString(),{class:"HeroScepterAbilityTitleUpgrade", id:"HeroScepterAbilityTitleUpgrade"+sHeroNameCapital+i.toString(), text:"#scepter_info_title"})
			$.CreatePanelWithProperties('Label', $("#HeroScepterAbilityTitleContainer"+sHeroNameCapital+i.toString()), "HeroScepterAbilityTitleName"+sHeroNameCapital+i.toString(),{class:"HeroScepterAbilityTitleName", id:"HeroScepterAbilityTitleName"+sHeroNameCapital+i.toString(), text:sAbilityName})
			$.CreatePanelWithProperties('Label', $("#HeroScepterAbilityContainer"+sHeroNameCapital+i.toString()), "HeroScepterAbilityDescription"+sHeroNameCapital+i.toString(),{class:"HeroScepterAbilityDescription", id:"HeroScepterAbilityDescription"+sHeroNameCapital+i.toString(), text:"#DOTA_Tooltip_Ability_"+tFunHeroScepterInfo[i.toString()].sAbilityName+"_aghanim_description"})
			i=i+1
		}
	}
	
	if (aTalents.length) {
		$.CreatePanelWithProperties('Panel', $(sPanelName), "HeroTalentContainer"+sHeroNameCapital,{class:"HeroTalentContainer", id:"HeroTalentContainer"+sHeroNameCapital})
	//	$("#Talent"+sHeroNameCapital).SetPanelEvent("onmouseover", function (){$("#HeroTalentContainer"+sHeroNameCapital).visible=true})
	//	$("#Talent"+sHeroNameCapital).SetPanelEvent("onmouseout", function (){$("#HeroTalentContainer"+sHeroNameCapital).visible=false})
		
		$.CreatePanelWithProperties('Label', $("#HeroTalentContainer"+sHeroNameCapital), '',{class:"HeroTalentTitle", text:"#DOTA_AbilityBuild_Talent_Title"})
		var iTalent = 0
		for (var iLevel = 25; iLevel > 5; iLevel=iLevel-5) {
			$.CreatePanelWithProperties('Panel', $("#HeroTalentContainer"+sHeroNameCapital), "HeroTalentLine"+sHeroNameCapital+iLevel.toString(),{class:"HeroTalentLine", id:"HeroTalentLine"+sHeroNameCapital+iLevel.toString()})
			
			$.CreatePanelWithProperties('Panel', $("#HeroTalentLine"+sHeroNameCapital+iLevel.toString()), "HeroTalentLeft"+sHeroNameCapital+iLevel.toString(),{class:"HeroTalentLeft", id:"HeroTalentLeft"+sHeroNameCapital+iLevel.toString()})
			$.CreatePanelWithProperties('Label', $("#HeroTalentLeft"+sHeroNameCapital+iLevel.toString()), "HeroTalentLableLeft"+sHeroNameCapital+iLevel.toString(),{id:"HeroTalentLableLeft"+sHeroNameCapital+iLevel.toString(), class:"HeroTalentContentLabel", text:"#DOTA_Tooltip_ability_"+aTalents[iTalent]})
			if ($('#HeroTalentLableLeft'+sHeroNameCapital+iLevel.toString()).text.match('[!s:value]')) {
				var iValue = 0
				var aTalentValue=aTalents[iTalent].match(/[0-9]/g)
				for (var i in aTalentValue)
					iValue = iValue*10+parseInt(aTalentValue[i]);
				
				$('#HeroTalentLableLeft'+sHeroNameCapital+iLevel.toString()).text=$('#HeroTalentLableLeft'+sHeroNameCapital+iLevel.toString()).text.replace('[!s:value]',iValue.toString())
				
			}
			iTalent++;			
			$.CreatePanelWithProperties('Panel', $("#HeroTalentLine"+sHeroNameCapital+iLevel.toString()), "HeroTalentMiddle"+sHeroNameCapital+iLevel.toString(),{class:"HeroTalentMiddle", id:"HeroTalentMiddle"+sHeroNameCapital+iLevel.toString()})
			$.CreatePanelWithProperties('Label', $("#HeroTalentMiddle"+sHeroNameCapital+iLevel.toString()), '',{class:"HeroTalentReqLabel", text:iLevel.toString()})
			$.CreatePanelWithProperties('Panel', var test=$("#HeroTalentLine"+sHeroNameCapital+iLevel.toString()), "HeroTalentRight"+sHeroNameCapital+iLevel.toString(),{class:"HeroTalentRight", id:"HeroTalentRight"+sHeroNameCapital+iLevel.toString()})
			
			$.CreatePanelWithProperties('Label', $("#HeroTalentRight"+sHeroNameCapital+iLevel.toString()), "HeroTalentLableRight"+sHeroNameCapital+iLevel.toString(),{class:"HeroTalentContentLabel", id:"HeroTalentLableRight"+sHeroNameCapital+iLevel.toString(), text:"#DOTA_Tooltip_ability_"+aTalents[iTalent]})
			if ($('#HeroTalentLableRight'+sHeroNameCapital+iLevel.toString()).text.match('[!s:value]')) {
				var iValue = 0
				var aTalentValue=aTalents[iTalent].match(/[0-9]/g)
				for (var i in aTalentValue)
					iValue = iValue*10+parseInt(aTalentValue[i]);
				$('#HeroTalentLableRight'+sHeroNameCapital+iLevel.toString()).text=$('#HeroTalentLableRight'+sHeroNameCapital+iLevel.toString()).text.replace('[!s:value]',iValue.toString())
			}
			iTalent++;
		}	
	}
	$.CreatePanelWithProperties('Button', $(sPanelName), "HeroSelection"+sHeroNameCapital,{id:"HeroSelection"+sHeroNameCapital, class:"HeroSelectionButton", onactivate:"HeroSelection(&quot;npc_dota_hero_"+sHeroName+"&quot;, &quot;"+sHeroNameCapital+"&quot;);"});
	$.CreatePanelWithProperties('Label', $("#HeroSelection"+sHeroNameCapital), "HeroSelectionLabel",{id:"HeroSelectionLabel", text:"#select_hero"})
	if (sHeroNameCapital == 'Invoker') {
		$.CreatePanelWithProperties('Button', $(sPanelName), "EnableWearable"+sHeroNameCapital,{id:"EnableWearable"+sHeroNameCapital, class:"HeroSelectionButton", onactivate:"EnableWearable(&quot;npc_dota_hero_"+sHeroName+"&quot;, &quot;"+sHeroNameCapital+"&quot;);", onmouseover:"DOTAShowTextTooltip(#InvokerRetroChangeWearable_enable_tooltip)", onmouseout:"DOTAHideTextTooltip()"});
		$.CreatePanelWithProperties('Label', $("#EnableWearable"+sHeroNameCapital), '',{text:"#InvokerRetroChangeWearable_enable"})
		$("#EnableWearable"+sHeroNameCapital).visible = true
		$.CreatePanelWithProperties('Button', $(sPanelName), "DisableWearable"+sHeroNameCapital,{id:"DisableWearable"+sHeroNameCapital, class:"HeroUnselectionButton", onactivate:"DisableWearable(&quot;npc_dota_hero_"+sHeroName+"&quot;, &quot;"+sHeroNameCapital+"&quot;);"});
		$.CreatePanelWithProperties('Label', $("#DisableWearable"+sHeroNameCapital), '',{text:"#InvokerRetroChangeWearable_disable" })
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