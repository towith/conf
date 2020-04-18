
#Persistent
DetectHiddenWindows,on
;获取招商证券持仓数量，需要先登录到交易软件，并浏览过一次持仓情况后才可自动获取。
 
Gui,Add,ListView, r20 w800,股票名称|证券数量|可卖数量|成本价|浮动盈亏|盈亏比例（`%）|最新市值|当前价|证券代码|股东代码
Gui,Show,, 持仓信息
SetTimer, 获取持仓,1000
获取持仓:
;注意1、最后一个参数不要忽略 
;注意2、SysListView321这个控件ID需要自己用spy软件先获取，可能随着运行次数不同会变
ControlGet, tdxlist, List, 0, SysListView321, A
LV_delete()
Loop,Parse, tdxlist,`n
LV_Add("",StrSplit(A_LoopField,A_Tab)*)
Return
GuiClose:
GuiEscape:
	ExitApp
