;功能：给通达信软件增加类似同花顺的交易功能热键
;2015年10月25日11:39:03
;作者：sunwind
  #SingleInstance,Force
  DetectHiddenWindows,On
  WINNAME := "东方通达信金融终端"
  CTRLNAME := "MHPToolBar1"
  hwnd:=ControlGetHwnd(CTRLNAME, WINNAME)
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
  MainViewBar:= Acc_Children(window)[3]
    

;下面代码是基于中银国际交易软件客户端测试的
  ;========买入按钮========
  buy:= Acc_Children(MainViewBar)[2]
  MsgBox % Acc_Role(buy)  " :: " buy.accName(0)
  ;========卖出按钮========
  sell:= Acc_Children(MainViewBar)[3]
  ;========撤单按钮========
  cancel:= Acc_Children(MainViewBar)[4]
  ;========成交按钮========
  chengjiao:= Acc_Children(MainViewBar)[5]
  ;========持仓按钮========
  chicang:= Acc_Children(MainViewBar)[6]
  
  shuaxin:= Acc_Children(MainViewBar)[7]
  



;招商证券的

;========买入按钮========
;buy:= Acc_Children(MainViewBar)[12]
;========卖出按钮========
;sell:= Acc_Children(MainViewBar)[13]

;这些信息查询，需要用到AccViewer工具。


;========热键定义========

;F1买入，F2卖出，F3撤单，F4持仓查询
  f1:: 
  buy.accDoDefaultAction(0)
  return
 
  f2::
  sell.accDoDefaultAction(0)
  return
 
  f3::
  cancel.accDoDefaultAction(0)
  return
 
  f4::
  chicang.accDoDefaultAction(0)
  return
  ;========辅助函数========
  ControlGetHwnd(aCtrl, aWin)
{
      ControlGet, cID,hwnd, , %aCtrl%, %aWin%
      Return cID
  }
 
 
  ;========acc库函数========
  ; Written by jethrow
Acc_Init()
{
	Static	h
	If Not	h
		h:=DllCall("LoadLibrary","Str","oleacc","Ptr")
}
Acc_Query(Acc) { ; thanks Lexikos - www.autohotkey.com/forum/viewtopic.php?t=81731&p=509530#509530
	try return ComObj(9, ComObjQuery(Acc,"{618736e0-3c3d-11cf-810c-00aa00389b71}"), 1)
}
Acc_Error(p="") {
	static setting:=0
	return p=""?setting:setting:=p
}
Acc_ObjectFromWindow(hWnd, idObject = 0)
{
	Acc_Init()
	If	DllCall("oleacc\AccessibleObjectFromWindow", "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)=0
	Return	ComObjEnwrap(9,pacc,1)
}
 
Acc_Children(Acc) {
	if ComObjType(Acc,"Name") != "IAccessible"
		ErrorLevel := "Invalid IAccessible Object"
	else {
		Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]
		if DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {
			Loop %cChildren%
				i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i), Children.Insert(NumGet(varChildren,i-8)=9?Acc_Query(child):child), NumGet(varChildren,i-8)=9?ObjRelease(child):
			return Children.MaxIndex()?Children:
		} else
			ErrorLevel := "AccessibleChildren DllCall Failed"
	}
	if Acc_Error()
		throw Exception(ErrorLevel,-1)
}
 
Acc_Role(Acc, ChildId=0) {
	try return ComObjType(Acc,"Name")="IAccessible"?Acc_GetRoleText(Acc.accRole(ChildId)):"invalid object"
}
Acc_GetRoleText(nRole)
{
	nSize := DllCall("oleacc\GetRoleText", "Uint", nRole, "Ptr", 0, "Uint", 0)
	VarSetCapacity(sRole, (A_IsUnicode?2:1)*nSize)
	DllCall("oleacc\GetRoleText", "Uint", nRole, "str", sRole, "Uint", nSize+1)
	Return	sRole
}
