# ==== scoop/lib/insall.ps1 ====
# ==== dl_with_cache_aria2 ====
        # Invoke-Expression $aria2 | ForEach-Object {
        #     if([String]::IsNullOrWhiteSpace($_)) {
        #         # skip blank lines
        #         return
        #     }
        #     Write-Host $prefix -NoNewline
        #     if($_.StartsWith('(OK):')) {
        #         Write-Host $_ -f Green
        #     } elseif($_.StartsWith('[') -and $_.EndsWith(']')) {
        #         Write-Host $_ -f Cyan
        #     } else {
        #         Write-Host $_ -f Gray
        #     }
        # }
        Get-Content -Path $urlstxt -OutVariable xx
        $u=$xx[0]
        $p=$xx[2].Split("=")[1]
        $f=$xx[3].Split("=")[1]

        $cc="& 'C:\Program Files (x86)\Internet Download Manager\IDMan.exe' /d $u /p $p /f $f /q /n /s "
        write-host $cc
        Invoke-Expression $cc
      
        $wait="& autohotkey.exe D:\Applications\z_disk\conf\persist\z_manual\idman\wait.ahk $f"
        Invoke-Expression $wait
