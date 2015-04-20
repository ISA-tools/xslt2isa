<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs"
	version="2.0">
	<xsl:strip-space elements="*"/>
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>		
	
	<xsl:template match="/">
		<main>
			<xsl:apply-templates select="document('http://www.ebi.ac.uk/ena/data/view/SRA030397&amp;display=xml')" mode="foo"/>	
		</main>		
	</xsl:template>	
	
	<xsl:template match="ROOT" mode="foo">				
			<xsl:apply-templates select="SUBMISSION/SUBMISSION_LINKS"/>			
	</xsl:template>
	
	<xsl:template match="SUBMISSION_LINK/XREF_LINK">
		<my-id>
			<xsl:value-of select="ID"></xsl:value-of>
		</my-id>
	</xsl:template>
	
</xsl:stylesheet>