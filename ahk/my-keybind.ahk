#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ^ Ctrl
; ! Alt
; # Windows
; + Shift

;;;;;;;; keybindings ;;;;;;;;;;;
!#Left::
    if (WinActive("ahk_class Chrome_WidgetWin_1") or WinActive("ahk_class SunAwtFrame") or WinActive("ahk_class XLMAIN")) { ; VSCode, MATLAB, Excel
        Send ^{PgUp}
    }
    else {
        Send ^+{Tab}
    }
    Return
!#Right::
    if (WinActive("ahk_class Chrome_WidgetWin_1") or WinActive("ahk_class SunAwtFrame") or WinActive("ahk_class XLMAIN")) { ; VSCode, MATLAB, Excel
        Send ^{PgDn}
    }
    else {
        Send ^{Tab}
    }
    Return
;>!>^Left::
;    if (WinActive("ahk_class Chrome_WidgetWin_1") or WinActive("ahk_class SunAwtFrame") or WinActive("ahk_class XLMAIN")) { ; VSCode, Matlab, Excel
;        Send ^{PgUp}
;    }
;    else {
;        Send ^+{Tab}
;    }
;    Return
;>!>^Right::
;    if (WinActive("ahk_class Chrome_WidgetWin_1") or WinActive("ahk_class SunAwtFrame") or WinActive("ahk_class XLMAIN")) { ; VSCode, MATLAB, Excel
;        Send ^{PgDn}
;    }
;    else {
;        Send ^{Tab}
;    }
;    Return
>^Enter::
    Send ^+m
    Return        
<^\:: ; for vscode toggle side bar
    if (WinActive("ahk_class SunAwtFrame")) { ; Matlab
        Send ^+m
    }
    else {
        Send ^b
    }
    Return
^+[:: ; コード折りたたみ
    if (WinActive("ahk_class SunAwtFrame")) { ; Matlab
        Send ^.
    }
    else {
        Send ^+[
    }
    Return
^+]:: ; コード折りたたみ
    if (WinActive("ahk_class SunAwtFrame")) { ; Matlab
        Send ^+.
    }
    else {
        Send ^+]
    }
    Return
;{{{  =====  key bindings for alphabet
;<!a::
;    mark_whole_buffer()
;    Return
!c::
    Send ^c
    Return
<^q::
    Send {Down}
    Return
!q::
    Send !{F4}
    Return
!r::
    Send {F5} ; for chrome reload
    Return
!t::
    Send ^t ; for chrome new tab
    Return
!v::
    Send ^v ; paste
    Return
!w:: ; close tab
    if (WinActive("ahk_class XLMAIN") or WinActive("ahk_class OpusApp")) { ; Excel
        Send !{F4}
    }
    else {
        Send ^{F4}
    }
    Return
!x:: ; cut
    Send ^x
    Return
<^z:: ; scroll up
    Send {Up}
    Return
!z:: ; undo
    Send ^z
    Return

;}}}
!a::
    Send ^a
    Return
!s::
    Send ^s
    Return
^s::
    Send ^f
    Return
^g::
    Send {Esc}
    Return
^a::
    Send {Home}
    Return
^e::
    Send {End}
    Return
^d::
    Send {Del}
    Return
!+<::
    Send ^{Home}
    Return
!+>::
    Send ^{End}
    Return
^y::
    Send ^v
    Return
kill_line()
{
    global
    Send +{End}
    Send ^c{Del}
}
 
^k::
    kill_line()
    Return

;; for Excel and Chrome
<^Enter::
    if (WinActive("ahk_exe MATLAB.exe") or WinActive("ahk_exe chrome.exe")) {
            Send {CtrlDown}{Enter}{CtrlUp}
    }
    else {
            if (WinActive("ahk_class XLMAIN")) { ; Microsoft Excel
                    Send {F2}
            }
            else {
                    ;Send {CtrlDown}{Enter}{CtrlUp}
                    Send ^+m
            }
    }
    return


; ^ Ctrl
; ! Alt
; # Windows
; + Shift
