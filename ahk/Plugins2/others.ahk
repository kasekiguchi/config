#If WinActive("ahk_exe ONENOTE.EXE") || WinActive("ahk_exe EXCEL.EXE")
  +r:: {
    if GetKeyState("vk1D", "P") {
      Send("{Ctrl Up}{Alt}hf1{Down 7}{Left 4}{Enter}")
    } else {
      Send("R")
    }
  }
  +b:: {
    if GetKeyState("vk1D", "P") {
      Send("{Ctrl Up}{Alt}hf1a")
    } else {
      Send("B")
    }
  }
  +g:: {
    if GetKeyState("vk1D", "P") {
      Send("{Ctrl Up}{Alt}hf1{Down 5}{Right 4}{Enter}")
    } else {
      Send("G")
    }
  }
#If

#If WinActive("ahk_exe ONENOTE.EXE")
  vk1D & i::ControlSend("OneNote::DocumentCanvas1", "{Blind}{Up}")
  vk1D & k::ControlSend("OneNote::DocumentCanvas1", "{Blind}{Down}")
  vk1D & 8::ControlSend("OneNote::DocumentCanvas1", "{Blind}{Up 4}")
  vk1D & ,::ControlSend("OneNote::DocumentCanvas1", "{Blind}{Down 4}")
#If