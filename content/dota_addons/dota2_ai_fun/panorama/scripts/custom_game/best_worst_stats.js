"use strict"; 

var tBasicAbilities = {}
var tUltiAbilities = CustomNetTables.GetTableValue('game_options', 'ulti_abilities' )
var aTalents = [{},{},{},{}]
var aUniqueTalents = [{},{},{},{}]
var bHeroInitialized = false
var bInitializing = false
var aPossibleTalents = [[],[],[],[]]
aPossibleTalents[0] = {}
aPossibleTalents[1] = {}
aPossibleTalents[2] = {}
aPossibleTalents[3] = {}
var aSelectedAbilities = []
var aSelectedTalents = []
var iPrimaryAttribute = 0



function InitBestWorstStats() {
	aTalents[0] = CustomNetTables.GetTableValue('game_options', 'talents_1' )
	aTalents[1] = CustomNetTables.GetTableValue('game_options', 'talents_2' )
	aTalents[2] = CustomNetTables.GetTableValue('game_options', 'talents_3' )
	aTalents[3] = CustomNetTables.GetTableValue('game_options', 'talents_4' )
	aUniqueTalents[0] = CustomNetTables.GetTableValue('game_options', 'unique_talents_1' )
	aUniqueTalents[1] = CustomNetTables.GetTableValue('game_options', 'unique_talents_2' )
	aUniqueTalents[2] = CustomNetTables.GetTableValue('game_options', 'unique_talents_3' )
	aUniqueTalents[3] = CustomNetTables.GetTableValue('game_options', 'unique_talents_4' )
	var iBasicAbilitiesGroupSize = CustomNetTables.GetTableValue('game_options', 'basic_abilities_group_count' )["1"]
	for (var i = 1; i <= iBasicAbilitiesGroupSize; i++) {
		var tTemp = CustomNetTables.GetTableValue('game_options', 'basic_abilities'+i.toString())
		for(var j in tTemp) {
			tBasicAbilities[j] = tTemp[j]
		}
	}
}

function AddHeroesForDropDown(sID){
	for (var sName in tBasicAbilities) {
		var dropdownlabel = $.CreatePanel('Label', $(sID), sName)
		dropdownlabel.text = $.Localize(sName+'_original')
		$(sID).AddOption(dropdownlabel)
//		$(sID).SetSelected(sName)
	}
}


function ChooseAbilityForHero(iDropDown) {
	var hAbilityDropDown = $('#SingleDropDownElementAbility'+iDropDown.toString()+'DropDown')
	if(hAbilityDropDown)
		hAbilityDropDown.RemoveAllOptions()
	var sName = $('#SingleDropDownElementHero'+iDropDown.toString()+'DropDown').GetSelected().id
	if (iDropDown < 4) {
		for (var sAbility in tBasicAbilities[sName]) {
			var dropdownlabel = $.CreatePanel('Label', hAbilityDropDown, sAbility)
			dropdownlabel.text = $.Localize("DOTA_Tooltip_ability_"+sAbility)	
			hAbilityDropDown.AddOption(dropdownlabel)	
			hAbilityDropDown.SetSelected(sAbility)			
		}
	}
	else {
		var sAbility
		for (var s in tUltiAbilities[sName])
			sAbility = s
		var dropdownlabel = $.CreatePanel('Label', hAbilityDropDown, sAbility)
		dropdownlabel.text = $.Localize("DOTA_Tooltip_ability_"+sAbility)	
		hAbilityDropDown.AddOption(dropdownlabel)	
		hAbilityDropDown.SetSelected(sAbility)	
	}
}



function AbilitySet(iDropDown) {
	var selectedLabel=$('#SingleDropDownElementAbility'+iDropDown.toString()+'DropDown').GetSelected()
	var sAbility
	if (selectedLabel) {sAbility = selectedLabel.id}
	else {sAbility = ''}
	$('#AbilityShowCase'+iDropDown.toString()).BCreateChildren('<DOTAAbilityImage abilityname="'+sAbility+'"/>')
	$('#AbilityShowCase'+iDropDown.toString()).SetPanelEvent('onmouseover', function () {
		$.DispatchEvent('DOTAShowAbilityTooltip', $('#AbilityShowCase'+iDropDown.toString()), sAbility)
	})
	$('#AbilityShowCase'+iDropDown.toString()).SetPanelEvent('onmouseout', function () {
		$.DispatchEvent('DOTAHideAbilityTooltip')
	})
}

function InitAbilitySelection() {
//	$.Msg('worst!')
	$('#AbilityChooseBase').visible = true
	$('#AbilityChoosePanel').visible = true
	$('#TalentChoosePanel').visible = false
	$('#AbilityChooseConfirmBtn').visible = true
	$('#AbilityChooseConfirmAllBtn').visible = false
	bInitializing = true
	
	$('#AbilityChooseBottomStatus').text=$.Localize('#best_worst_stats_status_choose_ability')
	$('#AbilityChooseConfirmBtnLabel').text=$.Localize('#best_worst_stats_confirm_ability')
	$('#AbilityChooseConfirmAllBtn').visible = false
	for(var i = 1; i < 5; i++) {
		$('#Ability'+i.toString()+'Panel').BCreateChildren('<Panel class="TitlePanel" id="TitlePanelAbility'+i.toString()+'"/>')
		$('#TitlePanelAbility'+i.toString()+'').BCreateChildren('<Label text="#best_worst_stats_ability_'+i.toString()+'"/>')
		
		$('#Ability'+i.toString()+'Panel').BCreateChildren('<Panel class="DropDownContainer" id="DropDownContainerAbility'+i.toString()+'"/>')
		
		$('#DropDownContainerAbility'+i.toString()+'').BCreateChildren('<Panel class="SingleDropDownContainer" id="SingleDropDownContainerHero'+i.toString()+'"/>')
		$('#SingleDropDownContainerHero'+i.toString()+'').BCreateChildren('<Panel class="SingleDropDownElement" id="SingleDropDownElementHero'+i.toString()+'LabelPanel"/>')
		$('#SingleDropDownElementHero'+i.toString()+'LabelPanel').BCreateChildren('<Label class="LargeLabel" text="dota_hero"/>')
		$('#SingleDropDownContainerHero'+i.toString()+'').BCreateChildren('<Panel class="SingleDropDownElement" id="SingleDropDownElementHero'+i.toString()+'DropDownPanel" />')
		$('#SingleDropDownElementHero'+i.toString()+'DropDownPanel').BCreateChildren('<DropDown id="SingleDropDownElementHero'+i.toString()+'DropDown" oninputsubmit="ChooseAbilityForHero('+i.toString()+');"/>')
		AddHeroesForDropDown('#SingleDropDownElementHero'+i.toString()+'DropDown')
		
		$('#DropDownContainerAbility'+i.toString()+'').BCreateChildren('<Panel class="SingleDropDownContainer" id="SingleDropDownContainerAbility'+i.toString()+'"/>')
		$('#SingleDropDownContainerAbility'+i.toString()+'').BCreateChildren('<Panel class="SingleDropDownElement" id="SingleDropDownElementAbility'+i.toString()+'LabelPanel"/>')
		$('#SingleDropDownElementAbility'+i.toString()+'LabelPanel').BCreateChildren('<Label class="LargeLabel" text="DOTA_Skills"/>')
		$('#SingleDropDownContainerAbility'+i.toString()+'').BCreateChildren('<Panel class="SingleDropDownElement" id="SingleDropDownElementAbility'+i.toString()+'DropDownPanel"/>')
		$('#SingleDropDownElementAbility'+i.toString()+'DropDownPanel').BCreateChildren('<DropDown id="SingleDropDownElementAbility'+i.toString()+'DropDown" oninputsubmit="AbilitySet('+i.toString()+')"/>')
//		$('#Ability'+i.toString()+'Panel').BCreateChildren('<Panel class="AbilityShowCase" id="AbilityShowCase'+i.toString()+'"/>')
	}
	
	
}

function AddTalentForDropDown(i, bBest) {
	var dropdown = $('#TalentDropDown'+i.toString())
	if (bBest) {
		for (var iIndex in aTalents[i-1]) {
			var sTalent = aTalents[i-1][iIndex]
			var dropdownlabel = $.CreatePanel('Label', dropdown, sTalent)
			dropdownlabel.text=$.Localize('DOTA_Tooltip_ability_'+sTalent)
			dropdown.AddOption(dropdownlabel)
			dropdown.SetSelected(sTalent)
		}
	}
	else{
		for (var sTalent in aPossibleTalents[i-1]) {
			var dropdownlabel = $.CreatePanel('Label', dropdown, sTalent)
			dropdownlabel.text=$.Localize('DOTA_Tooltip_ability_'+sTalent)
			dropdown.AddOption(dropdownlabel)
			dropdown.SetSelected(sTalent)
		}
	}
}

function StrActivated(){
	iPrimaryAttribute = 1
	$("#PrimaryAttributeSelectBtnStr").SetHasClass('PrimaryAttributeSelectBtnActivated', true)
	$("#PrimaryAttributeSelectBtnAgi").SetHasClass('PrimaryAttributeSelectBtnActivated', false)
	$("#PrimaryAttributeSelectBtnInt").SetHasClass('PrimaryAttributeSelectBtnActivated', false)
}

function AgiActivated(){
	iPrimaryAttribute = 2
	$("#PrimaryAttributeSelectBtnStr").SetHasClass('PrimaryAttributeSelectBtnActivated', false)
	$("#PrimaryAttributeSelectBtnAgi").SetHasClass('PrimaryAttributeSelectBtnActivated', true)
	$("#PrimaryAttributeSelectBtnInt").SetHasClass('PrimaryAttributeSelectBtnActivated', false)
}

function IntActivated(){
	iPrimaryAttribute = 3
	$("#PrimaryAttributeSelectBtnStr").SetHasClass('PrimaryAttributeSelectBtnActivated', false)
	$("#PrimaryAttributeSelectBtnAgi").SetHasClass('PrimaryAttributeSelectBtnActivated', false)
	$("#PrimaryAttributeSelectBtnInt").SetHasClass('PrimaryAttributeSelectBtnActivated', true)
}

function InitTalentSelection(bBest) {
//	$.Msg('best!')
	$('#AbilityChooseBase').visible = true
	$('#AbilityChoosePanel').visible = false
	$('#AbilityChooseConfirmBtn').visible = false
	$('#AbilityChooseConfirmAllBtn').visible = true
	if (bBest) {
		$('#PrimaryAttributeSelectBtnStr').visible = true
		$('#PrimaryAttributeSelectBtnAgi').visible = true
		$('#PrimaryAttributeSelectBtnInt').visible = true
	}
	else {
		$('#TalentChoosePanel').visible = true
		$('#AbilityChooseBottomStatus').text=$.Localize('#best_worst_stats_status_choose_talent')
		bInitializing = true
		for(var i = 1; i < 5; i++) {
			$('#Talent'+i.toString()+'Panel').BCreateChildren('<Panel class="TitlePanel" id="TitlePanelTalent'+i.toString()+'"/>')
			$('#TitlePanelTalent'+i.toString()+'').BCreateChildren('<Label text="#best_worst_stats_talent_tier_'+i.toString()+'"/>')
			$('#Talent'+i.toString()+'Panel').BCreateChildren('<Panel class="DropDownContainerLarge" id="DropDownContainerLarge'+i.toString()+'"/>')
			$('#DropDownContainerLarge'+i.toString()).BCreateChildren('<DropDown id="TalentDropDown'+i.toString()+'"/>')
			AddTalentForDropDown(i, false)
			AddTalentForDropDown(i, true)
		}
	}
} 

function BWSUpdateSelectUnit(keys) {
	if (bHeroInitialized) {return}
	if (bInitializing) {return}
	var tLocalPlayerFunHero = CustomNetTables.GetTableValue('fun_hero_stats', 'fun_hero_selection_player'+Players.GetLocalPlayer().toString())
	if (tLocalPlayerFunHero) {
		 if (tLocalPlayerFunHero.initialized) {
			 bHeroInitialized = true
			 return
		 }
		 if (tLocalPlayerFunHero.hero == 'npc_dota_hero_troll_warlord') {
			 InitAbilitySelection()
		 }
		 if (tLocalPlayerFunHero.hero == 'npc_dota_hero_monkey_king') {
			 InitTalentSelection(true)
		 }
	}
 }
 
function ChooseAbilityActivated() {
	var tHeroName = {}
	for (var i = 0; i<4; i++) {
		var DropDownLabel =	$('#SingleDropDownElementAbility'+(i+1).toString()+'DropDown').GetSelected()
		if (DropDownLabel) {aSelectedAbilities[i] = DropDownLabel.id} else {return}
		var sHeroName = $('#SingleDropDownElementHero'+(i+1).toString()+'DropDown').GetSelected().id
		if (!tHeroName[sHeroName]) {
			tHeroName[sHeroName] = true
			for (var j = 0; j < 4; j++) {
				for (var sTalentName in aUniqueTalents[j]) {
					if (sTalentName.search(sHeroName.substring(14)) >= 0) {
						aPossibleTalents[j][sTalentName] = 1;
					}
				}
			}
		}
	}
	InitTalentSelection(false);
}
 
function AbilityChooseConfirmAllBtnActivated() {
	if ($("#TalentDropDown1")) {
		for (var i = 0; i<4; i++) {
			var label =  $("#TalentDropDown"+(i+1).toString()).GetSelected()
			if (label) aSelectedTalents[i] = label.id
		}
	}
	GameEvents.SendCustomGameEventToServer( "best_worst_stats_selected_abilities", { "talents" : aSelectedTalents, "abilities" : aSelectedAbilities, "primary_attribute" : iPrimaryAttribute.toString()} );

	bHeroInitialized = true
	$('#AbilityChooseBase').visible = false
	$('#AbilityChooseBase').SetFocus()
}
 
InitBestWorstStats(); 
GameEvents.Subscribe( "dota_player_update_selected_unit", BWSUpdateSelectUnit);