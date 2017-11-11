@echo off
path C:\Windows\system32
cmd /u /c TYPE english\AllHead.txt > addon_english.txt
for /f "tokens=*" %%a in (filelist.txt) do (
	cmd /u /c TYPE english\%%a >> addon_english.txt
)

cmd /u /c TYPE english\AllTail.txt >> addon_english.txt
COPY /b /y bom+addon_english.txt ..\resource\addon_english.txt
DEL addon_english.txt


cmd /u /c TYPE schinese\AllHead.txt > addon_schinese.txt
for /f "tokens=*" %%a in (filelist.txt) do (
	cmd /u /c TYPE schinese\%%a >> addon_schinese.txt
)

cmd /u /c TYPE schinese\AllTail.txt >> addon_schinese.txt
COPY /b /y bom+addon_schinese.txt ..\resource\addon_schinese.txt
DEL addon_schinese.txt
