; :*b0:<em>::</em>{left 5}

; :*:\date::  
;     ; FormatTime, CurrentDateTime,, M/d/yyyy H:mm:ss tt  ; It will look like 9/1/2005 3:53 PM
;     FormatTime, CurrentDateTime,, MMddHHmm  
;     SendInput %CurrentDateTime%
; Return

; :*:\mail::
;   send {raw}calflying@outlook.com
; Return


; :*:\a::  locals{enter}
; :*:\b::  cont{enter}


; :*:\d::  
;   send cont{enter}
;   Sleep, 700
;   send locals{enter}
; return

