

; ~^C::
#!f11::
QueryGoogle:
  Send ^c
  Sleep, 50
  run %browser_path% https://translate.google.cn/#view=home&op=translate&sl=en&tl=zh-CN&text=%Clipboard%,,Hide
return 

#+f11::
PlayWordVoice:
 Send ^c
 Sleep, 50
 prepareWord(Clipboard,"auto",en)
 Gosub, playvoice
return

playvoice:
   FileCreateDir, D:\z_my\envoc\sound
   f:= "D:\z_my\envoc\sound\" . currentWords . ".mp3"
   if(!FileExist(f)){
      UrlDownloadToFile,  %voiceUrl%, %f%
   } 

   ; OutputDebug f: %f%
   if(FileExist(f)){
      SoundPlay %f%
   }
	; FileDelete, %f%
return

#f11::
TransPop:
   WinGet,pid,id,A
   Send ^c
   Sleep, 500
	ToolTip, Translating...
   res:=GoogleTranslate(Clipboard, "en","zh_CN").full
	; ToolTip, % res
   
   ; Gui,ok:Destroy
   Gui,ok:New,,MyTranslator
   Gui,ok:Add, Edit,  ReadOnly vMyEdit Multi W700 H200 
   Gui,Font, s14 Cblue 
   GuiControl,ok:Font,MyEdit
   GuiControl, ok:Text, MyEdit, %res%
   Gui,ok:Add,Button,gplayvoice w80 vButton,&<Play
   Gui,ok:Add,Button,gAddword w120 vBAdd,Add to &>Note
   ; Gui,ok:+Parent%pid%
   Gui,ok:+Owner%pid%
   Gui,ok:+ToolWindow 
	Gui,ok:Show
   GuiControl,ok: Focus,Button
   ; SoundBeep
	; KeyWait, lwin, up L 
	; KeyWait, Esc, Down
	ToolTip
Return


#IfWinActive,MyTranslator
Esc::
   Gui,ok:Destroy
return
#IfWinActive

Addword:
 showWinAfterTrans:=false
 ControlGetText, result, Edit1,A
 Gosub,doAddword
 pid:=getParentId(WinExist())
 Gui,ok:Destroy
 WinWaitActive, %tVivaldi%,,5
 if(WinActive(tVivaldi)){
     Sleep 500
     WinActivate, ahk_id %pid%
 }
return

doAddword:
   fileName := "D:\z_my\envoc\B" . A_MM . A_DD ".md"
   FileAppend, %result%`n`n, %fileName%
   u:="file:///" . fileName . "?&appended" ; . "&translate"
   Run , %browser_path% --profile-directory="Profile 4" %u%,,Hide,pid
return


#!f12::
AddAndOpen:
   WinGet, id, id,A 
   Send ^c
   Sleep, 50
	ToolTip, Translating...
   result:=GoogleTranslate(Clipboard, "en","zh_CN").full
   Gosub, doAddword

   ;; back
   WinWaitActive, %tVivaldi%,,5
   if(WinActive(tVivaldi)){
         WinActivate, ahk_id %id%
   }
	ToolTip
Return

; $F1::
;    Clipboard := ""
;    SendInput, ^c
;    ClipWait, 1
;    if ErrorLevel
;       Return
;    Clipboard := GoogleTranslate(Clipboard).main
;    Return
 
GoogleTranslate(str, from := "auto", to := "en")  {
   
  str:=StrReplace(str, "`r`n", " ", , Limit := 1)
  str:=StrReplace(str, "- ", "-", , Limit := 1)
  str:=Trim(str)
   
   try{
      sJson := SendRequest( str, to, from)
   }
   Catch, e
   {
      ToolTip 
      throw {shower:"tooltip",error:e}
   }
   oJSON := A_JSON.Parse(sJson)
 
   ; if !IsObject(oJSON[2])  {
   ;    for k, v in oJSON[1]
   ;       trans .= v[1]
   ; }
   ; else  {
      MainTransText := "# " oJSON[1,1,2] "`n - " oJSON[1, 1, 1] "`n - " oJSON[1][2][4]
      if(IsObject(oJSON[2])){
         trans .= "`n## Full "
      }
      for k, v in oJSON[2]  {
         for i, txt in v[2]
            trans .= (MainTransText = txt ? "" : "`n`t* " . txt)
      }
      desc:=""
      if(IsObject(oJSON[13])){
         desc .= "`n## Desc `n"
      }
      for k,v in oJSON[13]{
         if(IsObject(v)){
            x0:=v[1]
            desc .= "- " x0 "`n"
            ; desc .= "`n```````n"
            for i,txt in v[2]{
               x1:=txt[1]
               x2:=Trim(txt[3],"`n")
               desc .= "`t>``" x1 "``  `n"
               desc .= "`t>" x2  "  `n"
            }
            ; desc .= "`n```````n"
         }
      }
   ; }
   full := MainTransText
   if IsObject(oJSON[2]){
      ; MainTransText := trans := Trim(trans, ",+`n ")
      full := MainTransText . "`n" . Trim(trans, ",+`n ")
   }

   if IsObject(oJSON[13]){
      full := MainTransText . "`n" . Trim(desc, ",+`n ")
   }
 
   from := oJSON[3]
   full := Trim(full, ",+`n ")
   full := full . "`n" "`n`t<audio preload='none'  controls> <source src='" . StrReplace(voiceUrl,"'","&#39;") . "'>no audio...</audio>"
   Return {main: MainTransText, full: full, from: from}
}
 
 
 prepareWord(str,tl,sl){
   voiceUrl:=""
   currentWords:=""
   str:=Trim(str)

   A_JSON := new A_JSON
   JS := A_JSON.JS, JS.( GetJScript() )

       ComObjError(false)
   url := "http://translate.google.cn/translate_a/single?client=t&sl="
        . sl . "&tl=" . tl . "&hl=" . tl
        . "&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=1&ssel=3&tsel=3&pc=1&kc=2"
        . "&tk=" . JS.("tk").(str)
   voiceUrl:="http://translate.google.cn/translate_tts?ie=UTF-8&q=" . str . "&tl=en&total=1&idx=0&tk=" . JS.("tk").(str) . "&client=webapp&prev=input"
   currentWords:=str
   return url
 }

SendRequest( str, tl, sl)  {
   url:=prepareWord(str,tl,sl)
   body := "q=" . URIEncode(str)
   contentType := "application/x-www-form-urlencoded;charset=utf-8"
   userAgent := "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0"
   Return A_JSON.GetFromUrl(url, body, contentType, userAgent)
}
 
URIEncode(str, encoding := "UTF-8")  {
   VarSetCapacity(var, StrPut(str, encoding))
   StrPut(str, &var, encoding)
 
   While code := NumGet(Var, A_Index - 1, "UChar")  {
      bool := (code > 0x7F || code < 0x30 || code = 0x3D)
      UrlStr .= bool ? "%" . Format("{:02X}", code) : Chr(code)
   }
   Return UrlStr
}
 
GetJScript()
{
   script =
   (
      var TKK = ((function() {
        var a = 561666268;
        var b = 1526272306;
        return 406398 + '.' + (a + b);
      })());
 
      function b(a, b) {
        for (var d = 0; d < b.length - 2; d += 3) {
            var c = b.charAt(d + 2),
                c = "a" <= c ? c.charCodeAt(0) - 87 : Number(c),
                c = "+" == b.charAt(d + 1) ? a >>> c : a << c;
            a = "+" == b.charAt(d) ? a + c & 4294967295 : a ^ c
        }
        return a
      }
 
      function tk(a) {
          for (var e = TKK.split("."), h = Number(e[0]) || 0, g = [], d = 0, f = 0; f < a.length; f++) {
              var c = a.charCodeAt(f);
              128 > c ? g[d++] = c : (2048 > c ? g[d++] = c >> 6 | 192 : (55296 == (c & 64512) && f + 1 < a.length && 56320 == (a.charCodeAt(f + 1) & 64512) ?
              (c = 65536 + ((c & 1023) << 10) + (a.charCodeAt(++f) & 1023), g[d++] = c >> 18 | 240,
              g[d++] = c >> 12 & 63 | 128) : g[d++] = c >> 12 | 224, g[d++] = c >> 6 & 63 | 128), g[d++] = c & 63 | 128)
          }
          a = h;
          for (d = 0; d < g.length; d++) a += g[d], a = b(a, "+-a^+6");
          a = b(a, "+-3^+b+-f");
          a ^= Number(e[1]) || 0;
          0 > a && (a = (a & 2147483647) + 2147483648);
          a `%= 1E6;
          return a.toString() + "." + (a ^ h)
      }
   )
   Return script
}
 
class A_JSON
{
   static JS := A_JSON._GetJScripObject()
   
   Parse(JsonString)  {
      try oJSON := this.JS.("(" JsonString ")")
      catch  {
         MsgBox, Wrong JsonString!
         Return
      }
      Return this._CreateObject(oJSON)
   }

   GetFromUrl(url, body := "", contentType := "", userAgent := "")  {
      try{
         XmlHttp := ComObjCreate("WinHttp.WinHttpRequest.5.1")
         ; XmlHttp := ComObjCreate("Microsoft.XmlHttp") ;; wtf, Get become post
         ; XmlHttp := ComObjCreate("MSXML2.XMLHTTP.6.0")
         XmlHttp.SetProxy(2,"http://127.0.0.1:8888")
         XmlHttp.SetTimeouts(5000, 5000, 5000, 5000)
         ; XmlHttp.SetTimeouts(2000, 2000, 2000, 2000)
         XmlHttp.Open("POST", url, false)
         ( contentType && XmlHttp.setrequestheader("Content-Type", contentType) )
         ( userAgent && XmlHttp.setrequestheader("User-Agent", userAgent) )
         XmlHttp.setrequestheader("Accept","application/json")
         time := WebRequest.WaitForResponse(2)

         XmlHttp.Send(body)

         if (time = -1) {
               ToolTip "connection timeout"
            return
         }

         status:=XmlHttp.Status


         if(status==200){
          Return XmlHttp.ResponseText
         }else{
            Throw, "Timeout"
         }
         ; XmlHttp.WaitForResponse()
         ;   OutputDebug % XmlHttp.ResponseText
      }
      catch e
      {
         throw e
      }
      
   }
 
   _GetJScripObject()  {
      VarSetCapacity(tmpFile, (MAX_PATH := 260) << !!A_IsUnicode, 0)
      DllCall("GetTempFileName", Str, A_Temp, Str, "AHK", UInt, 0, Str, tmpFile)
     
      FileAppend,
      (
      <component>
      <public><method name='eval'/></public>
      <script language='JScript'></script>
      </component>
      ), % tmpFile
     
      JS := ObjBindMethod( ComObjGet("script:" . tmpFile), "eval" )
      FileDelete, % tmpFile
      A_JSON._AddMethods(JS)
      Return JS
   }
 
   _AddMethods(ByRef JS)  {
      JScript =
      (
         Object.prototype.GetKeys = function () {
            var keys = []
            for (var k in this)
               if (this.hasOwnProperty(k))
                  keys.push(k)
            return keys
         }
         Object.prototype.IsArray = function () {
            var toStandardString = {}.toString
            return toStandardString.call(this) == '[object Array]'
         }
      )
      JS.("delete ActiveXObject; delete GetObject;")
      JS.(JScript)
   }
 
   _CreateObject(ObjJS)  {
      res := ObjJS.IsArray()
      if (res = "")
         Return ObjJS
     
      else if (res = -1)  {
         obj := []
         Loop % ObjJS.length
            obj[A_Index] := this._CreateObject(ObjJS[A_Index - 1])
      }
      else if (res = 0)  {
         obj := {}
         keys := ObjJS.GetKeys()
         Loop % keys.length
            k := keys[A_Index - 1], obj[k] := this._CreateObject(ObjJS[k])
      }
      Return obj
   }
}