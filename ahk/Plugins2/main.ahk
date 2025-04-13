;; 英数キー無効
vkF0:: return

;; デスクトップフォルダを開く
; #e:: Run A_Desktop

;; 音量変更
AppsKey:: Send "{AppsKey}"

;; ボリュームを上げる
AppsKey & Up:: Send "{Volume_Up 1}"

;; ボリュームを下げる
AppsKey & Down:: Send "{Volume_Down 1}"

;; ミュート
AppsKey & Left:: Send "{Volume_Mute}"

;; 上書き保存したらツールチップ表示
!s:: {
    Send "^s"
    my_tooltip_function("上書き保存", 300)
}

;; タイムシフト録画したら保存フォルダを開く（コメントアウト）
;~!F10::Goto ^!F10

;; 録画の保存フォルダを開く（コメントアウト）
;^!F10::Run "D:\\Videos\\GeforceExperience"

;; Explorerでカレントディレクトリのパスを取得
^+!p:: {
    A_Clipboard := get_current_dir()
    my_tooltip_function("パスコピー", 300)
}

;; 日付入力
^vkBB:: {
    dateStr := FormatTime(, "yyyy-MM-dd")
    Send "{vkF2}{vkF3}" dateStr
}
