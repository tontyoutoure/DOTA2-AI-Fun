"use strict"; 
//Globals

//var PlayerTables = GameUI.CustomUIConfig().PlayerTables

var SELECT_JOB = 0;
var SELECT_SECONDARY_SKILL = 1;
var iPlayerID = Game.GetLocalPlayerID();
var bInitialized = false;
var tRamzaList = {}
//Main object
var RamzaJob = {};

RamzaJob.FetchNetTableConstants = function () {
	this.tJobNames = CustomNetTables.GetTableValue("ramza_job_names", iPlayerID.toString());
	this.tJobAbilities = CustomNetTables.GetTableValue("ramza_job_abilities", iPlayerID.toString());
	this.tInitJobRequirement = CustomNetTables.GetTableValue("ramza_init_job_requirement", iPlayerID.toString());
	this.tJobStats = CustomNetTables.GetTableValue("ramza_job_stats", iPlayerID.toString());

}

RamzaJob.FetchNetTableVariables = function() {
	this.tJobLevel = CustomNetTables.GetTableValue("ramza_job_level", iPlayerID.toString());
	this.iCurrnetJob = CustomNetTables.GetTableValue("ramza_current_job", iPlayerID.toString())["1"];
	this.iCurrnetSecondarySkill = CustomNetTables.GetTableValue("ramza_current_secondary_skill", iPlayerID.toString())["1"];
	this.tJobRequirement = CustomNetTables.GetTableValue("ramza_job_requirement", iPlayerID.toString());
}




RamzaJob.SelectJob = function () {
	if (!bInitialized) {
		$("#JobSelectionContainer").style.visibility = "collapse";
		RamzaJob.FetchNetTableConstants();			
		RamzaJob.InitializeDescription();
		bInitialized = true;
	}
	
	
	if ($("#JobSelectionContainer").style.visibility == 'collapse' || $("#ButtonToggleJob").style.visibility == "visible")	{
		
		this.FetchNetTableVariables();
		this.RenewJobLables()
		
		this.DescriptionUpdateLevel();
		
		
		$("#JobSelectionContainer").style.visibility = "visible";
		$("#ButtonToggleSecondarySkill").style.visibility = "visible";
		$("#ButtonToggleJob").style.visibility = "collapse";
		$("#JobContainerExample2").style.visibility = "collapse";
		this.iState = SELECT_JOB; 
		
		for (var i = 1; i < 21; i++) {
			if (this.tJobLevel[i.toString()] > 0)
				this.EnableJob(i);
		}
		this.DisableJob(this.iCurrnetJob, SELECT_JOB);
		if(this.iCurrnetJob == 18 || this.iCurrnetJob == 20) {
			$("#ToggleButtonContainer").style.visibility = 'collapse';
		}
		else {
			$("#ToggleButtonContainer").style.visibility = 'visible';
		}
	}
	else
		$("#JobSelectionContainer").style.visibility = "collapse";
	
}

RamzaJob.SelectSecondarySkill = function () {	
	if (!bInitialized) {
		$("#JobSelectionContainer").style.visibility = "collapse";
		RamzaJob.FetchNetTableConstants();			
		RamzaJob.InitializeDescription();
		bInitialized = true;
	}
	if ($("#JobSelectionContainer").style.visibility == 'collapse' || $("#ButtonToggleSecondarySkill").style.visibility == "visible")	{
		
		this.FetchNetTableVariables();
		this.RenewJobLables();
		this.DescriptionUpdateLevel();
		
		$("#JobSelectionContainer").style.visibility = "visible";
		$("#ButtonToggleSecondarySkill").style.visibility = "collapse";
		$("#ButtonToggleJob").style.visibility = "visible";
		$("#JobContainerExample2").style.visibility = "visible";
		this.iState = SELECT_SECONDARY_SKILL;
		
		for (var i = 1; i < 21; i++) {
			if (this.tJobLevel[i.toString()] > 0)
				this.EnableJob(i);
		}
		
		this.DisableJob(18);
		this.DisableJob(20);
		this.DisableJob(this.iCurrnetJob, SELECT_JOB);
		if (this.iCurrnetSecondarySkill > 0)
			this.DisableJob(this.iCurrnetSecondarySkill, SELECT_SECONDARY_SKILL);
	}
	else
		$("#JobSelectionContainer").style.visibility = "collapse";
}


RamzaJob.CloseSelector = function() {
	$("#JobSelectionContainer").style.visibility = "collapse";
} 

RamzaJob.EnableJob = function (iJob) {
	var sJobCoverUp = "#JobCoverUp"+iJob.toString();
	var sSelectJobButton = "#SelectJobButton"+iJob.toString();
	$(sJobCoverUp).style.visibility = 'collapse';
	$(sSelectJobButton).style.visibility = 'visible';
}

RamzaJob.DisableJob = function (iJob, iType) {
	var sJobCoverUp = "#JobCoverUp"+iJob.toString();
	var sSelectJobButton = "#SelectJobButton"+iJob.toString();	
	
	if ($(sJobCoverUp).BHasClass('JobCoverUpCurrentJob'))
		$(sJobCoverUp).RemoveClass('JobCoverUpCurrentJob');	
	if ($(sJobCoverUp).BHasClass('JobCoverUpCurrentSecondarySkill'))
		$(sJobCoverUp).RemoveClass('JobCoverUpCurrentSecondarySkill');
	
	if (iType == SELECT_JOB)
		$(sJobCoverUp).SetHasClass('JobCoverUpCurrentJob', true);
	if (iType == SELECT_SECONDARY_SKILL)
		$(sJobCoverUp).SetHasClass('JobCoverUpCurrentSecondarySkill', true);
	
	$(sJobCoverUp).style.visibility = 'visible';
	$(sSelectJobButton).style.visibility = 'collapse';	
}
/*
	<Panel id="JobLabelContainer1" class="JobLabelContainer">
		<Label id="JobLabelLevel1", class="JobLabelAvailable" />
		<Label id="JobLabelName1", class="JobLabelAvailable" />
	</Panel>
*/
RamzaJob.RenewJobLables = function () {
	var sJobContainer;
	var sJobLabelContainer;
	var sSelectJobButton;
	var sJobNameLabel;
	var sJobLevelLabel;
	for (var i = 1; i < 21; i++){
		sJobLabelContainer = "JobLabelContainer"+i.toString();
		sJobContainer = "JobContainer"+i.toString();
		sSelectJobButton = "SelectJobButton"+i.toString();
		sJobNameLabel = "JobNameLabel"+i.toString();
		sJobLevelLabel="JobLevelLabel"+i.toString();
		if (!$('#'+sJobLabelContainer)) {			
			$('#'+sJobContainer).BCreateChildren("<Panel id='"+sJobLabelContainer+"' class='JobLabelContainer' hittest='false' />");
			$('#'+sJobContainer).MoveChildBefore($('#'+sJobLabelContainer), $('#'+sSelectJobButton));
			$('#'+sJobLabelContainer).BCreateChildren("<Label id='"+sJobNameLabel+"' class='JobNameLabelUnavailable'/>");
			$('#'+sJobLabelContainer).BCreateChildren("<Label id='"+sJobLevelLabel+"' text='lv0' class='JobLevelLabelUnavailable'/>");	
			$('#'+sJobNameLabel).text=$.Localize('#'+this.tJobNames[i.toString()]);
			$('#'+sJobLevelLabel).text=$.Localize('#ramza_job_lv'+this.tJobLevel[i.toString()].toString());
		}
		if(this.tJobLevel[i.toString()] == 9) {
			$('#'+sJobLevelLabel).text=$.Localize('#ramza_job_lv'+this.tJobLevel[i.toString()].toString());
			if ($('#'+sJobNameLabel).BHasClass('JobNameLabelAvailable'))
				$('#'+sJobNameLabel).RemoveClass('JobNameLabelAvailable');
			if ($('#'+sJobLevelLabel).BHasClass('JobLevelLabelAvailable'))
				$('#'+sJobLevelLabel).RemoveClass('JobLevelLabelAvailable');
			$('#'+sJobNameLabel).SetHasClass('JobNameLabelMastered', true);
			$('#'+sJobLevelLabel).SetHasClass('JobLevelLabelMastered', true);
		}
		else if(this.tJobLevel[i.toString()] > 0) {
				$('#'+sJobLevelLabel).text=$.Localize('#ramza_job_lv'+this.tJobLevel[i.toString()].toString());
				$('#'+sJobNameLabel).SetHasClass('JobNameLabelAvailable', true);
				$('#'+sJobLevelLabel).SetHasClass('JobLevelLabelAvailable', true);
			}
		
	}
}

RamzaJob.ChangeJob = function (iJob) {
	GameEvents.SendCustomGameEventToServer( "ramza_change_job_client_to_server", { "iState" : this.iState.toString(), "iJob" : iJob.toString() } );
} 

RamzaJob.InitializeDescription = function() {
	$("#JobDescriptionContainer").style.visibility = "visible";
	var tLeftJobs = {
		ramza_job_squire: true,
		ramza_job_knight: true,
		ramza_job_archer: true,
		ramza_job_monk: true,
		ramza_job_thief: true,
		ramza_job_geomancer: true,
		ramza_job_dragoon: true,
		ramza_job_samurai: true,
		ramza_job_ninja: true,
		ramza_job_onion_knight: true
	};
	var tStrenthJobs = {
		ramza_job_samurai: true,
		ramza_job_geomancer: true,
		ramza_job_monk: true,
		ramza_job_squire: true,
		ramza_job_knight: true,
		ramza_job_dark_knight: true,
	};
	
	var tAgilityJobs = {
		ramza_job_archer: true,
		ramza_job_thief: true,
		ramza_job_dragoon: true,
		ramza_job_ninja: true,
		ramza_job_onion_knight: true
	};
	var sClass;
	var j;
	var k;
	var tJobLevelAbilities;
	var sJobLevelAbilities;
	var sDelimiter;
	var tSingleJobRequirement;
	for (var i = 20; i > 0; i--) {
		if (tLeftJobs[this.tJobNames[i.toString()]])
			sClass='JobDescriptionFlyoutRight';
		else
			sClass='JobDescriptionFlyoutLeft';
		$("#JobDescriptionContainer").BCreateChildren("<Panel id='JobDescriptionFlyout"+i.toString()+"'/>")
		$("#JobDescriptionFlyout"+i.toString()).SetHasClass(sClass, true);
		
		$("#JobDescriptionFlyout"+i.toString()).BCreateChildren("<Label id='JobDescriptionTitle"+i.toString()+"' class='JobDescriptionTitle' text='#"+this.tJobNames[i.toString()]+"'/>");
		$("#JobDescriptionFlyout"+i.toString()).BCreateChildren("<Label id='JobDescriptionLevel"+i.toString()+"'/>");
		$("#JobDescriptionFlyout"+i.toString()).BCreateChildren("<Label id='JobDescription"+i.toString()+"' class='JobDescription' text='#"+this.tJobNames[i.toString()]+"_description"+"'/>")
		if ($.Language() == 'english') 
			$("#JobDescription"+i.toString()).SetHasClass("JobDescriptionEnglish", true);
		$("#JobDescriptionFlyout"+i.toString()).BCreateChildren("<Panel id='JobStatRow"+i.toString()+"' class='JobStatRow' />")
			$("#JobStatRow"+i.toString()).BCreateChildren("<Panel id='JobStatKeyColumn"+i.toString()+"' class='JobStatColumn' />")
				$("#JobStatKeyColumn"+i.toString()).BCreateChildren("<Panel id='JobStatStrKeyColumnRow"+i.toString()+"' class='JobStatColumnRow' />")
				$("#JobStatStrKeyColumnRow"+i.toString()).BCreateChildren("<Label id='JobStatStrKey"+i.toString()+"' class='JobStatKey' text='#ramza_job_description_stat_str' />")
				$("#JobStatKeyColumn"+i.toString()).BCreateChildren("<Panel id='JobStatAgiKeyColumnRow"+i.toString()+"' class='JobStatColumnRow' />")
				$("#JobStatAgiKeyColumnRow"+i.toString()).BCreateChildren("<Label id='JobStatAgiKey"+i.toString()+"' class='JobStatKey' text='#ramza_job_description_stat_agi' />")
				$("#JobStatKeyColumn"+i.toString()).BCreateChildren("<Panel id='JobStatIntKeyColumnRow"+i.toString()+"' class='JobStatColumnRow' />")
				$("#JobStatIntKeyColumnRow"+i.toString()).BCreateChildren("<Label id='JobStatIntKey"+i.toString()+"' class='JobStatKey' text='#ramza_job_description_stat_int' />")
				$("#JobStatKeyColumn"+i.toString()).BCreateChildren("<Panel id='JobStatARKeyColumnRow"+i.toString()+"' class='JobStatColumnRow' />")
				$("#JobStatARKeyColumnRow"+i.toString()).BCreateChildren("<Label id='JobStatARKey"+i.toString()+"' class='JobStatKey' text='#ramza_job_description_stat_attack_range' />")
				$("#JobStatKeyColumn"+i.toString()).BCreateChildren("<Panel id='JobStatMSKeyColumnRow"+i.toString()+"' class='JobStatColumnRow' />")
				$("#JobStatMSKeyColumnRow"+i.toString()).BCreateChildren("<Label id='JobStatMSKey"+i.toString()+"' class='JobStatKey' text='#ramza_job_description_stat_move_speed' />")
			
			$("#JobStatRow"+i.toString()).BCreateChildren("<Panel id='JobStatValueColumn"+i.toString()+"' class='JobStatColumn' />")
				$("#JobStatValueColumn"+i.toString()).BCreateChildren("<Panel id='JobStatStrValueColumnRow"+i.toString()+"' class='JobStatColumnRow' />")
				$("#JobStatStrValueColumnRow"+i.toString()).BCreateChildren("<Label id='JobStatStrValue"+i.toString()+"' class='JobStatValue' text ='"+ this.tJobStats[i.toString()]["base_str"].toString()+'+'+this.tJobStats[i.toString()]["gain_str"].toFixed(1)+"'/>")
				$("#JobStatValueColumn"+i.toString()).BCreateChildren("<Panel id='JobStatAgiValueColumnRow"+i.toString()+"' class='JobStatColumnRow' />")
				$("#JobStatAgiValueColumnRow"+i.toString()).BCreateChildren("<Label id='JobStatAgiValue"+i.toString()+"' class='JobStatValue' text ='"+ this.tJobStats[i.toString()]["base_agi"].toString()+'+'+this.tJobStats[i.toString()]["gain_agi"].toFixed(1)+"'/>")
				$("#JobStatValueColumn"+i.toString()).BCreateChildren("<Panel id='JobStatIntValueColumnRow"+i.toString()+"' class='JobStatColumnRow' />")
				$("#JobStatIntValueColumnRow"+i.toString()).BCreateChildren("<Label id='JobStatIntValue"+i.toString()+"' class='JobStatValue' text ='"+ this.tJobStats[i.toString()]["base_int"].toString()+'+'+this.tJobStats[i.toString()]["gain_int"].toFixed(1)+"'/>")
				$("#JobStatValueColumn"+i.toString()).BCreateChildren("<Panel id='JobStatARValueColumnRow"+i.toString()+"' class='JobStatColumnRow' />")
				$("#JobStatARValueColumnRow"+i.toString()).BCreateChildren("<Label id='JobStatARValue"+i.toString()+"' class='JobStatValue' />")
				if (this.tJobStats[i.toString()]["attack_range"] > 150)
					$("#JobStatARValue"+i.toString()).text = this.tJobStats[i.toString()]["attack_range"].toString();
				else
					$("#JobStatARValue"+i.toString()).text = $.Localize('#ramza_job_description_meele')
				$("#JobStatValueColumn"+i.toString()).BCreateChildren("<Panel id='JobStatMSValueColumnRow"+i.toString()+"' class='JobStatColumnRow' />")
				$("#JobStatMSValueColumnRow"+i.toString()).BCreateChildren("<Label id='JobStatMSValue"+i.toString()+"' class='JobStatValue' text ='"+ this.tJobStats[i.toString()]["move_speed"].toString()+"'/>")
				switch (this.tJobStats[i.toString()]["primary_attribute"]) {
					case Attributes.DOTA_ATTRIBUTE_STRENGTH:
						$("#JobStatStrKey"+i.toString()).SetHasClass('RedFont', true);
						$("#JobStatStrValue"+i.toString()).SetHasClass('RedFont', true);
						break;
					case Attributes.DOTA_ATTRIBUTE_AGILITY:
						$("#JobStatAgiKey"+i.toString()).SetHasClass('GreenFont', true);
						$("#JobStatAgiValue"+i.toString()).SetHasClass('GreenFont', true);
						break;
					default:
						$("#JobStatIntKey"+i.toString()).SetHasClass('BluerFont', true);
						$("#JobStatIntValue"+i.toString()).SetHasClass('BluerFont', true);
				}
		$("#JobDescriptionFlyout"+i.toString()).BCreateChildren("<Label id='JobAbilityTitle"+i.toString()+"' class='JobAbilityTitle BlueFont'/>")
		$("#JobAbilityTitle"+i.toString()).text=$.Localize('#ramza_job_primary_ability')+$.Localize('#DOTA_Tooltip_ability_'+this.tJobNames[i.toString()]+'_JC');
		if( i == 18 || i == 20)
			$("#JobDescriptionFlyout"+i.toString()).BCreateChildren("<Label id='JobAbilityWarning"+i.toString()+"' class='JobAbilityWarning' text='#ramza_job_ability_warning'/>");
		$("#JobDescriptionFlyout"+i.toString()).BCreateChildren("<Panel id='JobAbilityRow"+i.toString()+"' class='JobStatRow' />")
			$("#JobAbilityRow"+i.toString()).BCreateChildren("<Panel id='JobAbilityKeyColumn"+i.toString()+"' class='JobStatColumn' />")
			$("#JobAbilityRow"+i.toString()).BCreateChildren("<Panel id='JobAbilityValueColumn"+i.toString()+"' class='JobStatColumn' />")		
			for (j = 1; j < 10; j++) {
				$("#JobAbilityKeyColumn"+i.toString()).BCreateChildren("<Panel id='JobAbilityKeyColumnRow"+i.toString()+"_"+j.toString()+"' class='JobStatColumnRow' />")
				$("#JobAbilityKeyColumnRow"+i.toString()+"_"+j.toString()).BCreateChildren("<Label id='JobAbilityKey"+i.toString()+"_"+j.toString()+"' class='JobStatKey GrayFont' text='#ramza_job_lv"+j.toString()+"' />")
				$("#JobAbilityValueColumn"+i.toString()).BCreateChildren("<Panel id='JobAbilityValueColumnRow"+i.toString()+"_"+j.toString()+"' class='JobStatColumnRow' />")
				$("#JobAbilityValueColumnRow"+i.toString()+"_"+j.toString()).BCreateChildren("<Label id='JobAbilityValue"+i.toString()+"_"+j.toString()+"' class='JobStatValue GrayFont'/>")
				tJobLevelAbilities=this.tJobAbilities[i.toString()][j.toString()];
				sJobLevelAbilities = "";
				sDelimiter = "";
				for (k in tJobLevelAbilities){
					sJobLevelAbilities = sJobLevelAbilities+sDelimiter+$.Localize('#DOTA_Tooltip_ability_'+tJobLevelAbilities[k]);
					sDelimiter = $.Localize("#ramza_job_delimiter")
				}
				$("#JobAbilityValue"+i.toString()+"_"+j.toString()).text = sJobLevelAbilities;
			}		
		$("#JobDescriptionFlyout"+i.toString()).BCreateChildren("<Label id='JobRequirementTitle"+i.toString()+"' class='JobRequirementTitle'/>")
		$("#JobRequirementTitle"+i.toString()).text=$.Localize('#ramza_job_requirement');
		$("#JobDescriptionFlyout"+i.toString()).BCreateChildren("<Panel id='JobRequirementRow"+i.toString()+"' class='JobStatRow' />")
		if(i == 1 || i == 2) {			
			$("#JobDescriptionFlyout"+i.toString()).BCreateChildren("<Label id='JobRequirementNone"+i.toString()+"' class='JobRequirementTitle'/>")
			$("#JobRequirementNone"+i.toString()).text=$.Localize('#ramza_job_requirement_none');
		}
		else {			
			$("#JobRequirementRow"+i.toString()).BCreateChildren("<Panel id='JobRequirementKeyColumn"+i.toString()+"' class='JobStatColumn' />")
			$("#JobRequirementRow"+i.toString()).BCreateChildren("<Panel id='JobRequirementValueColumn"+i.toString()+"' class='JobStatColumn' />")
				tSingleJobRequirement=this.tInitJobRequirement[i.toString()]
				for (k in tSingleJobRequirement) {					
					$("#JobRequirementKeyColumn"+i.toString()).BCreateChildren("<Panel id='JobRequirementKeyColumnRow"+i.toString()+"_"+k.toString()+"' class='JobStatColumnRow' />")
					$("#JobRequirementKeyColumnRow"+i.toString()+"_"+k.toString()).BCreateChildren("<Label id='JobRequirementKey"+i.toString()+"_"+k+"' class='JobStatKey RedFont' text='#"+this.tJobNames[k]+"' />");
					$("#JobRequirementValueColumn"+i.toString()).BCreateChildren("<Panel id='JobRequirementValueColumnRow"+i.toString()+"_"+k.toString()+"' class='JobStatColumnRow' />")
					$("#JobRequirementValueColumnRow"+i.toString()+"_"+k.toString()).BCreateChildren("<Label id='JobRequirementValue"+i.toString()+"_"+k+"' class='JobStatValue RedFont' text='#ramza_job_lv"+tSingleJobRequirement[k]+"' />");
				}
					
		}
	}
}

RamzaJob.DescriptionUpdateLevel = function() {
	for (var i = 1; i < 21; i++) {		
		$("#JobDescriptionLevel"+i.toString()).text = $.Localize('#ramza_job_lv'+this.tJobLevel[i.toString()].toString());
		if ($("#JobDescriptionLevel"+i.toString()).BHasClass('JobDescriptionLevelLabel0'))
			$("#JobDescriptionLevel"+i.toString()).RemoveClass('JobDescriptionLevelLabel0');
		if ($("#JobDescriptionLevel"+i.toString()).BHasClass('JobDescriptionLevelLabel18'))
			$("#JobDescriptionLevel"+i.toString()).RemoveClass('JobDescriptionLevelLabel18');
		if ($("#JobDescriptionLevel"+i.toString()).BHasClass('JobDescriptionLevelLabel9'))
			$("#JobDescriptionLevel"+i.toString()).RemoveClass('JobDescriptionLevelLabel9');
		if(this.tJobLevel[i.toString()]==0)		
			$("#JobDescriptionLevel"+i.toString()).AddClass('JobDescriptionLevelLabel0');
		else if (this.tJobLevel[i.toString()]==9)
			$("#JobDescriptionLevel"+i.toString()).AddClass('JobDescriptionLevelLabel9');
		else		
			$("#JobDescriptionLevel"+i.toString()).AddClass('JobDescriptionLevelLabel18');
		
		for ( var j = 1; j <= this.tJobLevel[i.toString()]; j++) {
			if((j == 3||j == 5||j == 7)&& i != 18 && i != 20) {
				$("#JobAbilityKey"+i.toString()+"_"+j.toString()).RemoveClass('GrayFont')
				$("#JobAbilityValue"+i.toString()+"_"+j.toString()).RemoveClass('GrayFont')
				$("#JobAbilityKey"+i.toString()+"_"+j.toString()).SetHasClass('GreenFont', true)
				$("#JobAbilityValue"+i.toString()+"_"+j.toString()).SetHasClass('GreenFont', true)
			}
			else {
				$("#JobAbilityKey"+i.toString()+"_"+j.toString()).RemoveClass('GrayFont')
				$("#JobAbilityValue"+i.toString()+"_"+j.toString()).RemoveClass('GrayFont')
				$("#JobAbilityKey"+i.toString()+"_"+j.toString()).SetHasClass('BlueFont', true)
				$("#JobAbilityValue"+i.toString()+"_"+j.toString()).SetHasClass('BlueFont', true)
			}
		}			
		
		
		
		var tJobRequirementSingle;
		var k;
		if(i != 1 && i != 2){
			tJobRequirementSingle = this.tJobRequirement[i.toString()]
			for (k in tJobRequirementSingle) {
				if (tJobRequirementSingle[k] == 1){
					$("#JobRequirementKey"+i.toString()+'_'+k).SetHasClass('LightGreenFont', true);
					$("#JobRequirementValue"+i.toString()+'_'+k).SetHasClass('LightGreenFont', true);
				}
			}
		}
	}
}


RamzaJob.ShowDescription = function(iJob) {
	for (var i = 20; i > 0; i--) {
		if (i == iJob)
			$('#JobDescriptionFlyout'+iJob.toString()).style.visibility = 'visible';
		else			
			$('#JobDescriptionFlyout'+i.toString()).style.visibility = 'collapse';
	}
}

RamzaJob.HideDescription = function(iJob) {
	$('#JobDescriptionFlyout'+iJob.toString()).style.visibility = 'collapse';
}


//Listeners

function RamzaSelectJobListener(keys) {
	if (keys.iHeroEntityIndex == Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer())) {
		RamzaJob.SelectJob()
	};
}

function RamzaSelectSecondarySkillListener(keys) {
	if (keys.iHeroEntityIndex == Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer())) {
		RamzaJob.SelectSecondarySkill()
	};
}

function RamzaCloseSelectionListener(keys) {
	if (keys.iHeroEntityIndex == Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer())) {
		$("#JobSelectionContainer").style.visibility = "collapse";
	};	
}

function RamzaPortraitApply(keys) {
	if (CustomNetTables.GetTableValue("ramza_list", (Players.GetLocalPlayerPortraitUnit()).toString())) {
		$('#RamzaPortraitContainer').style.visibility = 'visible';
		if(Entities.IsAlive(Players.GetLocalPlayerPortraitUnit())) {
			$("#RamzaPortraitDeath").style.visibility = 'collapse';
			$("#RamzaPortrait").RemoveClass('BottomMargin50px');
		}
		else {
			$("#RamzaPortraitDeath").style.visibility = 'visible';
			$("#RamzaPortrait").AddClass('BottomMargin50px');
		}
	}
	else
	{
		$('#RamzaPortraitContainer').style.visibility = 'collapse';
	}
}

function UpdateRamzaDeath(keys) {	
	if(Entities.IsAlive(Players.GetLocalPlayerPortraitUnit())) {
		$("#RamzaPortraitDeath").style.visibility = 'collapse';
		$("#RamzaPortrait").RemoveClass('BottomMargin50px');
	}
	else {
		$("#RamzaPortraitDeath").style.visibility = 'visible';
		$("#RamzaPortrait").AddClass('BottomMargin50px');
	}
}

GameEvents.Subscribe( "ramza_select_job", RamzaSelectJobListener);
GameEvents.Subscribe( "ramza_select_secondary_skill", RamzaSelectSecondarySkillListener);
GameEvents.Subscribe( "ramza_close_selection", RamzaCloseSelectionListener)
GameEvents.Subscribe( "dota_player_update_selected_unit", RamzaPortraitApply);
GameEvents.Subscribe( "dota_player_update_query_unit", RamzaPortraitApply);
GameEvents.Subscribe( "dota_player_update_killcam_unit", UpdateRamzaDeath);