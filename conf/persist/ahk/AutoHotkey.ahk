; #NoEnv
SetWorkingDir %A_scriptdir%

Run %A_AhkPath% bindings.ahk
Sleep 1500
Run %A_AhkPath% caps.ahk