if /I "%1" EQU "" goto list_git_large_obj

bash -c ". list_git_large_obj.sh | grep %1"

:choice
set /P c=Are you sure you want to continue[Y/N]?
if /I "%c%" EQU "Y" goto :exec
if /I "%c%" EQU "N" goto :exit
goto :choice

:list_git_large_obj
bash -c ". list_git_large_obj.sh"
goto exit

:exec
bash -c ". list_git_large_obj.sh | grep %1 | awk '{print $1}' > id-file"
bfg -bi id-file
git gc --prune --aggressive & git prune

:exit



