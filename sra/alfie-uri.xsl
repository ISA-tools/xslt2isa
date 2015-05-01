<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
        <foo>            
            <xsl:variable name="uri" select="'http://www.ebi.ac.uk/ena/data/warehouse/filereport?accession=SRX202009&amp;result=read_run&amp;fields=fastq_ftp,fastq_md5'"/>
            <xsl:variable name="my-doc" select="unparsed-text($uri)"/>
            
            <xsl:for-each select="tokenize($my-doc, '\n')">
                <xsl:if test="not(contains(.,'fastq_ftp'))">
                    <xsl:for-each select="tokenize(., '\t')">
                        <bar>
                            <xsl:value-of select="."/>    
                        </bar>
                    </xsl:for-each>
               </xsl:if>
            </xsl:for-each>   
        </foo> 
    </xsl:template>
</xsl:stylesheet>