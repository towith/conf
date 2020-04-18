Menu, Tray, Icon,shell32.dll,110,1

#SingleInstance, force 
#Persistent
SetTitleMatchMode, RegEx
 
global imeIgnore:=Array()
Suspend On
    
;; functions 
#Include, commvar.ahk
#Include, configvar.ahk
#Include, capsvar.ahk
#Include, lib/TrayIcon.ahk

;; worker
; #Include, messages.ahk
; #Include, messages-evt.ahk

;; bindings
#include, CapsKey.ahk
#include, KdeStyle.ahk

;; subs 
#Include, capsubs.ahk
#Include, commsub-tmp.ahk

!CapsLock::
+CapsLock::
^CapsLock::
#CapsLock::
CapsLock::
    Suspend Off
    Menu, Tray, Icon,shell32.dll,145
return
shift up::
alt up::
ctrl up::
lwin up::
CapsLock Up:: 
; MsgBox, %A_ThisHotkey%|%A_PriorHotkey%|%A_PriorKey%
    Suspend On
    Menu, Tray, Icon,shell32.dll,110,1
return
