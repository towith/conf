
;������.ahk �벻Ҫ����
;����:sunwind
;ʱ��:2016��1��11��21:47:52
 
#SingleInstance
OnMessage(0x4a, "Receive_WM_COPYDATA")  ; 0x4a Ϊ WM_COPYDATA
 
; ʾ��: ���˵����ļ��ı��༭��.
 
; Ϊ�˵��������Ӳ˵�:
Menu, FileMenu, Add, &New, FileNew
Menu, FileMenu, Add, &Open, FileOpen
Menu, FileMenu, Add, &Save, FileSave
Menu, FileMenu, Add, Save &As, FileSaveAs
Menu, FileMenu, Add  ; �ָ���.
Menu, FileMenu, Add, E&xit, FileExit
Menu, HelpMenu, Add, &About, HelpAbout
 
; �������������Ӳ˵��Ĳ˵���:
Menu, MyMenuBar, Add, &File, :FileMenu
Menu, MyMenuBar, Add, &Help, :HelpMenu
 
; ��Ӳ˵���������:
Gui, Menu, MyMenuBar
 
; �������༭�ؼ�����ʾ����:
Gui, +Resize  ; ���û����Ե������ڵĴ�С.
Gui, Add, Edit, vMainEdit WantTab W600 R20
;~ Gui, Show,, Untitled
Gui, Show,, ������
CurrentFileName =  ; ��ʾ��ǰû���ļ�.
return
 
FileNew:
GuiControl,, MainEdit  ; ��ձ༭�ؼ�.
return
 
FileOpen:
Gui +OwnDialogs  ; ǿ���û���Ӧ FileSelectFile �Ի������ܷ��ص�������.
FileSelectFile, SelectedFileName, 3,, Open File, Text Documents (*.txt)
if SelectedFileName =  ; û��ѡ���ļ�.
    return
Gosub FileRead
return
 
FileRead:  ; �������Ѿ������� SelectedFileName ����.
FileRead, MainEdit, %SelectedFileName%  ; ��ȡ�ļ������ݵ�������.
if ErrorLevel
{
    MsgBox Could not open "%SelectedFileName%".
    return
}
GuiControl,, MainEdit, %MainEdit%  ; �ڿؼ�����ʾ�ı�.
CurrentFileName = %SelectedFileName%
Gui, Show,, %CurrentFileName%   ; �ڱ�������ʾ�ļ���.
return
 
FileSave:
if CurrentFileName =   ; ��û��ѡ���ļ�, ����ִ�����Ϊ����.
    Goto FileSaveAs
Gosub SaveCurrentFile
return
 
FileSaveAs:
Gui +OwnDialogs  ; ǿ���û���Ӧ FileSelectFile �Ի������ܷ��ص�������..
FileSelectFile, SelectedFileName, S16,, Save File, Text Documents (*.txt)
if SelectedFileName =  ; û��ѡ���ļ�.
    return
CurrentFileName = %SelectedFileName%
Gosub SaveCurrentFile
return
 
SaveCurrentFile:  ; �������Ѿ�ȷ���� CurrentFileName ��Ϊ��.
IfExist %CurrentFileName%
{
    FileDelete %CurrentFileName%
    if ErrorLevel
    {
        MsgBox The attempt to overwrite "%CurrentFileName%" failed.
        return
    }
}
GuiControlGet, MainEdit  ; ��ȡ�༭�ؼ�������.
FileAppend, %MainEdit%, %CurrentFileName%  ; �������ݵ��ļ�.
; �ɹ�ʱ�ڱ�������ʾ�ļ��� (�Է� FileSaveAs ����ʱ�����):
Gui, Show,, %CurrentFileName%
return
 
HelpAbout:
Gui, About:+owner1  ; �������� (Gui #1) ��Ϊ "���ڶԻ���" �ĸ�����.
Gui +Disabled  ; ����������.
Gui, About:Add, Text,, Text for about box.
Gui, About:Add, Button, Default, OK
Gui, About:Show
return
 
AboutButtonOK:  ; ����� "���ڶԻ���" ��Ҫʹ���ⲿ��.
AboutGuiClose:
AboutGuiEscape:
Gui, 1:-Disabled  ; �������������� (��������һ��֮ǰ����).
Gui Destroy  ; ���ٹ��ڶԻ���.
return
 
GuiDropFiles:  ; ���Ϸ��ṩ֧��.
Loop, Parse, A_GuiEvent, `n
{
    SelectedFileName = %A_LoopField%  ; ����ȡ�׸��ļ� (����ж���ļ���ʱ��).
    break
}
Gosub FileRead
return
 
GuiSize:
if ErrorLevel = 1  ; ���ڱ���С����.  ������в���.
    return
; ����, ���ڵĴ�С���������������. �����༭�ؼ��Ĵ�С��ƥ�䴰��.
NewWidth := A_GuiWidth - 20
NewHeight := A_GuiHeight - 20
GuiControl, Move, MainEdit, W%NewWidth% H%NewHeight%
return
 
FileExit:     ; �û��� File �˵���ѡ���� "Exit".
GuiClose:  ; �û��ر��˴���.
ExitApp
 
Receive_WM_COPYDATA(wParam, lParam)
{
    global
    StringAddress := NumGet(lParam + 2*A_PtrSize)  ; ��ȡ CopyDataStruct �� lpData ��Ա.
    CopyOfData := StrGet(StringAddress)  ; �ӽṹ�и����ַ���.
    ; ���� MsgBox, Ӧ���� ToolTip ��ʾ, �������ǿ��Լ�ʱ����:
    ;~ ToolTip %A_ScriptName%`nReceived the following string:`n%CopyOfData%
    ;~ SplashTextOn, 400,300 ,������, %CopyOfData%
    ;~ WinMove, ������, , A_ScreenWidth-200, A_ScreenHeight-200
    ;~ WinSetTitle, <insert title of splash window>, , NewTitle
	FormatTime, TimeString, %A_Now%, yyyy-MM-dd HH:mm:ss
	logTotal=%logTotal%`n%TimeString%`t%CopyOfData%
	GuiControl,,MainEdit,%logTotal%  ;������������ѣ�todo�Զ�����
    return true  ; ���� 1 (true) �ǻظ�����Ϣ�Ĵ�ͳ��ʽ.
}
