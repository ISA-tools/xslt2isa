<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#160;">
  <!ENTITY copy "&#169;">
]>
<!--
xsl stylesheet prototype for rendering FUGE XML documents in html ISA-TAB  
Author: Philippe Rocca-Serra, EMBL-EBI (rocca@ebi.ac.uk) , March 2008
-->
<xsl:stylesheet 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
 xmlns:fuge="http://fuge.sourceforge.net/fuge/1.0"
 xmlns:fcm="http://flowcyt.sourceforge.net/fugeflow/"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

<xsl:output method="html"/>

  <xsl:key name="PAlookup" match="fuge:GenericProtocolApplication" use="@identifier"/>
  
 
 <xsl:key name="PAby_inputCompleteMaterials"
          match="fuge:GenericProtocolApplication/fuge:_inputCompleteMaterials"
          use="parent::node()/@identifier"/>
  	   
  <xsl:key name="PAby_GenericMaterialMeasurement"
           match="fuge:GenericProtocolApplication/fuge:GenericMaterialMeasurement"
  	       use="@Material_ref"/>

 <xsl:key name="PAby_inputCompleteMaterials"
          match="fuge:GenericProtocolApplication/GenericProtocolApplication"
          use="parent::node()/@identifier"/> 
  	   
  <xsl:key name="PAby_outputMaterials"
           match="fuge:GenericProtocolApplication/fuge:_outputMaterials"
  	       use="@Material_ref"/>
  	   
  <xsl:key name="PAby_outputData" 
           match="fuge:GenericProtocolApplication/fuge:_outputData"
  	       use="@Data_ref"/>

  <xsl:key name="PAby_inputData" 
           match="fuge:GenericProtocolApplication"
  	       use="child::fuge:_inputData/@Data_ref"/>
  	       
    <xsl:key name="PAby_inputData_by_id" 
           match="fuge:GenericProtocolApplication/fuge:_inputData"
  	       use="parent::node()/@identifier"/>	       

<xsl:key name="gidlookup" match="fuge:GenericInternalData" use="@identifier"/>

  <xsl:key name="datafilelookupid"
           match="fcm:ListModeDataFile"
           use="@identifier"/>
 
    <xsl:key name="cytometerlookupid"
           match="fcm:Cytometer"
           use="@identifier"/>

    <xsl:key name="opticalfilterlookupid"
           match="fcm:OpticalFilter"
           use="@identifier"/>

     <xsl:key name="opticaldetectorlookupid"
           match="fcm:OpticalDetector"
           use="@identifier"/>

     <xsl:key name="lightsourcelookupid"
           match="fcm:LightSource"
           use="@identifier"/>
           
   <xsl:key name="softwarelookupid"
           match="fcm:Software"
           use="@identifier"/>           
 

   <xsl:key name="fluoreagentlookupid"
           match="fcm:FluorescentReagent"
           use="@identifier"/>
           
  <xsl:key name="samplelookupid"
           match="fcm:Sample"
           use="@identifier"/>
 
 <xsl:key name="organism"
          match="fcm:Organism"
          use="@identifier"/>
          
  
 <xsl:key name="ontoindlookupid"  match="fuge:OntologyIndividual"  use="@identifier"/>
 <xsl:key name="ontosourcelookupid"  match="//fuge:OntologyCollection/fuge:OntologySource"  use="@identifier"/>
 <xsl:key name="ontosourceforontoind"  match="//fuge:OntologyCollection/fuge:OntologyIndividual"  use="@OntologySource_ref"/>
 <xsl:key name="genotype" match="fcm:Genotype" use="@identifier"/>
 <xsl:key name="phenotype" match="fcm:Phenotype" use="@identifier"/>
 <xsl:key name="dataproplookupid" match="fuge:DataProperty" use="@identifier"/> 
 <xsl:key name="bibreflookupid" match="fuge:BibliographicReference" use="@identifier"/> 
 <xsl:key name="personlookupid" match="fuge:Person" use="@identifier"/>
 <xsl:key name="orglookupid" match="fuge:Organization" use="@identifier"/>
 
<xsl:template match="fuge:FuGE">	
<html>
 <head>
   <title>FuGE Submission</title>
 </head>
 
  <link rel="stylesheet"
       type="text/css"
       href="mystyle.css">
  </link>
                                  
  <script src="tabs.js" type="text/javascript"></script> 
 
  <body bgcolor="gray">
   <p>
    <h1>
     <img class="floatleft" src="logo-3.png" alt="ISATAB Logo" />
         <font color="#006838" face="Verdana" size="2pt">
                            <b>FuGE Document:</b>
      						<xsl:value-of select="@identifier"/>
     	</font>
    </h1>
   </p>
   
 <ul class = "tabs primary">
    <li class="active"><a href="#investigation">investigation</a></li>
	<li><a href="#instruments">instruments</a></li>	
	<li><a href="#reagents">reagents</a></li>
    <li><a href="#studies">study(ies)</a></li>
    <li><a href="#assays">assay(s)</a></li>
 </ul>   
   
   
   <div class="content" id="investigation">
   		<xsl:apply-templates select="fuge:OntologyCollection"/>
  		 <br/>
   		<xsl:apply-templates select="fuge:InvestigationCollection"/>
   		<br/>
   		<xsl:apply-templates select="fuge:ProtocolCollection"/>  
   		<br/>
   	</div>
   	
   <div class="content" id="instruments">		
   <table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
    <tr>
       <td class="delta">INSTRUMENT TAB</td>
    </tr>
    <tr bgcolor="#006838">
     <td class="delta">Instrument Name</td>
     <td class="delta">make</td>
     <td class="delta">model</td>    
     <td class="delta">components</td>       
    </tr>
    <xsl:apply-templates select="//fcm:Cytometer"/>
   </table>
   </div>
   

   
	<div class="content" id="reagents">
   <table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
    <tr>
       <td class="delta">REAGENT TAB</td>
    </tr>
    <tr>
     <td class="delta">Reagent Name</td>
     <td class="delta">make</td>
     <td class="delta">analyte detector</td>    
     <td class="delta">reporter</td>
     <td class="delta">catalog Number</td> 
     <td class="delta">measured characteristic</td>        
    </tr>
    <xsl:apply-templates select="//fcm:FluorescentReagent"/>
   </table>   
  </div>
    
  <div class="content" id="studies">
   <table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
    <tr>
       <td class="delta">STUDY TAB</td>
    </tr>
    <tr>
     <td class="delta">Source</td>
     <td class="delta">Comment[description]</td>
     <td class="delta">characteristics[phenotype]</td>    
     <td class="delta">characteristics[genotype]</td>
     <td class="delta">characteristics[gender]</td> 
     <td class="delta">characteristics[taxonomic information]</td>        
     <td class="delta">characteristics[age]</td>  
     <td class="delta">Protocol REF</td>
     <td class="delta">Parameter[Instrument]</td>
     <td class="delta">Date</td>
     <td class="delta">Sample</td>
    </tr>
     <xsl:apply-templates select="//fuge:_outputMaterials"/>
    </table>
	</div>
	
	<div class="content" id="assays">   
      <!--<table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10" style:table-layout:fixed;>-->  
      <!--<th width="10%">--> 
	   <table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
	    <tr>
       		<td class="delta">ASSAY TAB</td>
   		</tr>
	    <tr bgcolor="#006838">
	     <td class="delta">Sample</td>
	     <td class="delta">Label</td>
	     <td class="delta">Protocol REF</td>
	     <td class="delta">Parameter[Instrument]</td>
	     <td class="delta">Parameter[optical path]</td>
	     <td class="delta">Parameter[detector voltage]</td>
	     <td class="delta">Unit Term</td>     
	     <td class="delta">Date</td>    
	     <td class="delta">Raw Data File</td>
	     <td class="delta">Protocol REF</td>
	     <td class="delta">Parameter[software]</td>
	     <td class="delta">Date</td>          
		 <td class="delta">Derived Data File</td>
		 <td class="delta">Comment[Summary Data]</td>     
	    </tr>
	       <xsl:apply-templates select="//fuge:_outputData"/>    
	    </table>
	</div>
   
   </body>
</html>
</xsl:template>
<!--
<xsl:template name="PA" match="//fuge:GenericProtocolApplication">
  <xsl:if test="child::fuge:GenericMaterialMeasurement and child::fuge:_outputMaterials">
  <xsl:variable name="currentGMM" select="child::fuge:GenericMaterialMeasurement/@Material_ref"/>
  <tr> 
   <td bgcolor="#CCCCC">
    <xsl:choose>
     <xsl:when test="key('PAby_outputMaterials',$currentGMM)">
      <xsl:text>I have a parent ! </xsl:text>
     <xsl:call-template name="PA"/>
     </xsl:when>
     <xsl:otherwise>I am the Source: 
      <xsl:value-of select="child::fuge:GenericMaterialMeasurement/@Material_ref"/>
     </xsl:otherwise>
    </xsl:choose>
    </td>
   <td bgcolor="#22222"><xsl:value-of select="@identifier"/></td>  
   <td bgcolor="#CCCCC"><xsl:value-of select="child::fuge:_outputMaterials/@Material_ref"/></td>
  </tr>
 </xsl:if>
 
  <xsl:if test="child::fuge:_inputCompleteMaterials and child::fuge:_outputMaterials">
  <xsl:variable name="currentInputmaterial" select="child::fuge:_inputCompleteMaterials/@Material_ref"/>
  <tr> 
   <td bgcolor="#FFFFF">   
      <xsl:choose>
     <xsl:when test="key('PAby_outputMaterials',$currentInputmaterial)">
     <xsl:text>I have a parent ! </xsl:text>
     <xsl:apply-templates select="//fuge:GenericProtocolApplication"/>
     </xsl:when>
     <xsl:otherwise>I am the Source: 
      <xsl:value-of select="child::fuge:_inputCompleteMaterials/@Material_ref"/>
     </xsl:otherwise>
     </xsl:choose>
    
   </td>
   <td bgcolor="#22222"><xsl:value-of select="@identifier"/></td>  
   <td bgcolor="#FFFFF"><xsl:value-of select="child::fuge:_outputMaterials/@Material_ref"/></td>
  </tr>
 </xsl:if>
  
  <xsl:if test="child::fuge:_inputCompleteMaterials and child::fuge:_outputData">
 <xsl:variable name="currentInputmaterial" select="child::fuge:_inputCompleteMaterials/@Material_ref"/>
  <tr>
   <td bgcolor="#55555">
    <xsl:choose>
     <xsl:when test="key('PAby_outputMaterials',$currentInputmaterial)">
      <xsl:text>I have a parent ! </xsl:text>
     </xsl:when>
     <xsl:otherwise>I am the Source: 
      <xsl:value-of select="child::fuge:_inputCompleteMaterials/@Material_ref"/>
     </xsl:otherwise>
    </xsl:choose>
    </td>
   <td bgcolor="#22222"><xsl:value-of select="@identifier"/></td>
   <td bgcolor="#55555"> <xsl:value-of select="child::fuge:_outputData/@Data_ref"/></td>
  </tr>
 </xsl:if>
 
  <xsl:if test="child::fuge:GenericMaterialMeasurement and child::fuge:_outputData">
   <tr>
   <td bgcolor="#33333"><xsl:value-of select="child::fuge:GenericMaterialMeasurement/@Material_ref"/></td>
   <td bgcolor="#22222"><xsl:value-of select="@identifier"/></td>
   <td bgcolor="#33333"> <xsl:value-of select="child::fuge_outputData/@Data_ref"/></td>
   </tr>
  </xsl:if>
</xsl:template>
-->
 
 <xsl:template name="PA2" match="//fuge:_outputData">
  <xsl:variable name="color">
   <xsl:choose>
    <xsl:when test="position() mod 2= 0">#A8A8A8</xsl:when>
    <xsl:otherwise>#CCCCCC</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  
  <tr bgcolor="{$color}">
   <!--If there is output data, this checks if the input was material -->
   <xsl:if test="parent::node()/fuge:_inputCompleteMaterials">
   	<td>
   	 <font color="#006838" face="Arial" size="2pt">
     <xsl:value-of select="parent::node()/fuge:_inputCompleteMaterials/@Material_ref"/>
     </font>
    </td>   

    <!--Use of a lookup on Sample to navigate from ProtocolApplication input Material and fetch Labels associated to this Sample, if found get the label value -->
    	<xsl:if test="key('samplelookupid',parent::node()/fuge:_inputCompleteMaterials/@Material_ref)">
    	<td><font color="#006838" face="Arial" size="2pt">
    		<xsl:for-each select="key('samplelookupid',parent::node()/fuge:_inputCompleteMaterials/@Material_ref)/fcm:_stainingReagent">
    			<xsl:value-of select="key('fluoreagentlookupid',@FluorescentReagent_ref)/@name"/>;
    		</xsl:for-each>
    	</font></td>
    	</xsl:if>

<!-- For the current selected PA node with an output data, get the Protocol, Instrument and Parameter and their associated Values -->

   	<td><font color="#006838" face="Arial" size="2pt">
    	<xsl:value-of select="parent::node()/@Protocol_ref"/>
   	</font></td>
   	<td><font color="#006838" face="Arial" size="2pt">
   	<!--<xsl:value-of select="parent::node()/fuge:EquipmentApplication/@Equipment_ref"/>-->
   	   <xsl:value-of select="key('ontoindlookupid',key('cytometerlookupid',parent::node()/fuge:EquipmentApplication/@Equipment_ref)/fuge:_model/@OntologyTerm_ref)/@term"/>.
   	   <xsl:value-of select="key('ontoindlookupid',key('cytometerlookupid',parent::node()/fuge:EquipmentApplication/@Equipment_ref)/fuge:_make/@OntologyTerm_ref)/@term"/>	Flow Cytometer
    </font></td>
   	<xsl:if test="parent::node()/fuge:ActionApplication">
   	   <td><font color="#006838" face="Arial" size="2pt"> 
    		<xsl:for-each select="parent::node()/fuge:ActionApplication/fuge:ParameterValue">
   			 <xsl:value-of select="@Parameter_ref"/>;
   		 	</xsl:for-each>
  		   </font></td>
    </xsl:if>
  	<xsl:if test="parent::node()/fuge:ActionApplication">
     	   <td> <font color="#006838" face="Arial" size="2pt">
		   	<xsl:for-each select="parent::node()/fuge:ActionApplication/fuge:ParameterValue">
   			 <xsl:value-of select="child::fuge:AtomicValue/@value"/>;
			</xsl:for-each>
 		   </font></td>
 		   <td><font color="#006838" face="Arial" size="2pt"><xsl:value-of select="key('ontoindlookupid',parent::node()/fuge:ActionApplication/fuge:ParameterValue/fuge:AtomicValue/fuge:_unit/@OntologyTerm_ref)/@term"/>
 		   </font></td>
    </xsl:if>

	<td><font color="#006838" face="Arial" size="2pt">
    		<xsl:value-of select="substring-before(parent::node()/@activityDate, 'T')"/>
   		</font></td>  
  		 <td><font color="#006838" face="Arial" size="2pt">
    		<xsl:value-of select="key('datafilelookupid',@Data_ref)/@location"/>
  		 </font></td>
  		 
  		 
  		 
    <td>	
     <!--<xsl:value-of select="parent::node()/fuge:_outputData/@Data_ref"/>-->
     <!--<xsl:value-of select="@Data_ref"/>-->
        <xsl:if test="key('PAby_inputData',@Data_ref)">
       		<font color="#006838" face="Arial" size="2pt">
       		<xsl:value-of select="key('PAby_inputData',@Data_ref)/@Protocol_ref"/>
			</font>
		</xsl:if>
	</td>
			<td>
			<font color="#006838" face="Arial" size="2pt">
			<xsl:choose>
				<xsl:when test="key('softwarelookupid',key('PAby_inputData',@Data_ref)/fuge:SoftwareApplication/@Software_ref)/fuge:_uri">
				<a href="key('softwarelookupid',key('PAby_inputData',@Data_ref)/fuge:SoftwareApplication/@Software_ref)/fuge:_uri/fuge:URI/@location">
       			<xsl:value-of select="key('softwarelookupid',key('PAby_inputData',@Data_ref)/fuge:SoftwareApplication/@Software_ref)/@name"/>
       			version:
       			<xsl:value-of select="key('softwarelookupid',key('PAby_inputData',@Data_ref)/fuge:SoftwareApplication/@Software_ref)/@version"/>
       			</a>
       			</xsl:when>
       			<xsl:otherwise>
       			<xsl:value-of select="key('softwarelookupid',key('PAby_inputData',@Data_ref)/fuge:SoftwareApplication/@Software_ref)/@name"/>
       			version:
       			<xsl:value-of select="key('softwarelookupid',key('PAby_inputData',@Data_ref)/fuge:SoftwareApplication/@Software_ref)/@version"/>       			</xsl:otherwise>
       		</xsl:choose>	
       			</font>
			</td>
			<td>
			<font color="#006838" face="Arial" size="2pt">
       			<xsl:value-of select="substring-before(key('PAby_inputData',@Data_ref)/@activityDate, 'T')"/>
       			
       			</font>
			</td>						
			<td>
			<font color="#006838" face="Arial" size="2pt">
       			<xsl:value-of select="key('PAby_inputData',@Data_ref)/fuge:_outputData/@Data_ref"/>
       			</font>
			</td>
			<td width="150">
       			<font color="#006838" face="Arial" size="2pt">
   				<xsl:value-of select="key('gidlookup',key('PAby_inputData',@Data_ref)/fuge:_outputData/@Data_ref)/fuge:storage/."/>
   				</font>
  			</td>			
  	    </xsl:if>  	
   
  		 	
 <!-- </xsl:if>-->
   
   </tr> 
  </xsl:template>
 
 
 <xsl:template name="getParentMaterial" match="//fuge:_outputMaterials">
 
  <xsl:param name="test1"  select="parent::node()/fuge:_inputCompleteMaterials"/>
  <xsl:param name="test2"  select="parent::node()/fuge:GenericMaterialMeasurement"/>
  <xsl:variable name="thisoutput" select="@Material_ref"/>
  <xsl:variable name="color">
   <xsl:choose>
    <xsl:when test="position() mod 2= 0">#A8A8A8</xsl:when>
    <xsl:otherwise>#CCCCCC</xsl:otherwise>
   </xsl:choose>
  </xsl:variable> 
    <xsl:choose>
   
   <!--check whether the input is GenericMaterialMeasurement or _inputCompleteMaterials -->
   <!--Test for the First Case: input material is coded as '_inputCompleteMaterials'-->
   <xsl:when test="$test1">
    <tr bgcolor="{$color}">
     <td><font color="#006838" face="Arial" size="2pt"><xsl:value-of select="$test1/@Material_ref"/></font></td>
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

      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('organism',$test1/@Material_ref)/fuge:_descriptions/fuge:Description/@text"/></font></td>
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('phenotype',key('organism',$test1/@Material_ref)/fcm:_phenotype/@Phenotype_ref)/@term"/></font></td>
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('genotype',key('organism',$test1/@Material_ref)/fcm:_genotype/@Genotype_ref)/@term"/></font></td>    
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('ontoindlookupid',key('organism',$test1/@Material_ref)/fcm:_gender/@OntologyTerm_ref)/@term"/></font></td>
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('ontoindlookupid',key('organism',$test1/@Material_ref)/fcm:_taxnomyNCBI/@OntologyTerm_ref)/@term"/></font></td>
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('dataproplookupid',key('organism',$test1/@Material_ref)/fcm:_age/@DataProperty_ref)/@term"/></font></td>                     
      
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="parent::node()/@identifier"/></font></td>     
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="parent::node()/fuge:EquipmentApplication/@Equipment_ref"/></font></td> 
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="substring-before(parent::node()/@activityDate, 'T')"/></font></td> 
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="@Material_ref"/></font></td>
      <xsl:call-template name="tt">
         <xsl:with-param name="thisoutput" select="$thisoutput"/>
      </xsl:call-template>
     <!-- HERE: TODO: I should call a getDescendantMaterial Template in order to go further-->
      <xsl:apply-templates select="//fuge:GenericProtocolApplication"/>
     </xsl:when>  

     <xsl:otherwise>
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="parent::node()/@identifier"/></font></td>
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('organism',@Material_ref)/fuge:_descriptions/fuge:Description/@text"/></font></td>
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('phenotype',key('organism',Material_ref)/fcm:_phenotype/@Phenotype_ref)/@term"/></font></td>
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('genotype',key('organism',@Material_ref)/fcm:_gnotype/@Genotype_ref)/@term"/></font></td> 
      <td><font color="#006838" face="Arial" size="2pt">   
      <xsl:value-of select="key('ontoindlookupid',key('organism',@Material_ref)/fcm:_gender/@OntologyTerm_ref)/@term"/></font></td>
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('ontoindlookupid',key('organism',@Material_ref)/fcm:_taxnomyNCBI/@OntologyTerm_ref)/@term"/></font></td>
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('dataproplookupid',key('organism',@Material_ref)/fcm:_age/@DataProperty_ref)/@term"/></font></td>                        
 
           <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="parent::node()/fuge:EquipmentApplication/@Equipment_ref"/></font></td> 
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="substring-before(parent::node()/@activityDate, 'T')"/></font></td> 
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="@Material_ref"/></font></td>
     </xsl:otherwise>
   </xsl:choose>
  </tr>   
   </xsl:when>
    
   <!--Test for the Second Case: input material is coded as 'GenericMaterialMeasurement'-->
   <xsl:when test="$test2">
    <tr bgcolor="{$color}">
      <td><font color="#006838" face="Arial" size="2pt"><xsl:value-of select="$test2/@Material_ref"/></font></td>
    <!-- check if current input=Material is also output of a ProtocolApplication-->
    <xsl:choose>
     <xsl:when test="key('PAby_outputMaterials',$test2/@Material_ref)">
     <!--2.1 Is it True that this inputCompleteMaterial is also an output of another PA?  YES    --> 

      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('organism',@Material_ref)/fuge:_descriptions/fuge:Description/@text"/></font></td>
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('phenotype',key('organism',@Material_ref)/fcm:_phenotype/@Phenotype_ref)/@term"/></font></td> 
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('genotype',key('organism',@Material_ref)/fcm:_genotype/@Genotype_ref)/@term"/></font></td>
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('ontoindlookupid',key('organism',@Material_ref)/fcm:_gender/@OntologyTerm_ref)/@term"/></font></td>
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('ontoindlookupid',key('organism',@Material_ref)/fcm:_taxnomyNCBI/@OntologyTerm_ref)/@term"/></font></td>
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('dataproplookupid',key('organism',@Material_ref)/fcm:_age/@DataProperty_ref)/@term"/></font></td>                  
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="parent::node()/@identifier"/></font></td>              
     <td><font color="#006838" face="Arial" size="2pt">
      <xsl:value-of select="parent::node()/fuge:EquipmentApplication/@Equipment_ref"/></font></td>     
     <td><font color="#006838" face="Arial" size="2pt">
      <xsl:value-of select="substring-before(parent::node()/@activityDate, 'T')"/></font></td>     
     <td><font color="#006838" face="Arial" size="2pt">
      <xsl:value-of select="@Material_ref"/></font></td>
      <xsl:call-template name="tt">
           <xsl:with-param name="thisoutput" select="$thisoutput"/>
      </xsl:call-template>
   
      <!-- <xsl:apply-templates select="//fuge:GenericProtocolApplication"/>
      <xsl:call-template name="getParentMaterial">
      <xsl:with-param name="test2" select="$test2[position()!=1]"/>
     </xsl:call-template>
     -->
    </xsl:when>
     <xsl:when test="key('PAby_GenericMaterialMeasurement',@Material_ref) or key('PAby_inputCompleteMaterials',@Material_ref)">
     <!-- 2.2.Is it True that this output material <xsl:value-of select="@Material_ref"/> on this PA is also a inputComplete material in another PA ? YES -->
      <td bgcolor="#CCCCC"><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="parent::node()/@identifier"/></font></td>
      <td bgcolor="#CCCCC"><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('organism',@Material_ref)/fuge:_descriptions/fuge:Description/@text"/></font></td>
      <td bgcolor="#CCCCC"><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('phenotype',key('organism',@Material_ref)/fcm:_phenotype/@Phenotype_ref)/@term"/></font></td>  
      <td bgcolor="#CCCCC"><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('genotype',key('organism',@Material_ref)/fcm:_genotype/@Genotype_ref)/@term"/></font></td>         
      <td bgcolor="#CCCCC"><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('ontoindlookupid',key('organism',@Material_ref)/fcm:_gender/@OntologyTerm_ref)/@term"/></font></td>         
      <td bgcolor="#CCCCC"><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('ontoindlookupid',key('organism',@Material_ref)/fcm:_gender/@OntologyTerm_ref)/@term"/></font></td>
      <td bgcolor="#CCCCC"><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('ontoindlookupid',key('organism',@Material_ref)/fcm:_taxnomyNCBI/@OntologyTerm_ref)/@term"/></font></td>
      <td bgcolor="#CCCCC"><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="key('dataproplookupid',key('organism',@Material_ref)/fcm:_age/@DataProperty_ref)/@term"/></font></td>                        
      <td bgcolor="#CCCCC"><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="parent::node()/fuge:EquipmentApplication/@Equipment_ref"/></font></td> 
      <td bgcolor="#CCCCC"><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="substring-before(parent::node()/@activityDate, 'T')"/></font></td> 
      <td bgcolor="#CCCCC"><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="@Material_ref"/></font></td>
      <xsl:call-template name="getParentMaterial">
       <xsl:with-param name="test2" select="$test2[position()>1]"/>
      </xsl:call-template>     
     </xsl:when> 
     <xsl:otherwise>
      <td bgcolor="#CCCCC"><font color="#006838" face="Arial" size="2pt">output is: 
       <xsl:value-of select="@Material_ref"/></font></td>
     </xsl:otherwise>
    </xsl:choose>
    </tr>
   </xsl:when> 
   </xsl:choose>   
 </xsl:template> 
  
  
 <xsl:template name="tt" match="//fuge:GenericProtocolApplication">
 <xsl:param name="thisoutput"/> 
  <xsl:for-each select="//fuge:GenericProtocolApplication">
    <xsl:if test="child::fuge:_inputCompleteMaterials/@Material_ref = $thisoutput and not(child::fuge:_outputData)">
     <td bgcolor="#CCCCC"><font color="#006838" face="Arial" size="2pt">
      <xsl:value-of select="@identifier"/></font></td>
     <td><font color="#006838" face="Arial" size="2pt">
      <xsl:value-of select="key('organism',@Material_ref)/fuge:_descriptions/fuge:Description/@text"/></font></td>
     <td><font color="#006838" face="Arial" size="2pt">
      <xsl:value-of select="key('phenotype',key('organism',@Material_ref)/fcm:_phenotype/@Phenotype_ref)/@term"/></font></td>
     <td><font color="#006838" face="Arial" size="2pt">
      <xsl:value-of select="key('ontoindlookupid',key('organism',@Material_ref)/fcm:_gender/@OntologyTerm_ref)/@term"/></font></td>
     <td><font color="#006838" face="Arial" size="2pt">
      <xsl:value-of select="key('ontoindlookupid',key('organism',@Material_ref)/fcm:_taxnomyNCBI/@OntologyTerm_ref)/@term"/></font></td>
     <td><font color="#006838" face="Arial" size="2pt">
      <xsl:value-of select="key('dataproplookupid',key('organism',@Material_ref)/fcm:_age/@DataProperty_ref)/@term"/></font></td>                                  
        <td><font color="#006838" face="Arial" size="2pt">
         
         <xsl:value-of select="child::fuge:EquipmentApplication/@Equipment_ref"/></font></td>
     <td><font color="#006838" face="Arial" size="2pt">
      <xsl:value-of select="substring-before(@activityDate, 'T')"/></font></td>
     <td><font color="#006838" face="Arial" size="2pt">
      <xsl:value-of select="child::fuge:_outputMaterials/@Material_ref"/></font></td>
   </xsl:if>
   <xsl:if test="child::fuge:GenericMaterialMeasurement/@Material_ref = $thisoutput and not(child::fuge:_outputData)">
    <td><font color="#006838" face="Arial" size="2pt">
     <xsl:value-of select="@identifier"/></font></td>
    <td><font color="#006838" face="Arial" size="2pt">
     <xsl:value-of select="key('organism',@Material_ref)/fuge:_descriptions/fuge:Description/@text"/></font></td>
    <td><font color="#006838" face="Arial" size="2pt">
     <xsl:value-of select="child::fuge:EquipmentApplication/@Equipment_ref"/></font></td>
    <td><font color="#006838" face="Arial" size="2pt">
     <xsl:value-of select="substring-before(@activityDate, 'T')"/></font></td>    
    <td><font color="#006838" face="Arial" size="2pt">
     <xsl:value-of select="child::fuge:_outputMaterials/@Material_ref"/></font></td>      
   </xsl:if>  
  </xsl:for-each>
</xsl:template>
 
 <xsl:template name="reagent" match="fcm:FluorescentReagent">
  <xsl:variable name="color">
   <xsl:choose>
    <xsl:when test="position() mod 2= 0">#A8A8A8</xsl:when>
    <xsl:otherwise>#CCCCCC</xsl:otherwise>
   </xsl:choose>
  </xsl:variable> 
  <tr bgcolor="{$color}">
   <td><font color="#006838" face="Arial" size="2pt">
    <xsl:value-of select="@name"/></font></td>

    <xsl:if test="child::fcm:_make">
     <td><font color="#006838" face="Arial" size="2pt">
      <xsl:value-of select="key('ontoindlookupid',child::fcm:_make/@OntologyTerm_ref)/@term"/></font></td>
    </xsl:if>
    <xsl:if test="child::fcm:_analyteDetector">
     <td><font color="#006838" face="Arial" size="2pt">
      <xsl:value-of select="child::fcm:_analyteDetector/@AnalyteDetector_ref"/></font></td>
    </xsl:if>
    <xsl:if test="child::fcm:_reporter">
     <td><font color="#006838" face="Arial" size="2pt">
      <xsl:value-of select="child::fcm:_reporter/@Material_ref"/></font></td>
    </xsl:if>
    <xsl:if test="child::fcm:_catalogNumber">
     <td><font color="#006838" face="Arial" size="2pt">
      <xsl:value-of select="key('dataproplookupid',child::fcm:_catalogNumber/@DataProperty_ref)/@term"/></font></td>
    </xsl:if>
    <xsl:if test="child::fcm:_measuredCharacteristics">
     <td><font color="#006838" face="Arial" size="2pt">
      <xsl:value-of select="key('ontoindlookupid',child::fcm:_measuredCharacteristics/@OntologyTerm_ref)/@term"/></font></td>
    </xsl:if>             
   </tr>  
 </xsl:template>
 
 
 <xsl:template name="Instrument" match="fcm:Cytometer">
  <xsl:variable name="color">
   <xsl:choose>
    <xsl:when test="position() mod 2= 0">#A8A8A8</xsl:when>
    <xsl:otherwise>#CCCCCC</xsl:otherwise>
   </xsl:choose>
  </xsl:variable> 
  <tr  bgcolor="{$color}">
  <td align="left"><font color="#00333366" face="Arial" size="2pt">
   <xsl:value-of select="@identifier"/>
  </font></td>
   <xsl:if test="child::fuge:_make">
    <td><font color="#006838" face="Arial" size="2pt">
   <xsl:value-of select="key('ontoindlookupid',child::fuge:_make/@OntologyTerm_ref)/@term"/>
   </font></td>
  </xsl:if>
  <xsl:if test="child::fuge:_model">
   <td valign="top"><font color="#006838" face="Arial" size="2pt">
    <xsl:value-of select="key('ontoindlookupid',child::fuge:_model/@OntologyTerm_ref)/@term"/>
   </font></td>
  </xsl:if>
  <td valign="top"><font color="#006838" face="Arial" size="2pt">
  <xsl:if test="child::fcm:FlowCell">
    <xsl:value-of select="key('ontoindlookupid',child::fcm:FlowCell/fcm:_flowCellType/@OntologyTerm_ref)/@term"/>
    <br/>
    <xsl:value-of select="child::fcm:FlowCell/fcm:_flowCellOtherInfo/fuge:Description/@text"/>  
  </xsl:if> 
   <br/>
   <table bgcolor="#DDDDD" font-family="sans-serif" border="1" cellspacing="1" cellpadding="10">
    <tr>
     <td><font color="#006838" face="Arial" size="2pt">Optical Filter</font></td>
     <td><font color="#006838" face="Arial" size="2pt">make</font></td>
     <td><font color="#006838" face="Arial" size="2pt">model</font></td>
     <td><font color="#006838" face="Arial" size="2pt">transmitted wavelength</font></td>
     <td><font color="#006838" face="Arial" size="2pt">filter type</font></td>
     <td><font color="#006838" face="Arial" size="2pt">miscellaneous information</font></td>
    </tr>
   <xsl:if test="child::fcm:OpticalFilter">
    <xsl:for-each select="child::fcm:OpticalFilter">
     <tr>
      <td><font color="#006838" face="Arial" size="2pt">
       <xsl:value-of select="@identifier"/>
      </font></td>
      <td><font color="#006838" face="Arial" size="2pt">
     <xsl:value-of select="key('ontoindlookupid',child::fuge:_make/@OntologyTerm_ref)/@term"/>
      </font> </td> 
      <td><font color="#006838" face="Arial" size="2pt"> 
     <xsl:value-of select="key('ontoindlookupid',child::fuge:_model/@OntologyTerm_ref)/@term"/>
      </font></td>
      <td><font color="#006838" face="Arial" size="2pt">
     <xsl:value-of select="key('dataproplookupid',child::fcm:_minTransmittedWavelength/@DataProperty_ref)/@term"/>
      </font></td> 
      <td><font color="#006838" face="Arial" size="2pt">
     <xsl:value-of select="key('ontoindlookupid',child::fcm:_opticalFilterType/@OntologyTerm_ref)/@term"/>
      </font></td>
      <td><font color="#006838" face="Arial" size="2pt"> 
     <xsl:value-of select="child::fcm:_opticalFilterOtherInfo/fuge:Description/@text"/>
      </font></td> 
     </tr> 
    </xsl:for-each> 
   </xsl:if>
   </table>
   
   <br/>
   <table bgcolor="#DDDDD" font-family="sans-serif" border="1" cellspacing="1" cellpadding="10">
    <tr>
     <td><font color="#006838" face="Arial" size="2pt">Optical Detector</font></td>
     <td><font color="#006838" face="Arial" size="2pt">detector type</font></td>
     <td><font color="#006838" face="Arial" size="2pt">amplification type</font></td>
     <td><font color="#006838" face="Arial" size="2pt">voltage</font></td>
     <td><font color="#006838" face="Arial" size="2pt">miscellaneous information</font></td>
    </tr>
    <xsl:if test="child::fcm:OpticalDetector">
     <xsl:for-each select="child::fcm:OpticalDetector">
      <tr>
       <td><font color="#006838" face="Arial" size="2pt">
        <xsl:value-of select="@identifier"/>
       </font></td>
       <td><font color="#006838" face="Arial" size="2pt">
        <xsl:value-of select="key('ontoindlookupid',child::fcm:_opticalDetectorType/@OntologyTerm_ref)/@term"/>
       </font> </td> 
       <td><font color="#006838" face="Arial" size="2pt"> 
        <xsl:value-of select="child::fcm:_opticalDetectorAmplificationType/fuge:Description/@text"/>
       </font></td>
       <td><font color="#006838" face="Arial" size="2pt">
        <xsl:value-of select="key('dataproplookupid',child::fcm:_opticalDetectorVoltage/@DataProperty_ref)/@term"/>
       </font></td> 
       <td><font color="#006838" face="Arial" size="2pt"> 
        <xsl:value-of select="child::fcm:_opticalDetectorOtherInfo/fuge:Description/@text"/>
       </font></td> 
      </tr> 
     </xsl:for-each> 
    </xsl:if>
   </table>
   
   <br/>
   <table bgcolor="#DDDDD" font-family="sans-serif" border="1" cellspacing="1" cellpadding="10">
    <tr>
     <td><font color="#006838" face="Arial" size="2pt">light source</font></td>
     <td><font color="#006838" face="Arial" size="2pt">source type</font></td>
     <td><font color="#006838" face="Arial" size="2pt">excitatory wavelength</font></td>
     <td><font color="#006838" face="Arial" size="2pt">power</font></td>
     <td><font color="#006838" face="Arial" size="2pt">polarization</font></td>
     <td><font color="#006838" face="Arial" size="2pt">beam</font></td>
     <td><font color="#006838" face="Arial" size="2pt">miscellaneous information</font></td>
    </tr>
    <xsl:if test="child::fcm:LightSource">
     <xsl:for-each select="child::fcm:LightSource">
      <tr>
       <td><font color="#006838" face="Arial" size="2pt">
        <xsl:value-of select="@identifier"/>
       </font></td>
       <td><font color="#006838" face="Arial" size="2pt">
        <xsl:value-of select="key('ontoindlookupid',child::fcm:_lightSourceType/@OntologyTerm_ref)/@term"/>
       </font> </td> 
       <td><font color="#006838" face="Arial" size="2pt">
        <xsl:value-of select="key('dataproplookupid',child::fcm:_lightSourceExcitatoryWavelength/@DataProperty_ref)/@term"/>
       </font></td>
       <td><font color="#006838" face="Arial" size="2pt">
        <xsl:value-of select="key('dataproplookupid',child::fcm:_lightSourcePower/@DataProperty_ref)/@term"/>
       </font></td>
       <td><font color="#006838" face="Arial" size="2pt"> 
        <xsl:value-of select="child::fcm:_lightSourcePolarization/fuge:Description/@text"/>
       </font></td>
       <td><font color="#006838" face="Arial" size="2pt"> 
        <xsl:value-of select="child::fcm:_lightSourceBeam/fuge:Description/@text"/>
       </font></td>                    
       <td><font color="#006838" face="Arial" size="2pt"> 
        <xsl:value-of select="child::fcm:_lightSourceOtherInfo/fuge:Description/@text"/>
       </font></td> 
      </tr> 
     </xsl:for-each> 
    </xsl:if>
   </table>
   
   <br/>
   
   <table bgcolor="#DDDDD" font-family="sans-serif" border="1" cellspacing="1" cellpadding="10">
    <tr>
     <td><font color="#006838" face="Arial" size="2pt">Optical path</font></td>
     <td><font color="#006838" face="Arial" size="2pt">light source</font></td>
     <td><font color="#006838" face="Arial" size="2pt">detector</font></td>
     <td><font color="#006838" face="Arial" size="2pt">filters</font></td>
    </tr>
    <xsl:if test="child::fcm:OpticalPathDesctiption">
     <xsl:for-each select="child::fcm:OpticalPathDesctiption">
      <tr>
       
       <td><font color="#006838" face="Arial" size="2pt">
        <xsl:value-of select="@identifier"/>
       </font>
       </td> 

        <xsl:if test="child::fcm:OpticalPathComponent/@LightSource_ref">
         <td><font color="#006838" face="Arial" size="2pt">
          <xsl:value-of select="child::fcm:OpticalPathComponent/@LightSource_ref"/>
          </font>
         </td>
        </xsl:if>
       
        <xsl:if test="child::fcm:OpticalPathComponent/@OpticalDetector_ref">
         <td><font color="#006838" face="Arial" size="2pt"> 
          <xsl:value-of select="child::fcm:OpticalPathComponent/@OpticalDetector_ref"/>
          </font>
         </td>      
        </xsl:if>
       
        <td><font color="#006838" face="Arial" size="2pt">
        <xsl:choose>
         <xsl:when test="child::fcm:OpticalPathComponent/@OpticalFilter_ref">
          <table  bgcolor="#DDDDD" font-family="sans-serif" border="0" cellspacing="0" cellpadding="1">
           <tr>
          <xsl:for-each select="child::fcm:OpticalPathComponent/@OpticalFilter_ref">    
           <td bgcolor="#fffff"> <font color="#006838" face="Arial" size="2pt"><xsl:value-of select="."/></font></td>
          </xsl:for-each>
           </tr>
          </table>
         </xsl:when>
         <xsl:otherwise>
          none
         </xsl:otherwise>
        </xsl:choose>
       </font></td>
      </tr>     
     </xsl:for-each> 
    </xsl:if>
   </table> 
  </font> </td> 
 </tr> 
 </xsl:template>
 
 <xsl:template match="fuge:InvestigationCollection">
  <table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
   <tr>
    <td bgcolor="#006838">
     <font color="#CCCCCC" face="Arial" size="2pt">
      <b>Study Identifier</b>
     </font>
    </td>
    <xsl:for-each select="//fuge:Investigation">
     <td bgcolor="#CCCCCC">
      <font face="Arial" size="2pt">
       <xsl:value-of select="@identifier"/>
      </font>
     </td>
    </xsl:for-each>				
   </tr>
   <tr>
    <td bgcolor="#006838">
     <font color="#CCCCCC" face="Arial" size="2pt">
      <b>Study Title</b>
     </font>
    </td>
    <xsl:for-each select="//fuge:Investigation">
     <td bgcolor="#CCCCCC">
      <font face="Arial" size="3pt">
       <xsl:value-of select="@name"/>
      </font>
     </td>
    </xsl:for-each>				
   </tr>
   <tr>
    <td bgcolor="#006838">
     <font color="#CCCCCC" face="Arial" size="2pt">
      <b>Study submission date</b>
     </font>
    </td>
    <xsl:for-each select="//fuge:Investigation">
     <td bgcolor="#CCCCCC">
      <font face="Arial" size="2pt">
       <xsl:value-of select="substring-before(@start,'T')"/>
      </font>
     </td>
    </xsl:for-each>				
   </tr>
     <xsl:for-each select="//fuge:Investigation">  
      <xsl:choose>
       <xsl:when test="child::fuge:_bibliographicReferences">
        <tr>    
         <td bgcolor="#006838"><font color="#CCCCCC" face="Arial" size="2pt"><b>Pubmed ID</b></font></td>
         <td bgcolor="#CCCCCC"><font face="Arial" size="2pt">
          <xsl:value-of select="key('bibreflookupid',child::fuge:_bibliographicReferences/@BibliographicReference_ref)/@name"/></font></td>
        </tr>
        <tr>
         <td bgcolor="#006838"><font color="#CCCCCC" face="Arial" size="2pt"><b>Authors List</b></font></td>
         <td bgcolor="#CCCCCC"><font face="Arial" size="3pt">
          <xsl:value-of select="key('bibreflookupid',child::fuge:_bibliographicReferences/@BibliographicReference_ref)/@authors"/>
         </font></td>
        </tr>
        <tr>
         <td bgcolor="#006838"><font color="#CCCCCC" face="Arial" size="2pt"><b>Publication title</b></font></td>
         <td bgcolor="#CCCCCC"><font face="Arial" size="2pt">
          <xsl:value-of select="key('bibreflookupid',child::fuge:_bibliographicReferences/@BibliographicReference_ref)/@title"/>
         </font></td>
        </tr>
        <tr>
         <td bgcolor="#006838"><font color="#CCCCCC" face="Arial" size="2pt"><b>Publication status</b></font></td>
         <td bgcolor="#CCCCCC"><font face="Arial" size="2pt">-</font></td>
        </tr>
        </xsl:when>
          <xsl:otherwise>
           <tr>
            <td bgcolor="#006838"><font color="#CCCCCC" face="Arial" size="2pt"><b>Pubmed ID</b></font></td>
            <td bgcolor="#CCCCCC"></td>
           </tr>
           <tr>
            <td bgcolor="#006838"><font color="#CCCCCC" face="Arial" size="2pt"><b>Authors List</b></font></td>
            <td bgcolor="#CCCCCC"></td>
           </tr>
           <tr>
            <td bgcolor="#006838"><font color="#CCCCCC" face="Arial" size="2pt"><b>Publication title</b></font></td>
            <td bgcolor="#CCCCCC"></td>
           </tr>
           <tr>
            <td bgcolor="#006838"><font color="#CCCCCC" face="Arial" size="2pt"><b>Publication status</b></font></td>
            <td bgcolor="#CCCCCC"></td>
           </tr>
        </xsl:otherwise>
     </xsl:choose>
   </xsl:for-each>
   
    <tr> 
    <xsl:for-each select="child::fuge:_descriptions/fuge:Description">  
         <td bgcolor="#CCCCCC">
          <font face="Arial" size="2pt">
           <xsl:value-of select="@text"/>
          </font>	
         </td>
     </xsl:for-each>				
    </tr> 
    <tr>    
     <td bgcolor="#006838">
      <font color="#CCCCCC" face="Arial" size="2pt">
      <b>Study Description</b>
     </font>
    </td>
    <xsl:for-each select="//fuge:Investigation">
     <xsl:choose>
      <xsl:when test="child::fuge:_descriptions">
       <xsl:for-each select="child::fuge:_descriptions/fuge:Description">
        <td bgcolor="#CCCCCC">
         <font face="Arial" size="2pt">
          <xsl:value-of select="@text"/>
         </font>	
        </td>
       </xsl:for-each>					
      </xsl:when>
      <xsl:otherwise><td>-</td></xsl:otherwise>
     </xsl:choose>
    </xsl:for-each>		
   </tr>
   <tr><td bgcolor="#006838">
    <font color="#CCCCCC" face="Arial" size="2pt">
     <b>Study Design</b>
    </font>	
   </td>
    <td bgcolor="#CCCCCC">
     <font face="Arial" size="2pt">
     </font>	
    </td>
   </tr>
    <tr>
     <td bgcolor="#006838">
      <font color="#CCCCCC"  face="Arial" size="2pt">
      <b>Study Design Term Source REF</b>
     </font>	
    </td>
     <td bgcolor="#CCCCCC">
      <font face="Arial" size="2pt">
      </font>	
     </td>
    </tr>							
  </table>
  
  <table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
   <tr>
    <td bgcolor="#006838">
     <font color="#CCCCCC" face="Arial" size="2pt">
      <b>Study Factors</b>
     </font>
    </td>
   </tr>
   <tr>
    <td bgcolor="#006838">
     <font color="#CCCCCC" face="Arial" size="2pt">
      <b>Factor Name</b>
     </font>
    </td>
    <xsl:for-each select="//fuge:Factor">
     <td bgcolor="#CCCCCC">
      <font face="Arial" size="2pt">
       <xsl:value-of select="@name"/>
       <xsl:value-of select="@identifier"/>
      </font>
     </td>
    </xsl:for-each> 
   </tr>
   <tr>
    <td bgcolor="#006838">
     <font color="#CCCCCC" face="Arial" size="2pt">
      <b>Factor Type</b>
     </font>
    </td>
    <xsl:for-each select="//fuge:Factor">
     <td bgcolor="#CCCCCC">
      <font face="Arial" size="2pt">
       <xsl:value-of select="key('ontoindlookupid',child::fuge:_factorType/@OntologyTerm_ref)/@term"/>
       <xsl:value-of select="child::fuge:_factorType/@OntologyTerm_ref"/>
      </font>
     </td>
    </xsl:for-each> 
   </tr>
   <tr>
    <td bgcolor="#006838">
     <font color="#CCCCCC" face="Arial" size="2pt">
      <b>Factor Type Term Source REF</b>
     </font>
    </td>
    <xsl:for-each select="//fuge:Factor">
     <td bgcolor="#CCCCCC">
      <font face="Arial" size="2pt">
       <xsl:text>OBI</xsl:text>
       <xsl:value-of select="."/>
      </font>
     </td>
    </xsl:for-each> 
   </tr>
   <tr>
    <td bgcolor="#006838">
     <font color="#CCCCCC" face="Arial" size="2pt">
      <b>Factor Type Term Accession</b>
     </font>
    </td>
    <xsl:for-each select="//fuge:Factor">
     <td bgcolor="#CCCCCC">
      <font face="Arial" size="2pt">
       <xsl:value-of select="."/>
      </font>
     </td>
    </xsl:for-each> 
   </tr>
  </table>
  
  <table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
   <tr>
    <td bgcolor="#006838">
     <font color="#CCCCCC" face="Arial" size="2pt">
      <b>Study Contacts</b>
     </font>
    </td>
   </tr>
   <tr>
    <td bgcolor="#006838">
     <font color="#CCCCCC" face="Arial" size="2pt">
      <b>Person Last Name</b>
     </font>
    </td>
    <xsl:for-each select="//fuge:ContactRole">
     <td bgcolor="#CCCCCC">
      <font face="Arial" size="2pt">
       <xsl:value-of select="key('personlookupid',@Contact_ref)/@lastName"/>
      </font>
     </td>
    </xsl:for-each> 
   </tr>
   <tr>
    <td bgcolor="#006838">
     <font color="#CCCCCC" face="Arial" size="2pt">
      <b>Person Last Name</b>
     </font>
    </td>
    <xsl:for-each select="//fuge:ContactRole">
     <td bgcolor="#CCCCCC">
      <font face="Arial" size="2pt">
       <xsl:value-of select="key('personlookupid',@Contact_ref)/@firstName"/>
      </font>
     </td>
    </xsl:for-each> 
   </tr>
   <tr>
    <td bgcolor="#006838">
     <font color="#CCCCCC" face="Arial" size="2pt">
      <b>Person Mid Initials</b>
     </font>
    </td>
    <xsl:for-each select="//fuge:ContactRole">
     <td bgcolor="#CCCCCC">
      <font face="Arial" size="2pt">
       <xsl:value-of select="key('personlookupid',@Contact_ref)/@midInitials"/>
      </font>
     </td>
    </xsl:for-each> 
   </tr>
   <tr>
    <td bgcolor="#006838">
     <font color="#CCCCCC" face="Arial" size="2pt">
      <b>Person email</b>
     </font>
    </td>
    <xsl:for-each select="//fuge:ContactRole">
     <td bgcolor="#CCCCCC">
      <font face="Arial" size="2pt">
       <xsl:value-of select="key('personlookupid',@Contact_ref)/@email"/>
      </font>
     </td>
    </xsl:for-each> 
   </tr>
   <tr>
    <td bgcolor="#006838">
     <font color="#CCCCCC" face="Arial" size="2pt">
      <b>Person Phone</b>
     </font>
    </td>
    <xsl:for-each select="//fuge:ContactRole">
     <td bgcolor="#CCCCCC">
      <font face="Arial" size="2pt">
       <xsl:value-of select="key('personlookupid',@Contact_ref)/@phone"/>
      </font>
     </td>
    </xsl:for-each> 
   </tr>
   <tr>
    <td bgcolor="#006838">
     <font color="#CCCCCC" face="Arial" size="2pt">
      <b>Person Fax</b>
     </font>
    </td>
    <xsl:for-each select="//fuge:ContactRole">
     <td bgcolor="#CCCCCC">
      <font face="Arial" size="2pt">
       <xsl:value-of select="key('personlookupid',@Contact_ref)/@fax"/>
      </font>
     </td>
    </xsl:for-each> 
   </tr>
   <tr>
    <td bgcolor="#006838">
     <font color="#CCCCCC" face="Arial" size="2pt">
      <b>Person address</b>
     </font>
    </td>
    <xsl:for-each select="//fuge:ContactRole">
     <td bgcolor="#CCCCCC">
      <font face="Arial" size="2pt">
       <xsl:value-of select="key('personlookupid',@Contact_ref)/@address"/>
      </font>
     </td>
    </xsl:for-each> 
   </tr>
   <tr>
    <td bgcolor="#006838">
     <font color="#CCCCCC" face="Arial" size="2pt">
      <b>Person Affiliation</b>
     </font>
    </td>
    <xsl:for-each select="//fuge:ContactRole">
     <td bgcolor="#CCCCCC">
      <font face="Arial" size="2pt">
       <i>{requires fixing}</i>
      </font>
     </td>
    </xsl:for-each> 
   </tr>
   <tr>
    <td bgcolor="#006838">
     <font color="#CCCCCC" face="Arial" size="2pt">
      <b>Person Role</b>
     </font>
    </td>
    <xsl:for-each select="//fuge:ContactRole">
     <td bgcolor="#CCCCCC">
      <font face="Arial" size="2pt">
       <xsl:value-of select="key('ontoindlookupid',child::fuge:_role/@OntologyTerm_ref)/@term"/>
      </font>
     </td>
    </xsl:for-each> 
   </tr>
   <tr>
    <td bgcolor="#006838">
     <font color="#CCCCCC" face="Arial" size="2pt">
      <b>Person Role Term Source REF</b>
     </font>
    </td>
    <xsl:for-each select="//fuge:ContactRole">
     <td bgcolor="#CCCCCC">
      <font face="Arial" size="2pt">
       OBI
      </font>
     </td>
    </xsl:for-each> 
   </tr>
   </table>	
 </xsl:template>
 
 <xsl:template match="fuge:ProtocolCollection">
  <table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
   <tr>
    <td bgcolor="#006838">
     <font color="#CCCCCC" face="Arial" size="3pt">
      <b>Study Protocols</b>
     </font>
    </td>
   </tr>
   <tr>
    <td bgcolor="#006838">
     <font color="#CCCCCC" face="Arial" size="2pt">
      <b>Protocol Name</b>
     </font>
    </td>
    <xsl:for-each select="//fuge:GenericProtocol">
     <td bgcolor="#CCCCCC">
      <font face="Arial" size="2pt">
       <xsl:value-of select="@identifier"/>
      </font>
     </td>
    </xsl:for-each> 
   </tr>
   <tr>
    <td bgcolor="#006838"><font color="#CCCCCC" face="Arial" size="2pt"><b>Protocol Instrument</b></font></td>
    <xsl:for-each select="//fuge:GenericProtocol">
     <td bgcolor="#CCCCCC" valign="top"><font face="Arial" size="2pt">
      
      <xsl:for-each select="child::fuge:genPrtclToEquip">
       <font face="Arial" size="2pt">
        <xsl:value-of select="key('genericequipmentlookupid',@GenericEquipment_ref)/@name"/>
        <xsl:text>;</xsl:text>         	
        
       </font>
      </xsl:for-each>
      
     </font></td> 
    </xsl:for-each>
   </tr>  
   <tr>
    <td bgcolor="#006838" valign="top"><font color="#CCCCCC" face="Arial" size="2pt"><b>Protocol Description</b></font></td>
    <xsl:for-each select="//fuge:GenericProtocol">
     <td bgcolor="#CCCCCC" valign="top"><font face="Arial" size="2pt">
      
      <xsl:value-of select="@protocolText"/><br/>
      <xsl:for-each select="child::fuge:GenericAction">
       <font face="Arial" size="2pt">
        <b><xsl:text>action:</xsl:text></b>
        <xsl:value-of select="@identifier"/><br/>
        <xsl:value-of select="@actionText"/><br/>
        
        <b><xsl:text>order:</xsl:text></b>
        <xsl:value-of select="@actionOrdinal"/>
        
        <br/>
       </font>
      </xsl:for-each>
      
      <xsl:for-each select="child::fuge:GenericParameter">
       <font face="Arial" size="2pt">
        <b><xsl:text>parameter:</xsl:text></b>
        <xsl:value-of select="@name"/><br/>
        <b><xsl:text>value:</xsl:text></b>
        <xsl:value-of select="key('ontoindlookupid', ./fuge:ComplexValue/fuge:_defaultValue/@OntologyTerm_ref)/@term"/>  
        
        <br/>
       </font>
      </xsl:for-each>
      
      <xsl:for-each select="child::fuge:descriptions/fuge:Description">
       <font face="Arial" size="2pt">
        <b><xsl:text>description: </xsl:text></b>
        <xsl:value-of select="@text"/><br/>
        <br/>
       </font>
      </xsl:for-each> 	         
      
      <xsl:choose>
       <xsl:when test="child::fuge:genPrtclToEquip/@GenericEquipment_ref">
        <font face="Arial" size="2pt">
         <b><xsl:text>equipment: </xsl:text></b>
         
         <xsl:value-of select="key('genericequipmentlookupid',child::fuge:genPrtclToEquip/@GenericEquipment_ref)/@name"/>
        </font>
       </xsl:when>
       <xsl:otherwise>
        <font face="Arial" size="2pt">-</font>
       </xsl:otherwise>
      </xsl:choose>
      <!--<xsl:choose>
       <xsl:when test="child::fuge:GenericAction">-->	         
      <!--</xsl:when>
       <xsl:otherwise>
       <font face="Arial" size="2pt">-</font>
       </xsl:otherwise>
       </xsl:choose>	-->	 
      
     </font></td> 
    </xsl:for-each>
   </tr>
  </table>
 </xsl:template>

 <xsl:template match="fuge:OntologyCollection">
  <table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
   <tr><td bgcolor="#006838"><font color="#CCCCCC" face="Arial" size="3pt"><b>Ontology Source Reference</b></font></td></tr>
   <tr>
    <td bgcolor="#006838"><font color="#CCCCCC" face="Arial" size="2pt"><b>Term Source Name</b></font></td>
    <xsl:for-each select="//fuge:OntologySource">
     <td bgcolor="#CCCCCC">
      <font face="Arial" size="2pt">
       <xsl:value-of select="@name"/>
       <xsl:value-of select="//fuge:OntologySource[generate-id(.)=generate-id(key('ontosourcelookupid',.)[1])]/@name"/>   
      </font>
     </td>
    </xsl:for-each> 
   </tr> 
   <tr>
    <td bgcolor="#006838"><font color="#CCCCCC" face="Arial" size="2pt"><b>Term Source File</b></font></td>
    <xsl:for-each select="//fuge:OntologySource">
     <td bgcolor="#CCCCCC"><font face="Arial" size="2pt">
      <xsl:value-of select="@ontologyURI"/>
      <xsl:value-of select="//fuge:OntologySource[generate-id(.)=generate-id(key('ontosourcelookupid',.)[1])]/@name"/>
     </font></td>
    </xsl:for-each>
   </tr>  
   <tr>
    <td bgcolor="#006838"><font color="#CCCCCC" face="Arial" size="2pt"><b>Term Source Version</b></font></td>
    <xsl:for-each select="//fuge:OntologySource">
     <td bgcolor="#CCCCCC"><font face="Arial" size="2pt">
      <xsl:value-of select="@identifier"/>
      <xsl:value-of select="."/>
     </font></td>
    </xsl:for-each>
   </tr>
   <tr>
    <td bgcolor="#006838"><font color="#CCCCCC" face="Arial" size="2pt"><b>Term Source Description</b></font></td>
    <xsl:for-each select="//fuge:OntologySource">
     <td bgcolor="#CCCCCC"><font face="Arial" size="2pt">
      <xsl:value-of select="@endurant"/>
      <xsl:value-of select="."/>
     </font></td>
    </xsl:for-each>
   </tr>
  </table>
 </xsl:template>
  
    
</xsl:stylesheet>