; Copyright 2008 Michael Hoffman <mh391@cantab.net>

#Persistent
#SingleInstance force

OnExit, ExitSub
Return

ExitSub:
  if A_ExitReason in Logoff,Shutdown
  {
    Run %SystemDrive%\cygwin\bin\bash.exe --login -i killssh.sh
  }

  ExitApp
  Return
