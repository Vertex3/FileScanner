<?xml version="1.0"?>
<?mso-application progid="Excel.Sheet"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel"
                xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:html="http://www.w3.org/TR/REC-html40">

	<xsl:output indent="yes"/>
	<!--	<xsl:include href="ExcelWriterCommon.xsl"/>-->

	<xsl:template match="/">

		<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
		          xmlns:html="http://www.w3.org/TR/REC-html40">
			<xsl:call-template name="Workbook"/>

			<Worksheet>
				<xsl:attribute name="ss:Name">Summary</xsl:attribute>
				<Table>
					<Column ss:Width="60" ss:AutoFitWidth="0"/>
					<Column ss:Width="60" ss:AutoFitWidth="0"/>
					<Column ss:Width="75" ss:AutoFitWidth="0"/>
					<Row>
						<Cell ss:StyleID="s20">
							<Data ss:Type="String">File Scanner Results</Data>
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
							<Data ss:Type="String">File Type</Data>
						</Cell>
						<Cell ss:StyleID="s20">
							<Data ss:Type="String">File Count</Data>
						</Cell>
						<Cell ss:StyleID="s20">
							<Data ss:Type="String">Total Size (mb)</Data>
						</Cell>
					</Row>
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
					<xsl:call-template name="showTotal">
						<xsl:with-param name="attr" select="'zip'"/>
					</xsl:call-template>
				</Table>
			</Worksheet>
			<xsl:call-template name="Main"/>
			<xsl:call-template name="Contents"/>
		</Workbook>
	</xsl:template>


	<xsl:template name="Main">
		<Worksheet>
			<xsl:attribute name="ss:Name">Results</xsl:attribute>
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
					<xsl:sort select="@lastmodms" order="ascending"/>
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
				</xsl:for-each>
			</Table>
		</Worksheet>
	</xsl:template>

	<xsl:template name="Contents">

		<xsl:variable name="lyrcount" select="count(//Layer)"/>
		<xsl:variable name="dscount" select="count(//Dataset)"/>

		<xsl:if test="$lyrcount &gt; 0 or $dscount &gt; 0">

			<xsl:for-each select="FileScanner/Files/File">
				<xsl:if test="count(Layer) &gt; 0">
					<Worksheet>
						<xsl:attribute name="ss:Name">
							<xsl:value-of select="concat(@filename,position())"/>
						</xsl:attribute>

						<Table>

							<xsl:for-each select="Layer[1]/@*">
								<xsl:variable name="nm" select="local-name(.)"/>
								<xsl:variable name="wid">
									<xsl:value-of select="'150'"/>
								</xsl:variable>
								<Column ss:Width="{$wid}" ss:AutoFitWidth="1"/>
							</xsl:for-each>
							<Row>
								<xsl:for-each select="Layer[1]/@*">
									<xsl:variable name="nm" select="local-name(.)"/>
									<Cell ss:StyleID="s20">
										<Data ss:Type="String">
											<xsl:value-of select="$nm"/>
										</Data>
									</Cell>
								</xsl:for-each>
							</Row>
							<xsl:for-each select="Layer">
								<Row>
									<xsl:for-each select="./@*">
										<Cell>
											<Data ss:Type="String">
												<xsl:value-of select="."/>
											</Data>
										</Cell>
									</xsl:for-each>
								</Row>
							</xsl:for-each>
						</Table>
					</Worksheet>
				</xsl:if>
				<xsl:if test="count(Dataset) &gt; 0">
					<Worksheet>
						<xsl:attribute name="ss:Name">
							<xsl:value-of select="concat(@filename,position())"/>
						</xsl:attribute>
						<xsl:variable name="fname" select="concat(@rootdir,'\',@filename)"/>

						<Table>
							<xsl:variable name="wid">
								<xsl:value-of select="100"/>
							</xsl:variable>

							<xsl:for-each select="Dataset[1]/@*">
								<xsl:variable name="nm" select="local-name(.)"/>
								<Column ss:Width="{$wid}" ss:AutoFitWidth="0"/>
							</xsl:for-each>
							<Column ss:Width="{$wid}" ss:AutoFitWidth="1"/>
							<Row>
								<xsl:for-each select="Dataset[1]/@*">
									<xsl:variable name="nm" select="local-name(.)"/>
									<Cell ss:StyleID="s20">
										<Data ss:Type="String">
											<xsl:value-of select="$nm"/>
										</Data>
									</Cell>
								</xsl:for-each>
								<Cell ss:StyleID="s20">
									<Data ss:Type="String">
										<xsl:value-of select="'Layer Count'"/>
									</Data>
								</Cell>
							</Row>
							<xsl:for-each select="Dataset">
								<Row>
									<xsl:for-each select="./@*">
										<xsl:variable name="typ">
											<xsl:choose>
												<xsl:when test="(number(.) and starts-with(.,'0') = false) or . = '0'">
													<xsl:value-of select="'Number'"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="'String'"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<Cell>
											<Data ss:Type="{$typ}">
												<xsl:value-of select="."/>
											</Data>
										</Cell>
									</xsl:for-each>

									<xsl:variable name="fullname">
										<xsl:value-of select="concat($fname,'\',@name)"/>
									</xsl:variable>
									<xsl:variable name="lcount" select="count(//Layer[@path=$fullname])"/>
									<Cell>
										<Data><xsl:attribute name="ss:Type">
										    <xsl:value-of select="'Number'"/>
										</xsl:attribute>
											<xsl:value-of select="$lcount"/>
										</Data>
									</Cell>
								</Row>
							</xsl:for-each>
						</Table>
					</Worksheet>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template name="showTotal">
		<xsl:param name="attr"/>

		<xsl:variable name="sum">
			<xsl:value-of select="sum(./FileScanner/Files/File[@filetype=$attr]/@filesize) div 1024"/>
		</xsl:variable>
		<xsl:if test="$sum &gt; 0">
			<Row>
				<Cell>
					<Data ss:Type="String">
						<xsl:value-of select="$attr"/>
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="Number">
						<xsl:value-of select="count(FileScanner/Files/File[@filetype=$attr])"/>
					</Data>
				</Cell>
				<Cell>
					<Data ss:Type="Number">
						<xsl:value-of select="format-number($sum,'#0.0')"/>
					</Data>
				</Cell>
			</Row>
		</xsl:if>
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
		<scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="outCAppsDeep\results.xml" htmlbaseurl="" outputurl="out\results.xls" processortype="msxmldotnet" useresolver="no" profilemode="0" profiledepth=""
		          profilelength="" urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal"
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