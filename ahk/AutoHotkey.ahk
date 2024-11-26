;#Persistent
;#SingleInstance, Force
;#NoEnv
#UseHook
InstallKeybdHook
InstallMouseHook
;HotkeyInterval(2000)
;MaxHotkeysPerInterval(200)
;Process(), Priority(), Realtime()
SendMode "Input"
SetWorkingDir A_ScriptDir
;SetTitleMatchMode, 2
; SetKeyDelay, , 10

; 変数の初期化
#Include "Variables.ahk"

; メニューアイコン設定
;Menu(Tray, Icon, icon.ico)

; プラグインの検出・取り込み
;If (search_plugins()) {
;  Reload
;}

search_plugins() {
  ; Pluginsフォルダ内のAHKスクリプト名を整形してplugin_filesに格納
  plugin_files := ""
  loop ("Plugins\*.ahk") {
    plugin_files .= "#" . "Include *i \Plugins\" . A_LoopFileName . "`n"
  }
  if (plugin_files = "") {
    return 0
  }
  ; Pluginsの変更点を認識
  file := FileOpen("\PluginList.ahk", "r `n", "utf-8")
  if (file) {
    plugin_list_old := file.Read(file.Length)
    file.Close
    if (plugin_list_old = plugin_files) {
      return 0
    }
  }
  ; plugin_list_oldをplugin_filesに書き換える
  file := FileOpen("\PluginList.ahk", "w `n", "utf-8")
  if (!file) {
    return 0
  }
  file.Write(plugin_files)
  file.Close
  return 1
}

; 練習用キー無効化
hotkeys_define(keys_practice, "keys_practice", "On")
keys_practice:
  count++
  if (count > 1)
    my_tooltip_function("そのキーは禁止です(" . count - 1 . "回目)", 1000)
  return

  ; (AutoExexuteここまで)

  #Include ".\PluginList.ahk"

  ; 共通サブルーチン
  ; ツールチップ
  my_tooltip_function(str, delay) {
    ToolTip(str)
    SetTimer remove_tooltip, -delay
  }

remove_tooltip:
  ToolTip
  return

remove_tooltip_all:
  SetTimer remove_tooltip, Off
  loop (20)
    ToolTip(, , , , A_Index)
  return

  ;カレントディレクトリ取得
  get_current_dir() {
    explorerHwnd := WinActive("ahk_class CabinetWClass")
    if (explorerHwnd) {
      for window in ComObjCreate("Shell.Application").Windows {
        if (window.hwnd == explorerHwnd)
          return window.Document.Folder.Self.Path
      }
    }
  }

  ; ループでホットキー定義
  hotkeys_define(keys, label, OnOff) {
    loop (PARSE, keys)
      Hotkey(A_LoopField, label, OnOff)
    return
  }

disable_keys:
  return

  ; 改行コード除去
  rm_crlf(str) {
    str := RegExReplace(str, "\n", "")
    str := RegExReplace(str, "\r", "")
    return str
  }
