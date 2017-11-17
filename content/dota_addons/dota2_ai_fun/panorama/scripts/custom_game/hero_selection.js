"use strict";


var sActivatingPanel

function HeroDescription(sPanelID){
	var hPanel = $(sPanelID)
	var hContainer = $("#HeroDescriptionPopPanelContainer")
	var aCursorPosition = GameUI.GetCursorPosition();
	if (hPanel.style.visibility == 'visible') {
		hPanel.style.visibility = 'collapse';
		hContainer.style.visibility = 'collapse';
		sActivatingPanel = null;
	}
	else {		
		if (sActivatingPanel)
			HeroDescription(sActivatingPanel);
		hPanel.style.visibility = 'visible';
		hContainer.style.visibility = 'visible';
		sActivatingPanel = sPanelID;
	}
}

function HeroSelection(sHeroName) {
	GameEvents.SendCustomGameEventToServer("fun_hero_selection", {
		"hero_name": sHeroName,
		"player_id": Players.GetLocalPlayer()
	})
}