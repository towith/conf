try{
 while($true){
  pomodoro start  | out-null
  pomodoro status --wait
  pomodoro break 
 }
}
finally
{
 Write-Host Exitting...
# Get-CimInstance win32_process -Filter "Name like 'pomodoro.exe'" | ? { (Get-Process -id $_.ParentProcessId -ea Ignore) -eq $null } | Select-Object ProcessId | ? { Stop-Process $_.ProcessId -Force }
 pomodoro cancel
}
