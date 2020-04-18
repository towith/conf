
;debug.ahk
;作者:sunwind
;时间:2016年1月11日21:47:52
debug(StringToSend,TargetScriptTitle= "debugui.ahk ahk_class AutoHotkey")
{
global
if (StringToSend="")
    return
	if IsObject(StringToSend)
	{
		For index, value in StringToSend
			StringToSend.= "Item " index " is '" value "'`n"
	}
	else{
	变量名=%StringToSend%
	变量值=% (%StringToSend%)
	StringToSend= %变量名%=%变量值%
	}
result := Send_WM_COPYDATA(StringToSend, TargetScriptTitle)
if result = FAIL
    MsgBox SendMessage failed. Does the following WinTitle exist?:`n%TargetScriptTitle%
else if result = 0
    MsgBox Message sent but the target window responded with 0, which may mean it ignored it.
return
}
 
Send_WM_COPYDATA(ByRef StringToSend, ByRef TargetScriptTitle)  ; 在这种情况中使用 ByRef 能节约一些内存.
; 此函数发送指定的字符串到指定的窗口然后返回收到的回复.
; 如果目标窗口处理了消息则回复为 1, 而消息被忽略了则为 0.
{
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)  ; 分配结构的内存区域.
    ; 首先设置结构的 cbData 成员为字符串的大小, 包括它的零终止符:
    SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)  ; 操作系统要求这个需要完成.
    NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)  ; 设置 lpData 为到字符串自身的指针.
    Prev_DetectHiddenWindows := A_DetectHiddenWindows
    Prev_TitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows On
    SetTitleMatchMode 2
    SendMessage, 0x4a, 0, &CopyDataStruct,, %TargetScriptTitle%  ; 0x4a 为 WM_COPYDATA. 必须使用发送而不是投递.
    DetectHiddenWindows %Prev_DetectHiddenWindows%  ; 恢复调用者原来的设置.
    SetTitleMatchMode %Prev_TitleMatchMode%         ; 同样.
    return ErrorLevel  ; 返回 SendMessage 的回复给我们的调用者.
}
