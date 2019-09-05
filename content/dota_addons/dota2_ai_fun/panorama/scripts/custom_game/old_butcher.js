"use strict";
function OldButcherBurrowUnburrow(keys) {
	if (keys.iPlayerID == Players.GetLocalPlayer()) {
		var tEventData = {}
		tEventData.bBurrow = keys.bBurrow
		tEventData.entindex = keys.iEntIndex
		tEventData.iPlayerID = keys.iPlayerID
		tEventData.tSelectedUnits = Players.GetSelectedEntities(Players.GetLocalPlayer())
		GameEvents.SendCustomGameEventToServer( "old_butcher_selected_units_for_burrow", tEventData)
	}
}

function OldButcherFlyToggle(keys) {
	if (keys.iPlayerID == Players.GetLocalPlayer()) {
		var tEventData = {}
		tEventData.bAutoCast = keys.bAutoCast
		tEventData.entindex = keys.iEntIndex
		tEventData.iPlayerID = keys.iPlayerID
		tEventData.tSelectedUnits = Players.GetSelectedEntities(Players.GetLocalPlayer())
		GameEvents.SendCustomGameEventToServer( "old_butcher_selected_units_for_fly_toggle", tEventData)
	}
}
GameEvents.Subscribe( "old_butcher_burrow_unburrow", OldButcherBurrowUnburrow);
GameEvents.Subscribe( "old_butcher_carrion_fly_toggle", OldButcherFlyToggle);

