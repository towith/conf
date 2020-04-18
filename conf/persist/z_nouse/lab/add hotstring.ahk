
;
#h::  ; Win+H hotkey
; Get the text currently selected. The clipboard is used instead of
; "ControlGet Selected" because it works in a greater variety of editors
; (namely word processors).  Save the current clipboard contents to be
; restored later. Although this handles only plain text, it seems better
; than nothing:
ClipboardOld := Clipboard
Clipboard := "" ; Must start off blank for detection to work.
Send ^c
ClipWait 1
if ErrorLevel  ; ClipWait timed out.
    return
; Replace CRLF and/or LF with `n for use in a "send-raw" hotstring:
; The same is done for any other characters that might otherwise
; be a problem in raw mode:
ClipContent := StrReplace(Clipboard, "``", "````")  ; Do this replacement first to avoid interfering with the others below.
ClipContent := StrReplace(ClipContent, "`r`n", "``r")  ; Using `r works better than `n in MS Word, etc.
ClipContent := StrReplace(ClipContent, "`n", "``r")
ClipContent := StrReplace(ClipContent, "`t", "``t")
ClipContent := StrReplace(ClipContent, "`;", "```;")
Clipboard := ClipboardOld  ; Restore previous contents of clipboard.
ShowInputBox("::`[::" ClipContent)
; ShowInputBox(":T:`::" ClipContent)
return

ShowInputBox(DefaultValue)
{
    ; This will move the InputBox's caret to a more friendly position:
    SetTimer, MoveCaret, 10
    ; Show the InputBox, providing the default hotstring:
    InputBox, UserInput, New Hotstring,
    (
    Type your abreviation at the indicated insertion point. You can also edit the replacement text if you wish.

    Example entry: :R:btw`::by the way
    ),,,,,,,, %DefaultValue%
    if ErrorLevel  ; The user pressed Cancel.
        return

    if RegExMatch(UserInput, "O)(?P<Label>:.*?:(?P<Abbreviation>.*?))::(?P<Replacement>.*)", Hotstring)
    {
        if !Hotstring.Abbreviation
            MsgText := "You didn't provide an abbreviation"
        else if !Hotstring.Replacement
            MsgText := "You didn't provide a replacement"
        else
        {
            Hotstring(Hotstring.Label, Hotstring.Replacement)  ; Enable the hotstring now.
            FileAppend, `n%UserInput%, %A_ScriptFullPath%  ; Save the hotstring for later use.
        }
    }
    else
        MsgText := "The hotstring appears to be improperly formatted"

    if MsgText
    {
        MsgBox, 4,, %MsgText%. Would you like to try again?
        IfMsgBox, Yes
            ShowInputBox(DefaultValue)
    }
    return
    
    MoveCaret:
    WinWait, New Hotstring
    ; Otherwise, move the InputBox's insertion point to where the user will type the abbreviation.
    Send {Home}{Right 3}
    SetTimer,, Off
    return
}
