

if not LuaConsole then 
	LuaConsole = class({})
end

LuaConsole.sAddonName = "dota2_ai_fun"

function LuaConsole:DoLuaConsoleCommand(eventSourceIndex, args)
	if not IsInToolsMode() then return end;
	print("command from client: "..args.command);
	local f = loadstring(args.command);
	f();
end

function LuaConsole:RestartAddon()
	if not IsInToolsMode() then return end;
	local sMapName = GetMapName()
	SendToServerConsole("dota_launch_custom_game "..self.sAddonName.." "..sMapName)
end


function LuaConsole:GlobalLoadfile(sFileName)
	if not IsInToolsMode() then 
		error("you are not in tools mode!")
	else
		local hFile = io.open(sFileName, "rb");
		if not hFile then error("Open file "..sFileName.." failed!") end
		local sCommands = ""
		sCommands = hFile:read("*a")
		return loadstring(sCommands)
	end
end

function LuaConsole:GlobalDofile(sFileName)
	if not IsInToolsMode() then 
		error("you are not in tools mode!")
	else
		local fTemp = self:GlobalLoadfile(sFileName)
		return fTemp()
	end
end

CustomGameEventManager:RegisterListener( "LuaConsole_CommandInput", function (...) return LuaConsole:DoLuaConsoleCommand(...) end);
CustomGameEventManager:RegisterListener( "LuaConsole_RestartAddon", function (...) return LuaConsole:RestartAddon(...) end);