mkdir D:\Applications\Portable\ditto_cmd
xcopy /S /E %scoop%\apps\ditto\current D:\Applications\Portable\ditto_cmd
del D:\Applications\Portable\ditto_cmd\Ditto.Settings
del D:\Applications\Portable\ditto_cmd\Ditto*.db
rd /s /q D:\Applications\Portable\ditto_cmd\Help
rd /s /q D:\Applications\Portable\ditto_cmd\DragFiles
rd /s /q D:\Applications\Portable\ditto_cmd\ClipCompare
rd /s /q D:\Applications\Portable\ditto_cmd\ReceivedFiles

move D:\Applications\Portable\ditto_cmd\Ditto.exe D:\Applications\Portable\ditto_cmd\Ditto_cmd.exe
shim D:\Applications\Portable\ditto_cmd\Ditto_cmd.exe