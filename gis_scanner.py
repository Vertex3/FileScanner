# gis_scanner.py - scan folder(s) for gis data
 
import sys,time,fnmatch,os,settings, re, xml.dom.minidom, subprocess, datetime, traceback, multiprocessing
from xml.dom.minidom import Document

log = open(sys.argv[0] + '.log', "w")
 
### folder to search
try:
    folders = sys.argv[1].lower()
except:
    folders = 'C:\\SG\\Projects\\CityOfBarrie'
folders = folders.split(',')
 
### file types to include
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
        
### folder strings to exclude from results 
exc = settings.exclude.split(',')

### scan for files or contents
try:
    mode = sys.argv[3].lower()
except:
    mode = 'files'
# other option is 'contents'

### get arcpy and the Arcgis license
try:
    import arcpy # if arcpy not present then do files
    res = arcpy.CheckProduct('ArcView')
    if res == 'Available':
        res = arcpy.SetProduct('ArcView')
    #print ('License ' + res)
except:
    mode = None # or just scan for 'files'
    
if mode not in ['files','contents']:
    mode = 'files' # default is 'files'
  
def main(argv = None):
    ### Main function - loop through files and do things
    global log
    pprint( 'Searching ' + str(folders))
    matches = []
    xmlDoc = startXmlDocument()
    cleanupFolder(settings.outfolder)
    
    try:
        for folder in folders: ### scan folders 
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
                            fil = os.path.join(root, filename)
                            fil = re.sub(r'[^\x00-\x7f]',' ',fil)
                            pprint(fil)
                            xmlDoc = writeFileInfo(xmlDoc,fil,extension)
    except Exception as err:
        print 'Process failed'
        pprint(traceback.format_exc())
    finally:
        pprint(str(len(matches)) + ' matches found for ' + str(srch))
        saveXmlDoc(xmlDoc)
        del matches, xmlDoc
        log.close()

def cleanupFolder(folder):
    ### get rid of files in the 'out' folder at the start of the process
    pprint('Removing existing files from ' + folder)
    for root, dirnames, filenames in os.walk(folder):
        for fil in filenames:
            try:
                os.remove(os.path.join(folder,fil))
            except:
                pass

def startXmlDocument():
    ### initialize the Xml document to be written
    xmlDoc = Document()
    root = xmlDoc.createElement('FileScanner')
    xmlDoc.appendChild(root)
    root.setAttribute("version",'1')
    root.setAttribute("xmlns:FileScanner",'http://vertex3.com')
 
    files = xmlDoc.createElement("Files")
    node = root.appendChild(files)
    node.setAttribute('timestamp',time.strftime("%Y-%m-%d %H:%M:%S"))
    return xmlDoc
 
 
def writeFileInfo(xmlDoc,fil,filetype):
    ### write file-level info and call other functions to write detailed info
    filename = os.path.basename(fil)
    rootdir = os.path.dirname(fil)
    creation = ''
    lastmod = ''
    lastmods = ''
    filesize = ''
    try:
        creation = formatDate(os.path.getctime(fil))
        lastmod = formatDate(os.path.getmtime(fil))
        lastmods = os.path.getmtime(fil)
        filesize = os.path.getsize(fil)
        if filename.endswith('.gdb'):
            filesize = getGdbSize(fil)
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
        xmlDoc = writeFileContents(xmlDoc,node,fil,filetype)
 
    return xmlDoc

def getGdbSize(fil):
    ### add up the files in the .gdb folders
    gdbsize = 0
    for f in os.listdir(fil):
        try:
            gdbsize = gdbsize + os.path.getsize(os.path.join(fil,f))
        except:
            pass
    return gdbsize
 
def formatDate(dateval):
    ### format the date val to string
    datets = datetime.datetime.fromtimestamp(dateval)
    return str(datetime.datetime.date(datets))
   
def saveXmlDoc(xmlDoc):
    ### save the Xml document to a file   
    pprint('Writing Xml Document ' + settings.outfile)
 
    fHandle = open(settings.outfile, 'w')
    xmlDoc.writexml(fHandle, encoding= 'utf-8', indent= '    ', newl= '\n')
    fHandle.close()
   
    pprint('Completed successfully')
 
def writeFileContents(xmlDoc,parent,fil,filetype):
    ### based on file extension call the appropriate function to write properties
    if filetype == '.mxd':
        if not fil.endswith(settings.oldMapSuffix):
            if testFileAccess(fil):
                xmlDoc = writelayers(xmlDoc,parent,fil,filetype)
    elif filetype == '.sde':
        xmlDoc = writesdeinfo(xmlDoc,parent,fil,filetype)
    elif filetype in ['.gdb','.shp','.dwg','.dgn']:
        if testFileAccess(fil):
            xmlDoc = writedatasets(xmlDoc,parent,fil,filetype)
    else:
        pprint ('Type not handled ' + filetype)
 
    return xmlDoc
 
def writelayers(xmlDoc,parent,fil,filetype):
    ### write layers from .mxd files
    try:
        mxd = arcpy.mapping.MapDocument(fil)
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
    except Exception as err:
        print err
        pprint(traceback.format_exc())
    finally:
        print 'layers complete'
    return xmlDoc
 
def writedatasets(xmlDoc,parent,fil,filetype):
    ### Write datasets for shp, gdb, etc

    for dirpath, dirnames, filenames in arcpy.da.Walk(fil,topdown=True,followlinks=True):
        for filename in filenames:
            if filename not in ['Point','Line','Polyline','Polygon','MultiPatch','Annotation']:
                pprint("Dataset: " + filename)
                node = xmlDoc.createElement('Dataset')
                elem = parent.appendChild(node)
                elem.setAttribute('name',filename)
                rowcount = 0
                try:
                    result = arcpy.GetCount_management(dirpath + os.sep + filename)
                    rowcount = int(result.getOutput(0))
                except:
                    pass
                elem.setAttribute('rowcount',str(rowcount))
    return xmlDoc

def writesdeinfo(xmlDoc,parent,file,filetype):
    ### write .sde connection file info    
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

def fileCheck(fil):
    for dirpath, dirnames, filenames in arcpy.da.Walk(fil,topdown=True):
        for name in filenames:
            name1 = name

def testFileAccess(fil):
    p = multiprocessing.Process(target=fileCheck, name="fileCheck", args=(fil,))
    started_at = time.time()
    p.start() 

    # If thread is active
    if p.is_alive():
        print 'checking file access'
        p.join(settings.timeout)    # Wait

        # Terminate
        p.terminate()
        ended_at = time.time()
        diff = ended_at - started_at
        print round(diff,2), 'seconds elapsed, timeout setting =',settings.timeout
        if(diff < settings.timeout):
            return True
        else:
            return False

def pprint(strval):
    ### write to stdout and log file
    print strval
    log.write(strval + '\n')
    
if __name__ == "__main__":
    main()