global windowTitleInfo := Array()
global windowStyleInfo := Array()
global windowPIDInfo := Array()
global windowPNInfo := Array()
global windowClassInfo := Array()
global windowMMInfo := Array()
global autoIncludeClasses:=Array()
global windowIdInfoFd:=runtimeFolder . "\winIdInfo"

Gui +LastFound 
Process, Priority,, High
FileCreateDir, %windowIdInfoFd%

hWnd := WinExist()
DllCall( "RegisterShellHookWindow", UInt,hWnd )
MsgNum := DllCall( "RegisterWindowMessageW", Str,"SHELLHOOK" )
MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
OnMessage(MsgNum, "ShellMessageT" )

OnMessage(0x11F,"OnMenuItemSelect") ;; WM_MENUSELECT
OnMessage(0x4a, "Receive_WM_COPYDATA") ; 0x4a is WM_COPYDATA
OnMessage(0x201, "WM_LBUTTONDOWN")

; Register an object to be called on exit:
; OnExit(ObjBindMethod(MyObject, "Exiting"))
OnExit("ExitFunc")

ExitFunc(ExitReason, ExitCode)
{
	if ExitReason in Logoff,Shutdown
	{
		preventNextLock()
		; MsgBox, 4, , Are you sure you want to exit?
		; IfMsgBox, No
		; return 1  ; OnExit functions must return non-zero to prevent exit.
	}
	; Do not call ExitApp -- that would prevent other OnExit functions from being called.
}

class MyObject
{
	Exiting()
	{
		MsgBox, MyObject is cleaning up prior to exiting...
        /*
        this.SayGoodbye()
        this.CloseNetworkConnections()
		*/
	}
}

Receive_WM_COPYDATA(wParam, lParam)
{
	StringAddress := NumGet(lParam + 2*A_PtrSize) ; Retrieves the CopyDataStruct's lpData member.
	CopyOfData := StrGet(StringAddress) ; Copy the string out of the structure.
	; Show it with ToolTip vs. MsgBox so we can return in a timely fashion:
	ToolTip %A_ScriptName%`nReceived the following string:`n%CopyOfData%
	return true ; Returning 1 (true) is the traditional way to acknowledge this message.
}

WM_LBUTTONDOWN(wParam, lParam)
{
	;     X := lParam & 0xFFFF
	;     Y := lParam >> 16
	;     if A_GuiControl
	; Control := "`n(in control " . A_GuiControl . ")"
	;     ToolTip You left-clicked in Gui window #%A_Gui% at client coordinates %X%x%Y%.%Control%
}

windowTitleMatch(lParam, windowTitle){
	WinGetTitle, Title, ahk_id %lParam%
	FoundPos := RegExMatch(Title,windowTitle)
	; outputdebug % "title match:" . FoundPos . " "  . Title . " " . windowTitle
	If(FoundPos>0){
		return true
	}
	return false
}

windowClassMath(lParam, className){
	WinGetClass,clazz,ahk_id %lParam%
	FoundPos := RegExMatch(clazz,className)
}

onCreate(wParam,lParam){
	handleWinExploerReplace(wParam,lParam)
	handleTrayNotice(lParam)
}

autoStyle(lParam){
	Sleep 50
	Winset , Bottom,,%tTaskbar%
}

switchIME4Win(lParam){
	if(windowTitleInfo[lParam]=="BreakAsk"){
		return
	}
	for i,e in imeIgnore
	{
		if(e==lParam){
			SwitchIME(00000804) ; Chinese
			return
		}
	}
	SwitchIME(0x04090409) ; English
}

putInfoInfoWindowInfo(wParam,lParam){
	WinGetTitle, tt , ahk_id %lParam%
	WinGet,ss,Style,ahk_id %lParam%
	WinGet,pid,pid,ahk_id %lParam%
	WinGet,pn,ProcessName,ahk_id %lParam%
	WinGet,mm,MinMax,ahk_id %lParam%
	WinGetClass, cc , ahk_id %lParam%

	windowTitleInfo[lParam]:= tt 
	windowStyleInfo[lParam]:= ss 
	windowPIDInfo[lParam] := pid 
	windowPNInfo[lParam]:=pn
	windowMMInfo[lParam]:=mm
	windowClassInfo[lParam]:=cc
	return
}

removeWindowInfo(wParam,lParam){
	windowTitleInfo[lParam]:= ""
	windowStyleInfo[lParam]:= 0 
	windowPIDInfo[lParam] := 0
	windowPNInfo[lParam]:= ""
	windowMMInfo[lParam]:= ""
	windowClassInfo[lParam]:= ""
	return
}

onActivate(wParam,lParam){
	;; change input method to default en
	; switchIME4Win(lParam)
	autoStyle(lParam)
}

handleTrayNotice(lParam){
	tt:=windowTitleInfo[lParam]
	if(tt="New Notification" || tt="新通知"){
		;    handlePomodone(lParam)
	}
}

/*
handlePomodone(lParam){
	turnOnMonitor()
	Sleep 500
	text:=getWindowText("ahk_id " . lParam)
	if(containsInArr("Timer stopped",text)){
		Sleep 15000
		;; prevent lost of focus
		BlockInput, MouseMove
		Hotkey, Lbutton, % mNoOp,On
		Hotkey, Rbutton, % mNoOp,On
		; | 0x1000 
		MsgBox, % 0x4 | 0x10, BreakAsk, Need A Break? (Press YES or NO),5
		;; get back
		BlockInput, MouseMoveOff
		Hotkey, Lbutton, % mNoOp, Off
		Hotkey, Rbutton, % mNoOp, Off
		IfMsgBox No
			return
        turnOffMonitor()
	}
	else if(containsInArr("Break stopped",text)){
		sendMsgToPhone("Break stopped","by msg caller")
	}
}
*/

handleWinExploerReplace(wParam,lParam) {
	alsoHandleFolder:=false
	if(GetKeyState("Shift")){
		giveTooltip("replace folder")
		alsoHandleFolder:=true
	}
	pn:=windowPNInfo[lParam]
	if(pn="explorer.exe"){
		; outputdebug handle explorer
		WinWaitActive , ahk_id %lParam%,, 5
		if(ErrorLevel){
			return
		}
		sel:=Explorer_GetSelection(lParam)	
		for item in sel{
			f:=item.path
			; OutputDebug p %f%
			; Run, %TC_PATH%  /A /P=R /R="%f%" ,,,pid
			c:=TC_PATH . " /A /P=R /R='" . f . "'"
			; pid:=RunWithStyle(c)
			; Run, %Clipboard%,,,pid
			winclose ahk_id %lParam%
			RunWaitSilent(c)
			return
		}
		;; folder
		if(alsoHandleFolder){
			Send , ^l
			Sleep, 200
			Send, ^c
			Sleep, 100
			; Run, %TC_PATH%  /A /P=R /R="%Clipboard%" ,,,pid
			; pid:=RunWithStyle(TC_PATH . " /A /P=R /R=" . Clipboard )
			c:=TC_PATH . " /A /P=R /R='" . f . "'"
			winclose ahk_id %lParam%
			RunWaitSilent(c)
		}
	}
	return
}

OnMenuItemSelect(wParma,lParam)
{
	;  outputdebug lParam:[%lParam%]  wParam:[%wParam%] msg:%msg% hWnd:%hWnd%  title:%t% 
}

/*
if wParam = 1
		msg = HSHELL_WINDOWCREATED
	if wParam = 2
		msg = HSHELL_WINDOWDESTROYED
	if wParam = 3
		msg = HSHELL_ACTIVATESHELLWINDOW
	if wParam = 4
		msg = HSHELL_WINDOWACTIVATED
	if wParam = 5
		msg = HSHELL_GETMINRECT
	if wParam = 6
		msg = HSHELL_REDRAW
	if wParam = 7
		msg = HSHELL_TASKMAN
	if wParam = 8
		msg = HSHELL_LANGUAGE
	if wParam = 9
		msg = HSHELL_SYSMENU
	if wParam = 10
		msg = HSHELL_ENDTASK
	if wParam = 11
		msg = HSHELL_ACCESSIBILITYSTATE
	if wParam = 12	
		msg = HSHELL_APPCOMMAND
	if wParam = 13
		msg = HSHELL_WINDOWREPLACED
	if wParam = 14
		msg = HSHELL_WINDOWREPLACING
	if wParam = 15
		msg = HSHELL_HIGHBIT
	if wParam = 16
		msg = HSHELL_FLASH
	if wParam = 17
		msg = HSHELL_RUDEAPPACTIVATED
*/

GetMessageName( FieldN=0 ) {
	Global MsgNames

	MsgNames =
	(
		HSHELL_WINDOWCREATED
		HSHELL_WINDOWDESTROYED
		HSHELL_ACTIVATESHELLWINDOW
		HSHELL_WINDOWACTIVATED
		HSHELL_GETMINRECT
		HSHELL_REDRAW
		HSHELL_TASKMAN
		HSHELL_LANGUAGE
		HSHELL_SYSMENU
		HSHELL_ENDTASK
		HSHELL_ACCESSIBILITYSTATE
		HSHELL_APPCOMMAND
		HSHELL_WINDOWREPLACED
		HSHELL_WINDOWREPLACING
		HSHELL_HIGHBIT
		HSHELL_FLASH
		HSHELL_RUDEAPPACTIVATED
	)

	Loop, Parse, MsgNames, `n
		IfEqual, A_Index, %FieldN%, Return, A_LoopField
}

GetAppCommand( FieldN=0 ) {
	Global AppCommands

	AppCommands =
	(
		APPCOMMAND_BROWSER_BACKWARD = 1
		APPCOMMAND_BROWSER_FORWARD = 2
		APPCOMMAND_BROWSER_REFRESH = 3
		APPCOMMAND_BROWSER_STOP = 4
		APPCOMMAND_BROWSER_SEARCH = 5
		APPCOMMAND_BROWSER_FAVORITES = 6
		APPCOMMAND_BROWSER_HOME = 7
		APPCOMMAND_VOLUME_MUTE = 8
		APPCOMMAND_VOLUME_DOWN = 9
		APPCOMMAND_VOLUME_UP = 10
		APPCOMMAND_MEDIA_NEXTTRACK = 11
		APPCOMMAND_MEDIA_PREVIOUSTRACK = 12
		APPCOMMAND_MEDIA_STOP = 13
		APPCOMMAND_MEDIA_PLAY_PAUSE = 14
		APPCOMMAND_LAUNCH_MAIL = 15
		APPCOMMAND_LAUNCH_MEDIA_SELECT = 16
		APPCOMMAND_LAUNCH_APP1 = 17
		APPCOMMAND_LAUNCH_APP2 = 18
		APPCOMMAND_BASS_DOWN = 19
		APPCOMMAND_BASS_BOOST = 20
		APPCOMMAND_BASS_UP = 21
		APPCOMMAND_TREBLE_DOWN = 22
		APPCOMMAND_TREBLE_UP = 23
		APPCOMMAND_MICROPHONE_VOLUME_MUTE = 24
		APPCOMMAND_MICROPHONE_VOLUME_DOWN = 25
		APPCOMMAND_MICROPHONE_VOLUME_UP = 26
		APPCOMMAND_HELP = 27
		APPCOMMAND_FIND = 28
		APPCOMMAND_NEW = 29
		APPCOMMAND_OPEN = 30
		APPCOMMAND_CLOSE = 31
		APPCOMMAND_SAVE = 32
		APPCOMMAND_PRINT = 33
		APPCOMMAND_UNDO = 34
		APPCOMMAND_REDO = 35
		APPCOMMAND_COPY = 36
		APPCOMMAND_CUT = 37
		APPCOMMAND_PASTE = 38
		APPCOMMAND_REPLY_TO_MAIL = 39
		APPCOMMAND_FORWARD_MAIL = 40
		APPCOMMAND_SEND_MAIL = 41
		APPCOMMAND_SPELL_CHECK = 42
		APPCOMMAND_DICTATE_OR_COMMAND_CONTROL_TOGGLE = 43
		APPCOMMAND_MIC_ON_OFF_TOGGLE = 44
		APPCOMMAND_CORRECTION_LIST = 45
	)

	Loop, Parse, AppCommands, `n
		IfEqual, A_Index, %FieldN%, Return, A_LoopField
}

ShellMessageT( wParam,lParam,msg,hWnd )
{
	; outputdebug 

	Routine := GetMessageName(wParam)
	IfEqual,Routine,, SetEnv, Routine, UNKNOWN
	; GoSub, %Routine%
	putInfoInfoWindowInfo(wParam,lParam)
	tt:=windowTitleInfo[lParam]
	cc:=windowClassInfo[lParam]
	pid:=windowPIDInfo[lParam]
	pn:=windowPNInfo[lParam]

	; outputdebug [%Routine%:%wParam%] lParam:[%lParam%] msg:%msg% hWnd:%hWnd%  class:%cc% title:%tt%  
	; window show
	If( (wParam = 4 or wParam=32772 or wParam=53 or wParam=54) And WinExist("ahk_id " lParam)) ; HSHELL_WINDOWACTIVATED := 4 or 32772
	{
		onActivate(wParam,lParam)
	}
	; window open
	else	If ( wParam = 1 ) ;  HSHELL_WINDOWCREATED := 1
	{
		onCreate(wParam,lParam)
		f:=windowIdInfoFd . "\" . lParam
		FileAppend, % cc, % f
		; OutputDebug, % "onCreate:" lParam . " " . cc
	}
	else If (wParam=2) ;HSHELL_WINDOWDESTROYED
	{
		;	  outputdebug editor id is  %editorId%
	}
	else If(wParam = 6) ;HSHELL_REDRAW
	{
		onRedraw(wParam,lParam)
	}
	removeWindowInfo(wParam,lParam)

	f:="_T_" . tt . "_" . wParam
	OutputDebug, % "f" f
	if(IsFunc(f)){
		Func(f).call(wParam,lParam)
	}

	;; call spectific event
	f:=cc . "_" . wParam
	if(IsFunc(f)){
		Func(f).call(wParam,lParam)
	}

	f:= "exe_" . StrReplace(pn, "." , "_") . "_" . wParam
	if(IsFunc(f)){
		Func(f).call(wParam,lParam)
	}

	fu:="Ev" . "_UNKNOWN" 
	if(IsFunc(fu)){
		Func(fu).call(wParam,lParam)
	}

	if(wParam=2){
		fd:="Ev_DESTROY_DISPATCH"
		if(IsFunc(fd)){
			Func(fd).call(wParam,lParam)
		}
	}
}

onRedraw(wParam,lParam){
	; handleTrayNotice(lParam)
}

WinGetAtCoords(x,y,what="Title") { ; by SKAN and Learning one
	; Returns Title/ID/Class/PID of window at given coordinates 
	WinID := DllCall( "GetAncestor", UInt ; by SKAN
		,DllCall( "WindowFromPoint", Int,X, Int,Y )
	, UInt, GA_ROOT := 2)
	if (what = "Title" or what = "T") {
		WinGetTitle, WinTitle, ahk_id %WinID%
		Return WinTitle
	}
	else if (what = "ID" or what = "I")
		Return WinID
	else if (what = "Class" or what = "C") {
		WinGetClass, WinClass, ahk_id %WinID%
		Return WinClass
	}
	else if (what = "PID" or what = "P") {
		WinGet, WinPID, PID, ahk_id %WinID%
		Return WinPID
	}
}	; http://www.autohotkey.com/forum/viewtopic.php?p=341120#341120
