; #Persistent
#SingleInstance, ignore
global TestCode2:="code2"
#Include %A_ScriptDir%\commvar.ahk
#include %A_ScriptDir%\configvar.ahk
#Include,%A_ScriptDir%\startActLib.ahk
; Menu, Tray, Icon,%A_AhkPath%,4
Menu, Tray, Icon, Shell32.dll, 321 

if(IsFunc(A_args[1])){
    f:=Func(A_args[1])
    ToolTip, % "Call:" . A_args[1]
    f.Call(A_args[2],A_args[3],A_args[4])
}else{
    MsgBox %1% is Not a known function.
}

ExitApp, 0


#esc::
ExitApp, 100
Return

#Include,%A_ScriptDir%\directLib.ahk