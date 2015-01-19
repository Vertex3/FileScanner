<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="4.01" indent="yes"/>
	<xsl:output doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>
	<xsl:output doctype-public="-//W3C//DTD HTML 4.01//EN"/>

	<xsl:param name="filecount" select="100"/>

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
		<strong><xsl:value-of select="concat('GIS File Scanner: Top ',$filecount,' largest files')"/></strong>
		<hr/>
		<xsl:text>Run At: </xsl:text>
		<xsl:value-of select="FileScanner/Files/@timestamp"/>
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
									<xsl:value-of select="' (mb)'"/>
								</xsl:if>
							</strong>
						</th>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="FileScanner/Files/File">
					<xsl:sort select="@filesize" order="descending" data-type="number"/>
					<xsl:variable name="pos" select="position()"/>
					<xsl:if test="$pos &lt; $filecount + 1">
						<tr>
							<xsl:for-each select="./@*">
								<xsl:variable name="nm" select="local-name(.)"/>
								<xsl:if test="$nm != 'lastmodms'">
									<xsl:choose>
										<xsl:when test="$nm='filename'">
											<td style="border-color: grey">
														<xsl:value-of select="concat($pos,'. ',.)"/>
											</td>
										</xsl:when>
										<xsl:when test="$nm='filesize'">
											<td style="border-color: grey">
												<xsl:value-of select="format-number(. div 1024,'###,###,##0')"/>
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
					</xsl:if>
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