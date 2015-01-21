<?xml version="1.0"?>
<?mso-application progid="Excel.Sheet"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel"
                xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:html="http://www.w3.org/TR/REC-html40">

	<xsl:key name="root" match="File" use="@rootdir"/>
	<xsl:output indent="yes"/>
	<!--	<xsl:include href="ExcelWriterCommon.xsl"/>-->

	<xsl:template match="/">

		<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
		          xmlns:html="http://www.w3.org/TR/REC-html40">
			<xsl:call-template name="Workbook"/>

			<Worksheet>
				<xsl:attribute name="ss:Name">Summary</xsl:attribute>
				<Table>
					<Column ss:Width="300" ss:AutoFitWidth="0"/>
					<Column ss:Width="60" ss:AutoFitWidth="0"/>
					<Column ss:Width="75" ss:AutoFitWidth="0"/>
					<Row>
						<Cell ss:StyleID="s20">
							<Data ss:Type="String"><xsl:value-of select="'File Scanner: Number of files by root folder'"/></Data>
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
						<Cell ss:StyleID="s20">
							<Data ss:Type="String">Root Folder</Data>
						</Cell>
						<Cell ss:StyleID="s20">
							<Data ss:Type="String">File Count</Data>
						</Cell>
						<Cell ss:StyleID="s20">
							<Data ss:Type="String">Descendant File Count</Data>
						</Cell>
					</Row>


				<xsl:for-each select="//File[generate-id(.) = generate-id( key('root', @rootdir[1]))]">
					<xsl:sort select="@rootdir" order="ascending"/>

					<xsl:variable name="dir" select="@rootdir"/>
					<xsl:variable name="pos" select="position()"/>

					<Row>
						<Cell>
							<Data ss:Type="String"><xsl:value-of select="concat($pos,'. ',@rootdir)"/></Data>
						</Cell>
						<Cell>
							<Data ss:Type="Number"><xsl:value-of select="format-number(count(//File[@rootdir=$dir]),'###,###,##0')"/></Data>
						</Cell>
						<Cell>
							<Data ss:Type="Number"><xsl:value-of select="format-number(count(//File[contains(@rootdir,$dir)]),'###,###,##0')"/></Data>
						</Cell>
					</Row>
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
		<scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="out\results.xml" htmlbaseurl="" outputurl="out\resultsDir.xls" processortype="msxmldotnet" useresolver="no" profilemode="0" profiledepth="" profilelength=""
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