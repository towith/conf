class HH{
    IdeaPjRun(p1,p2,p3){
        IdeaPjRun(p1,p2,p3)
    }
}


IdeaPjRun(pjTitle,runTitle:="",seq:=0){
    SetTitleMatchMode 1
    WinWait %pjTitle%,,30
    if(ErrorLevel==1){
        return
    }
    i:=0
    maxTry:=30
    ToolTip, Try activate %pjTitle%
    while(!WinActive(pjTitle)){
        WinActivate, %pjTitle%
        i++
        if(i>maxTry){
            Throw, % "WinActivate exceeds max settings[" pjTitle "]"  
        }
    }
    Send , !+{f9}
    Sleep 500
    if(WinExist("ahk_class SunAwtWindow")){
        Sleep 500
        ; OutputDebug, Found Exist ahk_class SunAwtWindow
    }
    SetKeyDelay, 0, 1
    ControlSend,, %runTitle%{right}, %pjTitle%
    Sleep 300
    loop %seq% {
        ControlSend ,, {down},%pjTitle%
    }
    Sleep 70
    ControlSend ,, {enter},%pjTitle%
    return
}

IdeaRunTermCmd(cmdArray){
    WinActivate %tIdea%
    WinWaitActive %tIdea%, , 10
    if(ErrorLevel){
        return
    }
    SendEvent, {Esc}
    Sleep 500
    SendEvent, {Esc}
    Sleep 500
    SendEvent !{f12}
    Sleep 500
    for i, e in cmdArray{
        SendInput, %e% {enter}
    }
    return
}



doTotalCmd(){
    ;; tc
    ; Run, %TC_PATH% /O /L=%tc_lp% /R=%tc_rp% /A /S /P=L,,Min
    RunWithStyle(TC_PATH . " /O /L=" . tc_lp . " /R=" . tc_rp . " /A /P=L")
    WinWait  %tTC%
}

doIdea(){
        debug("open:" projects)
        debug(IDEA_PATH . " " . projects)
        c:=IDEA_PATH . " " . projects
        ; pid:=RunAsFunc(c)
        Run, %c% , , , pid
        projArr:=StrSplit(projects, A_Space)
        currentMode:=A_TitleMatchMode
        SetTitleMatchMode, 2 
        for i,p in projArr {
            if(p){
                WinWait %p%,, 30
            }
        }
        SetTitleMatchMode, %currentMode% 
}




doScrcpy(){
    tScrcpy:="ahk_exe scrcpy.exe"
    if(!WinExist(tScrcpy)){
        RunWait, adb connect %phone_s%
        Run scrcpy -m 800 -s %phone_s% 
        WinWait,%tScrcpy%,,5
        WinHide,%tScrcpy%
    }
    ;; scrcpy
   WinWait,  %phone_t%,,5
   WinActivate,%phone_t%,,5
    if(WinActive(tScrcpy)){
        WinWaitActive,%phone_t%,,1
        MoveWindowToDesktop(2,phone_t,false)
        WinMove, % tScrcpy,,1348,30
    } 
}

doWx(){
    tWx:="ahk_exe WeChat.exe"
    tLogin:="ahk_class WeChatLoginWndForPC"
    if(!WinExist(tWx)){
        Run , D:\Program Files (x86)\Tencent\WeChat\WeChat.exe
    }
    WinWait,%tWx%,,5
    if(WinExist(tLogin)){
        WinActivate,%tLogin%,,5
        WinWaitActive,%tLogin%,,1
        send {enter}
    }
   WinWaitActive, %tWx%,,5
     if(WinActive(tWx)){
        ; MoveWindowToDesktop(2,,false)
        ; MoveWindowToDesktop(2,tWx,false)
    }

}

doFiddler(){
    tFiddler:="ahk_exe Fiddler.exe"
    if(WinExist(tFiddler)){
        Return
    }
    Run,D:\Applications\Scoop\apps\fiddler\current\Fiddler.exe
    WinWaitActive Progress Telerik Fiddler Web Debugger %tFiddler% ,,10
}





doFiles(){
    for i,f in files{
        Run, %f%
    }
}



minimizeAll(){
       WinMinimizeAll
}

doAfter(){
    ;; idea
   ;  cmd:=new Array("set PATH=D:\Program Files\Java\jdk1.8.0_211\bin;%PATH%","quasar dev -m cordova -T android -H 192.168.43.10")
   ;  IdeaRunTermCmd(cmd)
   ;; wait all start up app startup
;    waitWin()

    for i,e in afterActionsArr
    {
        doCallAction(e)
    }
}

waitWin(){
    if(!waitWins){
        Return
    }
    d:=A_DetectHiddenWindows
    DetectHiddenWindows, On
    for i, e in waitWins
    {
        WinWait, %t%,,5
        if(WinExist(e)){
        }
    }
    DetectHiddenWindows, %d%
    Sleep 500
}


doCallAction(a:=""){
    if(IsFunc(a)){
        ToolTip, % "action: " . a
        ; OutputDebug % "action: " . a
        Func(a).call()
    }else{
        throw a . " is not a valid action function"
    }
}