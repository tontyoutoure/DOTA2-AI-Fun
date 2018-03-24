"use strict";
var sActivatingPanel
var sSelectingPart

var DOTA_ATTRIBUTE_STRENGTH = 0
var DOTA_ATTRIBUTE_AGILITY = 1
var DOTA_ATTRIBUTE_INTELLECT = 2
$("#AllowSelectionDupulicatePanel").visible=false
var tFunHeroInfo = {
	'spirit_breaker':{'sName':'astral_trekker', 'sCapitalName':'SpiritBreaker', 'bNewAvatar':false, 'bOld':true, 'bImba':true,},
	'shadow_demon':{'sName':'bastion', 'sCapitalName':'ShadowDemon', 'bNewAvatar':true, 'bOld':false, 'bImba':true,},
	'treant':{'sName':'intimidator', 'sCapitalName':'Treant', 'bNewAvatar':false, 'bOld':false, 'bImba':false,},
	'techies':{'sName':'persuasive', 'sCapitalName':'Techies', 'bNewAvatar':false, 'bOld':false, 'bImba':true,},
	'night_stalker':{'sName':'void_demon', 'sCapitalName':'NightStalker', 'bNewAvatar':false, 'bOld':true, 'bImba':false,},
	'tinker':{'sName':'terran_marine', 'sCapitalName':'Tinker', 'bNewAvatar':false, 'bOld':false, 'bImba':false,},
	'visage':{'sName':'magic_dragon', 'sCapitalName':'Visage', 'bNewAvatar':false, 'bOld':false, 'bImba':true,},
	'arc_warden':{'sName':'mana_fiend', 'sCapitalName':'ArcWarden', 'bNewAvatar':false, 'bOld':false, 'bImba':false,},
	'wisp':{'sName':'formless', 'sCapitalName':'Wisp', 'bNewAvatar':false, 'bOld':false, 'bImba':false,},
	'beastmaster':{'sName':'fluid_engineer', 'sCapitalName':'Beastmaster', 'bNewAvatar':false, 'bOld':false, 'bImba':false,},
	'enigma':{'sName':'telekenetic_blob', 'sCapitalName':'Enigma', 'bNewAvatar':false, 'bOld':false, 'bImba':true,},
	'dragon_knight':{'sName':'ramza', 'sCapitalName':'DragonKnight', 'bNewAvatar':true, 'bOld':false, 'bImba':true,},
	'oracle':{'sName':'cleric', 'sCapitalName':'Oracle', 'bNewAvatar':false, 'bOld':false, 'bImba':false,},
	'windrunner':{'sName':'pet_summoner', 'sCapitalName':'Windrunner', 'bNewAvatar':false, 'bOld':false, 'bImba':false,},
	'sven':{'sName':'felguard', 'sCapitalName':'Sven', 'bNewAvatar':false, 'bOld':false, 'bImba':false,},
	'pugna':{'sName':'el_dorado', 'sCapitalName':'Pugna', 'bNewAvatar':true, 'bOld':false, 'bImba':false,},
	'disruptor':{'sName':'hurricane', 'sCapitalName':'Disruptor', 'bNewAvatar':true, 'bOld':false, 'bImba':false,},
	'nevermore':{'sName':'capslockftw', 'sCapitalName':'Nevermore', 'bNewAvatar':false, 'bOld':false, 'bImba':false,},
	'omniknight':{'sName':'templar', 'sCapitalName':'Omniknight', 'bNewAvatar':false, 'bOld':false, 'bImba':false,},
	'meepo':{'sName':'spongebob', 'sCapitalName':'Meepo', 'bNewAvatar':true, 'bOld':false, 'bImba':false,},
	'tusk':{'sName':'hamsterlord', 'sCapitalName':'Tusk', 'bNewAvatar':false, 'bOld':false, 'bImba':false,},
	'juggernaut':{'sName':'exsoldier', 'sCapitalName':'Juggernaut', 'bNewAvatar':true, 'bOld':false, 'bImba':false,},
	'rubick':{'sName':'gambler', 'sCapitalName':'Rubick', 'bNewAvatar':false, 'bOld':true, 'bImba':false,},
	'life_stealer':{'sName':'old_lifestealer', 'sCapitalName':'LifeStealer', 'bNewAvatar':false, 'bOld':true, 'bImba':false,},
	'chaos_knight':{'sName':'rider', 'sCapitalName':'ChaosKnight', 'bNewAvatar':false, 'bOld':true, 'bImba':false,},
	'skywrath_mage':{'sName':'siglos', 'sCapitalName':'SkywrathMage', 'bNewAvatar':false, 'bOld':false, 'bImba':false,},
	'warlock':{'sName':'flame_lord', 'sCapitalName':'Warlock', 'bNewAvatar':false, 'bOld':true, 'bImba':false,},
	'keeper_of_the_light':{'sName':'conjurer', 'sCapitalName':'KeeperOfTheLight', 'bNewAvatar':false, 'bOld':true, 'bImba':false,},
	'spectre':{'sName':'avatar_of_vengeance', 'sCapitalName':'Spectre', 'bNewAvatar':false, 'bOld':true, 'bImba':false,},
//	'invoker':{'sName':'invoker_retro', 'sCapitalName':'Invoker', 'bNewAvatar':false, 'bOld':true, 'bImba':false,},
}

var CurrentOldLine = 1
var CurrentOldColumn = 1
var CurrentNewLine = 1
var CurrentNewColumn = 1
var bSecondInited = false
var tHeroSelectionOptions
function InitUISecond(keys) {
	$("#bot_attack_tower_pick_rune").checked=true;
	$("#bot_has_fun_item").checked=true;  
	if (Game.GetLocalPlayerInfo() === undefined) {
		$.Schedule(1, InitializeUI);
		return;
	} else if (Game.GetLocalPlayerInfo().player_has_host_privileges) {
		$("#game_options_container").visible=true;
		$("#GameOptionHider").visible=false;
		$("#LockOptionsBtn").visible=true;
		$("#UnlockOptionsBtn").visible=false;
		$("#ShowGameOptionButton").visible=false;
		$("#HideGameOptionButton").visible=true;
	}
	else
	{
		$("#game_options_container").visible=false;
		$("#GameOptionHider").visible=true;
		$("#LockOptionsBtn").visible=false;
		$("#UnlockOptionsBtn").visible=false;
		$("#ShowGameOptionButton").visible=true;
		$("#HideGameOptionButton").visible=false;
	}	
	tHeroSelectionOptions = keys 
	var sAvatarDir
	$("#HeroSelectionPanelOld").BCreateChildren('<Panel id="HeroAvatarButtonLineOld1" class="HeroAvatarButtonLine"/>')
	$("#HeroSelectionPanelNew").BCreateChildren('<Panel id="HeroAvatarButtonLineNew1" class="HeroAvatarButtonLine"/>')
	for (var sHeroName in tFunHeroInfo) {
		if (keys.ban_imba_fun_heroes && tFunHeroInfo[sHeroName].bImba) {continue}
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
	$("#HeroSelectionContainer").visible = true;
	$("#HeroSelectionPanelOld").visible = true;
	SelectOldHeroesActivate();
	bSecondInited = true;
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
	$(sPanelName).BCreateChildren('<Label class="HeroAbilityTitle" text="#DOTA_SHOP_CATEGORY_ABILITIES"/>')
	$(sPanelName).BCreateChildren('<Panel id="HeroAbilityContainer'+sHeroNameCapital+'" class="AbilityLine"/>')
	var aTalents = [];
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
	
	$(sPanelName).BCreateChildren('<Button id="HeroSelection'+sHeroNameCapital+'" class="HeroSelectionButton" onactivate="HeroSelection(&quot;npc_dota_hero_'+sHeroName+'&quot;, &quot;'+sHeroNameCapital+'&quot;);"/>')
	$("#HeroSelection"+sHeroNameCapital).BCreateChildren('<Label id="HeroSelectionLabel" text="#select_hero"/>')
	$(sPanelName).BCreateChildren('<Button id="HeroUnselection'+sHeroNameCapital+'" class="HeroUnselectionButton" onactivate="HeroUnselection(&quot;npc_dota_hero_'+sHeroName+'&quot;, &quot;'+sHeroNameCapital+'&quot;);"/>')
	$("#HeroUnselection"+sHeroNameCapital).BCreateChildren('<Label id="HeroUnselectionLabel" text="#unselect_hero" />')
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
		HideGameOption(false);
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

var sLanguage = $.Language()
function HeroSelection(sHeroName, sHeroPart) {
	GameEvents.SendCustomGameEventToServer("fun_hero_selection", {
		"hero_name": sHeroName,
		"player_id": Players.GetLocalPlayer(),
		"language": sLanguage
	})
	if (sSelectingPart) {
		$("#HeroSelection"+sSelectingPart).style.visibility = 'visible';
		$("#HeroUnselection"+sSelectingPart).style.visibility = 'collapse';
		$("#HeroAvatarCover"+sSelectingPart).style.visibility = 'collapse';
	}
	sSelectingPart = sHeroPart
	$("#HeroSelection"+sSelectingPart).style.visibility = 'collapse';
	$("#HeroUnselection"+sSelectingPart).style.visibility = 'visible';
	$("#HeroAvatarCover"+sSelectingPart).style.visibility = 'visible';
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

function OnConnectFull(keys) {
	if (bSecondInited||keys.PlayerID != Game.GetLocalPlayerID()){return}
	if (CustomNetTables.GetTableValue("game_options", "selection_options")) {
		InitUISecond(CustomNetTables.GetTableValue("game_options", "selection_options"))
		return
	}
	$("#HeroSelectionOptionContainer").visible=true;
	if (Game.GetLocalPlayerInfo().player_has_host_privileges) {
		$("#HeroSelectionOptionContainerWait").visible=false;
		$("#HeroSelectionOptionPanel").visible=true;
	}
	else {
		$("#HeroSelectionOptionContainerWait").visible=true;
		$("#HeroSelectionOptionPanel").visible=false;
	}
}

function ConfirmHeroSelectionOptionsActivate() {
	Game.EmitSound('ui_team_select_lock_and_start')
	var tFunHeroSelectionOptions = {
		"allow_selection_replicate":$("#allow_selection_replicate").checked,
		"ban_imba_fun_heroes":$("#ban_imba_fun_heroes").checked
	}
	GameEvents.SendCustomGameEventToServer( "net_table_change_value", { "table_name" : "game_options", "table_key" : "selection_options", "table_value":tFunHeroSelectionOptions } );
	$("#HeroSelectionOptionContainer").visible=false;
	GameEvents.SendCustomGameEventToAllClients("host_set_hero_selection_option", tFunHeroSelectionOptions)
}
GameEvents.Subscribe( "host_set_hero_selection_option", InitUISecond);
GameEvents.Subscribe( "player_connect_full", OnConnectFull); 