; v2 対応版
; thanks to chatgpt and
; https://github.com/ryobeam/alt-ime-ahk-v2f/blob/master/IMEv2.ahk

SendMode("Input")
SetWorkingDir(A_ScriptDir)
;SetTitleMatchMode("2")
;SetKeyDelay("", 10)

; 変数の初期化
#Include Variables2.ahk

; メニューアイコン設定
; MenuSetIcon("Tray", "icon.ico")

; search_plugins() {
;   ; Plugins2フォルダ内のAHKスクリプト名を整形して plugin_files に格納
;   plugin_files := ""
;   for file in FileOpenDir(A_ScriptDir "\Plugins2") {
;     plugin_files .= "#Include " . file.FullPath . "`n"
;   }
;   if (plugin_files == "") {
;     return false
;   }

;   ; Plugins の変更点を認識
;   try {
;     file := FileOpen(A_ScriptDir "\PluginList2.ahk", "r", "UTF-8")
;     plugin_list_old := file.Read()
;     file.Close()
;     if (plugin_list_old == plugin_files) {
;       return false
;     }
;   } catch {
;     MsgBox("エラー: プラグインリストの読み込み中に問題が発生しました。")
;   }

;   ; plugin_list_oldをplugin_filesに書き換える
;   try {
;     file := FileOpen(A_ScriptDir "\PluginList2.ahk", "w", "UTF-8")
;     file.Write(plugin_files)
;     file.Close()
;   } catch {
;     MsgBox("エラー: プラグインリストの書き込み中に問題が発生しました。")
;     return false
;   }

;   return true
; }
; ファイルが存在しない場合は無視

; 練習用キー無効化
; hotkeys_define(keys_practice, "keys_practice", true)
; keys_practice() {
;   static count := 0
;   count++
;   if (count > 1) {
;     my_tooltip_function("そのキーは禁止です(" . count - 1 . "回目)", 1000)
;   }
; }

#Include PluginList2.ahk

; 共通サブルーチン
my_tooltip_function(str, delay) {
  ToolTip(str)
  SetTimer(() => ToolTip(), -delay)
}

; remove_tooltip_all() {
;   for i, _ in Range(1, 20) {
;     ToolTip("", "", "", i)
;   }
; }

get_current_dir() {
  explorerHwnd := WinActive("ahk_class CabinetWClass")
  if (explorerHwnd) {
    shell := ComObject("Shell.Application")
    for window in shell.Windows {
      if (window.hwnd == explorerHwnd) {
        return window.Document.Folder.Self.Path
      }
    }
  }
  return ""
}

hotkeys_define(keys, label, onOff) {
  for key in StrSplit(keys, ",", "`n") {
    Hotkey(key, label, onOff)
  }
}

rm_crlf(str) {
  str := StrReplace(str, "`n")
  str := StrReplace(str, "`r")
  return str
}
