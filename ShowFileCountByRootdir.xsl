<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="4.01" indent="yes"/>
	<xsl:output doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>
	<xsl:output doctype-public="-//W3C//DTD HTML 4.01//EN"/>

	<xsl:key name="root" match="File" use="@rootdir"/>

	<xsl:template match="/">
		<html>
			<link rel="stylesheet" type="text/css" href="css/style.css"/>
			<body>
				<xsl:call-template name="Main"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="Main">
		<!-- This section provides the headers and links at the top of the html page -->
		<br/>
		<strong>
			<xsl:value-of select="'GIS File Scanner: Number of files by root folder'"/>
		</strong>
		<hr/>
		<xsl:text>Run At: </xsl:text>
		<xsl:value-of select="FileScanner/Files/@timestamp"/>
		<br/>
		<br/>
		<table width="100%" style="border-color: white">
			<tbody>

				<th width="10%" style="border-color: white">
					<strong>
						<xsl:value-of select="'Root folder'"/>
					</strong>
				</th>
				<th width="5%" style="border-color: white">
					<strong>
						<xsl:value-of select="'File Count'"/>
					</strong>
				</th>
				<th width="5%" style="border-color: white">
					<strong>
						<xsl:value-of select="'Descendant File Count'"/>
					</strong>
				</th>

				<xsl:for-each select="//File[generate-id(.) = generate-id( key('root', @rootdir[1]))]">
					<xsl:sort select="@rootdir" order="ascending"/>

					<xsl:variable name="dir" select="@rootdir"/>
					<xsl:variable name="pos" select="position()"/>

					<tr>
						<td style="border-color: grey">
							<xsl:value-of select="concat($pos,'. ',@rootdir)"/>
						</td>
						<td style="border-color: grey">
							<xsl:value-of select="format-number(count(//File[@rootdir=$dir]),'###,###,##0')"/>
						</td>
						<td style="border-color: grey">
							<xsl:value-of select="format-number(count(//File[contains(@rootdir,$dir)]),'###,###,##0')"/>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
		<hr/>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios>
		<scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="out\results.xml" htmlbaseurl="" outputurl="out\results.html" processortype="msxmldotnet" useresolver="no" profilemode="0" profiledepth="" profilelength=""
		          urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal"
		          customvalidator="">
			<advancedProp name="sInitialMode" value=""/>
			<advancedProp name="schemaCache" value="||"/>
			<advancedProp name="bXsltOneIsOkay" value="true"/>
			<advancedProp name="bSchemaAware" value="false"/>
			<advancedProp name="bGenerateByteCode" value="true"/>
			<advancedProp name="bXml11" value="false"/>
			<advancedProp name="iValidation" value="0"/>
			<advancedProp name="bExtensions" value="true"/>
			<advancedProp name="iWhitespace" value="0"/>
			<advancedProp name="sInitialTemplate" value=""/>
			<advancedProp name="bTinyTree" value="true"/>
			<advancedProp name="xsltVersion" value="2.0"/>
			<advancedProp name="bWarnings" value="true"/>
			<advancedProp name="bUseDTD" value="false"/>
			<advancedProp name="iErrorHandling" value="fatal"/>
		</scenario>
	</scenarios>
	<MapperMetaTag>
		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
		<MapperBlockPosition></MapperBlockPosition>
		<TemplateContext></TemplateContext>
		<MapperFilter side="source"></MapperFilter>
	</MapperMetaTag>
</metaInformation>
-->