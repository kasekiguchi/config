; ↑
!i::Send {Up}

; ↓
!k::Send {Down}

; ←
!j::Send {Left}

; →
!l::Send, {Right}

; Home
;!h::Send, {Home} => backspace

; ; => End
!`;::Send, {End}

; ↑↑↑↑
!o::Send, {Up 4}

; ↓↓↓↓
!,::Send, {Down 4}

; →→→→
!.::Send, {Right 4}

; ←←←←
!m::Send, {Left 4}

; Enter
!Space::Send, {Enter}

; Backspace
!h::Send, {Backspace}

; Delete
;!/::Send,{Delete}

; 行挿入
!+Enter::
  If (GetKeyState("Ctrl", "P")) {
    Send, {Up}{End}{Enter}
  } Else {
    Send, {End}{Enter}
  }
Return

!Enter:: ; Excel 改行
  Send, !{Enter}
Return

; 半角英数
!vkF2::Send, {vkF2}{vkF3}

; 矢印入力
^Up::Send, {vkF2}{vkF3}↑{vkF2}
^Down::Send, {vkF2}{vkF3}↓{vkF2}
^Left::Send, {vkF2}{vkF3}←{vkF2}
^Right::Send, {vkF2}{vkF3}→{vkF2}


; ^ Ctrl
; ! Alt
; # Windows
; + Shift

