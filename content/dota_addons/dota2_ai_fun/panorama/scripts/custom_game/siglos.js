"use strict";
	function SiglosSelectUnit(keys) {
			GameUI.SelectUnit(keys.iEntIndex, false)
	}
	GameEvents.Subscribe( "siglos_select_unit", SiglosSelectUnit);