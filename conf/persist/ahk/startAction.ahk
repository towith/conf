
#include %A_ScriptDir%\commvar.ahk
#include %A_ScriptDir%\configvar.ahk
#include %A_ScriptDir%\startActLib.ahk

if(A_args[1]=="autostart"){
    isAutostart:=true
}
SetTimer, lCheckExit, 1000
loop,1{
    SoundBeep, 500, 200  ;
}
Menu, Tray, Icon, Shell32.dll, 321 

;; test
; ExitApp 0
;; test end

for i, e in actionsArr
{
  doCallAction(e)
}

;; notify


if(isAutostart){
	SoundGet, v
    SoundPlay,C:\Windows\Media\Linux Ubuntu\login.wav,wait
	SoundSet, %v%
}
TrayTip , Finished, All Action done, 3,34
doAfter()
ExitApp, 0

lCheckExit:
   if(GetKeyState("Alt")){
    loop,1{
        SoundBeep, 200, 200  ;
    }
       Gosub, lExitApp
   }
Return

lExitApp:
    ExitApp,0
Return

