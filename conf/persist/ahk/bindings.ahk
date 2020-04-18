Menu, Tray, Icon, Shell32.dll, 297 ;; +2
#WinActivateForce
#SingleInstance, force
#Persistent

#InstallKeybdHook
; #InstallMouseHook
; #NoTrayIcon
; #UseHook, On

DetectHiddenWindows Off
SetWorkingDir %A_ScriptDir%
AutoTrim, On
SetTitleMatchMode, RegEx
FileEncoding ,UTF-8-RAW

;; functions
#Include, <DBA>
#Include, commvar.ahk
#Include, dbcommon.ahk
global DbObj:=new DBObj
#Include, bindingsvar.ahk
#include lib/ahkSock.ahk
#Include, lib/httpServer.ahk

;; workers
#Include, interface.ahk
#Include, messages.ahk
#Include, messages-evt.ahk

; DB := DBA.DataBaseFactory.OpenDataBase("SQLite", "D:\bov_logs\data.db")

;; bindings
#Include, space.ahk
#include abbr-pub.ahk
#include translator.ahk

#Include, ifs.ahk
#Include, temp.ahk
#Include, test.ahk

;; subs 
#Include, binding-sub.ahk

return

;; overwritten
$LWin:: 
  send {LWinDown} 
return

$LWin Up:: 
  send {LWinUp}
  if(A_PriorKey == "LWin"){
    SwitchIME(00000804) ; Chinese
  }
return

#BackSpace::
  SwitchIME(0x04090409) ; English
return

/* 
$#1::
$#2::
$#3::
$#4::
$#5::
$#6::
$#7::
$#8::
$#9::
$#0::
  pos:=RegExMatch(A_ThisHotkey, "\d" , num)
  send {LWinDown}{CtrlDown}%num%{CtrlUp}{LWinUp}
return
*/
#b::
  send ,#b
  Sleep, 50
  ControlGetPos, mX, mY,,,Button2, %tTaskbar%
  MouseMove, mX, mY
return
#1::
  tQ:="ahk_class TTOTAL_CMD"
  if(!WinExist(tQ)){
    RunWithStyle(TC_PATH)
    Winwait,%tQ%,,5
  }else{
    switchBetweenSameType(tQ)
  }
return
; #2::
;   if(! tryRestoreWinById(A_ThisHotkey)){
;    cmd:=vivaldi_path .  " --profile-directory=""default"" --remote-debugging-port=50000 --start-fullscreen"
;    runAndStoreId(cmd,tVivaldi,A_ThisHotkey)
;   }
; return
*#2::
  tQ:=tBrowser
  if(!WinExist(tQ)){
    doBrowser()
  }else{
    switchBetweenSameType(tQ)
  }
return
#3::
  tQ:="ahk_exe Code.exe"
  if(!WinExist(tQ)){
    doMsVscode()
  }else{
    switchBetweenSameType(tQ)
  }
return
#4::
  tQ:="ahk_exe idea64.exe"
  if(!WinExist(tQ)){
    ;  RunAsFunc(IDEA_PATH)
    ;  Winwait,%tQ%,,5
    giveTooltip("IDEA is not running.",5)
  }
  switchBetweenSameType(tQ)
return
#5::
  Run %browser_path% --new-window http://localhost:11032
  ; tQ:=tDevBrowser
  ; if(!WinExist(tQ)){
  ;   doDevBrowser()
  ; }
  ; switchBetweenSameType(tQ)
return
#6::
/*   tQ:=tRider
  if(!WinExist(tQ)){
    giveTooltip( tQ . " is not running.",5)
  }
  switchBetweenSameType(tQ)
  */

  tQ:=tToDo
  if(!WinExist(tQ)){
    Run,% toDoPath
  }else{
    switchBetweenSameType(tQ)
  }
return
#7::
  tQ:=wtTitle
  if(!WinExist(tQ)){
    giveTooltip("WT not running",5)
  }else{
    switchBetweenSameType(tQ)
  }
return
*#8::
  tQ:=tOneNote
  if(GetKeyState("Shift","P")){
    tQ:=tNotion
    if(!WinExist(tQ)){
      Run ,%notionPath%
      Winwait,%tQ%,,5
    }else{
      switchBetweenSameType(tQ)
    }

  }else{
    tQ:=tOneNote
    if(!WinExist(tQ)){
      Run ,%OneNote_Path%
      Winwait,%tQ%,,5
    }else{
      switchBetweenSameType(tQ)
    }
  }
return
*#9::
  tQ:=tHelper
  if(!WinExist(tQ)){
    if(GetKeyState("Shift", "P")){
      doHelper()
    }else{
      cmd:=Helper_path
      Run , % cmd
    }
    Winwait,%tQ%,,5
  }else{
    switchBetweenSameType(tQ)
  }
return
#0::
  doTDX()
  switchBetweenSameType(tTDX)
return

*#`::
  if(GetKeyState("Shift","P")){
    WinGet, id, id,A
    WinGet, name, ProcessName,A
    giveTooltip( name " saved")
  }else{
    if(id){
      WinActivate,ahk_id %id%
    }
  }
Return

;;; winkeys
; #enter::
; Winset , AlwaysOnTop,,%tTaskbar%
; keywait , lwin , U 
; if(!GetKeyState("Alt")){
;   Winset , Bottom,,%tTaskbar%
; }
; return

#?:: 
  startAction("run")
return

#!-::
  preventNextStart() 
return

^#-::
  preventNextLock()
return

/*
 f9::
    a:=RunWaitSilent("adb shell input touchscreen tap 547 1820; echo ""After Press""",false)
    giveTooltip(a,5)
    KeyWait, f7, U
    b:=RunWaitSilent("adb shell input touchscreen tap 547 1820; echo ""After Release""",false)
    giveTooltip(b,0.5)
return 
*/

#ins::
  WinGetClass, cc, A
  ToolTip Begin Key map
  CoordMode, Mouse, Window
  MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
  giveTooltip("Input key mapped to current mouse pos, esc to cancel")
  Input Key, L1 T2 C,{esc}
  if(Key==""){
    giveTooltip("map canceled")
    return
  }
  FileAppend, 
  (
    %cc%|%Key%|click|%OutputVarX%|%OutputVarY%`n
  ) ,% logDir . "\keymaps.map"
  giveTooltip("map " + Key " for " cc "(" OutputVarX "," OutputVarY ")")
  mapDefinedKeys()
return

mapOpClick:
  CoordMode,Mouse,Window
  WinGetClass, cc , A
  k:=StrReplace(A_ThisHotkey,"$","")
  k:=StrReplace(k," up","")
  args:=mapOpArgs[cc . "_" . k]
  a1:=args[1]
  a2:=args[2]
  MouseClick, left, % a1,% a2, ,100 
  giveTooltip("click at " a1 "," a2, 3,a1,a2)
  ; MouseMove,  % a1,% a2 
return

; *vk5D::
;    send {f4}
; return

MButton::
  send #{tab}
return

#esc::

return

#f12::
  Run wt -w "tasking" "keeprun.cmd"
return

Volume_Up::
  send {WheelDown}
Return

Volume_Down::
  send {WheelUp}
Return

Volume_Mute::
  send {LButton}
Return 

!Volume_Mute::
  SoundSet, +1,, Mute
  SoundGet, master_mute,, Mute
  giveTooltip("Mute:" master_mute)
Return

!Volume_Up::
  SoundSet +1
  SoundGet, master_volume
  giveTooltip("volume:" master_volume)
Return

!Volume_Down::
  SoundSet, -1
  SoundGet, master_volume
  giveTooltip("volume:" master_volume)
Return
