TestCodeButtonOk:
	Gui, testCode:Submit 
	f:="D:\z_wd\appointment\test.fix.txt"
	FileDelete, %f%
	FileAppend, %TestCode2%,%f%
Return
