hShowProcMenu:
	sessionId:=getSessionId()
	mapDesktopsFromRegistry()
	WinGet, preWinId,Id,A
	winInfo:=Array()
	DetectHiddenWindows off
	cleanMenu("winListMenu")
	cleanMenu("IdeaMenu")
	cleanMenu("codeMenu")
	cleanMenu("editorMenu")
	WinList:=Array()
	WinGet,WinList,List,,,Program Manager
	count:=1
	; countLetter:=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
	countLetter:=["z","y","x","w","v","u","t","s","r","q","p","o","n","m","l","k","j","i","h","g","f","e","d","c","b","a","9","8","7","6","5","4","3","2","1","0"]
	extList:=Array()
	wwList:=Array()
	ideaCount:=0
	ideaLast:=""
	codeCount:=0
	codeLast:=""
	editorCount:=0
	editorLast:=""
	loop,%WinList%{
		Current:=WinList%A_Index%
		WinGetTitle,WinTitle,ahk_id %Current%
		if %WinTitle%
		{
			WinGetClass,WinClass,ahk_id %Current%
			if ( Winclass == "Windows.UI.Core.CoreWindow" || Winclass == "ApplicationFrameWindow" )
			{
				if(false){
					; outputdebug x %WinClass% %WinTitle%
				}else{
					extList.push(Current)
					Continue
				}
			}
			; outputdebug %count% %WinClass%
			Gosub , wwListAddItem
		}
	}
	;; sort
	Array_Quicksort.Call(wwList)
	for i,menuName in wwList {
		Gosub , winListAddMenu
	}
	Menu winListMenu, Add

	for i , Current in extList {
		WinGetTitle,WinTitle,ahk_id %Current%
		if %WinTitle%
		{
			Gosub,winListAddMenuMetro
		}
	}
	;; add idea sub menu
	if(ideaCount){
		ideaMenuName:="IDEA(&>)"
		if(ideaCount==1){
			winInfo[ideaMenuName]:=ideaLast
			winInfo[ideaLast]:=WinTitle
			menu winListMenu, Add , % ideaMenuName , hTaskHandle
		}else{
			menu ,winListMenu,add,%ideaMenuName% ,:IdeaMenu
		}
		Menu, winListMenu, Icon,%ideaMenuName%, %IDEA_PATH%
	}
	if(codeCount){
		codeMenuName:="VsCode(&<)"
		if(codeCount==1){
			winInfo[codeMenuName]:=codeLast
			winInfo[codeLast]:=WinTitle
			menu winListMenu, Add , % codeMenuName , hTaskHandle
		}else{
			menu ,winListMenu,add,%codeMenuName% ,:codeMenu
		}
		Menu, winListMenu, Icon,%codeMenuName%, %CODE_PATH%
	}
	if(editorCount){
		editorMenuName:="&Editor"
		if(editorCount==1){
			winInfo[editorMenuName]:=editorLast
			winInfo[editorLast]:=WinTitle
			menu winListMenu, Add , % editorMenuName , hTaskHandle
		}else{
			menu,winListMenu,Add ,%editorMenuName%,:editorMenu
		}
		WinGet, pp , ProcessPath , ahk_id %editorLast%
		Menu, winListMenu, Icon,%editorMenuName%, %pp%
	}
	if count
	{
		menu , winListMenu, Add,&+,:winListHideMetroMenu
		; currentPid:=DllCall("GetCurrentProcessId")
		; WinActivateWithHidden("ahk_pid " . currentPid)
		; MsgBox, %currentPid%
		menu winListMenu,show
		;; do not do this , cause issue active task bar
		; DetectHiddenWindows On
		; WinActivate ahk_id %A_ScriptHwnd%
		; WinActivate, ahk_exe AutoHotkeyU64.exe
	}
	preWinId:=0
return

genMenu:
	; WinGet, preWinId,Id,A
	Menu, myMenu, UseErrorLevel ; This affects all menus, not just the tray.
	Menu, MyMenu, NoDefault
	if (ErrorLevel = 0)
	{
		menu myMenu,deleteAll
	}

	menu showPointer, add , &Show, hShowPointer
	menu showPointer, add , &Hide, hHidePointer
	menu androidMenu, add , &Connect wifi adb, hConnectWifiAdb
	menu androidMenu, add , &Show Pointer, :showPointer
	menu myMenu, add , &Android, :androidMenu
	; menu myMenu, add , &ScrCpy, hScrCpy
	menu myMenu, add , Get &Color, hGetColor
	menu mQuickTool, add , Edit act &Var, hTriggerEditActVar 
	; menu myMenu, add , &Fire actions, :mTriggerAction
	menu mQuickTool, add , &TmpTerm, hOpenTermAtTmp
	menu mQuickTool, add , &bc , hOpenBc 
	menu mQuickTool , add , &Monitor off, % mTurnMonitorOff
	menu mQuickTool , add , &FuckGfw, hOpenFuckGfw
	menu myMenu, add , &Quick tool, :mQuickTool
	menu Inputs, add , Adb &Devices, hShowAdbDeviceMenu
	menu Inputs, add , Adb &Tasks, hShowTaskTexts
	menu myMenu, add , &Inputs, :Inputs
	menu Debug, add , &AhkWndSpy, hOpenAhkWndSpy
	menu Debug, add , &Help, hOpenAhkHelp
	menu Debug, add , Dbg&Viewr, hOpenDbgViewer
	menu myMenu, add , &Debug, :Debug
	Gosub hTrayList
	menu myMenu, add, Tray&List, :trayListMenu
	actionInfo:=Array()
	actionAfter:=Array()
	lastIdx:=0
	for i, e in actionsArr{
		m:="&" RegExreplace(e, "^do")
		actionInfo[i]:=e
		menu actionsMenu, add, % m, hDoAction
	}
	lastIdx+=actionsArr.Length()
	for i, e in actionAfter{
		j:= lastIdx+ i
		actionInfo[j]:=e
		m:= RegExreplace(e, "") . "&After"
		menu actionsMenu, add , % m , hDoActionAfter
	}
	lastIdx+=actionAfter.Length()
	if(!added){
		for i, e in performTasksNoAsk{
			performTasks.push(e)
		} 
		added:=true
	}
	for i, e in performTasks
	{
		j:= lastIdx+ i
		actionInfo[j]:=e
		m:="&" . i . "`t" . RegExreplace(e, "")
		menu actionsMenu, add, % m, hDoTNTask
	}
	menu myMenu,add, &\Quick Actions,:actionsMenu
	menu myMenu,add , &+, :mMisc
	; menu myMenu,add, ToggleTaskbar,toggleTaskbar
	; currentPid:=DllCall("GetCurrentProcessId")
	; WinActivateWithHidden("ahk_pid " . currentPid)
	; WinActivate, ahk_pid %currentPid%
	Menu, myMenu, Icon, &Quick tool, shell32.dll,145,
	menu myMenu,show
	; preWinId:=0
return

hOpenAhkHelp:
	t:="AutoHotkey Help"
	if(!WinExist(t)){
		RunWaitSilent(Scoop . "\apps\autohotkey-installer\current\AutoHotkey.chm",,,false)
	}
	WinActivate, %t%,,5
return

hOpenDbgViewer:
	t:="ahk_exe dbgview.exe"
	if(!WinExist(t)){
		Run, % Scoop . "\apps\sysinternals\current\Dbgview.exe"
	}
	WinActivate, %t%,,5
return

wwListAddItem:
	winget , pn, ProcessName, ahk_id %Current%
	winget , id, id, ahk_id %Current%
	; if(count<10){
	; menuName:="" . count . " `&" . pn . " " .   WinTitle
	; }else{
	; letter:=countLetter.Pop()
	; menuName:="" . letter . " `&" . pn . " " . WinTitle
	; }
	WinTitle:=WinTitle . " " . RegExreplace(Current,"^0x","")
	if(id=preWinId){
		menuName:= "`&: " pn . " " . WinTitle
	}
	else if( pn = "idea64.exe"){
		ideaCount++
		match:=RegExMatch(WinTitle, "(.*?\[.*?\])" , tt)
		if(match<1){ ;; nomatch
			tt:=WinTitle
		}
		ideaMenuItemName:= "&" . tt
		winInfo[ideaMenuItemName]:=Current
		winInfo[Current]:=WinTitle
		ideaLast:=Current
		menu IdeaMenu, Add , % ideaMenuItemName , hTaskHandle
		return
	}
	else if( pn = "Code.exe"){ 
		codeCount++
		codeMenuItemName:= "&" . RegExreplace(WinTitle,"- Visual Studio Code$","")
		winInfo[codeMenuItemName]:=Current
		winInfo[Current]:=WinTitle
		codeLast:=Current
		menu codeMenu, Add , % codeMenuItemName , hTaskHandle
		return
	}
	else if(pn = "gvim.exe" || pn="notepad2.exe"){
		editorCount++
		editorMenuItemName:= "&" . WinTitle
		winInfo[editorMenuItemName]:=Current
		winInfo[Current]:=WinTitle
		editorLast:=Current
		menu editorMenu, Add , % editorMenuItemName , hTaskHandle
		return
	} 
	else if( pn = "chrome.exe"){
		menuName:= "`&Google " . pn . " " . WinTitle
	}
	else if( pn = "scrcpy.exe" ){
		if(RegExMatch(WinTitle, "Scoop|scrcpy")>0){
			menuName:= pn . " " . WinTitle
		}else{
			menuName:= "`&" . WinTitle . " " . pn
		}
	}
	else{
		excludes:=[]
		f:=SubStr(pn, 1 , 1)
		if(isStrInLlist(f,excludes)){
			l:=countLetter.Pop()
			menuName:="`&" . l . " " . pn . " " . WinTitle
		}else{
			menuName:= "`&" . pn . " " . WinTitle
		}
	}

	;; desktop id
	dNum:=getDesktopNum(Current,sessionId)
	if(dNum==CurrentDesktop){
	}else{
		menuName:= menuName . "`t[" . CurrentDesktop . " --> " . dNum . "]"
	}

	winInfo[menuName]:=Current
	winInfo[Current]:=WinTitle
	wwList.push(menuName)
return

winListAddMenu:
	menu ,winListMenu,add,%menuName% ,hTaskHandle
	Current:=winInfo[menuName]
	WinGet, pp , ProcessPath , ahk_id %Current%
	Menu, winListMenu, Icon,%menuName% , %pp%
	count++
return

winListAddMenuMetro:
	winget , pn, ProcessName, ahk_id %Current%
	menuName:= StrReplace(WinTitle, "Microsoft " , "Microsoft &", , 1) . " " . pn 
	winInfo[menuName]:=Current
	winInfo[Current]:=WinTitle
	menu ,winListHideMetroMenu,add,%menuName% ,hTaskHandle
	WinGet, pp , ProcessPath , ahk_id %Current%
	Menu, winListHideMetroMenu, Icon, %menuName% , %pp%
	WinGet, mm , MinMax , ahk_id %Current%
	WinGet, ss , Style , ahk_id %Current%
	; outputdebug Metro Item: %mm% %ss% %pp% %menuName% %Current%
	; Menu, winListHideMetroMenu, Disable, %menuName%
	count++
return

subTaskHandleCenter:
	winMoveCenter("ahk_id " . hnd) 
return

subTaskHandleTopMost:
	WinSet, AlwaysOnTop, On , % "ahk_id " . hnd
return

subTaskHandleNoAlwaysOnTop:
	WinSet, AlwaysOnTop, Off , % "ahk_id " . hnd
return

subTaskHandleSwitchTo:
	WinActivate ahk_id %hnd%
return

subTaskHandleClose:
	WinClose ahk_id %hnd%
return

subTaskHandleMinimize:
	WinMinimize, ahk_id %hnd%
return

subTaskHandleMaximize:
	WinMaximize, ahk_id %hnd%
return

subTaskHandleKill:
	WinKill, ahk_id %hnd%
return

subTaskHandleCopyProId:
	WinGet,pid,pid, ahk_id %hnd%
	Clipboard:=pid
return

subTaskHandleCopyProPath:
	WinGet,pp,ProcessPath, ahk_id %hnd%
	Clipboard:=pp
return

subTaskHandleCopyHexId:
	Clipboard:=hnd . ""
return

subTaskHandleCopyTitle:
	WinGetTitle,tt, ahk_id %hnd%
	Clipboard:=tt
return

subTaskToggleTitlebar:
	WinSet, style,^0xC00000, ahk_id %hnd%
return

hNoOp:
return

hTaskHandle:
	hnd:=winInfo[A_ThisMenuItem]
	if(!hnd){
		error(A_ThisMenuItem)
		for i,e in winInfo{
			error(i . " : " . e)
		}
		throw % "no hnd:" . hnd
	}
	GetKeyState, C, Tab, P
	if(C = "D"){
		WinClose ahk_id %hnd% 
		Gosub, hShowProcMenu
		return 
	}
	GetKeyState, M, Shift, P
	if(hnd=preWinId || M="D"){
		; Menu,  subMenu, Add ,  &Center, subTaskHandleCenter
		; Menu, winListMenu, Add, A_ThisMenuItem , :subMenu
		cleanMenu(A_ThisMenuItem)
		t:=StrReplace(A_ThisMenuItem, "&")
		Menu, % A_ThisMenuItem, Add , % t, hNoOp
		Menu, % A_ThisMenuItem, Add
		Menu, % A_ThisMenuItem, Add , &SwitchTo , subTaskHandleSwitchTo
		Menu, % A_ThisMenuItem, Add , AlwaysOn&Top, subTaskHandleTopMost
		Menu, % A_ThisMenuItem, Add , &NoAlwaysOnTop, subTaskHandleNoAlwaysOnTop
		Menu, % A_ThisMenuItem, Add , C&enter, subTaskHandleCenter
		Menu, % A_ThisMenuItem, Add , &Close, subTaskHandleClose
		Menu, % A_ThisMenuItem, Add , M&iniMize, subTaskHandleMinimize
		Menu, % A_ThisMenuItem, Add , M&aximize, subTaskHandleMaximize
		Menu, % A_ThisMenuItem, Add , &Kill, subTaskHandleKill
		Menu, % A_ThisMenuItem, Add , &1 Process Id, subTaskHandleCopyProId
		Menu, % A_ThisMenuItem, Add , &2 Process Path, subTaskHandleCopyProPath
		Menu, % A_ThisMenuItem, Add , &Hex Id, subTaskHandleCopyHexId
		Menu, % A_ThisMenuItem, Add , &Get Title, subTaskHandleCopyTitle
		Menu, % A_ThisMenuItem, Add , &3 Toggle title bar, subTaskToggleTitlebar
		Menu, % A_ThisMenuItem, Disable , % t
		Menu, % A_ThisMenuItem, show
		return
	}
	; hnd:=winInfo[A_ThisMenuItemPos]
	WinActivate ahk_id %hnd%
Return

return

hTriggerEditActVar:
	Run %CODE_PATH% %A_ScriptDir%\configvar.ahk
return

hTrayList:
	trayinfoO:=array()
	cleanMenu("trayListMenu")
	list:=TrayIcon_GetInfo()

	for i,e in list
	{
		shortCode:=""
		if(e.Tooltip && Asc( SubStr(e.ToolTip, 1, 1) ) >= 128){
			shortCode:=SubStr(e.Process, 1 , 1) "|"
		}
		m:= "&" shortCode e.Tooltip " [" e.Process "]" " [" i "]"
		pp:=e.ProcessPath
		hIcon:=e.hIcon
		Menu, trayListMenu, Add ,% m, hOpenContextMenuOfTrayItem
		;  OutputDebug % "trayinfo(m):" i " " e.msgID " " e.uID " " e.hWnd " icon:" hIcon
		;  Menu,trayListMenu,Icon, %m%, %pp% 
		Menu,trayListMenu,Icon, %m%, % "hicon:" . hIcon
		trayinfoO[i] := e
	}
return

hShowTrayList:
	Gosub, hTrayList
	Menu , trayListMenu, show
return

hOpenContextMenuOfTrayItem:
	e:=trayinfoO[A_ThisMenuItemPos]
	; OutputDebug % "trayinfo:" A_ThisMenuItemPos " " e.msgID " " e.uID " " e.hWnd 
	if(GetKeyState("Shift", "P")){
		TrayIcon_Button2(e.msgID,e.uID,e.hWnd,"R")
	}else if(GetKeyState("Ctrl", "P")){
		TrayIcon_Button2(e.msgID,e.uID,e.hWnd,"L",true)
	}else{
		TrayIcon_Button2(e.msgID,e.uID,e.hWnd,"L",false)
	}
return

hOpenAhkWndSpy:
	if(WinExist("Window Spy")){
		WinClose, Window Spy
		return
	}
	SplitPath, % A_AhkPath ,file , dir, ext, OutNameNoExt, OutDrive
	Run %A_AhkPath% %dir%\WindowSpy.ahk
return

hShowAdbDeviceMenu:
	cleanMenu("hShowAdbDeviceMenu")
	devices:=RunWaitSilent("adb devices")
	Loop, parse, devices, `n, `r 
	{
		if(A_Index>1 && A_LoopField){
			s:=StrSplit(A_LoopField, A_Tab,,2)
			menu hShowAdbDeviceMenu , add , % "&" s[1], hMenuItemPate
		}
	}
	menu hShowAdbDeviceMenu, show
return

hMenuItemPate:
	p:=""
	f:=SubStr(A_ThisMenuItem, 1 , 1)
	if(f=="&"){
		p:=SubStr(A_ThisMenuItem, 2 )
	}else{
		p:=A_ThisMenuItem
	}
	SendInput %p%
return

hOpenBc:
	Gosub , hOpenTerm
	Sleep 500
	SendInput bash -c "bc -l" {enter}
	if(GetKeyState("Ctrl")){
		Sleep 500
		Send obase=10`;ibase=16`;{enter}
	}else if(GetKeyState("Shift")){
		Sleep 500
		Send obase=2`;ibase=10`;{enter}
	}
return

hOpenFuckGfw:
	runVivaldi("-profile-directory=""Profile 3"" --incognito")
return

hOpenTermAtTmp:
	hOpenVsCodeTerm( juncDir . "\" . focusTermDir)
return

hOpenTerm:
	prepareVsCode() 
/* 	WinGet, pn,ProcessName,A
	if(pn=="Code.exe"){
		Send {f1}{Esc} 
		Send !{f12}
	} 
	*/
return

hDoAction:
	action:=actionInfo[A_ThisMenuItemPos] 
	runWithAfter:=false
	if(GetKeyState("Shift")){
		runWithAfter:=true
	}
	Run %A_AhkPath% %A_ScriptDir%/DirectCall.ahk %action%
	if(runWithAfter){
		Run %A_AhkPath% %A_ScriptDir%/DirectCall.ahk %action%After
	}
return

hDoActionAfter:
	action:=actionInfo[A_ThisMenuItemPos] 
	Run %A_AhkPath% %A_ScriptDir%/DirectCall.ahk %action%After 
return

hDoTNTask:
	action:=actionInfo[A_ThisMenuItemPos] 
	performT1(action) 
return

hShowPointer:
	ret:=RunWaitSilent("adb shell settings put system pointer_location 1 " , true)
return

hHidePointer:
	ret:=RunWaitSilent("adb shell settings put system pointer_location 0 " , true)
return

hConnectWifiAdb:
	ret:=RunWaitSilent("adb connect " . device, true)
return 

hGetColor:
	MouseGetPos, mouseX, mouseY
	; 获得鼠标所在坐标，把鼠标的 X 坐标赋值给变量 mouseX ，同理 mouseY
	PixelGetColor, color, %mouseX%, %mouseY%, RGB
	; 调用 PixelGetColor 函数，获得鼠标所在坐标的 RGB 值，并赋值给 color
	StringRight color,color,6
	; 截取 color（第二个 color） 右边的 6 个字符，因为获得的值是这样的：#RRGGBB，一般我们只需要 RRGGBB 部分。把截取到的值再赋给 color（第一个 color）。
	clipboard = %color%
	; 把 color 的值发送到剪贴板
return

hContentMenuClick:
	clipboard:=contentO[A_ThisMenuItem]
	send ^v 
return 

hlockDesktop:
	send #l
return

hShowTaskTexts:
	token:="eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJqdGkiOiI1ZDM0NDI2NDA5NDU5NjVkZjIyNDlmYjIiLCJpYXQiOjE1NjM3OTQ2ODksImlzcyI6Imh0dHA6XC9cL215LnBvbW9kb25lYXBwLmNvbSIsImV4cCI6MTU5NTMzMDY4OX0.TX3mKjnjYN0YexVTWxp5PNGSGVFcmd4_qF7C2fY2CJgOFnpkamurojdDAJmcqFrFzdHl2AbSliGETdQa3bVr7H2ouqhrFEei2Ioj9BMMDp0eumJw9-pqQFHFU1TsDHl5DrBrB7u3N9RU1PLXgPaOWTJbC6pZZKShGgt4-T8jakKCWTj60zx9qLA0Erh51srCsOnXce31HxUKuao2kqAyT0M1IT__bvfrwr8dQDj4k9v3iiUxaeuDp2Hfrx3JZ9kKeLCTlFbQ7swf3YuGsCCXaXev2mxargfU_qWiDwNwE4NRVe9fpCJropxrtVB2R5R5cXkDn4an-GoRm3Ao5uwHjQ"
	url:= "https://my.pomodoneapp.com/api/v2/data/?client=win&service=outlook&token=" . token
	oWhr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	; oWhr.SetProxy(2,"http://127.0.0.1:8888")
	oWhr.SetTimeouts(10000, 10000, 10000, 10000)
	oWhr.Open("GET", url, false)
	oWhr.SetRequestHeader("Content-Type", "application/json")
	; oWhr.SetRequestHeader("Authorization", "Bearer 80b44ea9c302237f9178a137d9e86deb-20083fb12d9579469f24afa80816066b")
	oWhr.Send()
	status:=oWhr.Status

	value := JSON.Load( oWhr.responseText )
	Menu, contentMenu, UseErrorLevel

	if(UseErrorLevel){
		Menu contentMenu , delete
		Menu contentMenu, Add
	}

	count:=0
	contentO:=Array()
	countLetter:=["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
	; countLetter:=["z","y","x","w","v","u","t","s","r","q","p","o","n","m","l","k","j","i","h","g","f","e","d","c","b","a"]
	for i,e in value.cards{
		letter:=countLetter.RemoveAt(1)
		content:= "&" . letter . " " . e.title
		Menu contentMenu , add , %content% , hContentMenuClick
		contentO[content]:=e.title
		count++
	}

	if(count>0){
		SoundBeep
		Menu contentMenu, show
	}
return

