cd /d %~dp0

:BACKUP
call back.bat

:COMMIT
rem set EDITOR=notepad
rem git gc --prune --aggressive
rem git add -u . 
git config  credential.helper wincred
git add . 
git commit  -a --amend  -m"%date% %time%" & git push --force
set e=%errorlevel%

:NOTIFY
set a=%A_ScriptDir%\DirectCall.ahk
set p=Persist
if %e% EQU 0 (
rem  autohotkey.exe %a%  giveTrayTip "Commited %p%" "Success" 3
  nircmdc trayballoon "Success" "Commited %p%" "shell32.dll,22" 2000
) else (
rem  autohotkey.exe %a%  giveTrayTip "To Commite %p%" "Failed: %ERRORLEVEL%" 3
  nircmdc trayballoon "Failed: %ERRORLEVEL%" "To Commite %p%" "shell32.dll,22" 2000
)
time /t
exit /b %e%
