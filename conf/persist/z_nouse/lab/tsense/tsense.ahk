DetectHiddenWindows, On
	CoordMode, Mouse, Screen
InitTsenseMode()


#include *i tsense_conf.ahk

	ToggleTsenseMode(i = -1) {
		global NowTime
			static now := 0
			If (WinExist("__tsense_mode_win") and (i = 1)) {
				return
			}
		if (i = 1) {
now := 1
		} else if (i = 0) {
now := 0
		} else {
now := !now
		}
		if (now) {
			CreateTsenseWindow()
		} else {
			DestroyTsenseWindow()
		}
	}

CreateTsenseWindow() {
	global NowTime
		global tsense_bgcolor, tsense_transeparent

		bgcolor      := "FFFF99"
		transeparent := 210

		if (tsense_bgcolor != "") {
bgcolor := tsense_bgcolor
		}

	if (tsense_transeparent != "") {
transeparent := tsense_transeparent
	}

__tsense_mode_font_size := 10
				 __tsense_mode_gui_h := A_ScreenHeight - __tsense_mode_font_size - 8
				 Gui, +ToolWindow +AlwaysOnTop -Caption +LastFound
				 Gui, +E0x00080020 +0x02000000 -0x0CC00000
				 Gui, Font, S%__tsense_mode_font_size%, Aria
				 Gui, Margin, 2, 2
				 Gui, Add, Text, w%A_ScreenWidth% vNowTime
				 Gui, Show, hide, __tsense_mode_win
				 Gui, Show, x0 y%__tsense_mode_gui_h% NoActivate
				 Gui, Color, %bgcolor%
				 WinSet, Transparent, %transeparent%
				 GoSub, TsenseClockLoop
				 SetTimer, TsenseClockStop, 1000
}

DestroyTsenseWindow() {
	SetTimer, DestroyTsenseWindowWatch, 50
}

DestroyTsenseWindowWatch:
If (isTsenseModeQuitOK()) {
	Gui, Destroy
	; Menu, TRAY, Icon, AutoHotkey.exe, 2
	SetTimer, DestroyTsenseWindowWatch, Off
}
return

InitTsenseMode() {
	TsenseModeQuitOK()
		InitMouseWheelEmu()
		InitEasyWindowDrag()
		InitEasyWindowResize()
}

TsenseModeQuitOK() {
	global tsense_mode_quit_ok
		tsense_mode_quit_ok := 1
}

TsenseModeQuitNG() {
	global tsense_mode_quit_ok
		tsense_mode_quit_ok := 0
}

isTsenseModeQuitOK() {
	global tsense_mode_quit_ok
		return tsense_mode_quit_ok
}


; ----------------------------------------------------------------------------
; MWheel Emu
; ----------------------------------------------------------------------------
InitMouseWheelEmu() {
	global esmb_Threshold, esmb_KeyDown
		esmb_Threshold = 1
		esmb_KeyDown = n
		origX := -1
		origY := -1
		SetTimer, esmb_CheckForScrollEventAndExecute, 40
}

esmb_TriggerKeyDown:
TsenseModeQuitNG()
	esmb_KeyDown = y
	MouseGetPos, esmb_OldX, esmb_OldY
	if (origX < 0 && origY < 0) {
origX := esmb_OldX
	       origY := esmb_OldY
	}
return

esmb_TriggerKeyUp:
TsenseModeQuitOK()
	esmb_KeyDown = n
	origX := -1
	origY := -1
	return

	esmb_CheckForScrollEventAndExecute:
	if esmb_KeyDown = n
	return

	MouseGetPos,, esmb_NewY
	esmb_Distance := esmb_NewY - esmb_OldY

	;; Do not send clicks on the first iteration
	if esmb_Distance > %esmb_Threshold%
{
esmb_OldY := esmb_OldY + esmb_Threshold
		   Send, {WheelDown}
}
else if esmb_Distance < -%esmb_Threshold%
{
esmb_OldY := esmb_OldY - esmb_Threshold
		   Send, {WheelUp}
}

return


; ----------------------------------------------------------------------------
; EasyWindowResize
; ----------------------------------------------------------------------------
InitEasyWindowResize() {
	global EWR_Enable
		EWR_Enable := 0
}

StartEasyWindowResize() {
	global EWR_WID, EWR_Enable, EWR_OrigWinX, EWR_OrigWinY, EWR_OrigWinW, EWR_OrigWinH, EWR_OrigMouseX, EWR_OrigMouseY
		if (EWR_Enable == 0) {
			TsenseModeQuitNG()
				WinGet, EWR_WID, ID, A
				WinGetPos, EWR_OrigWinX, EWR_OrigWinY, EWR_OrigWinW, EWR_OrigWinH, ahk_id %EWR_WID%
				MouseGetPos, EWR_OrigMouseX, EWR_OrigMouseY
				EWR_Enable := 1
				SetTimer, EWR_WatchMouse, 50 ; Track the mouse as the user drags it.
		}
}

EndEasyWindowResize() {
	global EWR_Enable
		EWR_Enable := 0
		TsenseModeQuitOK()
		SetTimer, EWR_WatchMouse, Off
}

EWR_WatchMouse:
MouseGetPos, EWR_TmpMouseX, EWR_TmpMouseY
EWR_WinX := EWR_OrigWinX
EWR_WinY := EWR_OrigWinY
EWR_WinW := EWR_OrigWinW + EWR_TmpMouseX - EWR_OrigMouseX
EWR_WinH := EWR_OrigWinH + EWR_TmpMouseY - EWR_OrigMouseY
WinMove, ahk_id %EWR_WID%, , %EWR_WinX%, %EWR_WinY%, %EWR_WinW%, %EWR_WinH%
return


; ----------------------------------------------------------------------------
; EasyWindowDrag
; ----------------------------------------------------------------------------
InitEasyWindowDrag() {
	global EWD_Enable
		EWD_Enable := 0
}

StartEasyWindowDrag() {
	global EWD_WID, EWD_Enable, EWD_OrigWinX, EWD_OrigWinY, EWD_OrigMouseX, EWD_OrigMouseY
		if (EWD_Enable == 0) {
			TsenseModeQuitNG()
				WinGet, EWD_WID, ID, A
				WinGetPos, EWD_OrigWinX, EWD_OrigWinY, , , ahk_id %EWD_WID%
				MouseGetPos, EWD_OrigMouseX, EWD_OrigMouseY
				EWD_Enable := 1
				SetTimer, EWD_WatchMouse, 50 ; Track the mouse as the user drags it.
		}
}

EndEasyWindowDrag() {
	global EWD_Enable
		EWD_Enable := 0
		TsenseModeQuitOK()
		SetTimer, EWD_WatchMouse, Off
}

EWD_WatchMouse:
MouseGetPos, EWD_TmpMouseX, EWD_TmpMouseY
EWD_WinX := EWD_OrigWinX + EWD_TmpMouseX - EWD_OrigMouseX
EWD_WinY := EWD_OrigWinY + EWD_TmpMouseY - EWD_OrigMouseY
WinMove, ahk_id %EWD_WID%, , %EWD_WinX%, %EWD_WinY%
return


; ----------------------------------------------------------------------------
; ToggleMaximize
; ----------------------------------------------------------------------------
; maximizeLevel = 0 : normal maximize
; maximizeLevel = 1 : maximize without title bar
; maximizeLevel = 2 : maximize without title bar and task bar
ToggleMaximize(maximizeLevel = 0) {
	WinGet, WID, ID, A
		WinGet, isMaximize, MinMax, ahk_id %WID%
		WinGet, myStyle, Style, ahk_id %WID%
		if (isMaximize == 1 && (maximizeLevel == 0 || myStyle & 0x00C40000 == 0)) {
			WinRestore, ahk_id %WID%
				if (maximizeLevel) {
					WinSet, Style, +0x00C40000, ahk_id %WID%
				}
		}
		else
		{
			WinMaximize, ahk_id %WID%
				if (maximizeLevel) {
					WinSet, Style, -0x00C40000, ahk_id %WID%

						if (maximizeLevel == 1) {
							; maximize without title bar
								SysGet, New, MonitorWorkArea
								WinMove, ahk_id %WID%, , 0, 0, %NewRight%, %NewBottom%
						} else {
							; maximize without title bar and task bar
								WinMove, ahk_id %WID%, , 0, 0, %A_ScreenWidth%, %A_ScreenHeight%
						}
				}
		}
}
; ----------------------------------------------------------------------------
; TsenseClock
; ----------------------------------------------------------------------------
TsenseClockLoop:
FormatTime, now_time, , yy/MM/dd ddd HH:mm:ss
WinGet, WID, ID, A
WinGetPos, X, Y, W, H, ahk_id %WID%
if (X >= 0) {
	X = +%X%
}
if (Y >= 0) {
	Y = +%Y%
}
WinGetTitle, now_active_window, ahk_id %WID%
GuiControl, , NowTime, %now_time% | (%W%x%H%%X%%Y%) %now_active_window%
return

TsenseClockStop:
SetTimer, TsenseClockStop, Off
Gui, Hide
return


/* TheGood
Wrapper to catch Power Management events

;http://msdn.microsoft.com/en-us/library/aa373162(VS.85).aspx
;SUPPORTED ONLY BY WINDOWS 2000 AND UP
WM_POWERBROADCAST           := 536          ;Notifies applications that a power-management event has occurred.
PBT_APMQUERYSUSPEND         := 0            ;Requests permission to suspend the computer. An application
                                            ;that grants permission should carry out preparations for the
                                            ;suspension before returning.
BROADCAST_QUERY_DENY        := 1112363332   ;Return this value to deny the request.
PBT_APMQUERYSUSPENDFAILED   := 2            ;Notifies applications that permission to suspend the computer
                                            ;was denied. This event is broadcast if any application or
                                            ;driver returned BROADCAST_QUERY_DENY to a previous
                                            ;PBT_APMQUERYSUSPEND event.
PBT_APMSUSPEND              := 4            ;Notifies applications that the computer is about to enter a
                                            ;suspended state. This event is typically broadcast when all
                                            ;applications and installable drivers have returned TRUE to a
                                            ;previous PBT_APMQUERYSUSPEND event.
PBT_APMRESUMECRITICAL       := 6            ;Notifies applications that the system has resumed operation.
                                            ;This event can indicate that some or all applications did not
                                            ;receive a PBT_APMSUSPEND event. For example, this event can be
                                            ;broadcast after a critical suspension caused by a failing
                                            ;battery.
PBT_APMRESUMESUSPEND        := 7            ;Notifies applications that the system has resumed operation
                                            ;after being suspended.
PBT_APMBATTERYLOW           := 9            ;Notifies applications that the battery power is low.
PBT_APMPOWERSTATUSCHANGE    := 10           ;Notifies applications of a change in the power status of the
                                            ;computer, such as a switch from battery power to A/C. The
                                            ;system also broadcasts this event when remaining battery power
                                            ;slips below the threshold specified by the user or if the
                                            ;battery power changes by a specified percentage.
PBT_APMOEMEVENT             := 11           ;Notifies applications that the APM BIOS has signaled an APM
                                            ;OEM event.
PBT_APMRESUMEAUTOMATIC      := 18           ;Notifies applications that the computer has woken up
                                            ;automatically to handle an event. An application will not
                                            ;generally respond unless it is handling the event, because
                                            ;the user is not present.
*/

OnMessage(536, "OnPBMsg")     ;WM_POWERBROADCAST
Return

OnPBMsg(wParam, lParam, msg, hwnd) {
outputdebug message %wParam% , %lParam%
	If (wParam = 0) {	;PBT_APMQUERYSUSPEND
		If (lParam & 1)	;Check action flag
			MsgBox The computer is trying to suspend, and user interaction is permitted.
		Else MsgBox The computer is trying to suspend, and no user interaction is allowed.
		;Return TRUE to grant the request, or BROADCAST_QUERY_DENY to deny it.
	} Else If (wParam = 2)	;PBT_APMQUERYSUSPENDFAILED
		MsgBox The computer tried to suspend, but failed.
	Else If (wParam = 4)	;PBT_APMSUSPEND
		MsgBox The computer is about to enter a suspended state.
	Else If (wParam = 6)	;PBT_APMRESUMECRITICAL
		MsgBox The computer is now resuming from a suspended state, which may have taken place unexpectedly.
	Else If (wParam = 7)	;PBT_APMRESUMESUSPEND
		MsgBox The computer is now resuming from a suspended state.
	Else If (wParam = 9)	;PBT_APMBATTERYLOW
		MsgBox The computer battery is running low.
	Else If (wParam = 10)	;PBT_APMPOWERSTATUSCHANGE
		MsgBox The computer power status has changed.
	Else If (wParam = 11)	;PBT_APMOEMEVENT
		MsgBox The APM BIOS has signaled an APM OEM event with event code %lParam%
	Else If (wParam = 18)	;PBT_APMRESUMEAUTOMATIC
		MsgBox The computer is now automatically resuming from a suspended state.
	
	;Must return True after message is processed
	Return True
}
