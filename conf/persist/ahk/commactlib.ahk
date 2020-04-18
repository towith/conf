
runVivaldi(args:=""){
    ; if(!WinExist(tVivaldi)){
        app := RunWaitSilent("scoop which " . "vivaldi",,,true)
        StringReplace, app, app, `n , , All
        StringReplace, app, app, `r , , All
        appR := Trim(app)
        
        ; Run %appR% --profile-directory="default",,,pid
        Run %appR% %args%,,,pid
        WinWait %tVivaldi%,,5
    ; }
}
