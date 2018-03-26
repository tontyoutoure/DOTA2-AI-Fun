"use strict"; 

var hAbilityBotton4
var hAbilityBotton3 
var bInvokerRetroInitiated = false


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
				SetAbilityButtonEvent(iSlot, iSlotLoadout)
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
function Testf(keys) {
	UpdateAbilityLoadout()
}
GameEvents.Subscribe( "dota_ability_changed", Testf);
GameEvents.Subscribe( "dota_player_update_selected_unit", InvokerButtonsApply);
GameEvents.Subscribe( "dota_player_update_query_unit", InvokerButtonsApply);
GameEvents.Subscribe( "invoker_scepter_state_change", InvokerButtonsScepterChange);






