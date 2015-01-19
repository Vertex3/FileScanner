gis_scanner.py C:\ .zip files
xsltgen.exe out\results.xml ShowResults.xsl out\resultsZip.htm
xsltgen.exe out\results.xml ShowLargestFiles.xsl out\resultsLargestFiles.htm
xsltgen.exe out\results.xml ShowFileCountByRootdir.xsl out\resultsFilesByRootdir.htm
xcopy out outZip /I /Y /S