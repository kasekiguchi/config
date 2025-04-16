#Requires AutoHotkey v2.0

;; RAltボタン無効
;vkA5:: return
; RAlt を修飾キーとしたリマップ
#HotIf GetKeyState("vkA5", "P")

h::Left
j::Down
k::Up
l::Right

y::Home
o::End
i::PgUp
u::PgDn

m::Enter
':: Send("\")
#HotIf