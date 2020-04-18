:DIR
call link.conf.bat

:TC
call link.tc.bat

:SCOOP
call link.ahk.bat
call link.maven.bat
call link.keepass.bat
call link.ditto.bat
call link.vim.bat

:UserProfile
call link.yarn.bat
call link.npm.bat
call link.idea.bat
call link.powershell.bat
call link.gradle.bat
call link.pip.bat
call link.ditto_cmd.bat
call link.fiddler.bat
call link.pomodoro.bat

:WINTASK
set r=%cd%
cd wintasks
call import.bat
cd /d %r%
