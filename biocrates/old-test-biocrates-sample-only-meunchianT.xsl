<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="text"/>
    
    <xsl:key name="samplelookupid" match="sample" use="@identifier"/>
     
    <!-- keys and variables needed for the muenchian transform/muenchian grouping --> 
    <xsl:key name="feature-by-sample" match="sampleInfoExport" use="ancestor::sample[1]/@identifier"/>
    <xsl:key name="sampleinfo-features" match="sampleInfoExport" use="@feature"/>
    <xsl:variable name="sampleinfo-features" select="/data/sample/sampleInfoExport[generate-id()=generate-id(key('sampleinfo-features', @feature)[1])]/@feature"/> 
    
 
 <xsl:template match="/data">
     
     <!--This is outputting the study table in a file-->
     <xsl:variable name="investigationfile" select="concat('output/',data,'s_study_biocrates.txt')[normalize-space()]"></xsl:variable>
     <xsl:value-of select="$investigationfile[normalize-space()]"/>     
     <xsl:result-document  href="{$investigationfile}">
         <xsl:copy-of select=".[normalize-space()]"></xsl:copy-of>
           
    <!--creating the header -->
         <h2>Source Name&#9;Material Type&#9;Characteristics[barcode identifier]&#9;Characteristics[organism]&#9;Characteristics[organism part]</h2><xsl:text>&#9;</xsl:text>
    <xsl:for-each select="/data/sample/sampleInfoExport[generate-id(.)=generate-id(key('sampleinfo-features', @feature)[1])]/@feature">    
       <!-- <xsl:sort/> -->     
        <h2>Characteristics[<xsl:value-of select="."/></h2><xsl:text>]&#9;</xsl:text>        
    </xsl:for-each>   
         <xsl:text>Protocol REF&#9;Performer&#9;Date&#9;Sample Name</xsl:text>
 <!-- creating a line break -->
<xsl:text>
</xsl:text>

<!--creating the rows for each sample and setting the right value for the right header category -->        
<xsl:for-each select="sample">
    <!-- pulling attributes from a sample node element -->
    <xsl:value-of select="@SampleIdentifier"/><xsl:text>&#9;</xsl:text> 
    <xsl:value-of select="@sampleType"/><xsl:text>&#9;</xsl:text>
    <xsl:value-of select="@barcode"/><xsl:text>&#9;</xsl:text>
    <xsl:value-of select="@Species"/><xsl:text>&#9;</xsl:text>
    <xsl:value-of select="@Material"/><xsl:text>&#9;</xsl:text>

    <!--Note: muenchian transform -->
    <xsl:variable name="sampleinfoexport" select="key('feature-by-sample', @identifier)"/>
    <xsl:for-each select="$sampleinfo-features">              
        <xsl:value-of select="$sampleinfoexport[@feature = current()]/@value"/><xsl:text>&#9;</xsl:text>
    </xsl:for-each>
    
    <!-- finishing table by adding protocol REF,performer,date and Sample Name values -->
    <xsl:text>sample collection&#9;</xsl:text>
    <xsl:value-of select="@sampleContact"/><xsl:text>&#9;</xsl:text>
    <xsl:value-of select="@collectionDate"/><xsl:text>&#9;</xsl:text>
    <xsl:value-of select="@SampleIdentifier"/><xsl:text>&#9;</xsl:text>
    
<!-- creating a line break -->
<xsl:text>
</xsl:text>
    
</xsl:for-each>   
</xsl:result-document> 
</xsl:template>
    
</xsl:stylesheet>