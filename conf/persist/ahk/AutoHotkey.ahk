; #NoEnv
SetWorkingDir %A_scriptdir%

Run %A_AhkPath% bindings.ahk
Sleep 1000
Run %A_AhkPath% caps.ahk