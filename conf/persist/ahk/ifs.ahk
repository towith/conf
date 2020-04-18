#IfWinActive, ahk_exe PotPlayerMini64.exe
	NumpadLeft::
		send {space}+z{left 2}{enter}{space}
	return
	NumpadRight::
		send {space}+z{right 2}{enter}{space}
	return
	#IfWinActive 

		#IfWinActive, ahk_class QPasteClass
			^enter::
				text:=getText()
				execString(text,true)
			return
			enter::
				if(GetKeyState("space", "P")){
					text:=getText()
					callWinRun(text)
				}else{
					send {enter}
				}
			return
			getText(){
				ControlGet, sel, List,Selected, SysListView321, A
				text:=RTrim(StrSplit(sel, "|", ,2)[2])
				if(SubStr(text,text.Length)=="`n"){
					StringTrimRight, text, text, 1
				}
				WinClose, ahk_class QPasteClass
			return text
		}
		callWinRun(text:=""){
			Send #r
			WinWaitActive , Run,,5
			if(ErrorLevel){
			return
		}
		ControlSetText,Edit1,%text%,Run
		return
	}
	setRow(Row_To_Focus:=0){
		Gui_ID := WinExist("A")
		ListView_Control_ID := GetChildHWND(Gui_ID, "SysListView321")
		; OutputDebug, id %ListView_Control_ID% pid %Gui_ID%
		;; not work
		; LV_Modify(Row_To_Focus, "Focus Select") 
		; PostMessage, 0x1000+19, Row_To_Focus-1, 0,, ahk_id %ListView_Control_ID% 
	}
#IfWinActive

#IfWinActive, ahk_exe scrcpy.exe
	^+p::
		TryScrCpyUnlock()
	return
	^g::
		CoordMode, Mouse, client
		draw001()
	return
	#ifwinactive 

		#ifwinactive ahk_class ConsoleWindowClass
			!f4::
				winclose , A
			return 

			#IfWinActive, ahk_class TTOTAL_CMD
			^g::
				;   PostMessage,0x111,251,0,,A
				;   PostMessage,0x111,251,0,,A
				;   return
				send ^+c
				Sleep, 50
				ControlGetText, p, Edit2, A
				if(p=="\\Desktop\"){
					p:=UserProfile . p
				}
				Run, wt,%p%
			return
			^+g::
				send ^+c
				Sleep, 50
				ControlGetText, p, Edit2, A
				if(p=="\\Desktop\"){
					p:=UserProfile . p
				}
				hOpenVsCodeTerm(p)

			return
			^.::
				send ^3
				Sleep, 50
				showGitLink(clipboard) 
			return 
#IfwinActive

#IfWinExist, ahk_class Microsoft.IME.UIManager.CandidateWindow.Host
	#IfWinExist

#IfWinActive, ahk_class Chrome_WidgetWin_1
	!+enter::
		send ^c
		Sleep 100
		WinActivate, % tTDX,, 3
		if(ErrorLevel=1){ 
			return
		}
		send 0
		While(True){
			ControlGetFocus, OutputVar , A
			if(OutputVar=="Edit1"){
				break
			}else{
				Sleep, 500
			}
		}
		ControlSetText ,Edit1, % Trim(Clipboard), A

	return
	!x::
		Send x
		WinActivate %tTDX%
	return
	!i::
		oldValue:=clipboard
		Send {Blind}{RButton}
		Sleep 50
		SendEvent e
		Run "C:\Program Files (x86)\Internet Download Manager\IDMan.exe" %clipboard% 
		WinWaitActive ahk_exe IDMan.exe,,5
		if(ErrorLevel){
			return
		}
		Send !t
		send a 
		WinWaitActive Enter new address to download,,5
		if(ErrorLevel){
			return
		}
		send ^c
		clipboard:=oldValue
	return
	!b::
		old:=clipboard
		send ^l
		Sleep 50
		send ^c
		Sleep 50
		url:=clipboard
		newUrl:=RegExReplace(url, ".*\?q=", "", , 1)
		SendInput, % "b " newUrl "{enter}"
		clipboard:=old
	return
#ifwinactive

#IfWinActive, ahk_exe scrcpy.exe
	^enter:: 
		ss:=getSerialNumber()
		runwait adb -s %ss% shell input mouse tap 1017 1096 ; wx send
	return
	!enter::
		ss:=getSerialNumber()
		runwait adb -s %ss% shell input mouse tap 906 1096 ; wx choose emotion
	return
	; +enter:: runwait adb shell input mouse tap 931 947.5 ;  mi 
	+enter::
		ss:=getSerialNumber()
		runwait adb -s %ss% shell input mouse tap 928 868 ;  
	return
	getSerialNumber(){
		wingettitle , tt, ahk_exe scrcpy.exe
		s:=""
		if(tt = "MI 5X")
		{
			s:= "4462de180804"
		} else if (tt="D6000"){
			s:="eda13ccf"
		}
	return s
}
#IfWinActive

#IfWinActive, ahk_class CabinetWClass
	^g::
		Send ^l
		ControlGetText, p, Edit1, A
		hOpenVsCodeTerm(p)
	return
#IfWinActive

#IfWinActive, ahk_exe idea64.exe
	^+g:: ;; go to chrome debuge same line in idea
		old:=Clipboard
		send ^!+c
		Sleep 200
		if(InStr(clipboard,".vue:") >0 ){
			; clipboard := "(no domain)" . clipboard
		}else if(Instr(clipboard,".js:") > 0){
			; clipboard := "webpack:///./" . clipboard
		}
		WinActivate , %tChrome%
		WinWaitActive , %tChrome% ,, 5
		if(ErrorLevel){
			return
		}
		clipboard:=StrReplace(clipboard, " ","%20" )
		send ^o
		Sleep 200
		send ^v
		clipboard:=old
	return
	gotoFile(IDEA_PATH,pj,target){
		; Run %IDEA_PATH% %pj% %target%
		send ^+a
		WinWait, ahk_class SunAwtWindow,,5
		send open{enter}
		WinWait, ahk_class SunAwtDialog,,5
		send {raw}%target%
		Sleep 50
		send {ctrl down}{enter}{ctrl up}
	}
	!o::
		old:=Clipboard
		send ^+c
		Sleep 50
		fileName:=clipboard
		WinGetTitle, tt, A
		ttArr:=StrSplit(tt,A_Space,,2)
		pj:=ttArr[1]
		SplitPath, fileName, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
		if(OutExtension="java"){
			pair:=getFileRepPair(pj,"class")
			if(pair){
				StringReplace, OutDir, % OutDir,% pair[1] ,% pair[2]
				target:=OutDir . "\" . OutNameNoExt . ".class"
				pj:=pair[3]
				;    outputdebug % "1 "  pair[1]  " 2 " pair[2] " o " OutDir " t " target
				giveTooltip("try open " . target,1)
				if(FileExist(target)){
					gotoFile(IDEA_PATH,pj,target)
				}else{
					TrayTip, Goto Failed, % target " does not exist", , 3
				}
			}else{
				giveTooltip("can not find " OutExtension " pair for this project",5)
			}
		}else{
			pair:=getFileRepPair(pj,OutExtension)
			if(pair){
				StringReplace, OutDir, % OutDir,% pair[1] ,% pair[2]
				target:=OutDir . "\" . OutNameNoExt . "." . OutExtension
				pj:=pair[3]
				;    outputdebug % "1 "  pair[1]  " 2 " pair[2] " o " OutDir " t " target
				giveTooltip("try open " . target,1)
				if(FileExist(target)){
					gotoFile(IDEA_PATH,pj,target)
				}else{
					TrayTip, Goto Failed, % target " does not exist", , 3
				}
			}else{
				giveTooltip("can not find " OutExtension " pair for this project",5)
			}
		}
		clipboard:=old
	return
	getFileRepPair(pj:="",type:=""){
		if(!type){
			return
		}
		Loop
		{
			FileReadLine, line, % UserProfile . "\Documents\idea.output.path", %A_Index%
			if ErrorLevel
				break
			if(line){
				lineArr:=StrSplit(line, "=", ,2)
				if(lineArr[1]=pj . "_" type){
					pairStr:=lineArr[2]
					pairArr:=StrSplit(pairStr, "|", ,3)
					return pairArr
				}else if(lineArr[1]=pj . "_*"){
					pairStr:=lineArr[2]
					pairArr:=StrSplit(pairStr, "|", ,3)
					return pairArr
				}else {
					Continue
				}
			}
		}
		throw "can not find pair for " . pj . " " . type
	}
	; ^!w up::
	;    if(GetKeyState("Ctrl")){
	; 	   KeyWait, Ctrl, U
	;    }
	;    if(GetKeyState("Alt")){
	; 	   KeyWait, Alt, U
	;    }
	;    send ^!+l
	;    Sleep 100
	;    send {Alt Down}w{Alt up}
	;    Sleep 50
	;    send {enter}
	; return
	; ^!l:: 
	;    if(GetKeyState("Ctrl")){
	; 	   KeyWait, Ctrl, U
	;    }
	;    if(GetKeyState("Alt")){
	; 	   KeyWait, Alt, U
	;    }
	;    send ^!+l
	;    Sleep 100
	;    send {Alt Down}v{Alt up}
	;    Sleep 50
	;    send {enter}
	; return
#IfWinActive

#IfWinActive, ahk_exe Taskmgr.exe|procexp64.exe
	!k:: 
		ControlGet, OutputVar, List, Focused Col1, SysListView321,A
		MsgBox, 4,, Would you like to kill all process %OutputVar%? (press Yes or No)
		IfMsgBox Yes
		{
			RunAs
			Run *RunAs cmd.exe /c taskkill /F /IM %OutputVar%
		}
	return
	*^1::
	*^2::
	*^3::
	*^4::
	*^5::
	*^6::
	*^7::
	*^8::
	*^9::
	*^0::
		pos:=RegExMatch(A_ThisHotkey, "\d" , num)
		if(GetKeyState("Shift", "P" )){
			ControlGet, OutputVar, List, Focused Col1%num%, SysListView321,A
		}else{
			ControlGet, OutputVar, List, Focused Col%num%, SysListView321,A
		}
		clipboard:=OutputVar
		giveTooltip( "Copyed: " clipboard)
	return
#IfWinActive

#IfWinActive, ahk_exe KeePassXC.exe
	^LButton::
		dcTime:=DllCall("GetDoubleClickTime")	
		if(A_PriorHotkey = A_ThisHotkey && A_TimeSincePriorHotkey < dcTime) {
			send !{tab}
			WinWaitNotActive, ahk_exe KeePassXC.exe
			Send ^v
			; WinSet,	Bottom,,A
		}
	return
#IfWinActive

#IfWinActive, ahk_exe GSP5.exe
	!2::
		PostMessage, 0x0201,0x00000001,0x003D0025 ,ToolbarWindow323, A ;; WM_LBUTTONDOWN
		PostMessage, 0x0202,0x00000000,0x003D0025 ,ToolbarWindow323, A ;; WM_LBUTTONUP
	return
	!3::
		PostMessage, 0x0201,0x00000001,0x0077001C ,ToolbarWindow323, A ;; WM_LBUTTONDOWN
		PostMessage, 0x0202,0x00000000,0x0077001C ,ToolbarWindow323, A ;; WM_LBUTTONUP
	return
	!4::
	return
	!6::
		PostMessage, 0x0201,0x00000001,0x01060016 ,ToolbarWindow323, A ;; WM_LBUTTONDOWN
		PostMessage, 0x0202,0x00000000,0x01060016 ,ToolbarWindow323, A ;; WM_LBUTTONUP
	return
	!7::
		PostMessage, 0x0201,0x00000001,0x01260019 ,ToolbarWindow323, A ;; WM_LBUTTONDOWN
		PostMessage, 0x0202,0x00000000,0x01260019 ,ToolbarWindow323, A ;; WM_LBUTTONUP
	return
	!8::
		PostMessage, 0x0201,0x00000001,0x015F001F ,ToolbarWindow323, A ;; WM_LBUTTONDOWN
		PostMessage, 0x0202,0x00000000,0x015F001F ,ToolbarWindow323, A ;; WM_LBUTTONUP
	return
#IfWinActive

#IfWinActive, ahk_exe spyxx_x86.exe
	^c::
		cc:=3
		clipboard:=""
		if(!WinExist("Message Properties"))
		{
			Send, {RButton}
			Sleep 50
			Send, {up}
			Sleep 50
			Send,{enter}
			WinWait, Message Properties,,5
			if(WinActive("Message Properties")){
				send !{tab}
				Sleep 50
				Send {lbutton}
				Sleep 50
			}
		}

		Loop, %cc%
		{
			if(A_Index<>1){
				Send {down}
				Sleep 50
			}
			ControlGetText, msg,Static4,Message Properties
			ControlGetText, typeName,Static5,Message Properties
			ControlGet, tt, List ,Col1,ListBox1,Message Properties
			RegExMatch(msg, "O)(\d+).*(Sent|Posted)" , UnquotedOutputVar)
			num:=UnquotedOutputVar.Value(1)
			type:=UnquotedOutputVar.Value(2)
			if(type=="Sent"){
				clipboard .= "`tSendMessage"
			}else{
				clipboard .= "`tPostMessage"
			}
			clipboard .= ", 0x" . num
			RegExMatch(tt, "O)wParam:\s*(\w+)\slParam:\s*(\w+)" , UnquotedOutputVar )
			clipboard .= ",0x" . UnquotedOutputVar.Value(1)
			clipboard .= ",0x" . UnquotedOutputVar.Value(2)
			clipboard .= " ,ToolbarWindow323, A "
			clipboard .= " `;`; " . typeName
			clipboard .= "`n"
		}
		Tooltip copyed to clipboard
		; ControlGet, tt, List , Focused ,ListBox1, A
	return
#IfWinActive

#ifwinactive , ahk_exe Everything.exe
	+enter::
		WinGet, id, id,A
		send {enter}
		winclose, ahk_id %id%
	return
	+^enter::
		WinGet, id, id,A
		send ^{enter}
		winclose, ahk_id %id%
	return
	f4::
		ControlGet, SelectedItems, List, Selected, SysListView321, A
		Loop, Parse, SelectedItems, `n ; Rows are delimited by linefeeds (`n).
		{
			RowNumber := A_Index
			; Loop, Parse, A_LoopField, %A_Tab%  ; Fields (columns) in each row are delimited by tabs (A_Tab).
			; MsgBox Row #%RowNumber% Col #%A_Index% is %A_LoopField%.
			OutputArray:=StrSplit(A_LoopField,A_Tab)
			f:=OutputArray[2] . "\" . OutputArray[1]
			if(FileExist(f)!="D"){
				Run %editor_path% "%f%" 
			}
		}
	return
#ifwinactive

#IfwinActive, ahk_exe Code.exe
	~^+f12::
		send ^j
	return
#ifwinactive

#IfwinActive, BreakAsk
	!tab::
	return
	rctrl::
	return
#IfWinActive

#IfwinActive, ahk_class Shell_TrayWnd
	~*$lbutton::
		preWinId:=
	return
	~*$RButton::
	return
#IfWinActive
;; ynz

#IfWinActive , ahk_exe Mockplus.exe
	+enter::
		MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
		MouseClick, Left, 472, 385
		MouseClick,Left, % OutputVarX, % OutputVarY
	return
#IfwinActive
#IfwinActive ahk_exe msedge.exe
	^tab::
		send !s
	return
#IfWinActive

#IfWinActive, 交易信号 | ahk_exe TdxW.exe
	~*^`::
		t:=400
		ControlGet, code1, List , Selected Col1, SysListView321, A
		ControlGet, name1, List , Selected Col2, SysListView321, A
		ControlGet, time1, List , Selected Col3, SysListView321, A
		code0:=StrSplit(code1,"`n")[1]
		name0:=StrSplit(name1,"`n")[1]
		time0:=StrSplit(time1,"`n")[1]
		; MsgBox %code0% %name0% %time0%
		; return
		WinActivate,%tTDX2%
		WinWaitActive, %tTDX2%
		code:=Trim(code0,"`n")
		Send %code%
		Sleep %t%
		Send {enter}

		Sleep %t%
		Send 49
		Sleep %t%
		Send {enter}
		Sleep %t%

		if(!WinActive("请选择锁定显示的截止日期")){
			Send 49
			Sleep %t%
			Send {enter}
		}

		timeArr:=StrSplit(StrSplit(time0, A_Space)[1],"-")
		dd:=timeArr[3]
		mm:=timeArr[2]
		mmToNum:=mm+0
		debugView(dd)
		ddToNum:=dd+0
		debugView(ddToNum)
		offset:=0
		if(ddToNum>=13){
			offset:=15+(31-ddToNum)
			if(timeArr[2]==12){
				timeArr[2]:="01"
				timeArr[1]:=timeArr[1]+1
			}else{
				timeArr[2]:=timeArr[2]+1
			}
			timeArr[3]:=15
		}else{
			timeArr[3]:=timeArr[3]+15
			offset:=15
		}
		; 30-0 31-1 28-0
		fix:=0
		If [1,3,5,7,8,10,12] contains mmToNum
		{
			fix:=-1
		}
		offset:=offset-(offset//7)*2 + fix
		for i,e in timeArr
		{
			if(i != 1){
				SendInput {right}
				send % Trim(e)
			}else{
				Send % Trim(e)
			}
		}
		debugView(offset)

		Send {enter}{end}{left %offset%}
		Sleep %t%
		WinMinimize, 程序交易评测系统
		; giveTooltip(name0 . ","  . Join(StrSplit(StrSplit(time0, A_Space)[1],"-")),2)
	return
	^!s::
		WinMinimize, 程序交易评测系统
	return

#IfWinActive

#IfWinActive, ahk_class TdxW_MainFrame_Class

	; mark
	\ & BackSpace::
		PostMessage, 0x111, 33781,0,,A
	return
	\ & 3::
		PostMessage, 0x111, 33784,0,,A
	return
	\ & 4::
		PostMessage, 0x111, 33785,0,,A
	return
	\ & 5::
		PostMessage, 0x111, 33786,0,,A
	return
	\ & 6::
		PostMessage, 0x111, 33787,0,,A
	return
	\ & 7::
		PostMessage, 0x111, 33789,0,,A
	return
	\ & 8::
		PostMessage, 0x111, 33790,0,,A
	return
	\ & 9::
		PostMessage, 0x111, 33791,0,,A
	return
	\ & a::
		PostMessage, 0x111, 33792,0,,A
	return

	\ & b::
		PostMessage, 0x111, 33793,0,,A 
	return

	\ & +::
		PostMessage,0x111,33696,0,,A ;;set up price
	return

	\ & -::
		PostMessage,0x111,33697,0,,A ;; set down price
	return 

	\ & Delete::
		PostMessage,0x111,4195,0,,A ;; delete
	return

	; sort
	=::
		PostMessage, 0x111, 31977,0,,A ;; no sort
	return
	-::
		PostMessage, 0x111,31979,0,,A ;今日涨幅排名
	Return

	)::
		PostMessage, 0x111,1929,0,,A ;不显示标识
	return

	!::
		MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
		WinGetPos,X, Y, Width, Height, A
		MouseClick, Left, 360, 71 
		Sleep 100
		MouseMove, % OutputVarX, %OutputVarY%
	Return

	@::
		MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
		WinGetPos,X, Y, Width, Height, A
		MouseClick, Left, 426, 71 
		Sleep 100
		MouseMove, % OutputVarX, %OutputVarY%
	Return

	#::
		MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
		WinGetPos,X, Y, Width, Height, A
		MouseClick, Left, 502, 71 
		Sleep 100
		MouseMove, % OutputVarX, %OutputVarY%
	Return

	%::
		PostMessage, 0x111,31986,0,,A ;最新大笔排名名名
	Return

	^::
		PostMessage, 0x111,32000,0,,A ;笔换手排名
	Return

	![::
		MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
		WinGetPos,X, Y, Width, Height, A
		MouseClick, Left,123, 70 
		Sleep 100
		MouseMove, % OutputVarX, %OutputVarY%
	
	Return

	!]::
		MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
		WinGetPos,X, Y, Width, Height, A
		MouseClick, Left,203, 66
		Sleep 100
		MouseMove, % OutputVarX, %OutputVarY%
	
	Return

	$::
		PostMessage, 0x111,31983,0,,A ;量比排名
	Return


	; pad
	^!h::
		PostMessage, 0x111, 2605,0,,A
	return

	^!b::
		PostMessage, 0x111, 32863,0,,A ;block index quote
	return

	^!z::
		PostMessage, 0x111, 36901,0,,A ;block index quote
	Return
	^!y::
		PostMessage, 0x111,36903,0,,A ;{Empty String}
	Return
	^!x::
		PostMessage, 0x111,36902,0,,A ;{Empty String}
	Return
	^+!m::
		Run, autohotkey %A_ScriptDir%\lib\contextMenuMessage.ahk
	return

	; ext ref info
	\ & g::
		code:=tdxGetCode()
		FormatTime, T, , yyyy-MM-dd
		Run %Browser_path% https://www.xilimao.com/zhangting/%code%/%T%.html	
	return

	\ & f10::
		code:=tdxGetCode()
		Run %Browser_path% https://www.xilimao.com/%code%/
	return

	F9::
		code:=tdxGetCode()
		RunWaitSilent("node " . A_ScriptDir . "\lib\external\browserTabCall.js 11032 巨潮资讯网 http://www.cninfo.com.cn/new/commonUrl?url=disclosure/list/notice bovSearchStock " . code,,true)
		WinActivate, %tBrowser%,,3
	return

	F10::
		PostMessage,0x111,2241,0,,A
	return

	; other
	!+t::
	tdxOpenStock("393008")
	Return
	!+c::
		SwitchIME(00000804) ; Chinese
		Sleep 50
		send !c
	Return
	^+c::
		SwitchIME(00000804) ; Chinese
		Sleep 50
		send !c
		Sleep 50
		Clipboard:=RegExReplace(Clipboard, "(\d+)(.*)" ,"$1 [$2](http://localhost:11031/tdx?code=$1&action=stock)" )
	Return

	^`::
		MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
		WinGetPos,X, Y, Width, Height, A
		MouseClick, Left, 55, % Height - 55
		Sleep 100
		MouseMove, % OutputVarX, %OutputVarY%
	return

	+`::
		MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
		MouseClick, Left, 1879, 489 
		MouseMove, % OutputVarX, %OutputVarY%
	Return

	/* 	
	^f10::
		RunWaitSilent( "set-location D:\xxx\tdx_tradeable\T0002\blocknew\;Get-Content  .\ZXG.blk,.\LSZX.blk   | Sort-Object| Get-Unique | Out-File .\LSZX.blk -Encoding ascii" )
		giveTooltip("自选股已存")
	return 
	*/

	/* 	
	^BackSpace::
		WinGetTitle, OutputVar ,A
		target:="A"
		if(InStr(OutputVar,tTDX)){
			target:=tTDX2
		}else if(Instr(OutputVar,tTDX2)){
			target:=tTDX
		}

		code:=tdxGetCode()
		tdxOpenStock(code,target)
	return 
	*/
	^f10::
		PostMessage, 0x111,34395,0,,A ;个性化数据同步
	return

#IfWinActive

#IfWinActive,通达信金融终端V7.56 

	;   $!Insert::
	;     oldClip:=Clipboard
	;     PostMessage,0x111,33780,0,,A
	; 	code:=SubStr(Clipboard,1,6)
	;     WinActivate, %tTDX2%
	; 	WinWaitActive, %tTDX2%,,5
	; 	if(ErrorLevel!=0){
	; 		Return
	; 	}
	; 	ensureTdx2ControlInit()
	; 	if(WinActive(tTDX2)){
	; 		buy.accDoDefaultAction(0)
	; 		ControlFocus,AfxWnd424,A
	; 		Sleep,500
	; 		; ControlSetText,AfxWnd424,%code%,A
	; 		Send,  %code%
	; 		Sleep,500
	; 		ControlFocus,Edit29,A
	; 	}
	; 	; Clipboard:=oldClip
	;    return
	;   $!Delete::
	;     oldClip:=Clipboard
	;     PostMessage,0x111,33780,0,,A
	; 	code:=SubStr(Clipboard,1,6)
	;     WinActivate, %tTDX2%
	; 	WinWaitActive, %tTDX2%,,5
	; 	if(ErrorLevel!=0){
	; 		Return
	; 	}
	; 	ensureTdx2ControlInit()
	; 	if(WinActive(tTDX2)){
	; 		sell.accDoDefaultAction(0)
	; 		ControlFocus,AfxWnd423,A
	; 		Sleep,500
	;         ; ControlSetText,AfxWnd423,%code%,A
	; 		Send,  %code%
	; 		Sleep,500
	; 		ControlFocus,Edit13,A
	; 	}
	; 	Clipboard:=oldClip
	;    return
	$!Insert::
		code:=tdxGetCode()
		tdxOpenStock(code,tTDX2)
		Sleep 200
		if(WinActive(tTDX2)){
			SendEvent,21{enter}
		}
	return

	$!Delete::
		code:=tdxGetCode()
		tdxOpenStock(code,tTDX2)
		Sleep 300
		if(WinActive(tTDX2)){
			SendEvent,23{enter}
		}
	return

#IfWinActive

#IfwinActive ChiTrader
	;  !BackSpace::
	;     ControlGet, tdxlist, List,  , SysListView321, A
	; 	; MsgBox %tdxlistHwnd%
	; 	; return
	; 	oAcc := Acc_Get("Object", "4", 0, "ahk_id " tdxlistHwnd)
	; 	; MsgBox % oAcc.accChildCount
	; 	Loop, % oAcc.accChildCount{
	; 		role:=Acc_Role(oAcc, A_Index)	
	; 		; MsgBox %role%
	; 		; if ( role= "list item"){
	; 			vText .= oAcc.accName(2) "`r`n"
	; 		; 		}
	; 	}

	;   WinActivate, %tTDX%
	; 	WinWaitActive, %tTDX%,,5
	; 	if(ErrorLevel!=0){
	; 		Return
	; 	}
	; 	 Loop,Parse, tdxlist,`n
	; 	 {
	; 		arr:=StrSplit(A_LoopField,A_Tab)
	; 		code:=arr[9]
	; tdxOpenStock(code)
	; 		Sleep, 50
	; 		PostMessage,0x111,32793,0,,A
	; 		Sleep, 10
	; 	 }
	;  return
	^f11::
	loginMulti:
		ensureTdx2ControlInit()
		multiAcc.accDoDefaultAction(0)
		WinWaitActive,多帐户批量登录,,5
		if(ErrorLevel==1){
			return
		}
		ControlFocus, AfxWnd421, A
		SendRaw 111111
		SendEvent {enter}
		Sleep 200
		SendEvent {enter}
		Sleep 200
		While(True){
			ControlGetFocus, OutputVar , A
			if(OutputVar=="AfxWnd421"){
				break
			}else{
				Sleep, 500
			}
		}
		Sleep, 500
		SendEvent {esc}
	Return 

	^f12::
		send {f12}
		While(True){
			ControlGetPos, X, Y, Width, Height, SafeEdit1,A
			if(X>0){
				break
			}else{
				Sleep, 100
			}
		}
		Sleep 300 
		sendraw % mmm 
		sendevent {enter}
		Sleep 200
		sendraw % 1234 
		; KeyWait, enter,DT5
		; if(ErrorLevel=1){
		; 	return
		; }
		WinWaitActive,消息标题,,6
		if(ErrorLevel){
			return
		}
		sendevent {esc}
		While(True){
			ControlGetPos, X, Y, Width, Height, MHPToolBar1,A
			if(X>0){
				break
			}else{
				Sleep, 500
			}
		}
		WinActivate, % tTaskbar,,3		
		Sleep 500
		WinActivate, % tTDX,,3		
		Sleep 500
		ensureTdx2ControlInit()
		chicang.accDoDefaultAction(0)
/* 
		Sleep 2000
		gosub loginMulti
 */
	return
#IfwinActive

#IfWinActive, ahk_exe 龙头复盘神器.exe
	^c::
		SwitchIME(00000804) ; 
		send ^c
	return
#IfWinActive

#IfWinActive, ToolWindow
	tab::
		WinGet, KDE_id, id, A
		CoordMode,Mouse
		; Get the initial mouse position and window id, and
		; abort if the window is maximized.
		MouseGetPos,KDE_X1,KDE_Y1
		WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
		If KDE_Win
		{
			return
		}
		; Get the initial window position.
		WinGetPos,KDE_WinX1,KDE_WinY1,,,ahk_id %KDE_id%
		Loop
		{
			GetKeyState,KDE_Button,%A_ThisHotkey%,P ; Break if button has been released.
			If KDE_Button = U
			{
				break
			}
			MouseGetPos,KDE_X2,KDE_Y2 ; Get the current mouse position.
			KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
			KDE_Y2 -= KDE_Y1
			KDE_WinX2 := (KDE_WinX1 + KDE_X2) ; Apply this offset to the window position.
			KDE_WinY2 := (KDE_WinY1 + KDE_Y2)
			WinMove,ahk_id %KDE_id%,,%KDE_WinX2%,%KDE_WinY2% ; Move the window to the new position.
		}
	Return
#IfWinActive