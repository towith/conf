; author：fwt
; 框框长宽小于pointsize时自动点击，点击点为左上角。
; 加shif为双击，加alt为右键，加ctrl拖动
; 请设置选择的精度，单位为像素
pointsize := 30
 
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen
Gui, +AlwaysOnTop +ToolWindow -Caption -DPIScale +HwndGrid +LastFound
Gui, Margin, 0
Gui, Color, 779977
Gui, Font, s12 w700 cFF0000
WinSet, Transparent, 170
SetGrid()
 
 
loop 24
{
    Hotkey, IfWinActive, ahk_id %Grid%
    HotKey, % chr(96 + A_Index), select
    HotKey, % "+" chr(96 + A_Index), select
    HotKey, % "!" chr(96 + A_Index), select
    HotKey, % "^" chr(96 + A_Index), select
    HotKey, % "space & " chr(96 + A_Index), select
}

space & `;::
    if(WinActive("ahk_id " Grid))
    {
        WinMove, ahk_id %Grid%, , 0, 0, %A_ScreenWidth%, %A_ScreenHeight%
        UpdateGrid(A_ScreenWidth, A_ScreenHeight)
    }
    else
    {
        WinGetPos, x, y, w, h, A
        Gui, Show, x0 y0 w0 h0, Grid
        WinMove, ahk_id %Grid%, , %x%, %y%, %w%, %h%
        UpdateGrid(w, h)
    }
return
 
select:
    key := SubStr(A_ThisHotkey, 0, 1)
    WinGetPos, x0, y0, w, h, % "ahk_id " Grid
    ControlGetPos, x1, y1, w, h, % key
    x := x0 + x1
    y := y0 + y1
    ; MouseMove, %x%, %y%
    if (w <= (pointsize * 50) && h <= (pointsize * 50))
    {
        Gui, Hide
        str := SubStr(A_ThisHotkey, 1, 1)
        if (str = "!")
            MouseClick, R, %x%, %y%
        else if(str = "+")
            MouseClick, L, %x%, %y%, 2
        else if(str = "^")
            MouseClickDrag, L, , , %x%, %y%    
        else
            MouseMove, % (x + A_ScreenWidth/6/2), % (y + A_ScreenHeight/4/2)
        UpdateGrid(A_ScreenWidth, A_ScreenHeight)
    }
    else
    {
        WinMove, ahk_id %Grid%, , %x%, %y%, %w%, %h%
        UpdateGrid(w, h)
    }
return
 
SetGrid(){
    i := 96
    loop 24
    {
        i += 1
        Gui, Add, pic, w100 h100 x+ y0 +Border , % chr(i)
    }
}
 
UpdateGrid(w, h){
    y := 0
    m := w / 6 > 20 ? 5 : 1
    w := w / 6 > 20 ? w / 6 : w / 2
    n := h / 4 > 20 ? 4 : 2
    h := h / 4 > 20 ? h / 4 : h / 2
    fontsize := w / 2
    Gui, Font, S%fontsize%
    i := 0
    loop %n%
    {
        x := 0
        i += 1
        y := h * (A_Index - 1)
        GuiControl, Move, Static%i%, x%x% y%y% w%w% h%h%
        GuiControl, Font, Static%i%
        loop %m%
        {
            x := w * A_Index
            i += 1
            GuiControl, Move, Static%i%, x%x% y%y% w%w% h%h%
            GuiControl, Font, Static%i%
        }
    }
    WinSet, AlwaysOnTop, On
    return
}

GuiEscape:
    UpdateGrid(A_ScreenWidth, A_ScreenHeight)
    Gui, Hide
return

#IfWinActive, Grid
space::
   Gosub, GuiEscape
return
#IfWinActive