<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">
 
    <!--xsl stylesheet for Bruker XML documents 
        xmlns="http://www.bruker.com/xml_1.0"
        Author: Philippe Rocca-Serra, University of Oxford 
        (philippe.rocca-serra@oerc.ox.ac.uk)
        Licence: CC-BY-SA 4.0
        Version: rc1.0
        Task: 
        renders Bruker XML documents compliant to Bruker xsd 1.0 to ISA-Tab format
        
        Tip: ISA-Tab viewer for viewing ISA-Tab archive in web browser available from:
        
        Demo:
        Bruker test files:
        SampleInfo.xml

        
        Command: xsltproc brukerXML2ISATab.xsl bruker-file.xml
        
        TODO: retrofit xsl template to set instrument details 
    -->


 <xsl:key name="sample" match="Sample" use="@SampleID"/>
    <xsl:key name="analysis" match="AnalysisHeader" use="@SampleID"/>
 
 <xsl:template match="Sample">
    <xsl:for-each select="/Sample">
        <xsl:value-of select="@SampleID"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:value-of select="@SampleType"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:value-of select="@Method"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:value-of select="@MS_Method"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:value-of select="@Volume"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:value-of select="@Amount"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:value-of select="@Dilution"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:value-of select="@Position"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:value-of select="@InternalStandard"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:value-of select="@Operator"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:value-of select="key('analysis',@SampleID)/@CreationDateTime"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:value-of select="key('analysis',@SampleID)/@FileName"/>
    </xsl:for-each> 
     
 </xsl:template>
 
 
</xsl:stylesheet>