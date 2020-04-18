##  ps2exe .\runDelegate.ps1 run.exe -noConsole
#$Host.UI.RawUI.FlushInputBuffer()
if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript")
{ 
 $ScriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition 
 $ScriptName = Split-Path -Leaf -Path $MyInvocation.MyCommand.Definition 
}
else
{ 
 $ScriptPath = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0]) 
 if (!$ScriptPath){ $ScriptPath = "." } 
 $ScriptName = Split-Path -Leaf -Path ([Environment]::GetCommandLineArgs()[0])
}
cd $ScriptPath


$t=$ScriptName.Split(".")[0]
Invoke-Expression (Get-Content -Raw "$t.ps1")

#$Host.UI.RawUI.FlushInputBuffer()
