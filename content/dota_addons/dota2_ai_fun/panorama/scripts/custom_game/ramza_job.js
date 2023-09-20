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
	this.tJobNames = CustomNetTables.GetTableValue("ramza", "job_names");
	this.tJobAbilities = CustomNetTables.GetTableValue("ramza", "job_abilities");
	this.tInitJobRequirement = CustomNetTables.GetTableValue("ramza", "init_job_requirement");
	this.tJobStats = CustomNetTables.GetTableValue("ramza", "job_stats");

}

RamzaJob.FetchNetTableVariables = function() {
	this.tJobLevel = CustomNetTables.GetTableValue("ramza", "job_level_"+iPlayerID.toString());
	this.iCurrnetJob = CustomNetTables.GetTableValue("ramza", "current_job_"+iPlayerID.toString())["1"];
	this.iCurrnetSecondarySkill = CustomNetTables.GetTableValue("ramza", "current_secondary_skill_"+iPlayerID.toString())["1"];
	this.tJobRequirement = CustomNetTables.GetTableValue("ramza", "job_requirement_"+iPlayerID.toString());
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
		if(this.iCurrnetJob == 18 || (this.iCurrnetJob == 20 && !this.bTalentedOnion)) {
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
			$.CreatePanel('Panel', $('#'+sJobContainer), sJobLabelContainer,{id:sJobLabelContainer, class:'JobLabelContainer', hittest:'false' });
			$('#'+sJobContainer).MoveChildBefore($('#'+sJobLabelContainer), $('#'+sSelectJobButton));
			$.CreatePanel('Label', $('#'+sJobLabelContainer), sJobNameLabel,{id:sJobNameLabel, class:'JobNameLabelUnavailable'});
			$.CreatePanel('Label', $('#'+sJobLabelContainer), sJobLevelLabel,{id:sJobLevelLabel, text:'lv0', class:'JobLevelLabelUnavailable'});
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
		$.CreatePanel('Panel', $("#JobDescriptionContainer"), "JobDescriptionFlyout"+i.toString(),{id:"JobDescriptionFlyout"+i.toString()})
		$("#JobDescriptionFlyout"+i.toString()).SetHasClass(sClass, true);
		
		$.CreatePanel('Label', $("#JobDescriptionFlyout"+i.toString()), "JobDescriptionTitle"+i.toString(),{id:"JobDescriptionTitle"+i.toString(), class:'JobDescriptionTitle', text:"#"+this.tJobNames[i.toString()]});
		$.CreatePanel('Label', $("#JobDescriptionFlyout"+i.toString()), "JobDescriptionLevel"+i.toString(),{id:"JobDescriptionLevel"+i.toString()});
		$.CreatePanel('Label', $("#JobDescriptionFlyout"+i.toString()), "JobDescription"+i.toString(),{id:"JobDescription"+i.toString(), class:'JobDescription', text:"#"+this.tJobNames[i.toString()]+"_description"})
		if ($.Language() == 'english') 
			$("#JobDescription"+i.toString()).SetHasClass("JobDescriptionEnglish", true);
		$.CreatePanel('Panel', $("#JobDescriptionFlyout"+i.toString()), "JobStatRow"+i.toString(),{id:"JobStatRow"+i.toString(), class:'JobStatRow' })
			$.CreatePanel('Panel', $("#JobStatRow"+i.toString()), "JobStatKeyColumn"+i.toString(),{id:"JobStatKeyColumn"+i.toString(), class:'JobStatColumn' })
				$.CreatePanel('Panel', $("#JobStatKeyColumn"+i.toString()), "JobStatStrKeyColumnRow"+i.toString(),{id:"JobStatStrKeyColumnRow"+i.toString(), class:'JobStatColumnRow' })
				$.CreatePanel('Label', $("#JobStatStrKeyColumnRow"+i.toString()), "JobStatStrKey"+i.toString(),{id:"JobStatStrKey"+i.toString(), class:'JobStatKey', text:'#ramza_job_description_stat_str' })
				$.CreatePanel('Panel', $("#JobStatKeyColumn"+i.toString()), "JobStatAgiKeyColumnRow"+i.toString(),{id:"JobStatAgiKeyColumnRow"+i.toString(), class:'JobStatColumnRow' })
				$.CreatePanel('Label', $("#JobStatAgiKeyColumnRow"+i.toString()), "JobStatAgiKey"+i.toString(),{id:"JobStatAgiKey"+i.toString(), class:'JobStatKey', text:'#ramza_job_description_stat_agi' })
				$.CreatePanel('Panel', $("#JobStatKeyColumn"+i.toString()), "JobStatIntKeyColumnRow"+i.toString(),{id:"JobStatIntKeyColumnRow"+i.toString(), class:'JobStatColumnRow' })
				$.CreatePanel('Label', $("#JobStatIntKeyColumnRow"+i.toString()), "JobStatIntKey"+i.toString(),{id:"JobStatIntKey"+i.toString(), class:'JobStatKey', text:'#ramza_job_description_stat_int' })
				$.CreatePanel('Panel', $("#JobStatKeyColumn"+i.toString()), "JobStatARKeyColumnRow"+i.toString(),{id:"JobStatARKeyColumnRow"+i.toString(), class:'JobStatColumnRow' })
				$.CreatePanel('Label', $("#JobStatARKeyColumnRow"+i.toString()), "JobStatARKey"+i.toString(),{id:"JobStatARKey"+i.toString(), class:'JobStatKey', text:'#ramza_job_description_stat_attack_range' })
				$.CreatePanel('Panel', $("#JobStatKeyColumn"+i.toString()), "JobStatMSKeyColumnRow"+i.toString(),{id:"JobStatMSKeyColumnRow"+i.toString(), class:'JobStatColumnRow' })
				$.CreatePanel('Label', $("#JobStatMSKeyColumnRow"+i.toString()), "JobStatMSKey"+i.toString(),{id:"JobStatMSKey"+i.toString(), class:'JobStatKey', text:'#ramza_job_description_stat_move_speed' })
			
			$.CreatePanel('Panel', $("#JobStatRow"+i.toString()), "JobStatValueColumn"+i.toString(),{id:"JobStatValueColumn"+i.toString(), class:'JobStatColumn' })
				$.CreatePanel('Panel', $("#JobStatValueColumn"+i.toString()), "JobStatStrValueColumnRow"+i.toString(),{id:"JobStatStrValueColumnRow"+i.toString(), class:'JobStatColumnRow' })
				$.CreatePanel('Label', $("#JobStatStrValueColumnRow"+i.toString()), "JobStatStrValue"+i.toString(),{id:"JobStatStrValue"+i.toString(), class:'JobStatValue', text: this.tJobStats[i.toString()]["base_str"].toString()+"+"+this.tJobStats[i.toString()]["gain_str"].toFixed(1)})
				$.CreatePanel('Panel', $("#JobStatValueColumn"+i.toString()), "JobStatAgiValueColumnRow"+i.toString(),{id:"JobStatAgiValueColumnRow"+i.toString(), class:'JobStatColumnRow' })
				$.CreatePanel('Label', $("#JobStatAgiValueColumnRow"+i.toString()), "JobStatAgiValue"+i.toString(),{id:"JobStatAgiValue"+i.toString(), class:'JobStatValue', text: this.tJobStats[i.toString()]["base_agi"].toString()+"+"+this.tJobStats[i.toString()]["gain_agi"].toFixed(1)})
				$.CreatePanel('Panel', $("#JobStatValueColumn"+i.toString()), "JobStatIntValueColumnRow"+i.toString(),{id:"JobStatIntValueColumnRow"+i.toString(), class:'JobStatColumnRow' })
				$.CreatePanel('Label', $("#JobStatIntValueColumnRow"+i.toString()), "JobStatIntValue"+i.toString(),{id:"JobStatIntValue"+i.toString(), class:'JobStatValue', text: this.tJobStats[i.toString()]["base_int"].toString()+"+"+this.tJobStats[i.toString()]["gain_int"].toFixed(1)})
				$.CreatePanel('Panel', $("#JobStatValueColumn"+i.toString()), "JobStatARValueColumnRow"+i.toString(),{id:"JobStatARValueColumnRow"+i.toString(), class:'JobStatColumnRow' })
				$.CreatePanel('Label', $("#JobStatARValueColumnRow"+i.toString()), "JobStatARValue"+i.toString(),{id:"JobStatARValue"+i.toString(), class:'JobStatValue' })
				if (this.tJobStats[i.toString()]["attack_range"] > 150)
					$("#JobStatARValue"+i.toString()).text = this.tJobStats[i.toString()]["attack_range"].toString();
				else
					$("#JobStatARValue"+i.toString()).text = $.Localize('#ramza_job_description_meele')
				$.CreatePanel('Panel', $("#JobStatValueColumn"+i.toString()), "JobStatMSValueColumnRow"+i.toString(),{id:"JobStatMSValueColumnRow"+i.toString(), class:'JobStatColumnRow' })
				$.CreatePanel('Label', $("#JobStatMSValueColumnRow"+i.toString()), "JobStatMSValue"+i.toString(),{id:"JobStatMSValue"+i.toString(), class:'JobStatValue', text: this.tJobStats[i.toString()]["move_speed"].toString()})
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
		$.CreatePanel('Label', $("#JobDescriptionFlyout"+i.toString()), "JobAbilityTitle"+i.toString(),{id:"JobAbilityTitle"+i.toString(), class:'JobAbilityTitle BlueFont'})
		$("#JobAbilityTitle"+i.toString()).text=$.Localize('#ramza_job_primary_ability')+$.Localize('#DOTA_Tooltip_ability_'+this.tJobNames[i.toString()]+'_JC');
		if( i == 18|| i == 20) {
			$.CreatePanel('Label', $("#JobDescriptionFlyout"+i.toString()), "JobAbilityWarning"+i.toString(),{id:"JobAbilityWarning"+i.toString(), class:'JobAbilityWarning', text:'#ramza_job_ability_warning'});
		}
		$.CreatePanel('Panel', $("#JobDescriptionFlyout"+i.toString()), "JobAbilityRow"+i.toString(),{id:"JobAbilityRow"+i.toString(), class:'JobStatRow' })
			$.CreatePanel('Panel', $("#JobAbilityRow"+i.toString()), "JobAbilityKeyColumn"+i.toString(),{id:"JobAbilityKeyColumn"+i.toString(), class:'JobStatColumn' })
			$.CreatePanel('Panel', $("#JobAbilityRow"+i.toString()), "JobAbilityValueColumn"+i.toString(),{id:"JobAbilityValueColumn"+i.toString(), class:'JobStatColumn' })
			for (j = 1; j < 10; j++) {
				$.CreatePanel('Panel', $("#JobAbilityKeyColumn"+i.toString()), "JobAbilityKeyColumnRow"+i.toString()+"_"+j.toString(),{id:"JobAbilityKeyColumnRow"+i.toString()+"_"+j.toString(), class:'JobStatColumnRow' })
				$.CreatePanel('Label', $("#JobAbilityKeyColumnRow"+i.toString()+"_"+j.toString()), "JobAbilityKey"+i.toString()+"_"+j.toString(),{id:"JobAbilityKey"+i.toString()+"_"+j.toString(), class:'JobStatKey GrayFont', text:"#ramza_job_lv"+j.toString() })
				$.CreatePanel('Panel', $("#JobAbilityValueColumn"+i.toString()), "JobAbilityValueColumnRow"+i.toString()+"_"+j.toString(),{id:"JobAbilityValueColumnRow"+i.toString()+"_"+j.toString(), class:'JobStatColumnRow' })
				$.CreatePanel('Label', $("#JobAbilityValueColumnRow"+i.toString()+"_"+j.toString()), "JobAbilityValue"+i.toString()+"_"+j.toString(),{id:"JobAbilityValue"+i.toString()+"_"+j.toString(), class:'JobStatValue GrayFont'})
				tJobLevelAbilities=this.tJobAbilities[i.toString()][j.toString()];
				sJobLevelAbilities = "";
				sDelimiter = "";
				for (k in tJobLevelAbilities){
					sJobLevelAbilities = sJobLevelAbilities+sDelimiter+$.Localize('#DOTA_Tooltip_ability_'+tJobLevelAbilities[k]);
					sDelimiter = $.Localize("#ramza_job_delimiter")
				}
				$("#JobAbilityValue"+i.toString()+"_"+j.toString()).text = sJobLevelAbilities;
			}		
		$.CreatePanel('Label', $("#JobDescriptionFlyout"+i.toString()), "JobRequirementTitle"+i.toString(),{id:"JobRequirementTitle"+i.toString(), class:'JobRequirementTitle'})
		$("#JobRequirementTitle"+i.toString()).text=$.Localize('#ramza_job_requirement');
		$.CreatePanel('Panel', $("#JobDescriptionFlyout"+i.toString()), "JobRequirementRow"+i.toString(),{id:"JobRequirementRow"+i.toString(), class:'JobStatRow' })
		if(i == 1 || i == 2) {			
			$.CreatePanel('Label', $("#JobDescriptionFlyout"+i.toString()), "JobRequirementNone"+i.toString(),{id:"JobRequirementNone"+i.toString(), class:'JobRequirementTitle'})
			$("#JobRequirementNone"+i.toString()).text=$.Localize('#ramza_job_requirement_none');
		}
		else {			
			$.CreatePanel('Panel', $("#JobRequirementRow"+i.toString()), "JobRequirementKeyColumn"+i.toString(),{id:"JobRequirementKeyColumn"+i.toString(), class:'JobStatColumn' })
			$.CreatePanel('Panel', $("#JobRequirementRow"+i.toString()), "JobRequirementValueColumn"+i.toString(),{id:"JobRequirementValueColumn"+i.toString(), class:'JobStatColumn' })
				tSingleJobRequirement=this.tInitJobRequirement[i.toString()]
				for (k in tSingleJobRequirement) {					
					$.CreatePanel('Panel', $("#JobRequirementKeyColumn"+i.toString()), "JobRequirementKeyColumnRow"+i.toString()+"_"+k.toString(),{id:"JobRequirementKeyColumnRow"+i.toString()+"_"+k.toString(), class:'JobStatColumnRow' })
					$.CreatePanel('Label', $("#JobRequirementKeyColumnRow"+i.toString()+"_"+k.toString()), "JobRequirementKey"+i.toString()+"_"+k,{id:"JobRequirementKey"+i.toString()+"_"+k, class:'JobStatKey RedFont', text:"#"+this.tJobNames[k] });
					$.CreatePanel('Panel', $("#JobRequirementValueColumn"+i.toString()), "JobRequirementValueColumnRow"+i.toString()+"_"+k.toString(),{id:"JobRequirementValueColumnRow"+i.toString()+"_"+k.toString(), class:'JobStatColumnRow' })
					$.CreatePanel('Label', $("#JobRequirementValueColumnRow"+i.toString()+"_"+k.toString()), "JobRequirementValue"+i.toString()+"_"+k,{id:"JobRequirementValue"+i.toString()+"_"+k, class:'JobStatValue RedFont', text:"#ramza_job_lv"+tSingleJobRequirement[k] });
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

function UpdateRamzaDeath(keys) {	
}
function RamzaAbilityLearnedListener(keys) {
	if (keys.PlayerID == Players.GetLocalPlayer()&&keys.abilityname=='special_bonus_ramza_4') {
		RamzaJob.bTalentedOnion = true;
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('JobAbilityWarning20').text=$.Localize('#ramza_job_ability_warning2');
	}
}
GameEvents.Subscribe( "dota_player_learned_ability", RamzaAbilityLearnedListener);
GameEvents.Subscribe( "ramza_select_job", RamzaSelectJobListener);
GameEvents.Subscribe( "ramza_select_secondary_skill", RamzaSelectSecondarySkillListener);
GameEvents.Subscribe( "ramza_close_selection", RamzaCloseSelectionListener)
GameEvents.Subscribe( "dota_player_update_killcam_unit", UpdateRamzaDeath);