<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:isa="http://www.isa-tools.org/"
    exclude-result-prefixes="xs isa"
    version="2.0">
    
    <xsl:function name="isa:quotes" as="xs:string">
        <xsl:param name="input" as="xs:string"/>
        <xsl:value-of select="concat('&quot;', $input, '&quot;')"/>
    </xsl:function>
    
</xsl:stylesheet>