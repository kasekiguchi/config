; ↑
PrintScreen & i::Send, {Blind}{Up}

; ↓
PrintScreen & k::Send, {Blind}{Down}

; ←
PrintScreen & j::Send, {Blind}{Left}

; →
PrintScreen & l::Send, {Blind}{Right}

; Home
PrintScreen & h::Send, {Blind}{Home}

; End
PrintScreen & vkBB::Send, {Blind}{End}

; ↑↑↑↑
PrintScreen & u::Send, {Blind}{Up 4}

; ↓↓↓↓
PrintScreen & ,::Send, {Blind}{Down 4}

; →→→→
PrintScreen & .::Send, {Blind}{Right 4}

; ←←←←
PrintScreen & m::Send, {Blind}{Left 4}

; Enter
PrintScreen & Space::Send, {Blind}{Enter}

; Backspace
PrintScreen & n::Send, {Blind}{Backspace}

; Delete
PrintScreen & /::Send,{Blind}{Delete}

; 行挿入
PrintScreen & Enter::
If (GetKeyState("Ctrl", "P")) {
  Send, {Up}{End}{Enter}
} Else {
  Send, {End}{Enter}
}
Return

; 半角英数
PrintScreen & vkF2::Send, {vkF2}{vkF3}

; 矢印入力
PrintScreen & Up::Send, {vkF2}{vkF3}↑{vkF2}
PrintScreen & Down::Send, {vkF2}{vkF3}↓{vkF2}
PrintScreen & Left::Send, {vkF2}{vkF3}←{vkF2}
PrintScreen & Right::Send, {vkF2}{vkF3}→{vkF2}
