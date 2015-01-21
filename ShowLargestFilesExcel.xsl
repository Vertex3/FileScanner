<?xml version="1.0"?>
<?mso-application progid="Excel.Sheet"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel"
                xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:html="http://www.w3.org/TR/REC-html40">

	<xsl:output indent="yes"/>

	<xsl:param name="filecount" select="100"/>

	<xsl:template match="/">
		<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
		          xmlns:html="http://www.w3.org/TR/REC-html40">
			<xsl:call-template name="Workbook"/>

			<Worksheet>
				<xsl:attribute name="ss:Name">Summary</xsl:attribute>
				<Table>
					<xsl:for-each select="FileScanner/Files/File[1]/@*">
						<xsl:variable name="nm" select="local-name(.)"/>
						<xsl:variable name="wid">
							<xsl:choose>
								<xsl:when test="$nm='filename'">
									<xsl:value-of select="'200'"/>
								</xsl:when>
								<xsl:when test="$nm='filesize'">
									<xsl:value-of select="'75'"/>
								</xsl:when>
								<xsl:when test="$nm='filetype'">
									<xsl:value-of select="'60'"/>
								</xsl:when>
								<xsl:when test="$nm='lastmod'">
									<xsl:value-of select="'100'"/>
								</xsl:when>
								<xsl:when test="$nm='origcreation'">
									<xsl:value-of select="'100'"/>
								</xsl:when>
								<xsl:when test="$nm='rootdir'">
									<xsl:value-of select="'300'"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:if test="$nm != 'lastmodms'">
							<Column ss:Width="{$wid}" ss:AutoFitWidth="0"/>
						</xsl:if>
					</xsl:for-each>
					<Row>
						<Cell ss:StyleID="s20">
							<Data ss:Type="String">
								<xsl:value-of select="concat('FileScanner: Top ',$filecount,' largest files')"/>
							</Data>
						</Cell>
					</Row>
					<Row/>
					<Row>
						<Cell ss:StyleID="s20">
							<Data ss:Type="String">
								<xsl:text>Run At: </xsl:text>
								<xsl:value-of select="FileScanner/Files/@timestamp"/>
							</Data>
						</Cell>
					</Row>
					<Row/>
					<Row>
						<xsl:for-each select="FileScanner/Files/File[1]/@*">
							<xsl:variable name="nm" select="local-name(.)"/>
							<xsl:if test="$nm != 'lastmodms'">
								<Cell ss:StyleID="s20">
									<Data ss:Type="String">
										<xsl:value-of select="$nm"/>
										<xsl:if test="$nm='filesize'">
											<xsl:value-of select="' (kb)'"/>
										</xsl:if>
									</Data>
								</Cell>
							</xsl:if>
						</xsl:for-each>
					</Row>



					<xsl:for-each select="FileScanner/Files/File">
						<xsl:sort select="@filesize" order="descending" data-type="number"/>
						<xsl:variable name="pos" select="position()"/>
						<xsl:if test="$pos &lt; $filecount + 1">
							<Row>
								<xsl:for-each select="./@*">
									<xsl:variable name="nm" select="local-name(.)"/>
									<xsl:if test="$nm != 'lastmodms'">
										<xsl:choose>
											<xsl:when test="$nm='filename'">
												<Cell>
													<Data ss:Type="String">
														<xsl:value-of select="."/>
													</Data>
												</Cell>
											</xsl:when>
											<xsl:when test="$nm='filesize'">
												<Cell>
													<Data ss:Type="Number">
														<xsl:value-of select="format-number(.,'#0.0')"/>
													</Data>
												</Cell>
											</xsl:when>
											<xsl:when test="$nm='rowcount'">
												<Cell>
													<Data ss:Type="Number">
														<xsl:value-of select="format-number(.,'#0')"/>
													</Data>
												</Cell>
											</xsl:when>
											<xsl:otherwise>
												<Cell>
													<Data ss:Type="String">
														<xsl:value-of select="."/>
													</Data>
												</Cell>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</xsl:for-each>
							</Row>
						</xsl:if>
					</xsl:for-each>
				</Table>
			</Worksheet>
		</Workbook>
	</xsl:template>

	<xsl:template name="Workbook">

		<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
			<Title>FileScanner Results</Title>
			<Author>SG</Author>
			<LastAuthor></LastAuthor>
			<Created></Created>
			<LastSaved></LastSaved>
			<Company>Vertex3</Company>
			<Version></Version>
		</DocumentProperties>
		<CustomDocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
		</CustomDocumentProperties>
		<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:office"/>

		<Styles>
			<Style ss:ID="Default" ss:Name="Normal">
				<Alignment ss:Vertical="Bottom"/>
				<Borders/>
				<Font/>
				<Interior/>
				<NumberFormat/>
				<Protection/>
			</Style>
			<Style ss:ID="s20" ss:StyleName="Heading">
				<Font x:Family="Swiss" ss:Bold="1"/>
			</Style>
		</Styles>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios>
		<scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="out\results.xml" htmlbaseurl="" outputurl="out\resultsLarge.xls" processortype="msxmldotnet" useresolver="no" profilemode="0" profiledepth="" profilelength=""
		          urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal"
		          customvalidator="">
			<advancedProp name="sInitialMode" value=""/>
			<advancedProp name="schemaCache" value="||"/>
			<advancedProp name="bXsltOneIsOkay" value="true"/>
			<advancedProp name="bSchemaAware" value="false"/>
			<advancedProp name="bGenerateByteCode" value="false"/>
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