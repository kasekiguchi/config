#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


Launch(exe,path)
{
IfWinNotExist ahk_exe %exe%
Run, %path%
else
WinActivate, ahk_exe %exe%
return
}
Launch2(title,exe,path)
{
IfWinNotExist ahk_exe %exe%
Run, %path%
else
IfWinNotActive, %title%
WinActivate, %title%
return
}

;^!f::
;Launch("TE64.exe","C:\Users\sekiguchi\OneDrive - tcu.ac.jp\Setting\setup\te180101\TE64.exe")
;Launch("Clover.exe","C:\Program Files (x86)\Clover\Clover.exe")
;Launch("explorer.exe","C:\Windows\explorer.exe") ; QTTABBar 重すぎ
;Launch("HmFilerClassic.exe","C:\Program Files\HmFilerClassic\HmFilerClassic.exe")
;return

^!e::
;Launch("atom.exe","C:\Users\sekiguchi\AppData\Local\atom\atom.exe")
;Launch("Code.exe","C:\Program Files\Microsoft VS Code\Code.exe")
Launch("Code.exe","C:\Users\sekiguchi\AppData\Local\Programs\Microsoft VS Code\Code.exe")
return

^!s::
;Launch("chrome.exe","C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
Launch("chrome.exe","C:\Program Files\Google\Chrome\Application\chrome.exe")
;"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome")
return

;^!l::
;Launch("LINE.exe","C:\Users\sekiguchi\AppData\Local\LINE\bin\LineLauncher.exe")
;return

^!c::
;Launch("Franz.exe","C:\Users\sekiguchi\AppData\Local\Programs\franz\Franz.exe")
;"C:\Users\sekiguchi\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\eFounders\Station.exe"
;Launch("Station.exe","C:\Users\sekiguchi\AppData\Local\browserX\Station.exe")
Launch("Stack.exe","C:\Users\sekiguchi\AppData\Local\Programs\stack\Stack.exe")
return

^!p::
Launch("POWERPNT.exe","C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PowerPoint 2016.lnk")
return

;^!m::
;Launch("Mathematica.exe","C:\Program Files\Wolfram Research\Mathematica\11.0\Mathematica.exe")
;return

;^!k::
;Launch("ubuntu.exe","C:\Users\sekiguchi\AppData\Local\Microsoft\WindowsApps\ubuntu.exe")
;return
;^!k::
;Launch("bash.exe","C:\Users\sekiguchi\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Bash on Ubuntu on Windows")
;return

;Launch("ConEmu64.exe","C:\Program Files\ConEmu\ConEmu64.exe")
;C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_0.4.2382.0_x64__8wekyb3d8bbwe\WindowsTerminal.exe")
^!k::
Launch("WindowsTerminal.exe","C:\Users\sekiguchi\AppData\Local\Microsoft\WindowsApps\wt.exe")
return

^!+k::
;Run, "C:\Users\sekiguchi\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Bash on Ubuntu on Windows"
Run, "C:\Users\sekiguchi\AppData\Local\Microsoft\WindowsApps\ubuntu.exe"
return

^!x::
Launch2("MATLAB R2021a - academic use","matlab.exe","C:\Program Files\MATLAB\R2021a\bin\matlab.exe -softwareopenglmesa")
return


; ^ Ctrl
; ! Alt
; # Windows
; + Shift

