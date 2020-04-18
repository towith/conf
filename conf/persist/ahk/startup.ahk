#WinActivateForce
#SingleInstance, force
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode,  RegEx
Menu, Tray, Icon, Shell32.dll, 321 
SoundSet, 28

Thread, Interrupt, 0 
#Include, commvar.ahk

; Run ,%windir%\System32\rundll32.exe user32.dll,LockWorkStation
if(FileExist(logDir . "\__prevent_lock__")){
    FileDelete, %logDir%\__prevent_lock__
}else{
    ; Run rundll32.exe user32.dll LockWorkStation, %windir%\System32
}
startAction("autostart")

ExitApp, 0