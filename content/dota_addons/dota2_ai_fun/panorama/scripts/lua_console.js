"use strict";

var LUA_CONSOLE_NEST_ERROR = -1;

if(!Game.IsInToolsMode())
	$("#ToggleLuaConsole").style.visibility = "collapse";


var LuaConsole = {};
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

LuaConsole.OnSelectAllActive = function() {	
	$("#CommandEntry").SetFocus();
	$("#CommandEntry").SelectAll();
	$.Msg($("#CommandEntry").inputnamespace)
}

LuaConsole.OnCleanInputActive = function() {
	$("#CommandEntry").SetFocus();
	$("#CommandEntry").SetCursorOffset(0);
	var iMaxCharacter = $("#CommandEntry").GetMaxCharCount();
	$("#CommandEntry").SetMaxChars(0);
	$("#CommandEntry").SetMaxChars(iMaxCharacter);
}

LuaConsole.GetCurrentObject = function (sName) {
	
}

LuaConsole.GetNestedLevel = function (sName, aNestStack) {
	while (true) {
		if (sName.indexOf("(") >= 0 || sName.indexOf("[") >=0) {
		}
	}
}