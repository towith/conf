;date:2014-07-06
    ;��TC�滻��Դ���������ָ���Դ������
    ;��Ҫ����http://blog.xiazhiri.com/tags/totalcmd/�����£�
    ;�ָ���http://qing.blog.sina.com.cn/2002017477/77545cc533002ie4.html�����¼����Ҽ���explorer��
    ;����ο���http://blog.csdn.net/lord_is_layuping/article/details/7435989������
    RegRead, IsExp, HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\open\command, DelegateExecute
    OutputDebug,  % IsExp
    If(IsExp="{11dbb47c-a525-400b-9e80-a54615a090c0}")
    {
    RegDelete HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\open\command, DelegateExecute
    RegWrite, REG_EXPAND_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\open\command, , `"D:\Applications\Portable\totalcmd64\Totalcmd64.exe" `"`%1`"
    ; RegWrite, REG_EXPAND_SZ,HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\openwithExplorer, , OpenWithExplorer
    ;��һ���ƺ����п���
    ;RegWrite, REG_EXPAND_SZ,HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\openwithExplorer, MultiSelectModel, Document
    RegWrite, REG_EXPAND_SZ,HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\openwithExplorer\command, MultiSelectModel, Document
    RegWrite, REG_EXPAND_SZ,HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\openwithExplorer\command, , `"%SystemRoot%\explorer.exe`" `"`%1`"
    RegWrite, REG_EXPAND_SZ,HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\openwithExplorer\command, EelegateExecute, {11dbb47c-a525-400b-9e80-a54615a090c0}
;add
    RegDelete HKEY_LOCAL_MACHINE, SOFTWARE\Classes\*\shell\OpenWithCommanderParent
    RegDelete HKEY_LOCAL_MACHINE, SOFTWARE\Classes\*\shell\OpenWithCommander
    RegDelete HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\OpenWithCommanderParent
    RegDelete HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\OpenWithCommander
;end
    TrayTip,,�л�TotalCommaderΪĬ���ļ�������,2000
    Sleep ,1500
    }
    Else
    {

    RegWrite, REG_EXPAND_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\open\command, DelegateExecute, {11dbb47c-a525-400b-9e80-a54615a090c0}
    RegWrite, REG_EXPAND_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\open\command, , `%SystemRoot`%\Explorer.exe



    ; add


    RegWrite, REG_EXPAND_SZ,HKEY_LOCAL_MACHINE, SOFTWARE\Classes\*\shell\OpenWithCommander, , Open With TCommander(&1)
    RegWrite, REG_EXPAND_SZ,HKEY_LOCAL_MACHINE, SOFTWARE\Classes\*\shell\OpenWithCommander\command, MultiSelectModel, Document
    RegWrite, REG_EXPAND_SZ,HKEY_LOCAL_MACHINE, SOFTWARE\Classes\*\shell\OpenWithCommander\command, , `"D:\Applications\Portable\totalcmd64\Totalcmd64.exe" `"`%1`"
    RegWrite, REG_EXPAND_SZ,HKEY_LOCAL_MACHINE, SOFTWARE\Classes\*\shell\OpenWithCommander\command, EelegateExecute, {11dbb47c-a525-400b-9e80-a54615a090c0}

    RegWrite, REG_EXPAND_SZ,HKEY_LOCAL_MACHINE, SOFTWARE\Classes\*\shell\OpenWithCommanderParent, , Open With TCommander Dir(&2)
    RegWrite, REG_EXPAND_SZ,HKEY_LOCAL_MACHINE, SOFTWARE\Classes\*\shell\OpenWithCommanderParent\command, MultiSelectModel, Document
    RegWrite, REG_EXPAND_SZ,HKEY_LOCAL_MACHINE, SOFTWARE\Classes\*\shell\OpenWithCommanderParent\command, , `"D:\Applications\Portable\totalcmd64\Totalcmd64.exe" `"`%1/..`"
    RegWrite, REG_EXPAND_SZ,HKEY_LOCAL_MACHINE, SOFTWARE\Classes\*\shell\OpenWithCommanderParent\command, EelegateExecute, {11dbb47c-a525-400b-9e80-a54615a090c0}
    
     RegWrite, REG_EXPAND_SZ,HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\OpenWithCommander, , Open With TCommander(&1)
     RegWrite, REG_EXPAND_SZ,HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\OpenWithCommander\command, MultiSelectModel, Document
     RegWrite, REG_EXPAND_SZ,HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\OpenWithCommander\command, , `"D:\Applications\Portable\totalcmd64\Totalcmd64.exe" `"`%1`"
     RegWrite, REG_EXPAND_SZ,HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\OpenWithCommander\command, EelegateExecute, {11dbb47c-a525-400b-9e80-a54615a090c0}

     RegWrite, REG_EXPAND_SZ,HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\OpenWithCommanderParent, , Open With TCommander Dir(&2)
     RegWrite, REG_EXPAND_SZ,HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\OpenWithCommanderParent\command, MultiSelectModel, Document
     RegWrite, REG_EXPAND_SZ,HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\OpenWithCommanderParent\command, , `"D:\Applications\Portable\totalcmd64\Totalcmd64.exe" `"`%1/..`"
     RegWrite, REG_EXPAND_SZ,HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\OpenWithCommanderParent\command, EelegateExecute, {11dbb47c-a525-400b-9e80-a54615a090c0}


    ; end
    RegDelete HKEY_LOCAL_MACHINE, SOFTWARE\Classes\Folder\shell\openwithExplorer
    TrayTip,,�ָ�ExplorerΪĬ���ļ�������,2000
    Sleep ,1500
    }
