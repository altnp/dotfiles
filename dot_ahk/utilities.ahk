SetKeyDelay, -1

CapsLock::Escape
^#CapsLock::CapsLock

; Prevent system Alt+Escape behavior and send to active window
!Escape::
  SendInput !{Escape}
Return

;disable opening start menu with lwin key
~LWin::Send {Blind}{vkE8}

;Reload Autohotkey Script
#h::Reload

;toggle windows terminal
#`::SwitchToWindowsTerminal()

;toggle browser
#b::SwitchToBrowser()

;Paste buffer by typing it
^#v:: SendInput, %Clipboard%

SwitchToWindowsTerminal()
{
  windowHandleId := WinExist("ahk_exe WindowsTerminal.exe")
  windowExistsAlready := windowHandleId > 0

  ; If the Windows Terminal is already open, determine if we should put it in focus or minimize it.
  if (windowExistsAlready = true)
  {
    activeWindowHandleId := WinExist("A")
    windowIsAlreadyActive := activeWindowHandleId == windowHandleId

    if (windowIsAlreadyActive)
    {
      ; Minimize the window.
      WinMinimize, "ahk_id %windowHandleId%"
    }
    else
    {
      ; Put the window in focus.
      WinActivate, "ahk_id %windowHandleId%"
      WinShow, "ahk_id %windowHandleId%"
    }
  }
  ; Else it's not already open, so launch it.
  else
  {
    Run, wt
  }
}

SwitchToBrowser()
{
  windowHandleId := WinExist("ahk_exe chrome.exe")
  windowExistsAlready := windowHandleId > 0

  ; If the Windows Terminal is already open, determine if we should put it in focus or minimize it.
  if (windowExistsAlready = true)
  {
    activeWindowHandleId := WinExist("A")
    windowIsAlreadyActive := activeWindowHandleId == windowHandleId

    if (windowIsAlreadyActive)
    {
      ; Minimize the window.
      WinMinimize, "ahk_id %windowHandleId%"
    }
    else
    {
      ; Put the window in focus.
      WinActivate, "ahk_id %windowHandleId%"
      WinShow, "ahk_id %windowHandleId%"
      SendInput, !d
    }
  }
  ; Else it's not already open, so launch it.
  else
  {
    Run, chrome.exe
    SendInput, !d
  }
}
