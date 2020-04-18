; refine windows taskbar hotkey behave
setBarTranspency(t){
;RegRead, OutputVar, HKCU, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3, Settings
;v:=SubStr(OutputVar, 17 ,2)
v:=DllCall("Shell32\SHAppBarMessage", "UInt", 4 ; ABM_GETSTATE
                                           , "Ptr", &APPBARDATA
                                           , "Int")
outputdebug the v is :%v%
if (v=0)
{
  return
}

 WinSet, Transparent, %t%, ahk_class Shell_TrayWnd
}
 



;HotkeyD("$#1","sw","1") 
;HotkeyD("$#2","sw","2") 
;HotkeyD("$#3","sw","3") 
;HotkeyD("$#4","sw","4") 
;HotkeyD("$#5","sw","5") 
;HotkeyD("$#6","sw","6") 
;HotkeyD("$#7","sw","7") 
;HotkeyD("$#8","sw","8") 
;HotkeyD("$#9","sw","9") 
;HotkeyD("$#0","sw","0") 


HotkeyD(hk, fun, arg*) {
    Static funs := {}, args := {}
    funs[hk] := Func(fun), args[hk] := arg
    Hotkey, %hk%, Hotkey_Handle
    Return
Hotkey_Handle:
    funs[A_ThisHotkey].(args[A_ThisHotkey]*)
    Return
}

sw(num){
   setBarTranspency(0)
   send #%num%
   winwaitnotactive ahk_class Shell_TrayWnd
   setBarTranspency(255)
}



