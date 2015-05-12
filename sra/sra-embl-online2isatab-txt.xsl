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
SRA095866 ->

representing submission 

SRA schema version considered:

 <xsl:import-schema schema-location="ftp://ftp.sra.ebi.ac.uk/meta/xsd/sra_1_5/SRA.submission.xsd"/>
 <xsl:import-schema schema-location="ftp://ftp.sra.ebi.ac.uk/meta/xsd/sra_1_5/SRA.study.xsd"/>
 <xsl:import-schema schema-location="ftp://ftp.sra.ebi.ac.uk/meta/xsd/sra_1_5/SRA.sample.xsd"/>
 <xsl:import-schema schema-location="ftp://ftp.sra.ebi.ac.uk/meta/xsd/sra_1_5/SRA.experiment.xsd"/>
 <xsl:import-schema schema-location="ftp://ftp.sra.ebi.ac.uk/meta/xsd/sra_1_5/SRA.run.xsd"/>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
 <xsl:import href="extract-studies.xsl"/>
 <xsl:output method="text" encoding="UTF-8"/>
 <xsl:strip-space elements="*"/>

 <!-- The input parameter from the command line -->
 <xsl:param name="acc-number" required="yes"/>

 <xsl:key name="protocols" match="LIBRARY_CONSTRUCTION_PROTOCOL" use="."/>
 <xsl:key name="sampletaglookupid" match="/ROOT/SAMPLE/SAMPLE_ATTRIBUTES/SAMPLE_ATTRIBUTE/TAG" use="."/>
 <xsl:key name="expprotlookupid" match="/ROOT/EXPERIMENT/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_CONSTRUCTION_PROTOCOL" use="."/>

 <xsl:variable name="url" select="concat('http://www.ebi.ac.uk/ena/data/view/', $acc-number, '&amp;display=xml')"/>

 <xsl:variable name="protocols" select="//LIBRARY_CONSTRUCTION_PROTOCOL[generate-id() = generate-id(key('protocols',.)[1])]"/>
 
 <xsl:variable name="experiments-sources-strategies">
  <xsl:call-template name="process-lib-strategies-sources">
   <xsl:with-param name="acc-number" select="$acc-number"/>
  </xsl:call-template>
 </xsl:variable>
 
 <xsl:variable name="samples-characteristics">
  <xsl:call-template name="process-samples-attributes">
   <xsl:with-param name="acc-number" select="$acc-number"/>
  </xsl:call-template>
 </xsl:variable>
 
 <xsl:variable name="distinct-characteristic-terms">
  <xsl:call-template name="generate-distinct-characteristic-terms">
   <xsl:with-param name="characteristics" select="$samples-characteristics"/>
  </xsl:call-template>
 </xsl:variable>

 <xsl:template match="/">
  <xsl:apply-templates select="document($url)" mode="go"/>
 </xsl:template>
 
 <xsl:template match="ROOT" mode="go">
  <xsl:apply-templates select="SUBMISSION" mode="go"/>
 </xsl:template>

 <xsl:template match="SUBMISSION" mode="go">
  <xsl:variable name="broker-name" select="@broker_name"/> 
  <xsl:apply-templates>
   <xsl:with-param name="broker-name" select="$broker-name" tunnel="yes"/>
  </xsl:apply-templates>
  <xsl:call-template name="generate-assay-files"/>
 </xsl:template>
 
 <xsl:template match="XREF_LINK/DB[contains(.,'NA-STUDY')]">
  <xsl:param name="broker-name" required="yes" tunnel="yes"/>
  <xsl:variable name="study" select="following-sibling::ID"/>
  <xsl:result-document href="{concat($acc-number, '/', 'i_', $acc-number, '.txt')}" method="text">
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
   <xsl:text>&#10;</xsl:text>
   <xsl:apply-templates select="document(concat('http://www.ebi.ac.uk/ena/data/view/',$study,'&amp;display=xml'))/ROOT/STUDY"/>
   
   <xsl:text>STUDY CONTACTS&#10;</xsl:text>
   <xsl:text>Study Person Last Name</xsl:text>
   <xsl:if test="CONTACTS/CONTACT">
    <xsl:text>&#9;</xsl:text>
    <xsl:value-of select="substring-before(CONTACTS/CONTACT/@name,' ')"/>
   </xsl:if>
   <xsl:text>&#10;</xsl:text>
   <xsl:text>Study Person First Name</xsl:text>
   <xsl:if test="CONTACTS/CONTACT">
    <xsl:text>&#9;</xsl:text>
    <xsl:value-of select="substring-after(CONTACTS/CONTACT/@name,' ')"/>    
   </xsl:if>
   <xsl:text>&#10;</xsl:text>
   <xsl:text>Study Person Mid Initials&#10;</xsl:text>
   <xsl:text>Study Person Email</xsl:text>
   <xsl:if test="CONTACTS/CONTACT">
    <xsl:text>&#9;</xsl:text>
    <xsl:value-of select="CONTACTS/CONTACT/@inform_on_status"/>
   </xsl:if>
   <xsl:text>&#10;</xsl:text>
   <xsl:text>Study Person Phone</xsl:text>
   <xsl:if test="CONTACTS/CONTACT"> 
    <xsl:text>&#9;</xsl:text>
    <xsl:text>-</xsl:text>
   </xsl:if>
   <xsl:text>&#10;</xsl:text>
   <xsl:text>Study Person Fax</xsl:text>
   <xsl:if test="CONTACTS/CONTACT">
    <xsl:text>&#9;</xsl:text>
    <xsl:text>-</xsl:text>
   </xsl:if>
   <xsl:text>&#10;</xsl:text>
   <xsl:text>Study Person Address&#10;</xsl:text>
   <xsl:text>Study Person Affiliation&#10;</xsl:text>
   <xsl:text>Study Person Roles&#10;</xsl:text>
   <xsl:text>Study Person Roles Term Accession Number&#10;</xsl:text>
   <xsl:text>Study Person Roles Term Source REF&#10;</xsl:text>
  </xsl:result-document>
 </xsl:template>

 <xsl:template match="XREF_LINK/DB[contains(.,'NA-SAMPLE')]">
  <xsl:result-document href="{concat($acc-number, '/', 's_', $acc-number, '.txt')}" method="text">
   <xsl:variable name="samples-ids" select="following-sibling::ID"/>
   <xsl:call-template name="generate-study-header"/>
   <xsl:text>&#9;Sample Name&#10;</xsl:text>
   <xsl:for-each select="tokenize($samples-ids, ',')">
    <xsl:apply-templates select="document(concat('http://www.ebi.ac.uk/ena/data/view/', . , '&amp;display=xml'))/ROOT/SAMPLE"/>
   </xsl:for-each>
  </xsl:result-document>
 </xsl:template>
 
 <xsl:template name="generate-study-header">
  <xsl:text>Source Name&#9;</xsl:text>
  <xsl:text>Characteristics[Primary Accession Number]&#9;</xsl:text>
  <xsl:text>Comment[Scientific Name]&#9;</xsl:text>
  <xsl:text>Characteristics[Taxonomic ID]&#9;</xsl:text>
  <xsl:text>Characteristics[Description]</xsl:text>
  <xsl:for-each select="$distinct-characteristic-terms/terms/term">
   <xsl:value-of select="concat('&#9;Characteristics[', ., ']')"/>
  </xsl:for-each>
 </xsl:template>
 
 <xsl:template name="generate-assay-files">
  <xsl:for-each-group select="$experiments-sources-strategies/studies/study" group-by="@library-strategy">
   <xsl:sort select="current-grouping-key()"/>
   <xsl:variable name="lib-strategy" select="current-grouping-key()"/>
   <xsl:for-each-group select="current-group()" group-by="@library-source">
    <xsl:sort select="current-grouping-key()"/>
    <xsl:result-document href="{concat($acc-number, '/', 'a_', lower-case($lib-strategy), '-', lower-case(current-grouping-key()), '.txt')}" method="text">
     <xsl:variable name="exp" select="document(concat('http://www.ebi.ac.uk/ena/data/view/', @acc-number, '&amp;display=xml'))"/>
     <!-- Create the header -->
     <xsl:text>Sample Name&#9;</xsl:text>
     <xsl:text>Protocol REF&#9;</xsl:text>
     <xsl:text>Parameter Value[library strategy]&#9;</xsl:text>
     <xsl:text>Parameter Value[library source]&#9;</xsl:text>
     <xsl:text>Parameter Value[library selection]&#9;</xsl:text>
     <xsl:text>Parameter Value[library layout]&#9;</xsl:text>
     
     <xsl:value-of select="if (count($exp/ROOT/EXPERIMENT/DESIGN/DESIGN_DESCRIPTION[contains(., 'target_taxon: ')]) > 0) 
      then 'Parameter Value[target_taxon]&#9;' else ''"/>
     <xsl:value-of select="if (count($exp/ROOT/EXPERIMENT/DESIGN/DESIGN_DESCRIPTION[contains(., 'target_gene: ')]) > 0) 
      then 'Parameter Value[target_gene]&#9;' else ''"/>
     <xsl:value-of select="if (count($exp/ROOT/EXPERIMENT/DESIGN/DESIGN_DESCRIPTION[contains(., 'target_subfragment: ')]) > 0) 
      then 'Parameter Value[target_subfragment]&#9;' else ''"/> 
     <xsl:value-of select="if (count($exp/ROOT/EXPERIMENT/DESIGN/DESIGN_DESCRIPTION[contains(., 'mid: ')]) > 0) 
      then 'Parameter Value[multiplex identifier]&#9;' else ''"/>   
     <xsl:value-of select="if (count($exp/ROOT/EXPERIMENT/DESIGN/DESIGN_DESCRIPTION[contains(., 'pcr_primers: ')]) > 0) 
      then 'Parameter Value[pcr_primers]&#9;' else ''"/>   
     <xsl:value-of select="if (count($exp/ROOT/EXPERIMENT/DESIGN/DESIGN_DESCRIPTION[contains(., 'pcr_cond: ')]) > 0) 
      then 'Parameter Value[pcr_conditions]&#9;' else ''"/>
     
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
     <xsl:for-each select="current-group()">
      <xsl:apply-templates select="$exp/ROOT/EXPERIMENT[@accession = current()/@accession]"/> 
     </xsl:for-each>          
    </xsl:result-document>
   </xsl:for-each-group>
  </xsl:for-each-group>
 </xsl:template>
 
 <xsl:template match="STUDY">
  <xsl:variable name="sra-isa-mapping" select="document('sra-isa-measurement_type_mapping.xml')"/>
  <xsl:text>Study Identifier&#9;</xsl:text>
  <xsl:value-of select="if (@accession) then @accession else '-'"/>
  <xsl:text>&#10;</xsl:text>
  
  <xsl:value-of select="concat('Study Title&#9;', DESCRIPTOR/STUDY_TITLE, '&#10;')"/>
  <xsl:value-of select="concat('Study Submission Date&#9;', SRA/SUBMISSION/@submission_date, '&#10;')"/>   
  <xsl:value-of select="concat('Study Public Release Date&#9;', SRA/SUBMISSION/@submission_date, '&#10;')"/>
  
  <xsl:text>Study Description&#9;</xsl:text>
  <xsl:value-of select="DESCRIPTOR/STUDY_ABSTRACT"/>
  <xsl:value-of select="substring-before(DESCRIPTOR/STUDY_DESCRIPTION,'\r')"/>
  <xsl:text>&#10;</xsl:text>
  
  <xsl:text>Study File Name&#10;</xsl:text>
  <xsl:text>STUDY DESIGN DESCRIPTORS&#10;</xsl:text>

  <xsl:apply-templates select="DESCRIPTOR/STUDY_TYPE"/>

  <xsl:text>Study Design Type Term Accession Number&#10;</xsl:text>
  <xsl:text>Study Design Type Term Source REF&#10;</xsl:text>
  <xsl:text>STUDY PUBLICATIONS&#10;</xsl:text>
  <xsl:text>Study PubMed ID&#9;</xsl:text>

  <xsl:apply-templates select="STUDY_LINKS/STUDY_LINK/XREF_LINK/DB[contains(., 'pubmed')]"/>

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
  <xsl:for-each-group select="$experiments-sources-strategies/studies/study" group-by="@library-strategy">
   <xsl:sort select="current-grouping-key()"/>
   <xsl:value-of select="concat('&#9;', current-grouping-key())"/>
  </xsl:for-each-group>
  <xsl:text>&#10;</xsl:text>

  <xsl:text>Study Assay Measurement Type Term Accession Number&#9;</xsl:text>
  <xsl:for-each-group select="$experiments-sources-strategies/studies/study" group-by="@library-strategy">
   <xsl:sort select="current-grouping-key()"/>
   <xsl:value-of select="concat('&#9;', $sra-isa-mapping/mapping/pairs/measurement[lower-case(@SRA_strategy)=lower-case(current-grouping-key())]/@accnum)"/>
  </xsl:for-each-group>
  <xsl:text>&#10;</xsl:text>

  <xsl:text>Study Assay Measurement Type Term Source REF&#9;</xsl:text>
  <xsl:for-each-group select="$experiments-sources-strategies/studies/study" group-by="@library-strategy">
   <xsl:sort select="current-grouping-key()"/>
   <xsl:value-of select="concat('&#9;', $sra-isa-mapping/mapping/pairs/measurement[lower-case(@SRA_strategy)=lower-case(current-grouping-key())]/@resource)"/>
  </xsl:for-each-group>
  <xsl:text>&#10;</xsl:text>

  <xsl:text>Study Assay Technology Type</xsl:text>
  <xsl:for-each-group select="$experiments-sources-strategies/studies/study" group-by="@library-strategy">
   <xsl:value-of select="concat('&#9;', 'Nucleic acid sequencing')"/>
  </xsl:for-each-group>
  <xsl:text>&#10;</xsl:text>

  <xsl:text>Study Assay Technology Type Term Accession Number&#9;</xsl:text>
  <xsl:text>ENA:0000044&#9;</xsl:text>
  <xsl:text>ENA:0000054&#10;</xsl:text>

  <xsl:text>Study Assay Technology Type Term Source REF&#9;</xsl:text>
  <xsl:text>ENA&#9;</xsl:text>
  <xsl:text>ENA&#10;</xsl:text>
  
  <xsl:text>Study Assay Technology Platform&#10;</xsl:text>

  <xsl:text>Study Assay File Names</xsl:text>
  <xsl:for-each-group select="$experiments-sources-strategies/studies/study" group-by="@library-strategy">
   <xsl:sort select="current-grouping-key()"/>
   <xsl:variable name="lib-strategy" select="current-grouping-key()"/>
   <xsl:for-each-group select="current-group()" group-by="@library-source">
    <xsl:sort select="current-grouping-key()"/>
    <xsl:value-of select="concat('&#9;a_', lower-case($lib-strategy), '-', lower-case(current-grouping-key()), '.txt')"/>
   </xsl:for-each-group>
  </xsl:for-each-group>
  <xsl:text>&#10;</xsl:text>
  
  <xsl:text>STUDY PROTOCOLS&#10;</xsl:text>
  <xsl:text>Study Protocol Name&#10;</xsl:text>
  <xsl:text>Study Protocol Type&#9;</xsl:text>
  <xsl:text>library construction&#10;</xsl:text>
  <xsl:text>Study Protocol Type Term Accession Number&#10;</xsl:text>
  <xsl:text>Study Protocol Type Term Source REF&#10;</xsl:text>
  <xsl:text>Study Protocol Description</xsl:text>
  <xsl:for-each select="//LIBRARY_CONSTRUCTION_PROTOCOL[generate-id(.)=generate-id(key('expprotlookupid',.)[1])]">
   <xsl:text>&#9;</xsl:text>
   <xsl:value-of select="substring-before(substring-after(.,'&#xa;'),'&#xa;')"/>
  </xsl:for-each>
  <xsl:text>&#10;</xsl:text>
  <xsl:text>Study Protocol URI&#10;</xsl:text>
  <xsl:text>Study Protocol Version&#10;</xsl:text>
  <xsl:text>Study Protocol Parameters Name&#10;</xsl:text>
  <xsl:text>Study Protocol Parameters Term Accession Number&#10;</xsl:text>
  <xsl:text>Study Protocol Parameters Term Source REF&#10;</xsl:text>
  <xsl:text>Study Protocol Components Name&#10;</xsl:text>
  <xsl:text>Study Protocol Components Type&#10;</xsl:text>
  <xsl:text>Study Protocol Components Type Term Accession Number&#10;</xsl:text>
  <xsl:text>Study Protocol Components Type Term Source REF&#10;</xsl:text>
 </xsl:template>

 <xsl:template match="DESCRIPTOR/STUDY_TYPE">
  <xsl:text>Study Design Type&#9;</xsl:text>
  <xsl:value-of select="@existing_study_type"/>
  <xsl:text>&#10;</xsl:text>
 </xsl:template>

 <xsl:template match="STUDY_LINKS/STUDY_LINK/XREF_LINK/DB[contains(., 'pubmed')]">
  <xsl:value-of select="following-sibling::ID/."/>
  <xsl:text>&#9;</xsl:text>
 </xsl:template>

 <xsl:template match="SAMPLE">
  <xsl:apply-templates select="@alias"/>
  <xsl:text>&#9;</xsl:text>
  <xsl:apply-templates select="@accession"/>
  <xsl:text>&#9;</xsl:text>
  
  <xsl:apply-templates select="./SAMPLE_NAME"/>
  <xsl:apply-templates select="./DESCRIPTION"/>
  <xsl:text>&#9;</xsl:text>
  
  <xsl:variable name="my-sample" select="./SAMPLE_ATTRIBUTES"/>
  <xsl:for-each select="$distinct-characteristic-terms/terms/term">
   <xsl:variable name="my-term" select="current()"/>
   <xsl:value-of select="if ($my-sample/SAMPLE_ATTRIBUTE/TAG[.=$my-term]) then $my-sample/SAMPLE_ATTRIBUTE/TAG[.=$my-term]/following-sibling::VALUE else ''"/>
   <xsl:text>&#9;</xsl:text>
  </xsl:for-each>
 
  <xsl:apply-templates select="@alias"/>
  <xsl:text>&#9;</xsl:text>
  <xsl:text>&#10;</xsl:text>
 </xsl:template>
 
 <xsl:template match="@alias | @accession | @refname">
  <xsl:value-of select="."/>
 </xsl:template>
 
 <xsl:template match="SAMPLE_NAME">
  <xsl:apply-templates select="COMMON_NAME"/>  
  <xsl:apply-templates select="SCIENTIFIC_NAME"/>
  <xsl:apply-templates select="TAXON_ID"/>
 </xsl:template>
 
 <xsl:template match="COMMON_NAME | SCIENTIFIC_NAME | TAXON_ID">
  <xsl:value-of select="."/>
  <xsl:text>&#9;</xsl:text>
 </xsl:template>
 
 <xsl:template match="DESCRIPTION">
  <xsl:value-of select="substring-before(.,'&#xa;')"/>
 </xsl:template>
 
 <xsl:template match="EXPERIMENT">
  <xsl:apply-templates select="DESIGN/SAMPLE_DESCRIPTOR/@refname"/>
  <xsl:text>&#9;</xsl:text>

  <xsl:text>library preparation&#9;</xsl:text>

  <xsl:apply-templates select="DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_STRATEGY"/>
  <xsl:text>&#9;</xsl:text>
  
  <xsl:apply-templates select="DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_SOURCE"/>
  <xsl:text>&#9;</xsl:text>
  
  <xsl:apply-templates select="DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_SELECTION"/>
  <xsl:text>&#9;</xsl:text>
  
  <xsl:apply-templates select="DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_LAYOUT/SINGLE"/>
  <xsl:text>&#9;</xsl:text>
  
  <xsl:apply-templates select="DESIGN/DESIGN_DESCRIPTION[contains(., 'target_taxon: ')]" mode="target-taxon"/>
  <xsl:text>&#9;</xsl:text>
  
  <xsl:choose>
   <xsl:when test="DESIGN/LIBRARY_DESCRIPTOR/TARGETED_LOCI">
    <xsl:if test="DESIGN/LIBRARY_DESCRIPTOR/TARGETED_LOCI/LOCUS">
     <xsl:value-of select="DESIGN/LIBRARY_DESCRIPTOR/TARGETED_LOCI/LOCUS/@locus_name"/>
     <xsl:text>&#9;</xsl:text>
    </xsl:if>
   </xsl:when>
   <xsl:otherwise>
    <xsl:choose>
     <xsl:when test="contains(DESIGN/DESIGN_DESCRIPTION/.,'target_gene: ')">
      <xsl:value-of select="substring-before(substring-after(DESIGN/DESIGN_DESCRIPTION/.,'target_gene: '),'target_subfragment:')"/>
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

  <xsl:apply-templates select="DESIGN/DESIGN_DESCRIPTION[contains(.,'target_subfragment: ')]" mode="target-subfragment"/>
  <xsl:text>&#9;</xsl:text>
  
  <xsl:apply-templates select="DESIGN/DESIGN_DESCRIPTION[contains(.,'mid: ')]" mode="mid"/>
  <xsl:text>&#9;</xsl:text>

  <xsl:choose>
   <xsl:when test="DESIGN/LIBRARY_DESCRIPTOR/TARGETED_LOCI">
    <xsl:if test="DESIGN/LIBRARY_DESCRIPTOR/TARGETED_LOCI/LOCUS">
     <xsl:text>(</xsl:text>
     <xsl:value-of select="DESIGN/LIBRARY_DESCRIPTOR/TARGETED_LOCI/LOCUS/PROBE_SET/DB"/>
     <xsl:text>:</xsl:text>
     <xsl:value-of select="DESIGN/LIBRARY_DESCRIPTOR/TARGETED_LOCI/LOCUS/PROBE_SET/ID"/>
     <xsl:text>) </xsl:text>
    </xsl:if>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>NULL</xsl:text>
    <xsl:text/>
   </xsl:otherwise>
  </xsl:choose>

  <xsl:apply-templates select="DESIGN/DESIGN_DESCRIPTION[contains(.,'pcr_primers: ')]" mode="pcr-primers"/>
  <xsl:text>&#9;</xsl:text>
  
  <xsl:apply-templates select="DESIGN/DESIGN_DESCRIPTION[contains(.,'pcr_cond: ')]" mode="pcr-cond"/>
  <xsl:text>&#9;</xsl:text>

  <xsl:apply-templates select="DESIGN/SAMPLE_DESCRIPTOR/@accession"/>
  <xsl:text>&#9;</xsl:text>

  <xsl:choose>
   <xsl:when test="DESIGN/SPOT_DESCRIPTOR">
    <xsl:text>Sequencing Protocol</xsl:text>
    <xsl:text>&#9;</xsl:text>
    <xsl:for-each select="DESIGN/SPOT_DESCRIPTOR/SPOT_DECODE_SPEC/READ_SPEC">
     <xsl:value-of select="READ_INDEX/."/>;<xsl:value-of select="READ_CLASS/."
      />;<xsl:value-of select="READ_TYPE/."/>;<xsl:value-of select="BASE_COORD/."
     />|</xsl:for-each>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text/>
   </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&#9;</xsl:text>
  
  <xsl:apply-templates select="PLATFORM//INSTRUMENT_MODEL"/>

  <!-- a TAB as placeholder for Performer-->
  <xsl:text>&#9;</xsl:text>
  <!-- another TAB as placeholder for Date-->
  <xsl:text>&#9;</xsl:text>

  <xsl:apply-templates select="@accession"/>
  <xsl:text>&#9;</xsl:text>

  <xsl:choose>
   <xsl:when test="EXPERIMENT_LINKS/EXPERIMENT_LINK/XREF_LINK">
    <xsl:apply-templates select="EXPERIMENT_LINKS/EXPERIMENT_LINK/XREF_LINK/DB[contains(., 'ENA-FASTQ-FILES')]"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text/>
    <xsl:text>&#9;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>
  <xsl:text>md5&#10;</xsl:text>
 </xsl:template>
 
 <xsl:template match="DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_STRATEGY | DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_SOURCE | DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_SELECTION">
  <xsl:value-of select="."/>
 </xsl:template>
 
 <xsl:template match="DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_LAYOUT/SINGLE">
  <xsl:value-of select="'single'"/>
 </xsl:template>
 
 <xsl:template match="DESIGN/DESIGN_DESCRIPTION[contains(., 'target_taxon: ')]" mode="target-taxon">
  <xsl:value-of select="substring-before(substring-after(.,'target_taxon: '),'target_gene:')"/>
 </xsl:template>
 
 <xsl:template match="DESIGN/DESIGN_DESCRIPTION[contains(.,'target_subfragment: ')]" mode="target-subfragment">
  <xsl:value-of select="substring-before(substring-after(.,'target_subfragment: '),'mid:')"/>
 </xsl:template>
 
 <xsl:template match="DESIGN/DESIGN_DESCRIPTION[contains(.,'mid: ')]" mode="mid">
  <xsl:value-of select="substring-before(substring-after(.,'mid: '),'pcr_primers:')"/>
 </xsl:template>
 
 <xsl:template match="DESIGN/DESIGN_DESCRIPTION[contains(.,'pcr_primers: ')]" mode="pcr-primers">
  <xsl:value-of select="substring-before(substring-after(.,'pcr_primers: '),'pcr_cond:')"/>
 </xsl:template>
 
 <xsl:template match="DESIGN/DESIGN_DESCRIPTION[contains(.,'pcr_cond: ')]" mode="pcr-cond">
  <xsl:value-of select="substring-after(.,'pcr_cond: ')"/>
 </xsl:template>
 
 <xsl:template match="PLATFORM//INSTRUMENT_MODEL">
  <xsl:value-of select="."/>
  <xsl:text>&#9;</xsl:text>
 </xsl:template>

 <xsl:template match="EXPERIMENT_LINKS/EXPERIMENT_LINK/XREF_LINK/DB[contains(., 'ENA-FASTQ-FILES')]">
  <xsl:variable name="file" select="following-sibling::ID/."/>
  <xsl:if test="contains($file,'&amp;result=read_run&amp;fields=run_accession,fastq_ftp')">
   <xsl:variable name="base" select="substring-before($file,'&amp;result=read_run&amp;fields=run_accession,fastq_ftp')"/>
   <xsl:variable name="link" select="concat($base,'&amp;result=read_run&amp;fields=fastq_ftp,fastq_md5')"/>
   <xsl:variable name="parsedlink" select="unparsed-text($link)"/>
   <xsl:for-each select="tokenize($parsedlink, '\n')">
    <xsl:if test="not(contains(.,'fastq_ftp'))">
     <xsl:for-each select="tokenize(., '\t')">
      <xsl:value-of select="."/>
      <xsl:text>&#9;</xsl:text>
     </xsl:for-each>
    </xsl:if>
   </xsl:for-each>
   <xsl:text>&#9;</xsl:text>
  </xsl:if>
 </xsl:template>
 
 <xsl:template match="text() | @*"/>  
</xsl:stylesheet>