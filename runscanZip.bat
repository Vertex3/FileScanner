gis_scanner.py T:\ .zip files
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
xsltgen.exe out\results.xml ShowResultsExcel.xsl out\resultsZip.xls
xsltgen.exe out\results.xml ShowLargestFilesExcel.xsl out\resultsLargestFiles.xls
xsltgen.exe out\results.xml ShowFileCountByRootdirExcel.xsl out\resultsFilesByRootdir.xls
xcopy out outZip /I /Y /S