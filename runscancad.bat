gis_scanner.py C:\ .dwg files
xsltgen.exe out\results.xml ShowResults.xsl out\results.htm
xsltgen.exe out\results.xml ShowLargestFiles.xsl out\resultsLargestFiles.htm
xsltgen.exe out\results.xml ShowFileCountByRootdir.xsl out\resultsFilesByRootdir.htm
xcopy out outcad /I /Y /S