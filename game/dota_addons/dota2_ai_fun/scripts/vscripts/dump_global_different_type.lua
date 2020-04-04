-- d:/desktop/2.lua
fConstant = io.open("C:/Users/LI Kun/Desktop/CONSTANT.txt", "w")
fFunction = io.open("C:/Users/LI Kun/Desktop/Function.txt", "w")
fTable = io.open("C:/Users/LI Kun/Desktop/table.txt", "w")

tTable = {}
tConstant = {}
tFunction = {}

for k, v in pairs(_G) do
	if type(v) == "number" then
		table.insert(tConstant, k)
	elseif type(v) == "function" then
		table.insert(tFunction, k)
	elseif type(v) == "table" then
		table.insert(tTable, k)
	end
end

function StringCompare(s1, s2)
	local i = 1
	local c1 = string.byte(s1, i)
	local c2 = string.byte(s2, i)
	while c1 and c2 do
		if c1 > c2 then return false end
		if c2 > c1 then return true end
		i = i+1
		c1 = string.byte(s1, i)
		c2 = string.byte(s2, i)
	end
	if i > string.len(s1) then return true end
	return false
end

table.sort(tConstant, StringCompare)
table.sort(tFunction, StringCompare)
table.sort(tTable, StringCompare)

for i = 1, #tConstant do
	fConstant:write(tConstant[i].."\n")
end

for i = 1, #tFunction do
	fFunction:write(tFunction[i].."\n")
end

local i = #tTable

while i > 0 do
	if tTable[i] ~= "Timers" and tTable[i] ~= "Attachments" and tTable[i] ~= "Notifications" then
		if string.byte(tTable[i], 1) ~= string.byte("C", 1) or string.byte(tTable[i], 2) < string.byte("A", 1) or string.byte(tTable[i], 2) > string.byte("Z", 1) then 
			print(tTable[i], i)
			table.remove(tTable, i)
		end
	end
	i = i-1
end

tClassFunctions = {}

for i = 1, #tTable do
	tClassFunctions[tTable[i]] = {}
	for k, v in pairs(_G[tTable[i]]) do
		table.insert(tClassFunctions[tTable[i]], k)
	end
	table.sort(tClassFunctions[tTable[i]], StringCompare)
	for j = 1, #tClassFunctions[tTable[i]] do
		fTable:write(tClassFunctions[tTable[i]][j].."\n")
	end
	fTable:write("\n")
end

fConstant:close()
fFunction:close()
fTable:close()

