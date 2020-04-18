$spath='D:\Applications\z_disk\conf\persist\powershell\'

if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadLine
}

Set-PSReadLineOption -EditMode Emacs

Set-PSReadLineOption -Colors @{
  Command            = 'Yellow'
  Number             = 'DarkGreen'
  Member             = 'DarkGreen'
  Operator           = 'DarkBlue'
  Type               = 'DarkGreen'
  Variable           = 'DarkBlue'
  Parameter          = 'DarkBlue'
  ContinuationPrompt = 'DarkGreen'
  Default            = 'Black'
}


function prompt {
  $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
  $principal = [Security.Principal.WindowsPrincipal] $identity
  $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

 $promptString=$(if (Test-Path variable:/PSDebugContext) { '[DBG]' }
    elseif($principal.IsInRole($adminRole)) { "#" }
    else { '' }
  ) + ' ' + $(Get-Location) +    ('>' * ($NestedPromptLevel+1))
    
    $color = Get-Random -Min 7 -Max 16
     Write-Host -NoNewLine  -ForegroundColor $Color  $promptString 
     return " "
}


Set-PSReadLineKeyHandler -Chord Ctrl+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+RightArrow -Function NextWord
Set-PSReadLineKeyHandler -Chord Ctrl+v -Function Paste
& "D:\Applications\Scoop\apps\docker\current\docker-machine.exe" env | Invoke-Expression
foreach ( $includeFile in ( "unix", "whois","handle") ) {
	Unblock-File $spath\$includeFile.ps1
    .  "$spath\$includeFile.ps1"
}

Function ll{
   Invoke-Expression (Get-History)[-1].commandline
}

Function sup{
   sudo powershell
}


function Show-Colors( ) {
  $colors = [Enum]::GetValues( [ConsoleColor] )
  $max = ($colors | foreach { "$_ ".Length } | Measure-Object -Maximum).Maximum
  foreach( $color in $colors ) {
    Write-Host (" {0,2} {1,$max} " -f [int]$color,$color) -NoNewline
    Write-Host "$color" -Foreground $color
  }
}

function libadb(){
  adb connect "192.168.64.${args}:5555"
}