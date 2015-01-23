### settings.py - settings for the gis scanner functions
import os

rootfolder = os.path.dirname(os.path.realpath(__file__))
outfolder = os.path.join(rootfolder,'out')
if not os.path.exists(outfolder):
    os.mkdir(outfolder)

outfile = os.path.join(outfolder,'results.xml')
outhtmlfile = os.path.join(outfolder,'results.htm')

xsltjs = os.path.join(rootfolder,'runxslt.js')
xsl_filename = os.path.join(rootfolder,'ShowResults.xsl')

gisexts = '.shp,.gdb,.mxd,.sde' 
cadexts = '.dwg,.dgn'
exclude = 'Program Files,Windows,$Recycle.Bin'
oldMapSuffix = '_9.3.mxd'
timeout = 120 # timeout for accessing a gdb file