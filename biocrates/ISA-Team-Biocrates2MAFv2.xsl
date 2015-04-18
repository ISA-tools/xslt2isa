<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs"
	version="2.0">
	<xsl:strip-space elements="*"/>
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="/">
		<xsl:result-document href="output.xml" method="xml">
			<table>
				<xsl:apply-templates select="data/metabolite"/>
			</table>
		</xsl:result-document>		
	</xsl:template>
	
	<xsl:template match="data/metabolite">
		<metabolite>
			<xsl:attribute name="id">
				<xsl:value-of select="@identifier"/>
			</xsl:attribute>
			<xsl:apply-templates select="following-sibling::plate">
				<xsl:with-param name="metabolite-id" select="@identifier" tunnel="yes"/>				
			</xsl:apply-templates>			
		</metabolite>
	</xsl:template>
	
	<xsl:template match="data/plate/well">		
		<xsl:apply-templates select="injection"/>				
	</xsl:template>	
	
	<xsl:template match="injection">
		<xsl:param name="metabolite-id" required="yes" tunnel="yes"/>
		<xsl:variable name="filename" select="tokenize(@rawDataFileName, '\.')"/>
		<injection>		
			<xsl:attribute name="metabolite-id">
				<xsl:value-of select="$metabolite-id"/>
			</xsl:attribute>	
			<xsl:attribute name="id">
				<xsl:value-of select="concat($filename[1], ':', @polarity)"/>
			</xsl:attribute>
			<xsl:attribute name="concentration">
				<xsl:value-of select="measure[$metabolite-id = @metabolite]/@concentration"/>					
			</xsl:attribute>
		</injection>
	</xsl:template>		
</xsl:stylesheet>