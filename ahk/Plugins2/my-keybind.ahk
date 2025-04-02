;#NoEnv ; 推奨: パフォーマンスと互換性の向上
; #Warn ; エラー検出のための警告を有効化
;SendMode("Input") ; 入力モードの設定
;SetWorkingDir(A_ScriptDir) ; 初期作業ディレクトリをスクリプトの場所に設定

; 関数群（Emacs風のキーバインド用）
kill_line() {
    Send("+{End}")
    Send("^x")
}

plain_text_yank() {
    A_Clipboard := A_Clipboard ; プレーンテキストに変換
    Send "^v"
}

move_tab(dir) {
    if dir >= 1 { ; 左へ移動
        if WinActive("ahk_exe chrome.exe") || WinActive("ahk_class Chrome_WidgetWin_1") || WinActive("ahk_class SunAwtFrame") || WinActive("ahk_class XLMAIN") {
            Send "^PgUp"
        } else {
            Send "^+Tab"
        }
    } else { ; 右へ移動
        if WinActive("ahk_class Chrome_WidgetWin_1") || WinActive("ahk_class SunAwtFrame") || WinActive("ahk_class XLMAIN") {
            Send "^PgDn"
        } else {
            Send "^Tab"
        }
    }
}

; 特殊文字関連のキーバインド
^:: {
    if (WinActive("ahk_class SunAwtFrame")) {
        Send("^+m")
    } else {
        Send("^b")
    }
}

^+[:: {
    if (WinActive("ahk_class SunAwtFrame")) {
        Send("^.")
    } else {
        Send("^+[")
    }
}

^+]:: {
    if (WinActive("ahk_class SunAwtFrame")) {
        Send("^+.")
    } else {
        Send("^+]")
    }
}

<^Enter:: {
    if (WinActive("ahk_exe MATLAB.exe")) {
        Send("^Enter")
    } else if (WinActive("ahk_class XLMAIN")) {
        Send("{F2}")
    } else if (WinActive("ahk_exe chrome.exe")) {
        Send("{Enter}")
    } else {
        Send("^+m")
    }
}

!+<::Send("^Home") ; ファイルの先頭へ移動
!+>::Send("^End")  ; ファイルの末尾へ移動

; タブ移動
!^Left::move_tab(1)
!^Right::move_tab(0)
!^j::move_tab(1)
!^l::move_tab(0)

; アルファベット関連のキーバインド
!a::Send("^a")
^a::Send("{Home}")
!c::Send("^c")
^d::Send("{Del}")
!d::Send("{Del}")
^e::Send("{End}")
^g::Send("{Esc}")
^k::kill_line()
^n::Send("{Down}")
<^q::Send("{Down}")
!q::Send("!F4")
!r::Send("{F5}") ; Chrome リロード
!t::Send("^t")
!v::Send("^v")
!+v::plain_text_yank()
!w:: {
    if (WinActive("ahk_class XLMAIN") || WinActive("ahk_class OpusApp")) {
        Send("!F4")
    } else {
        Send("^w")
    }
}
!x::Send("^x")
^y::Send("^v")
!y::Send("^v")
<^z::Send("{Up}")
!z::Send("^z")
!+z::Send("^+z")

; 拡大・縮小
!^=::Send("^+=")
!^-::Send("^-")

aux_reset() {
    if GetKeyState("Alt") {
        Send("{AltUp}")
    }
    if GetKeyState("Ctrl") {
        Send("{CtrlUp}")
    }
    if GetKeyState("Shift") {
        Send("{ShiftUp}")
    }
}