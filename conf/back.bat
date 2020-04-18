:DOBAK
cd /d %~dp0
cmd /c "scoop export > persist/app.list"
cmd /c "scoop bucket list > persist/bucket.list"
copy  /y D:\Applications\Portable\ditto_cmd\command.i.db %cd%\persist\ditto_cmd\command.db


::PAUSE
set a=%A_ScriptDir%\DirectCall.ahk
rem autohotkey.exe %a% wait 1
nircmdc wait 1000
exit /b 0
