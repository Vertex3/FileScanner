gis_scanner.py T:\ .dwg files
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
xsltgen.exe out\results.xml ShowResultsExcel.xsl out\results.xls
xsltgen.exe out\results.xml ShowLargestFilesExcel.xsl out\resultsLargestFiles.xls
xsltgen.exe out\results.xml ShowFileCountByRootdirExcel.xsl out\resultsFilesByRootdir.xls
xcopy out outcad /I /Y /S