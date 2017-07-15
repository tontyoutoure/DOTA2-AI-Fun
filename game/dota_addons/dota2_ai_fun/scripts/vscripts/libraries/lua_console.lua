if not LuaConsole then 
	LuaConsole = class({})
end

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

function LuaConsole:Start()
	local src = debug.getinfo(1).source
  	local iCallStack = 1
	while not src:sub(2):find("dota_addons") do
		iCallStack = iCallStack+1
		src = debug.getinfo(iCallStack).source
	end
	self.sGameDir, self.sAddonName = string.match(src:sub(2), "(.*dota 2 beta[\\/]game[\\/]dota_addons[\\/])([^\\/]+)[\\/]")
	if not self.sAddonName then print("Lua Console Library load failed, plz contact author tontyoutoure@gmail.com") end
end

function LuaConsole:GlobalLoadfile(sFileName)
	local hFile = io.open(sFileName, "rb");
	if not hFile then error("Open file "..sFileName.." failed!") end
	local sCommands = ""
	sCommands = hFile:read("*a")
	return loadstring(sCommands)
end

function LuaConsole:GlobalDofile(sFileName)
	local fTemp = self:GlobalLoadfile(sFileName)
	return fTemp()
end

LuaConsole:Start();
CustomGameEventManager:RegisterListener( "LuaConsole_CommandInput", function (...) return LuaConsole:DoLuaConsoleCommand(...) end);
CustomGameEventManager:RegisterListener( "LuaConsole_RestartAddon", function (...) return LuaConsole:RestartAddon(...) end);