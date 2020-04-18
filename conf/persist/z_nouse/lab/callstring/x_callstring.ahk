; .. .. /snip

pipe_name := "testpipe"


pipe_ga := CreateNamedPipe(pipe_name, 2)
pipe    := CreateNamedPipe(pipe_name, 2)
if (pipe=-1 or pipe_ga=-1) {
    MsgBox CreateNamedPipe failed.
    ExitApp
}

;Menu, Tray, Icon, "\\.\pipe\%pipe_name%"
	hIcon := DllCall("LoadImage", uint, 0 
	 , str, "\\.\pipe\%pipe_name%"
	 , uint, 1, int, 0, int, 0, uint, 0x10)
DllCall("ConnectNamedPipe","uint",pipe_ga,"uint",0)

res := BinRead(pipe,data)
;if !DllCall("WriteFDllile","uint",pipe,"str",Icon,"uint",StrLen(Icon)+1,"uint*",0,"uint",0)
;    MsgBox WriteFile failed: %ErrorLevel%/%A_LastError%

;DllCall("ConnectNamedPipe","uint",pipe_ga,"uint",0)

DllCall("CloseHandle","uint",pipe_ga)

;DllCall("ConnectNamedPipe","uint",pipe,"uint",0)

;Script = ???%Script%

;if !DllCall("WriteFile","uint",pipe,"str",Icon,"uint",StrLen(Icon)+1,"uint*",0,"uint",0)
;    MsgBox WriteFile failed: %ErrorLevel%/%A_LastError%

DllCall("CloseHandle","uint",pipe)
	SendMessage, 0x80, 1, hIcon

Gui, Add, Button, gGuiEscape,RUN!
Gui, Show

return

CreateNamedPipe(Name, OpenMode=3, PipeMode=0, MaxInstances=255) {
    return DllCall("CreateNamedPipe","str","\\.\pipe\" Name,"uint",OpenMode
        ,"uint",PipeMode,"uint",MaxInstances,"uint",0,"uint",0,"uint",0,"uint",0)
}

GuiClose:
GuiEscape:
Escape::
ExitApp

;.. .. /snip

; There go some more Lines here merily copied from 
; http://www.autohotkey.com/forum/topic4546.html (1st code example)
; and my DataThingy (done with read bin, readFile, String2MessageBx, 
; copyMsg, strip out whatever unneeded, paste in continuation section  
; The Gosub, Data Call sets a new value for dataVariable