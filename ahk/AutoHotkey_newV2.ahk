;#Persistent
;#SingleInstance, Force
;#NoEnv
#UseHook
InstallKeybdHook()
InstallMouseHook()
A_HotkeyInterval := 2000
A_MaxHotkeysPerInterval := 200
ProcessSetPriority("Realtime")
SendMode("Input")
SetWorkingDir(A_ScriptDir)
;SetTitleMatchMode, 2
; SetKeyDelay, , 10

; 変数の初期化
#Include "%A_ScriptDir%\Variables.ahk"

; メニューアイコン設定
TraySetIcon("icon.ico")

; プラグインの検出・取り込み
;If (search_plugins()) {
;  Reload
;}

search_plugins() {
  ; Pluginsフォルダ内のAHKスクリプト名を整形してplugin_filesに格納
  plugin_files := ""
  loop files, A_ScriptDir "\Plugins\*.ahk" {
    plugin_files .= "#" . "Include *i %A_ScriptDir%\Plugins\" . A_LoopFileName . "`n"
  }
  if (plugin_files = "") {
    return
  }
  ; Pluginsの変更点を認識
  file := FileOpen(A_ScriptDir . "\PluginList.ahk", "r `n", "utf-8")
  if (file) {
    plugin_list_old := file.Read(file.Length)
    file.Close
    if (plugin_list_old == plugin_files) {
      return
    }
  }
  ; plugin_list_oldをplugin_filesに書き換える
  file := FileOpen(A_ScriptDir . "\PluginList.ahk", "w `n", "utf-8")
  if (!file) {
    return
  }
  file.Write(plugin_files)
  file.Close
  return
}

; 練習用キー無効化
count := 0
hotkeys_define(keys_practice, "keys_practice", "On")
keys_practice:
  count++
  if (count > 1)
    my_tooltip_function("そのキーは禁止です(" . count - 1 . "回目)", 1000)
  return

  ; (AutoExexuteここまで)

  #Include "%A_ScriptDir%\PluginList.ahk"

  ; 共通サブルーチン
  ; ツールチップ
  my_tooltip_function(str, delay) {
    ToolTip(str)
    SetTimer(remove_tooltip, -%delay%)
  }

  remove_tooltip() { ; V1toV2: Added bracket
    global ; V1toV2: Made function global
    ToolTip()
    return
  } ; V1toV2: Added Bracket before label

remove_tooltip_all:
  SetTimer(remove_tooltip, 0)
  loop 20
    ToolTip(, , , A_Index)
  return

  ;カレントディレクトリ取得
  get_current_dir() {
    explorerHwnd := WinActive("ahk_class CabinetWClass")
    if (explorerHwnd) {
      for window in ComObject("Shell.Application").Windows {
        if (window.hwnd == explorerHwnd)
          return window.Document.Folder.Self.Path
      }
    }
  }

  ; ループでホットキー定義
  hotkeys_define(keys, label, OnOff) {
    loop parse, keys, ","
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
