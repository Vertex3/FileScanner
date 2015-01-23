gis_scanner.py T:\ .shp,.gdb,.mxd,.sde contents
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
xsltgen.exe out\results.xml ShowResultsExcel.xsl out\resultsGIS.xls
xsltgen.exe out\results.xml ShowLargestFilesExcel.xsl out\resultsLargestFiles.xls
xsltgen.exe out\results.xml ShowFileCountByRootdirExcel.xsl out\resultsFilesByRootdir.xls
xcopy out outgisDeep /I /Y /S