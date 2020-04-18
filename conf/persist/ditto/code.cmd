@for /f "usebackq tokens=*" %%i in (`scoop which code`) do set out=%%i
%out% --diff %1 %2