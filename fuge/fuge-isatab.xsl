<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#160;">
  <!ENTITY copy "&#169;">
]>

<!--xsl stylesheet prototype for html ISA-TAB like rendering of FUGE XML documents  
Author: Philippe Rocca-Serra, EMBL-EBI (rocca@ebi.ac.uk) , March 2008-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html"/>


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
  <body bgcolor="gray">
   <p>
    <h1>
     <font color="#003366" face="Arial" size="2pt">
      <b>FuGE Document:</b>
      <xsl:value-of select="@identifier"/>
     </font>
    </h1>
   </p>
  	 
  	<xsl:apply-templates select="OntologyCollection"/>
  	<br/> 
  	 <xsl:apply-templates select="InvestigationCollection"/>
 	<br/>
    <xsl:apply-templates select="ProtocolCollection"/>
  <!--    <xsl:call-template name="GenericProtocolApplication"/>--> 
     <br/>
     <xsl:apply-templates select="MaterialCollection"/>
     <br/>
     <xsl:apply-templates select="DataCollection"/>
     
<!-- 	
  	<font color="#003366" face="Arial" size="3pt"><b><xsl:text>STUDY TAB</xsl:text></b></font>
  	
  	<table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
  		<tr bgcolor="eeeee">
  			<td  bgcolor="#33333"><font color="gray" face="Arial" size="2pt">Source</font></td>
  			<td  bgcolor="#33333"><font color="gray" face="Arial" size="2pt">Protocol REF</font></td>
  			<td  bgcolor="#33333"><font color="gray" face="Arial" size="2pt">Parameter[Instrument]</font></td>
  			<td  bgcolor="#33333"><font color="gray" face="Arial" size="2pt">Date</font></td>
  			<td  bgcolor="#33333"><font color="gray" face="Arial" size="2pt">Sample</font></td>
  		</tr>
  		<xsl:apply-templates select="//genericOutputMaterials"/>
  	</table>
 -->
  	 	
  	<font color="#003366" face="Arial" size="3pt"><b><xsl:text>ASSAY TAB</xsl:text></b></font>
  	
  	<table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
  		<tr bgcolor="#003366">
  			<td  bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt">Sample</font></td>
  			<td  bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt">Protocol REF</font></td>
  			<td  bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt">Parameter[Instrument]</font></td>
  			<td  bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt">Date</font></td>    
  			<td  bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt">Raw Data File</font></td>
  		</tr>
  		<xsl:apply-templates select="//genericOutputData"/>
  		<xsl:apply-templates select="//_outputData"/>
  	</table>

   </body>
</html>
</xsl:template>


<xsl:template match="OntologyCollection">
 <table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
 	<tr><td bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="3pt"><b>Ontology Source Reference</b></font></td></tr>
<tr>
	<td bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt"><b>Term Source Name</b></font></td>
  	  <xsl:for-each select="//OntologySource">
  	     <td bgcolor="#CCCCCC">
  	      <font face="Arial" size="2pt">
  	       <xsl:value-of select="@name"/>
  	       <xsl:value-of select="//OntologySource[generate-id(.)=generate-id(key('ontosourcelookupid',.)[1])]/@name"/>   
  	      </font>
  	     </td>
	   </xsl:for-each> 
  </tr> 
  <tr>
  	<td bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt"><b>Term Source File</b></font></td>
  	  <xsl:for-each select="//OntologySource">
  	     <td bgcolor="#CCCCCC"><font face="Arial" size="2pt">
  	      <xsl:value-of select="@ontologyURI"/>
  	       <xsl:value-of select="//OntologySource[generate-id(.)=generate-id(key('ontosourcelookupid',.)[1])]/@name"/>
 	       </font></td>
	   </xsl:for-each>
   </tr>  
  <tr>
  	<td bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt"><b>Term Source Version</b></font></td>
  	  <xsl:for-each select="//OntologySource">
  	     <td bgcolor="#CCCCCC"><font face="Arial" size="2pt">
  	      <xsl:value-of select="@identifier"/>
  	       <xsl:value-of select="."/>
 	       </font></td>
	   </xsl:for-each>
  </tr>
  <tr>
  	<td bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt"><b>Term Source Description</b></font></td>
  	  <xsl:for-each select="//OntologySource">
  	     <td bgcolor="#CCCCCC"><font face="Arial" size="2pt">
  	      <xsl:value-of select="@endurant"/>
  	       <xsl:value-of select="."/>
 	       </font></td>
	   </xsl:for-each>
  </tr>
</table>
</xsl:template>

<xsl:template match="InvestigationCollection">
		<table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
			<tr>
				<td bgcolor="#003366">
					<font color="#CCCCCC" face="Arial" size="3pt">
						<b>Study Identifier</b>
					</font>
				</td>
				<xsl:for-each select="//Investigation">
					<td bgcolor="#CCCCCC">
						<font face="Arial" size="3pt">
							<xsl:value-of select="@identifier"/>
						</font>
					</td>
				</xsl:for-each>				
			</tr>
			<tr>
				<td bgcolor="#003366">
					<font color="#CCCCCC" face="Arial" size="3pt">
						<b>Study Title</b>
					</font>
				</td>
				<xsl:for-each select="//Investigation">
					<td bgcolor="#CCCCCC">
						<font face="Arial" size="3pt">
							<xsl:value-of select="@name"/>
						</font>
					</td>
				</xsl:for-each>				
			</tr>
			<tr>
				<td bgcolor="#003366">
					<font color="#CCCCCC" face="Arial" size="3pt">
						<b>Study submission date</b>
					</font>
				</td>
				<xsl:for-each select="//Investigation">
					<td bgcolor="#CCCCCC">
						<font face="Arial" size="3pt">
							<xsl:value-of select="substring-before(@start,'T')"/>
						</font>
					</td>
				</xsl:for-each>				
			</tr>
			<xsl:for-each select="//Investigation">  
				<xsl:choose>
					<xsl:when test="child::_bibliographicReferences">
						<tr>    
							<td bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="3pt"><b>Pubmed ID</b></font></td>
							<td bgcolor="#CCCCCC"><font face="Arial" size="3pt">
								<xsl:value-of select="key('bibreflookupid',child::_bibliographicReferences/@BibliographicReference_ref)/@name"/></font></td>
						</tr>
						<tr>
							<td bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="3pt"><b>Authors List</b></font></td>
							<td bgcolor="#CCCCCC"><font face="Arial" size="3pt">
								<xsl:value-of select="key('bibreflookupid',child::_bibliographicReferences/@BibliographicReference_ref)/@authors"/>
							</font></td>
						</tr>
						<tr>
							<td bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="3pt"><b>Publication title</b></font></td>
							<td bgcolor="#CCCCCC"><font face="Arial" size="3pt">
								<xsl:value-of select="key('bibreflookupid',child::_bibliographicReferences/@BibliographicReference_ref)/@title"/>
							</font></td>
						</tr>
						<tr>
							<td bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="3pt"><b>Publication status</b></font></td>
							<td bgcolor="#CCCCCC"><font face="Arial" size="3pt">-</font></td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<tr>
							<td bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="3pt"><b>Pubmed ID</b></font></td>
							<td bgcolor="#CCCCCC"></td>
						</tr>
						<tr>
							<td bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="3pt"><b>Authors List</b></font></td>
							<td bgcolor="#CCCCCC"></td>
						</tr>
						<tr>
							<td bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="3pt"><b>Publication title</b></font></td>
							<td bgcolor="#CCCCCC"></td>
						</tr>
						<tr>
							<td bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="3pt"><b>Publication status</b></font></td>
							<td bgcolor="#CCCCCC"></td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			
			<tr> 
				<xsl:for-each select="child::_descriptions/Description">  
					<td bgcolor="#CCCCCC">
						<font face="Arial" size="3pt">
							<xsl:value-of select="@text"/>
						</font>	
					</td>
				</xsl:for-each>				
			</tr> 
			<tr>    
				<td bgcolor="#003366">
					<font color="#CCCCCC" face="Arial" size="3pt">
						<b>Study Description</b>
					</font>
				</td>
				<xsl:for-each select="//Investigation">
					<xsl:choose>
						<xsl:when test="child::_descriptions">
							<xsl:for-each select="child::_descriptions/Description">
								<td bgcolor="#CCCCCC">
									<font face="Arial" size="3pt">
										<xsl:value-of select="@text"/>
									</font>	
								</td>
							</xsl:for-each>					
						</xsl:when>
						<xsl:otherwise><td>-</td></xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>		
			</tr>
			<tr><td bgcolor="#003366">
				<font color="#CCCCCC" face="Arial" size="3pt">
					<b>Study Design</b>
				</font>	
			</td>
				<td bgcolor="#CCCCCC">
					<font face="Arial" size="3pt">
					</font>	
				</td>
			</tr>
			<tr>
				<td bgcolor="#003366">
					<font color="#CCCCCC"  face="Arial" size="3pt">
						<b>Study Design Term Source REF</b>
					</font>	
				</td>
				<td bgcolor="#CCCCCC">
					<font face="Arial" size="3pt">
					</font>	
				</td>
			</tr>							
		</table>

	<table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
		<tr>
			<td bgcolor="#003366">
				<font color="#CCCCCC" face="Arial" size="3pt">
					<b>Study Factors</b>
				</font>
			</td>
		</tr>
		<tr>
			<td bgcolor="#003366">
				<font color="#CCCCCC" face="Arial" size="2pt">
					<b>Factor Name</b>
				</font>
			</td>
			<xsl:for-each select="//Factor">
				<td bgcolor="#CCCCCC">
					<font face="Arial" size="2pt">
						<xsl:value-of select="@name"/>
					</font>
				</td>
			</xsl:for-each> 
		</tr>
		<tr>
			<td bgcolor="#003366">
				<font color="#CCCCCC" face="Arial" size="2pt">
					<b>Factor Type</b>
				</font>
			</td>
			<xsl:for-each select="//Factor">
				<td bgcolor="#CCCCCC">
					<font face="Arial" size="2pt">
						<xsl:value-of select="key('ontoindlookupid',child::_factorType/@OntologyTerm_ref)/@term"/>
						<xsl:value-of select="child::_factorType/@OntologyTerm_ref"/>
					</font>
				</td>
			</xsl:for-each> 
		</tr>
		<tr>
			<td bgcolor="#003366">
				<font color="#CCCCCC" face="Arial" size="2pt">
					<b>Factor Type Term Source REF</b>
				</font>
			</td>
			<xsl:for-each select="//Factor">
				<td bgcolor="#CCCCCC">
					<font face="Arial" size="2pt">
						<xsl:text>OBI</xsl:text>
						<xsl:value-of select="."/>
					</font>
				</td>
			</xsl:for-each> 
		</tr>
		<tr>
			<td bgcolor="#003366">
				<font color="#CCCCCC" face="Arial" size="2pt">
					<b>Factor Type Term Accession</b>
				</font>
			</td>
			<xsl:for-each select="//Factor">
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
				<td bgcolor="#003366">
					<font color="#CCCCCC" face="Arial" size="3pt">
						<b>Study Contacts</b>
					</font>
				</td>
			</tr>
			<tr>
				<td bgcolor="#003366">
					<font color="#CCCCCC" face="Arial" size="2pt">
						<b>Person Last Name</b>
					</font>
				</td>
				<xsl:for-each select="//ContactRole">
					<td bgcolor="#CCCCCC">
						<font face="Arial" size="2pt">
							<xsl:value-of select="key('personlookupid',@Contact_ref)/@lastName"/>
						</font>
					</td>
				</xsl:for-each> 
			</tr>
			<tr>
				<td bgcolor="#003366">
					<font color="#CCCCCC" face="Arial" size="2pt">
						<b>Person Last Name</b>
					</font>
				</td>
				<xsl:for-each select="//ContactRole">
					<td bgcolor="#CCCCCC">
						<font face="Arial" size="2pt">
							<xsl:value-of select="key('personlookupid',@Contact_ref)/@firstName"/>
						</font>
					</td>
				</xsl:for-each> 
			</tr>
			<tr>
				<td bgcolor="#003366">
					<font color="#CCCCCC" face="Arial" size="2pt">
						<b>Person Mid Initials</b>
					</font>
				</td>
				<xsl:for-each select="//ContactRole">
					<td bgcolor="#CCCCCC">
						<font face="Arial" size="2pt">
							<xsl:value-of select="key('personlookupid',@Contact_ref)/@midInitials"/>
						</font>
					</td>
				</xsl:for-each> 
			</tr>
			<tr>
				<td bgcolor="#003366">
					<font color="#CCCCCC" face="Arial" size="2pt">
						<b>Person email</b>
					</font>
				</td>
				<xsl:for-each select="//ContactRole">
					<td bgcolor="#CCCCCC">
						<font face="Arial" size="2pt">
							<xsl:value-of select="key('personlookupid',@Contact_ref)/@email"/>
						</font>
					</td>
				</xsl:for-each> 
			</tr>
			<tr>
				<td bgcolor="#003366">
					<font color="#CCCCCC" face="Arial" size="2pt">
						<b>Person Phone</b>
					</font>
				</td>
				<xsl:for-each select="//ContactRole">
					<td bgcolor="#CCCCCC">
						<font face="Arial" size="2pt">
							<xsl:value-of select="key('personlookupid',@Contact_ref)/@phone"/>
						</font>
					</td>
				</xsl:for-each> 
			</tr>
			<tr>
				<td bgcolor="#003366">
					<font color="#CCCCCC" face="Arial" size="2pt">
						<b>Person Fax</b>
					</font>
				</td>
				<xsl:for-each select="//ContactRole">
					<td bgcolor="#CCCCCC">
						<font face="Arial" size="2pt">
							<xsl:value-of select="key('personlookupid',@Contact_ref)/@fax"/>
						</font>
					</td>
				</xsl:for-each> 
			</tr>
			<tr>
				<td bgcolor="#003366">
					<font color="#CCCCCC" face="Arial" size="2pt">
						<b>Person address</b>
					</font>
				</td>
				<xsl:for-each select="//ContactRole">
					<td bgcolor="#CCCCCC">
						<font face="Arial" size="2pt">
							<xsl:value-of select="key('personlookupid',@Contact_ref)/@address"/>
						</font>
					</td>
				</xsl:for-each> 
			</tr>
			<tr>
				<td bgcolor="#003366">
					<font color="#CCCCCC" face="Arial" size="2pt">
						<b>Person Affiliation</b>
					</font>
				</td>
				<xsl:for-each select="//ContactRole">
					<td bgcolor="#CCCCCC">
						<font face="Arial" size="2pt">
							<i>{requires fixing}</i>
						</font>
					</td>
				</xsl:for-each> 
			</tr>
			<tr>
				<td bgcolor="#003366">
					<font color="#CCCCCC" face="Arial" size="2pt">
						<b>Person Role</b>
					</font>
				</td>
				<xsl:for-each select="//ContactRole">
					<td bgcolor="#CCCCCC">
						<font face="Arial" size="2pt">
							<xsl:value-of select="key('ontoindlookupid',child::_role/@OntologyTerm_ref)/@term"/>
						</font>
					</td>
				</xsl:for-each> 
			</tr>
			<tr>
				<td bgcolor="#003366">
					<font color="#CCCCCC" face="Arial" size="2pt">
						<b>Person Role Term Source REF</b>
					</font>
				</td>
				<xsl:for-each select="//ContactRole">
					<td bgcolor="#CCCCCC">
						<font face="Arial" size="2pt">
							OBI
						</font>
					</td>
				</xsl:for-each> 
			</tr>
		</table>	
	</xsl:template>

<xsl:template match="ProtocolCollection">
 <table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
 	<tr><td bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="3pt"><b>Study Protocols</b></font></td></tr>
<tr>
	<td bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt"><b>Protocol Name</b></font></td>
  	  <xsl:for-each select="//GenericProtocol">
  	     <td bgcolor="#CCCCCC">
  	      <font face="Arial" size="2pt">
  	       <xsl:value-of select="@name"/>
  	      </font>
  	     </td>
	   </xsl:for-each> 
  </tr> 
  <tr>
  	<td bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt"><b>Protocol Instrument</b></font></td>
  	  <xsl:for-each select="//GenericProtocol">
  	     <td bgcolor="#CCCCCC"><font face="Arial" size="2pt">
  	         
	          <xsl:for-each select="child::genPrtclToEquip">
	         	<font face="Arial" size="2pt">
	         	<xsl:value-of select="key('genericequipmentlookupid',@GenericEquipment_ref)/@name"/>
	         	<xsl:text>;</xsl:text>         	
	         	
	         	</font>
	          </xsl:for-each>

		</font></td> 
	 </xsl:for-each>
   </tr>  
  <tr>
  	<td bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt"><b>Protocol Description</b></font></td>
  	  <xsl:for-each select="//GenericProtocol">
  	     <td bgcolor="#CCCCCC"><font face="Arial" size="2pt">
  	     
  	     	<xsl:value-of select="@protocolText"/>
	          <xsl:for-each select="child::GenericAction">
	         	<font face="Arial" size="2pt">
	         	<b><xsl:text>action:</xsl:text></b>
	         		<xsl:value-of select="@name"/><xsl:value-of select="@actionText"/><br/>
	        	<b><xsl:text>order:</xsl:text></b>
	         	<xsl:value-of select="@actionOrdinal"/>
	         	
	         	<br/>
	         	</font>
	         </xsl:for-each>
	         
	          <xsl:for-each select="child::GenericParameter">
	         	<font face="Arial" size="2pt">
	         	<b><xsl:text>parameter:</xsl:text></b>
	         	<xsl:value-of select="@name"/><br/>
	        	<b><xsl:text>value:</xsl:text></b>
	         	<xsl:value-of select="key('ontoindlookupid', ./ComplexValue/_defaultValue/@OntologyTerm_ref)/@term"/>  
	         	<xsl:value-of select="./AtomicValue/@value"/>
	         		<xsl:value-of select="./AtomicValue/_unit/@OntologyTerm_ref"/>  
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
  	     
  	         <xsl:choose>
	          <xsl:when test="child::genPrtclToEquip/@GenericEquipment_ref">
	         	<font face="Arial" size="2pt">
	         	<b><xsl:text>equipment: </xsl:text></b>
	         	
	         	<xsl:value-of select="key('genericequipmentlookupid',child::genPrtclToEquip/@GenericEquipment_ref)/@name"/>
	         	</font>
	          </xsl:when>
	          <xsl:otherwise>
	           <font face="Arial" size="2pt">-</font>
	          </xsl:otherwise>
		 </xsl:choose>
		

  	         <!--<xsl:choose>
	          <xsl:when test="child::GenericAction">-->

	         
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

 <table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
 	<tr><td bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="3pt"><b>Study Tab</b></font></td></tr>
 <tr>
 	<td bgcolor="#003366">
  	<font color="#CCCCCC" face="Arial" size="2pt">
    <b>
	 Material Name
    </b>
   </font>
  </td>
 	<td bgcolor="#003366">
  	<font color="#CCCCCC" face="Arial" size="2pt">
    <b>
	 Material Type
    </b>
   </font>
  </td>  
 	<td bgcolor="#003366">
  	<font color="#CCCCCC" face="Arial" size="2pt">
    <b>
	 Description
    </b>
   </font>
  </td>
 	<td bgcolor="#003366">
 		<font color="#CCCCCC" face="Arial" size="2pt">
 			<b>
 				Date
 			</b>
 		</font>
 	</td> 
 	<td bgcolor="#003366">
 		<font color="#CCCCCC" face="Arial" size="2pt">
 			<b>
 				Performer
 			</b>
 		</font>
 	</td> 
 	<xsl:choose>
 		<xsl:when test="child::_characteristics">	   
  <xsl:for-each select="//_characteristics">
  	<td bgcolor="#003366"><b><font color="#CCCCCC" face="Arial" size="2pt">
       <xsl:text>Characteristics[</xsl:text>
       <!--<xsl:value-of select="@OntologyTerm_ref"/>-->
       <xsl:value-of select="key('ontosourcelookupid',key('ontoindlookupid',@OntologyTerm_ref)/@OntologySource_ref)/@name"/>
       <xsl:text>]</xsl:text>
       </font></b></td>
   </xsl:for-each>
 		</xsl:when> 
 		<xsl:otherwise>
 			<td bgcolor="#003366"><b><font color="#CCCCCC" face="Arial" size="2pt">
 				<xsl:text>Characteristics[]</xsl:text>
 			</font></b></td>	
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
  	  	<tr  bgcolor="{$color}">

 
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
    	   </xsl:otherwise>
    	   </xsl:choose> 
  	   
  	   
  	   <xsl:choose>
  	   <xsl:when test="./_characteristics/@OntologyTerm_ref">
  	       <xsl:for-each select="./_characteristics/@OntologyTerm_ref">
  	       
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

<!-- OLD TEMPLATE FOR DATA COLLECTION
<xsl:template match="DataCollection">
 <table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
  <tr>
  	<td bgcolor="#CCCCCC">
  		<font face="Arial" size="3pt">
  			<b>Assay Tab</b>
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
 	<xsl:for-each select="//ExternalData">
  <tr>
  	<td bgcolor="#CCCCCC">
  		<font face="Arial" size="2pt">
  	       <xsl:value-of select="@name"/>
  	    </font>
    </td>
    <td bgcolor="#CCCCCC">
        <font face="Arial" size="2pt">
  	       <xsl:value-of select="key('ontoindlookupid',child::fileFormat/@OntologyTerm_ref)/@term"/>
        </font>
     </td>
  </tr> 
   </xsl:for-each> 
</table>
</xsl:template>
-->

<xsl:template name="PA2" match="//genericOutputData">
		<xsl:variable name="color">
			<xsl:choose>
				<xsl:when test="position() mod 2= 0">#B0C4DE</xsl:when>
				<xsl:otherwise>#CCCCCC</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr bgcolor="{$color}">
			<xsl:if test="parent::node()/genericInputCompleteMaterials">
				<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="key('materiallookupid',parent::node()/genericInputCompleteMaterials/@Material_ref)/@name"/></font></td>
				<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="key('protocollookupid',parent::node()/@Protocol_ref)/@name"/></font></td>
				<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="key('genericequipmentlookupid',parent::node()/EquipmentApplication/@Equipment_ref)/@name"/>
					<xsl:value-of select="key('genericequipmentlookupid',key('protocollookupid',parent::node()/@Protocol_ref)/genPrtclToEquip/@GenericEquipment_ref)/@name"/>
				</font></td>
				<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="substring-before(parent::node()/@activityDate,'T')"/></font></td>  
				<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="key('datafilelookupid',@Data_ref)/@name"/>.<xsl:value-of select="key('datafilelookupid',@Data_ref)/fileFormat/@OntologyTerm_ref"/></font></td>
			</xsl:if>
		</tr> 
</xsl:template>
	<xsl:template name="fugeaj" match="//_outputData">
		<xsl:variable name="color">
			<xsl:choose>
				<xsl:when test="position() mod 2= 0">#B0C4DE</xsl:when>
				<xsl:otherwise>#CCCCCC</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr bgcolor="{$color}">
			<xsl:if test="parent::node()/_inputCompleteMaterials">
				<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="key('materiallookupid',parent::node()/_inputCompleteMaterials/@Material_ref)/@name"/></font></td>
				<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="key('protocollookupid',parent::node()/@Protocol_ref)/@name"/></font></td>
				<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="key('genericequipmentlookupid',parent::node()/EquipmentApplication/@Equipment_ref)/@name"/>
					<xsl:value-of select="key('genericequipmentlookupid',key('protocollookupid',parent::node()/@Protocol_ref)/genPrtclToEquip/@GenericEquipment_ref)/@name"/>
				</font></td>
				<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="substring-before(parent::node()/@activityDate,'T')"/></font></td>  
				<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="key('datafilelookupid',@Data_ref)/@name"/>.<xsl:value-of select="key('datafilelookupid',@Data_ref)/fileFormat/@OntologyTerm_ref"/></font></td>
			</xsl:if>
		</tr> 
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
							<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="parent::node()/@identifier"/></font></td>
							<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="key('genericequipmentlookupid',parent::node()/EquipmentApplication/@Equipment_ref)/@name"/></font></td> 
							<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="substring-before(parent::node()/@activityDate, 'T')"/></font></td> 
							<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="@Material_ref"/></font></td>
							<xsl:call-template name="tt">
								<xsl:with-param name="thisoutput" select="$thisoutput"/>
							</xsl:call-template>
							<!-- HERE: TODO: I should call a getDescendantMaterial Template in order to go further-->
							<xsl:apply-templates select="//GenericProtocolApplication"/>
						</xsl:when>  
						
						<xsl:otherwise>
							<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="parent::node()/@identifier"/></font></td>
							<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="key('genericequipmentlookupid',parent::node()/EquipmentApplication/@Equipment_ref)/@name"/></font></td> 
							<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="substring-before(parent::node()/@activityDate, 'T')"/></font></td> 
							<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="@Material_ref"/></font></td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>   
			</xsl:when>
			
			<!--Test for the Second Case: input material is coded as 'GenericMaterialMeasurement'-->
			<xsl:when test="$test2">
				<tr bgcolor="{$color}">
					 <td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="$test2/@Material_ref"/></font></td>
					<!-- check if current input=Material is also output of a ProtocolApplication-->
					<xsl:choose>
						<xsl:when test="key('PAby_outputMaterials',$test2/@Material_ref)">
							<!--2.1 Is it True that this inputCompleteMaterial is also an output of another PA?  YES    --> 
							<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="parent::node()/@identifier"/></font></td>
							<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="key('genericequipmentlookupid',parent::node()/EquipmentApplication/@Equipment_ref)/@name"/></font></td>     
							<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="substring-before(parent::node()/@activityDate, 'T')"/></font></td>     
							<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="@Material_ref"/></font></td>
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
							<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="parent::node()/@identifier"/></font></td>
							<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="key('genericequipmentlookupid',parent::node()/EquipmentApplication/@Equipment_ref)/@name"/></font></td> 
							<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="substring-before(parent::node()/@activityDate, 'T')"/></font></td> 
							<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="@Material_ref"/></font></td>
							<xsl:call-template name="getParentMaterial">
								<xsl:with-param name="test2" select="$test2[position()>1]"/>
							</xsl:call-template>     
						</xsl:when> 
						<xsl:otherwise>
							<td><font color="#003366" face="Arial" size="2pt">output is: <xsl:value-of select="@Material_ref"/></font></td>
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
				<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="@identifier"/></font></td>
				<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="key('genericequipmentlookupid',child::EquipmentApplication/@Equipment_ref)/@name"/></font></td>
				<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="substring-before(@activityDate, 'T')"/></font></td>
				<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="child::genericOutputMaterials/@Material_ref"/></font></td>
			</xsl:if>
			<xsl:if test="child::GenericMaterialMeasurement/@Material_ref = $thisoutput and not(child::genericOutputData)">
				<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="@identifier"/></font></td>
				<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="key('genericequipmentlookupid',child::EquipmentApplication/@Equipment_ref)/@name"/></font></td>
				<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="substring-before(@activityDate, 'T')"/></font></td>    
				<td><font color="#003366" face="Arial" size="2pt"><xsl:value-of select="child::genericOutputMaterials/@Material_ref"/></font></td>      
			</xsl:if>  
		</xsl:for-each>
	</xsl:template>



</xsl:stylesheet>