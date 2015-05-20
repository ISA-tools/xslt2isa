<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="/">
        <xsl:variable name="biocrates2isa-cv-mapping" select="document('ISA-Team-Biocrates2ISA-CV-mapping.xml')"/>
        <xsl:value-of select="$biocrates2isa-cv-mapping/mapping/@name"/>
        <xsl:for-each select="$biocrates2isa-cv-mapping/mapping/replacement/element">
            
            <xsl:text>&#9;§§§</xsl:text>
            <xsl:value-of select="."/>
            <xsl:value-of select="@biocrateslabel"/>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>