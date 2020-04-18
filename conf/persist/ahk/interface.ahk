
paths := {}
paths["/"] := Func("HelloWorld")
paths["404"] := Func("NotFound")
paths["/logo"] := Func("Logo")
paths["/mdLoaded"] := Func("mdLoaded")
paths["/play"] := Func("play")
paths["/test"] := Func("test")
paths["/run"] := Func("run")
paths["/vact"] := Func("vact")
paths["/tdx"] := Func("tdx")
paths["/toolTip"] := Func("toolTip")
paths["/splash"] := Func("splash")

server := new HttpServer()
; server.LoadMimes(A_ScriptDir . "/mime.types")
server.SetPaths(paths)
server.Serve(11031)

toolTip(ByRef req,ByRef res){
    msg:=Trim(req.queries["msg"])
    giveToolTip(msg)
    res.SetBodyText("ok")
    res.status := 200
}

splash(ByRef req,ByRef res){
    msg:=Trim(req.queries["msg"])
    time:=Trim(req.queries["time"])
    giveSplash(msg,,,time)
    res.SetBodyText("ok")
    res.status := 200
}

tdx(ByRef req,ByRef res){
    action:=Trim(req.queries["action"])
    if(action=="stock"){ 
        code:=Trim(req.queries["code"])
        tdxOpenStock(code,tTDX)
    }
    else if(action=="openByName"){
        name:=Trim(req.queries["name"])
        if(!name){
            MsgBox name is required
            Return
        }
        DB:=DbObj.getDB()
        code:=getCodeByName(name,DB)
        if(code){
            tdxOpenStock(code,tTDX)
        }
    }else if(action=="openPadMyBlock"){
        WinActivate, %tTDX%
        WinWaitActive, %tTDX%,,3
        SendMessage, 0x111, 2628,0,,A
    }else if(action=="openTdxBlock"){
        code:=Trim(req.queries["code"])
        msgCode:=(code-393000)+1+36901
        ; msgCode:=(code-393000)+40600
        WinActivate, %tTDX%
        WinWaitActive, %tTDX%,,3
        ; WinActivate, %tTDX%,,5
        if(WinActive(tTDX)){
            giveTooltip(code . "," . msgCode,5)
            PostMessage, 0x111,%msgCode%,0,,A 
        }
    }
    res.headers["content-type"]:="text/html; charset=utf-8"
    html:=
    (
        "
        <script>window.onload=function(){window.close()}</script>
        "
    )
    res.SetBodyText(html)
    res.status := 200
}

HelloWorld(ByRef req, ByRef res) {
    res.SetBodyText("Hello World")
    res.status := 200
}

Logo(ByRef req, ByRef res, ByRef server) {
    server.ServeFile(res, A_ScriptDir . "/logo.png")
    res.status := 200
}

mdLoaded(ByRef req, ByRef res, ByRef server){
    res.SetBodyText("ok")
    res.status := 200
}

play(ByRef req, ByRef res, ByRef server){
    w:=Trim(req.queries["word"])
    prepareWord(w,"auto",en)
    Gosub playvoice
    if(showWinAfterTrans){
        WinActivate, %tVivaldi%
    }
    res.SetBodyText("ok:" . currentWords)
    res.status := 200
}

test(ByRef req, ByRef res, ByRef server){
    MsgBox, , Title, Text, Timeout]
    res.SetBodyText("ok:" . currentWords)
    res.status := 200
}

run(ByRef req, ByRef res, ByRef server){
    r:=Trim(req.queries["run"])
    ToolTip, % "Run: " . r
    SetTimer, %mRemoveTooltip%, -3000
    Run,% r
    res.SetBodyText("ok:" . currentWords)
    res.status := 200
}

vact(ByRef req, ByRef res, ByRef server){

    a:=Trim(req.queries["act"])
    msg.="act:"
    msg.=a
    p:=""
    WinGet, pn, ProcessName,A
    if(pn=="vivaldi.exe"){
        p:="vivaldi://"
    }else if(pn=="msedge.exe"){
        p:="edge://"
    }else if(pn=="chrome.exe"){
        p:="chrome://"
    }
    if(a=="toUrl"){
        b:=Trim(req.queries["url"])
        b:=StrReplace(b, "<proto>", p)
        Send ^l
        Sleep 200
        SendInput %b%{enter}
    }
    msg.="`nurl:" b
    res.SetBodyText(msg)
    res.status := 200
}