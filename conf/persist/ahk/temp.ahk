/* ;; temp keys eng word
#IfWinActive, ahk_exe SumatraPDF.exe
~left::
~right::
	Gosub, createDocInfo
return
#IfWinActive

#IfWinActive, ahk_exe vivaldi.exe|SumatraPDF.exe

^left::
;; 
	Gosub, TransPop
return

+left::
	Gosub , QueryGoogle
return

^up::
 gosub , PlayWordVoice
return

+up::
  MouseGetPos,  OutputVarX, OutputVarY
  MouseClick, left , 80, 41,2 
  Sleep, 200
  gosub PlayWordVoice
  MouseMove, OutputVarX, OutputVarY
return


^down::
    showWinAfterTrans:=false
	Gosub, AddAndOpen
return

+down::
  MouseClick, left , 80, 41,2 
  Sleep, 200
	Gosub, AddAndOpen
return

!down::
    showWinAfterTrans:=true
	Gosub, AddAndOpen
return

^right::
    Send ^c
	Sleep 100
	fileName := "D:\z_my\envoc\B" . A_MM . A_DD ".md"
	u:="file:///" . fileName . "?&translate#" . Clipboard
	gosub, runBrowser
return

runBrowser:
	Run , %browser_path%  "%u%",,Hide,pid
	mPath:=AhkAddMessage("vivaldi","V_Full")
	SetTimer, deleteMessage, -3000
return

+right::
    MouseClick, left , 80, 41,2 
	Sleep 100
    Send ^c
	Sleep 100
	fileName := "D:\z_my\envoc\B" . A_MM . A_DD ".md"
	u:="file:///" . fileName . "#" . Clipboard
	gosub, runBrowser
return
#IfWinActive

#IfWinActive ahk_exe vivaldi.exe
~rshift up::
	if(isDoublePress()){
		send ^w
	}
return
^/::
	send {esc}
	Sleep 500
	send ^l
	Sleep 200
	send ^a^c
	Sleep 50
	RegExMatch(Clipboard, "O)file:///(.*\.\w{1,4})[\?#]?" , UnquotedOutputVar )
    file:=UnquotedOutputVar.Value(1)
	if(file){
		Run, %editor_path% %file%
		WinWaitActive, %tEditor%,,3
		if(WinActive(tEditor))
		{
			send ^{end}
		}
	}
return
#IfWinActive */

;; temp keys eng word end

/* bindNumKeyMode(){
	Numpad1:="Numpad1"
	Numpad2:="Numpad2"
	Numpad3:="Numpad3"
	Numpad4:="Numpad4"
	Numpad5:="Numpad5"
	Numpad6:="Numpad6"
	Numpad7:="Numpad7"
	Numpad8:="Numpad8"
	Numpad9:="Numpad9"
	if(numLockKeyMode)
	{
		if(IsLabel(Numpad1))
			Hotkey, z,%Numpad1%,On
		; if(IsLabel("^" . Numpad1))
			; Hotkey, ^z,^%Numpad1%,On
		; if(IsLabel("+" . Numpad1))
			; Hotkey, +z,+%Numpad1%,On
		if(IsLabel(Numpad2))
			Hotkey, x,%Numpad2%,On
		if(IsLabel(Numpad3))
			Hotkey, c,%Numpad3%,On 
		if(IsLabel(Numpad4))
			Hotkey, a,%Numpad4%,On
		if(IsLabel(Numpad5))
			Hotkey, s,%Numpad5%,On
		; if(IsLabel("^" . Numpad5))
			; Hotkey, ^s,^%Numpad5%,On
		; if(IsLabel("+" . Numpad5))
			; Hotkey, +s, +%Numpad5%,On
		if(IsLabel(Numpad6))
			Hotkey, d,%Numpad6%,On
		if(IsLabel(Numpad7))
			Hotkey, q,%Numpad7%,On
		if(IsLabel(Numpad8))
			Hotkey, w,%Numpad8%,On
		if(IsLabel(Numpad9))
			Hotkey, e,%Numpad9%,On
	}
	else
	{
		if(IsLabel(Numpad1))
			Hotkey, z,%Numpad1%,Off
		if(IsLabel(Numpad2))
			Hotkey, x,%Numpad2%,Off
		if(IsLabel(Numpad3))
			Hotkey, c,%Numpad3%,Off 
		if(IsLabel(Numpad4))
			Hotkey, a,%Numpad4%,Off
		if(IsLabel(Numpad5))
			Hotkey, s,%Numpad5%,Off
		if(IsLabel(Numpad6))
			Hotkey, d,%Numpad6%,Off
		if(IsLabel(Numpad7))
			Hotkey, q,%Numpad7%,Off
		if(IsLabel(Numpad8))
			Hotkey, w,%Numpad8%,Off
		if(IsLabel(Numpad9))
			Hotkey, e,%Numpad9%,Off
	}
}
 */






;;   Stock
#f1::
    Gui,stock:+LastFound
    Gui,stock:New
    Gui,stock:Add, Text,,Code
    Gui,stock:Add, Edit, r1 vCode w135
    Gui,stock:Add, Text,,Name
    Gui,stock:Add, Edit, r1 vName w135
    Gui,stock:Add, DropDownList, vConcernType Choose1, txt|link|html
    Gui,stock:Add, Checkbox, vC1, 签合同
    Gui,stock:Add, Checkbox, vC2, 业绩预报
    Gui,stock:Add, Checkbox, vC3, 业绩报告
    Gui,stock:Add, Checkbox, vC4, 收购
    Gui,stock:Add, Checkbox, vC5, 转让
    Gui,stock:Add, Checkbox, vC6, 投资
    Gui,stock:Add, Checkbox, vC7, 配股
    Gui,stock:Add, Checkbox, vC8, 新品发布
    Gui,stock:Add, Checkbox, vC9, 政策
    Gui,stock:Add, Checkbox, vC10, 涨价
    Gui,stock:Add, Checkbox, vC11, 上下游
    Gui,stock:Add, Checkbox, vC12, 外围类
    Gui,stock:Add, Text,,Url
    Gui,stock:Add, Edit, r1 vUrl w400
    Gui,stock:Add, Text,,Content
    Gui,stock:Add, Edit, r9 vContent w400
    Gui,stock:Add, Button, default gButtonOk, OK
    Gui,stock:Show, AutoSize Center
return

ButtonOK:
  DB:=DbObj.getDB()
  Gui, stock:Submit  
;   if(!code || !url){
;     giveTooltip("invalid value")
;     return
;   }
  concern := {}
  concern.code:="#" . code
  concern.name:= name
  concern.label:=label

  concernInfo:={}
  concernInfo.type:=concernType
  concernInfo.url:=url
  concernInfo.content:=content

  try {
;       DB.BeginTransaction()
      DB.Insert(concern, "stock_concern") ; insert a single record into table test
      SQLite_LastInsertRowID(-1,concernId)
      concernInfo.stock_id:=concernId
      DB.Insert(concernInfo,"concern_info")
;     DB.EndTransaction()
  }catch e{
    MsgBox,16, Error, % "Test of Recordset Insert failed!`n`nException Detail:`n" e.What "`n"  e.Message
  }
;     Gui,stock:Destroy
return

#f3::
	Gui,stockList:+LastFound
	Gui,stockList:Destroy
	Gui,stockList:New,AlwaysOnTop
	Gui, Add, ActiveX, w700 h400 vWB, Shell.Explorer  
	WB.Navigate("http://localhost:9000")  

	;  +Grid  0 0x4000 0x8 0x2
	Gui,stockList:Add, ListView, r20 w700 AltSubmit ,  , Name|Code
	if(!FileExist("Y:")){
		RunAs
		RunWait *RunAs cmd.exe /c net use Y: https://dav.jianguoyun.com/dav/  /user:yinghao_niu@126.com /persistent:YES aaxys6ckwx4mtbf7
	}
	if(!FileExist("Y:")){
		MsgBox, Error:No path Y:
		Return
	}
	FileRead, concernContent, *P65001 Y:\data.bov\stockConcern\latest.concern.json
	targets:=JSON.Load(concernContent)
	all:=Array()
	for  i,e in targets
	{
		if(e.stocks)
		{
			for j,s in e.stocks
			{
				all.push(s)
			}
		}
	}

	for i,e in all
	{
		name:=e.name
		RegExMatch(e.symbol, "O)(\d{6}).*" , matchObj )
		code:=matchObj.Value(1)
		LV_Add("", name, code,label)
	}
	LV_ModifyCol(1,"AutoHdr")
	LV_ModifyCol(2,"AutoHdr")
	Gui, Show
Return

#f2::
	Gui,stockList:+LastFound
	Gui,stockList:New,AlwaysOnTop
	;  +Grid  0 0x4000 0x8 0x2
	Gui,stockList:Add, ListView, r20 w700 gMyListView AltSubmit ,  , Name|Code|Label|content
	DB:=DbObj.getDB()
	if(!DB){
		MsgBox can not get db
		Return
	}
	sql:="select code,name,label,content from stock_concern s,concern_info i where s.id=i.stock_id"
	resultSet := DB.OpenRecordSet(sql)
	if(!IsObject(resultSet)){
		MsgBox error resultSet is not Object
		Return
	}
	if(!is(resultSet, DBA.RecordSet))
		throw Exception("RecordSet Object expected! resultSet was of type: " typeof(resultSet) ,-1)
	columns := resultSet.getColumnNames()
	columnCount := columns.Count()
	while(!resultSet.EOF){	
		code:=SubStr(resultSet[1], 2) 
		name:=resultSet[2]
		label:=resultSet[3]
		content:=resultSet[4]
		LV_Add("", name, code,label,content)
		resultSet.MoveNext()
	}
	LV_ModifyCol(1,"AutoHdr")
	LV_ModifyCol(2,"AutoHdr")
	LV_ModifyCol(3,"AutoHdr")
	LV_ModifyCol(4,500)
Gui, Show
return

MyListView:
OutputDebug,  %A_GuiEvent%
if (A_GuiEvent = "DoubleClick")
{
}else if(A_GuiEvent="I"){
	LV_GetText(code, A_EventInfo,2) 
	if(code){
		tdxOpenStock(code,tTDX)
		return
	}
	LV_GetText(name, A_EventInfo,1)
	OutputDebug %name%
	code:=getCodeByName(name,DB)
	if(code){
		tdxOpenStock(code,tTDX)	
	}
}

return