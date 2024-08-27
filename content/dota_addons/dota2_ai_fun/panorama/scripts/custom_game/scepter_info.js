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
		var tFunHeroShardInfo = CustomNetTables.GetTableValue("fun_hero_stats", tFunHeroInfo[sHeroName].sName+"_shard_infos");
		
		if (tFunHeroScepterInfo||tFunHeroShardInfo) {
			tFunHeroInfo[sHeroName].bHasScepterUpgrade = true
			var sHeroNameCapital = tFunHeroInfo[sHeroName].sCapitalName
		$.CreatePanel('Panel', $("#ScepterInfoContainer"), "ScepterInfoHeroContainer"+sHeroNameCapital,{class:"ScepterInfoHeroContainer", id:"ScepterInfoHeroContainer"+sHeroNameCapital})
			
			var i = 1
			while (tFunHeroScepterInfo[i.toString()]) {
				$.CreatePanel('Panel', $("#ScepterInfoHeroContainer"+sHeroNameCapital), "HeroScepterAbilityContainer"+sHeroNameCapital+i.toString(),{class:"HeroScepterAbilityContainer", id:"HeroScepterAbilityContainer"+sHeroNameCapital+i.toString()})
				$.CreatePanel('Panel', $("#HeroScepterAbilityContainer"+sHeroNameCapital+i.toString()), "HeroScepterAbilityLine"+sHeroNameCapital+i.toString(),{class:"HeroScepterAbilityLine", id:"HeroScepterAbilityLine"+sHeroNameCapital+i.toString()})
				
				var sAbilityName = $.Localize("#DOTA_Tooltip_Ability_"+tFunHeroScepterInfo[i.toString()].sAbilityName).toUpperCase()
				$.CreatePanel('Label', $("#HeroScepterAbilityLine"+sHeroNameCapital+i.toString()), "HeroScepterAbilityTitleUpgrade"+sHeroNameCapital+i.toString(),{class:"HeroScepterAbilityTitleUpgrade", id:"HeroScepterAbilityTitleUpgrade"+sHeroNameCapital+i.toString(), text:"#scepter_info_title"})
				$.CreatePanel('Label', $("#HeroScepterAbilityLine"+sHeroNameCapital+i.toString()), "HeroScepterAbilityTitleName"+sHeroNameCapital+i.toString(),{class:"HeroScepterAbilityTitleName", id:"HeroScepterAbilityTitleName"+sHeroNameCapital+i.toString(), text:sAbilityName})
				$.CreatePanel('Label', $("#HeroScepterAbilityContainer"+sHeroNameCapital+i.toString()), "HeroScepterAbilityDescription"+sHeroNameCapital+i.toString(),{class:"HeroScepterAbilityDescription", id:"HeroScepterAbilityDescription"+sHeroNameCapital+i.toString(), text:"#DOTA_Tooltip_Ability_"+tFunHeroScepterInfo[i.toString()].sAbilityName+"_aghanim_description"})
				if (tFunHeroScepterInfo[i.toString()].tScepterSpecials) {
					var j = 1
					while (tFunHeroScepterInfo[i.toString()].tScepterSpecials[j.toString()]) {
						var sSpecialName = $.Localize("#DOTA_Tooltip_ability_"+tFunHeroScepterInfo[i.toString()].sAbilityName+"_"+tFunHeroScepterInfo[i.toString()].tScepterSpecials[j.toString()].sSpecialName)
						var sSpecialValue = tFunHeroScepterInfo[i.toString()].tScepterSpecials[j.toString()].sSpecialValue
						$.CreatePanel('Panel', $("#HeroScepterAbilityContainer"+sHeroNameCapital+i.toString()), "HeroScepterAbilityLine"+sHeroNameCapital+i.toString()+"special"+j.toString(),{class:"HeroScepterAbilityLine", id:"HeroScepterAbilityLine"+sHeroNameCapital+i.toString()+"special"+j.toString()})
						if (sSpecialName.substr(0,1) == "%") {
							var aSpecials = sSpecialValue.split("/")
							var sSpecialWithPercentage = ""
							for (var k = 0; k < aSpecials.length; k++) {
								sSpecialWithPercentage = sSpecialWithPercentage+aSpecials[k]+"%"
								if (aSpecials[k+1]) {sSpecialWithPercentage = sSpecialWithPercentage+"/"}
							}
							$.CreatePanel('Label', $("#HeroScepterAbilityLine"+sHeroNameCapital+i.toString()+'special'+j.toString()), "HeroScepterAbilitySpecialName"+sHeroNameCapital+i.toString()+"special"+j.toString(),{class:"HeroScepterAbilityTitleName", id:"HeroScepterAbilitySpecialName"+sHeroNameCapital+i.toString()+"special"+j.toString(), text:sSpecialName.substr(1)})
							$.CreatePanel('Label', $("#HeroScepterAbilityLine"+sHeroNameCapital+i.toString()+'special'+j.toString()), "HeroScepterAbilitySpecialValue"+sHeroNameCapital+i.toString()+"special"+j.toString(),{class:"HeroScepterAbilitySpecialValue", id:"HeroScepterAbilitySpecialValue"+sHeroNameCapital+i.toString()+"special"+j.toString(), text:sSpecialWithPercentage})
							
						}
						else{
							$.CreatePanel('Label', $("#HeroScepterAbilityLine"+sHeroNameCapital+i.toString()+'special'+j.toString()), "HeroScepterAbilitySpecialName"+sHeroNameCapital+i.toString()+"special"+j.toString(),{class:"HeroScepterAbilityTitleName", id:"HeroScepterAbilitySpecialName"+sHeroNameCapital+i.toString()+"special"+j.toString(), text:sSpecialName})
							$.CreatePanel('Label', $("#HeroScepterAbilityLine"+sHeroNameCapital+i.toString()+'special'+j.toString()), "HeroScepterAbilitySpecialValue"+sHeroNameCapital+i.toString()+"special"+j.toString(),{class:"HeroScepterAbilitySpecialValue", id:"HeroScepterAbilitySpecialValue"+sHeroNameCapital+i.toString()+"special"+j.toString(), text:sSpecialValue})
						}
						j = j+1
					}
				}
				i=i+1
			}
			var i = 1
			while (tFunHeroShardInfo[i.toString()]) {
				$.CreatePanel('Panel', $("#ScepterInfoHeroContainer"+sHeroNameCapital), "HeroShardAbilityContainer"+sHeroNameCapital+i.toString(),{class:"HeroScepterAbilityContainer", id:"HeroShardAbilityContainer"+sHeroNameCapital+i.toString()})
				$.CreatePanel('Panel', $("#HeroShardAbilityContainer"+sHeroNameCapital+i.toString()), "HeroShardAbilityLine"+sHeroNameCapital+i.toString(),{class:"HeroScepterAbilityLine", id:"HeroShardAbilityLine"+sHeroNameCapital+i.toString()})
				
				var sAbilityName = $.Localize("#DOTA_Tooltip_Ability_"+tFunHeroShardInfo[i.toString()].sAbilityName).toUpperCase()
				
				$.CreatePanel('Label', $("#HeroShardAbilityLine"+sHeroNameCapital+i.toString()), "HeroShardAbilityTitleUpgrade"+sHeroNameCapital+i.toString(),{class:"HeroScepterAbilityTitleUpgrade", id:"HeroShardAbilityTitleUpgrade"+sHeroNameCapital+i.toString(), text:"#Shard_info_title"})
				$.CreatePanel('Label', $("#HeroShardAbilityLine"+sHeroNameCapital+i.toString()), "HeroShardAbilityTitleName"+sHeroNameCapital+i.toString(),{class:"HeroScepterAbilityTitleName", id:"HeroShardAbilityTitleName"+sHeroNameCapital+i.toString(), text:sAbilityName})
				$.CreatePanel('Label', $("#HeroShardAbilityContainer"+sHeroNameCapital+i.toString()), "HeroShardAbilityDescription"+sHeroNameCapital+i.toString(),{class:"HeroScepterAbilityDescription", id:"HeroShardAbilityDescription"+sHeroNameCapital+i.toString(), text:"#DOTA_Tooltip_Ability_"+tFunHeroShardInfo[i.toString()].sAbilityName+"_shard_description"})
				if (tFunHeroShardInfo[i.toString()].tShardSpecials) {
					var j = 1
					while (tFunHeroShardInfo[i.toString()].tShardSpecials[j.toString()]) {
						var sSpecialName = $.Localize("#DOTA_Tooltip_ability_"+tFunHeroShardInfo[i.toString()].sAbilityName+"_"+tFunHeroShardInfo[i.toString()].tShardSpecials[j.toString()].sSpecialName)
						var sSpecialValue = tFunHeroShardInfo[i.toString()].tShardSpecials[j.toString()].sSpecialValue
						$.CreatePanel('Panel', $("#HeroShardAbilityContainer"+sHeroNameCapital+i.toString()), "HeroShardAbilityLine"+sHeroNameCapital+i.toString()+"special"+j.toString(),{class:"HeroScepterAbilityLine", id:"HeroShardAbilityLine"+sHeroNameCapital+i.toString()+"special"+j.toString()})
						if (sSpecialName.substr(0,1) == "%") {
							var aSpecials = sSpecialValue.split("/")
							var sSpecialWithPercentage = ""
							for (var k = 0; k < aSpecials.length; k++) {
								sSpecialWithPercentage = sSpecialWithPercentage+aSpecials[k]+"%"
								if (aSpecials[k+1]) {sSpecialWithPercentage = sSpecialWithPercentage+"/"}
							}
							$.CreatePanel('Label', $("#HeroShardAbilityLine"+sHeroNameCapital+i.toString()+'special'+j.toString()), "HeroShardAbilitySpecialName"+sHeroNameCapital+i.toString()+"special"+j.toString(),{class:"HeroScepterAbilityTitleName", id:"HeroShardAbilitySpecialName"+sHeroNameCapital+i.toString()+"special"+j.toString(), text:sSpecialName.substr(1)})
							$.CreatePanel('Label', $("#HeroShardAbilityLine"+sHeroNameCapital+i.toString()+'special'+j.toString()), "HeroShardAbilitySpecialValue"+sHeroNameCapital+i.toString()+"special"+j.toString(),{class:"HeroScepterAbilitySpecialValue", id:"HeroShardAbilitySpecialValue"+sHeroNameCapital+i.toString()+"special"+j.toString(), text:sSpecialWithPercentage})
							
						}
						else{
							$.CreatePanel('Label', $("#HeroShardAbilityLine"+sHeroNameCapital+i.toString()+'special'+j.toString()), "HeroShardAbilitySpecialName"+sHeroNameCapital+i.toString()+"special"+j.toString(),{class:"HeroScepterAbilityTitleName", id:"HeroShardAbilitySpecialName"+sHeroNameCapital+i.toString()+"special"+j.toString(), text:sSpecialName})
							$.CreatePanel('Label', $("#HeroShardAbilityLine"+sHeroNameCapital+i.toString()+'special'+j.toString()), "HeroShardAbilitySpecialValue"+sHeroNameCapital+i.toString()+"special"+j.toString(),{class:"HeroScepterAbilitySpecialValue", id:"HeroShardAbilitySpecialValue"+sHeroNameCapital+i.toString()+"special"+j.toString(), text:sSpecialValue})
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

function GetActualOffset(panel) {	
	var hud = panel
	var x = 0, y = 0
	while (hud.id != 'DotaHud')
	{
		x += hud.actualxoffset
		y += hud.actualyoffset
		hud = hud.GetParent()
	}
	return {'x':x, 'y':y}
}


function AghsStatusBlockerMouseOver(){
	$("#ScepterInfoContainer").visible = true
}
function AghsStatusBlockerMouseOut(){
	$("#ScepterInfoContainer").visible = false
}

function ScepterInfoButtonApply(keys) {
	if ((Entities.GetAbilityByName(Players.GetLocalPlayerPortraitUnit(), "invoker_retro_invoke") > 0 || 
	Entities.GetAbilityByName(Players.GetLocalPlayerPortraitUnit(), "hero_attribute_gain_manager") > 0 || 
	Entities.GetAbilityByName(Players.GetLocalPlayerPortraitUnit(), "ramza_go_back_lua") > 0 ) && tFunHeroInfo[Entities.GetUnitName(Players.GetLocalPlayerPortraitUnit()).substr(14)] && tFunHeroInfo[Entities.GetUnitName(Players.GetLocalPlayerPortraitUnit()).substr(14)].bHasScepterUpgrade) {
		// $("#ScepterInfoButton").visible = true
		$("#ScepterInfoContainer").visible = false
		$("#AghsStatusBlocker").visible = true
		var aghs_show = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse('AghsStatusContainer')
		var offset = GetActualOffset(aghs_show)
		var screen_width = Game.GetScreenWidth()
		var screen_height = Game.GetScreenHeight()
		// $.Msg("line", (offset.x/Game.GetScreenWidth()).toString())
		//avoiding error when init
		if (offset.x > screen_width) {
			offset.x = screen_width
		}
		if (offset.y > screen_height) {
			offset.y = screen_height
		}
		$("#AghsStatusBlocker").style.marginLeft = (offset.x/screen_width*100).toString()+'%'
		$("#AghsStatusBlocker").style.marginTop = (offset.y/screen_height*100).toString()+'%'
		$("#AghsStatusBlocker").style.width = (aghs_show.actuallayoutwidth/screen_width*100).toString()+'%'
		$("#AghsStatusBlocker").style.height = (aghs_show.actuallayoutheight/screen_height*100).toString()+'%'
		// $("#AghsStatusBlocker").style.visibility = 'visible'
	}
	else {
		$("#AghsStatusBlocker").visible = false
		// $("#ScepterInfoButton").visible = false
		$("#ScepterInfoContainer").visible = false
	}
}
ScepterInfo.Initialize()
 

GameEvents.Subscribe( "dota_player_update_selected_unit", ScepterInfoButtonApply);
GameEvents.Subscribe( "dota_player_update_query_unit", ScepterInfoButtonApply);














