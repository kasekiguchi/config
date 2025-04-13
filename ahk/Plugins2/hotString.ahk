;#Hotstring C O Z
; C: 大文字小文字を区別する
; O : 最後に終了文字を入力しない
; Z : 発動時点でキー入力のバッファをクリアする
; R : 特殊キーをそのまま入力する(個別設定)
; オプション設定（C=大文字小文字区別, O=末尾文字を無視, Z=末尾にあるときだけ）
;HotstringOptions("COZ")

; "::ttt" を入力すると "It's test." を入力する
Hotstring("::ttt", (*) => SendText("It's test."))

; "::192" を入力すると "192.168." を入力する
Hotstring("::192", (*) => SendText("192.168."))