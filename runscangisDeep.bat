gis_scanner.py T:\ .shp,.gdb,.mxd contents
xsltgen.exe out\results.xml ShowResultsExcel.xsl out\resultsGIS.xls
xsltgen.exe out\results.xml ShowLargestFilesExcel.xsl out\resultsLargestFiles.xls
xsltgen.exe out\results.xml ShowFileCountByRootdirExcel.xsl out\resultsFilesByRootdir.xls
xcopy out outgisDeep /I /Y /S