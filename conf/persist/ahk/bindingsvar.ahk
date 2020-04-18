global voiceUrl:=""
global currentWords:=""
global showWinAfterTrans:=false
global pid:=0
global f9toggle:=true
global preWin:=0

Winset , Bottom,,%tTaskbar%
mapDefinedKeys()



OnClipboardChange("ClipChanged",1)


ClipChanged(Type) {
    ; ToolTip %Clipboard% data type: %Type%
}
