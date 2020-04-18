; Show a menu of the first n files matching a pattern, and their icons.
pattern = %A_ScriptDir%\*
n = 15

; Allocate memory for a SHFILEINFOW struct.
VarSetCapacity(fileinfo, fisize := A_PtrSize + 688)

Loop, Files, %pattern%, FD
{
    ; Add a menu item for each file.
    Menu F, Add, %A_LoopFileName%, donothing
    
    ; Get the file's icon.
    if DllCall("shell32\SHGetFileInfoW", "WStr", A_LoopFileFullPath
        , "UInt", 0, "Ptr", &fileinfo, "UInt", fisize, "UInt", 0x100)
    {
        hicon := NumGet(fileinfo, 0, "Ptr")
        ; Set the menu item's icon.
        Menu F, Icon, %A_Index%&, HICON:%hicon%
        ; Because we used ":" and not ":*", the icon will be automatically
        ; freed when the program exits or if the menu or item is deleted.
    }
}
until A_Index = n
Menu F, Show
donothing:
return