"use strict"; 
var hAbilityBotton4
var hAbilityBotton3 
var bInvokerRetroInitiated = false
var tInvokerWearables = {}
var tCurrentWearables = {
	'head':{'id':'99'},
	'shoulder':{'id':'89'},
	'back':{'id':'48'},
	'arms':{'id':'100'},
	'belt':{'id':'305'}
}
var aInvokerRetroInvokeList = [
	[
		["invoker_retro_icy_path", "invoker_retro_portal", "invoker_retro_frost_nova"],
		["invoker_retro_betrayal", "invoker_retro_tornado_blast", "invoker_retro_levitation"],
		["invoker_retro_power_word", "invoker_retro_invisibility_aura", "invoker_retro_shroud_of_flames"]
	],
	[
		["invoker_retro_mana_burn", "invoker_retro_emp", "invoker_retro_soul_blast"],
		["invoker_retro_telelightning", "invoker_retro_shock", "invoker_retro_arcane_arts"],
		["invoker_retro_scout", "invoker_retro_energy_ball", "invoker_retro_lightning_shield"]
	],
	[
		["invoker_retro_chaos_meteor", "invoker_retro_confuse", "invoker_retro_disarm"],
		["invoker_retro_soul_reaver", "invoker_retro_firestorm", "invoker_retro_incinerate"],
		["invoker_retro_deafening_blast", "invoker_retro_inferno", "invoker_retro_firebolt"]
	]
] 


var aInvokerWearableParts = ['head', 'shoulder', 'back', 'arms', 'belt']
var aInvokerWearablePartsCapitalized = ['Head', 'Shoulder', 'Back', 'Arms', 'Belt']
var bInvokerWearableInitialized = false;

function InvokerWearableConfirmActivated(iSlot){
	var hWearableDropDown = $('#'+aInvokerWearablePartsCapitalized[iSlot]+'DropDownWearable')
	var hStyleDropDown = $('#'+aInvokerWearablePartsCapitalized[iSlot]+'DropDownStyle')
	var sID = hWearableDropDown.GetSelected().id
	tCurrentWearables[aInvokerWearableParts[iSlot]] = {}
	tCurrentWearables[aInvokerWearableParts[iSlot]].id = sID
	if (tInvokerWearables[sID].visuals && tInvokerWearables[sID].visuals.styles) {
		var sStyle = hStyleDropDown.GetSelected().id
		$("#"+aInvokerWearablePartsCapitalized[iSlot]+"Image").SetImage("s2r://panorama/images/"+tInvokerWearables[sID].visuals.alternate_icons[tInvokerWearables[sID].visuals.styles[sStyle].alternate_icon].icon_path+".png")
		tCurrentWearables[aInvokerWearableParts[iSlot]].style = sStyle
	}
	else {
		$("#"+aInvokerWearablePartsCapitalized[iSlot]+"Image").SetImage("s2r://panorama/images/"+tInvokerWearables[sID].image_inventory+".png")
	}
	GameEvents.SendCustomGameEventToServer( "invoker_retro_change_wearables", tCurrentWearables)
}

function InvokerWearableCheckStyle(iSlot) {
	var hWearableDropDown = $('#'+aInvokerWearablePartsCapitalized[iSlot]+'DropDownWearable')
	var hStyleContainer = $('#'+aInvokerWearablePartsCapitalized[iSlot]+'DropDownContainerStyle')
	var hStyleDropDown = $('#'+aInvokerWearablePartsCapitalized[iSlot]+'DropDownStyle')
	var sID = hWearableDropDown.GetSelected().id
	if (tInvokerWearables[sID].visuals && tInvokerWearables[sID].visuals.styles) {
		hStyleContainer.visible = true
		hStyleDropDown.RemoveAllOptions()
		for (var sStyle in tInvokerWearables[sID].visuals.styles) {	
			var dropdownlabel = $.CreatePanel('Label', hStyleDropDown, sStyle)
			dropdownlabel.text=$.Localize(tInvokerWearables[sID].visuals.styles[sStyle].name)		
			hStyleDropDown.AddOption(dropdownlabel)	
		}
		hStyleDropDown.SetSelected("0")	
	}
	else{
		hStyleContainer.visible = false	 
	}
}

function InvokerWearableResetActivated(iSlot) {
	tCurrentWearables[aInvokerWearableParts[iSlot]] = null
	$("#"+aInvokerWearablePartsCapitalized[iSlot]+"Image").SetImage("s2r://panorama/images/econ/testitem_slot_empty.png") 
	GameEvents.SendCustomGameEventToServer( "invoker_retro_change_wearables", tCurrentWearables)
}

function InvokerWearableIntializeDropDown(iSlot, hDropDown) {
	for (var sID in tInvokerWearables) {
		if (tInvokerWearables[sID].item_slot == aInvokerWearableParts[iSlot]) {			
			var dropdownlabel = $.CreatePanel('Label', hDropDown, sID)
			dropdownlabel.text=$.Localize(tInvokerWearables[sID].item_name)
			if (tInvokerWearables[sID].item_rarity) 
				dropdownlabel.AddClass('label_color_'+tInvokerWearables[sID].item_rarity)				
			hDropDown.AddOption(dropdownlabel)
		}
	}
}

function InitializeInvokerWearables() {
	var iIndex = 1
	var tInvokerWearablesSingle
	while (true) {
		tInvokerWearablesSingle = CustomNetTables.GetTableValue('invoker_retro', 'InvokerWearableTable_'+iIndex.toString())
		for (var key in tInvokerWearablesSingle)
			tInvokerWearables[key] = tInvokerWearablesSingle[key]
		iIndex = iIndex+1
		if (!tInvokerWearablesSingle)
			break
	}
	for (var i = aInvokerWearableParts.length-1; i >= 0; i--) {
		$("#WearableBase").BCreateChildren('<Panel class="WearablePartContainer" id="'+aInvokerWearablePartsCapitalized[i]+'Container"/>')
		$("#"+aInvokerWearablePartsCapitalized[i]+"Container").BCreateChildren('<Panel class="WearablePartName" id="'+aInvokerWearablePartsCapitalized[i]+'Name"/>')
		$("#"+aInvokerWearablePartsCapitalized[i]+"Name").BCreateChildren('<Label text="#DOTA_WearableType_'+aInvokerWearablePartsCapitalized[i]+'"/>')
		$("#"+aInvokerWearablePartsCapitalized[i]+"Container").BCreateChildren('<Panel class="WearableDropDownContainer" id="'+aInvokerWearablePartsCapitalized[i]+'DropDownContainer"/>')
		$("#"+aInvokerWearablePartsCapitalized[i]+"DropDownContainer").BCreateChildren('<Panel class="WearableDropDownContainerWearable" id="'+aInvokerWearablePartsCapitalized[i]+'DropDownContainerWearable"/>')
		$("#"+aInvokerWearablePartsCapitalized[i]+"DropDownContainerWearable").BCreateChildren('<Panel class="LabelContainer" id="'+aInvokerWearablePartsCapitalized[i]+'DropDownContainerWearableLabelContainer"/>')
		$("#"+aInvokerWearablePartsCapitalized[i]+"DropDownContainerWearableLabelContainer").BCreateChildren('<Label text="#DOTA_WearableType_Wearable"/>')
		$("#"+aInvokerWearablePartsCapitalized[i]+"DropDownContainerWearable").BCreateChildren('<DropDown id="'+aInvokerWearablePartsCapitalized[i]+'DropDownWearable" oninputsubmit="InvokerWearableCheckStyle(&quot;'+i.toString()+'&quot;);"/>')
		$("#"+aInvokerWearablePartsCapitalized[i]+"DropDownContainer").BCreateChildren('<Panel class="WearableDropDownContainerStyle" id="'+aInvokerWearablePartsCapitalized[i]+'DropDownContainerStyle"/>')
		$("#"+aInvokerWearablePartsCapitalized[i]+"DropDownContainerStyle").BCreateChildren('<Panel class="LabelContainer" id="'+aInvokerWearablePartsCapitalized[i]+'DropDownContainerStyleLabelContainer"/>')
		$("#"+aInvokerWearablePartsCapitalized[i]+"DropDownContainerStyleLabelContainer").BCreateChildren('<Label text="#DOTA_SelectStyle"/>')
		$("#"+aInvokerWearablePartsCapitalized[i]+"DropDownContainerStyle").BCreateChildren('<DropDown id="'+aInvokerWearablePartsCapitalized[i]+'DropDownStyle" oninputsubmit=""/>')
		$("#"+aInvokerWearablePartsCapitalized[i]+"Container").BCreateChildren('<Panel class="WearableConfirmButtonContainer" id="'+aInvokerWearablePartsCapitalized[i]+'ConfirmButtonContainer"/>')
		$("#"+aInvokerWearablePartsCapitalized[i]+"ConfirmButtonContainer").BCreateChildren('<Button id="'+aInvokerWearablePartsCapitalized[i]+'ConfirmButton" onactivate="InvokerWearableConfirmActivated(&quot;'+i.toString()+'&quot;)"/>')
		$("#"+aInvokerWearablePartsCapitalized[i]+"ConfirmButton").BCreateChildren('<Label text="DOTA_Confirm"/>')
		$("#"+aInvokerWearablePartsCapitalized[i]+"Container").BCreateChildren('<Panel class="WearableImageContainer" id="'+aInvokerWearablePartsCapitalized[i]+'ImageContainer"/>')
		$("#"+aInvokerWearablePartsCapitalized[i]+"ImageContainer").BCreateChildren('<Image id="'+aInvokerWearablePartsCapitalized[i]+'Image"/>')
		$("#"+aInvokerWearablePartsCapitalized[i]+"Image").SetImage("s2r://panorama/images/econ/testitem_slot_empty.png") 
//		$("#"+aInvokerWearablePartsCapitalized[i]+"Container").BCreateChildren('<Panel class="WearableResetButtonContainer" id="'+aInvokerWearablePartsCapitalized[i]+'ResetButtonContainer"/>')
//		$("#"+aInvokerWearablePartsCapitalized[i]+"ResetButtonContainer").BCreateChildren('<Button id="'+aInvokerWearablePartsCapitalized[i]+'ResetButton" onactivate="InvokerWearableResetActivated(&quot;'+i.toString()+'&quot;)"/>')
//		$("#"+aInvokerWearablePartsCapitalized[i]+"ResetButton").BCreateChildren('<Label text="DOTA_econ_item_details_description_reset"/>')
		InvokerWearableIntializeDropDown(i, $("#"+aInvokerWearablePartsCapitalized[i]+"DropDownWearable"))
	}
	
	bInvokerWearableInitialized = true
}

var aInvokerElementName = ['Quas', 'Wex', 'Exort']


if (!bInvokerRetroInitiated) {
	InvokerRetroInitialize();
}

function InvokerRetroInitialize() {
	for (var i = 0; i < 3; i++) {
		$('#SpellCardListBase').BCreateChildren('<Panel id="SpellCardList'+i.toString()+'" class="SpellCardList"/>')
		for (var j = 0; j < 3; j++) {
			for (var k = 0; k < 3; k++) {
				$('#SpellCardList'+i.toString()).BCreateChildren('<Panel id="SpellCardSingle'+i.toString()+j.toString()+k.toString()+'" class="SpellCardSingle"/>')
				$('#SpellCardSingle'+i.toString()+j.toString()+k.toString()).BCreateChildren('<Panel class="SpellCardAbilityImagePanel" id="SpellCardAbilityImagePanel'+i.toString()+j.toString()+k.toString()+'" onmouseout="DOTAHideAbilityTooltip()" onmouseover="DOTAShowAbilityTooltip('+aInvokerRetroInvokeList[i][j][k]+')"/>')
				$('#SpellCardAbilityImagePanel'+i.toString()+j.toString()+k.toString()).BCreateChildren('<DOTAAbilityImage hittest="false" class="SpellCardAbilityImage" abilityname="'+aInvokerRetroInvokeList[i][j][k]+'"/>')
				$('#SpellCardSingle'+i.toString()+j.toString()+k.toString()).BCreateChildren('<Panel class="SpellCardCombinationPanel" id="SpellCardCombinationPanel'+i.toString()+j.toString()+k.toString()+'"/>')
				$('#SpellCardSingle'+i.toString()+j.toString()+k.toString()).SetHasClass(aInvokerElementName[i]+'SpellCardSingle', true)
				
				
				$('#SpellCardCombinationPanel'+i.toString()+j.toString()+k.toString()).BCreateChildren('<Panel class="SpellCardCombinationSinglePanel" id="SpellCardCombinationSinglePanel'+i.toString()+j.toString()+k.toString()+'i" />')
				$('#SpellCardCombinationSinglePanel'+i.toString()+j.toString()+k.toString()+'i').SetHasClass(aInvokerElementName[i]+'Color', true)
				$('#SpellCardCombinationSinglePanel'+i.toString()+j.toString()+k.toString()+'i').BCreateChildren('<Label id="SpellCardCombinationSinglePanelLabel'+i.toString()+j.toString()+k.toString()+'i" />')
				$('#SpellCardCombinationSinglePanelLabel'+i.toString()+j.toString()+k.toString()+'i').text=Abilities.GetKeybind(i)
				
				
				$('#SpellCardCombinationPanel'+i.toString()+j.toString()+k.toString()).BCreateChildren('<Panel class="SpellCardCombinationSinglePanel" id="SpellCardCombinationSinglePanel'+i.toString()+j.toString()+k.toString()+'j" />')
				$('#SpellCardCombinationSinglePanel'+i.toString()+j.toString()+k.toString()+'j').SetHasClass(aInvokerElementName[j]+'Color', true)
				$('#SpellCardCombinationSinglePanel'+i.toString()+j.toString()+k.toString()+'j').BCreateChildren('<Label id="SpellCardCombinationSinglePanelLabel'+i.toString()+j.toString()+k.toString()+'j" />')
				$('#SpellCardCombinationSinglePanelLabel'+i.toString()+j.toString()+k.toString()+'j').text=Abilities.GetKeybind(j)

				
				$('#SpellCardCombinationPanel'+i.toString()+j.toString()+k.toString()).BCreateChildren('<Panel class="SpellCardCombinationSinglePanel" id="SpellCardCombinationSinglePanel'+i.toString()+j.toString()+k.toString()+'k" />')
				$('#SpellCardCombinationSinglePanel'+i.toString()+j.toString()+k.toString()+'k').SetHasClass(aInvokerElementName[k]+'Color', true)
				$('#SpellCardCombinationSinglePanel'+i.toString()+j.toString()+k.toString()+'k').BCreateChildren('<Label id="SpellCardCombinationSinglePanelLabel'+i.toString()+j.toString()+k.toString()+'k" />')
				$('#SpellCardCombinationSinglePanelLabel'+i.toString()+j.toString()+k.toString()+'k').text=Abilities.GetKeybind(k)
				
				
				$('#SpellCardSingle'+i.toString()+j.toString()+k.toString()).BCreateChildren('<Panel class="SpellCardNamePanel" id="SpellCardNamePanel'+i.toString()+j.toString()+k.toString()+'"/>')
				$('#SpellCardNamePanel'+i.toString()+j.toString()+k.toString()).BCreateChildren('<Label id="SpellCardName'+i.toString()+j.toString()+k.toString()+'"/>')
				$('#SpellCardName'+i.toString()+j.toString()+k.toString()).text=$.Localize('#DOTA_Tooltip_ability_'+aInvokerRetroInvokeList[i][j][k]);
				$('#SpellCardName'+i.toString()+j.toString()+k.toString()).SetHasClass(aInvokerElementName[i]+'ColorLabel', true)
			}
		}
	}
	InitializeInvokerKeyCombination() 
}

function InitializeInvokerKeyCombination(){
	var aAbilityKeyBind = [Abilities.GetKeybind(Entities.GetAbility(Players.GetLocalPlayerPortraitUnit(), 0)), Abilities.GetKeybind(Entities.GetAbility(Players.GetLocalPlayerPortraitUnit(), 1)), Abilities.GetKeybind(Entities.GetAbility(Players.GetLocalPlayerPortraitUnit(), 2))]
	
	for (var i = 0; i < 3; i++) {
		for (var j = 0; j < 3; j++) {
			for (var k = 0; k < 3; k++) {
				$('#SpellCardCombinationSinglePanelLabel'+i.toString()+j.toString()+k.toString()+'i').text=aAbilityKeyBind[i]
				$('#SpellCardCombinationSinglePanelLabel'+i.toString()+j.toString()+k.toString()+'j').text=aAbilityKeyBind[j]
				$('#SpellCardCombinationSinglePanelLabel'+i.toString()+j.toString()+k.toString()+'k').text=aAbilityKeyBind[k]
			}
		}
	}
	
}



//for showing tooltips
function AbilityButtonMouseOver(hPanel, iSlot) {
	var iAbility = Entities.GetAbility(Players.GetLocalPlayerPortraitUnit(), iSlot)
	$.DispatchEvent("DOTAShowAbilityTooltipForEntityIndex", hPanel,  Abilities.GetAbilityName(iAbility), Players.GetLocalPlayerPortraitUnit())
//	$.Msg(Abilities.GetAbilityName(iAbility))
}

function AbilityButtonMouseOut() {
	$.DispatchEvent("DOTAHideAbilityTooltip")
}

function SetAbilityButtonEvent(iSlot, iSlotLoadout){	
//		$.Msg(iSlot," ",iSlotLoadout)
		var hAbilityBotton = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("Ability"+iSlotLoadout.toString()).FindChildTraverse("AbilityButton")
		hAbilityBotton.SetPanelEvent("onmouseover", function (){AbilityButtonMouseOver(hAbilityBotton, iSlot)})
		hAbilityBotton.SetPanelEvent("onmouseout", function (){AbilityButtonMouseOut()})
}
//for showing ability button

function InvokerButtonsApply(keys) {
	if (Entities.GetAbilityByName(Players.GetLocalPlayerPortraitUnit(), "invoker_retro_invoke") > 0) {
		$('#AbilityButtonTooltipButton5').style.visibility = 'visible';
		if (Entities.HasScepter(Players.GetLocalPlayerPortraitUnit())) {
			$('#AbilityButtonTooltipButton5').AddClass('WithScepter')
		}
		else {
			$('#AbilityButtonTooltipButton5').RemoveClass('WithScepter')
		}
	}
	else
	{
		$('#AbilityButtonTooltipButton5').style.visibility = 'collapse';
	}
	UpdateAbilityLoadout()
}

function UpdateAbilityLoadout() {
	var iSlotLoadout = 0
	if ($.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("Ability"+iSlotLoadout.toString()).FindChildTraverse("AbilityButton")){
		for (var iSlot = 0; iSlot < 24; iSlot++) {
			var iAbility = Entities.GetAbility(Players.GetLocalPlayerPortraitUnit(), iSlot)
			if (iAbility >= 0 && !Abilities.IsHidden(iAbility) && Abilities.GetAbilityType(iAbility) < 2) {
//				SetAbilityButtonEvent(iSlot, iSlotLoadout)
				iSlotLoadout = iSlotLoadout+1
			}
		}
	}
}
function InvokerButtonsScepterChange(keys) {
	if (Players.GetLocalPlayerPortraitUnit() != keys.entindex){return}
	if (Entities.HasScepter(keys.entindex)) {
		$('#AbilityButtonTooltipButton5').AddClass('WithScepter')
	}
	else {
		$('#AbilityButtonTooltipButton5').RemoveClass('WithScepter')
		
	}
}
function Testf() {
}

function AbilityButtonTooltipButton5Activated() {
	if ($('#SpellCardBase').style.visibility == 'visible') {
		$('#SpellCardBase').style.visibility = 'collapse';
	}
	else {
		$('#SpellCardBase').style.visibility = 'visible';
		InitializeInvokerKeyCombination() 
		if (CustomNetTables.GetTableValue('invoker_retro', 'wearables_for_player_'+Game.GetLocalPlayerID().toString()))			
			$('#ChangeWearableButton').visible = true
	}
}

function ChangeWearableActivated() {
	$('#SpellCardBase').style.visibility = 'collapse';
	$('#WearableBase').style.visibility = 'visible';
	if (!bInvokerWearableInitialized)
		InitializeInvokerWearables()
	
	tCurrentWearables = CustomNetTables.GetTableValue('invoker_retro', 'wearables_for_player_'+Game.GetLocalPlayerID().toString())
	for (var i = 0; i < 5 ; i++) {
		var sID = tCurrentWearables[aInvokerWearableParts[i]].id
		$('#'+aInvokerWearablePartsCapitalized[i]+'DropDownWearable').SetSelected(sID)
		$("#"+aInvokerWearablePartsCapitalized[i]+"Image").SetImage("s2r://panorama/images/"+tInvokerWearables[sID].image_inventory+".png")
	}
}

function WearableCloseButtonActivated() {
	$('#WearableBase').style.visibility = 'collapse';
}


GameEvents.Subscribe( "dota_ability_changed", Testf);
GameEvents.Subscribe( "dota_player_update_selected_unit", InvokerButtonsApply);
GameEvents.Subscribe( "dota_player_update_query_unit", InvokerButtonsApply);
GameEvents.Subscribe( "invoker_scepter_state_change", InvokerButtonsScepterChange);






