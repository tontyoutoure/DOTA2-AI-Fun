"use strict";
//$("#HeroAvatarBtnMeepo").style.visibility = 'collapse';
$("#HeroAvatarBtnJuggernaut").visible = false
var sActivatingPanel
var sSelectingPart
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