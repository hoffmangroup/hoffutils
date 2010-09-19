; Copyright 2007 Michael Hoffman <mh391@cantab.net>

#SingleInstance force

;;; INIT

CustomColor = 000000  ; Can be any RGB color (it will be made transparent below).
X_Offset := -1024
Y_Offset := 0
Width := 1024 + 1280
Height := 1024

Gui, +AlwaysOnTop +LastFound +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, Color, %CustomColor%
Gui, Font, s36
RowLabels := "1234567890 QWERTYUIOP ASDFGHJKL; ZXCVBNM,./"
Loop, Parse, RowLabels, %A_Space%
{
  Y := (A_Index-1)*(Height/4)
  Loop, Parse, A_LoopField
  {
    X := (A_Index-1)*(Width/10)
    Gui, Add, Text, cNavy x%X% y%Y%, %A_LoopField%
  }
}

; Make all pixels of this color transparent and make the text itself translucent (150):
WinSet, TransColor, %CustomColor% 150
Gui, -Caption  ; Remove the title bar and window borders.

;; FUNCTIONS

WinMaximizeAt(X, Y) {
    WinExist("A")
    
    WinRestore
    WinMove, %X%, %Y%
    WinMaximize
}

WinActivateAt(X, Y) {
    CoordMode, Mouse, Screen
    MouseGetPos, save_xpos, save_ypos
    Loop {
      MouseMove, %X%, %Y%, 0
      MouseGetPos,,,WinID
      WinGetClass, WinClass, ahk_id %WinID%
      IfNotEqual, WinClass, Progman
      {
        WinActivate, ahk_id %WinID%
        Break        
      }
      X := X + 100
      Y := Y + 100
    }

    MouseMove, %save_xpos%, %save_ypos%, 0
  }
  
GetKeyCoord(ByRef X, ByRef Y) {
  global X_Offset, Y_Offset, Width, Height, RowLabels
  ; XXX: this flickers after the first time it is drawn
  ; XXX: one idea is to destroy and draw again immediately
  ; XXX: better to ask on forums though
  Gui, Show, x%X_Offset% y%Y_Offset% w%Width% h%Height% NoActivate
  
  Input, Key, L1, {Esc}{Space}{Enter}
  Loop, Parse, RowLabels, %A_Space%
  {
    Y := (A_Index-1)*(Height/4)+Y_Offset
    Loop, Parse, A_LoopField
    {
      IfEqual, A_LoopField, %Key%
      {
        X := (A_Index-1)*(Width/10)+X_Offset
        Gui, Hide
        Return
      }
    }
  }
  ;Gui, Hide
  Exit
}
  
;;; HOTKEYS

#+Left::
    WinMaximizeAt(-800, 200)
    return

#+Right::
    WinMaximizeAt(100, 200)
    return

#Left::
    WinActivateAt(-800, 200)
    return

#Right::
    WinActivateAt(100, 100)
    return
 
#a::
  GetKeyCoord(X, Y)
  WinActivateAt(X, Y)
  return
    
#v::
  GetKeyCoord(X, Y)
  WinExist("A")
  WinRestore
  WinMove, %X%, %Y%
  Return
  
#z::
  GetKeyCoord(X, Y)
  WinExist("A")

  WinGetPos, WinX, WinY
  
  W := X-WinX
  H := Y-WinY
  
  WinRestore
  WinMove,,,,,%W%,%H%
  
  Return

Pause:: Send {Escape}
^Pause:: Send ^{Escape}
^+Pause:: Send ^+{Escape}