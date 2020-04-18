; #IfWinExist, __tsense_mode_win

; ----------------------------------------------------------------------------
; window
tsense_bgcolor      := "FFFF99"
tsense_transeparent := 210

; ----------------------------------------------------------------------------
; key bind
;^h::MouseMove, -16,   0, 0, R
;^j::MouseMove,   0,  16, 0, R
;^k::MouseMove,   0, -16, 0, R
;^l::MouseMove,  16,   0, 0, R
;+h::MouseMove,  -8,   0, 0, R
;+j::MouseMove,   0,   8, 0, R
;+k::MouseMove,   0,  -8, 0, R
;+l::MouseMove,   8,   0, 0, R
;j::Down
;k::Up
;h::Left
;l::Right
;h::MouseMove,  -8,   0, 0, R
;j::MouseMove,   0,   8, 0, R
;k::MouseMove,   0,  -8, 0, R
;l::MouseMove,   8,   0, 0, R

;Enter::Send, {END}{ENTER}
;f::Send, {WheelDown}
;b::Send, {WheelUp}

;n::Send, {PgDn}
;p::Send, {PgUp}
;i::Tab

;c::LButton
;r::RButton
;m::MButton

;w::WinClose, A

;d::Send, {LButton}{LButton}
;t::WinGetTitle, clipboard, r

; r::ToggleMaximize(0)
;+r::ToggleMaximize(1)
;^r::ToggleMaximize(2)

z::StartEasyWindowDrag()
z Up::EndEasyWindowDrag()
x::StartEasyWindowResize()
x Up::EndEasyWindowResize()
;s::GoTo, esmb_TriggerKeyDown
;s Up::GoTo, esmb_TriggerKeyUp

; ----------------------------------------------------------------------------
; #IfWinExist
