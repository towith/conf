
Ev_DESTROY_DISPATCH(wParam,lParam){
    f:=windowIdInfoFd . "\" . lParam
    FileReadLine, cc, %f%, 1
    fun:=cc . "_" . wparam
    if(IsFunc(fun)){
        Func(fun).call(wParam,lParam)
    }
    WinGetTitle, xx, ahk_id %lParam%
    ; OutputDebug % "onDestroy:" . f . " " . cc . " " . xx
    FileDelete ,%f%
}

Ev_UNKNOWN(){
}

exe_Tdxw_exe_1(wParam,lParam){
    ; WinGetTitle, OutputVar , ahk_id %lParam%
    ; WinGetText, OutputText , ahk_id %lParam%

    ; ; OutputDebug,  %   lParam "," OutputVar ","  OutputText
    ; if(InStr(OutputVar, tTDX)=1 && InStr(OutputText,mmmTxt)>1){
    ;     WinActivate, ahk_id %lParam%
    ;     Sleep 500
    ;     sendevent % mmm . "{enter}" 
    ;     ; sendevent {enter}
    ; }
}

TdxW_MainFrame_Class_1(wParam,lParam){
    ; ;    MsgBox, % windowTitleInfo[lParam] ; not work
    ;    WinGetTitle, tt , ahk_id %lParam%
    ;    if(!InStr(tt, tTDX2, true)){
    ;        Return
    ;    }
    ;     ;  WinActivate, ahk_id %lParam%
    ;     ;  WinWaitActive, ahk_id %lParam%,,5
    ;     ;  if(WinActive("ahk_id " . lParam))
    ;     ;  {
    ;     ;        CoordMode, Relative
    ;     ;        Click,343, 26
    ;     ;  }
    ;     giveToolTip("Callback:" tt)
    ;     Sleep 2000
    ;     initTdxControl("ahk_id" lParam,True)

    ;     ; WinMove, ahk_id %lParam%, , , , 500, 474
    ;     if(WinActive("ahk_id" lParam)){
    ;         CoordMode, Mouse, Relative
    ;         MouseClick, Left, 265, 237,2
    ;     }

}

;; event func
/* SUMATRA_PDF_FRAME_32772(){
}

SUMATRA_PDF_FRAME_1(wParam,lParam){
    if(lParam){ 
        WinWaitActive, ahk_id %lParam% ,,5
        Gosub, createDocInfo
    }
}

SUMATRA_PDF_FRAME_2(wParam,lParam){
    WinClose, ahk_class AutoHotkeyGUI
}

*/
;;  pn=="vivaldi.exe"
; cmdLine:=RunWaitSilent("Get-WmiObject win32_process | where {$_.processid -eq '" . pid . "'} | select  commandline | ft  -HideTableHeaders")
; if(InStr(cmdline, "Profile 4")){
; }

;; event funcend
; SDL_app_32772(){ ;; srccpy
;     if(WinActive("ahk_class SDL_app")){
;         ; TryScrCpyUnlock()
;     }
; }

; Chrome_WidgetWin_1_2(wParam,lParam){
;     f:=runtimeFolder . "\OpenWinV"
;     FileReadLine, OutputVar, % f, 1
;     ; OutputDebug, % OutputVar "|" lParam
;     if(lParam==OutputVar){
;         FileDelete, % f
;     }
; }

; Chrome_WidgetWin_1_1(wParam,lParam){
;     ; WinWaitActive, ahk_id %lParam%,,5
;     ; Sleep 500
;     ; if(isWindowFullScreen("ahk_id " . lParam)){
;     ; }else{
;     ;             WinGet, pn, ProcessName, ahk_id %lParam%
;     ;             if(pn="vivaldi.exe"){
;     ;               Sleep 500
;     ;               send {f11}
;     ;               Sleep 500
;     ;               send !^+t
;     ;             }
;     ; } 

; }

_T_ToolWindow_1(wParam,lParam){
    Sleep, 500
    Winset , AlwaysOnTop,,ahk_id %lParam%
}
_T_ToolWindow_32772(wParam,lParam){
    Sleep, 500
    Winset , AlwaysOnTop,,ahk_id %lParam%
}