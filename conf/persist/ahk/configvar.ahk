;;; main task
v:="07"
global mainTaskMainWd:= ".md"
focusTermDir:="wlpost"

global actionsArr:=object()
; actionsArr.push("doTotalCmd")
; actionsArr.push("doMsVscode")
actionsArr.push("doBrowser")
; actionsArr.push("doIdea")
; actionsArr.push("doTDX")
actionsArr.push("doHelper")
; actionsArr.push("doWx")
; actionsArr.push("doFiddler")
; actionsArr.push("doFiles")
; actionsArr.push("doScrcpy")
global afterActionsArr=object()

;;;  doIdea 
global projectsArr:=Array()
; projectsArr.push("D:\z_wd\bov.stock\helper\")

runHit:=2
debugHist:=3
debugRebelHit:=6
FormatTime,weekDay,,ddd
if(weekDay=="Sat" || weekDay =="Sun"){
    ; global ws_projects:=
    ;     (Comments LTrim RTrim0 Join`s 
    ;     "
    ;     D:\z_wd\fl.wordlearn\wordlearn
    ;     "
    ;     )
}else{
    ; projectsArr.push("D:\z_wd\hy\tyhonor-mall")
    ; projectsArr.push("D:\z_wd\hy\km\km.code\")
}

;;; doTotalCmd
global :=true
global tc_lp:="D:\z_wd\hy\pj0405\"
global tc_rp:="\\"


;; doMsVscode

;; doFiddler

;; doFiles
global files:=Array()
; files.push("D:\z_wd\test\Merriam-Webster's+Vocabulary+Builder+-+Merriam-Webster.pdf")


;;;  doScrcpy
; global phone_t:="D6000"
; global phone_s:="eda13ccf"
global phone_t:="MI 5X"
; global phone_s:="192.168.43.1:5555"
global phone_s:="192.168.64.41:5555"


;;; setting process
/**    
global projects:=
    (Comments LTrim RTrim0 Join`s 
    "
    D:\z_wd\gradle
    ; D:\z_wd\giftapp
    "
    )
*/
global isAutostart:=false
global projects:=join(projectsArr)
global waitWins:=Array()
global performTasks:=Array()
performTasks.push("D:\z_my\envoc\commit.bat") 
performTasks.push(juncDir . "\conf4sync\conf\commit.bat")
performTasks.push(juncDir . "\notesync\notes\commit.bat")
global performTasksNoAsk:=Array()
performTasksNoAsk.push("D:\Applications\z_disk\conf\back.bat")

;; process var
afterActionsArr.push("minimizeAll")
