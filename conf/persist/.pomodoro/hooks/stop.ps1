# pomodoro start -d 1 | out-null
autohotkey C:\Users\calflying\OneDrive\z_disk\conf\persist\ahk\DirectCall.ahk turnOnMonitor
nircmdc mediaplay 2000 "C:\Windows\Media\Windows Logon.wav"
nircmdc trayballoon  "Break over." "Keep work" "shell32.dll,146" 5000
exit 0
