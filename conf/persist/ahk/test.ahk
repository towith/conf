; #include  lib/ahkSock.ahk
; #Include, lib/httpServer.ahk

SetTitleMatchMode, RegEx
global pid

getSpyMsgInfo(){
    ControlGet, tt, List , Focused ,ListBox1, A
    Clipboard:=tt
    return tt
}

testGetOminibar(){
    ControlGetText omniboxContents, Chrome_OmniboxView1, A
    msgbox %omniboxContents% 
}



testUrl(){
    a:="https://github.com/beingwill/Ahk/blob/master/.gitignore"
    b:="http://github.com/beingwill/Ahk/blob/master/.gitignore"
    ; Run , %a%
    ; Run , %b%
    Run, http://www.google.com/search

}
testGetTitle(){
    WinGetTitle, tt, A
    msgbox % tt
}

testTitleBar(){
	WinSet , Style,0x15070000 ,A
}

testIfTopMost(){
    hwnd:=WinExist("A")
    c := DllCall("user32.dll\GetWindowLong","Int",hWnd,"Int",-20,"Int")
    msgbox %c%
}

testDynamicString(){
    ; Thread := AhkThread("MsgBox Message from thread.")
    AhkCom := ComObjCreate("AutoHotkey.Script")
    AhkCom.ahktextdll("MsgBox Hello World!`nExitApp")
    While AhkCom.ahkReady()
    Sleep, 100
    MsgBox Exiting now
}
testWinList(){
; ControlGet, l , hwnd ,,MSTaskListWClass1, ahk_class Shell_TrayWnd
; ControlGet, l , List ,,ToolbarWindow323, ahk_class Shell_TrayWnd
; msgbox %l%
		for window in ComObjCreate("Shell.Application").Windows{
          msgbox % window.name 
        }

        shell := ComObjCreate("Shell.Application")
        ; Shell.CascadeWindows()
        ; Shell.TileHorizontally()
        ; Shell.TileVertically()
        ; Shell.TrayProperties()

}

testMsg(){
    ;; test msg
ControlGet, Hwnd, Hwnd, , SysListView321, A
LV_SelectRow(Hwnd, 3)
; tt:=getSpyMsgInfo()
; msgbox ok: %tt%
}

; for test
; winget,i,id , ahk_exe gvim.exe
	; Array := [Item1, Item2,  ItemN]
    ; for index, element in Array{
    ;     msgbox oo
    ; }
    ; ArrayCount:=Array.MaxIndex()
	; 	loop,%ArrayCount%{
	; 		msgbox ok
	; }

LV_SelectRow(hList, iItem) 
{ 
	VarSetCapacity(LVITEM, 80, 0) 
      
	LVIF_STATE := 0x8
	LVIS_SELECTED := 0x2
	LVIS_FOCUSED := 0x1
	LVM_SETITEMSTATE := 0x104B

	mask := LVIF_STATE
	iSubItem = 0
	state := 0x0
	; statemask := LVIS_SELECTED | LVIS_FOCUSED
	statemask := 0x3

	NumPut(8, LVITEM, 0, "UInt") 
	; NumPut(iItem, LVITEM, 4, "Int")		;Row Number
	; NumPut(iSubItem, LVITEM, 8, "Int") 
	; NumPut(state, LVITEM, 12, "UInt") 
	; NumPut(stateMask, LVITEM, 16, "UInt") 
  
/*
typedef struct tagLVITEMW {
  UINT   mask;
  int    iItem;
  int    iSubItem;
  UINT   state;
  UINT   stateMask;
  LPWSTR pszText; 32
  int    cchTextMax;
  int    iImage;
  LPARAM lParam;  64
  int    iIndent;
  int    iGroupId;
  UINT   cColumns;
  PUINT  puColumns;
  int    *piColFmt;
  int    iGroup;
} LVITEMW, *LPLVITEMW;
*/

	; NumPut(&t, LVITEM, 20, "Int")  ;; add 4 pszText
	; NumPut(0, LVITEM, 24, "Int")  ;; add 4 cchTextMax
	; NumPut(0, LVITEM, 28, "Int")  ;; add 4 iImage
	; NumPut(0, LVITEM, 32, "Int64")  ;; add 8 lParam
	; NumPut(0, LVITEM, 40, "Int")  ;; add 64 UPtr iIndent
    ;; 40+4=44
		
    ; VarSetCapacity(ItemText, 2048, 0) ; text buffer
    ;   , VarSetCapacity(LVITEM, 40 + (A_PtrSize * 5), 0) ; LVITEM structure
    ;   , NumPut(7, LVITEM, 4, "Int")
    ;   , NumPut(0, LVITEM, 8, "Int")
    ;   , NumPut(&ItemText, LVITEM, 16 + A_PtrSize, "Ptr") ; pszText in LVITEM
    ;   , NumPut(1024 + 1, LVITEM, 16 + (A_PtrSize * 2), "Int") ; cchTextMax in LVITEM

	; result := DllCall("SendMessageW", UInt, hList, UInt, LVM_SETITEMSTATE, UInt, 0, UInt, &LVITEM) 
	; result := DllCall("SendMessageA", UInt, hList, UInt, LVM_SETITEMSTATE, UInt, 0, UInt, &LVITEM) 

    SendMessage, %LVM_SETITEMSTATE%,  0, % &LVITEM, , % "ahk_id " . hList ; LVM_GETITEMTEXT
	return result 
} 

LV_EX_GetItemParam(HLV, Row) {
    ; LVM_GETITEM -> http://msdn.microsoft.com/en-us/library/bb774953(v=vs.85).aspx
   Static LVM_GETITEM := A_IsUnicode ? 0x104B : 0x1005 ; LVM_GETITEMW : LVM_GETITEMA
   Static OffParam := 24 + (A_PtrSize * 2)
   LV_EX_LVITEM(LVITEM, 0x00000004) ; LVIF_PARAM
   SendMessage, % LVM_GETITEM, 0, % &LVITEM, , % "ahk_id " . HLV
   Return NumGet(LVITEM, OffParam, "UPtr")
}

LV_EX_SetItemIndent(HLV, Row, NumIcons) {
   Static LVM_SETITEM := A_IsUnicode ? 0x104C : 0x1006 ; LVM_SETITEMW : LVM_SETITEMA
   Static LVITEMSize := 48 + (A_PtrSize * 3)
   Static LVIF_INDENT := 0x00000010
   Static OffIndent := 24 + (A_PtrSize * 3)
   VarSetCapacity(LVITEM, LVITEMSize, 0)
   NumPut(LVIF_INDENT, LVITEM, 0, "UInt")
   NumPut(Row - 1, LVITEM, 4, "Int")
   NumPut(NumIcons, LVITEM, OffIndent, "Int")
   SendMessage, % LVM_SETITEM, 0, % &LVITEM, , % "ahk_id " . HLV
   Return ErrorLevel
}

LV_EX_LVITEM(ByRef LVITEM, Mask := 0, Row := 1, Col := 1) {
   Static LVITEMSize := 48 + (A_PtrSize * 3)
   VarSetCapacity(LVITEM, LVITEMSize, 0)
   NumPut(Mask, LVITEM, 0, "UInt"), NumPut(Row - 1, LVITEM, 4, "Int"), NumPut(Col - 1, LVITEM, 8, "Int")
}

imageSearch:
CoordMode Pixel  
            ImageSearch, SX,SY , 0,0, A_ScreenWidth, A_ScreenHeight,  *16 *16 %A_ScriptDir%\1.ico
            ; ImageSearch, SX,SY , 0,0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\d6000pd.PNG
            ; ImageSearch, SX,SY , 0,0, A_ScreenWidth, A_ScreenHeight,  D:\Applications\Scoop\apps\autohotkey\1.1.30.03\AutoHotkeyU64.exe
          if ErrorLevel = 2
    MsgBox Could not conduct the search.
else if ErrorLevel = 1
{
    MsgBox Icon could not be found on the screen.
}
else
    MsgBox The icon was found at %FoundX%x%FoundY%.
return

runLnk(){
        Run ,%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Microsoft Edge Canary.lnk
}

testTrayList(){
ControlGet, OutputVar, List,  , ToolbarWindow323, ahk_class Shell_TrayWnd
msgbox %OutputVar%
}

GetHotItem()
{
	SendMessage, 0x447, 0, 0, ToolbarWindow323, ahk_class Shell_TrayWnd	; TB_GETHOTITEM
	Return ErrorLevel << 32 >> 32
}


HitTest()
{
	; idxTB:=	GetTaskSwBar()
	ControlGet, hWnd, hWnd,, ToolbarWindow323, ahk_class Shell_TrayWnd
	WinGet, pid, PID, ahk_id %hWnd%
	hProc:=	DllCall("OpenProcess", "Uint", 0x38, "int", 0, "Uint", pid)
	pRB  :=	DllCall("VirtualAllocEx", "Uint", hProc, "Uint", 0, "Uint", 8, "Uint", 0x1000, "Uint", 0x4)
	DllCall("GetCursorPos", "int64P", pt)
	DllCall("ScreenToClient", "Uint", hWnd, "int64P", pt)
	DllCall("WriteProcessMemory", "Uint", hProc, "Uint", pRB, "int64P", pt, "Uint", 8, "Uint", 0)
	idx  :=	DllCall("SendMessage", "Uint", hWnd, "Uint", 0x445, "Uint", 0, "Uint", pRB)	; TB_HITTEST
	DllCall("VirtualFreeEx", "Uint", hProc, "Uint", pRB, "Uint", 0, "Uint", 0x8000)
	DllCall("CloseHandle"  , "Uint", hProc)
	Return	idx
}

testTray(){
    test := TrayIcon_GetInfo()
Loop, % test.MaxIndex()
    str .= test[A_Index].place " - " test[A_Index].idx " - " test[A_Index].process " - " test[A_Index].hwnd " - " test[A_Index].idcmd "`n"
MsgBox, %str%   
; WinActivate, %  info[1].hWnd

; WinGetPos, X, Y, Width, Height, ahk_id 197732
; WinClose, ahk_id %sid%
; WinGetClass, cc, ahk_id %hid%
; WinGetClass, sClass, ahk_id %hid%
; WinGetClass, s2Class, ahk_id %sid%
; msgbox % X "," Y "," cc "," hid "," sClass "," s2Class
}
testTrayPos(){
    ; hw_notification := FindWindow( "Shell_TrayWnd|TrayNotifyWnd|SysPager|ToolbarWindow32,Notification Area" )
    hw_notification:=WinExist("ahk_class Shell_TrayWnd")
    ; msgbox %hw_notification%
    WinGetPos, s_x, s_y, s_w, s_h, ahk_id %hw_notification%
    CoordMode, Pixel, Screen
    ImageSearch, t_x, t_y, s_x, s_y, s_x+s_w-1, s_y+s_h-1, *Icon1 D:\Applications\Scoop\apps\autohotkey\1.1.30.03\AutoHotkeyU64.exe
    msgbox % t_x "," t_y "," ErrorLevel
}

FindWindow( p_tree )
{
	level_total = 0

	loop, parse, p_tree, |
	{
		level_total++
		
		ix := InStr( a_LoopField, "," )

		if ( ix )
		{
			StringMid, tree[%level_total%]?class, a_LoopField, 1, ix-1
			StringMid, tree[%level_total%]?title, a_LoopField, ix+1, StrLen( a_LoopField )-ix
		}
		else
		{
			tree[%level_total%]?class := a_LoopField
			tree[%level_total%]?title = 0
		}
	}
	
	hw_parent = 0
	hw_child = 0
	
	level = 1
	
	loop,
	{
		hw_child := FindWindowEx( hw_parent, hw_child, tree[%level%]?class, tree[%level%]?title )

		if ( hw_child )
		{
			if ( level = level_total )
				return, hw_child
		
			level++
			
			hw_parent_old := hw_parent
			hw_parent := hw_child
			
			hw_child_old := hw_child	
			hw_child = 0
		}
		else
		{
			if ( level = 1 )
				return, 0
		
			level--
			
			hw_parent := hw_parent_old
			
			hw_child := hw_child_old
		}
	}
}

FindWindowEx( p_hw_parent, p_hw_child, p_class, p_title=0 )
{
	if ( p_title = 0 )
		type_title = uint
	else
		type_title = str

	return, DllCall( "FindWindowEx"
						, "uint", p_hw_parent
						, "uint", p_hw_child
						, "str", p_class
						, type_title, p_title )
}

testExec(){
    
}

testTimer()
{
        	Progress, m1 b fs20 zh0 w200, Enter # of minutes
	loop,2
	{
		Input x, L1,{enter}{esc},1,2,3,4,5,6,7,8,9,0
	if (ErrorLevel = "Match")
		Progress, m1 b fs70 fm12 zh10 w200, % tm .= x, Press Enter to accept
		else if (Errorlevel = "EndKey:enter")
			break
	}
	settimer,label,1000
	label:
	++y
	Progress, % 100*(tm*60-y)/(tm*60), % tm-floor(y/60)-1, % y>tm*60 ? tm*60-y : ((z:=mod(tm*60-y,60))=0 ? 60 : z)
	if (y = tm * 60)
		Progress, m1 b fs40 fm20 zh0 CTred w200, , done
    return
}

testArr(){
    a:=[]
    a.Push("djljlj")
    a.Push("ccc")
    for i,line in a{
        msgbox %line%
    }
}

testlog(){
	log("this is a test")
	log("this is a test2")
}


testGUI(){
	Gui, Font, underline
	Gui, Add, Text,cBlue , Click here to launch Google.
	Gui, Add, Custom, ClassSysIPAddress32 r1 w150 hwndhIPControl 
	Gui, Add, Edit, R20 ReadOnly, lassSysIPAddress32 r1 w150 hwndhIPControl 
	Gui,Show
}


testArrJoin(){
	global projectsArr:=Array()

projectsArr.Push("test")
projectsArr.Push("test2")
projectsArr.Join
global projects:=
    (Comments LTrim RTrim0 Join`s 
    "
	%projectsArr%
    ; D:\z_wd\hy\vlis-test
    ; D:\z_wd\hy\tigase-server-tigase-server-8.0.0
    ; D:\z_wd\gradle
    ; D:\z_wd\giftapp
    ; D:\z_wd\giftapp-templates\heart-drawing
    ; D:\z_wd\giftapp-templates\love-ornot-quasar
    ; D:\z_wd\lab\clumsy-bird
    "
    )
	projects:=join(projectsArr)
msgbox %projects%
}


testplay(){
	SoundPlay,C:\WINDOWS\Media\Linux Ubuntu\question.wav
	; SoundPlay, %A_WinDir%\Media\ding.wav
	; SoundPlay *-1  ; Simple beep. If the sound card is not available, the sound is generated using the speaker.
}
testadjust(){
	getWindowText("test")
;    RunWaitSilent("pause")
   run powershell
   Sleep 10000
}

testFile(){
	Run,D:\z_wd\test\Merriam-Webster's+Vocabulary+Builder+-+Merriam-Webster.pdf
}
testHide(){
   Run, D:\Applications\Scoop\apps\vivaldi\2.9.1705.41\Application\vivaldi.exe, , Min
}

testTrim(){
	   str:=" test ok    "
	   str:=Trim(str)
	   msgbox #%str%#
}

testHttpServer(){
	paths := {}
paths["/"] := Func("HelloWorld")
paths["404"] := Func("NotFound")
paths["/logo"] := Func("Logo")

server := new HttpServer()
server.LoadMimes(A_ScriptDir . "/mime.types")
server.SetPaths(paths)
server.Serve(8000)
msgbox start
}

testmsgbox(){
	; MsgBox, % 0x4 | 0x2000 | 0x10, , Need A Break? (Press YES or NO),2
	; MsgBox, % 0x4 | 0x40000 | 0x10, , Need A Break? (Press YES or NO),2
		MsgBox, % 0x4 | 0x40000 | 0x10, , Need A Break? (Press YES or NO),2
		IfMsgBox No
			return
        turnOffMonitor()
		;; block input for 5 seconds
		BlockInput, On
		BlockInput, MouseMove
		Sleep 5000
		BlockInput,Off
		BlockInput, MouseMoveOff
}

testBlock(){
		BlockInput, On
		BlockInput, MouseMove
		Sleep 5000
		BlockInput,Off
		BlockInput, MouseMoveOff
}

testCaps(){
	send {CapsLock}
}
testWinStyle(){
	Winget,Style,Style,A
	msgbox %Style%
}
testSound(){
	SoundPlay,C:\Windows\Media\Linux Ubuntu\startup.wav
}
testRunSilent(){
	; t:=RunWaitSilent("ls")
	; t:=RunWaitSilent("D:\Applications\Scoop\apps\autohotkey\current\AutoHotkey.chm",,true)
  
	; t:=RunWaitSilent2("ls")
	; t:=RunWaitSilent2("ls")
	; t:=RunWaitSilent2("java")
	; t:=RunWaitSilent2("D:\Applications\Scoop\apps\autohotkey\current\AutoHotkey.chm")
	ToolTip, %t%
	settimer,%mRemoveTooltip%,-2000
}





testTemporary(){
}


testTrayMsg(){
	TrayTip, test, test,,0
	msgbox ok
}

; WheelDown::n
;  msgbox ok
; return
SetOwner(hwnd, newOwner) {
    static GWL_HWNDPARENT := -8
    if A_PtrSize = 8
        DllCall("SetWindowLongPtr", "ptr", hwnd, "int", GWL_HWNDPARENT, "ptr", newOwner)
    else
        DllCall("SetWindowLong", "int", hwnd, "int", GWL_HWNDPARENT, "int", newOwner)
}

#=::
; testExec()
; testArr()
; testlog()
; testArrJoin()
;; testTimer()
	; Run "\"powershell.exe\" -Command 'ls'" /k,, Hide, pid
    ; msgbox ok 
;    SplashTextOn , , A, A
; TrayIcon_GetInfo()
; SplashImage , %Clipboard%,B
; SplashImage, Off
; SendMessage,0x21,0x0005076A,0x02010001,ToolbarWindow323, A
; SendMessage,0x20,0x00080748,0x02010001,ToolbarWindow323, A
; PostMessage, 0x201, , 0x01210012, ToolbarWindow323, A
; PostMessage, 0x202, , 0x01500017, ToolbarWindow323, A
; PostMessage, 0x2A3, 0x00000000, 0x00000000, ToolbarWindow323, A
; existTrayNoticeInfo()
; FormatTime, Time,,yyyyMMddHHmmss
; msgbox %Time%
; TrayTip, My Title, Multiline`nText
;  Run   "%windir%\system32\taskmgr.exe" 
	; Run *Runas Notepad
; msgbox % "c"="C"
; testTrayPos()
; testTray()
; test:=TaskButton("idea64.exe")
; idx:=HitTest()
; idx:=GetHotItem()
; TrayIcon_Button("autohotkeyu64.exe","R")
; testTrayList()
; runLnk()
; runWith()
; testGetOminibar()
; testUrl()
; testGetTitle()
;  testTitleBar()
; testWinStyle()
; testIfTopMost()
; testWinList()
; testDynamicString()
; TrayIcons() ;will remove dead icons
; RefreshTray()
; testMsg() 
; testplay()
; testadjust()
; testFile()
; testHide()
; testTrim()
; testHttpServer()
; testmsgbox()
; testBlock()
; testCaps()
; testRunSilent()
; testSound()
; testTrayMsg()

; testTemporary()

; Control, Hide ,, Control, WinTitle, WinText, ExcludeTitle, ExcludeText
;   Parent_Handle := DllCall( "FindWindowEx", "uint",0, "uint",0, "str", Window_Class, "uint",0) 
;    ControlClick, [Control-or-Pos, WinTitle, WinText, WhichButton, ClickCount, Options, ExcludeTitle, ExcludeText]
    ; WinMove, A, , , , 500, 474
	; MsgBox, %x% %y% %width% %height%, Title, Text, Timeout]



; ControlFocus, , ahk_id 0x00131B14
    ; SendMessage,0x111,4294967295,0,,A
;     giveTrayTip("test","test",5)

return 