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
	$.CreatePanelWithProperties('DOTAAbilityImage', $('#AbilityShowCase'+iDropDown.toString()), '',{abilityname:sAbility})
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
		$.CreatePanelWithProperties('Panel', $('#Ability'+i.toString()+'Panel'), "TitlePanelAbility"+i.toString(),{class:"TitlePanel", id:"TitlePanelAbility"+i.toString()})
		$.CreatePanelWithProperties('Label', $('#TitlePanelAbility'+i.toString()+''), '',{text:"#best_worst_stats_ability_"+i.toString()})
		
		$.CreatePanelWithProperties('Panel', $('#Ability'+i.toString()+'Panel'), "DropDownContainerAbility"+i.toString(),{class:"DropDownContainer", id:"DropDownContainerAbility"+i.toString()})
		
		$.CreatePanelWithProperties('Panel', $('#DropDownContainerAbility'+i.toString()+''), "SingleDropDownContainerHero"+i.toString(),{class:"SingleDropDownContainer", id:"SingleDropDownContainerHero"+i.toString()})
		$.CreatePanelWithProperties('Panel', $('#SingleDropDownContainerHero'+i.toString()+''), "SingleDropDownElementHero"+i.toString()+"LabelPanel",{class:"SingleDropDownElement", id:"SingleDropDownElementHero"+i.toString()+"LabelPanel"})
		$.CreatePanelWithProperties('Label', $('#SingleDropDownElementHero'+i.toString()+'LabelPanel'), '',{class:"LargeLabel", text:"dota_hero"})
		$.CreatePanelWithProperties('Panel', $('#SingleDropDownContainerHero'+i.toString()+''), "SingleDropDownElementHero"+i.toString()+"DropDownPanel" ,{class:"SingleDropDownElement", id:"SingleDropDownElementHero"+i.toString()+"DropDownPanel" })
		$.CreatePanelWithProperties('DropDown', $('#SingleDropDownElementHero'+i.toString()+'DropDownPanel'), "SingleDropDownElementHero"+i.toString()+"DropDown",{id:"SingleDropDownElementHero"+i.toString()+"DropDown", oninputsubmit:"ChooseAbilityForHero("+i.toString()+");"});
		AddHeroesForDropDown('#SingleDropDownElementHero'+i.toString()+'DropDown')
		
		$.CreatePanelWithProperties('Panel', $('#DropDownContainerAbility'+i.toString()+''), "SingleDropDownContainerAbility"+i.toString(),{class:"SingleDropDownContainer", id:"SingleDropDownContainerAbility"+i.toString()})
		$.CreatePanelWithProperties('Panel', $('#SingleDropDownContainerAbility'+i.toString()+''), "SingleDropDownElementAbility"+i.toString()+"LabelPanel",{class:"SingleDropDownElement", id:"SingleDropDownElementAbility"+i.toString()+"LabelPanel"})
		$.CreatePanelWithProperties('Label', $('#SingleDropDownElementAbility'+i.toString()+'LabelPanel'), '',{class:"LargeLabel", text:"DOTA_Skills"})
		$.CreatePanelWithProperties('Panel', $('#SingleDropDownContainerAbility'+i.toString()+''), "SingleDropDownElementAbility"+i.toString()+"DropDownPanel",{class:"SingleDropDownElement", id:"SingleDropDownElementAbility"+i.toString()+"DropDownPanel"})
		$.CreatePanelWithProperties('DropDown', $('#SingleDropDownElementAbility'+i.toString()+'DropDownPanel'), "SingleDropDownElementAbility"+i.toString()+"DropDown",{id:"SingleDropDownElementAbility"+i.toString()+"DropDown", oninputsubmit:"AbilitySet("+i.toString()+")"})
		$.CreatePanelWithProperties('Panel', $('#Ability'+i.toString()+'Panel'), "AbilityShowCase"+i.toString(),{class:"AbilityShowCase", id:"AbilityShowCase"+i.toString()})
	}
	
	
}
function AddTalentForDropDown(i, bBest) {
	var dropdown = $('#TalentDropDown'+i.toString())
	if (bBest) {
		for (var iIndex in aTalents[i-1]) {
			var sTalent = aTalents[i-1][iIndex]
			var dropdownlabel = $.CreatePanel('Label', dropdown, sTalent)
			if ($.Localize('DOTA_Tooltip_ability_'+sTalent).length > 0)
				dropdownlabel.text=$.Localize('DOTA_Tooltip_ability_'+sTalent);
			else
				dropdownlabel.text=sTalent;
			dropdown.AddOption(dropdownlabel)
			dropdown.SetSelected(sTalent)
		}
	}
	else{
		for (var sTalent in aPossibleTalents[i-1]) {
			var dropdownlabel = $.CreatePanel('Label', dropdown, sTalent)
			if ($.Localize('DOTA_Tooltip_ability_'+sTalent).length > 0)
				dropdownlabel.text=$.Localize('DOTA_Tooltip_ability_'+sTalent);
			else
				dropdownlabel.text=sTalent;
			dropdown.AddOption(dropdownlabel)
			dropdown.SetSelected(sTalent)
		}
	}
}
//$.Msg($.Localize('DOTA_Tooltip_ability_special_bonus_30_crit_2')) 
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
			$.CreatePanelWithProperties('Panel', $('#Talent'+i.toString()+'Panel'), "TitlePanelTalent"+i.toString(),{class:"TitlePanel", id:"TitlePanelTalent"+i.toString()})
			$.CreatePanelWithProperties('Label', $('#TitlePanelTalent'+i.toString()+''), '',{text:"#best_worst_stats_talent_tier_"+i.toString()})
			$.CreatePanelWithProperties('Panel', $('#Talent'+i.toString()+'Panel'), "DropDownContainerLarge"+i.toString(),{class:"DropDownContainerLarge", id:"DropDownContainerLarge"+i.toString()})
			$.CreatePanelWithProperties('DropDown', $('#DropDownContainerLarge'+i.toString()), "TalentDropDown"+i.toString(),{id:"TalentDropDown"+i.toString()})
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
	//GameEvents.SendCustomGameEventToServer( "best_worst_stats_selected_abilities", { "talents" : aSelectedTalents, "abilities" : aSelectedAbilities, "primary_attribute" : iPrimaryAttribute.toString()} );

	bHeroInitialized = true
	$('#AbilityChooseBase').visible = false
	$('#AbilityChooseBase').SetFocus()
}
 
InitBestWorstStats(); 
GameEvents.Subscribe( "dota_player_update_selected_unit", BWSUpdateSelectUnit);