;#NoEnv ; 推奨: パフォーマンスと互換性向上
; #Warn ; エラー検出のための警告を有効化
; SendMode("Input") ; 推奨設定
; SetWorkingDir(A_ScriptDir) ; 初期作業ディレクトリの設定

Launch(exe, path) {
    if !WinExist("ahk_exe " exe) {
        Run(path)
    } else {
        WinActivate("ahk_exe " exe)
    }
}

Launch2(title, exe, path) {
    if !WinExist("ahk_exe " exe) {
        Run(path)
    } else if !WinActive(title) {
        WinActivate(title)
    }
}

^!f:: {
    ; Launch("TE64.exe", "C:\Users\sekiguchi\OneDrive - tcu.ac.jp\Setting\setup\te180101\TE64.exe")
    ; Launch("Clover.exe", "C:\Program Files (x86)\Clover\Clover.exe")
    Launch("explorer.exe", "C:\Windows\explorer.exe") ; QTTABBar 重すぎ
    ; Launch("HmFilerClassic.exe", "C:\Program Files\HmFilerClassic\HmFilerClassic.exe")
}

^!e:: {
    ; Launch("atom.exe", "C:\Users\sekiguchi\AppData\Local\atom\atom.exe")
    ; Launch("Code.exe", "C:\Program Files\Microsoft VS Code\Code.exe")
    Launch("Code.exe", "C:\Users\kseki\AppData\Local\Programs\Microsoft VS Code\Code.exe")
}

^!s:: {
    ; Launch("chrome.exe", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
    Launch("chrome.exe", "C:\Program Files\Google\Chrome\Application\chrome.exe")
    ; "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome")
}

^!c:: {
    ; Launch("Franz.exe", "C:\Users\sekiguchi\AppData\Local\Programs\franz\Franz.exe")
    ; "C:\Users\sekiguchi\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\eFounders\Station.exe"
    ; Launch("Station.exe", "C:\Users\sekiguchi\AppData\Local\browserX\Station.exe")
    ; Launch("Stack.exe", "C:\Users\sekiguchi\AppData\Local\Programs\stack\Stack.exe")
    Launch("Slack.exe", "C:\Users\kseki\AppData\Local\Microsoft\WindowsApps\Slack.exe")
}

^!p:: {
    Launch("POWERPNT.exe", "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PowerPoint 2016.lnk")
}

^!k:: {
    Launch("WindowsTerminal.exe", "C:\Users\kseki\AppData\Local\Microsoft\WindowsApps\wt.exe")
}

^!+k:: {
    Run("C:\Users\kseki\AppData\Local\Microsoft\WindowsApps\ubuntu.exe")
}

^!x:: {
    Launch2("MATLAB R2024b - academic use", "matlab.exe",
        "C:\Program Files\MATLAB\R2024b\bin\matlab.exe -softwareopenglmesa")
}

; ^ Ctrl
; ! Alt
; # Windows
; + Shift
