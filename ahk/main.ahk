#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Forse
; 以下　alt-ime-ahkより

; Razer Synapseなど、キーカスタマイズ系のツールを併用しているときのエラー対策
#MaxHotkeysPerInterval 350

; 主要なキーを HotKey に設定し、何もせずパススルーする
*~a::
*~b::
*~c::
*~d::
*~e::
*~f::
*~g::
*~h::
*~i::
*~j::
*~k::
*~l::
*~m::
*~n::
*~o::
*~p::
*~q::
*~r::
*~s::
*~t::
*~u::
*~v::
*~w::
*~x::
*~y::
*~z::
*~1::
*~2::
*~3::
*~4::
*~5::
*~6::
*~7::
*~8::
*~9::
*~0::
*~F1::
*~F2::
*~F3::
*~F4::
*~F5::
*~F6::
*~F7::
*~F8::
*~F9::
*~F10::
*~F11::
*~F12::
*~`::
*~~::
*~!::
*~@::
*~#::
*~$::
*~%::
*~^::
*~&::
*~*::
*~(::
*~)::
*~-::
*~_::
*~=::
*~+::
*~[::
*~{::
*~]::
*~}::
*~\::
*~|::
*~;::
*~'::
*~"::
*~,::
*~<::
*~.::
*~>::
*~/::
*~?::
*~Esc::
*~Tab::
*~Space::
*~Left::
*~Right::
*~Up::
*~Down::
*~Enter::
*~PrintScreen::
*~Delete::
*~Home::
*~End::
*~PgUp::
*~PgDn::
    Return

; 上部メニューがアクティブになるのを抑制
*~LAlt::Send {Blind}{vk07}
*~RAlt::Send {Blind}{vk07}
;*~LAlt::Send {Blind}{vkA4}
;*~RAlt::Send {Blind}{vkA4}


; CapsLock
; Requires AutoHotkey v1.1.26+, and the keyboard hook must be installed.
; #InstallKeybdHook
; SendSuppressedKeyUp(key) {
;     DllCall("keybd_event"
;         , "char", GetKeyVK(key)
;         , "char", GetKeySC(key)
;         , "uint", KEYEVENTF_KEYUP := 0x2
;         , "uptr", KEY_BLOCK_THIS := 0xFFC3D450)
; }
; ;; Disable Alt+key shortcuts for the IME.
; ;~LAlt::SendSuppressedKeyUp("LAlt")

; ; Test hotkey:
; !CapsLock::MsgBox % A_ThisHotkey
; SetStoreCapsLockMode False
; ; Remap CapsLock to LCtrl in a way compatible with IME.
; CapsLock::
;     Send {Blind}{LCtrl}
;    ; Send SuppressedKeyUp("LCtrl")
;     return
; CapsLock up::
;     Send {Blind}{LCtrl Up}
;     return
*sc03A:: Send {sc01D}
; & a::Send {Home}
;vkf0:: Send <^
;vk14::Send {Blind}{vkA2}
;vkA2vk14::Send {Home}
;vkFC{a}::Send {Home}
;#Include C:/Users/sekiguchi/Documents/GitHub/alt-ime-ahk/alt-ime-ahk.ahk
#Include C:/Users/sekiguchi/Documents/GitHub/config/ahk/my-launcher.ahk
#Include C:/Users/sekiguchi/Documents/GitHub/config/ahk/my-keybind.ahk

