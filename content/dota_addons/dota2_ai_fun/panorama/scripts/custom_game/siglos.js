"use strict";
	$.Msg("hoho")
	function SiglosSelectUnit(keys) {
		$.Msg(keys)
			GameUI.SelectUnit(keys.iEntIndex, false)
	}
	GameEvents.Subscribe( "siglos_select_unit", SiglosSelectUnit);