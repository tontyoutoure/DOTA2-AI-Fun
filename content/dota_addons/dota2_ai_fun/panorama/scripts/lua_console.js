"use strict";

var LUA_CONSOLE_NEST_ERROR = -1;

var LuaConsole = {};


if(!Game.IsInToolsMode())
	$("#ToggleLuaConsole").style.visibility = "collapse";

LuaConsole.OnInputSubmitted = function () {
	var i;
	var iMaxCharacter = $("#CommandEntry").GetMaxCharCount();
	GameEvents.SendCustomGameEventToServer("LuaConsole_CommandInput", {"command": $("#CommandEntry").text});
//	$.Msg($("#CommandEntry").GetCursorOffset());
	$("#CommandEntry").SetFocus();
	$("#CommandEntry").SelectAll();
//	$("#CommandEntry").SetMaxChars(iMaxCharacter);
}

LuaConsole.OnRestartAddon = function () {
	GameEvents.SendCustomGameEventToServer("LuaConsole_RestartAddon", {});
}
 
LuaConsole.OnToggleConsole = function () {
	if ($("#LuaConsoleContainer").style.visibility == "visible") {
		$("#LuaConsoleContainer").style.visibility = "collapse";
		$("#ButtonContainer").style.visibility = "collapse";
		Game.EmitSound("ui_settings_slide_out");
	}
	else {
		$("#LuaConsoleContainer").style.visibility = "visible";
		$("#ButtonContainer").style.visibility = "visible";
		Game.EmitSound("ui_settings_multi");
	}
}

LuaConsole.OnDofileActivate = function () {
	 $("#CommandEntry").text = "LuaConsole:GlobalDofile(\"\")";
	 $("#CommandEntry").SetFocus();
	 $("#CommandEntry").SetCursorOffset(25);
}

LuaConsole.OnSendToConsoleActivate = function() {	
	 $("#CommandEntry").text = "SendToServerConsole(\"\")";
	 $("#CommandEntry").SetFocus();
	 $("#CommandEntry").SetCursorOffset(21);
}

LuaConsole.OnSelectHeroActivate = function() {
	 $("#CommandEntry").text = "PlayerResource:GetPlayer(0):GetAssignedHero()";
	 $("#CommandEntry").SetFocus();
	 $("#CommandEntry").SetCursorOffset(45);
}

LuaConsole.OnSelectAllActive = function() {	
	$("#CommandEntry").SetFocus();
	$("#CommandEntry").SelectAll();
	$.Msg($("#CommandEntry").inputnamespace)
}

LuaConsole.OnDofileTestActive = function() {
	 $("#CommandEntry").text = "dofile('test')";
	GameEvents.SendCustomGameEventToServer("LuaConsole_CommandInput", {"command": $("#CommandEntry").text});
}

LuaConsole.OnCleanInputActive = function() {
	$("#CommandEntry").SetFocus();
	$("#CommandEntry").SetCursorOffset(0);
	var iMaxCharacter = $("#CommandEntry").GetMaxCharCount();
	$("#CommandEntry").SetMaxChars(0);
	$("#CommandEntry").SetMaxChars(iMaxCharacter);
}

LuaConsole.OnAddEscutcheonActive = function () {
	$("#CommandEntry").text = "SendToServerConsole(\"dota_bot_give_item item_fun_escutcheon\")";
	LuaConsole.OnInputSubmitted();
	$("#CommandEntry").text = "SendToServerConsole(\"dota_bot_give_item item_fun_escutcheon\")";
	LuaConsole.OnInputSubmitted();
	$("#CommandEntry").text = "SendToServerConsole(\"dota_bot_give_item item_fun_escutcheon\")";
	LuaConsole.OnInputSubmitted();
	$("#CommandEntry").text = "";
}

LuaConsole.OnAddAAActive = function () {
	$("#CommandEntry").text = "SendToServerConsole(\"dota_bot_give_item item_fun_angelic_alliance\")";
	LuaConsole.OnInputSubmitted();
	$("#CommandEntry").text = "SendToServerConsole(\"dota_bot_give_item item_fun_angelic_alliance\")";
	LuaConsole.OnInputSubmitted();
	$("#CommandEntry").text = "SendToServerConsole(\"dota_bot_give_item item_fun_angelic_alliance\")";
	LuaConsole.OnInputSubmitted();
	$("#CommandEntry").text = "";
}

LuaConsole.OnAddTestItemsActive = function () {
	$("#CommandEntry").text = "SendToServerConsole(\"dota_bot_give_item item_magic_stick\")";
	LuaConsole.OnInputSubmitted();
	$("#CommandEntry").text = "SendToServerConsole(\"dota_bot_give_item item_silver_edge\")";
	LuaConsole.OnInputSubmitted();
	$("#CommandEntry").text = "";
}

LuaConsole.OnBotAddLevelActive = function () {
	$("#CommandEntry").text = "SendToServerConsole(\"dota_bot_give_level 5\")";
	LuaConsole.OnInputSubmitted();
	$("#CommandEntry").text = "";
}

LuaConsole.OnAddTinyActive = function () {
	$("#CommandEntry").text = "SendToServerConsole(\"dota_create_unit npc_dota_hero_tiny enemy\")";
	LuaConsole.OnInputSubmitted();
	$("#CommandEntry").text = "";
}
LuaConsole.GetCurrentObject = function (sName) {
	
}

LuaConsole.GetNestedLevel = function (sName, aNestStack) {
	while (true) {
		if (sName.indexOf("(") >= 0 || sName.indexOf("[") >=0) {
		}
	}
}
