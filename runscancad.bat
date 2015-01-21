gis_scanner.py T:\ .dwg files
xsltgen.exe out\results.xml ShowResultsExcel.xsl out\results.xls
xsltgen.exe out\results.xml ShowLargestFilesExcel.xsl out\resultsLargestFiles.xls
xsltgen.exe out\results.xml ShowFileCountByRootdirExcel.xsl out\resultsFilesByRootdir.xls
xcopy out outcad /I /Y /S