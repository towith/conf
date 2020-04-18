global SCOOP
EnvGet, SCOOP, SCOOP
EnvGet userprofile, userprofile
EnvGet username, username

global TMP_PATH:=USERPROFILE . "\AppData\Local\Temp"
global tTC:="ahk_class TTOTAL_CMD"
global COMMANDER_PATH:="D:\Applications\Portable\totalcmd64"
global TC_PATH:=COMMANDER_PATH . "\Totalcmd64.exe"
global tPdfViewer:="ahk_exe SumatraPDF.exe"
global tCode:="ahk_exe Code.exe"
global CODE_PATH:=SCOOP . "\apps\vscode\current\Code.exe"
global tIdea:="ahk_exe idea64.exe"
; global IDEA_PATH:= "D:\Program Files\JetBrains\IntelliJ IDEA 2019.3.2\bin\idea64.exe"
global IDEA_PATH:= "D:\Applications\Scoop\apps\idea-ultimate\current\bin\idea64.exe"
global tChrome:="ahk_exe chrome.exe"
global tVivaldi:="ahk_exe vivaldi.exe"
global VIVALDI_PATH:="D:\Users\" . username . "\AppData\Local\Vivaldi\Application\vivaldi.exe"
global tEdge:="ahk_exe msedge.exe"
global EDGE_PATH:="C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
global tRider:="ahk_exe rider64.exe"
global tVS:="ahk_exe devenv.exe"
global tTDX:="ChiTrader"
global TDX_PATH="D:\xxx\tdx_tradeable\Tdxw.exe"
global tToDo="Microsoft To Do"

; global tTDX2:="通达信专业版V2021.05"
; global TDX2_PATH="D:\xxx\zd_zyb756\Tdxw.exe"
global tTHS:="ahk_exe hexin.exe"
global THS_PATH="D:\同花顺软件\同花顺\hexin.exe"
global tTDXWindow:="ahk_exe TdxW.exe | ahk_class #32770"
global tdx2ControlInited:=false
global tEditor:="ahk_exe gvim.exe"
global EDITOR_PATH:=SCOOP . "\apps\vim-nightly\current\gvim.exe"
global tDFCF:="ahk_exe mainfree.exe"
global DFCF_PATH="D:\eastmoney\swc8\mainfree.exe"
global tOneNote:="OneNote for Windows 10"
global OneNote_Path:="explorer onenote-cmd://"
global tTaskbar:="ahk_class Shell_TrayWnd" 
global tBrowser:=tEdge
global BROWSER_PATH=EDGE_PATH
global tDevBrowser:=tVivaldi
global DEV_BROWSER_PATH=VIVALDI_PATH
global tNotion="ahk_exe Notion Enhanced.exe"
global notionPath="C:\Program Files\Notion Enhanced\Notion Enhanced.exe"
global wtTitle="ahk_exe WindowsTerminal.exe"
global wtPath="wt"
global tHelper="Helper"
global Helper_path="D:\z_wd\bov.stock\helperWin\dist\electron\Packaged\win-unpacked\HelperWin.exe"
global toDoPath="explorer ms-todo://"

global logDir:="D:\bov_logs"
global messageFolder:="N:\messages"
global runtimeFolder:="N:\run"
global scriptFolder:= runtimeFolder . "\scripts"
global myDir:="D:\z_my"
global juncDir:=myDir . "\__juncs"

WinGetPos,,, desk_width, desk_height, Program Manager 
global screenWidth:= desk_width
global screenHeight:= desk_height
global jjx:= screenWidth // 10
global jjy:= screenHeight // 10
global jjxs:=jjx // 5
global jjys:=jjy // 5
global cursorSize:=16
global wheelStep:=1
global mouseDrageMode:=false
; global DBFileName := "D:\bov_logs\data.xx.db"
global DBFileName := A_ScriptDir . "\TEST.DB"

FileCreateDir, %messageFolder%
FileCreateDir, %runtimeFolder%
FileCreateDir, %scriptFolder%
FileCreateDir, %logDir%
if(!FileExist(myDir)){
	FileCreateDir, %myDir%
}
if(!FileExist(juncDir)){
	FileCreateDir, %juncDir%
}

global preWinId:=0
global numLockKeyMode:=false
global mapOpArgs:=Object()

#Include, %A_ScriptDir%\private-var.ahk
#Include, %A_ScriptDir%\lib\json.ahk
#Include, %A_ScriptDir%\lib\array_quicksort.ahk
#Include, %A_ScriptDir%/lib/windows-desktop-switcher/desktop_switcher.ahk
#Include,%A_ScriptDir%\commactlib.ahk
#include %A_ScriptDir%\private.ahk

RegRead, OutputVar, HKEY_CLASSES_ROOT, http\shell\open\command
StringReplace, OutputVar, OutputVar,",,All
SplitPath, OutputVar,,OutDir,,OutNameNoExt, OutDrive
global browser:=OutDir "\" OutNameNoExt ".exe"

SendMode Input
StringCaseSense On
OnError("LogError")
; %cause% := error

;; 
class LMethods{
	__New() {
		this.seconds:=5
	}
	RemoveToolTip(){
		Tooltip
	}
	RemoveSplash(){
		SplashImage,Off
	}

	turnOffMonitor(){
		turnOffMonitor()
	}

	noOp(){
		return
	}
}

global mRemoveTooltip:=ObjBindMethod(new LMethods,"RemoveToolTip")
global mRemoveSplash:=ObjBindMethod(new LMethods,"RemoveSplash")
global mTurnMonitorOff:=ObjBindMethod(new LMethods,"turnOffMonitor")
global mNoOp:=ObjBindMethod(new LMethods,"noOp")

LogError(exception) {
	; FileAppend % "Error on line " exception.Line ": " exception.Message "`n"  , errorlog.txt
	if(exception.shower="tooltip")
	{
		giveTooltip(exception.error,5)
	}else{
		if(exception.Message){
			MsgBox, % "Error Handler Msg: Error on line " exception.Line ": " exception.Message "`n"
		}else{
			MsgBox % "Error: " . exception
		}
	}
	return true
}

isDoublePress(ms = 300) {
	Return (A_ThisHotKey = A_PriorHotKey) && (A_TimeSincePriorHotkey <= ms)
}

TrimBlank(txt){
	StringReplace, txt, txt, `n , , All
	StringReplace, txt, txt, `r , , All
	txt := Trim(txt)
	return txt
}

RunWaitSilent(command,wd:="",useAs:=false,dbg:=false){
	agent:=SCOOP . "\apps\nircmd\current\nircmd.exe exec hide "
	f:= scriptFolder . "\" . A_Now . ".ps1"
	outoff:= f . ".out"
	sigDone:=f . ".done"
	cdCommand:=wd?("cd " . wd . "`n"):""
	if(useAs){
		RunWait %agent% %command%
		return
	}else{
		FileAppend,
		(
			%cdCommand%
			%command% 2>&1 > %outoff%
			New-Item -Type File -Path %sigDone%
		), %f%
		c:=agent " powershell.exe -File " f
		RunWait %c%
		maxTry:=1000
		i:=0
		while(!FileExist(sigDone)){
			Sleep, 100
			i:=i+1
			if(i>maxTry){
				throw "exec time out:" . c
			}
		}
		FileRead, output, % outoff
		; FileRead, t,  N:\run\scripts\20200417203855.ps1.out
		; debug(c "`t" outoff "`t" output)
		if(!dbg){
			FileDelete, %f%
			FileDelete, %outoff%
		}else{
			Run notepad %f%
		}
		FileDelete, %sigDone%
		return %output%
	}
}

RunWaitSilent_x(command,echo:=false,wd:="",useAs:=false,returnType:=1){
	dhw := A_DetectHiddenWindows
	DetectHiddenWindows On
	Run "powershell.exe" ,, Hide, pid
	while !(hConsole := WinExist("ahk_pid" pid))
		Sleep 10
	DllCall("AttachConsole", "UInt", pid)
	DetectHiddenWindows %dhw%
	objShell := ComObjCreate("WScript.Shell")
	if(wd){
		objShell.CurrentDirectory:=wd
	}
	if(useAs){
		objExec := objShell.Exec(command)
	}else{
		objExec := objShell.Exec("powershell.exe -Command " . command . " 2>&1 ")
	}
	While !objExec.Status
		Sleep 100
	strLine := objExec.StdOut.ReadAll() ;read the output at once
	strLineErr := objExec.StdErr.ReadAll() ;read the output at once
	DllCall("FreeConsole")
	Process Exist, %pid%
	if (ErrorLevel == pid)
		Process Close, %pid%
	output:=(strLine?"Msg:":"") strLine (strLineErr?"Err:":"") strLineErr "Cmd:" command

	; if(strLineErr){
	;    Throw, % output
	; }

	if(echo){
		giveTooltip(output,3)
	}
	log(output)
	if(returnType==1){
		return strLine
	}else if(returnType==2){
		return objExec.ExitCode
	}
}

RunWaitSilent2(command,wd:="") {
	; WshShell object: http://msdn.microsoft.com/en-us/library/aew9yb99?
	DllCall("AllocConsole")
	hConsole := DllCall("GetConsoleWindow")
	WinWait % "ahk_id " hConsole
	WinHide
	shell := ComObjCreate("WScript.Shell")
	; Execute a single command via 
	; cString:= command
	; cString:="cmd /c " . command
	; cString := ComSpec " /C   " command " 2>&1 "
	cString:="powershell.exe -Command " command " 2>&1 "
	if(wd){
		if(SubStr(wd,StrLen(wd))=="/" || SubStr(wd,StrLen(wd))=="\"){
			wd:= SubStr(wd, 1 , StrLen(wd)-1)
		}
		shell.CurrentDirectory:=wd
	}
	; outputdebug cmd: %cString% wd: %wd%
	exec := shell.Exec(cString)
	While !exec.Status
		Sleep 100
	DllCall("FreeConsole")
	; Read and return the command's output
	ret:=exec.StdOut.ReadAll()
	return ret 
	; return exec.StdErr.ReadAll()
}

prepareVsCode(){
	#WinActivateForce
	IfWinNotExist, %tCode% 
	{

		RunWithStyle(code_path)
		WinActivate %tCode%
		WinWaitActive %tCode%,,8
		Sleep 3000
	} else{
		giveTooltip("try active " tCode)
		d:=A_DetectHiddenWindows
		DetectHiddenWindows, On
		; WinActivate %tCode%
		IfWinExist, %tCode%
		{
			WinRestore
			WinActivate 
		}
		WinWaitActive %tCode%,,2
		DetectHiddenWindows, %d%

	}
	if(ErrorLevel){
		; retry
		WinActivate %tCode%
		WinWaitActive %tCode%,,2
		;    throw "Can not prepare vscode" . %ErrorLevel% . "."
	}
}

hOpenVsCodeTerm(pp:="d:\"){
	prepareVsCode()
	WinGet, pn,ProcessName,A
	if(pn=="Code.exe"){
		SendEvent, ^~
		Sleep 200
		sendinput cd "%pp%"
		send {enter}
	}
	return
}

AllWinMinimize(title:="A"){
	maxTry:=0
	while(True){
		WinGet MMX, MinMax, %title%
		if(MMX=-1){
			Break
		}else{
			WinMinimize, %title%
		}
		maxTry++
		if(maxTry>100){
			break
		}
	}
	return
}

Explorer_GetWindow(hwnd="")
{
	OutputDebug hwnd %hwnd%
	hwnd := hwnd ? hwnd : WinExist("A")
	WinGetClass class, ahk_id %hwnd%

	if (class="CabinetWClass" or class="ExploreWClass" or class="Progman")
		for window in ComObjCreate("Shell.Application").Windows
	if (window.hwnd==hwnd){
		; a:=window.hwnd 
		; b:=window.LocationURL
		; c:=window.Document
		; d:=window.Document.Folder.Items
		; e:=window.Document.SelectedItems
		;  t:=JSON.Dump(window)
		; OutputDebug window %t% : %a% :%b%:%c%:%d%:%e%
		; for item in e{
		; 	f:=item.path
		; 	MsgBox, item %f%
		; }
		return window
	}
}
Explorer_GetShellFolderView(hwnd="")
{
	return Explorer_GetWindow(hwnd).Document
}

Explorer_GetPath(hwnd="")
{
	return Explorer_GetWindow(hwnd).LocationURL
}
Explorer_GetItems(hwnd="")
{
	return Explorer_GetShellFolderView(hwnd).Folder.Items
}

Explorer_GetSelection(hwnd="")
{
	return Explorer_GetShellFolderView(hwnd).SelectedItems
}

cleanMenu(menuName){
	Menu, %menuName%, UseErrorLevel ; This affects all menus, not just the tray.
	Menu, %menuName%, NoDefault
	if (ErrorLevel = 0)
	{
		menu %menuName%,deleteAll
	}
}

join( strArray )
{
	s := ""
	for i,v in strArray
		s .= " " . v
	return substr(s, 1)
}

startAction(type:=""){
	canRun:=false
	if("autostart"==type){
		if(FileExist(logDir . "\__prevent_start__")){
			canRun:=false
			FileDelete %logDir%\__prevent_start__
		}else{
			canRun:=true
		}
	}else if("run"==type){
		canRun:=true
	}

	if(!canRun){
		return
	}
	Run %A_AhkPath% %A_ScriptDir%\startAction.ahk %type%
	return 
}

openFileIfExist(dir,filename){
	winget, aid,id, %filename%
	if %aid%
	{
		WinActivate, ahk_id %aid%
		return
	}

	file:= dir . "\" . filename
	ifexist %file%
	{
	}
	else
	{
		fileappend,, %file%
	}
	run %file%
}

; SendTCUserCommand(Command) ; string
;   {
;     If  Command <>
;       {
;         VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)  ; Set up the structure's memory area.
;         dwData := Asc("E") + 256 * Asc("M")
;         NumPut(dwData,  CopyDataStruct, 0)
;         cbData := (StrLen(Command) + 1) * (A_IsUnicode ? 2 : 1)  ;SizeInBytes
;         NumPut(cbData, CopyDataStruct, A_PtrSize)  ; OS requires that this be done.
;         NumPut(&Command, CopyDataStruct, 2*A_PtrSize)  ; Set lpData to point to the string itself.
;         SendMessage, 0x4a, 0, &CopyDataStruct,, %tTC% ; 0x4a is WM_COPYDATA. Must use Send not Post.
;       }
;   }

SendTCUserCommand(Command) ; string 
{ 
	If Command <> 
	{ 
		VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0) ; Set up the structure's memory area. 
		dwData := Asc("E") + 256 * Asc("M") 
		NumPut(dwData, CopyDataStruct, 0) 
		cbData := StrPutVar(Command, Command, "cp0") 
		NumPut(cbData, CopyDataStruct, A_PtrSize) ; OS requires that this be done. 
		NumPut(&Command, CopyDataStruct, 2*A_PtrSize) ; Set lpData to point to the string itself. 
		SendMessage, 0x4a, 0, &CopyDataStruct,, %tTC% ; 0x4a is WM_COPYDATA. Must use Send not Post. 
	} 
} 

StrPutVar(string, ByRef var, encoding) 
{ 
	; Ensure capacity. 
	VarSetCapacity( var, StrPut(string, encoding) * ((encoding="utf-16"||encoding="cp1200") ? 2 : 1) ) 
	; Copy or convert the string. 
	return StrPut(string, &var, encoding) 
}

SendTCCommand( xsTCCommand, xbWait=1 )
{
	loop Read, %COMMANDER_PATH%\usercmd.ini
	{
		StringSplit asCommands, A_LoopReadLine, =
		outputdebug A_LoopReadLine %A_LoopReadLine%
		if (asCommands1 = xsTCCommand)
		{
			StringSplit asCommandsValues, asCommands2, `;
			Break
		}
	}

	if !(asCommandsValues1 > 0)
		return

	if (xbWait)
		SendMessage 1075, %asCommandsValues1%, 0, , %tTC%
	else
		PostMessage 1075, %asCommandsValues1%, 0, , %tTC%
}

SwitchIME(dwLayout){
	HKL:=DllCall("LoadKeyboardLayout", Str, dwLayout, UInt, 1)
	ControlGetFocus,ctl,A
	SendMessage,0x50,0,HKL,%ctl%,A
}

sendLoopInput()
{
	xxx:=clipboard

	Loop, Parse, xxx
	{
		;  %A_Index% is %A_LoopField%.
		sendInput %A_LoopField%
	}
	return 
}

GetChildHWND(ParentHWND, ChildClassNN) 
{ 
	WinGetPos, ParentX, ParentY,,, ahk_id %ParentHWND% 
	if ParentX = 
		return ; Parent window not found (possibly due to DetectHiddenWindows). 
	ControlGetPos, ChildX, ChildY,,, %ChildClassNN%, ahk_id %ParentHWND% 
	if ChildX = 
		return ; Child window not found, so return a blank value. 
	return DllCall("WindowFromPoint", "int", ChildX + ParentX, "int", ChildY + ParentY) 
}

showGitLink(path:=""){
	if(!path){
		return
	}
	SplitPath, path, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
	;    rootPath:=RunWaitSilent("git rev-parse --show-toplevel",true,OutDir)
	relativeDir:=RunWaitSilent("git rev-parse --show-prefix",OutDir,,false)
	relativePath:=relativeDir . OutFileName
	relativePath:=TrimBlank(relativePath)
	remote:=RunWaitSilent("git config --get remote.origin.url",true,OutDir) ;; or git ls-remote --get-url origin 
	remote:=TrimBlank(remote)
	remoteUrl:=StrReplace(remote, ".git" , , , 1) . "/blob/master/" . relativePath
	;    clipboard:= % remoteUrl
	Run ,%BROWSER_PATH% "%remoteUrl%"
}

turnOffMonitor(){
	; BlockInput, On
	Sleep 200 ; if you use this with a hotkey, not sleeping will make it so your keyboard input wakes up the monitor immediately
	; SendMessage 0x112, 0xF170, 1,,Program Manager ; send the monitor into standby (off) mode
	SendMessage 0x112, 0xF170, 2,,Program Manager ; send the monitor into off mode
	; BlockInput, Off
}

turnOffMonitor_(){
	Sleep 200 ; if you use this with a hotkey, not sleeping will make it so your keyboard input wakes up the monitor immediately
	RunWaitSilent("nircmdc monitor off")
}

turnOnMonitor(){
	BlockInput ,On
	Send,{Shift}
	BlockInput, Off
}

turnOnMonitor_(){
	; BlockInput, On
	SendMessage 0x112, 0xF170, -1,,Program Manager ; send the monitor into off mode
	; BlockInput, Off
}

toggleStickKey(){
	SPI_GETSTICKYKEYS:=0x003A
	SPI_SETSTICKYKEYS:=0x003B
	SKF_STICKYKEYSON:=0x1
	VarSetCapacity(STICKYKEYS,8) ; DWORD cbSize;DWORD dwFlags;
	NumPut(8,&STICKYKEYS,"UInt")
	DllCall("SystemParametersInfo","UInt",SPI_GETSTICKYKEYS,"UInt",8,"PTR",&STICKYKEYS,"UInt",0)
	dwFlags:=NumGet(&STICKYKEYS,4,"Uint")
	If (dwFlags & SKF_STICKYKEYSON)
		dwFlags-=SKF_STICKYKEYSON
	else dwFlags|=SKF_STICKYKEYSON
		giveTooltip("STICKYKEYS are " (dwFlags & SKF_STICKYKEYSON ? "ON" : "OFF"),1)
	NumPut(dwFlags,&STICKYKEYS,4,"UInt")
	DllCall("SystemParametersInfo","UInt",SPI_SETSTICKYKEYS,"UInt",8,"PTR",&STICKYKEYS,"UInt",0)
}

winMoveCenter(hnd){
	WinGetPos,,, desk_width, desk_height, Program Manager
	WinGetPos, X, Y, Width, Height, %hnd%
	WinMove, %hnd%, , (desk_width-Width)/2, (desk_height-Height)/2, Width, Height
	return
}

isStrInLlist(s,list){
	StringCaseSense, Off
	for i,e in list{
		if(s=e){
			return true
		}
	}
	return false
}

log(msg:=""){
	FormatTime, TimeString,,yyyy/MM/dd HH:mm:ss
	FileAppend,[I] %TimeString% %msg%`n, % logDir . "\__ahk.log"
	return
}

debug(msg){
	FormatTime, TimeString,,yyyy/MM/dd HH:mm:ss
	FileAppend,[D] %TimeString% %msg%`n, % logDir . "\__ahk.dbg"
	return
}

logToFile(msg:="",file:="D:\__ahk_timer.log"){
	FormatTime, TimeString,,yy/MM/dd HH:mm:ss
	FileAppend,%msg% %TimeString%`n,%file%
	return
}

getWindowText(title:="A"){
	WinGetPos, X, Y, Width, Height,% title
	c:= "nircmdc.exe savescreenshot shot.png " X " " Y " " Width " " Height
	RunWaitSilent(c,false,TMP_PATH)
	curTime:=getCurrentTime()
	RunWaitSilent("tesseract.exe .\shot.png shot." . curTime,false,TMP_PATH)
	text:=[]
	Loop
	{
		FileReadLine, line, % TMP_PATH . "\shot." . curTime . ".txt", %A_Index%
		if ErrorLevel
			break

		text.Push(line)
	}
	return text
}

getCurrentTime(){
	FormatTime, Time,,yyyyMMddHHmmss
	return Time
}

execString(text:="",keep:=false){
	f:= runtimeFolder . "\" . A_Now . ".ahk"
	FileAppend,
	(
		Menu, Tray, Icon,%A_AhkPath%,4
		%text%
	), %f%
	RunWait %A_AhkPath% %f%
	if(!keep){
		FileDelete, %f%
	}
}

containsInArr(str:="",arr:=""){
	for k,line in arr
	{
		if(InStr(line, str , true)>0){
			return true
		}
	}
	return false
}

NoOp(){
	return	
}

getParentId(currentId){
	;   outputdebug currentId:%currentId%
	ID := DllCall("GetParent", UInt,currentId)
	;   ID := DllCall("GetParent", UInt,WinExist("ahk_id" currentId))
	;   outputdebug pid:%ID%
	ID := !ID ? WinExist("ahk_id" currentId) : ID
	return ID
}

Set_Parent_by_class(Window_Class, Gui_Number) ; class e.g. Shell_TrayWnd, gui number is e.g. 99 
{ 
	Parent_Handle := DllCall( "FindWindowEx", "uint",0, "uint",0, "str", Window_Class, "uint",0) 
	Gui, %Gui_Number%: +LastFound 
	Return DllCall( "SetParent", "uint", WinExist(), "uint", Parent_Handle ) 
} 

Set_Parent_by_id(Window_id, Gui_Number) ; class e.g. Shell_TrayWnd, gui number is e.g. 99 
{ 
	Gui, %Gui_Number%: +LastFound 
	Return DllCall( "SetParent", "uint", WinExist(), "uint", Window_id ) 
} 

isWindowFullScreen( winTitle )
{ 
	winID := WinExist( winTitle )
	If ( !winID )
		Return false

	WinGet style, Style, ahk_id %WinID%
	WinGetPos ,,,winW,winH, %winTitle%
	Return ((style & 0x20800000) or winH < A_ScreenHeight or winW < A_ScreenWidth) ? false : true
}

restart(){
	RunWait schtasks /run /tn my\autohotkey
}

giveSplash(subTxt:="",mainTxt:="",title:="",time:=2,x:=0,y:=0,w:=0,h:=0){

	if(!w)
		w:=450
	if(!h)
		h:=150
	if(!x)
		x:=A_ScreenWidth*.5-w/2
	if(!y)
		; y:=A_ScreenHeight*.5-h/2
	y:=A_ScreenHeight*.1
	SplashImage, ,X%x% Y%y% W%w% H%h% FM12 CBFFFFFF CWFFFFDD CT808000 ZW-1, % subTxt, % mainTxt, % title, FontName
	if(time=0){
		KeyWait, q, DT10
		SplashImage,Off
		return
	}
	t:=-time*1000
	mObj:=ObjBindMethod(new LMethods,"RemoveSplash")
	SetTimer , % mObj , %t%
}

giveTooltip(text:="",time:=2,x:=0,y:=0){
	if(!x || !y)
		MouseGetPos, x, y
	ToolTip, %text%,%x%,%y%
	t:=-time*1000
	mObj:= ObjBindMethod(new LMethods,"RemoveToolTip")
	SetTimer ,% mObj, %t%
}

preventNextLock(){
	FileAppend, , %logDir%\__prevent_lock__
	giveSplash("","Prevent next auto lock",,5)
}

preventNextStart(){
	FileAppend, , %logDir%\__prevent_start__
	giveSplash("","Prevent next auto start",,5)
}

error(msg:=""){
	FormatTime, TimeString,,yyyy/MM/dd HH:mm:ss
	FileAppend, % "[Err] " . TimeString . " " msg . "`n", % logDir . "\_error.log"
}
; 

WinActivateWithHidden(t:="A"){
	d:=A_DetectHiddenWindows
	DetectHiddenWindows, Off
	WinActivate,t 
	DetectHiddenWindows, %d%
}

openTrash(){
	run "::{645ff040-5081-101b-9f08-00aa002f954e}"
}

AhkAddMessage(kind,msg){
	if(!msg){
		return
	}
	t:=getCurrentTime()
	subFolder:=messageFolder . "\" . kind
	if(!FileExist(subFolde)){
		FileCreateDir, %subFolde%
	}
	mName:=msg . t
	f:= subFolder . "\" mName 
	FileAppend, ,%f% 
	return kind . "\" . mName
}

GetMessage(kind){
	f:=messageFolder . "\" . kind
	Loop, Files, % f . "\*", FD
	{
		fname:=A_LoopFileName
		if(fname){
			FileDelete ,% f . "\" fname
			break
		}
	}
	return fname
}

cleanMessage(kind){
	f:=messageFolder . "\" . kind
	Loop, Files, % f . "\*", FD
	{
		fname:=A_LoopFileName
		FileDelete ,% f . "\" fname
	}
}

deleteMessage(mPath){
	FileDelete , % messageFolder . "\" . mPath
}

giveTrayTip(title:="",text:="",seconds:=1,options:=0){
	TrayTip, % title, %text% , , options
	Sleep % seconds * 1000
	TrayTip
}

wait(t:=1){
	Sleep, % t * 1000 
}

TryScrCpyUnlock(){
	CoordMode, Mouse, Window 
	WinGetPos, X, Y, W, H, A
	PixelGetColor, color, W/2, H/2, RGB
	; ; 调用 PixelGetColor 函数，获得鼠标所在坐标的 RGB 值，并赋值给 color
	StringRight color,color,6
	; outputdebug color 1:%color%
	unlock:=true
	if(color="000000"||color="000100"){
	}else{
		unlock:=false
	}
	PixelGetColor, color, W/3, H/3, RGB
	StringRight color,color,6
	; outputdebug color 2:%color% 
	if(color="000000"||color="000100"){
	}else{
		unlock:=false
	}
	PixelGetColor, color, W/4, H/4, RGB
	StringRight color,color,6
	; outputdebug color 3:%color%
	if(color="000000"||color="000100"){
	}else{
		unlock:=false
	}
	if(unlock){
		Func("input001").call()
	}	
}

desktopIcon(d:=1){
	c:=A_AhkPath . " " A_ScriptDir . "\desktopIcon.ahk" . " " . d
}

getDesktopNum(aId,sessionId){
	if (aId) {
		a:=RegExReplace(aId,"^0x")
		n0:= 16 - StrLen(a)
		s0:=""
		loop %n0%{
			s0:=s0 . "0"
		}
		r:="HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\" . sessionId "\ApplicationViewManagement\W32:" . s0 . a
		RegRead, cdId,%r% , VirtualDesktop
		cdId:=SubStr(cdId, 17)

		if (cdId) {
			IdLength := StrLen(cdId)
		}
	}

	; Get a list of the UUIDs for all virtual desktops on the system
	RegRead, dList, HKEY_CURRENT_USER, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, VirtualDesktopIDs
	if (dList) {
		dListLength := StrLen(dList)
		; Figure out how many virtual desktops there are
		dCount := floor(dListLength / IdLength)
	}
	else {
		dCount := 1
	}

	; Parse the REG_DATA string that stores the array of UUID's for virtual desktops in the registry.
	i := 0
	while (cdId and i < dCount) {
		StartPos := (i * IdLength) + 1
		DesktopIter := SubStr(dList, StartPos, IdLength)
		; OutputDebug, The iterator is pointing at %DesktopIter% and count is %i%.

		; Break out if we find a match in the list. If we didn't find anything, keep the
		; old guess and pray we're still correct :-D.
		if (DesktopIter = cdId) {
			dNum := i + 1
			; OutputDebug, Current desktop number is %dNum% with an ID of %DesktopIter%.
			break
		}
		i++
	}
	return dNum?dNum:1
}

LastActiveId()
{
	WinGet, idlist, list,,, Program Manager
	Loop, %idlist%
	{
		this_id := idlist%A_Index%
		WinGetClass, this_class, ahk_id %this_id%
		if this_class != Shell_TrayWnd
			return %this_id%
	}
	return 0
}

HideShowTaskbar(action) {
	static ABM_SETSTATE := 0xA, ABS_AUTOHIDE := 0x1, ABS_ALWAYSONTOP := 0x2
	VarSetCapacity(APPBARDATA, size := 2*A_PtrSize + 2*4 + 16 + A_PtrSize, 0)
	NumPut(size, APPBARDATA), NumPut(WinExist("ahk_class Shell_TrayWnd"), APPBARDATA, A_PtrSize)
	NumPut(action ? ABS_AUTOHIDE : ABS_ALWAYSONTOP, APPBARDATA, size - A_PtrSize)
	DllCall("Shell32\SHAppBarMessage", UInt, ABM_SETSTATE, Ptr, &APPBARDATA)
}

runAndStoreId(cmd,wT,keys) {
	WinGet, cur, id,A 
	Run , %cmd%,,,pid
	WinWaitNotActive, ahk_id %cur%,,5
	WinWaitActive, %wT%,,5
	WinGet,i,id,A
	if(i){
		pf:=runtimeFolder . "\winIdInfo\OpenWin" . keys 
		FileDelete, %pf%
		FileAppend, % (i+0),% pf
		giveTooltip("openwin " . keys . " stored")
	}
}

tryRestoreWinById(keys){
	pf:=runtimeFolder . "\winIdInfo\OpenWin" . keys
	FileReadLine, pp, % pf, 1
	tQ:="ahk_id " . pp
	if(pp){
		if(WinExist(tQ)){
			WinActivate, %tQ%
			pp:=""
			return true
		}
	}
	return false
}

mapDefinedKeys(){
	f:=logDir . "\keymaps.map"
	loop {
		FileReadLine, line, % f, %A_Index%
		if ErrorLevel
			break
		if(line){
			lineArr:=StrSplit(line,"|")
			clazz:=lineArr[1]
			key:=lineArr[2]
			type:=lineArr[3]
			arg1:=lineArr[4]
			arg2:=lineArr[5]
			mapOpArgs[clazz . "_" . key]:=[arg1,arg2]
			if(type=="click"){
				Hotkey, IfWinActive, ahk_class %clazz%
					k:="$" . key . " up"
				Hotkey, % k, mapOpClick, On
				Hotkey, IfWinActive
				}
		}
	}
}

/* ;
*****************************
***** UTILITY FUNCTIONS *****
*****************************
*/

ExtractAppTitle(FullTitle)
{	
	AppTitle := SubStr(FullTitle, InStr(FullTitle, " ", false, -1) + 1)
	Return AppTitle
}

/* ;
***********************************
***** SHORTCUTS CONFIGURATION *****
***********************************
*/

switchBetweenSameType(t){
	WinGet, currentId,Id,A
	WinGet, targetId, id, %t%
	if(currentId!=targetId)
	{
		WinActivate, ahk_id %targetId%
		return
	}
	WinGet, OpenWindowsAmount, Count, %t%
	; WinGet, ProcessName, ProcessName,A
	; if(!InStr(t,ProcessName) > 0){
	;     WinActivate,%t%
	;     Return
	; }
	If OpenWindowsAmount = 1 
	{
		WinActivate,%t%
		Return
	}
	Else
	{
		DetectHiddenWindows, Off
		WinGet, WindowsWithSameTitleList, List, %t%
		If WindowsWithSameTitleList > 1 
		{
			WinActivate, % "ahk_id " WindowsWithSameTitleList%WindowsWithSameTitleList%	; Activate next Window	
		}
	}
	Return
}

RunWithStyle(path){
	Run, % path, ,Max , OutputVarPID
	WinWait, ahk_pid %OutputVarPID%, , 5
	WinGet, style, Style,ahk_pid %OutputVarPID%
	style-=0xC00000
	; style-=0x800000
	; style+=0x1000000
	WinSet, Style, % style , ahk_pid %OutputVarPID% 

	; WinWaitActive
	; WinGet, ActiveWindowID, ID
	; WinGet, style, Style,ahk_id %ActiveWindowID%
	; WinSet, Style,  (-0xC00000 | style ), ahk_id %ActiveWindowID% 
	return OutputVarPID
}

performT1(scriptPath){
	DOTASK:
		tooltip % "Perform task: " . scriptPath
		RunWait,%scriptPath%,, UseErrorLevel, OutputVarPID
		if(ErrorLevel!=0){
			MsgBox, % 0x2 | 0x40000 | 0x10, , Retry task %scriptPath%? 
			IfMsgBox Retry
			Goto, DOTASK
			IfMsgBox Abort
			Clipboard:=scriptPath
			SplitPath, %scriptPath%, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
			hOpenVsCodeTerm(OutDir)
			throw {shower:"tooltip",error:"Task " . scriptPath . " Aborted(Path has copied to clipboard)"}
		}
		ToolTip
		; return
	}

	performTN(needConfirm:=true){
		for i, e in performTasks{
			if(needConfirm){
				MsgBox, % 0x4 | 0x40000 | 0x10, , do task %e% ? 
				IfMsgBox No
				Continue
			}else{
				giveTooltip("perform " . e)
			}
			performT1(e)
		}

		for i,e in performTasksNoAsk{
			performT1(e)
		}
	}

	performTN_x(l:="TNStart",type:=0){
		goto %l%
	TNStart:

	TWords:
		MsgBox, % 0x4 | 0x40000 | 0x10, , do task words? (Press YES or NO)
		IfMsgBox No
		Goto, TWordsEnd
		Tooltip Start TWords
		RunWait,x:\xxx\xxx.bat,, UseErrorLevel, OutputVarPID
		if(ErrorLevel!=0){
			MsgBox, % 0x2 | 0x40000 | 0x10, , Retry commit words? 
			IfMsgBox Retry
			Goto, TWords
			IfMsgBox Abort
			throw {shower:"tooltip",error:"Aborted"}
		}
	TWordsEnd:
		if(type==1){
			return
		}

	TNEnd:
	}

	RunAsFunc(command){
		Run, % command, , , OutputVarPID
	return OutputVarPID
}

sendMsgToPhone(title,content:=""){
	; sendCommand:="curl.exe -s   --form-string 'source=" . altov_s . "'   --form-string 'receiver=" .  altov_r .  "'   --form-string 'content=" . content . "'   --form-string 'title=" .  title .  "'   --form-string 'priority=1'   https://api.alertover.com/v1/alert"
	; RunWaitSilent(sendCommand,true)
}

doTDX(){
	if(!WinExist(tTDX)){
		FileCopy, D:\xxx\Tdx-YJBRCGB-7.56\TDX-YJBRCGB\T0002\tmp\Cookies, D:\xxx\tdx_tradeable\T0002\tmp\Cookies , 1
		Run , % TDX_PATH
		Winwait,%tTDX%,,15
	}
}

doTDX2(){
	if(!WinExist(tTDX2)){
		SplitPath, TDX2_PATH , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
		Run , % TDX2_PATH,% OutDir
		Winwait,%tTDX2%,,15
	}
}

debugView(msg:=""){
	outputdebug % msg
}

ControlGetHwnd(aCtrl, aWin)
{
	ControlGet, cID,hwnd, , %aCtrl%, %aWin%
	Return cID
}

tdxOpenStock(code:="",title:="A"){
	if(title!="A"){
		WinActivate, %title%
		WinWaitActive, %title%,,1
	}
	if(WinActive(title)){
		if(InStr(code,"6")==1){
			code:="7" . code
		}else if(InStr(code,"0")==1 || InStr(code,"3")==1){
			code:="6" . code
		}
		UWM_STOCK := DllCall("RegisterWindowMessage", Str,"Stock")
		PostMessage,UWM_STOCK,%code%,0,,A
	}
}

tdxGetCode(){
	oldClip:=Clipboard
	SendMessage,0x111,33780,0,,A
	code:=SubStr(Clipboard,1,6)
	Clipboard:=oldClip
	return code
}

initTdxControl(winTitle:="A",reload:=False){
	if(!reload && tdx2ControlInited){
	Return
}
CTRLNAME := "MHPToolBar1"
hwnd:=ControlGetHwnd(CTRLNAME,winTitle )
idObject:=0
;~ window   :=0  SELF
;~ client   :=  -4  
;~ child_1 := 1;
;~ child_2 := 2;
;~ child_3 := 3;
;========MHPToolBar1========
;按钮所在的“小”窗口
window := Acc_ObjectFromWindow(hwnd, idObject) 
;========MainViewBar========
;窗口里面的工具栏
MainViewBar:= Acc_Children(window)[4]

;下面代码是基于中银国际交易软件客户端测试的
;========买入按钮========
global buy:= Acc_Children(MainViewBar)[5]
; MsgBox % Acc_Role(buy)  " :: " buy.accName(0)
;========卖出按钮========
global sell:= Acc_Children(MainViewBar)[6]
;========撤单按钮========
global cancel:= Acc_Children(MainViewBar)[7]
;========成交按钮========
global chengjiao:= Acc_Children(MainViewBar)[8]
;========持仓按钮========
global chicang:= Acc_Children(MainViewBar)[9]
; 多账号
global multiAcc:= Acc_Children(MainViewBar)[10]
global shuaxin:= Acc_Children(MainViewBar)[111]

if(buy && sell){
	tdx2ControlInited:=true
}
Return
}

ensureTdx2ControlInit(){
	if(!tdx2ControlInited){
		initTdxControl()
	}
	if(!tdx2ControlInited){
		giveTooltip("not tdx Control Inited")
	return
}else{
	;  giveTooltip(buy.accName(0))
}
return buy
}

doBrowser(){
	; --start-fullscreen 
	if(GetKeyState("Shift")){
		browser_options:="--remote-debugging-port=11032"
	}else{
		browser_options:="--remote-debugging-port=11032 --kiosk"
	}

	if(!WinExist(tBrowser)){
		Run , %BROWSER_PATH% %browser_options%	
	}
	WinWaitActive %tBrowser%,,5
}

doDevBrowser(){
	; --profile-directory=""Default""  --auto-open-devtools-for-tabs 
	dev_browser_options:=" --args --remote-debugging-port=11033 --disable-web-security --allow-file-access-from-files --allow-file-access --enable-easy-off-store-extension-install" 
	if(!WinExist(tDevBrowser)){
		Run,%DEV_BROWSER_PATH% %dev_browser_options%
	}
	WinWaitActive %tDevBrowser%,,5
}

class DBObj
{
	__New() {
		this.initDb()
	}
	initDb(){
		connected := IsObject(this._DB)
		if(!connected){
			this._DB := DBA.DataBaseFactory.OpenDataBase("SQLite", "D:\bov_logs\data.db")
		}
		OnExit(ObjBindMethod(this, "Exiting"))
	return this._DB
}
getDB(){
	if(IsObject(this._DB)){
	return this._DB
}
else{
	return this.initDb()
}
}	
Exiting()
{
	if(IsObject(this._DB)){
		this._DB.Close()
	}
}
}

doHelper(){
	; . " alsoWZxg"
	cmd:= Helper_path . " openTdx" . " openNews"
	Run, % cmd
}

doMsVscode(){
	if(!WinExist(tCode)){
		RunWithStyle(code_path . " -r")
	}
	WinWait %tCode%,,10
}

editTestCode(origCode:="")
{
	TestCode2:=origCode
	Gui,testCode:+LastFound
	Gui,testCode:New,,editTestCode
	Gui,testCode:Add, Picture,w150 h-1, D:\z_wd\appointment\test.png
	Gui,testCode:Add, Edit, r1 x180 y25 vTestCode2 w135,%TestCode2%
	Gui,testCode:Add, Button, default gTestCodeButtonOk, OK
	Gui,testCode:Show,AutoSize Center
	WinWaitClose, editTestCode
	SplashImage,Off
}

blockInputOn(){
	BlockInput, On
	BlockInput, MouseMove
}
blockInputOff(){
	BlockInput,Off
	BlockInput, MouseMoveOff
}
tdxUpdateHS3Data(){
	WinActivate, %tTDX%,,5
	if(WinActive(tTDX))
	{
		PostMessage, 0x111, 33083,0,,A ;历史行情.指标排序
		Sleep, 2000
		WinWaitClose, 刷新数据,,10*60
		Sleep, 2000
		WinWaitClose, 正在计算`,请稍等,,100*60
		blockInputOn()
		WinActivate, %tTDX%
		PostMessage, 0x111,33233,0,,A ;数据导出
		WinWaitActive, 数据导出,,5
		path:="D:\bov_logs\tdxData\" . A_YYYY . A_MM . A_DD . ".txt"
		ControlSetText, Edit1,%path%,A
		Sleep, 100
		ControlFocus,Button4,A 
		Sleep, 100
		ControlClick, Button4, A 
		Sleep, 100
		Send {Space}
		Sleep, 100
		ControlClick, Button5, A
		WinWaitActive, TdxW,,10
		ControlClick, Button2, A
		Send {Esc}
		blockInputOff()
	}else{
		MsgBox, "Tdx not open"
	}

}

testXX(){
	WinActivate, %tTDX%,,5
	; winget, id, id, ChiTrader
	; 交易信号 | ahk_exe TdxW.exe
	; msgbox %id%

}

testXX2(){
}

