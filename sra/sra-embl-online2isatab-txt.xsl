<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#160;">
  <!ENTITY copy "&#169;">
]>

<!--xsl stylesheet prototype for rendering SRA XML documents to ISA-Tab representation:

Authors: 
Philippe Rocca-Serra, University of Oxford e-Research Centre (philippe.rocca-serra@oerc.ox.ac.uk);
Alfie Abdul-Rahman, University of Oxford e-Research Centre (alfie.abdulrahman@oerc.ox.ac.uk) 

test datasets:
SRA030397 -> targeted metagenomics application
SRA000266 -> targeted metagenomics application
ERA148766 -> 

representing submission 

SRA schema version considered:

 <xsl:import-schema schema-location="ftp://ftp.sra.ebi.ac.uk/meta/xsd/sra_1_5/SRA.submission.xsd"/>
 <xsl:import-schema schema-location="ftp://ftp.sra.ebi.ac.uk/meta/xsd/sra_1_5/SRA.study.xsd"/>
 <xsl:import-schema schema-location="ftp://ftp.sra.ebi.ac.uk/meta/xsd/sra_1_5/SRA.sample.xsd"/>
 <xsl:import-schema schema-location="ftp://ftp.sra.ebi.ac.uk/meta/xsd/sra_1_5/SRA.experiment.xsd"/>
 <xsl:import-schema schema-location="ftp://ftp.sra.ebi.ac.uk/meta/xsd/sra_1_5/SRA.run.xsd"/>

-->


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
 <xsl:output method="text" encoding="UTF-8"/>
 <xsl:strip-space elements="*"/>

 <!-- The input parameter from the command line -->
 <xsl:param name="acc-number" required="yes"/>

 <xsl:key name="samplelookupid" match="SAMPLE" use="@alias"/>
 <xsl:key name="sampletaglookupid" match="/ROOT/SAMPLE/SAMPLE_ATTRIBUTES/SAMPLE_ATTRIBUTE/TAG" use="."/>
 <xsl:key name="samplevallookupid" match="/ROOT/SAMPLE/SAMPLE_ATTRIBUTES/SAMPLE_ATTRIBUTE/VALUE" use="."/>
 <xsl:key name="sampleunitlookupid" match="/ROOT/SAMPLE/SAMPLE_ATTRIBUTES/SAMPLE_ATTRIBUTE/UNITS" use="."/>
 <xsl:key name="exptlookupid" match="EXPERIMENT" use="@alias"/>
 <xsl:key name="samplereflookupid" match="SAMPLE_DESCRIPTOR" use="@refname"/>
 <xsl:key name="libnamelookupid" match="LIBRARY_NAME" use="."/>
 <xsl:key name="libstratlookupid" match="LIBRARY_STRATEGY" use="."/>
 <xsl:key name="libsrclookupid" match="LIBRARY_SOURCE" use="."/>
 <xsl:key name="libseleclookupid" match="LIBRARY_SELECTION" use="."/>
 <xsl:key name="protocols" match="LIBRARY_CONSTRUCTION_PROTOCOL" use="."/>
 <xsl:key name="expprotlookupid" match="/ROOT/EXPERIMENT/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_CONSTRUCTION_PROTOCOL" use="."/>
 <xsl:key name="instrumentlookupid" match="INSTRUMENT_MODEL" use="."/>
 <xsl:key name="TAGS-by-SAMPLE" match="TAG" use="preceding-sibling::SAMPLE_ATTRIBUTES/SAMPLE_ATTRIBUTE/TAG[1]"/>
 <xsl:key name="TAGS-by-RUN" match="TAG" use="preceding-sibling::RUN_ATTRIBUTES/RUN_ATTRIBUTE/TAG[1]"/>
 <xsl:key name="runtaglookupid" match="/ROOT/RUN/RUN_ATTRIBUTES/RUN_ATTRIBUTE/TAG" use="."/>
 <xsl:key name="runvallookupid" match="/ROOT/RUN/RUN_ATTRIBUTES/RUN_ATTRIBUTE/VALUE" use="."/>
 <xsl:key name="rununitlookupid" match="/ROOT/RUN/RUN_ATTRIBUTES/RUN_ATTRIBUTE/UNITS" use="."/>
 <xsl:key name="filelookupid" match="FILE" use="@filename"/>
 <!--<xsl:key name="SamplebySampleAttributesbyTag" match="SAMPLE" use="concat(SAMPLE_ATTRIBUTES,'::',SAMPLE_ATTRIBUTE,'::',TAG)"/>-->
 

 <xsl:variable name="url" select="concat('http://www.ebi.ac.uk/ena/data/view/', $acc-number, '&amp;display=xml')"/>

 <xsl:variable name="protocols" select="//LIBRARY_CONSTRUCTION_PROTOCOL[generate-id() = generate-id(key('protocols',.)[1])]"/>

 <xsl:template match="/">
  <xsl:apply-templates select="document($url)" mode="go"/>
 </xsl:template>

 <xsl:template match="ROOT" mode="go">
  <xsl:apply-templates select="SUBMISSION"/>
  <!-- <xsl:apply-templates select="SUBMISSION_LINK"/> -->
  <!--<xsl:apply-templates select="SAMPLE"/>
  <xsl:apply-templates select="RUN"/>-->
 </xsl:template>
 
 <xsl:template match="SUBMISSION">
  <xsl:variable name="broker-name" select="@broker_name"/>
  <xsl:apply-templates>
   <xsl:with-param name="broker-name" select="$broker-name" tunnel="yes"/>
  </xsl:apply-templates>
 </xsl:template>
 
 <xsl:template match="XREF_LINK/DB[contains(.,'NA-STUDY')]">
  <xsl:param name="broker-name" required="yes" tunnel="yes"/>
  <xsl:variable name="study" select="following-sibling::ID"/>
  <xsl:result-document href="{concat('i_', $acc-number, '.txt')}" method="text">
   <xsl:text>#SRA Document:&#10;</xsl:text>
   <xsl:value-of select="@identifier"/>
   <xsl:text>ONTOLOGY SOURCE REFERENCE&#10;</xsl:text>
   <xsl:text>Term Source Name&#9;</xsl:text>
   <xsl:text>ENA-CV&#10;</xsl:text>
   <xsl:text>Term Source File&#9;</xsl:text>
   <xsl:text>ENA-CV.obo&#10;</xsl:text>
   <xsl:text>Term Source Version&#9;</xsl:text>
   <xsl:text>1&#10;</xsl:text>
   <xsl:text>Term Source Description&#9;</xsl:text>
   <xsl:text>Controlled Terminology for SRA/ENA schema</xsl:text>
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
   <xsl:text>Comment[SRA broker]&#9;</xsl:text>  
   <xsl:value-of select="$broker-name"/>
   <xsl:text>
</xsl:text>
   <xsl:apply-templates select="document(concat('http://www.ebi.ac.uk/ena/data/view/',$study,'&amp;display=xml'))/ROOT/STUDY"/>
   <xsl:text>
</xsl:text>
   
   <xsl:if test="child::CONTACTS/CONTACT">
    <xsl:text>Person Last Name</xsl:text>
    <xsl:value-of select="substring-before(child::CONTACTS/CONTACT/@name,' ')"/>
    <xsl:text>
</xsl:text>
   </xsl:if>
   <xsl:if test="child::CONTACTS/CONTACT">
    <xsl:text>Person First Name</xsl:text>
    <xsl:value-of select="substring-after(child::CONTACTS/CONTACT/@name,' ')"/>
    <xsl:text>
</xsl:text>
   </xsl:if>
   <xsl:text>Person Mid Initials</xsl:text>
   <xsl:text>
</xsl:text>
   <xsl:if test="child::CONTACTS/CONTACT">
    <xsl:text>Person Email</xsl:text>
    <xsl:value-of select="child::CONTACTS/CONTACT/@inform_on_status"/>
   </xsl:if>
   <xsl:text>
</xsl:text>
   <xsl:if test="child::CONTACTS/CONTACT">
    <xsl:text>Person Phone</xsl:text>
    <xsl:text>-</xsl:text>
   </xsl:if>
   <xsl:text>
</xsl:text>
   <xsl:if test="child::CONTACTS/CONTACT">
    <xsl:text>Person Fax</xsl:text>
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
  </xsl:result-document>
 </xsl:template>
 
 <xsl:template match="XREF_LINK/DB[contains(.,'NA-SAMPLE')]">  
  <xsl:result-document href="{concat('s_', $acc-number, '.txt')}" method="text">
   <xsl:variable name="samples" select="following-sibling::ID"/>
   <xsl:text>Source Name&#9;</xsl:text>
   <xsl:text>Characteristics[Primary Accession Number]&#9;</xsl:text>
   <xsl:text>Comment[Scientific Name]&#9;</xsl:text>
   <xsl:text>Characteristics[Taxonomic ID]&#9;</xsl:text>
   <xsl:text>Characteristics[Description]&#9;</xsl:text>
   <xsl:for-each select="document(concat('http://www.ebi.ac.uk/ena/data/view/', $samples, '&amp;display=xml'))/ROOT/SAMPLE/SAMPLE_ATTRIBUTES/SAMPLE_ATTRIBUTE/TAG[generate-id(.)=generate-id(key('sampletaglookupid',.)[1])]">
    <xsl:text>Characteristics[</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>]&#9;</xsl:text>
   </xsl:for-each>
   <xsl:text>Sample Name&#10;</xsl:text>
   <xsl:apply-templates select="document(concat('http://www.ebi.ac.uk/ena/data/view/', $samples, '&amp;display=xml'))/ROOT/SAMPLE"/>
   <xsl:text>&#9;</xsl:text>
  </xsl:result-document>
 </xsl:template>
 
 <xsl:template match="XREF_LINK/DB[contains(.,'NA-EXPERIMENT')]">
  <xsl:result-document href="{concat('a_', $acc-number, '.txt')}" method="text">
   <xsl:variable name="experiments" select="following-sibling::ID"/>
   <xsl:variable name="exp" select="document(concat('http://www.ebi.ac.uk/ena/data/view/', $experiments, '&amp;display=xml'))"/>
   <!--<xsl:value-of select="$exp"></xsl:value-of>-->
   <xsl:text>Sample Name&#9;</xsl:text>
   <xsl:text>Protocol REF&#9;</xsl:text>
   <xsl:text>Parameter Value[library strategy]&#9;</xsl:text>
   <xsl:text>Parameter Value[library source]&#9;</xsl:text>
   <xsl:text>Parameter Value[library selection]&#9;</xsl:text>
   <xsl:text>Parameter Value[library layout]&#9;</xsl:text>
   <xsl:if test="contains($exp,'target_taxon: ')">
    <xsl:text>Parameter Value[target_taxon]&#9;</xsl:text>
   </xsl:if>
   <xsl:if test="contains($exp,'target_gene: ')">
    <xsl:text>Parameter Value[target_gene]&#9;</xsl:text>
   </xsl:if>
   <xsl:if test="contains($exp,'target_subfragment: ')">
    <xsl:text>Parameter Value[target_subfragment]&#9;</xsl:text>
   </xsl:if>
  
   <xsl:if test="contains($exp,'mid: ')">
    <xsl:text>Parameter Value[multiplex identifier]&#9;</xsl:text>
   </xsl:if>
   
   <xsl:if test="contains($exp,'pcr_primers: ')">
    <xsl:text>Parameter Value[pcr_primers]&#9;</xsl:text>
   </xsl:if>
   <xsl:if test="contains($exp,'pcr_cond: ')">
    <xsl:text>Parameter Value[pcr_conditions]&#9;</xsl:text>
   </xsl:if>
   <xsl:text>Labeled Extract Name&#9;</xsl:text>
   <xsl:text>Protocol REF&#9;</xsl:text>
   <xsl:text>Parameter Value[read information {index;type;class;base coord}]&#9;</xsl:text>
   <xsl:text>Parameter Value[sequencing instrument]&#9;</xsl:text>
   <xsl:text>Performer&#9;</xsl:text>
   <xsl:text>Date&#9;</xsl:text>
   <xsl:text>Assay Name&#9;</xsl:text>
   <xsl:text>Raw Data File&#9;</xsl:text>
   <xsl:text>Comment[File checksum]&#9;</xsl:text>
   <xsl:text>Comment[File checksum method]&#10;</xsl:text>
   <xsl:apply-templates select="document(concat('http://www.ebi.ac.uk/ena/data/view/', $experiments, '&amp;display=xml'))/ROOT/EXPERIMENT"/>
   <xsl:text>&#9;</xsl:text>   

  </xsl:result-document>
 </xsl:template>
 
 <xsl:template match="STUDY">
   <xsl:text>Study Identifier&#9;</xsl:text>
   <xsl:choose>
    <xsl:when test="@accession">
     <xsl:value-of select="@accession"/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:text>-</xsl:text>
    </xsl:otherwise>
   </xsl:choose>
   <xsl:text>&#10;</xsl:text>

   <xsl:text>Study Title&#9;</xsl:text>
   <xsl:value-of select="DESCRIPTOR/STUDY_TITLE"/>
   <xsl:text>&#10;</xsl:text>
 
   <xsl:text>Study Description&#9;</xsl:text>
   <xsl:value-of select="DESCRIPTOR/STUDY_ABSTRACT"/>
   <xsl:value-of select="substring-before(DESCRIPTOR/STUDY_DESCRIPTION,'\r')"/>    
   <xsl:text>&#10;</xsl:text>

   <xsl:text>Study Submission Date&#9;</xsl:text>
   <xsl:value-of select="SRA/SUBMISSION/@submission_date"/>   
   <xsl:text>&#10;</xsl:text>

   <xsl:text>Study Public Release Date&#9;</xsl:text>
   <xsl:value-of select="SRA/SUBMISSION/@submission_date"/>
   <xsl:text>&#10;</xsl:text>
   <xsl:text>Study File Name&#10;</xsl:text>
  
   <xsl:text>STUDY DESIGN DESCRIPTORS&#10;</xsl:text>

   <xsl:if test="child::DESCRIPTOR/STUDY_TYPE">
    <xsl:text>Study Design Type&#9;</xsl:text>
    <xsl:value-of select="child::DESCRIPTOR/STUDY_TYPE/@existing_study_type"/>
   </xsl:if>
   <xsl:text>&#10;</xsl:text>
   <xsl:text>Study Design Type Term Accession Number</xsl:text>
   <xsl:text>&#10;</xsl:text>
   <xsl:text>Study Design Type Term Source REF</xsl:text>
   <xsl:text>
STUDY PUBLICATIONS
Study PubMed ID&#9;</xsl:text>
   <xsl:for-each select="child::STUDY_LINKS/STUDY_LINK/XREF_LINK/DB">
    <xsl:if test="contains(., 'pubmed')">
     <xsl:value-of select="following-sibling::ID/."/>
     <xsl:text>&#9;</xsl:text>
    </xsl:if>
   </xsl:for-each>
   <xsl:text>
Study Publication DOI
Study Publication Author List
Study Publication Title
Study Publication Status
Study Publication Status Term Accession Number
Study Publication Status Term Source REF 
</xsl:text>
   <xsl:text>STUDY FACTORS&#10;</xsl:text>
   <xsl:text>Study Factor Name&#10;</xsl:text>
   <xsl:text>Study Factor Type&#10;</xsl:text>
   <xsl:text>Study Factor Type Term Accession Number&#10;</xsl:text>
   <xsl:text>Study Factor Type Term Source REF&#10;</xsl:text>
   <xsl:text>STUDY ASSAYS&#10;</xsl:text>
   <xsl:text>Study Assay Measurement Type</xsl:text>
   <xsl:for-each select="//LIBRARY_SOURCE[generate-id(.)=generate-id(key('libsrclookupid',.)[1])]">
    <xsl:value-of select="."/>
   </xsl:for-each>
   <xsl:text>&#10;</xsl:text>

   <xsl:text>Study Assay Measurement Type Term Accession Number&#9;</xsl:text>
   <xsl:text>ENA:0000019&#9;</xsl:text>
   <xsl:text>ENA:0000020</xsl:text>
   <xsl:text>&#10;</xsl:text>

   <xsl:text>Study Assay Measurement Type Term Source REF&#9;</xsl:text>
   <xsl:text>ENA&#9;</xsl:text>
   <xsl:text>ENA</xsl:text>
   <xsl:text>&#10;</xsl:text>

   <xsl:text>Study Assay Technology Type</xsl:text>
   <xsl:for-each select="//LIBRARY_STRATEGY[generate-id(.)=generate-id(key('libstratlookupid',.)[1])]">
    <xsl:value-of select="."/>
   </xsl:for-each>
   <xsl:text>&#10;</xsl:text>

   <xsl:text>Study Assay Technology Type Term Accession Number&#9;</xsl:text>
   <xsl:text>ENA:0000044&#9;</xsl:text>
   <xsl:text>ENA:0000054</xsl:text>
   <xsl:text>&#10;</xsl:text>

   <xsl:text>Study Assay Technology Type Term Source REF</xsl:text>
   <xsl:text>&#9;</xsl:text>
   <xsl:text>ENA</xsl:text>
   <xsl:text>&#9;</xsl:text>
   <xsl:text>ENA&#10;</xsl:text>

   <xsl:text>Study Assay File Names&#10;</xsl:text>
   <xsl:text>STUDY PROTOCOLS&#10;</xsl:text>
   <xsl:text>Study Protocol Name&#10;</xsl:text>
   <xsl:text>Study Protocol Type&#9;</xsl:text>
   <xsl:text>library construction&#10;</xsl:text>
   <xsl:text>Study Protocol Type Term Accession Number&#10;</xsl:text>
   <xsl:text>Study Protocol Type Term Source REF&#10;</xsl:text>
   <xsl:text>Study Protocol Description</xsl:text>
   <xsl:for-each select="//LIBRARY_CONSTRUCTION_PROTOCOL[generate-id(.)=generate-id(key('expprotlookupid',.)[1])]">
    <xsl:value-of select="substring-before(substring-after(.,'&#xa;'),'&#xa;')"/>
   </xsl:for-each>
   <xsl:text>&#10;</xsl:text>
   <xsl:text>STUDY CONTACTS&#10;</xsl:text>
 </xsl:template>

<!-- <xsl:template match="EXPERIMENT" mode="gamma">
  <xsl:apply-templates select="EXPERIMENT"/>
  <xsl:text>
</xsl:text>
 </xsl:template>

 <xsl:template match="SAMPLE" mode="beta">
  <xsl:text>
</xsl:text>
  <xsl:apply-templates select="SAMPLE"/>
 </xsl:template>-->

 <xsl:template match="SAMPLE">
  <xsl:choose>
   <xsl:when test="@alias">
    <xsl:value-of select="@alias"/>
    <xsl:text>&#9;</xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text/>
    <xsl:text>&#9;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
   <xsl:when test="@accession">
    <xsl:value-of select="@accession"/>
    <xsl:text>&#9;</xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text/>
    <xsl:text>&#9;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
   <xsl:when test="./SAMPLE_NAME/COMMON_NAME">
    <xsl:value-of select="./SAMPLE_NAME/COMMON_NAME/."/>
    <xsl:text>&#9;</xsl:text>
   </xsl:when>
   <xsl:when test="./SAMPLE_NAME/SCIENTIFIC_NAME">
    <xsl:value-of select="./SAMPLE_NAME/SCIENTIFIC_NAME/."/>
    <xsl:text>&#9;</xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text/>
    <xsl:text>&#9;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
   <xsl:when test="./SAMPLE_NAME/TAXON_ID">
    <!-- <xsl:param name="url" select="./SAMPLE_NAME/TAXON_ID/."></xsl:param> -->

    <!-- <a href="http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id={$url}" target="_blank">-->
    <xsl:value-of select="./SAMPLE_NAME/TAXON_ID/."/>
    <xsl:text>&#9;</xsl:text>
    <!-- </a> -->
   </xsl:when>
   <xsl:otherwise>
    <xsl:text/>
    <xsl:text>&#9;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
   <xsl:when test="./DESCRIPTION">
    <xsl:value-of select="substring-before(./DESCRIPTION/.,'&#xa;')"/>
    <xsl:text>&#9;</xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text/>
    <xsl:text>&#9;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
   <xsl:when test="./SAMPLE_ATTRIBUTES">
    <xsl:for-each select="SAMPLE">
     <xsl:variable name="tags" select="key('TAGS-by-SAMPLE', .)"/>
     <xsl:for-each select="TAGS-by-SAMPLE">
      <xsl:value-of select="$tags[/TAG = current()]"/>
      <xsl:text>&#9;</xsl:text>
     </xsl:for-each>
    </xsl:for-each>
    <xsl:for-each select="./SAMPLE_ATTRIBUTES/SAMPLE_ATTRIBUTE/VALUE">
     <xsl:value-of select="."/>
     <xsl:text>&#9;</xsl:text>
    </xsl:for-each>

    <!--<xsl:for-each select="./SAMPLE_ATTRIBUTES/SAMPLE_ATTRIBUTE/UNITS">
      <td>
      <font face="Arial" size="2pt">
      <xsl:value-of select="."/>
      </font>
      </td>
      </xsl:for-each>-->

   </xsl:when>
   <xsl:otherwise>
    <xsl:text/>
    <xsl:text>&#9;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
   <xsl:when test="@alias">
    <xsl:value-of select="@alias"/>
    <xsl:text>&#9;</xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text/>
    <xsl:text>&#9;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>
  <xsl:text>
</xsl:text>
  <!--  </xsl:for-each> -->
 </xsl:template>


 <xsl:template match="EXPERIMENT">
  
<!--   <xsl:choose>
  <xsl:when test="@alias">
   <xsl:value-of select="@alias"/><xsl:text>&#9;</xsl:text>
  </xsl:when>
  <xsl:otherwise>
   <xsl:text></xsl:text><xsl:text>&#9;</xsl:text>
  </xsl:otherwise>
 </xsl:choose>-->

  <xsl:choose>
   <xsl:when test="child::DESIGN/SAMPLE_DESCRIPTOR">
    <xsl:value-of select="child::DESIGN/SAMPLE_DESCRIPTOR/@refname"/>
    <xsl:text>&#9;</xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text/>
    <xsl:text>&#9;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>


  <xsl:text>library preparation</xsl:text>
  <xsl:text>&#9;</xsl:text>

  <!-- <xsl:choose>
  <xsl:when test="./DESIGN/SAMPLE_DESCRIPTOR">
   <xsl:text></xsl:text><xsl:value-of select="./DESIGN/SAMPLE_DESCRIPTOR/@refname"/><xsl:text>&#9;</xsl:text>
  </xsl:when>
  <xsl:otherwise>
   <xsl:text></xsl:text><xsl:text>&#9;</xsl:text>
  </xsl:otherwise>
 </xsl:choose>
 
 <xsl:choose>
  <xsl:when test="./DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_NAME">
   <xsl:value-of select="./DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_NAME/."/><xsl:text>&#9;</xsl:text>
  </xsl:when>
   <xsl:otherwise>
    <xsl:text></xsl:text><xsl:text>&#9;</xsl:text>
   </xsl:otherwise>
 </xsl:choose>-->



  <xsl:choose>
   <xsl:when test="child::DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_STRATEGY">
    <xsl:value-of select="child::DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_STRATEGY/."/>
    <xsl:text>&#9;</xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text/>
    <xsl:text>&#9;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
   <xsl:when test="child::DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_SOURCE">
    <xsl:value-of select="child::DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_SOURCE/."/>
    <xsl:text>&#9;</xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text/>
    <xsl:text>&#9;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
   <xsl:when test="child::DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_SELECTION">
    <xsl:value-of select="child::DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_SELECTION/."/>
    <xsl:text>&#9;</xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text/>
    <xsl:text>&#9;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
   <xsl:when test="child::DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_LAYOUT/SINGLE">
    <xsl:text>single&#9;</xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text/>
    <xsl:text>&#9;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
   <xsl:when test="contains(child::DESIGN/DESIGN_DESCRIPTION/.,'target_taxon: ')">
    <xsl:value-of
     select="substring-before(substring-after(child::DESIGN/DESIGN_DESCRIPTION/.,'target_taxon: '),'target_gene:')"/>
    <xsl:text>&#9;</xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text/>
    <xsl:text>&#9;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
   <xsl:when test="child::DESIGN/LIBRARY_DESCRIPTOR/TARGETED_LOCI">
    <xsl:if test="child::DESIGN/LIBRARY_DESCRIPTOR/TARGETED_LOCI/LOCUS">
     <xsl:value-of select="child::DESIGN/LIBRARY_DESCRIPTOR/TARGETED_LOCI/LOCUS/@locus_name"/>
     <xsl:text>&#9;</xsl:text>
    </xsl:if>
   </xsl:when>
   <xsl:otherwise>
    <xsl:choose>
     <xsl:when  test="contains(child::DESIGN/DESIGN_DESCRIPTION/.,'target_gene: ')">
      <xsl:value-of
       select="substring-before(substring-after(child::DESIGN/DESIGN_DESCRIPTION/.,'target_gene: '),'target_subfragment:')"/>
      <xsl:text>&#9;</xsl:text>
     </xsl:when>
     <xsl:otherwise>
      <xsl:text/>
      <xsl:text>NULL</xsl:text>
      <xsl:text>&#9;</xsl:text>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:otherwise>
  </xsl:choose>



  
  <xsl:choose>
   <xsl:when  test="contains(child::DESIGN/DESIGN_DESCRIPTION/.,'target_subfragment: ')">
   <xsl:value-of
    select="substring-before(substring-after(child::DESIGN/DESIGN_DESCRIPTION/.,'target_subfragment: '),'mid:')"/>
   <xsl:text>&#9;</xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text/>
    <xsl:text>&#9;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>
  
  <xsl:choose>
   <xsl:when  test="contains(child::DESIGN/DESIGN_DESCRIPTION/.,'mid: ')">
    <xsl:value-of
     select="substring-before(substring-after(child::DESIGN/DESIGN_DESCRIPTION/.,'mid: '),'pcr_primers:')"/>
    <xsl:text>&#9;</xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text/>
    <xsl:text>&#9;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>
  
  
  <xsl:choose>
   <xsl:when test="child::DESIGN/LIBRARY_DESCRIPTOR/TARGETED_LOCI">
    <xsl:if test="child::DESIGN/LIBRARY_DESCRIPTOR/TARGETED_LOCI/LOCUS">
     <xsl:text>(</xsl:text>
     <xsl:value-of select="child::DESIGN/LIBRARY_DESCRIPTOR/TARGETED_LOCI/LOCUS/PROBE_SET/DB"/>
     <xsl:text>:</xsl:text>
     <xsl:value-of select="child::DESIGN/LIBRARY_DESCRIPTOR/TARGETED_LOCI/LOCUS/PROBE_SET/ID"/>
     <xsl:text>) </xsl:text>
    </xsl:if>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>NULL</xsl:text>
    <xsl:text></xsl:text>
   </xsl:otherwise>
  </xsl:choose> 
    

      <xsl:choose>
       <xsl:when  test="contains(child::DESIGN/DESIGN_DESCRIPTION/.,'pcr_primers: ')">
   <xsl:value-of
    select="substring-before(substring-after(child::DESIGN/DESIGN_DESCRIPTION/.,'pcr_primers: '),'pcr_cond:')"/>
   <xsl:text>&#9;</xsl:text>
       </xsl:when>
       <xsl:otherwise>
        <xsl:text/>
        <xsl:text>&#9;</xsl:text>
       </xsl:otherwise>
      </xsl:choose>
        <xsl:choose>
         <xsl:when  test="contains(child::DESIGN/DESIGN_DESCRIPTION/.,'pcr_cond: ')">
   <xsl:value-of select="substring-after(child::DESIGN/DESIGN_DESCRIPTION/.,'pcr_cond: ')"/>
   <xsl:text>&#9;</xsl:text>
         </xsl:when>
         <xsl:otherwise>
          <xsl:text/>
          <xsl:text>&#9;</xsl:text>
         </xsl:otherwise>
        </xsl:choose>

  <xsl:choose>
   <xsl:when test="child::DESIGN/SAMPLE_DESCRIPTOR">
    <xsl:value-of select="@accession"/>
    <xsl:text>&#9;</xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text/>
    <xsl:text>&#9;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
   <xsl:when test="child::DESIGN/SPOT_DESCRIPTOR">
    <xsl:text>Sequencing Protocol</xsl:text>
    <xsl:text>&#9;</xsl:text>
    <xsl:for-each select="child::DESIGN/SPOT_DESCRIPTOR/SPOT_DECODE_SPEC/READ_SPEC">
     <xsl:value-of select="child::READ_INDEX/."/>;<xsl:value-of select="child::READ_CLASS/."
      />;<xsl:value-of select="child::READ_TYPE/."/>;<xsl:value-of select="child::BASE_COORD/."
     />|</xsl:for-each>
    <xsl:text>&#9;</xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text/>
    <xsl:text>&#9;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
   <xsl:when test="child::PLATFORM//INSTRUMENT_MODEL/.">
    <xsl:value-of select="child::PLATFORM//INSTRUMENT_MODEL/."/>
    <xsl:text>&#9;</xsl:text>
   </xsl:when>
  </xsl:choose>

<!-- a TAB as placeholder for Performer-->
  <xsl:text>&#9;</xsl:text>
<!-- another TAB as placeholder for Date--> 
  <xsl:text>&#9;</xsl:text>

  <xsl:choose>
   <xsl:when test="@accession">
    <xsl:value-of select="@accession"/>
    <xsl:text>&#9;</xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text/>
    <xsl:text>&#9;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
   <xsl:when test="child::EXPERIMENT_LINKS/EXPERIMENT_LINK/XREF_LINK">
    <xsl:for-each select="child::EXPERIMENT_LINKS/EXPERIMENT_LINK/XREF_LINK/DB/.">
     <xsl:if test="contains(., 'ENA-FASTQ-FILES')">
      <xsl:variable name="file" select="following-sibling::ID/."/>
<!--       <xsl:value-of select="following-sibling::ID/."/>-->
      <xsl:if test="contains($file,'&amp;result=read_run&amp;fields=run_accession,fastq_ftp')"> <!--result=read_run&amp;fields=run_accession-->
       <xsl:variable name="base" select="substring-before($file,'&amp;result=read_run&amp;fields=run_accession,fastq_ftp')"></xsl:variable>
       <xsl:variable name="link" select="concat($base,'&amp;result=read_run&amp;fields=fastq_ftp,fastq_md5')"></xsl:variable>
       <xsl:variable name="parsedlink" select="unparsed-text($link)"/>
<!--       <xsl:value-of select="unparsed-text($link)"></xsl:value-of>-->
       <xsl:for-each select="tokenize($parsedlink, '\n')">
        
        <xsl:if test="not(contains(.,'fastq_ftp'))">
         <xsl:for-each select="tokenize(., '\t')">

          <xsl:value-of select="."/>   <xsl:text>&#9;</xsl:text> 
          
         </xsl:for-each>
        </xsl:if>
       </xsl:for-each>   
<!--       <xsl:value-of select="$link"></xsl:value-of>-->
       
       <xsl:text>&#9;</xsl:text>
      </xsl:if>
     </xsl:if>
    </xsl:for-each>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text/>
    <xsl:text>&#9;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>
  <xsl:text>md5</xsl:text>
  <xsl:text>
</xsl:text>

 </xsl:template>
 
 <xsl:template name="embl_file_processing"></xsl:template>
</xsl:stylesheet>
