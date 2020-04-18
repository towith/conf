@for /f "usebackq tokens=*" %%i in (`scoop which idea`) do set out=%%i
%out% diff %1 %2