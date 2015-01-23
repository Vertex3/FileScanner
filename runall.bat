call runscangisDeep
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
call runscancad
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
call runscanzip
