$title=$args[0]
$content=$args[1]
$quickText=$args[2]
if($title -eq $null){
   throw  "Need a param:title,content,quicktext"
}
if($content -eq $null){
  $content=$title
}
$target="D:\Applications\Portable\ditto_cmd\command.i.db"
$path="N:\ditto_cmd\"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path  | Out-Null
}
$f=Get-Date -Format 'yyyyMMddHHmmss'
$p="${path}$f"
$insertMainSql="insert into Main(mText , lParentID, bIsGroup,QuickPasteText) values ('$title',15,0,'$quickText');select last_insert_rowid()"
$rowId=sqlite3.exe $target $insertMainSql
$content | out-file -encoding unicode -NoNewline -FilePath  $p
$unicode=xxd.exe -p -c 1000000000 $p
$unicode=$unicode.subString(4) + "0000"
$insertDataSql="insert  into Data(lParentID, strClipBoardFormat, ooData) values ($rowId,'CF_UNICODETEXT', X'$unicode')"
write-host $insertMainSql ; $insertDataSql
sqlite3.exe $target $insertDataSql 
Remove-Item -Path $p 

function Invoke-SQL {
    param(
        [string] $dataSource = ".\SQLEXPRESS",
        [string] $database = "MasterData",
        [string] $sqlCommand = $(throw "Please specify a query.")
      )
    $connectionString = "Data Source=$dataSource; " +
            "Integrated Security=SSPI; " +
            "Initial Catalog=$database"
    $connection = new-object system.data.SqlClient.SQLConnection($connectionString)
    $command = new-object system.data.sqlclient.sqlcommand($sqlCommand,$connection)
    $connection.Open()
    $adapter = New-Object System.Data.sqlclient.sqlDataAdapter $command
    $dataset = New-Object System.Data.DataSet
    $adapter.Fill($dataSet) | Out-Null
    $connection.Close()
    $dataSet.Tables
}
