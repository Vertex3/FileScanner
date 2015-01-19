gis_scanner.py C:\ .shp,.gdb,.mxd files
xsltgen.exe out\results.xml ShowResults.xsl out\resultsGIS.htm
xsltgen.exe out\results.xml ShowLargestFiles.xsl out\resultsLargestFiles.htm
xsltgen.exe out\results.xml ShowFileCountByRootdir.xsl out\resultsFilesByRootdir.htm
xcopy out outgis /I /Y /S