; mouse
; $*tab::
;   send {rbutton down}
;   keywait,%A_ThisHotkey%
; return
; $*tab up::
;   send {rbutton up}
; return

; ^lbutton up::
;         click down
;         ; OutputDebug before wait
;         ; keywait , Lbutton , D ;T10 ;; wired behave when ctrl up keywait exit
;         ; OutputDebug after wait 
;         ToolTip
; return

*lbutton up::
        ToolTip, Dragging...
        click down
        Winset , AlwaysOnTop,,%tTaskbar%
;       ; DllCall("mouse_event", uint, 4, int, x, int, y, uint, 0, int, 0)
;       ; PostMessage, 0x202 , 0, ((y<<16)^x), , A               ;WM_LBUTTONUP
        ; OutputDebug before wait
        keywait , CapsLock , U P ;T10
        ; OutputDebug after wait 
        click up
        Winset , Bottom,,%tTaskbar%
;       ; DllCall("mouse_event", uint, 2, int, x, int, y, uint, 0, int, 0)
;       ; PostMessage, 0x201, 0x0001, ((y<<16)^x), , A         ;WM_LBUTTONDOWN
        ToolTip
return

$*space::
    ;  SetKeyDelay -1
      click down
      ; keywait , CapsLock , U P ;T10
      keywait, space ,U P
      ;keywait, %A_ThisHotkey%
    ;  Send {Blind}{lbutton DownTemp}
return

*$space up::  
  click up
return


;===Navigate
*x::delete
*,::esc
*h::Left
*j::Down
*k::Up
*l::Right
*a::Home
*e::End
*p::pgup
*n::pgdn
*w::
  SetKeyDelay -1
  Send {Blind}{Control DownTemp}{Right DownTemp}
return
*w up::
  SetKeyDelay -1
  Send {Blind}{Right up}{Control Up}
return
*b::
  SetKeyDelay -1
  Send {Blind}{Control DownTemp}{Left DownTemp}
return
*b up::
  SetKeyDelay -1
  Send {Blind}{Left up}{Control Up}
return

*s::
{
   BlockInput, on
   prevClipboard = %clipboard%
   clipboard =
   Send, ^c
   BlockInput, off
   ClipWait, 2
   if ErrorLevel = 0
   {
      searchQuery=%clipboard%
      GoSub, BrowserSearch
   }
   clipboard = %prevClipboard%
   return
}

BrowserSearch:
  GetKeyState,S, Shift, P
  GetKeyState,C, Ctrl, P
  if(S="D"){
    u:="http://www.bing.com/search?q="  searchQuery 
  }else if(C="D")
  {
    u:="https://xueqiu.com/S/"  searchQuery 
  }
  else
  {
    u:="http://www.google.com/search?q=" searchQuery
  }
  if(u){
   Run, %BROWSER_PATH% --start-fullscreen "%u%"
  }
  return
  
GoogleSearch:
   StringReplace, searchQuery, searchQuery, `r`n, %A_Space%, All
   Loop
   {
      noExtraSpaces=1
      StringLeft, leftMost, searchQuery, 1
      IfInString, leftMost, %A_Space%
      {
         StringTrimLeft, searchQuery, searchQuery, 1
         noExtraSpaces=0
      }
      StringRight, rightMost, searchQuery, 1
      IfInString, rightMost, %A_Space%
      {
         StringTrimRight, searchQuery, searchQuery, 1
         noExtraSpaces=0
      }
      If (noExtraSpaces=1)
         break
   }
   StringReplace, searchQuery, searchQuery, \, `%5C, All
   StringReplace, searchQuery, searchQuery, %A_Space%, +, All
   StringReplace, searchQuery, searchQuery, `%, `%25, All
   IfInString, searchQuery, .
   {
      IfInString, searchQuery, +
         Run, %browser% http://www.google.com/search?hl=en&q=%searchQuery%
      else
         Run, %browser% %searchQuery%
   }
   else
      Run, %browser% http://www.google.com/search?hl=en&q=%searchQuery%
return

$`;::
  suspend, on
  Menu, Tray, Icon,shell32.dll,110,1
	gosub, hshowprocmenu
return

+`;::
  suspend, on
  Menu, Tray, Icon,shell32.dll,110,1
	gosub, hShowTrayList
return

$\::
  suspend, on
  Menu, Tray, Icon,shell32.dll,110,1
  gosub, genmenu
return

$g::
  gosub , hOpenterm
return

*BackSpace::
return


$m::
 winminimize,A
return

$t::
/*   
; 
  t:="ahk_exe procexp64.exe"
  if(WinExist(t))
  {
    WinActivate %t%
  }else{
    Run, % SCOOP . "\apps\sysinternals\current\procexp64.exe"
  }
 */
   send ^+{esc}
   WinWaitActive,ahk_exe Taskmgr.exe,,5
  ;  send ^{tab} 
  ;  send ^{tab} 
return 


$+m::
	WinGet,mm,MinMax,A
  if(mm==1){
    WinRestore, A
  }else if(mm==0){
    WinMaximize, A
  }
return

$!m::
{
	    WinGet , cid, id, A
   		WinGet,WinList,List,,,Program Manager 
 		  loop,%WinList%{
                 	Current:=WinList%A_Index%
					if(Current==cid){
						Continue
					}
            		WinGet,es,ExStyle,ahk_id %Current%
                    if(es &  0x8) ;; 0x8 is WS_EX_TOPMOST.
                    {
                        WinGetTitle, tt,ahk_id %Current%
                        Winget, mm, minmax , ahk_id %Current%
                        if(mm!=-1 && tt){
                           WinMinimize,  ahk_id %Current%
                        }
                    }
         }
		 return
}

$-::
 WinClose, A
return

q::
  FormatTime, Time , ,M/d dddd HH:mm
  giveSplash("",Time,"Time")
return

+q::
  t:=RunWaitSilent("echo $($a=(pomodoro status )[0];if($a -and $a -match '(\d{1,2}:\d\d)'){$Matches.0})")
  giveSplash(t,"","pomo time")
return

r::
    WinGet, cc, processname,A
    if(("ahk_exe " . cc)==tCode){
      send ^s
    }
    BlockInput, On
    restart()
    Sleep, 500
    BlockInput, Off
return



z::
  turnOffMonitor()
return

refreshRound:
	FormatTime, d,,yyMMdd
	f:= logDir . "__ahk_timer_" . d . ".log"
  tempArr:=Array()
  tempArr.push("Start")
	Loop
	{
		FileReadLine, line, % f, %A_Index%
		if ErrorLevel
			break
		if(line){
      lineArr:=StrSplit(line,A_Space)
      tempArr.push(lineArr[1])
		}
	}
  meetHead:=False
  meetEnd:=false
  timerNum:=0
  e:=tempArr.pop()
  while(e)
  {
     if(e=="Start"){
       meetHead:=true
     }else if(e=="Stop"){
       meetEnd:=true
       if(meetHead){
           meetHead:=false
           meetEnd:=false
           timerNum++        
       }
     }
     e:=tempArr.pop()
  }
  c:=timerNum+1
  giveTooltip("Current round:" + c,3)
  Run %A_AhkPath% %A_ScriptDir%\statusIcon.ahk %c%
return


; u::switchDesktopByNumber(1)
; i::switchDesktopByNumber(2)
; o::switchDesktopByNumber(3)
; *::switchDesktopToLastOpened()
; +u::MoveWindowToDesktop(1)
; +i::MoveWindowToDesktop(2)
; +o::MoveWindowToDesktop(3)

+f4::
   performTN()
   Shutdown, 1 
return

enter::
  send {ctrl down}{esc}{ctrl up}
return

+6::
WinGetPos, X, Y,,,A
WinMove, A, , % X-jjx,Y
return
+7::
WinGetPos, X, Y,,,A
WinMove, A, ,  X,% Y + jjy
return
+8::
WinGetPos, X, Y,,,A
WinMove, A, ,  X,% Y - jjy
return
+9::
WinGetPos, X, Y,,,A
WinMove, A, , % X+jjx,Y
return

^6::
WinGetPos,,,W,H,A
WinMove, A, , , , W-jjx, H
return
^7::
WinGetPos,,,W,H,A
WinMove, A, , , , W, H + jjy
return
^8::
WinGetPos,,,W,H,A
WinMove, A, , , , W, H - jjy
return
^9::
WinGetPos,,,W,H,A
WinMove, A, , , , W+jjx, H
return

switchInputLanguage:
  send #{space}
	WinGet , id, id,A
    for i, e in imeIgnore
    {
      if(e==id){
        imeIgnore.RemoveAt(i,1)
      }
	}
return 

switchInputLanguage2:
  SwitchIME(00000804) ; Chinese
	WinGet , id, id,A
	imeIgnore.push(id)
return

The3Win:
{    if (GetKeyState("Shift"))
    {
      giveTooltip("ReActive window shift")
      f:=runtimeFolder . "\TopWin1"
      FileReadLine, gw1,%f% , 1
      WinActivate, ahk_id %gw1%
    }
    else if (GetKeyState("Ctrl"))
    {
      giveTooltip("ReActive window ctrl")
      f:=runtimeFolder . "\TopWin2"
      FileReadLine, gw2,%f% , 1
      WinActivate, ahk_id %gw2%
    }
    else if (GetKeyState("Alt"))
    {
      giveTooltip("ReActive window alt")
      f:=runtimeFolder . "\TopWin3"
      FileReadLine, gw3,%f% , 1
      WinActivate, ahk_id %gw1%
    }else{
      giveTooltip("Input store kind Shift(A) Ctrl (B) Alt(C), esc to cancel")
      Input Key, L1 T2 C,{esc}
      if (Key=="a")
      {
        giveTooltip("Store window shift")
        WinGet, gw1, id, A
        f:=runtimeFolder . "\TopWin1"
        FileDelete, %f%
        FileAppend, %gw1%, % f
      }

      else if (Key=="b")
      {
        giveTooltip("Store window ctrl")
        WinGet, gw2, id, A
        f:=runtimeFolder . "\TopWin2"
        FileDelete, %f%
        FileAppend, %gw2%, % f
      }
      else if (Key=="c")
      {
        giveTooltip("Store window alt")
        WinGet, gw3, id, A
        f:=runtimeFolder . "\TopWin3"
        FileDelete, %f%
        FileAppend, %gw3%, % f
      }
    }
}   
return

'::
gosub hShowTrayList
Return
; .'=ydfcv`  {esc}  {ins} {del} {home} {pageup} {pagedown} {end} {right} {left} {up} {down} 
; f1-f3 f5,f6 f7 f8-f11 insert delete
