<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="4.01" indent="yes"/>
	<xsl:output doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>
	<xsl:output doctype-public="-//W3C//DTD HTML 4.01//EN"/>
	
	<xsl:template match="/">
		<html>
		<link rel="stylesheet" type="text/css" href="css/style.css"/>
			<body>
				<xsl:call-template name="Main"/>
				<xsl:call-template name="Contents"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="Main">
		<!-- This section provides the headers and links at the top of the html page -->
		<br/>
		<strong>GIS File Scanner Results</strong>
		<hr/>
		<xsl:text>Run At: </xsl:text>
		<xsl:value-of select="FileScanner/Files/@timestamp"/>
		<br/>
		<br/>
		<xsl:call-template name="showTotal">
			<xsl:with-param name="attr" select="'dwg'"/>
		</xsl:call-template>
		<xsl:call-template name="showTotal">
			<xsl:with-param name="attr" select="'shp'"/>
		</xsl:call-template>
		<xsl:call-template name="showTotal">
			<xsl:with-param name="attr" select="'gdb'"/>
		</xsl:call-template>
		<xsl:call-template name="showTotal">
			<xsl:with-param name="attr" select="'mxd'"/>
		</xsl:call-template>
		<br/>
		<br/>
		<table width="100%" style="border-color: white">
			<tbody>
				<xsl:for-each select="FileScanner/Files/File[1]/@*">
					<xsl:variable name="nm" select="local-name(.)"/>
					<xsl:variable name="wid">
						<xsl:choose>
							<xsl:when test="$nm='filename'">
								<xsl:value-of select="'20%'"/>
							</xsl:when>
							<xsl:when test="$nm='filesize'">
								<xsl:value-of select="'7%'"/>
							</xsl:when>
							<xsl:when test="$nm='filetype'">
								<xsl:value-of select="'7%'"/>
							</xsl:when>
							<xsl:when test="$nm='lastmod'">
								<xsl:value-of select="'7%'"/>
							</xsl:when>
							<xsl:when test="$nm='origcreation'">
								<xsl:value-of select="'7%'"/>
							</xsl:when>
							<xsl:when test="$nm='rootdir'">
								<xsl:value-of select="'*'"/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:if test="$nm != 'lastmodms'">

						<th width="{$wid}" style="border-color: white">
							<strong>
								<xsl:value-of select="$nm"/>
								<xsl:if test="$nm='filesize'">
									<xsl:value-of select="' (kb)'"/>
								</xsl:if>
							</strong>
						</th>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="FileScanner/Files/File">
					<xsl:sort select="@lastmodms" order="ascending"/>
					<tr>
						<xsl:for-each select="./@*">
							<xsl:variable name="nm" select="local-name(.)"/>
							<xsl:if test="$nm != 'lastmodms'">
								<xsl:choose>
									<xsl:when test="$nm='filename'">
										<td style="border-color: grey">
											<xsl:element name="a">
												<xsl:attribute name="href">
													<xsl:value-of select="concat('#',../@rootdir,'\',.)"/>
												</xsl:attribute>
												<xsl:value-of select="."/>
											</xsl:element>
										</td>
									</xsl:when>
									<xsl:when test="$nm='filesize'">
										<td style="border-color: grey">
											<xsl:value-of select="format-number(.,'###,###,##0.0')"/>
										</td>
									</xsl:when>
									<xsl:when test="$nm='rowcount'">
										<td style="border-color: grey">
											<xsl:value-of select="format-number(.,'###,###,##0')"/>
										</td>
									</xsl:when>
									<xsl:otherwise>
										<td style="border-color: grey">
											<xsl:value-of select="."/>
										</td>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</xsl:for-each>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
		<hr/>
	</xsl:template>

	<xsl:template name="Contents">
		<!-- This section provides the detailed contents if present -->
		<xsl:variable name="lyrcount" select="count(//Layer)"/>
		<xsl:variable name="dscount" select="count(//Dataset)"/>

		<xsl:if test="$lyrcount &gt; 0 or $dscount &gt; 0">
			<br/>
			<strong>Contents</strong>
			<hr/>
			<br/>
			<xsl:value-of select="concat($lyrcount,' Layers Found')"/>
			<br/>
			<xsl:value-of select="concat($dscount,' Datasets Found')"/>
			<xsl:for-each select="FileScanner/Files/File">
				<xsl:variable name="fname" select="concat(@rootdir,'\',@filename)"/>
				<xsl:element name="a">
					<xsl:attribute name="name">
						<xsl:value-of select="$fname"/>
					</xsl:attribute>
					<br/>
					<strong>
						<xsl:value-of select="$fname"/>
					</strong>
					<br/>
				</xsl:element>
				<xsl:if test="count(Layer) &gt; 0">
					<table width="100%" style="border-color: white">
						<tbody>
							<xsl:for-each select="Layer[1]/@*">
								<xsl:variable name="nm" select="local-name(.)"/>
								<xsl:variable name="wid">
									<xsl:value-of select="'20%'"/>
								</xsl:variable>
								<th width="{$wid}" style="border-color: white">
									<strong>
										<xsl:value-of select="$nm"/>
									</strong>
								</th>
							</xsl:for-each>
							<xsl:for-each select="Layer">
								<tr>
									<xsl:for-each select="./@*">
										<xsl:variable name="nm" select="local-name(.)"/>
										<td style="border-color: grey">
											<xsl:value-of select="."/>
										</td>
									</xsl:for-each>
								</tr>
							</xsl:for-each>
						</tbody>
					</table>
					<hr/>
				</xsl:if>
				<xsl:if test="count(Dataset) &gt; 0">
					<table width="100%" style="border-color: white">
						<xsl:variable name="wid">
							<xsl:value-of select="'5%'"/>
						</xsl:variable>
						<tbody>
							<xsl:for-each select="Dataset[1]/@*">
								<xsl:variable name="nm" select="local-name(.)"/>
								<th width="{$wid}" style="border-color: white">
									<strong>
										<xsl:value-of select="$nm"/>
									</strong>
								</th>
							</xsl:for-each>
							<th width="{$wid}" style="border-color: white">
								<strong>
									<xsl:text>Layer count</xsl:text>
								</strong>
							</th>
							<xsl:for-each select="Dataset">
								<tr>
									<xsl:for-each select="./@*">
										<xsl:variable name="nm" select="local-name(.)"/>
										<td style="border-color: grey">
											<xsl:value-of select="."/>
										</td>
									</xsl:for-each>
									<td style="border-color: grey">
										<xsl:variable name="fullname">
											<xsl:value-of select="concat($fname,'\',@name)"/>
										</xsl:variable>
										<xsl:variable name="lcount" select="count(//Layer[@path=$fullname])"/>
										<xsl:value-of select="$lcount"/>
										<xsl:if test="$lcount &gt; 0">
											<xsl:value-of select="' Layers use this dataset'"/>
										</xsl:if>
									</td>
								</tr>
							</xsl:for-each>
						</tbody>
					</table>
					<hr/>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template name="showTotal">
		<xsl:param name="attr"/>

		<xsl:variable name="sum">
			<xsl:value-of select="sum(FileScanner/Files/File[@filetype=$attr]/@filesize) div 1000"/>
		</xsl:variable>
		<xsl:if test="$sum &gt; 0">
			<xsl:value-of select="concat(count(FileScanner/Files/File[@filetype=$attr]),' ',$attr,' Files Found')"/>
			<xsl:value-of select="concat(', ',format-number($sum,'###,###,##0.0'),' mb')"/>
			<br/>
		</xsl:if>
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