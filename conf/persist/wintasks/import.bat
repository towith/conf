schtasks.exe /Create /XML autohotkey.xml /tn my\autohotkey
schtasks.exe /Create /XML autohotkey-startup.xml /tn my\autohotkey-startup
schtasks.exe /Create /XML docker-machine.xml /tn my\docker-machine
schtasks.exe /Create /XML performTasks.xml /tn my\performTasks


rem run ... 
schtasks /run /tn my\autohotkey
rem schtasks /run /tn my\docker-machine 
