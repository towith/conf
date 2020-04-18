createDocInfo:
   if(!isWindowFullScreen("A")){
	   Gui,tt:Destroy
	   return
   }
   WinGet, pid, id, A
	ControlGetText, text,Edit1,A
   Gui,tt:+LastFound
   if(!Winexist()){
      Gui,tt:New
	  Gui,tt:Font, s12, Arial
	  Gui,tt:Add, Text,cRed vTTT, p%text%
   }else{
	   GuiControlGet, chwnd, tt:Hwnd, TTT
	   if(chwnd){
	     GuiControl,tt: , TTT, %text% 
	   }else{
	     Gui,tt:Font, s12, Arial
		 Gui,tt:Add, Text,cRed vTTT, p%text%
	   }
   }
	Gui,tt:-Caption
    Gui,tt:+Border
    ; Gui,tt:+Parent%pid%
	; Gui,tt:+Owner%pid%
	Gui,tt:+AlwaysOnTop
	Gui,tt:+Disabled
	Gui,tt:+ToolWindow
	Gui,tt:Show,X1850 Y30 NA

	; Gui,tt:+OwnDialogs
	; Gui,tt:+0x80000000
	; Set_Parent_by_id(pid,"tt")
	; Control, Style, 0x40000000 ,AutoHotkeyGUI1,A
	; ControlGet, cid, Hwnd, , AutoHotkeyGUI1,A
	; WinSet, Redraw,,A
return