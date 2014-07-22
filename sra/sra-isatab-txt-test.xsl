<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#160;">
  <!ENTITY copy "&#169;">
]>

<!--xsl stylesheet prototype for SRA XML documents representing submission 000266 
Author: Philippe Rocca-Serra, EMBL-EBI (rocca@ebi.ac.uk) -->


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text"/>

<xsl:key name="samplelookupid"  match="SAMPLE"  use="@alias"/>
<xsl:key name="sampletaglookupid"  match="//SAMPLE_SET/SAMPLE/SAMPLE_ATTRIBUTES/SAMPLE_ATTRIBUTE/TAG"  use="."/>
<xsl:key name="samplevallookupid"  match="//SAMPLE_SET/SAMPLE/SAMPLE_ATTRIBUTES/SAMPLE_ATTRIBUTE/VALUE"  use="."/>
<xsl:key name="sampleunitlookupid"  match="//SAMPLE_SET/SAMPLE/SAMPLE_ATTRIBUTES/SAMPLE_ATTRIBUTE/UNITS"  use="."/>
<xsl:key name="exptlookupid"  match="EXPERIMENT"  use="@alias"/>
<xsl:key name="samplereflookupid"  match="SAMPLE_DESCRIPTOR"  use="@refname"/>
<xsl:key name="libnamelookupid"  match="LIBRARY_NAME" use="."/>
<xsl:key name="libstratlookupid"  match="LIBRARY_STRATEGY"  use="."/>
<xsl:key name="libsrclookupid"  match="LIBRARY_SOURCE"  use="."/>
<xsl:key name="libseleclookupid"  match="LIBRARY_SELECTION"  use="."/>
<xsl:key name="protocols"  match="LIBRARY_CONSTRUCTION_PROTOCOL"  use="."/>
<xsl:key name="expprotlookupid"  match="//EXPERIMENT_SET/EXPERIMENT/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_CONSTRUCTION_PROTOCOL"  use="."/>
<xsl:key name="instrumentlookupid"  match="INSTRUMENT_MODEL" use="."/>
<!--<xsl:key name="SamplebySampleAttributesbyTag" match="SAMPLE" use="concat(SAMPLE_ATTRIBUTES,'::',SAMPLE_ATTRIBUTE,'::',TAG)"/>-->
<xsl:variable name="protocols"
              select="//LIBRARY_CONSTRUCTION_PROTOCOL[generate-id() =
                                 generate-id(key('protocols',.)[1])]" />
<xsl:key name="TAGS-by-SAMPLE"
         match="TAG"
         use="preceding-sibling::SAMPLE_ATTRIBUTES/SAMPLE_ATTRIBUTE/TAG[1]" />

<xsl:key name="TAGS-by-RUN"
         match="TAG"
         use="preceding-sibling::RUN_ATTRIBUTES/RUN_ATTRIBUTE/TAG[1]" />    

<xsl:key name="runtaglookupid"  match="//RUN_SET/RUN/RUN_ATTRIBUTES/RUN_ATTRIBUTE/TAG"  use="."/>
<xsl:key name="runvallookupid"  match="//RUN_SET/RUN/RUN_ATTRIBUTES/RUN_ATTRIBUTE/VALUE"  use="."/>
<xsl:key name="rununitlookupid"  match="//RUN_SET/RUN/RUN_ATTRIBUTES/RUN_ATTRIBUTE/UNITS"  use="."/>

<xsl:key name="filelookupid" match="FILE" use="@filename"/>

 <xsl:template match="SRA">	
 
<xsl:text>#SRA Document:</xsl:text>  <xsl:value-of select="@identifier"/>
<xsl:text></xsl:text>
<xsl:text>
</xsl:text>
<xsl:text>Ontology Source Reference</xsl:text>
<xsl:text>
</xsl:text>
 
<xsl:text>Term Source Name</xsl:text> 
<xsl:text>&#9;</xsl:text><xsl:text>ENA-CV</xsl:text>
<xsl:text>
</xsl:text>
 
<xsl:text>Term Source File</xsl:text>
<xsl:text>&#9;</xsl:text><xsl:text>ENA-CV.obo</xsl:text>
<xsl:text>
</xsl:text>
 
<xsl:text>Term Source Version</xsl:text>
<xsl:text>&#9;</xsl:text><xsl:text>1</xsl:text>
<xsl:text>
</xsl:text>
<xsl:text>Term Source Description</xsl:text>
<xsl:text>&#9;</xsl:text><xsl:text>Controlled Terminology for SRA/ENA schema</xsl:text>
 
<xsl:text>
INVESTIGATION
Investigation Identitifier
Investigation Title
Investigation Description
Investigation Submission Date
Investigation Public Release Date
INVESTIGATION PUBLICATIONS
Investigation PubMed ID
Investigation Publication DOI
Investigation Publication Author List
Investigation Publication Title
Investigation Publication Status
Investigation Publication Status Term Accession Number
Investigation Publication Status Term Source REF
INVESTIGATION CONTACTS
Investigation Person Last Name
Investigation Person First Name
Investigation Person Mid Initials
Investigation Person Email
Investigation Person Phone
Investigation Person Fax
Investigation Person Address
Investigation Person Affiliation
Investigation Person Roles
Investigation Person Roles Term Accession Number
Investigation Person Roles Term Source REF

STUDY
</xsl:text>
<xsl:apply-templates select="STUDY"/>
<xsl:apply-templates select="SUBMISSION"/>
<xsl:apply-templates select="SAMPLE_SET"/>
<xsl:apply-templates select="RUN_SET"/>
</xsl:template> 

<xsl:template match="SUBMISSION">
 
 
  <xsl:for-each select="//SUBMISSION">
    <xsl:if test="child::CONTACTS/CONTACT">
<xsl:text>Person Last Name</xsl:text><xsl:text>&#9;</xsl:text>
     <xsl:value-of select="substring-before(child::CONTACTS/CONTACT/@name,' ')"/>
<xsl:text>
</xsl:text>
    </xsl:if>
 <xsl:if test="child::CONTACTS/CONTACT">
<xsl:text>Person First Name</xsl:text><xsl:text>&#9;</xsl:text>
  <xsl:value-of select="substring-after(child::CONTACTS/CONTACT/@name,' ')"/>
<xsl:text>
</xsl:text>
 </xsl:if>
   <xsl:text>Person Mid Initials</xsl:text>
   <xsl:text>
</xsl:text>
<xsl:if test="child::CONTACTS/CONTACT">
<xsl:text>Person Email</xsl:text><xsl:text>&#9;</xsl:text>  
<xsl:value-of select="child::CONTACTS/CONTACT/@inform_on_status"/>
</xsl:if>
<xsl:text>
</xsl:text>
<xsl:if test="child::CONTACTS/CONTACT">
<xsl:text>Person Phone</xsl:text><xsl:text>&#9;</xsl:text>  
 <xsl:text>-</xsl:text>
</xsl:if>
<xsl:text>
</xsl:text> 
<xsl:if test="child::CONTACTS/CONTACT">
<xsl:text>Person Fax</xsl:text><xsl:text>&#9;</xsl:text>  
 <xsl:text>-</xsl:text>
</xsl:if>
<xsl:text>
</xsl:text>    
<xsl:text>Person Address</xsl:text>
<xsl:text>
</xsl:text>
<xsl:text>Person Affiliation</xsl:text>
<xsl:text>
</xsl:text>
<xsl:text>Person Role</xsl:text>
<xsl:text>
</xsl:text>
<xsl:text>Person Role Term Source REF</xsl:text>
<xsl:text>
</xsl:text>
<xsl:text>Person Role Term Accession</xsl:text>
<xsl:text>
</xsl:text>
  </xsl:for-each>
 

 
</xsl:template>


 <xsl:template match="STUDY">

<xsl:for-each select="//STUDY">
   
<xsl:text>Study Identifier</xsl:text><xsl:text>&#9;</xsl:text>
<xsl:choose>
<xsl:when test="@accession">
<xsl:value-of select="@accession"/>
</xsl:when>
<xsl:otherwise>
<xsl:text></xsl:text>
</xsl:otherwise>
</xsl:choose>
<xsl:text>
</xsl:text>
 
<xsl:if test="child::DESCRIPTOR/STUDY_TITLE">
<xsl:text>Study Title</xsl:text><xsl:text>&#9;</xsl:text>
<xsl:value-of select="child::DESCRIPTOR/STUDY_TITLE"/>
<xsl:text>
</xsl:text>
</xsl:if> 
    
<xsl:if test="child::DESCRIPTOR/STUDY_ABSTRACT">
<xsl:text>Study Description</xsl:text><xsl:text>&#9;</xsl:text>
<xsl:value-of select="child::DESCRIPTOR/STUDY_ABSTRACT"/>
<xsl:if test="child::DESCRIPTOR/STUDY_DESCRIPTION">
 <xsl:value-of select="substring-before(child::DESCRIPTOR/STUDY_DESCRIPTION,'\r')"/>
</xsl:if>
</xsl:if>  
<xsl:text>
</xsl:text>     
    
<xsl:text>Study Submission Date</xsl:text><xsl:text>&#9;</xsl:text>
<xsl:value-of select="SRA/SUBMISSION/@submission_date"/>
 <!-- <xsl:apply-template select="//SUBMISSION" mode="submissiondate"/>    -->
<xsl:text>
</xsl:text>
    
<xsl:text>Study Public Release Date</xsl:text><xsl:text>&#9;</xsl:text>
<xsl:value-of select="SRA/SUBMISSION/@submission_date"/>
<xsl:text>
</xsl:text>
 <xsl:text>Study File Name</xsl:text>
 <xsl:text>
</xsl:text>   

 <xsl:text>STUDY DESIGN DESCRIPTORS</xsl:text>
 <xsl:text>
</xsl:text>     

<xsl:if test="child::DESCRIPTOR/STUDY_TYPE">
<xsl:text>Study Design Type</xsl:text><xsl:text>&#9;</xsl:text>
<xsl:value-of select="child::DESCRIPTOR/STUDY_TYPE/@existing_study_type"/>
</xsl:if>  
<xsl:text>
</xsl:text>     
 <xsl:text>Study Design Type Term Accession Number</xsl:text><xsl:text>&#9;</xsl:text>
 <xsl:text>
</xsl:text>    
<xsl:text>Study Design Type Term Source REF</xsl:text><xsl:text>&#9;</xsl:text>
 
<xsl:text>
STUDY PUBLICATIONS
Study PubMed ID
Study Publication DOI
Study Publication Author List
Study Publication Title
Study Publication Status
Study Publication Status Term Accession Number
Study Publication Status Term Source REF 
</xsl:text>

 
<xsl:text>STUDY FACTORS</xsl:text>
<xsl:text>
</xsl:text>
 
 <xsl:text>Study Factor Name</xsl:text><xsl:text>&#9;</xsl:text>
<xsl:text>
</xsl:text>

<xsl:text>Study Factor Type</xsl:text><xsl:text>&#9;</xsl:text>
<xsl:text>
</xsl:text>

 <xsl:text>Study Factor Type Term Accession Number</xsl:text><xsl:text>&#9;</xsl:text>
 <xsl:text>
</xsl:text>

<xsl:text>Study Factor Type Term Source REF</xsl:text><xsl:text>&#9;</xsl:text>
<xsl:text>
</xsl:text>
    
<xsl:text>STUDY ASSAYS</xsl:text>
<xsl:text>
</xsl:text>
    
<xsl:text>Study Assay Measurement Type</xsl:text>
     <xsl:for-each select="//LIBRARY_SOURCE[generate-id(.)=generate-id(key('libsrclookupid',.)[1])]">
      <xsl:text>&#9;</xsl:text>
       <xsl:value-of select="."/>
     </xsl:for-each>
<xsl:text>
</xsl:text>

<xsl:text>Study Assay Measurement Type Term Accession Number</xsl:text><xsl:text>&#9;</xsl:text>
    <xsl:text>ENA:0000019</xsl:text><xsl:text>&#9;</xsl:text>
    <xsl:text>ENA:0000020</xsl:text>
<xsl:text>
</xsl:text>

 <xsl:text>Study Assay Measurement Type Term Source REF</xsl:text><xsl:text>&#9;</xsl:text>
 <xsl:text>ENA</xsl:text><xsl:text>&#9;</xsl:text>
 <xsl:text>ENA</xsl:text>
 <xsl:text>
</xsl:text>

<xsl:text>Study Assay Technology Type</xsl:text><xsl:text>&#9;</xsl:text>
     <xsl:for-each select="//LIBRARY_STRATEGY[generate-id(.)=generate-id(key('libstratlookupid',.)[1])]">
      <xsl:text>&#9;</xsl:text>
      <xsl:value-of select="."/>
     </xsl:for-each>        
<xsl:text>
</xsl:text>
     
<xsl:text>Study Assay Technology Type Term Accession Number</xsl:text><xsl:text>&#9;</xsl:text>
     <xsl:text>ENA:0000044</xsl:text><xsl:text>&#9;</xsl:text>
     <xsl:text>ENA:0000054</xsl:text>
<xsl:text>
</xsl:text>  

 <xsl:text>Study Assay Technology Type Term Source REF</xsl:text><xsl:text>&#9;</xsl:text>
 <xsl:text>ENA</xsl:text><xsl:text>&#9;</xsl:text>
 <xsl:text>ENA </xsl:text>
 <xsl:text>
</xsl:text> 

<xsl:text>Study Assay File Names</xsl:text><xsl:text>&#9;</xsl:text>
<xsl:text>
</xsl:text>
    
<xsl:text>STUDY PROTOCOLS</xsl:text>
<xsl:text>
</xsl:text>
      
<xsl:text>Study Protocol Name</xsl:text><xsl:text>&#9;</xsl:text>
<xsl:text>
</xsl:text>
      
<xsl:text>Study Protocol Type</xsl:text><xsl:text>&#9;</xsl:text>
     <xsl:text>library construction</xsl:text>
<xsl:text>
</xsl:text>  

<xsl:text>Study Protocol Type Term Accession Number</xsl:text>
 <xsl:text>
</xsl:text>


<xsl:text>Study Protocol Type Term Source REF</xsl:text>
<xsl:text>
</xsl:text>
      
<xsl:text>Study Protocol Description</xsl:text><xsl:text>&#9;</xsl:text>   
    <xsl:for-each select="//LIBRARY_CONSTRUCTION_PROTOCOL[generate-id(.)=generate-id(key('expprotlookupid',.)[1])]">
          <xsl:value-of select="substring-before(substring-after(.,'&#xa;'),'&#xa;')"/>
     </xsl:for-each>
<xsl:text>
</xsl:text>
    
<xsl:text>STUDY CONTACTS</xsl:text>
<xsl:text>
</xsl:text>
    
    
    <!--      <xsl:choose>
     <xsl:when test="./STUDY_ATTRIBUTES">
     
     <xsl:for-each select="STUDY_ATTRIBUTE">
     <xsl:variable name="tags" select="key('TAGS-by-STUDY', .)" />
     <tr>
     <xsl:for-each select="TAGS-by-STUDY"> -->
    <!-- introduce a test to check on the value of the STUDY_TAGs-> ask Rasko regarding the possible values defined by curation team-->
    <!-- <td><font face="Arial" size="2pt">
     <xsl:value-of select="$tags[/TAG = current()]" />
     </td>
     </xsl:for-each>
     </tr>
     </xsl:for-each>
     <xsl:for-each select="./STUDY_ATTRIBUTES/STUDY_ATTRIBUTE/VALUE">
     <td bgcolor="#CCCCCC">
     <font face="Arial" size="2pt">
     <xsl:value-of select="."/>
     </font>
     </td>
     </xsl:for-each>  -->
    
    <!--<xsl:for-each select="./SAMPLE_ATTRIBUTES/SAMPLE_ATTRIBUTE/UNITS">
     <td>
     <font face="Arial" size="2pt">
     <xsl:value-of select="."/>
     </font>
     </td>
     </xsl:for-each>-->
    
    <!--   </xsl:when>
     <xsl:otherwise>
     <td><font face="Arial" size="2pt">-</td>
     </xsl:otherwise>
     </xsl:choose>-->

   </xsl:for-each>
 
 </xsl:template>

 <xsl:template match="SAMPLE_SET">
  <xsl:text>
</xsl:text>
  <xsl:text>Source Name</xsl:text><xsl:text>&#9;</xsl:text>
  <xsl:text>Comment[Common Name]</xsl:text><xsl:text>&#9;</xsl:text>
  <xsl:text>Characteristics[organism]</xsl:text><xsl:text>&#9;</xsl:text>
  <xsl:text>Term Source REF</xsl:text><xsl:text>&#9;</xsl:text>
  <xsl:text>Term Source Accession</xsl:text><xsl:text>&#9;</xsl:text>
  <xsl:text>Characteristics[Description]</xsl:text><xsl:text>&#9;</xsl:text>
    <xsl:for-each select="//TAG[generate-id(.)=generate-id(key('sampletaglookupid',.)[1])]">
      <xsl:text>Characteristics[</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>]</xsl:text>
      <xsl:text>&#9;</xsl:text>
    </xsl:for-each>
  <xsl:text>Sample Name</xsl:text><xsl:text>&#9;</xsl:text>
<xsl:text>
</xsl:text>
    <xsl:apply-templates select="SAMPLE"/>
 </xsl:template>

 <xsl:template match="SAMPLE">
  
  <!--  <xsl:variable name="color">
   <xsl:choose>
   <xsl:when test="position() mod 2= 0">#B0C4DE</xsl:when>
   <xsl:otherwise>#CCCCCC</xsl:otherwise>
   </xsl:choose>
   </xsl:variable>
   
   <tr bgcolor="{$color}">  -->
   
   <xsl:choose>
    <xsl:when test="@alias">
     <xsl:value-of select="@alias"/><xsl:text>&#9;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
     <xsl:text></xsl:text><xsl:text>&#9;</xsl:text>
    </xsl:otherwise>
   </xsl:choose>
   
   <xsl:choose>
    <xsl:when test="./SAMPLE_NAME/COMMON_NAME">
     <xsl:value-of select="./SAMPLE_NAME/COMMON_NAME/."/><xsl:text>&#9;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
     <xsl:text></xsl:text><xsl:text>&#9;</xsl:text>
    </xsl:otherwise>
   </xsl:choose>
   <xsl:choose>
    <xsl:when test="./SAMPLE_NAME/TAXON_ID">
     <!-- <xsl:param name="url" select="./SAMPLE_NAME/TAXON_ID/."></xsl:param> -->
     <xsl:value-of select="./SAMPLE_NAME/SCIENTIFIC_NAME/."/><xsl:text>&#9;</xsl:text>
     <xsl:text>NCBITax</xsl:text><xsl:text>&#9;</xsl:text>
      <!-- <a href="http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id={$url}" target="_blank">-->
     <xsl:value-of select="./SAMPLE_NAME/TAXON_ID/."/><xsl:text>&#9;</xsl:text>
      <!-- </a> -->
      </xsl:when>
    <xsl:otherwise>
     <xsl:text></xsl:text><xsl:text>&#9;</xsl:text>
    </xsl:otherwise>
   </xsl:choose>
   
   
   <xsl:choose>
    <xsl:when test="./DESCRIPTION">
     <xsl:value-of select="substring-before(./DESCRIPTION/.,'&#xa;')"/><xsl:text>&#9;</xsl:text>     
    </xsl:when>
    <xsl:otherwise>
     <xsl:text></xsl:text><xsl:text>&#9;</xsl:text>
    </xsl:otherwise>
   </xsl:choose>
   
   <xsl:choose>
    <xsl:when test="./SAMPLE_ATTRIBUTES">
     <xsl:for-each select="SAMPLE">
      <xsl:variable name="tags" select="key('TAGS-by-SAMPLE', .)" />
       <xsl:for-each select="TAGS-by-SAMPLE">       
        <xsl:value-of select="$tags[/TAG = current()]" /><xsl:text>&#9;</xsl:text>       
       </xsl:for-each>
     </xsl:for-each>
     <xsl:for-each select="./SAMPLE_ATTRIBUTES/SAMPLE_ATTRIBUTE/VALUE">    
      <xsl:value-of select="."/><xsl:text>&#9;</xsl:text>      
    </xsl:for-each>
 <!--    
    <xsl:for-each select="./SAMPLE_ATTRIBUTES/SAMPLE_ATTRIBUTE/UNITS">
      <td>
      <font face="Arial" size="2pt">
      <xsl:value-of select="."/><xsl:text>&#9;</xsl:text>
      </font>
      </td>
      </xsl:for-each>-->
     
    </xsl:when>
    <xsl:otherwise>
     <xsl:text></xsl:text><xsl:text>&#9;</xsl:text>
    </xsl:otherwise>
   </xsl:choose>
  <xsl:choose>
   <xsl:when test="@alias">
    <xsl:value-of select="@alias"/><xsl:text>&#9;</xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text></xsl:text><xsl:text>&#9;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>
<xsl:text>
</xsl:text> 
</xsl:template>


<xsl:template match="RUN_SET">


 <xsl:text>
</xsl:text>
 <xsl:text>Sample Name</xsl:text><xsl:text>&#9;</xsl:text>   
 <xsl:text>Protocol REF</xsl:text><xsl:text>&#9;</xsl:text>
 <xsl:text>Parameter Value[library strategy]</xsl:text><xsl:text>&#9;</xsl:text>
 <xsl:text>Parameter Value[library source]</xsl:text><xsl:text>&#9;</xsl:text>
 <xsl:text>Parameter Value[library selection]</xsl:text><xsl:text>&#9;</xsl:text>
 <xsl:text>Parameter Value[library layout]</xsl:text><xsl:text>&#9;</xsl:text>

 <xsl:for-each select="//TAG[generate-id(.)=generate-id(key('expprotlookupid',.)[1])]">
  <xsl:text>Parameter Value[</xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>]</xsl:text>
  <xsl:text>&#9;</xsl:text>
 </xsl:for-each>
 
 <!--<xsl:text>Parameter Value[target_taxon]</xsl:text><xsl:text>&#9;</xsl:text>
 <xsl:text>Parameter Value[target_gene]</xsl:text><xsl:text>&#9;</xsl:text>
 <xsl:text>Parameter Value[target_subfragment]</xsl:text><xsl:text>&#9;</xsl:text>
 <xsl:text>Parameter Value[pcr_primers]</xsl:text><xsl:text>&#9;</xsl:text>
 <xsl:text>Parameter Value[pcr_conditions]</xsl:text><xsl:text>&#9;</xsl:text>-->
<xsl:choose>
 <xsl:when test="contains(//DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_CONSTRUCTION_PROTOCOL/.,'target_taxon: ')">
  <xsl:text>Parameter Value[target_taxon]</xsl:text><xsl:text>&#9;</xsl:text>
 </xsl:when>
 <xsl:otherwise><xsl:text>??</xsl:text><xsl:text>&#9;</xsl:text></xsl:otherwise>
</xsl:choose>

 <xsl:if test="contains(//DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_CONSTRUCTION_PROTOCOL/.,'target_gene: ')">
  <xsl:text>Parameter Value[target_gene]</xsl:text><xsl:text>&#9;</xsl:text>
 </xsl:if>
 <xsl:if test="contains(//DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_CONSTRUCTION_PROTOCOL/.,'target_subfragment: ')">
  <xsl:text>Parameter Value[target_subfragment]</xsl:text><xsl:text>&#9;</xsl:text>
 </xsl:if>
 <xsl:if test="contains(//DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_CONSTRUCTION_PROTOCOL/.,'pcr_primers: ')">
  <xsl:text>Parameter Value[pcr_primers]</xsl:text><xsl:text>&#9;</xsl:text>
 </xsl:if>
 <xsl:if test="contains(//DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_CONSTRUCTION_PROTOCOL/.,'pcr_cond: ')">
  <xsl:text>Parameter Value[pcr_conditions]</xsl:text><xsl:text>&#9;</xsl:text>
 </xsl:if>           

 <xsl:text>Labeled Extract Name</xsl:text><xsl:text>&#9;</xsl:text> 
 <xsl:text>Protocol REF</xsl:text><xsl:text>&#9;</xsl:text>
 <xsl:text>Parameter Value[read information {index;type;class;base coord}]</xsl:text><xsl:text>&#9;</xsl:text>
 <xsl:text>Parameter Value[sequencing instrument]</xsl:text><xsl:text>&#9;</xsl:text>
 <xsl:text>Performer</xsl:text><xsl:text>&#9;</xsl:text>
 <xsl:text>Date</xsl:text><xsl:text>&#9;</xsl:text>
 <xsl:text>Assay Name</xsl:text><xsl:text>&#9;</xsl:text>
 <!--
    <xsl:for-each select="//TAG[generate-id(.)=generate-id(key('runtaglookupid',.)[1])]">
    <th><font color="#CCCCCC" face="Arial" size="2pt">
    <xsl:text>Parameter[</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>]</xsl:text>
    </font></th>
    </xsl:for-each>
   -->
 <xsl:text>Raw Data File</xsl:text><xsl:text>&#9;</xsl:text>
 <xsl:text>Comment[File checksum method]</xsl:text><xsl:text>&#9;</xsl:text>
 <xsl:text>Comment[File checksum]</xsl:text><xsl:text>&#9;</xsl:text>
<xsl:text>
</xsl:text>
 <xsl:apply-templates select="RUN"/> 
 </xsl:template>

 <xsl:template match="RUN">
 <xsl:choose>
<xsl:when test="child::EXPERIMENT_REF/@refname">
<xsl:value-of select="key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/SAMPLE_DESCRIPTOR/@refname"/><xsl:text>&#9;</xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:text></xsl:text><xsl:text>&#9;</xsl:text>
</xsl:otherwise>
</xsl:choose>
    
   
   
   
   <xsl:choose>
    <xsl:when test="child::EXPERIMENT_REF/@refname">
     <!--  <xsl:value-of select="key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_CONSTRUCTION_PROTOCOL"/> -->
     <xsl:text>library construction</xsl:text><xsl:text>&#9;</xsl:text>   
<xsl:value-of select="key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_STRATEGY/."/><xsl:text>&#9;</xsl:text>
<xsl:value-of select="key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_SOURCE/."/><xsl:text>&#9;</xsl:text>
<xsl:value-of select="key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_SELECTION/."/><xsl:text>&#9;</xsl:text>
   <xsl:choose>
     <xsl:when test="key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_LAYOUT/SINGLE">
      <xsl:text>SINGLE</xsl:text><xsl:text>&#9;</xsl:text>
     </xsl:when>
      <xsl:otherwise>
       <xsl:text>PAIRED</xsl:text><xsl:text>&#9;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
<xsl:if test="contains(key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_CONSTRUCTION_PROTOCOL/.,'target_taxon: ')">
 <xsl:value-of select="substring-before(substring-after(key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_CONSTRUCTION_PROTOCOL/.,'target_taxon: '),'&#xa;')"/><xsl:text>&#9;</xsl:text>
</xsl:if>     
<xsl:if test="key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/TARGETED_LOCI/LOCUS">
 <xsl:value-of select="key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/TARGETED_LOCI/LOCUS/@locus_name"/>
 <xsl:text> (</xsl:text>
 <xsl:value-of select="key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/TARGETED_LOCI/LOCUS/PROBE_SET/DB"/>
 <xsl:text>:</xsl:text>
 <xsl:value-of select="key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/TARGETED_LOCI/LOCUS/PROBE_SET/ID"/>
 <xsl:text>)</xsl:text> 
 <xsl:text>&#9;</xsl:text>
</xsl:if>
     
     <!--<xsl:if test="contains(key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_CONSTRUCTION_PROTOCOL/.,'target_gene: ')">
 <xsl:value-of select="substring-before(substring-after(key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_CONSTRUCTION_PROTOCOL/.,'target_gene: '),'&#xa;')"/><xsl:text>&#9;</xsl:text>
 </xsl:if>-->
<xsl:if test="contains(key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_CONSTRUCTION_PROTOCOL/.,'target_subfragment: ')">
 <xsl:value-of select="substring-before(substring-after(key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_CONSTRUCTION_PROTOCOL/.,'target_subfragment: '),'&#xa;')"/><xsl:text>&#9;</xsl:text>
</xsl:if>
<xsl:if test="contains(key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_CONSTRUCTION_PROTOCOL/.,'pcr_primers: ')">
 <xsl:value-of select="substring-before(substring-after(key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_CONSTRUCTION_PROTOCOL/.,'pcr_primers: '),'&#xa;')"/><xsl:text>&#9;</xsl:text>
</xsl:if>
<xsl:if test="contains(key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_CONSTRUCTION_PROTOCOL/.,'pcr_cond: ')">
 <xsl:value-of select="substring-after(key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_CONSTRUCTION_PROTOCOL/.,'pcr_cond: ')"/><xsl:text>&#9;</xsl:text>
</xsl:if>       
     <xsl:value-of select="child::EXPERIMENT_REF/@refname"/><xsl:text>&#9;</xsl:text>    
    </xsl:when>
   <xsl:otherwise>
     <xsl:text></xsl:text><xsl:text>&#9;</xsl:text>
    </xsl:otherwise>
   </xsl:choose>
   
   <!--   <xsl:choose>
    <xsl:when test="./RUN_ATTRIBUTES">
    
    <xsl:for-each select="RUN">
    <xsl:variable name="tags" select="key('TAGS-by-RUN', .)" />
    <tr>
    <xsl:for-each select="TAGS-by-RUN">
    <td>
    <xsl:value-of select="$tags[/TAG = current()]" />
    </td>
    </xsl:for-each>
    </tr>
    </xsl:for-each>
    <xsl:for-each select="./RUN_ATTRIBUTES/RUN_ATTRIBUTE/VALUE">
    <td>
    <font face="Arial" size="2pt">
    <xsl:value-of select="."/>
    </font>
    </td>
    </xsl:for-each>
   -->
   <!--
    <xsl:for-each select="./SAMPLE_ATTRIBUTES/SAMPLE_ATTRIBUTE/UNITS">
    <td>
    <font face="Arial" size="2pt">
    <xsl:value-of select="."/>
    </font>
    </td>
    </xsl:for-each>-->
   <!--
    </xsl:when>
    <xsl:otherwise>
    <td><font face="Arial" size="2pt">-</td>
    </xsl:otherwise>
    </xsl:choose>
   -->
   <xsl:choose>
    <xsl:when test="key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/SPOT_DESCRIPTOR">
<xsl:text>Sequencing Protocol</xsl:text><xsl:text>&#9;</xsl:text>     
      <xsl:for-each select="key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/SPOT_DESCRIPTOR/SPOT_DECODE_SPEC/READ_SPEC"><xsl:value-of select="child::READ_INDEX/."/>;<xsl:value-of select="child::READ_CLASS/."/>;<xsl:value-of select="child::READ_TYPE/."/>;<xsl:value-of select="child::BASE_COORD/."/>|</xsl:for-each> 
<xsl:text>&#9;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
     <xsl:text></xsl:text><xsl:text>&#9;</xsl:text>
    </xsl:otherwise>
   </xsl:choose>
   
   <xsl:choose>
    <xsl:when test="key('exptlookupid',child::EXPERIMENT_REF/@refname)/PLATFORM//INSTRUMENT_MODEL">
     <xsl:value-of select="key('exptlookupid',child::EXPERIMENT_REF/@refname)/PLATFORM//INSTRUMENT_MODEL/."/><xsl:text>&#9;</xsl:text>   
    </xsl:when>
    <xsl:otherwise>
     <xsl:text></xsl:text><xsl:text>&#9;</xsl:text>
    </xsl:otherwise>
   </xsl:choose>
     
   <xsl:choose>
    <xsl:when test="@run_center">
<xsl:value-of select="@run_center"/><xsl:text>&#9;</xsl:text>    
    </xsl:when>
    <xsl:otherwise>
     <xsl:text></xsl:text><xsl:text>&#9;</xsl:text>
    </xsl:otherwise>
   </xsl:choose> 
   <xsl:choose>
    <xsl:when test="@run_date">
     <xsl:value-of select="@run_date"/><xsl:text>&#9;</xsl:text>    
    </xsl:when>
    <xsl:otherwise>
<xsl:text></xsl:text><xsl:text>&#9;</xsl:text>
    </xsl:otherwise>
   </xsl:choose>  
   <xsl:choose>
    <xsl:when test="@alias">
       <xsl:value-of select="@alias"/><xsl:text>&#9;</xsl:text>  
    </xsl:when>
    <xsl:otherwise>
 <xsl:text></xsl:text><xsl:text>&#9;</xsl:text>
    </xsl:otherwise>
   </xsl:choose> 
           
   <xsl:choose>
    <xsl:when test="child::DATA_BLOCK/FILES/FILE/@filename">
     <xsl:value-of select="child::DATA_BLOCK/FILES/FILE/@filename"/><xsl:text>&#9;</xsl:text>     
     <xsl:value-of select="key('filelookupid',child::DATA_BLOCK/FILES/FILE/@filename)/@checksum_method"/><xsl:text>&#9;</xsl:text>    
     <xsl:value-of select="key('filelookupid',child::DATA_BLOCK/FILES/FILE/@filename)/@checksum"/><xsl:text>&#9;</xsl:text> 
    </xsl:when>
    <xsl:when test="contains((child::RUN_LINKS/RUN_LINK/XREF_LINK/DB)[4],'ENA-FASTQ-FILES')"> 
      <xsl:value-of select="(child::RUN_LINKS/RUN_LINK/XREF_LINK/ID)[4]"/>
     </xsl:when>
    <xsl:otherwise>
     <xsl:text></xsl:text><xsl:text>&#9;</xsl:text>	
    </xsl:otherwise>
   </xsl:choose>
  
 
<xsl:text>
</xsl:text>
 </xsl:template>
 
</xsl:stylesheet>