OnMessage(WM_MOUSEMOVE:=0x200, "MouseMove")
MouseMove() {
	global
	MouseGetPos, x2, y2
	if (x1!=x2 and y1!=y2) {
		Tooltip % x2 " " y2
		
	}
}
CoordMode, Mouse, Screen
MouseGetPos, x1, y1
OnMessage(WM_MOUSEMOVE:=0x200, "MouseMove")
Gui, +ToolWindow
Gui, Show, x0 y0 w0 h0
Gui, +LastFoundExist
WinSet, Transparent, 1, % "ahk_id" WinExist()
Gui, Show, w%A_ScreenWidth% h%A_ScreenHeight%