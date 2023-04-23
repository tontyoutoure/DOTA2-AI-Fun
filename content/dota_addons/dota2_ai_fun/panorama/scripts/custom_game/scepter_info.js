"use strict"; 
var ScepterInfo = {};

ScepterInfo.bInitialized = false;
ScepterInfo.bAddIntoInfoTabs = false;

ScepterInfo.OnScepterInfoActive = function() {
	if (!this.bAddIntoInfoTabs) {
		Ingame.tInfomationTabs['#ScepterInfoContainer'] = true;
		this.bAddIntoInfoTabs = true;
	}
	if ($("#ScepterInfoContainer").visible ) {
		Ingame.ChangeTabState('#ScepterInfoContainer', false)
	}
	else {
		Ingame.ChangeTabState('#ScepterInfoContainer', true)
		for (var sHeroName in tFunHeroInfo) {
			if ($("#ScepterInfoHeroContainer"+tFunHeroInfo[sHeroName].sCapitalName)) {
				if ("npc_dota_hero_"+sHeroName == Entities.GetUnitName(Players.GetLocalPlayerPortraitUnit())) {
					$("#ScepterInfoHeroContainer"+tFunHeroInfo[sHeroName].sCapitalName).visible = true
				}
				else {
					$("#ScepterInfoHeroContainer"+tFunHeroInfo[sHeroName].sCapitalName).visible = false
				}
			}
		}
	}
}
ScepterInfo.Initialize = function() {	
	for (var sHeroName in tFunHeroInfo) {
		var tFunHeroScepterInfo = CustomNetTables.GetTableValue("fun_hero_stats", tFunHeroInfo[sHeroName].sName+"_scepter_infos");
		if (tFunHeroScepterInfo) {
			tFunHeroInfo[sHeroName].bHasScepterUpgrade = true
			var sHeroNameCapital = tFunHeroInfo[sHeroName].sCapitalName
		$.CreatePanelWithProperties('Panel', $("#ScepterInfoContainer"), "ScepterInfoHeroContainer"+sHeroNameCapital,{class:"ScepterInfoHeroContainer", id:"ScepterInfoHeroContainer"+sHeroNameCapital})
			
			var i = 1
			while (tFunHeroScepterInfo[i.toString()]) {
				$.CreatePanelWithProperties('Panel', $("#ScepterInfoHeroContainer"+sHeroNameCapital), "HeroScepterAbilityContainer"+sHeroNameCapital+i.toString(),{class:"HeroScepterAbilityContainer", id:"HeroScepterAbilityContainer"+sHeroNameCapital+i.toString()})
				$.CreatePanelWithProperties('Panel', $("#HeroScepterAbilityContainer"+sHeroNameCapital+i.toString()), "HeroScepterAbilityLine"+sHeroNameCapital+i.toString(),{class:"HeroScepterAbilityLine", id:"HeroScepterAbilityLine"+sHeroNameCapital+i.toString()})
				
				var sAbilityName = $.Localize("#DOTA_Tooltip_Ability_"+tFunHeroScepterInfo[i.toString()].sAbilityName).toUpperCase()
				$.CreatePanelWithProperties('Label', $("#HeroScepterAbilityLine"+sHeroNameCapital+i.toString()), "HeroScepterAbilityTitleUpgrade"+sHeroNameCapital+i.toString(),{class:"HeroScepterAbilityTitleUpgrade", id:"HeroScepterAbilityTitleUpgrade"+sHeroNameCapital+i.toString(), text:"#scepter_info_title"})
				$.CreatePanelWithProperties('Label', $("#HeroScepterAbilityLine"+sHeroNameCapital+i.toString()), "HeroScepterAbilityTitleName"+sHeroNameCapital+i.toString(),{class:"HeroScepterAbilityTitleName", id:"HeroScepterAbilityTitleName"+sHeroNameCapital+i.toString(), text:sAbilityName})
				$.CreatePanelWithProperties('Label', $("#HeroScepterAbilityContainer"+sHeroNameCapital+i.toString()), "HeroScepterAbilityDescription"+sHeroNameCapital+i.toString(),{class:"HeroScepterAbilityDescription", id:"HeroScepterAbilityDescription"+sHeroNameCapital+i.toString(), text:"#DOTA_Tooltip_Ability_"+tFunHeroScepterInfo[i.toString()].sAbilityName+"_aghanim_description"})
				if (tFunHeroScepterInfo[i.toString()].tScepterSpecials) {
					var j = 1
					while (tFunHeroScepterInfo[i.toString()].tScepterSpecials[j.toString()]) {
						var sSpecialName = $.Localize("#DOTA_Tooltip_ability_"+tFunHeroScepterInfo[i.toString()].sAbilityName+"_"+tFunHeroScepterInfo[i.toString()].tScepterSpecials[j.toString()].sSpecialName)
						var sSpecialValue = tFunHeroScepterInfo[i.toString()].tScepterSpecials[j.toString()].sSpecialValue
						$.CreatePanelWithProperties('Panel', $("#HeroScepterAbilityContainer"+sHeroNameCapital+i.toString()), "HeroScepterAbilityLine"+sHeroNameCapital+i.toString()+"special"+j.toString(),{class:"HeroScepterAbilityLine", id:"HeroScepterAbilityLine"+sHeroNameCapital+i.toString()+"special"+j.toString()})
						if (sSpecialName.substr(0,1) == "%") {
							var aSpecials = sSpecialValue.split("/")
							var sSpecialWithPercentage = ""
							for (var k = 0; k < aSpecials.length; k++) {
								sSpecialWithPercentage = sSpecialWithPercentage+aSpecials[k]+"%"
								if (aSpecials[k+1]) {sSpecialWithPercentage = sSpecialWithPercentage+"/"}
							}
							$.CreatePanelWithProperties('Label', $("#HeroScepterAbilityLine"+sHeroNameCapital+i.toString()+'special'+j.toString()), "HeroScepterAbilitySpecialName"+sHeroNameCapital+i.toString()+"special"+j.toString(),{class:"HeroScepterAbilityTitleName", id:"HeroScepterAbilitySpecialName"+sHeroNameCapital+i.toString()+"special"+j.toString(), text:sSpecialName.substr(1)})
							$.CreatePanelWithProperties('Label', $("#HeroScepterAbilityLine"+sHeroNameCapital+i.toString()+'special'+j.toString()), "HeroScepterAbilitySpecialValue"+sHeroNameCapital+i.toString()+"special"+j.toString(),{class:"HeroScepterAbilitySpecialValue", id:"HeroScepterAbilitySpecialValue"+sHeroNameCapital+i.toString()+"special"+j.toString(), text:sSpecialWithPercentage})
							
						}
						else{
							$.CreatePanelWithProperties('Label', $("#HeroScepterAbilityLine"+sHeroNameCapital+i.toString()+'special'+j.toString()), "HeroScepterAbilitySpecialName"+sHeroNameCapital+i.toString()+"special"+j.toString(),{class:"HeroScepterAbilityTitleName", id:"HeroScepterAbilitySpecialName"+sHeroNameCapital+i.toString()+"special"+j.toString(), text:sSpecialName})
							$.CreatePanelWithProperties('Label', $("#HeroScepterAbilityLine"+sHeroNameCapital+i.toString()+'special'+j.toString()), "HeroScepterAbilitySpecialValue"+sHeroNameCapital+i.toString()+"special"+j.toString(),{class:"HeroScepterAbilitySpecialValue", id:"HeroScepterAbilitySpecialValue"+sHeroNameCapital+i.toString()+"special"+j.toString(), text:sSpecialValue})
						}
						j = j+1
					}
				}
				i=i+1
			}			
		}
	}
	this.bInitialized = true
}

function ScepterInfoButtonApply(keys) {
	if ((Entities.GetAbilityByName(Players.GetLocalPlayerPortraitUnit(), "invoker_retro_invoke") > 0 || 
	Entities.GetAbilityByName(Players.GetLocalPlayerPortraitUnit(), "hero_attribute_gain_manager") > 0 || 
	Entities.GetAbilityByName(Players.GetLocalPlayerPortraitUnit(), "ramza_go_back_lua") > 0 ) && tFunHeroInfo[Entities.GetUnitName(Players.GetLocalPlayerPortraitUnit()).substr(14)] && tFunHeroInfo[Entities.GetUnitName(Players.GetLocalPlayerPortraitUnit()).substr(14)].bHasScepterUpgrade) {
		$("#ScepterInfoButton").visible = true
		$("#ScepterInfoContainer").visible = false
	}
	else {
		$("#ScepterInfoButton").visible = false
		$("#ScepterInfoContainer").visible = false
	}
}
ScepterInfo.Initialize()
 

GameEvents.Subscribe( "dota_player_update_selected_unit", ScepterInfoButtonApply);
GameEvents.Subscribe( "dota_player_update_query_unit", ScepterInfoButtonApply);














