#Include, mousegrid.ahk
$*space::
return

$*space up::
; MsgBox, %A_ThisHotkey%|%A_PriorHotkey%|%A_PriorKey%
if (A_PriorKey=="Space"){
  modKey:=""
  if(GetKeyState("Shift")){
      modKey:=modKey . "+"
  }
  if(GetKeyState("Ctrl")){
      modKey:=modKey + "^"
  }
  if(GetKeyState("Alt")){
      modKey:=modKey + "!"
  }
  send %modKey%{space}
}
return

space & h:: 
mousemove -jjxs,0,0,R 
return
space & j::
mousemove 0,jjys,0,R
return
space & k::
mousemove 0,-jjys,0,R
return
space & l::
mousemove jjxs,0,0,R
return        


space & 1::
    MouseGetPos , curX, curY
    topLeftX:=0
    topLeftY:=0
    if(isDoublePress()){
      CoordMode,Mouse,Screen
      mousemove 0,0
    }else{
      CoordMode, Mouse, Window 
      mousemove 0,0
    }
return 
space & 2::
  MouseGetPos , curX, curY
  topRightX:=screenWidth
  topRightY:=0
  if(isDoublePress()){
    CoordMode,Mouse,Screen
    mousemove (screenWidth-cursorSize),0
  }else{
    WinGetPos, X, Y, W, H, A
    CoordMode, Mouse, Window 
    mousemove W-cursorSize,0+cursorSize
  }
return 
space & 3::
  MouseGetPos , curX, curY
  bottomLeftX:=0
  bottomLeftY:=screenHeight
  if(isDoublePress()){
    CoordMode,Mouse,Screen
    mousemove 0,screenHeight-cursorSize
  }else{
    CoordMode, Mouse, Window 
    WinGetPos, X, Y, W, H, A
    mousemove 0+cursorSize,H-cursorSize
  }
return 
space & 4::
  MouseGetPos , curX, curY
  bottomRightX:=screenWidth
  bottomRightY:=screenHeight
  mousemove curX,curY
  if(isDoublePress()){
    CoordMode,Mouse,Screen
    mousemove screenWidth-cursorSize,screenHeight-cursorSize
  }else{
    CoordMode, Mouse, Window 
    WinGetPos, X, Y, W, H, A
    mousemove W-cursorSize,H-cursorSize
  }
return 
space & 5::
  MouseGetPos , curX, curY
  if(isDoublePress()){
    CoordMode,Mouse,Screen
    WinGetPos, X, Y, W, H, A
    mousemove screenWidth/2-cursorSize,screenHeight/2-cursorSize
  }else{
    CoordMode, Mouse, Window 
    WinGetPos, X, Y, W, H, A
    mousemove W/2,H/2
  }
return

space & [::  send {wheelup %wheelStep%} 
space & ]::  send {wheeldown %wheelStep%} 
space & /:: AppsKey
space & enter:: send {rbutton}

space & tab::
  MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
  WinActivate, ahk_id %OutputVarWin%
return

; 6::
; mousemove -jjx,0,0,R
; return
; 7::
; mousemove 0,jjy,0,R
; return
; 8::
; mousemove 0,-jjy,0,R
; return
; 9::
; mousemove jjx,0,0,R
; return

space & t::
Run , % Browser_path . " " . "https://shuo.taoguba.com.cn/newsFlash/"
return