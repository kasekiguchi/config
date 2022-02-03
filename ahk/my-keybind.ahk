#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ^ Ctrl
; ! Alt
; # Windows
; + Shift

;; {{{ functions for keybind : thanks to emacs-ahk
kill_line()
{
    global
    Send +{End}
    Send ^x
}

plain_text_yank()
{
    ; Convert any copied files, HTML, or other formatted text to plain text
    Clipboard = %Clipboard%

    ; Paste by pressing Ctrl+V
    SendInput ^v
}

move_tab(dir)
{
    if (dir >= 1){ ; 左へ移動
    if (WinActive("ahk_class Chrome_WidgetWin_1") or WinActive("ahk_class SunAwtFrame") or WinActive("ahk_class XLMAIN")) { ; VSCode, MATLAB, Excel
        Send ^{PgUp}
    }
    else {
        Send ^+{Tab}
    }
    }
    else{ ; 右へ移動
            if (WinActive("ahk_class Chrome_WidgetWin_1") or WinActive("ahk_class SunAwtFrame") or WinActive("ahk_class XLMAIN")) { ; VSCode, MATLAB, Excel
        Send ^{PgDn}
    }
    else {
        Send ^{Tab}
    }
    }
    Return
}
;; }}}

;; {{{ special character : from upper to bottom of the keyboard
<^\:: ; MATLAB,VSCode : toggle side bar
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
;; for Excel, Spreadsheet and MATLAB
<^Enter::
    if (WinActive("ahk_exe MATLAB.exe")) { ; MATLAB : 実行
            Send {CtrlDown}{Enter}{CtrlUp}
    }
    else {
            if (WinActive("ahk_class XLMAIN")) { ; Microsoft Excel : セル編集
                    Send {F2}
            }
            else {
                if (WinActive("ahk_exe chrome.exe")){ ; Spreadsheet : セル編集
                    Send {Enter}
                }else{
                    ;Send {CtrlDown}{Enter}{CtrlUp}
                    Send ^+m
                }
            }
    }
    return
!+<:: ; goto beginning of file
    Send ^{Home}
    Return
!+>:: ; goto end of file
    Send ^{End}
    Return
!^Left:: ; タブ移動
    move_tab(1)
    Return
!^Right:: ; タブ移動
    move_tab(0)
    Return
!^h:: ; タブ移動
    move_tab(1)
    Return
!^l:: ; タブ移動
    move_tab(0)
    Return
;; }}}

;; {{{ alphabet
!a:: ; select whole buffer
    Send ^a
    Return
^a:: ; goto beginning of line
    Send {Home}
    Return
!c:: ; copy
    Send ^c
    Return
^d:: ; delete char
    Send {Del}
    Return
^e:: ; goto end of line
    Send {End}
    Return
^g:: ; keyboard quit
    Send {Esc}
    Return
^k:: ; kill line
    kill_line()
    Return
^n:: ; next line
    Send {Down}
    Return
<^q:: ; scroll down
    Send {Down}
    Return
!q:: ; close window
    Send !{F4}
    Return
!r:: ; reload
    Send {F5} ; for chrome reload
    Return
!s:: ; save
    Send ^s
    Return 
;^s:: ; search 
;    Send ^f
;    Return
!t:: ; new tab
    Send ^t
    Return
!v:: ; paste
    Send ^v
    Return
!+v:: ; paste
    plain_text_yank()
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
^y:: ; paste
    Send ^v
    Return
!y:: ; paste
    Send ^v
    Return
<^z:: ; scroll up
    Send {Up}
    Return
!z:: ; undo
    Send ^z
    Return
!+z:: ; redo
    Send ^+z
    Return

;; }}}

; ^ Ctrl
; ! Alt
; # Windows
; + Shift
