
;debug.ahk
;����:sunwind
;ʱ��:2016��1��11��21:47:52
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
	������=%StringToSend%
	����ֵ=% (%StringToSend%)
	StringToSend= %������%=%����ֵ%
	}
result := Send_WM_COPYDATA(StringToSend, TargetScriptTitle)
if result = FAIL
    MsgBox SendMessage failed. Does the following WinTitle exist?:`n%TargetScriptTitle%
else if result = 0
    MsgBox Message sent but the target window responded with 0, which may mean it ignored it.
return
}
 
Send_WM_COPYDATA(ByRef StringToSend, ByRef TargetScriptTitle)  ; �����������ʹ�� ByRef �ܽ�ԼһЩ�ڴ�.
; �˺�������ָ�����ַ�����ָ���Ĵ���Ȼ�󷵻��յ��Ļظ�.
; ���Ŀ�괰�ڴ�������Ϣ��ظ�Ϊ 1, ����Ϣ����������Ϊ 0.
{
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)  ; ����ṹ���ڴ�����.
    ; �������ýṹ�� cbData ��ԱΪ�ַ����Ĵ�С, ������������ֹ��:
    SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)  ; ����ϵͳҪ�������Ҫ���.
    NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)  ; ���� lpData Ϊ���ַ��������ָ��.
    Prev_DetectHiddenWindows := A_DetectHiddenWindows
    Prev_TitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows On
    SetTitleMatchMode 2
    SendMessage, 0x4a, 0, &CopyDataStruct,, %TargetScriptTitle%  ; 0x4a Ϊ WM_COPYDATA. ����ʹ�÷��Ͷ�����Ͷ��.
    DetectHiddenWindows %Prev_DetectHiddenWindows%  ; �ָ�������ԭ��������.
    SetTitleMatchMode %Prev_TitleMatchMode%         ; ͬ��.
    return ErrorLevel  ; ���� SendMessage �Ļظ������ǵĵ�����.
}
