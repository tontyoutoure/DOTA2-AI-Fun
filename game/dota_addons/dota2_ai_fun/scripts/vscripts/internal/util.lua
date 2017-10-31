function IsDebugSpewOn()
	local spew = Convars:GetInt('dota2aifun_spew') or -1
	if spew == -1 and DOTA2_AI_FUN_SPEW then
		spew = 1
	end

	if spew == 1 then
		return true
	end
	return false
end


function DebugPrint(...)
	local spew = Convars:GetInt('dota2aifun_spew') or -1
	if spew == -1 and DOTA2_AI_FUN_SPEW then
		spew = 1
	end

	if spew == 1 then
		print(...)
	end
end

function DebugPrintTable(...)
	local spew = Convars:GetInt('dota2aifun_spew') or -1
	if spew == -1 and DOTA2_AI_FUN_SPEW then
		spew = 1
	end

	if spew == 1 then
		PrintTable(...)
	end
end

if IsInToolsMode() then
	function PrintTable(t, indent, fileHandle, done)
		--print ( string.format ('PrintTable type %s', type(keys)) )
		if type(t) ~= "table" then return end

		done = done or {}
		done[t] = true
		indent = indent or 0
		fileHandle = fileHandle or io.stdout
		local l = {}
		for k, v in pairs(t) do
			table.insert(l, k)
		end

		table.sort(l)
		for k, v in ipairs(l) do
			-- Ignore FDesc
			if v ~= 'FDesc' then
				local value = t[v]

				if type(value) == "table" and not done[value] then
					done [value] = true
					if fileHandle == io.stdout then 
						print(string.rep ("\t", indent)..tostring(v)..":")
					end
					fileHandle:write(string.rep ("\t", indent)..tostring(v)..":".."\n")
					PrintTable (value, indent + 2, fileHandle, done)
				elseif type(value) == "userdata" and not done[value] then
					done [value] = true
					if fileHandle == io.stdout then
						print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
					end
					fileHandle:write(string.rep ("\t", indent)..tostring(v)..": "..tostring(value).."\n")
					PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, fileHandle, done)
				else
					if t.FDesc and t.FDesc[v] then
						if fileHandle == io.stdout then
							print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
						end
						fileHandle:write(string.rep ("\t", indent)..tostring(t.FDesc[v]).."\n")
					else
						if fileHandle == io.stdout then
							print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
						end
						fileHandle:write(string.rep ("\t", indent)..tostring(v)..": "..tostring(value).."\n")
					end
				end
			end
		end
	end
else
	function PrintTable(t, indent, done)
	  --print ( string.format ('PrintTable type %s', type(keys)) )
	  if type(t) ~= "table" then return end

	  done = done or {}
	  done[t] = true
	  indent = indent or 0

	  local l = {}
	  for k, v in pairs(t) do
		table.insert(l, k)
	  end

	  table.sort(l)
	  for k, v in ipairs(l) do
		-- Ignore FDesc
		if v ~= 'FDesc' then
		  local value = t[v]

		  if type(value) == "table" and not done[value] then
			done [value] = true
			print(string.rep ("\t", indent)..tostring(v)..":")
			PrintTable (value, indent + 2, done)
		  elseif type(value) == "userdata" and not done[value] then
			done [value] = true
			print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
			PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
		  else
			if t.FDesc and t.FDesc[v] then
			  print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
			else
			  print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
			end
		  end
		end
	  end
	end
end
-- Colors
COLOR_NONE = '\x06'
COLOR_GRAY = '\x06'
COLOR_GREY = '\x06'
COLOR_GREEN = '\x0C'
COLOR_DPURPLE = '\x0D'
COLOR_SPINK = '\x0E'
COLOR_DYELLOW = '\x10'
COLOR_PINK = '\x11'
COLOR_RED = '\x12'
COLOR_LGREEN = '\x15'
COLOR_BLUE = '\x16'
COLOR_DGREEN = '\x18'
COLOR_SBLUE = '\x19'
COLOR_PURPLE = '\x1A'
COLOR_ORANGE = '\x1B'
COLOR_LRED = '\x1C'
COLOR_GOLD = '\x1D'


function DebugAllCalls()
		if not GameRules.DebugCalls then
				print("Starting DebugCalls")
				GameRules.DebugCalls = true

				debug.sethook(function(...)
						local info = debug.getinfo(2)
						local src = tostring(info.short_src)
						local name = tostring(info.name)
						if name ~= "__index" then
								print("Call: ".. src .. " -- " .. name .. " -- " .. info.currentline)
						end
				end, "c")
		else
				print("Stopped DebugCalls")
				GameRules.DebugCalls = false
				debug.sethook(nil, "c")
		end
end




--[[Author: Noya
	Date: 09.08.2015.
	Hides all dem hats
]]
function HideWearables( hero )
	local children = hero:GetChildren()
	for k,child in pairs(children) do
	   if child:GetClassname() == "dota_item_wearable" then
		   child:RemoveSelf()
	   end
	end
end

function ShowWearables( unit )

	for i,v in pairs(unit.hiddenWearables) do
		v:RemoveEffects(EF_NODRAW)
	end
end

--[[Autohor: tontyoutoure
	Date:08.01.2017
	Print all modifiers
]]

function PrintAllModifiers( PlayerID )
	local tModifiers = PlayerResource:GetPlayer(PlayerID):GetAssignedHero():FindAllModifiers()
	for i, v in pairs(tModifiers) do print(v:GetName()) end

end

function Vector2D(v3D)
	return Vector(Vector(0,0,0).Dot(Vector(1,0,0), v3D), Vector(0,0,0).Dot(Vector(0,1,0), v3D),0)
end

print("Util loaded")

