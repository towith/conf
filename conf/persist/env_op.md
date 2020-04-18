# Op tools
```
$env:SCOOP='D:\Applications\Scoop'
[environment]::setEnvironmentVariable('SCOOP_GLOBAL','D:\GlobalScoopApps','Machine')
$env:SCOOP_GLOBAL='D:\GlobalScoopApps'
set-executionpolicy remotesigned -s cu ; iex (new-object net.webclient).downloadstring('https://get.scoop.sh')

# scoop install aria2
scoop config aria.enabled true
## config idman download from manual

scoop install  git 
scoop bucket known
scoop bucket add extras ...
scoop install  autohotkey everything ditto psutils 
    > import task
```

# Dev tools
```
scoop install IntelliJ-IDEA-Ultimate vscode 
    > idea  set setting repo, restart , choose scheme
       plugin: plugin import/export
     notepad C:/Windows/System32/drivers/etc/hosts
       
       0.0.0.0        account.jetbrains.com
       0.0.0.0        www.jetbrains.com

    > vscode    plugins: settings sync
    GitHub Token
    GitHub Gist 76baee058a72bf85138369ac3b983223

scoop install oraclejdk maven  nodejs yarn python27 python android-sdk
scoop install virtualbox docker fiddler
scoop reset python27
```

# Useful
```
vivaldi zotero 
    > sync settings
```
### `docker-machine change mirror`
```
docker-machine ssh default
sudo sed -i "s|EXTRA_ARGS='|EXTRA_ARGS='--registry-mirror=http://d7e77b19.m.daocloud.io |g" /var/lib/boot2docker/profile
exit
docker-machine restart default
```

# For mobile
### android-sdk
```
sdkmanager --list
... sdkmanager add dependencies
```

### android avd
```
avdmanager.bat create avd -d 17 -n "avdny" -k system-images;android-Q;google_apis_playstore;x86_64
sc query intelhaxm
> chanage %userprofile%/.android/avd/(xx)/config.ini
    hw.keyboard=yes
emulator @android28
```

### flutter
```
scoop install flutter
```
### react native
```
yarn global add react-native-cli
```

# For cloud
### kube
```
scoop install minikube
scoop install kubectl
>   set cc proxy
    set http_proxy=xxx;
    set https_proxy=xxx; 
    minikube start --vm-driver="kvm" --docker-env="http_proxy=xxx" --docker-env="https_proxy=yyy" --docker-env no_proxy=no_proxy=localhost,127.0.0.1,[minikube_ip] start
```
# Env Def
## Hosts
```
127.0.0.1		 dev.bov.org
```


# Optional
#### choco
```
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install -y flashplayerppapi
```
#### viper4windows  
>  http://vipersaudio.com/blog/?page_id=48

<!-- $p="$env:ProgramFiles\Git\cmd" -->
<!-- [environment]::setEnvironmentVariable('PATH',"$env:PATH;$p",'Machine') -->
<!-- [environment]::setEnvironmentVariable('choco_install_dir',"d:\ChocoAppDir",'Machine') -->

<!-- scoop install miniconda3 -->
<!-- conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/free/   -->
<!-- conda config --set show_channel_urls yes   -->
<!-- conda create --name py2 python=2.7 -->
<!-- conda activate py2 -->


#### deprecated
```
   >  notepad D:\Applications\Scoop\apps\clink\current\clink.bat
          @for %%i in (cat,touch,zcat,ls,rm,cp,mv,grep,less,vi,vim,nc) do @doskey %%i=bash -c "%%i $*"
   > clink autorun --allusers install

```
