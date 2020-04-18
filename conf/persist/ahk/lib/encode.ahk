SetFormat, integer, H

String := "汉字"
MsgBox, % Encode(String, "CP65001")
return

Encode(Str, Encoding, Separator = "%")
{
    StrCap := StrPut(Str, Encoding)
    VarSetCapacity(ObjStr, StrCap)
    StrPut(Str, &ObjStr, Encoding)
    Loop, % StrCap - 1
    {
        ObjCodes .= Separator . SubStr(NumGet(ObjStr, A_Index - 1, "UChar"), 3)
    }
    Return, ObjCodes
}
