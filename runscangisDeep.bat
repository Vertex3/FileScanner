gis_scanner.py T:\ .shp,.gdb,.mxd contents
xsltgen.exe out\results.xml ShowResults.xsl out\resultsGIS.htm
xsltgen.exe out\results.xml ShowLargestFiles.xsl out\resultsLargestFiles.htm
xsltgen.exe out\results.xml ShowFileCountByRootdir.xsl out\resultsFilesByRootdir.htm
xcopy out outCAppsDeep /I /Y /S