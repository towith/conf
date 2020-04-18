rem not work:  git update-index  --skip-worktree persist/totalcmd/Wincmd.ini persist/totalcmd/User.ini persist/ditto/Ditto.Settings  persist/ditto_cmd/Ditto.Settings persist/ahk/test.ahk persist/ahk/configvar.ahk
rem not work:  git update-index --assume-unchanged persist/totalcmd/Wincmd.ini


set targets=persist/totalcmd/Wincmd.ini persist/totalcmd/User.ini persist/ditto/Ditto.Settings  persist/ditto_cmd/Ditto.Settings persist/ditto_cmd/command.db 
git update-index  --skip-worktree %targets%
git update-index --assume-unchanged  %targets%