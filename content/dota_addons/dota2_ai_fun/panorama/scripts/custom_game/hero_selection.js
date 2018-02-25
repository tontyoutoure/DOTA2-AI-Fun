"use strict";
var sActivatingPanel
var sSelectingPart
$("#HeroAvatarBtnWarlock").visible = true
var DOTA_ATTRIBUTE_STRENGTH = 0
var DOTA_ATTRIBUTE_AGILITY = 1
var DOTA_ATTRIBUTE_INTELLECT = 2

var tFunHeroNames = {
	"spirit_breaker":"astral_trekker",
	'shadow_demon': 'bastion',
	'treant': 'intimidator',
	'techies': 'persuasive',
	'night_stalker': 'void_demon',
	'tinker': 'terran_marine',
	'visage': 'magic_dragon',
	'arc_warden': 'mana_fiend',
	'wisp': 'formless',
	'beastmaster': 'fluid_engineer',
	'enigma': 'telekenetic_blob',
	'dragon_knight': 'ramza',
	'oracle': 'cleric',
	'windrunner': 'pet_summoner',
	'sven': 'felguard',
	'pugna': 'el_dorado',
	'disruptor': 'hurricane',
	'nevermore': 'capslockftw',
	'omniknight':'templar',
	'meepo':'spongebob',
	'tusk':'hamsterlord',
	'juggernaut':'exsoldier',
	'rubick':'gambler',
	'life_stealer':'old_lifestealer',
	'chaos_knight':'rider',
	'skywrath_mage':'siglos',
	'warlock':'flame_lord',
}
var tHeroNameCapitals = {
	"spirit_breaker":"SpiritBreaker",
	'shadow_demon': 'ShadowDemon',
	'treant': 'Treant',
	'techies': 'Techies',
	'night_stalker': 'NightStalker',
	'tinker': 'Tinker',
	'visage': 'Visage',
	'arc_warden': 'ArcWarden',
	'wisp': 'Wisp',
	'beastmaster': 'Beastmaster',
	'enigma': 'Enigma',
	'dragon_knight': 'DragonKnight',
	'oracle': 'Oracle',
	'windrunner': 'Windrunner',
	'sven': 'Sven',
	'pugna': 'Pugna',
	'disruptor': 'Disruptor',
	'nevermore': 'Nevermore',	
	'omniknight':'Omniknight',
	'meepo':'Meepo',
	'tusk':'Tusk',
	'juggernaut':'Juggernaut',
	'rubick':'Rubick',
	'life_stealer':'LifeStealer',
	'chaos_knight':'ChaosKnight',
	'skywrath_mage':'SkywrathMage',
	'warlock':'Warlock',
}

function HeroDescriptionInitAll(keys) {
	if (keys.PlayerID == Game.GetLocalPlayerID()) {
		for (var sHeroName in tHeroNameCapitals) {
			HeroDescriptionInit(tFunHeroNames[sHeroName], sHeroName, tHeroNameCapitals[sHeroName]);
		}
	}
	$("#HeroDescriptionContainer").visible = true;
	$("#HeroAvatarBtnRubick").visible = true;
}

function HeroDescriptionInit(sFunHeroName, sHeroName, sHeroNameCapital) {
	var tFunHeroAbilities = CustomNetTables.GetTableValue("fun_hero_abilities", sFunHeroName);
	var tFunHeroStats = CustomNetTables.GetTableValue("fun_hero_stats", sFunHeroName);
	var tFunHeroScepterInfo = CustomNetTables.GetTableValue("fun_hero_scepter_infos", sFunHeroName);
	$("#HeroDescriptionPopPanelContainer").BCreateChildren("<Panel id='HeroDescriptionPopPanel"+sHeroNameCapital+"' class = 'HeroDescriptionPopPanel' hittest='true'/>")
	var sPanelName = '#HeroDescriptionPopPanel'+sHeroNameCapital
	$(sPanelName).BCreateChildren('<Panel id="HeroNameLine'+sHeroNameCapital+'" class="HeroNameLine"/>')
	$("#HeroNameLine"+sHeroNameCapital).BCreateChildren('<Label id="HeroName'+sHeroNameCapital+'" class="HeroName" text="#npc_dota_hero_'+sHeroName+'_long"/>')
	$("#HeroNameLine"+sHeroNameCapital).BCreateChildren('<Panel id="HeroPrimaryAttribute'+sHeroNameCapital+'" class="HeroAttributeContainer"/>')
	if (tFunHeroStats.PrimaryAttribute == DOTA_ATTRIBUTE_STRENGTH) {
		$("#HeroPrimaryAttribute"+sHeroNameCapital).AddClass("HeroPrimaryAttributeStrength")
	}
	else if (tFunHeroStats.PrimaryAttribute == DOTA_ATTRIBUTE_AGILITY) {
		$("#HeroPrimaryAttribute"+sHeroNameCapital).AddClass("HeroPrimaryAttributeAgility")
	}
	else if (tFunHeroStats.PrimaryAttribute == DOTA_ATTRIBUTE_INTELLECT) {
		$("#HeroPrimaryAttribute"+sHeroNameCapital).AddClass("HeroPrimaryAttributeIntelligence")
	}
	else {
		$("#HeroPrimaryAttribute"+sHeroNameCapital).visible = false
	}
	
	
	$(sPanelName).BCreateChildren('<Label id="HeroBio'+sHeroNameCapital+'" class="HeroBio" text="#npc_dota_hero_'+sHeroName+'_bio"/>')	
	$(sPanelName).BCreateChildren('<Label class="HeroAbilityTitle" text="#DOTA_SHOP_CATEGORY_ABILITIES"/>')
	$(sPanelName).BCreateChildren('<Panel id="HeroAbilityContainer'+sHeroNameCapital+'" class="AbilityLine"/>')
	var aTalents = [];
	for (var i = 1; i < 24; i++) {
		if (tFunHeroAbilities[i.toString()]){
			if(tFunHeroAbilities[i.toString()].search("special_bonus") < 0 ){
				if (tFunHeroAbilities[i.toString()].search("generic_hidden") < 0) {
	//				$("#HeroAbilityContainer"+sHeroNameCapital).BCreateChildren('<DOTAAbilityImage id="Ability'+sHeroNameCapital+i.toString()+'" class="AbilityIcon" abilityname="'+tFunHeroAbilities[i.toString()]+'" onmouseover="DOTAShowAbilityTooltip('+tFunHeroAbilities[i.toString()]+')" onmouseout="DOTAHideAbilityTooltip()"/>')
					$("#HeroAbilityContainer"+sHeroNameCapital).BCreateChildren('<Panel id="AbilityIconContainer'+sHeroNameCapital+i.toString()+'" class="AbilityIconContainer"/>')
					$("#AbilityIconContainer"+sHeroNameCapital+i.toString()).BCreateChildren('<DOTAAbilityImage id="Ability'+sHeroNameCapital+i.toString()+'" class="AbilityIcon" abilityname="'+tFunHeroAbilities[i.toString()]+'" onmouseover="DOTAShowAbilityTooltip('+tFunHeroAbilities[i.toString()]+')" onmouseout="DOTAHideAbilityTooltip()"/>')
				}
			}
			else
			{
				aTalents.unshift(tFunHeroAbilities[i.toString()])
			}
		}
	} 
//	$("#HeroAbilityContainer"+sHeroNameCapital).BCreateChildren('<Panel id="Talent'+sHeroNameCapital+'" class="TalentBranch"/>')
	
	if (tFunHeroScepterInfo){
//		$.Msg(tFunHeroScepterInfo)
		$(sPanelName).BCreateChildren('<Panel class="HeroScepterInfoContainer" id="HeroScepterInfoContainer'+sHeroNameCapital+'"/>')
		var i = 1
		while (tFunHeroScepterInfo[i.toString()]) {
			$("#HeroScepterInfoContainer"+sHeroNameCapital).BCreateChildren('<Panel class="HeroScepterAbilityContainer" id="HeroScepterAbilityContainer'+sHeroNameCapital+i.toString()+'"/>')
			$("#HeroScepterAbilityContainer"+sHeroNameCapital+i.toString()).BCreateChildren('<Panel class="HeroScepterAbilityTitleContainer" id="HeroScepterAbilityTitleContainer'+sHeroNameCapital+i.toString()+'"/>')
			
			var sAbilityName = $.Localize("#DOTA_Tooltip_Ability_"+tFunHeroScepterInfo[i.toString()].sAbilityName).toUpperCase()
			$("#HeroScepterAbilityTitleContainer"+sHeroNameCapital+i.toString()).BCreateChildren('<Label class="HeroScepterAbilityTitleUpgrade" id="HeroScepterAbilityTitleUpgrade'+sHeroNameCapital+i.toString()+'" text="#scepter_info_title"/>')
			$("#HeroScepterAbilityTitleContainer"+sHeroNameCapital+i.toString()).BCreateChildren('<Label class="HeroScepterAbilityTitleName" id="HeroScepterAbilityTitleName'+sHeroNameCapital+i.toString()+'" text="'+sAbilityName+'"/>')
			$("#HeroScepterAbilityContainer"+sHeroNameCapital+i.toString()).BCreateChildren('<Label class="HeroScepterAbilityDescription" id="HeroScepterAbilityDescription'+sHeroNameCapital+i.toString()+'" text="#DOTA_Tooltip_Ability_'+tFunHeroScepterInfo[i.toString()].sAbilityName+'_aghanim_description"/>')
			i=i+1
		}
	}
	
	
	$(sPanelName).BCreateChildren('<Panel class="HeroTalentContainer" id="HeroTalentContainer'+sHeroNameCapital+'"/>')
//	$("#Talent"+sHeroNameCapital).SetPanelEvent("onmouseover", function (){$("#HeroTalentContainer"+sHeroNameCapital).visible=true})
//	$("#Talent"+sHeroNameCapital).SetPanelEvent("onmouseout", function (){$("#HeroTalentContainer"+sHeroNameCapital).visible=false})
	
	$("#HeroTalentContainer"+sHeroNameCapital).BCreateChildren('<Label class="HeroTalentTitle" text="#DOTA_AbilityBuild_Talent_Title"/>')
	var iTalent = 0
	for (var iLevel = 25; iLevel > 5; iLevel=iLevel-5) {
		$("#HeroTalentContainer"+sHeroNameCapital).BCreateChildren('<Panel class="HeroTalentLine" id="HeroTalentLine'+sHeroNameCapital+iLevel.toString()+'"/>')
		
		$("#HeroTalentLine"+sHeroNameCapital+iLevel.toString()).BCreateChildren('<Panel class="HeroTalentLeft" id="HeroTalentLeft'+sHeroNameCapital+iLevel.toString()+'"/>')
		$("#HeroTalentLeft"+sHeroNameCapital+iLevel.toString()).BCreateChildren('<Label class="HeroTalentContentLabel" text="#DOTA_Tooltip_ability_'+aTalents[iTalent++]+'"/>')		
		$("#HeroTalentLine"+sHeroNameCapital+iLevel.toString()).BCreateChildren('<Panel class="HeroTalentMiddle" id="HeroTalentMiddle'+sHeroNameCapital+iLevel.toString()+'"/>')
		$("#HeroTalentMiddle"+sHeroNameCapital+iLevel.toString()).BCreateChildren('<Label class="HeroTalentReqLabel" text="'+iLevel.toString()+'"/>')
		$("#HeroTalentLine"+sHeroNameCapital+iLevel.toString()).BCreateChildren('<Panel class="HeroTalentRight" id="HeroTalentRight'+sHeroNameCapital+iLevel.toString()+'"/>')
		$("#HeroTalentRight"+sHeroNameCapital+iLevel.toString()).BCreateChildren('<Label class="HeroTalentContentLabel" text="#DOTA_Tooltip_ability_'+aTalents[iTalent++]+'"/>')		
	}	
	
	$(sPanelName).BCreateChildren('<Button id="HeroSelection'+sHeroNameCapital+'" class="HeroSelectionButton" onactivate="HeroSelection(&quot;npc_dota_hero_'+sHeroName+'&quot;, &quot;'+sHeroNameCapital+'&quot;);"/>')
	$("#HeroSelection"+sHeroNameCapital).BCreateChildren('<Label id="HeroSelectionLabel" text="#select_hero"/>')
	$(sPanelName).BCreateChildren('<Button id="HeroUnselection'+sHeroNameCapital+'" class="HeroUnselectionButton" onactivate="HeroUnselection(&quot;npc_dota_hero_'+sHeroName+'&quot;, &quot;'+sHeroNameCapital+'&quot;);"/>')
	$("#HeroUnselection"+sHeroNameCapital).BCreateChildren('<Label id="HeroUnselectionLabel" text="#unselect_hero" />')
}

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

GameEvents.Subscribe( "player_connect_full", HeroDescriptionInitAll);