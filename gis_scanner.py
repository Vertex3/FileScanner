# gis_scanner.py - scan folder(s) for gis data
 
import sys,time,fnmatch,os,settings, re, xml.dom.minidom, subprocess, datetime, traceback
from xml.dom.minidom import Document

log = open(sys.argv[0] + '.log', "w")
 
try:
    folders = sys.argv[1].lower()
except:
    folders = 'C:\\SG\\Projects\\CityOfBarrie'
folders = folders.split(',')
 
try:
    include = sys.argv[2].lower()
except:
    include = 'gis'
if include == '*' or include == '#':
    include = 'gis'

srch = []
if include.find('.') > -1: 
    srch = include.lower().split(',') # if there is a . then assume actual file extensions
else:
    for incstr in include.lower().split(','): # if not then assume gis and/or cad from settings.py
        strvals = eval('settings.'+ incstr + 'exts')
        vals = strvals.split(',')
        srch += vals
 
exc = settings.exclude.split(',')
 
try:
    mode = sys.argv[3].lower()
except:
    mode = 'files'
# other option is 'contents'
 
try:
    import arcpy # if arcpy not present then do files
except:
    mode = None
 
if mode not in ['files','contents']:
    mode = 'files' # default is 'files'
  
def main(argv = None):
    global log
    pprint( 'Searching ' + str(folders))
    matches = []
    xmlDoc = startXmlDocument()
    cleanupFolder(settings.outfolder)
    
    try:
        for folder in folders:
            for root, dirnames, filenames in os.walk(folder):
                exclude = False
                for item in exc:
                    if root.find(item) > -1:
                        exclude = True
                if exclude == False:
                    for dirname in dirnames:
                        extension = '.gdb'
                        if dirname.endswith(extension) and extension in srch:
                            matches.append(os.path.join(root, dirname))
                            gdb = os.path.join(root, dirname)
                            gdb = re.sub(r'[^\x00-\x7f]',' ',gdb)
                            pprint(gdb)
                            xmlDoc = writeFileInfo(xmlDoc,gdb,extension)
                           
                    for extension in srch:
                        for filename in fnmatch.filter(filenames, '*' + extension):       
                            matches.append(os.path.join(root, filename))
                            file = os.path.join(root, filename)
                            file = re.sub(r'[^\x00-\x7f]',' ',file)
                            pprint(file)
                            xmlDoc = writeFileInfo(xmlDoc,file,extension)
    except Exception, err:
        pprint(traceback.format_exc())

    pprint(str(len(matches)) + ' matches found for ' + str(srch))
    saveXmlDoc(xmlDoc)
    del matches, xmlDoc
    log.close()

def cleanupFolder(folder):
    pprint('Removing existing files from ' + folder)
    for root, dirnames, filenames in os.walk(folder):
        for file in filenames:
            try:
                os.remove(os.path.join(folder,file))
            except:
                pass

def startXmlDocument():
    xmlDoc = Document()
    root = xmlDoc.createElement('FileScanner')
    xmlDoc.appendChild(root)
    root.setAttribute("version",'1')
    root.setAttribute("xmlns:FileScanner",'http://vertex3.com')
 
    files = xmlDoc.createElement("Files")
    node = root.appendChild(files)
    node.setAttribute('timestamp',time.strftime("%Y-%m-%d %H:%M:%S"))
    return xmlDoc
 
 
def writeFileInfo(xmlDoc,file,filetype):
    filename = os.path.basename(file)
    rootdir = os.path.dirname(file)
    creation = ''
    lastmod = ''
    lastmods = ''
    filesize = ''
    try:
        creation = formatDate(os.path.getctime(file))
        lastmod = formatDate(os.path.getmtime(file))
        lastmods = os.path.getmtime(file)
        filesize = os.path.getsize(file)
        if filename.endswith('.gdb'):
            filesize = getGdbSize(file)
        if filesize > 0:
            filesize = round((filesize / 1024),4) # turn to KB
    except:
        pprint('Error getting 1 or more file properties')
        pass
       
    parent = xmlDoc.getElementsByTagName('Files')[0]
 
    node = xmlDoc.createElement('File')
 
    source = parent.appendChild(node)
    source.setAttribute('rootdir',rootdir.replace('\\\\','\\'))
    source.setAttribute('filename',filename)
    source.setAttribute('filetype',filetype.replace('.',''))
    source.setAttribute('origcreation',creation)
    source.setAttribute('lastmodms',str(lastmods))
    source.setAttribute('lastmod',str(lastmod))
    source.setAttribute('filesize',str(filesize))
 
    if mode == 'contents':
        xmlDoc = writeFileContents(xmlDoc,node,file,filetype)
 
    return xmlDoc

def getGdbSize(file):
    gdbsize = 0
    for f in os.listdir(file):
        try:
            gdbsize = gdbsize + os.path.getsize(os.path.join(file,f))
        except:
            pass
    return gdbsize
 
def formatDate(dateval):
    datets = datetime.datetime.fromtimestamp(dateval)
    return str(datetime.datetime.date(datets))
   
def saveXmlDoc(xmlDoc):
   
    pprint('Writing Xml Document ' + settings.outfile)
 
    fHandle = open(settings.outfile, 'w')
    xmlDoc.writexml(fHandle, encoding= 'utf-8', indent= '    ', newl= '\n')
    fHandle.close()
   
    pprint('Completed successfully')
 
def writeFileContents(xmlDoc,parent,file,filetype):
 
    if filetype == '.mxd':
        xmlDoc = writelayers(xmlDoc,parent,file,filetype)
    elif filetype == '.sde':
        xmlDoc = writesdeinfo(xmlDoc,parent,file,filetype)
    elif filetype in ['.gdb','.shp','.dwg','.dgn']:
        xmlDoc = writedatasets(xmlDoc,parent,file,filetype)
    else:
        pprint ('Type not handled ' + filetype)
 
    return xmlDoc
 
def writelayers(xmlDoc,parent,file,filetype):
   
    mxd = arcpy.mapping.MapDocument(file)
    try:
        for lyr in arcpy.mapping.ListLayers(mxd):
            pprint( "Layer: " + lyr.name)
            name = lyr.name
            type = ''
            source = ''
            server = ''
            path = ''
            if lyr.supports("SERVICEPROPERTIES"):
                servProp = lyr.serviceProperties
                if lyr.serviceProperties["ServiceType"] != "SDE":
                    type = servProp.get('ServiceType', 'N/A')
                    source = servProp.get('URL', 'N/A')
                    server = servProp.get('Server', 'N/A')
                else:
                    type = servProp.get('ServiceType', 'N/A')
                    source = servProp.get('Database', 'N/A')
                    server = servProp.get('Server', 'N/A')
            
            elif lyr.isFeatureLayer:
                    type = 'FeatureLayer'
                    path = lyr.dataSource
                    name = lyr.longName
               
            node = xmlDoc.createElement('Layer')
            elem = parent.appendChild(node)
            elem.setAttribute('name',name)
            elem.setAttribute('path',path)
            elem.setAttribute('source',source)
            elem.setAttribute('server',server)
            elem.setAttribute('type',type)
    except Exception, err:
        pprint(traceback.format_exc())
           
    return xmlDoc
 
def writedatasets(xmlDoc,parent,file,filetype):
   
    for dirpath, dirnames, filenames in arcpy.da.Walk(file,topdown=True,followlinks=True):
        for filename in filenames:
            if filename not in ['Point','Line','Polyline','Polygon','MultiPatch','Annotation']:
                pprint("Dataset: " + filename)
                name = filename
                path = dirpath           
                node = xmlDoc.createElement('Dataset')
                elem = parent.appendChild(node)
                elem.setAttribute('name',name)
                rowcount = 0
                try:
                    result = arcpy.GetCount_management(dirpath + os.sep + filename)
                    rowcount = int(result.getOutput(0))
                except:
                    rowcount = 0
                elem.setAttribute('rowcount',str(rowcount))
    return xmlDoc

def writesdeinfo(xmlDoc,parent,file,filetype):
   
    mode = ''
    database = ''
    instance = ''
    server = ''
    user = ''
    
    try:
        desc = arcpy.Describe(file)
        mode = desc.connectionProperties.authentication_mode
        database = desc.connectionProperties.database
        instance = desc.connectionProperties.instance
        server = desc.connectionProperties.server
        if mode != 'OSA':
            user = desc.connectionProperties.user
    except:
        pass

    node = xmlDoc.createElement('Dataset')
    elem = parent.appendChild(node)
    elem.setAttribute('mode',mode)
    elem.setAttribute('database',database)
    elem.setAttribute('instance',instance)
    elem.setAttribute('server',server)
    elem.setAttribute('user',user)
                  
    return xmlDoc


def pprint(strval):
    print strval
    log.write(strval + '\n')
    
if __name__ == "__main__":
    main()