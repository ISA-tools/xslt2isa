<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
<!ENTITY copy "&#169;">
]>

<!--xsl stylesheet prototype for html ISA-TAB like rendering of FUGE XML documents  
Author: Philippe Rocca-Serra, EMBL-EBI (rocca@ebi.ac.uk) , March 2008-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
xmlns:fuge="http://fuge.sourceforge.net/fuge/1.0"
 xmlns:fcm="http://flowcyt.sourceforge.net/fugeflow/"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">


  <xsl:output method="html"/>  
  
  <xsl:include href="genericOutputData.xsl"/>
  <xsl:include href="OntologySource.xsl"/> 
   
  
  <xsl:key name="materiallookupid"  match="GenericMaterial"  use="@identifier"/>
  <xsl:key name="materialcharlookupid"  match="//MaterialCollection/GenericMaterial/characteristics"  use="."/>
  <xsl:key name="investigationlookupid"  match="Investigation"  use="@identifier"/>
  <xsl:key name="externaldatalookupid"  match="ExternalData"  use="@identifier"/>
  <xsl:key name="organizationlookupid"  match="Organization"  use="@identifier"/>
  <xsl:key name="personlookupid"  match="Person"  use="@identifier"/>
  <xsl:key name="protocollookupid"  match="GenericProtocol"  use="@identifier"/>
  <xsl:key name="actionlookupid"  match="GenericAction"  use="@identifier"/>
  <xsl:key name="parameterlookupid"  match="GenericParameter"  use="@identifier"/>
  <xsl:key name="ontoindlookupid"  match="OntologyIndividual"  use="@identifier"/>
  <xsl:key name="ontosourcelookupid"  match="//OntologyCollection/OntologySource"  use="@identifier"/>
  <xsl:key name="ontosourceforontoind"  match="//OntologyCollection/OntologyIndividual"  use="@OntologySource_ref"/>
  <xsl:key name="genericequipmentlookupid" match="GenericEquipment" use="@identifier"/>
  <xsl:key name="contactreflookupid"  match="Audit"  use="@Contact_ref"/>
  <xsl:key name="bibreflookupid"  match="BibliographicReference"  use="@identifier"/>
  
  <xsl:key name="PAby_inputCompleteMaterials"
	   match="GenericProtocolApplication/genericInputCompleteMaterials"
	   use="parent::node()/@identifier"/>
  
  <xsl:key name="PAby_GenericMaterialMeasurement"
	   match="GenericProtocolApplication/GenericMaterialMeasurement"
	   use="@Material_ref"/>
  
  <xsl:key name="PAby_inputCompleteMaterials"
	   match="GenericProtocolApplication/GenericProtocolApplication"
	   use="parent::node()/@identifier"/> 
  
  <xsl:key name="PAby_outputMaterials"
	   match="GenericProtocolApplication/genericOutputMaterials"
	   use="@Material_ref"/>
  
  <xsl:key name="PAby_outputData" 
	   match="GenericProtocolApplication/genericOutputData"
	   use="@Data_ref"/>
  
  <xsl:key name="datafilelookupid"
	   match="ExternalData"
	   use="@identifier"/>	
  
  <xsl:template match="FuGE">	
    <html>
      <head><title>FuGE Submission</title></head>
      
      <link rel="stylesheet" type="text/css" href="mystyle.css"/>
      
      <body bgcolor="gray">
	<p>
	  <h1>
	    <font color="#003366" face="Arial" size="2pt">
	      <b>FuGE Document:</b>
	      <xsl:value-of select="@identifier"/>
	    </font>
	  </h1>
	</p>
	<!-- BUILDING INVESTIGATION FILE -->
	<xsl:apply-templates select="OntologyCollection"/>
	<xsl:apply-templates select="InvestigationCollection"/>
	<xsl:apply-templates select="ProtocolCollection"/>
	<br/>
	<!-- BUILDING STUDY SAMPLE FILE -->
	<xsl:apply-templates select="MaterialCollection"/>
	<br/>
	
	
	<!-- BUILDING STUDY ASSAY FILE -->
	<table class="gamma" width="100%" font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
	  <tr><td class="delta">ASSAY TAB</td></tr>
	  <tr bgcolor="#003366">
	    <td class="delta">Sample Name</td>
	    <td class="delta">Assay Name</td>
	    <td class="delta">Protocol REF</td>
	    <td class="delta">Parameter[Instrument]</td>
	    <td class="delta">Date</td>    
	    <td class="delta">Raw Data File</td>
	  </tr>

	  <xsl:apply-templates select="//genericOutputData"/>
	  <xsl:apply-templates select="//_outputData"/>
	</table>
	
      </body>
    </html>
  </xsl:template>
  


  <xsl:template match="OntologyCollection">
    <table class="gamma" width="30%" border="0" cellspacing="1" cellpadding="10">
      <tr><td class="delta">Ontology Source Reference</td></tr>
      <tr>
	<td class="delta" width="10%">Term Source Name</td>
	<xsl:apply-templates select="OntologySource" mode="name"/>
      </tr> 
      <tr>
	<td class="delta" width="10%" >Term Source File</td>
	<xsl:apply-templates select="OntologySource" mode="uri"/>
      </tr>  
      <tr>
	<td class="delta" width="10%" >Term Source Version</td>
	<xsl:apply-templates select="OntologySource" mode="id"/>
      </tr>
      <tr>
	<td class="delta" width="10%" >Term Source Description</td>
	<xsl:apply-templates select="OntologySource" mode="endurant"/>
      </tr>
    </table>
  </xsl:template>

  
  

 
  
  
  
 
  
  
  
  <xsl:template match="InvestigationCollection">
    
    <!--BLOCK STARTS:  BUILDING THE STUDY DESCRIPTION SECTION OF ISA-TAB RENDERING -->
    <table class="gamma" width="75%" font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
      <tr>
	<td width="20%" class="delta">Study Identifier</td>
	<xsl:apply-templates select="Investigation" mode="id"/>			
      </tr>
      <tr>
	<td class="delta">Study Title</td>
	<xsl:apply-templates select="Investigation" mode="name"/>
      </tr>
      <tr>
	<td class="delta">Study Submission Date</td>
	<xsl:apply-templates select="Investigation" mode="date"/>
      </tr>
      <tr>
	<td class="delta">Study Authors List</td>
	<xsl:apply-templates select="Investigation" mode="bibrefauthors"/>
      </tr>
      <tr>
	<td class="delta">Study Publication Title</td>
	<xsl:apply-templates select="Investigation" mode="bibreftitle"/>
      </tr> 
      <tr>
	<td class="delta">Study PubMed ID</td>
	<xsl:apply-templates select="Investigation" mode="bibrefpubmed"/>
      </tr>    
      <tr>
	<td class="delta">Study Publication Status</td>
	<xsl:apply-templates select="Investigation" mode="bibrefstatus"/>
      </tr>  
      <tr>
	<td class="delta">Study Description</td>
	<td class="beta">
	  <xsl:apply-templates select="Investigation" mode="hypothesis"/>
	  <xsl:apply-templates select="Investigation" mode="conclusion"/>
	  <xsl:apply-templates select="Investigation" mode="description"/>
	</td>
      </tr>  
      
      <tr><td class="delta">STUDY DESIGN DESCRIPTORS</td>
      <td bgcolor="#CCCCCC">
	<font face="Arial" size="2pt">
	</font>	
      </td>
      </tr>
      <tr><td class="delta">Study Design Type</td>
      <td bgcolor="#CCCCCC">
	<font face="Arial" size="2pt">
	</font>	
      </td>
      </tr>
      <tr>
	<td class="delta">Study Design Type Term Accession Number</td>
	<td bgcolor="#CCCCCC">
	  <font face="Arial" size="2pt">
	  </font>	
	</td>
      </tr>	    
      <tr>
	<td class="delta">Study Design Type Term Source REF</td>
	<td bgcolor="#CCCCCC">
	  <font face="Arial" size="2pt">
	  </font>	
	</td>
      </tr>							
    </table>
    <!--BLOCK ENDS-->
    
    
    <!--BLOCK STARTS: BUILDING THE STUDY FACTOR SECTION OF ISA-TAB RENDERING -->   
    
    <table class="gamma" width="75%" font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
      <tr>
	<td width="20%" class="delta">STUDY FACTORS</td>
      </tr>
      <tr>
	<td width="20%" class="delta">Study Factor Name</td>
	<xsl:choose>
	  <xsl:when test="Factor">
	    <xsl:apply-templates select="Factor" mode="name"/>				
	  </xsl:when>
	  <xsl:otherwise>
	    <td class="beta">-</td></xsl:otherwise>
	  </xsl:choose>
	</tr>
	<tr>
	  <td class="delta" width="20%">Study Factor Type</td>
	  <xsl:choose>
	    <xsl:when test="Factor">
	      <xsl:apply-templates select="Factor" mode="type"/>				
	    </xsl:when>
	    <xsl:otherwise>
	      <td class="beta">-</td></xsl:otherwise>
	    </xsl:choose> 
	</tr>
	<tr>
	  <td class="delta" width="20%">Study Factor Type Term Accession Number</td>
	  <xsl:choose>
	    <xsl:when test="Factor">
	      <xsl:apply-templates select="Factor" mode="term"/>				
	    </xsl:when>
	    <xsl:otherwise>
	      <td class="beta">-</td></xsl:otherwise>
	    </xsl:choose>
	  </tr>     
	  <tr>
	    <td class="delta" width="20%">Study Factor Type Term Source REF</td>
	    <xsl:choose>
	      <xsl:when test="Factor">
		<xsl:apply-templates select="Factor" mode="source"/>				
	      </xsl:when>
	      <xsl:otherwise>
		<td class="beta">-</td></xsl:otherwise>
	      </xsl:choose> 	
	    </tr>
    </table>
    <!--BLOCK ENDS-->
    
    
    <!--BLOCK STARTS: BUILDING THE STUDY ASSAY SECTION OF ISA-TAB RENDERING -->   
    
    <table class="gamma" width="75%" font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
      <tr>
	<td width="20%" class="delta">STUDY ASSAYS</td>
      </tr>
      <tr>
	<td width="20%" class="delta">Study Assay Measurement Type</td>
	<xsl:choose>
	  <xsl:when test="InvestigationComponent">
	    <xsl:apply-templates select="InvestigationComponent" mode="measuretype"/>				
	  </xsl:when>
	  <xsl:otherwise>
	    <td class="beta">-</td></xsl:otherwise>
	  </xsl:choose>
      </tr>
      <tr>
	<td class="delta" width="20%">Study Assay Measurement Type Term Accession Number</td>
	<xsl:choose>
	  <xsl:when test="InvestigationComponent">
	    <xsl:apply-templates select="InvestigationComponent" mode="measureterm"/>				
	  </xsl:when>
	  <xsl:otherwise>
	    <td class="beta">-</td></xsl:otherwise>
	  </xsl:choose>
      </tr> 
      <tr>
	<td class="delta" width="20%">Study Assay Measurement Type Term Source</td>
	<xsl:choose>
	  <xsl:when test="InvestigationComponent">
	    <xsl:apply-templates select="InvestigationComponent" mode="measuresource"/>				
	  </xsl:when>
	  <xsl:otherwise>
	    <td class="beta">-</td></xsl:otherwise>
	  </xsl:choose> 
      </tr>      
      <tr>
	<td class="delta" width="20%">Study Technology Type</td>
	<xsl:choose>
	  <xsl:when test="InvestigationComponent">
	    <xsl:apply-templates select="InvestigationComponent" mode="techtype"/>				
	  </xsl:when>
	  <xsl:otherwise>
	    <td class="beta">-</td></xsl:otherwise>
	  </xsl:choose> 	
      </tr>
      <tr>
	<td class="delta" width="20%">Study Technology Type Term Accession Number</td>
	<xsl:choose>
	  <xsl:when test="InvestigationComponent">
	    <xsl:apply-templates select="InvestigationComponent" mode="techterm"/>				
	  </xsl:when>
	  <xsl:otherwise>
	    <td class="beta">-</td></xsl:otherwise>
	  </xsl:choose> 	
	</tr>                 
	<tr>
	  <td class="delta" width="20%">Study Technology Type Term Source REF</td>
	  <xsl:choose>
	    <xsl:when test="InvestigationComponent">
	      <xsl:apply-templates select="InvestigationComponent" mode="techsource"/>				
	    </xsl:when>
	    <xsl:otherwise>
	      <td class="beta">-</td></xsl:otherwise>
	    </xsl:choose> 	
	  </tr>
    </table>
    <!--BLOCK ENDS-->  
    
    
    <!--BLOCK STARTS: BUILDING THE STUDY CONTACT SECTION OF ISA-TAB RENDERING -->   
    
    <table class="gamma" width="75%" font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
      <tr><td width="20%" class="delta">STUDY CONTACTS</td></tr>
      <tr>
	<td class="delta">Study Person Last Name</td>
	<xsl:apply-templates select="Investigation" mode="contactlastname"/>     	 
      </tr>
      <tr>
	<td class="delta">Study Person First Name</td>
	<xsl:apply-templates select="Investigation" mode="contactfirstname"/>
      </tr>
      <tr>
	<td class="delta">Study Person Mid Initials</td>
	<xsl:apply-templates select="Investigation" mode="contactmidinitials"/>
      </tr>
      <tr>
	<td class="delta">Study Person email</td>
	<xsl:apply-templates select="Investigation" mode="contactemail"/>
      </tr>
      <tr>
	<td class="delta">Study Person Phone</td>
	<xsl:apply-templates select="Investigation" mode="contactphone"/>
      </tr>
      <tr>
	<td class="delta">Study Person Fax</td>
	<xsl:apply-templates select="Investigation" mode="contactfax"/>
      </tr>
      <tr>
	<td class="delta">Study Person address</td>
	<xsl:apply-templates select="Investigation" mode="contactaddress"/>
      </tr>
      <tr>
	<td class="delta">Study Person Affiliation</td>
	<xsl:apply-templates select="Investigation" mode="contactaffiliation"/>   
      </tr>
      <tr>
	<td class="delta">Study Person Role</td>
	<xsl:apply-templates select="Investigation" mode="contactrole"/>   
      </tr>
      <tr>
	<td class="delta">Study Person Role Term Accession Number</td>
	<xsl:apply-templates select="Investigation" mode="contactroleaccnum"/>
      </tr>      
      <tr>
	<td class="delta">Study Person Role Term Source REF</td>
	<xsl:apply-templates select="Investigation" mode="contactrolesrc"/>
      </tr>
    </table>
    <!--BLOCK ENDS-->
    
  </xsl:template>
  
  

  <xsl:template match="ProtocolCollection">
    <table class="gamma" width="75%" font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
      <tr><td class="delta">STUDY PROTOCOLS</td></tr>
      <tr>
	<td class="delta">Study Protocol Name</td>
	<xsl:apply-templates select="GenericProtocol" mode="name"/>
      </tr>  
      <tr>
	<td class="delta">Study Protocol Description</td>
	<xsl:for-each select="//GenericProtocol">
	  <td bgcolor="#CCCCCC"><font face="Arial" size="2pt">	  
	    <xsl:value-of select="@protocolText"/><br/>
	    <xsl:for-each select="child::GenericAction">
	      <font face="Arial" size="2pt">
		<b><xsl:text>action:</xsl:text></b>
		<xsl:value-of select="@name"/><xsl:value-of select="@actionText"/><br/>
		<b><xsl:text>order:</xsl:text></b>
		<xsl:value-of select="@actionOrdinal"/>   
		<br/>
	      </font>
	    </xsl:for-each>	  
	    <xsl:for-each select="child::descriptions/Description">
	      <font face="Arial" size="2pt">
		<b><xsl:text>description: </xsl:text></b>
		<xsl:value-of select="@text"/><br/>
		<br/>
	      </font>
	    </xsl:for-each>	  
	  </font></td> 
	</xsl:for-each>  
      </tr>       
      <tr>
	<td class="delta">Study Protocol Parameter Name</td>
	<xsl:apply-templates select="GenericProtocol" mode="parameter"/>
      </tr> 
      <tr>
	<td class="delta">Study Protocol Component Name</td>
	<xsl:apply-templates select="GenericProtocol" mode="equipment"/>
      </tr>        
    </table> 
  </xsl:template>
  
  
  <!-- OLD GPA template
       <xsl:template name="GenericProtocolApplication" match="GenericProtocolApplication">
       <table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
     <tr>
     <td bgcolor="#CCCCCC">
     <font face="Arial" size="3pt">
     <b>Assay Tab </b>
     </font>
     </td>
     </tr>
 <tr>
 <td bgcolor="#CCCCCC">
 <font face="Arial" size="3pt"><b>Raw Data File</b>
 </font>
 </td>
 <td bgcolor="#CCCCCC">
 <font face="Arial" size="3pt"><b>File Format</b>
 </font>
 </td>
 </tr>	
 
   <xsl:for-each select="//GenericProtocolApplication">
   <tr>
   <xsl:if test="child::genericInputCompleteMaterials">
   <td bgcolor="#CCCCCC">
   <font face="Arial" size="2pt">
   <xsl:value-of select="key('materiallookupid',child::genericInputCompleteMaterials/@Material_ref)/@name"/>
   </font>
   </td>
   </xsl:if>
   <xsl:if test="child::genericOutputMaterials">
   <td bgcolor="#CCCCCC">
   <font face="Arial" size="2pt">
   <xsl:value-of select="key('materiallookupid',child::genericOutputMaterials/@Material_ref)/@name"/>
   </font>
   </td>
   </xsl:if>	
   <xsl:if test="child::genericOutputData">
   <td bgcolor="#CCCCCC">
   <font face="Arial" size="2pt">
   <xsl:value-of select="key('externaldatalookupid',child::genericOutputData/@Data_ref)/@name"/>
   </font>
   </td>
   <td bgcolor="#CCCCCC">
   <font face="Arial" size="2pt">	
-->
<!--<xsl:value-of select="key('ontoindlookupid',child::fileFormat/@OntologyTerm_ref)/@term"/>-->

<!--
    <xsl:value-of select="key('ontoindlookupid',key('externaldatalookupid',child::genericOutputData/@Data_ref)/fileFormat/@OntologyTerm_ref)/@term"/>
    </font>
    </td>
    </xsl:if>	
    </tr>
    </xsl:for-each>
    </table>
    </xsl:template>
-->


<xsl:template match="MaterialCollection">
  
  <table class="gamma" width="100%" font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
    <tr><td class="delta">STUDY TAB</td></tr>
    <tr>
      <td class="delta">Source Name</td>
      <td class="delta">Material Type</td>  
      <td class="delta">Description</td>
      <td class="delta">Date</td> 
      <td class="delta">Performer</td> 
      <xsl:choose>
	<xsl:when test="child::GenericMaterial/_characteristics">	   
	  <xsl:for-each select="child::GenericMaterial/_characteristics">
	    <td class="delta">
	      <xsl:text>Characteristics[</xsl:text>
	      <!--<xsl:value-of select="@OntologyTerm_ref"/>-->
	      <xsl:value-of select="key('ontosourcelookupid',key('ontoindlookupid',@OntologyTerm_ref)/@OntologySource_ref)/@name"/>
	      <xsl:text>]</xsl:text>
	    </td>
	  </xsl:for-each>
	</xsl:when> 
	<xsl:otherwise>
	  <td class="delta"><xsl:text>Characteristics[]</xsl:text></td>	
	</xsl:otherwise>
      </xsl:choose> 
    </tr>
        
    <xsl:for-each select="//GenericMaterial">
      <xsl:variable name="color">
	<xsl:choose>
	  <xsl:when test="position() mod 2= 0">#B0C4DE</xsl:when>
	  <xsl:otherwise>#CCCCCC</xsl:otherwise>
	</xsl:choose>
      </xsl:variable>
      <tr bgcolor="{$color}">
	
	
	<td>
	  <font face="Arial" size="2pt">
	    <xsl:value-of select="@identifier"/>
	  </font>
	</td>
	<xsl:choose>
	  <xsl:when test="./materialType">
	    <xsl:for-each select="./materialType/@OntologyTerm_ref">     
	      <td>
		<font face="Arial" size="2pt">
		  <xsl:value-of select="key('ontoindlookupid',.)/@term"/>
		</font>
	      </td>      
	    </xsl:for-each>
	  </xsl:when>
	  <xsl:otherwise>
	    <td>
	      <font face="Arial" size="2pt">
		<xsl:text>na</xsl:text>
	      </font>
	    </td>
	  </xsl:otherwise>
	</xsl:choose>
	
	<xsl:choose>
	  <xsl:when test="./descriptions"> 
	    <td>
	      <font face="Arial" size="2pt">
		<xsl:for-each select="./descriptions/Description">
		  
		  <xsl:value-of select="@text"/><br/>
		  
		</xsl:for-each>
	      </font>
	    </td>	       
	  </xsl:when>
	  <xsl:otherwise>
	    <td>
	      <font face="Arial" size="2pt">
		<xsl:text>na</xsl:text>
	      </font>
	    </td>
	  </xsl:otherwise>
	</xsl:choose> 
	
	<xsl:choose>
	  <xsl:when test="./auditTrail/Audit">
	    
	    <td>
	      <font face="Arial" size="2pt">
		<xsl:value-of select="substring-before(./auditTrail/Audit/@date,'T')"/>
	      </font>
	    </td>
	    <td>
	      <font face="Arial" size="2pt">
		<xsl:value-of select="key('personlookupid',./auditTrail/Audit/@Contact_ref)/@name"/>
	      </font>
	    </td> 	       	
	  </xsl:when>
	  <xsl:otherwise>
	    <td>
	      <font face="Arial" size="2pt">
		<xsl:text>na</xsl:text>
	      </font>
	    </td>
  	    <td>
	      <font face="Arial" size="2pt">
		<xsl:text>na</xsl:text>
	      </font>
	    </td>
	  </xsl:otherwise>
	</xsl:choose> 
	
	
	<xsl:choose>
	  <xsl:when test="child::_characteristics">
	    <xsl:for-each select="child::_characteristics/@OntologyTerm_ref">
	      
	      <td>
		<font face="Arial" size="2pt">
		  <xsl:value-of select="key('ontoindlookupid',.)/@term"/>
		</font>
	      </td>
	      
	    </xsl:for-each>
	  </xsl:when>  
	  <xsl:otherwise>
	    <td>
	      <font face="Arial" size="1pt">
		<i><xsl:text>none</xsl:text></i>
	       	 </font>
	       </td>	   
	     </xsl:otherwise>
	   </xsl:choose>  	   
	   
	 </tr> 	       
       </xsl:for-each> 
       
     </table>
   </xsl:template>
   
   


<xsl:template name="getParentMaterial" match="//genericOutputMaterials">
  <xsl:param name="test1"  select="parent::node()/genericInputCompleteMaterials"/>
  <xsl:param name="test2"  select="parent::node()/GenericMaterialMeasurement"/>
  <xsl:variable name="thisoutput" select="@Material_ref"/>
  <xsl:variable name="color">
    <xsl:choose>
      <xsl:when test="position() mod 2= 0">#B0C4DE</xsl:when>
      <xsl:otherwise>#CCCCCC</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>		
  <xsl:choose>
    
    <!--check whether the input is GenericMaterialMeasurement or _inputCompleteMaterials -->
    <!--Test for the First Case: input material is coded as '_inputCompleteMaterials'-->
    <xsl:when test="$test1">
      <tr bgcolor="{$color}">
	<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="$test1/@Material_ref"/></font></td>
	<!-- check if current input=Material is also output of a ProtocolApplication, i.e if it has a parent-->
	<!-- check if current output is input for another ProtocolApplication, i.e if it has a descendant -->
	<xsl:choose>
	  
	  <xsl:when test="key('PAby_outputMaterials',$test1/@Material_ref)">
	    <!-- 1.1. Is it True that this inputCompleteMaterial is also an output of another PA?  YES-->
	    <xsl:call-template name="getParentMaterial">
	      <xsl:with-param name="test1" select="$test1[position()!=1]"/>
	    </xsl:call-template>
	  </xsl:when>
	  
	  <xsl:when test="key('PAby_inputCompleteMaterials',@Material_ref)  or key('PAby_GenericMaterialMeasurement',@Material_ref)">        
	    <!-- 1.2. Is it True that this output material <xsl:value-of select="$thisoutput"/> of this PA is also an inputComplete material in another PA ? YES -->
	    <td><xsl:value-of select="parent::node()/@identifier"/></td>
	    <td><xsl:value-of select="key('genericequipmentlookupid',parent::node()/EquipmentApplication/@Equipment_ref)/@name"/></td> 
	    <td><xsl:value-of select="substring-before(parent::node()/@activityDate, 'T')"/></td> 
	    <td><xsl:value-of select="@Material_ref"/></td>
	    <xsl:call-template name="tt">
	      <xsl:with-param name="thisoutput" select="$thisoutput"/>
	    </xsl:call-template>
	    <!-- HERE: TODO: I should call a getDescendantMaterial Template in order to go further-->
	    <xsl:apply-templates select="//GenericProtocolApplication"/>
	  </xsl:when>  
	  
	  <xsl:otherwise>
	    <td><xsl:value-of select="parent::node()/@identifier"/></td>
	    <td><xsl:value-of select="key('genericequipmentlookupid',parent::node()/EquipmentApplication/@Equipment_ref)/@name"/></td> 
	    <td><xsl:value-of select="substring-before(parent::node()/@activityDate, 'T')"/></td> 
	    <td><xsl:value-of select="@Material_ref"/></td>
	  </xsl:otherwise>
	</xsl:choose>
      </tr>   
    </xsl:when>
    
    <!--Test for the Second Case: input material is coded as 'GenericMaterialMeasurement'-->
    <xsl:when test="$test2">
      <tr bgcolor="{$color}">
	<td><xsl:value-of select="$test2/@Material_ref"/></td>
	<!-- check if current input=Material is also output of a ProtocolApplication-->
	<xsl:choose>
	  <xsl:when test="key('PAby_outputMaterials',$test2/@Material_ref)">
	    <!--2.1 Is it True that this inputCompleteMaterial is also an output of another PA?  YES    --> 
	    <td><xsl:value-of select="parent::node()/@identifier"/></td>
	    <td><xsl:value-of select="key('genericequipmentlookupid',parent::node()/EquipmentApplication/@Equipment_ref)/@name"/></td>     
	    <td><xsl:value-of select="substring-before(parent::node()/@activityDate, 'T')"/></td>     
	    <td><xsl:value-of select="@Material_ref"/></td>
	    <xsl:call-template name="tt">
	      <xsl:with-param name="thisoutput" select="$thisoutput"/>
	    </xsl:call-template>
	    
	    <!-- <xsl:apply-templates select="// GenericProtocolApplication"/>
		 <xsl:call-template name="getParentMaterial">
		 <xsl:with-param name="test2" select="$test2[position()!=1]"/>
		 </xsl:call-template>
	    -->
	  </xsl:when>
	  <xsl:when test="key('PAby_GenericMaterialMeasurement',@Material_ref) or key('PAby_inputCompleteMaterials',@Material_ref)">
	    <!-- 2.2.Is it True that this output material <xsl:value-of select="@Material_ref"/> on this PA is also a inputComplete material in another PA ? YES -->
	    <td><xsl:value-of select="parent::node()/@identifier"/></td>
	    <td><xsl:value-of select="key('genericequipmentlookupid',parent::node()/EquipmentApplication/@Equipment_ref)/@name"/></td> 
	    <td><xsl:value-of select="substring-before(parent::node()/@activityDate, 'T')"/></td> 
	    <td><xsl:value-of select="@Material_ref"/></td>
	    <xsl:call-template name="getParentMaterial">
	      <xsl:with-param name="test2" select="$test2[position()>1]"/>
	    </xsl:call-template>     
	  </xsl:when> 
	  <xsl:otherwise>
	    <td>output is: <xsl:value-of select="@Material_ref"/></td>
	  </xsl:otherwise>
	</xsl:choose>
      </tr>
    </xsl:when> 
  </xsl:choose>   
</xsl:template>


<xsl:template name="tt" match="//GenericProtocolApplication">
  <xsl:param name="thisoutput"/> 
  <xsl:for-each select="//GenericProtocolApplication">
    <xsl:if test="child::genericInputCompleteMaterials/@Material_ref = $thisoutput and not(child::genericOutputData)">
      <td class="epsilon"><xsl:value-of select="@identifier"/></td>
      <td class="epsilon"><xsl:value-of select="key('genericequipmentlookupid',child::EquipmentApplication/@Equipment_ref)/@name"/></td>
      <td class="epsilon"><xsl:value-of select="substring-before(@activityDate, 'T')"/></td>
      <td class="epsilon"><xsl:value-of select="child::genericOutputMaterials/@Material_ref"/></td>
    </xsl:if>
    <xsl:if test="child::GenericMaterialMeasurement/@Material_ref = $thisoutput and not(child::genericOutputData)">
      <td class="epsilon"><xsl:value-of select="@identifier"/></td>
      <td class="epsilon"><xsl:value-of select="key('genericequipmentlookupid',child::EquipmentApplication/@Equipment_ref)/@name"/></td>
      <td class="epsilon"><xsl:value-of select="substring-before(@activityDate, 'T')"/></td>    
      <td class="epsilon"><xsl:value-of select="child::genericOutputMaterials/@Material_ref"/></td>      
    </xsl:if>  
  </xsl:for-each>
</xsl:template>



  

  
  
  <!-- TEMPLATES TO PROCESS FUGE CONTACTS -->
  
  <xsl:template match="ContactRole" mode="lastname">
    <td class="beta">
      <xsl:value-of select="key('personlookupid',@Contact_ref)/@lastName"/>
    </td>
  </xsl:template>
  <xsl:template match="ContactRole" mode="firstname">
    <td class="beta">
      <xsl:value-of select="key('personlookupid',@Contact_ref)/@firstName"/>
    </td>
  </xsl:template>
  <xsl:template match="ContactRole" mode="midinitials">
    <td class="beta">
      <xsl:value-of select="key('personlookupid',@Contact_ref)/@midInitials"/>
    </td>
  </xsl:template>
  <xsl:template match="ContactRole" mode="email">
    <td class="beta">
      <xsl:value-of select="key('personlookupid',./@Contact_ref)/@email"/>
    </td>
  </xsl:template>
  <xsl:template match="ContactRole" mode="phone">
    <td class="beta">
      <xsl:value-of select="key('personlookupid',./@Contact_ref)/@phone"/>
    </td>
  </xsl:template>
  <xsl:template match="ContactRole" mode="fax">
    <td class="beta">
      <xsl:value-of select="key('personlookupid',./@Contact_ref)/@fax"/>
    </td>
  </xsl:template>
  <xsl:template match="ContactRole" mode="address">
    <td class="beta">
      <xsl:value-of select="key('personlookupid',./@Contact_ref)/@address"/>
    </td>
  </xsl:template>
  
  <xsl:template match="ContactRole/_role" mode="ontoind">
    <td class="beta">
      <xsl:value-of select="key('ontoindlookupid',./@OntologyTerm_ref)/@term"/>
    </td>
  </xsl:template>
  
  <xsl:template match="ContactRole/_role" mode="accnum">
    <td class="beta">
      <xsl:value-of select="key('ontoindlookupid',./@OntologyTerm_ref)/@termAccession"/>
    </td>
  </xsl:template>
  
  <xsl:template match="ContactRole/_role" mode="ontosrc">
    <td class="beta">
      <xsl:value-of select="key('ontosourcelookupid',key('ontoindlookupid',./@OntologyTerm_ref)/@OntologySource_ref)/@name"/>
    </td>
  </xsl:template>
  
  <xsl:template match="ContactRole" mode="affiliation">
    <td class="beta">
      <xsl:value-of select="key('organizationlookupid',key('personlookupid',./@Contact_ref)/_affiliations/@Organization_ref)/@name"/>
    </td>
  </xsl:template>
  <!--==========================================-->
  
  
  
  <!-- TEMPLATES TO PROCESS FACTORS -->
  <xsl:template match="Factor" mode="name">
    <td class="beta"><xsl:value-of select="@name"/></td>					
  </xsl:template>
  
  <xsl:template match="Factor" mode="type">
    <td class="beta">
      <xsl:value-of select="key('ontoindlookupid',child::_factorType/@OntologyTerm_ref)/@term"/>
      <!--<xsl:value-of select="child::_factorType/@OntologyTerm_ref"/>-->
    </td>					
  </xsl:template>
  
  <xsl:template match="Factor" mode="term">
    <td class="beta">
      <xsl:value-of select="key('ontoindlookupid',child::_factorType/@OntologyTerm_ref)/@termAccession"/></td>					
  </xsl:template>
  
  <xsl:template match="Factor" mode="source">
    <td class="beta">
      <xsl:value-of select="key('ontosourcelookupid',key('ontoindlookupid',child::_factorType	/@OntologyTerm_ref)/@OntologySource_ref)/@name"/>
    </td>					
  </xsl:template>
  <!--==========================================-->
  
  
  <!-- TEMPLATES TO PROCESS INVESTIGATIONS COMPONENTS AND CREATE ASSAYS -->
  <xsl:template match="InvestigationComponent" mode="name">
    <td class="beta"><xsl:value-of select="@name"/></td>					
  </xsl:template>
  
  <xsl:template match="InvestigationComponent" mode="type">
    <td class="beta">
      <xsl:value-of select="key('ontoindlookupid',child::_componentType/@OntologyTerm_ref)/@term"/>
      <!--<xsl:value-of select="child::_factorType/@OntologyTerm_ref"/>-->
    </td>					
  </xsl:template>
  
  <xsl:template match="InvestigationComponent" mode="term">
    <td class="beta">
      <xsl:value-of select="key('ontoindlookupid',child::_componentType/@OntologyTerm_ref)/@termAccession"/></td>					
  </xsl:template>
  
  <xsl:template match="InvestigationComponent" mode="source">
    <td class="beta">
      <xsl:value-of select="key('ontosourcelookupid',key('ontoindlookupid',child::_componentType/@OntologyTerm_ref)/@OntologySource_ref)/@name"/>
    </td>					
  </xsl:template>
  <!--==========================================-->
  
  
  <!-- TEMPLATES TO PROCESS DESCRIPTION-->
  
  <xsl:template match="_descriptions" mode="text">
    <xsl:apply-templates select="Description"/>
    <br/>
  </xsl:template>
  <xsl:template match="_hypothesis" mode="text">
    <xsl:apply-templates select="Description"/>
    <br/>	
  </xsl:template>
  <xsl:template match="_conclusion" mode="text">
    <xsl:apply-templates select="Description"/>
    <br/>
  </xsl:template>
  
  <xsl:template match="Description">
    <xsl:value-of select="@text"/>
    <br/>
  </xsl:template>
  <!--==========================================-->
  
  
  <xsl:template match="InvestigationComponent" mode="name">
    <td class="beta">
      <xsl:value-of select="@name"/>
    </td>
  </xsl:template>
  
  
  <!-- TEMPLATES TO PROCESS BIBREF -->
  <xsl:template match="_bibliographicReferences" mode="name">
    <td class="beta">
      <xsl:value-of select="key('bibreflookupid',./@BibliographicReference_ref)/@name"/>
    </td>
  </xsl:template>
  <xsl:template match="_bibliographicReferences" mode="authors">
    <td class="beta">
      <xsl:value-of select="key('bibreflookupid',./@BibliographicReference_ref)/@authors"/>
    </td>
  </xsl:template>
  <xsl:template match="_bibliographicReferences" mode="title">
    <td class="beta">
      <xsl:value-of select="key('bibreflookupid',./@BibliographicReference_ref)/@title"/>
    </td>
  </xsl:template>
  <xsl:template match="_bibliographicReferences" mode="publication">
    <td class="beta">
      <xsl:value-of select="key('bibreflookupid',./@BibliographicReference_ref)/@publication"/>
    </td>
  </xsl:template>
  <xsl:template match="_bibliographicReferences" mode="year">
    <td class="beta">
      <xsl:value-of select="key('bibreflookupid',./@BibliographicReference_ref)/@year"/>
    </td>
  </xsl:template>
  <xsl:template match="_bibliographicReferences" mode="pages">
    <td class="beta">
      <xsl:value-of select="key('bibreflookupid',./@BibliographicReference_ref)/@pages"/>
    </td>
  </xsl:template>
  <xsl:template match="_bibliographicReferences" mode="volume">
    <td class="beta">
      <xsl:value-of select="key('bibreflookupid',./@BibliographicReference_ref)/@volume"/>
    </td>
  </xsl:template>
  <!--==========================================-->
  
  
  <!-- TEMPLATES TO PROCESS FUGE PROTOCOLS -->
  
  <xsl:template match="GenericProtocol" mode="name">
    <td class="beta">
      <xsl:value-of select="@name"/>
    </td>
  </xsl:template>
  
  <xsl:template match="GenericProtocol" mode="text">
    <xsl:value-of select="@protocolText"/>
  </xsl:template>
  
  <xsl:template match="GenericProtocol" mode="description">
    <xsl:apply-templates select="GenericAction"/>
  </xsl:template>
  
  
  <xsl:template match="GenericProtocol" mode="equipment">
    <xsl:apply-templates select="_equipment"/>
  </xsl:template>
  <xsl:template match="GenericProtocol" mode="software">
    <xsl:apply-templates select="GenericSoftware"/>
  </xsl:template>
  <xsl:template match="GenericProtocol" mode="parameter">
    <xsl:apply-templates select="GenericParameter" mode="name"/>
  </xsl:template>
  
  <xsl:template match="_equipment">
    <td class="beta">
      <xsl:value-of select="@GenericEquipment_ref"/>
      <br/>
      <xsl:value-of select="key('genericequipmentlookupid',@GenericEquipment_ref)/@name"/>
    </td>
  </xsl:template>
  
  <xsl:template match="GenericAction">
    <xsl:value-of select="@actionOrdinal"/>
    <xsl:text>: </xsl:text>
    <xsl:value-of select="@actionText"/>
  </xsl:template>
  
  
  <xsl:template match="GenericParameter" mode="name">
    <td class="beta">
      <xsl:value-of select="@name"/>
      <xsl:value-of select="key('genericequipmentlookupid',@GenericEquipment_ref)/@name"/>
    </td>
  </xsl:template>
  
  <xsl:template match="GenericSoftware" mode="name">
    <td class="beta">
      <xsl:value-of select="@name"/>
      <xsl:value-of select="key('genericequipmentlookupid',@GenericEquipment_ref)/@name"/>
    </td>
  </xsl:template>
  <!--==========================================-->  
  <!-- TEMPLATES TO FILL IN ISA-TAB STUDY DETAILS FROM FUGE INVESTIGATION -->
  
  <xsl:template match="Investigation" mode="id">
    <td class="beta"><xsl:value-of select="@identifier"/></td>
  </xsl:template>
  <xsl:template match="Investigation" mode="name">
    <td class="beta"><xsl:value-of select="@name"/></td>
  </xsl:template>
  <xsl:template match="Investigation" mode="date">
    <td class="beta"><xsl:value-of select="substring-before(@start,'T')"/></td>
  </xsl:template>
  <xsl:template match="Investigation" mode="contactlastname">
    <xsl:apply-templates select="ContactRole" mode="lastname"/>
  </xsl:template>
  <xsl:template match="Investigation" mode="contactfirstname">
    <xsl:apply-templates select="ContactRole" mode="firstname"/>
  </xsl:template>
  <xsl:template match="Investigation" mode="contactmidinitials">
    <xsl:apply-templates select="ContactRole" mode="midinitials"/>
  </xsl:template>
  <xsl:template match="Investigation" mode="contactemail">
    <xsl:apply-templates select="ContactRole" mode="email"/>
  </xsl:template>
  <xsl:template match="Investigation" mode="contactphone">
    <xsl:apply-templates select="ContactRole" mode="phone"/>
  </xsl:template>
  <xsl:template match="Investigation" mode="contactfax">
    <xsl:apply-templates select="ContactRole" mode="fax"/>
  </xsl:template>
  <xsl:template match="Investigation" mode="contactaddress">
    <xsl:apply-templates select="ContactRole" mode="address"/>
  </xsl:template>
  <xsl:template match="Investigation" mode="contactrole">
    <xsl:apply-templates select="ContactRole/_role" mode="ontoind"/>
  </xsl:template>
  <xsl:template match="Investigation" mode="contactrolesrc">
    <xsl:apply-templates select="ContactRole/_role" mode="ontosrc"/>
  </xsl:template>
  <xsl:template match="Investigation" mode="contactroleaccnum">
    <xsl:apply-templates select="ContactRole/_role" mode="accnum"/>
  </xsl:template>
  <xsl:template match="Investigation" mode="contactaffiliation">
    <xsl:apply-templates select="ContactRole" mode="affiliation"/>
  </xsl:template>
  
  <xsl:template match="Investigation" mode="bibrefauthors">
    <xsl:apply-templates select="_bibliographicReferences" mode="authors"/>
  </xsl:template>
  <xsl:template match="Investigation" mode="bibreftitle">
    <xsl:apply-templates select="_bibliographicReferences" mode="title"/>
  </xsl:template>
  <xsl:template match="Investigation" mode="bibrefpubmed">
    <xsl:apply-templates select="_bibliographicReferences" mode="name"/>
  </xsl:template>
  
  <xsl:template match="Investigation" mode="hypothesis">
    <xsl:apply-templates select="_hypothesis" mode="text"/>
  </xsl:template>
  <xsl:template match="Investigation" mode="description">
    <xsl:apply-templates select="_descriptions" mode="text"/>
  </xsl:template>
  <xsl:template match="Investigation" mode="conclusion">
    <xsl:apply-templates select="_conclusion" mode="text"/>
  </xsl:template>
  <!--==========================================-->
  
  
  <!-- TEMPLATES TO PROCESS FUGE CONTACTS -->
  
  <xsl:template match="ContactRole" mode="lastname">
    <td class="beta">
      <xsl:value-of select="key('personlookupid',@Contact_ref)/@lastName"/>
    </td>
  </xsl:template>
  <xsl:template match="ContactRole" mode="firstname">
    <td class="beta">
      <xsl:value-of select="key('personlookupid',@Contact_ref)/@firstName"/>
    </td>
  </xsl:template>
  <xsl:template match="ContactRole" mode="midinitials">
    <td class="beta">
      <xsl:value-of select="key('personlookupid',@Contact_ref)/@midInitials"/>
    </td>
  </xsl:template>
  <xsl:template match="ContactRole" mode="email">
    <td class="beta">
      <xsl:value-of select="key('personlookupid',./@Contact_ref)/@email"/>
    </td>
  </xsl:template>
  <xsl:template match="ContactRole" mode="phone">
    <td class="beta">
      <xsl:value-of select="key('personlookupid',./@Contact_ref)/@phone"/>
    </td>
  </xsl:template>
  <xsl:template match="ContactRole" mode="fax">
    <td class="beta">
      <xsl:value-of select="key('personlookupid',./@Contact_ref)/@fax"/>
    </td>
  </xsl:template>
  <xsl:template match="ContactRole" mode="address">
    <td class="beta">
      <xsl:value-of select="key('personlookupid',./@Contact_ref)/@address"/>
    </td>
  </xsl:template>
  
  <xsl:template match="ContactRole/_role" mode="ontoind">
    <td class="beta">
      <xsl:value-of select="key('ontoindlookupid',./@OntologyTerm_ref)/@term"/>
    </td>
  </xsl:template>
  
  <xsl:template match="ContactRole/_role" mode="accnum">
    <td class="beta">
      <xsl:value-of select="key('ontoindlookupid',./@OntologyTerm_ref)/@termAccession"/>
    </td>
  </xsl:template>
  
  <xsl:template match="ContactRole/_role" mode="ontosrc">
    <td class="beta">
      <xsl:value-of select="key('ontosourcelookupid',key('ontoindlookupid',./@OntologyTerm_ref)/@OntologySource_ref)/@name"/>
    </td>
  </xsl:template>
  
  <xsl:template match="ContactRole" mode="affiliation">
    <td class="beta">
      <xsl:value-of select="key('organizationlookupid',key('personlookupid',./@Contact_ref)/_affiliations/@Organization_ref)/@name"/>
    </td>
  </xsl:template>
  <!--==========================================-->
  
  
  
  <!-- TEMPLATES TO PROCESS FACTORS -->
  <xsl:template match="Factor" mode="name">
    <td class="beta"><xsl:value-of select="@name"/></td>					
  </xsl:template>
  
  <xsl:template match="Factor" mode="type">
    <td class="beta">
      <xsl:value-of select="key('ontoindlookupid',child::_factorType/@OntologyTerm_ref)/@term"/>
      <!--<xsl:value-of select="child::_factorType/@OntologyTerm_ref"/>-->
    </td>					
  </xsl:template>
  
  <xsl:template match="Factor" mode="term">
    <td class="beta">
      <xsl:value-of select="key('ontoindlookupid',child::_factorType/@OntologyTerm_ref)/@termAccession"/></td>					
  </xsl:template>
  
  <xsl:template match="Factor" mode="source">
    <td class="beta">
      <xsl:value-of select="key('ontosourcelookupid',key('ontoindlookupid',child::_factorType	/@OntologyTerm_ref)/@OntologySource_ref)/@name"/>
    </td>					
  </xsl:template>
  <!--==========================================-->
  
  
  <!-- TEMPLATES TO PROCESS INVESTIGATIONS COMPONENTS AND CREATE ASSAYS -->
  <xsl:template match="InvestigationComponent" mode="name">
    <td class="beta"><xsl:value-of select="@name"/></td>					
  </xsl:template>
  
  <xsl:template match="InvestigationComponent" mode="type">
    <td class="beta">
      <xsl:value-of select="key('ontoindlookupid',child::_componentType/@OntologyTerm_ref)/@term"/>
      <!--<xsl:value-of select="child::_factorType/@OntologyTerm_ref"/>-->
    </td>					
  </xsl:template>
  
  <xsl:template match="InvestigationComponent" mode="term">
    <td class="beta">
      <xsl:value-of select="key('ontoindlookupid',child::_componentType/@OntologyTerm_ref)/@termAccession"/></td>					
  </xsl:template>
  
  <xsl:template match="InvestigationComponent" mode="source">
    <td class="beta">
      <xsl:value-of select="key('ontosourcelookupid',key('ontoindlookupid',child::_componentType/@OntologyTerm_ref)/@OntologySource_ref)/@name"/>
    </td>					
  </xsl:template>
  <!--==========================================-->
  
  
  <!-- TEMPLATES TO PROCESS DESCRIPTION-->
  
  <xsl:template match="_descriptions" mode="text">
    <xsl:apply-templates select="Description"/>
    <br/>
  </xsl:template>
  <xsl:template match="_hypothesis" mode="text">
    <xsl:apply-templates select="Description"/>
    <br/>	
  </xsl:template>
  <xsl:template match="_conclusion" mode="text">
    <xsl:apply-templates select="Description"/>
    <br/>
  </xsl:template>
  
  <xsl:template match="Description">
    <xsl:value-of select="@text"/>
    <br/>
  </xsl:template>
  <!--==========================================-->
  
  
  <xsl:template match="InvestigationComponent" mode="name">
    <td class="beta">
      <xsl:value-of select="@name"/>
    </td>
  </xsl:template>
  
  
  <!-- TEMPLATES TO PROCESS BIBREF -->
  <xsl:template match="_bibliographicReferences" mode="name">
    <td class="beta">
      <xsl:value-of select="key('bibreflookupid',./@BibliographicReference_ref)/@name"/>
    </td>
  </xsl:template>
  <xsl:template match="_bibliographicReferences" mode="authors">
    <td class="beta">
      <xsl:value-of select="key('bibreflookupid',./@BibliographicReference_ref)/@authors"/>
    </td>
  </xsl:template>
  <xsl:template match="_bibliographicReferences" mode="title">
    <td class="beta">
      <xsl:value-of select="key('bibreflookupid',./@BibliographicReference_ref)/@title"/>
    </td>
  </xsl:template>
  <xsl:template match="_bibliographicReferences" mode="publication">
    <td class="beta">
      <xsl:value-of select="key('bibreflookupid',./@BibliographicReference_ref)/@publication"/>
    </td>
  </xsl:template>
  <xsl:template match="_bibliographicReferences" mode="year">
    <td class="beta">
      <xsl:value-of select="key('bibreflookupid',./@BibliographicReference_ref)/@year"/>
    </td>
  </xsl:template>
  <xsl:template match="_bibliographicReferences" mode="pages">
    <td class="beta">
      <xsl:value-of select="key('bibreflookupid',./@BibliographicReference_ref)/@pages"/>
    </td>
  </xsl:template>
  <xsl:template match="_bibliographicReferences" mode="volume">
    <td class="beta">
      <xsl:value-of select="key('bibreflookupid',./@BibliographicReference_ref)/@volume"/>
    </td>
  </xsl:template>
  <!--==========================================-->
  
  
  <!-- TEMPLATES TO PROCESS FUGE PROTOCOLS -->
  
  <xsl:template match="GenericProtocol" mode="name">
    <td class="beta">
      <xsl:value-of select="@name"/>
    </td>
  </xsl:template>
  
  <xsl:template match="GenericProtocol" mode="text">
    <xsl:value-of select="@protocolText"/>
  </xsl:template>
  
  <xsl:template match="GenericProtocol" mode="description">
    <xsl:apply-templates select="GenericAction"/>
  </xsl:template>
  
  
  <xsl:template match="GenericProtocol" mode="equipment">
    <xsl:apply-templates select="_equipment"/>
  </xsl:template>
  <xsl:template match="GenericProtocol" mode="software">
    <xsl:apply-templates select="GenericSoftware"/>
  </xsl:template>
  <xsl:template match="GenericProtocol" mode="parameter">
    <xsl:apply-templates select="GenericParameter" mode="name"/>
  </xsl:template>
  
  <xsl:template match="_equipment">
    <td class="beta">
      <xsl:value-of select="@GenericEquipment_ref"/>
      <br/>
      <xsl:value-of select="key('genericequipmentlookupid',@GenericEquipment_ref)/@name"/>
    </td>
  </xsl:template>
  
  <xsl:template match="GenericAction">
    <xsl:value-of select="@actionOrdinal"/>
    <xsl:text>: </xsl:text>
    <xsl:value-of select="@actionText"/>
  </xsl:template>
  
  
  <xsl:template match="GenericParameter" mode="name">
    <td class="beta">
      <xsl:value-of select="@name"/>
      <xsl:value-of select="key('genericequipmentlookupid',@GenericEquipment_ref)/@name"/>
    </td>
  </xsl:template>
  
  <xsl:template match="GenericSoftware" mode="name">
    <td class="beta">
      <xsl:value-of select="@name"/>
      <xsl:value-of select="key('genericequipmentlookupid',@GenericEquipment_ref)/@name"/>
    </td>
  </xsl:template>
  <!--==========================================-->



</xsl:stylesheet>