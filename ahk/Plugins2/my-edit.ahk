; ↑
!i::Send("{Up}")

; ↓
!k::Send("{Down}")

; ←
!j::Send("{Left}")

; →
!l::Send("{Right}")

; Home => Backspaceに変更
!h::Send("{Backspace}")

; End
!`;::Send("{End}")

; ↑↑↑↑
!o::Send("{Up 4}")

; ↓↓↓↓
!,::Send("{Down 4}")

; →→→→
!.::Send("{Right 4}")

; ←←←←
!m::Send("{Left 4}")

; Enter
!Space::Send("{Enter}")

; 行挿入
!+Enter:: {
  if (GetKeyState("Ctrl", "P")) {
    Send("{Up}{End}{Enter}")
  } else {
    Send("{End}{Enter}")
  }
}

; Excel改行
!Enter:: {
  Send("!{Enter}")
}

; 半角英数
!vkF2::Send("{vkF2}{vkF3}")

; 矢印入力
^Up::Send("{vkF2}{vkF3}↑{vkF2}")
^Down::Send("{vkF2}{vkF3}↓{vkF2}")
^Left::Send("{vkF2}{vkF3}←{vkF2}")
^Right::Send("{vkF2}{vkF3}→{vkF2}")