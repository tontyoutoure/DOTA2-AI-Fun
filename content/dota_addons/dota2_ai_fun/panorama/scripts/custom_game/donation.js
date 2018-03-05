"use strict"; 
var Donation = {};
var bInitialized = false;
var iCurrentTab = 0;
var aCurrentColor = [[-1, -1, -1], [-1, -1, -1], [-1, -1, -1], [-1, -1, -1]]
var aCurrentEffect = [-1, -1, -1, -1]

Donation.aEyeParticles = [2, 3, 4, 5, 8]
Donation.tColorIndex = {
	'#d03d33': 0,
	'#d11fa1': 1,
	'#cfab31': 2,
	'#0097ce': 3,
	'#8232cf': 4,
	'#d07733': 5,
	'#b7cf33': 6,
	'#3d68c4': 7,
	'#4ab78d': 8,
	'#51b350': 9,
	'#37864d': 10,
	'#8232ed': 11,
	'#a1ff59': 12,
	'#94cad0': 13,
	'#ffeebc': 14,
	'#ff4200': 15,
	'#dcf2ff': 16,
	'#d76092': 17,
	'#1a3d85': 18,
	'#060606': 19,
	'#626e5b': 20,
	'#507dfe': 21,
	'#15a515': 22,
	'#ffca15': 23,
	'#5ac355': 24,
	'#ffc604': 25,
	'#f79d00': 26,
	'#bdb76b': 27,
	'#7b68ee': 28,
	'#bcddb3': 29,
	'#f0e68c': 30,
	'#808000': 31,
	'#191970': 32,
	'#c0c0c0': 33,
	'#d5e3f5': 34,
	'#ca0123': 35,
	'#ff3c28': 36,
	'#ff7832': 37,
	'#32abdc': 38,
	'#ffc1dc': 39,
	'#7f48c3': 40,
	'#ffaf00': 41,
}

Donation.aEtherealParticles = [
	[15, "EF"],
	[16, "RE"],
	[17, "LG", true],
	[18, "SE", true],
	[19, "BA", true],
	[20, "PB", true],
	[21, "FB"],
	[22, "AoV"],
	[31, "ToC", true],
	[32, "SF"],
	[37, "CA2012"],
	[46, "DC"],
	[47, "ToM"],
	[57, "FF"],
	[61, "TotLB"],
	[68, "CR"],
	[73, "CE"],
	[74, "DE"],
	[76, "TotA"],
	[96, "ToBD"],
	[109, "CA2013"],
	[129, "RS"],
	[138, "EE"],
	[155, "DB"],
	[156, "SoEm"],
	[157, "SoEa"],
	[158, "OD"],
	[159, "BH"],
	[163, "IV"],
	[185, "NBC"],
	[196, "BR"],
	[205, "ToFr"],
	[206, "Tofl"],
	[268, "CA2014"],
]

Donation.aPrismaticColors = [
	["UnusualRed", 208,61,51],
	["UnusualRubiline", 209,31,161],
	["UnusualGold", 207,171,49],
	["UnusualBlue", 0,151,206],
	["UnusualPurple", 130,50,207],
	["UnusualOrange", 208,119,51],
	["UnusualLightGreen", 183,207,51],
	["UnusualDeepBlue", 61,104,196],
	["UnusualSeaGreen", 74,183,141],
	["UnusualVerdantGreen", 81,179,80],
	["UnusualDeepGreen", 55,134,77],
	["UnusualBrightPurple", 130,50,237],
	["UnusualBrightGreen", 161,255,89],
	["UnusualPlacidBlue", 148,202,208],
	["UnusualSummerWarmth", 255,238,188],
	["UnusualDefensiveRed", 255,66,0],
	["UnusualCreatorsLight", 220,242,255],
	["UnusualBlossomRed", 215,96,146],
	["UnusualCrystallineBlue", 26,61,133],
	["UnusualCursedBlack", 6,6,6],
	["UnusualPlagueGrey", 98,110,91],
	["UnusualInternational2012", 80,125,254],
	["UnusualInternational2013", 21,165,21],
	["UnusualMidasGold", 255,202,21],
	["UnusualEarthGreen", 90,195,85],
	["UnusualEmberFlame", 255,198,4],
	["UnusualDiretideOrange", 247,157,0],
	["UnusualDredgeEarth", 189,183,107],
	["UnusualDungeonDoom", 123,104,238],
	["UnusualMannsMint", 188,221,179],
	["UnusualBusinessPants", 240,230,140],
	["UnusualUnhallowedGround", 128,128,0],
	["UnusualShips", 25,25,112],
	["UnusualMiasma", 192,192,192],
	["UnusualPristinePlatinum", 213,227,245],
	["UnusualVermilionRenewal", 202,1,35],
	["UnusualAbysm", 255,60,40],
	["UnusualLavaRoshan", 255,120,50],
	["UnusualIceRoshan", 50,171,220],
	["UnusualPlushShagbark", 255,193,220],
	["UnusualInternational2014", 127,72,195],
	["UnusualSwine", 255,175,0],
]
$("#DonationButton").visible=true
$("#DonationTabEffect").visible=false

Donation.OnDonationActive = function () {
	if (!bInitialized) {
		this.Initialize()
	}
	if ($("#DonationContentContainer").visible ) {
		$("#DonationContentContainer").visible = false;
	}
	else {
		$("#DonationContentContainer").visible = true;
		if(iCurrentTab == 2) {
			$("#BottomButtonEmblem").visible = true;
		}
		else {
			$("#BottomButtonEmblem").visible = false;
		}
	}
}


Donation.Initialize = function() {
	var hPanel
	$("#DonationTabEffect").BCreateChildren("<Panel class='TitleContainer' id='TitleContainerEthereal' />")
	$("#TitleContainerEthereal").BCreateChildren("<Label id='EtherealTitle' text='#Econ_Socket_Empty_Effect'/>")
	for (var i = 0; i < 6; i++) {
		$("#DonationTabEffect").BCreateChildren("<Panel class='DonationTabRow' id='DonationTabRowEthereal"+(i).toString()+"' />")
		for (var j = 0; j < 6; j++) {
			if ((i*6+j) < this.aEtherealParticles.length) {
				$("#DonationTabRowEthereal"+(i).toString()).BCreateChildren("<Label class='GemButton' id='GemButtonEthereal"+(i*6+j).toString()+"' onactivate='Donation.OnEffectChange("+(i*6+j).toString()+")' onmouseout='UIHideTextTooltip()' onmouseover='UIShowTextTooltip(#Attrib_Particle"+this.aEtherealParticles[i*6+j][0].toString()+")'/>")
				$("#GemButtonEthereal"+(i*6+j).toString()).BCreateChildren("<Image class='GemImage' id='GemImageEthreal"+(i*6+j).toString()+"' src='file://{images}/econ/sockets/gem_effect.png' />")
				$("#GemButtonEthereal"+(i*6+j).toString()).BCreateChildren("<Label class='GemLabel' id='GemLabelEthreal"+(i*6+j).toString()+"' text='"+this.aEtherealParticles[i*6+j][1]+"' />")
			}
		}
	}
	
	$("#DonationTabEffect").BCreateChildren("<Panel class='TitleContainer' id='TitleContainerPrismatic' />")
	$("#TitleContainerPrismatic").BCreateChildren("<Label id='PrismaticTitle' text='#Econ_Socket_Empty_Color'/>")
	for (var i = 0; i < 7; i++) {
		var sColor
		$("#DonationTabEffect").BCreateChildren("<Panel class='DonationTabRow' id='DonationTabRowPrismatic"+(i).toString()+"' />")
		for (var j = 0; j < 6; j++) {
			$("#DonationTabRowPrismatic"+(i).toString()).BCreateChildren("<Label class='GemButton' id='GemButtonPrismatic"+(i*6+j).toString()+"' onactivate='Donation.OnColorChange("+(i*6+j).toString()+")' onmouseout='UIHideTextTooltip()' onmouseover='UIShowTextTooltip(#"+this.aPrismaticColors[i*6+j][0]+")'/>")
			$("#GemButtonPrismatic"+(i*6+j).toString()).BCreateChildren("<Image class='GemImage' id='GemImageEthreal"+(i*6+j).toString()+"' src='file://{images}/econ/sockets/gem_color.png' />")
			$("#GemButtonPrismatic"+(i*6+j).toString()).BCreateChildren("<Panel class='PrismaticMask' id='PrismaticMask"+(i*6+j).toString()+"'/>")
			
			sColor = this.GetColorHex(this.aPrismaticColors[i*6+j][1], this.aPrismaticColors[i*6+j][2], this.aPrismaticColors[i*6+j][3])
			$("#PrismaticMask"+(i*6+j).toString()).style.backgroundColor=sColor;
			$("#GemButtonPrismatic"+(i*6+j).toString()).BCreateChildren("<Image class='PrismaticMaskImage' id = 'PrismaticMaskImage" +(i*6+j).toString()+"' src='file://{images}/econ/sockets/gem_color_mask.png' />")
			$("#PrismaticMaskImage"+(i*6+j).toString()).style.washColor=sColor;
		}
	}
	$("#DonationTabEffect").BCreateChildren("<Panel id='BottomContainer' />")
	$("#BottomContainer").BCreateChildren("<Panel id='BottomContainerHalf1' class='BottomContainerHalf' />")
	$("#BottomContainer").BCreateChildren("<Panel id='BottomContainerHalf2' class='BottomContainerHalf' />")
	$("#BottomContainerHalf1").BCreateChildren("<Panel id='ColorEntryContainerEntry' class='ColorEntryContainer' />")
	
	$("#ColorEntryContainerEntry").BCreateChildren("<TextEntry id='ColorEntry' maxchars='10000' placeholder='#Econ_Socket_Empty_Color' oninputsubmit='Donation.OnSubmitColorActive();' />")
	$("#BottomContainerHalf1").BCreateChildren("<Button class='BottomButton' id='BottomButtonSubmit' onactivate='Donation.OnSubmitColorActive()' onmouseout='UIHideTextTooltip()' onmouseover='UIShowTextTooltip(#submit_color_tooltip)' />")
	$("#BottomButtonSubmit").BCreateChildren("<Label class='BottomButtonLabel' id='BottomButtonLabelSubmit' text='#submit_color'/>")
	$("#BottomContainerHalf1").BCreateChildren("<Button class='BottomButton' id='BottomButtonRandom' onactivate='Donation.OnRandomColorActive()' onmouseout='UIHideTextTooltip()' onmouseover='UIShowTextTooltip(#random_color_tooltip)' />")
	$("#BottomButtonRandom").BCreateChildren("<Label class='BottomButtonLabel' id='BottomButtonLabelRandom' text='#random_color'/>")
	
	$("#BottomContainerHalf2").BCreateChildren("<Panel id='ColorEntryContainerDes' class='ColorEntryContainer' />")
	$("#ColorEntryContainerDes").BCreateChildren("<Label id='ColorEntryDesLabel' text='#color_entry_des' />")
	$("#ColorEntryContainerDes").BCreateChildren("<Panel id='ColorExample'/>")

	$("#BottomContainerHalf2").BCreateChildren("<Button class='BottomButton' id='BottomButtonErase' onactivate='Donation.OnRemoveEffectActive()' onmouseout='UIHideTextTooltip()' onmouseover='UIShowTextTooltip(#remove_effect_tooltip)' />")
	$("#BottomButtonErase").BCreateChildren("<Label class='BottomButtonLabel' id='BottomButtonLabelErase' text='#remove_effect'/>")
	$("#BottomContainerHalf2").BCreateChildren("<Button class='BottomButton' id='BottomButtonEmblem' onactivate='Donation.OnEmblemActive()' onmouseout='UIHideTextTooltip()' onmouseover='UIShowTextTooltip(#emblem_tooltip)' />")
	$("#BottomButtonEmblem").BCreateChildren("<Label class='BottomButtonLabel' id='BottomButtonLabelEmblem' text='#LoadoutSlot_Emblem'/>")
	$("#BottomButtonEmblem").visible=false
}

Donation.OnDonationTabActive = function (){
	$("#DonationTabDonation").visible = true;
	$("#DonationTabEffect").visible = false;
	iCurrentTab = 0;
	$("#DonationTabButtonDonation").AddClass('HaveShadow')
	$("#DonationTabButtonCourier").RemoveClass('HaveShadow')
	$("#DonationTabButtonHero").RemoveClass('HaveShadow')
	$("#DonationTabButtonWard").RemoveClass('HaveShadow')
}

Donation.OnCourierTabActive = function (){
	$("#DonationTabDonation").visible = false;
	$("#DonationTabEffect").visible = true;
	iCurrentTab = 1;
	for (var i = 0; i < 5; i++) {
		$("#GemImageEthreal"+this.aEyeParticles[i].toString()).visible = true;
		$("#GemLabelEthreal"+this.aEyeParticles[i].toString()).visible = true;
		$("#GemButtonEthereal"+this.aEyeParticles[i].toString()).visible = true;
	}
	$("#BottomButtonEmblem").visible = false;
	Donation.ResetPanel()
	$("#DonationTabButtonDonation").RemoveClass('HaveShadow')
	$("#DonationTabButtonCourier").AddClass('HaveShadow')
	$("#DonationTabButtonHero").RemoveClass('HaveShadow')
	$("#DonationTabButtonWard").RemoveClass('HaveShadow')
}

Donation.OnHeroTabActive = function (){
	$("#DonationTabDonation").visible = false;
	$("#DonationTabEffect").visible = true;
	iCurrentTab = 2;
	for (var i = 0; i < 5; i++) {
		$("#GemImageEthreal"+this.aEyeParticles[i].toString()).visible = false;
		$("#GemLabelEthreal"+this.aEyeParticles[i].toString()).visible = false;
		$("#GemButtonEthereal"+this.aEyeParticles[i].toString()).visible = false;
	}
	$("#BottomButtonEmblem").visible = true;
	Donation.ResetPanel()
	$("#DonationTabButtonDonation").RemoveClass('HaveShadow')
	$("#DonationTabButtonCourier").RemoveClass('HaveShadow')
	$("#DonationTabButtonHero").AddClass('HaveShadow')
	$("#DonationTabButtonWard").RemoveClass('HaveShadow')
}

Donation.OnWardTabActive = function (){
	$("#DonationTabDonation").visible = false;
	$("#DonationTabEffect").visible = true;
	iCurrentTab = 3;
	for (var i = 0; i < 5; i++) {
		$("#GemImageEthreal"+this.aEyeParticles[i].toString()).visible = false;
		$("#GemLabelEthreal"+this.aEyeParticles[i].toString()).visible = false;
		$("#GemButtonEthereal"+this.aEyeParticles[i].toString()).visible = false;
	}
	$("#BottomButtonEmblem").visible = false;
	Donation.ResetPanel()
	$("#DonationTabButtonDonation").RemoveClass('HaveShadow')
	$("#DonationTabButtonCourier").RemoveClass('HaveShadow')
	$("#DonationTabButtonHero").RemoveClass('HaveShadow')
	$("#DonationTabButtonWard").AddClass('HaveShadow') 
}

Donation.GetColorHex = function(i1, i2, i3) {
	var sColor = "#"
	if (i1 < 0 || i2 < 0 || i3 < 0) {
		return ""
	}
	if (i1 < 16) {
		sColor = sColor+'0'+i1.toString(16)
	}
	else {
		sColor = sColor+i1.toString(16) 
	}
	if (i2 < 16) {
		sColor = sColor+'0'+i2.toString(16)
	}
	else {
		sColor = sColor+i2.toString(16)
	}
	if (i3 < 16) {
		sColor = sColor+'0'+i3.toString(16)
	}
	else {
		sColor = sColor+i3.toString(16)
	}
	return sColor
}

Donation.OnEffectChange = function(iEffect) {
	GameEvents.SendCustomGameEventToServer("ChangeEtherealEffect", {"tab":iCurrentTab, "effect": this.aEtherealParticles[iEffect][0]})
}

Donation.OnColorChange = function(iColor) {
	$("#ColorEntry").text=this.aPrismaticColors[iColor][1].toString()+','+this.aPrismaticColors[iColor][2].toString()+','+this.aPrismaticColors[iColor][3].toString()
	this.OnSubmitColorActive()
}

Donation.OnRandomColorActive = function() {
	$("#ColorEntry").text=Math.floor(Math.random()*256).toString()+","+Math.floor(Math.random()*256).toString()+","+Math.floor(Math.random()*256).toString()
	this.OnSubmitColorActive()
}

Donation.OnSubmitColorActive = function() {
	$("#ColorExample").visible=false
	var sRGB = $("#ColorEntry").text
	var iFirstCommaPos = sRGB.indexOf(",")
	var iSecondCommaPos = sRGB.indexOf(",", iFirstCommaPos+1)
	if (iFirstCommaPos < 0 || iSecondCommaPos < 0) {
		$("#ColorEntryDesLabel").visible=true
		return
	}
	var sR=sRGB.slice(0, iFirstCommaPos)
	var sG=sRGB.slice(iFirstCommaPos+1, iSecondCommaPos)
	var sB=sRGB.slice(iSecondCommaPos+1)
	var iR=parseInt(sR)
	var iG=parseInt(sG)
	var iB=parseInt(sB)
	if(isNaN(iR) || iR < 0 || iR > 255 || isNaN(iG) || iG < 0 || iG > 255 || isNaN(iB) || iB < 0 || iB > 255){
		$("#ColorEntryDesLabel").visible=true
		return
	}
	$("#ColorEntryDesLabel").visible=false
	GameEvents.SendCustomGameEventToServer("ChangePrismaticColor", {"tab":iCurrentTab, "r":iR , "g": iG, "b": iB})
}

Donation.OnEmblemActive = function() {
	var iR = 1
	var iG = 2
	var iB = 3
	GameEvents.SendCustomGameEventToServer("ToggleEmblem", {"tab":iCurrentTab, "r":iR , "g": iG, "b": iB})
}

Donation.OnRemoveEffectActive = function(){
	GameEvents.SendCustomGameEventToServer("RemoveEtherealEffect", {"tab":iCurrentTab})
}

Donation.ResetPanel = function() {
	var i
	for (i = 0; i < 34; i++) {
		$("#GemButtonEthereal"+i.toString()).RemoveClass("HaveShadow")
	}
	for (i = 0; i < 42; i++) {
		$("#GemButtonPrismatic"+i.toString()).RemoveClass("HaveShadow")
	}
	var sColor = this.GetColorHex(aCurrentColor[iCurrentTab][0], aCurrentColor[iCurrentTab][1], aCurrentColor[iCurrentTab][2])
	if (sColor.length == 0) {
		$("#ColorEntry").text = ""
		$("#ColorExample").visible = false
	}
	else {
		$("#ColorEntry").text = aCurrentColor[iCurrentTab][0].toString()+","+aCurrentColor[iCurrentTab][1].toString()+","+aCurrentColor[iCurrentTab][2].toString()
		$("#ColorExample").style.backgroundColor=sColor
		$("#ColorExample").visible = true
	}
	
	if(this.tColorIndex[sColor]!=null) {
		$("#GemButtonPrismatic"+this.tColorIndex[sColor].toString()).AddClass("HaveShadow")
	}
	
	if (aCurrentEffect[iCurrentTab] >= 0) {
		$("#GemButtonEthereal"+aCurrentEffect[iCurrentTab].toString()).AddClass("HaveShadow")
	}
}

function EffectChanged(keys) {
	var iEffect
	for (iEffect = 0; iEffect < 34; iEffect++) {
		if(keys.effect == Donation.aEtherealParticles[iEffect][0]) {
			aCurrentEffect[keys.tab] = iEffect
			break
		}
	}
	Donation.ResetPanel()
}

function ColorChanged(keys) {
	aCurrentColor[keys.tab][0] = keys.r
	aCurrentColor[keys.tab][1] = keys.g
	aCurrentColor[keys.tab][2] = keys.b
	Donation.ResetPanel()
}

function EffectRemoved(keys) {
	aCurrentEffect[keys.tab] = -1
	aCurrentColor[keys.tab][0] = -1
	aCurrentColor[keys.tab][1] = -1
	aCurrentColor[keys.tab][2] = -1
	Donation.ResetPanel()
}
GameEvents.Subscribe( "effect_changed", EffectChanged);
GameEvents.Subscribe( "color_changed", ColorChanged);
GameEvents.Subscribe( "effect_removed", EffectRemoved);