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

<xsl:key name="materiallookupid"  match="fuge:GenericMaterial"  use="@identifier"/>
<xsl:key name="materialcharlookupid"  match="//fuge:MaterialCollection/fuge:GenericMaterial/fuge:_characteristics"  use="."/>
<xsl:key name="investigationlookupid"  match="fuge:Investigation"  use="@identifier"/>
<xsl:key name="externaldatalookupid"  match="fuge:ExternalData"  use="@identifier"/>
<xsl:key name="organizationlookupid"  match="fuge:Organization"  use="@identifier"/>
<xsl:key name="personlookupid"  match="fuge:Person"  use="@identifier"/>
<xsl:key name="protocollookupid"  match="fuge:GenericProtocol"  use="@identifier"/>
<xsl:key name="actionlookupid"  match="fuge:GenericAction"  use="@identifier"/>
<xsl:key name="parameterlookupid"  match="fuge:GenericParameter"  use="@identifier"/>
<xsl:key name="ontoindlookupid"  match="fuge:OntologyIndividual"  use="@identifier"/>
<xsl:key name="ontosourcelookupid"  match="//fuge:OntologyCollection/fuge:OntologySource"  use="@identifier"/>
<xsl:key name="ontosourceforontoind"  match="//fuge:OntologyCollection/fuge:OntologyIndividual"  use="@OntologySource_ref"/>
<xsl:key name="genericequipmentlookupid" match="fuge:GenericEquipment" use="@identifier"/>
<xsl:key name="contactreflookupid"  match="fuge:Audit"  use="@Contact_ref"/>



<xsl:template match="fuge:FuGE">	
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
  	<xsl:apply-templates select="fuge:OntologyCollection"/><br/>
  	<xsl:apply-templates select="fuge:InvestigationCollection"/><br/>
    <xsl:apply-templates select="fuge:ProtocolCollection"/>
    <xsl:apply-templates select="fuge:GenericProtocolApplication"/><br/>
    <xsl:apply-templates select="fuge:MaterialCollection"/><br/>
    <xsl:apply-templates select="fuge:DataCollection"/>

 <!-- TO DO
     <xsl:apply-templates select="InvestigationCollection"/>
     <xsl:apply-templates select="Protocols"/>
     <xsl:apply-templates select="Data"/>
`	TO DO-->
   </body>
</html>
</xsl:template>


<xsl:template match="fuge:OntologyCollection">
 <table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
 	<tr>
 		<td bgcolor="#CCCCCC">
 			<font face="Arial" size="3pt">
 				<b>Ontology Source Reference</b>
 			</font>
 		</td>
 	</tr>
 	<tr>
 		<td bgcolor="#CCCCCC">
 			<font face="Arial" size="2pt">
 				<b>Term Source Name</b>
 			</font>
 		</td>
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
 		<td bgcolor="#CCCCCC">
 			<font face="Arial" size="2pt">
 				<b>Term Source File</b>
 			</font>
 		</td>
 		<xsl:for-each select="//fuge:OntologySource">
  	     <td bgcolor="#CCCCCC">
  	     	<font face="Arial" size="2pt">
  	     	<xsl:value-of select="@ontologyURI"/> 	      
  	       	<xsl:value-of select="//fuge:OntologySource[generate-id(.)=generate-id(key('ontosourcelookupid',.)[1])]/@name"/>
  	       	</font>
  	     </td>
	   </xsl:for-each>
 	</tr>
 	<tr>
 		<td bgcolor="#CCCCCC">
 			<font face="Arial" size="2pt">
 				<b>Term Source Version</b>
 			</font>
 		</td>
 		<xsl:for-each select="//fuge:OntologySource">
 	  	<td bgcolor="#CCCCCC">
 	  		<font face="Arial" size="2pt">
 	  			<xsl:value-of select="@identifier"/>
 	  			<xsl:value-of select="."/>
 	       </font>
 	  	</td>
 		</xsl:for-each>
 	</tr>
 	<tr>
 		<td bgcolor="#CCCCCC">
 			<font face="Arial" size="2pt">
 				<b>Term Source Description</b>
 			</font>
 		</td>
 		<xsl:for-each select="//fuge:OntologySource">
  	     <td bgcolor="#CCCCCC">
  	     	<font face="Arial" size="2pt">
  	     		<xsl:value-of select="@endurant"/>
  	     		<xsl:value-of select="."/>
 	       </font>
  	     </td>
	   </xsl:for-each>
 	</tr>
 </table>
</xsl:template>

<xsl:template match="fuge:ProtocolCollection">
 <table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
 	<tr>
 		<td bgcolor="#CCCCCC">
 			<font face="Arial" size="3pt">
 				<b>Study Protocols</b>
 	 		</font>
 		</td>
 	</tr>
 	<tr>
 		<td bgcolor="#CCCCCC">
 			<font face="Arial" size="2pt">
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
  	<td bgcolor="#CCCCCC"><font face="Arial" size="2pt"><b>Protocol Instrument</b></font></td>
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
  	<td bgcolor="#CCCCCC" valign="top"><font face="Arial" size="2pt"><b>Protocol Description</b></font></td>
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


 <table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
 <xsl:for-each select="//fuge:GenericProtocolApplication">
<tr>
<xsl:if test="child::fuge:genericOutputData">
 <td bgcolor="#CCCCCC">
 <font face="Arial" size="2pt">
 <xsl:value-of select="key('externaldatalookupid',child::fuge:genericOutputData/@Data_ref)/@name"/>
 </font>
 </td>
   	     <td bgcolor="#CCCCCC">
   	      <font face="Arial" size="2pt">
   	       <!--<xsl:value-of select="key('ontoindlookupid',child::fuge:fileFormat/@OntologyTerm_ref)/@term"/>-->
   	       
   	      <xsl:value-of select="key('ontoindlookupid',key('externaldatalookupid',child::fuge:genericOutputData/@Data_ref)/fuge:fileFormat/@OntologyTerm_ref)/@term"/>
   	      
   	      </font>
  	     </td>
</xsl:if>
<xsl:if test="child::fuge:genericOutputMaterials">
 <td bgcolor="#CCCCCC">
 <font face="Arial" size="2pt">
 <xsl:value-of select="key('materiallookupid',child::fuge:genericOutputMaterials/@Material_ref)/@name"/>
 </font></td>
</xsl:if>
<xsl:if test="child::fuge:genericInputCompleteMaterials">
 <td bgcolor="#CCCCCC">
 <font face="Arial" size="2pt">
 <xsl:value-of select="key('materiallookupid',child::fuge:genericInputCompleteMaterials/@Material_ref)/@name"/>
 </font>
 </td>
</xsl:if>
</tr>
</xsl:for-each>

</table>
</xsl:template>

<xsl:template match="fuge:MaterialCollection">
 <table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
 <tr><td bgcolor="#CCCCCC"><font face="Arial" size="3pt"><b>Study Tab</b></font></td></tr>
 <tr>
  <td bgcolor="#CCCCCC">
   <font face="Arial" size="2pt">
    <b>
	 Material Name
    </b>
   </font>
  </td>
  <td bgcolor="#CCCCCC">
   <font face="Arial" size="2pt">
    <b>
	 Material Type
    </b>
   </font>
  </td>  
  <td bgcolor="#CCCCCC">
   <font face="Arial" size="2pt">
    <b>
	 Description
    </b>
   </font>
  </td>   
  <xsl:for-each select="//fuge:_characteristics[generate-id(.)=generate-id(key('materialcharlookupid',.)[1])]">
      <td bgcolor="#CCCCCC"><b>
      	<font face="Arial" size="2pt">
         <xsl:text>Characteristics[</xsl:text>
         <!--<xsl:value-of select="@OntologyTerm_ref"/>-->
         <xsl:value-of select="key('ontosourcelookupid',key('ontoindlookupid',@OntologyTerm_ref)/@OntologySource_ref)/@name"/>
       <xsl:text>]</xsl:text>
       </font>
      </b>
      </td>
   </xsl:for-each> 
  </tr>
<xsl:for-each select="//fuge:GenericMaterial">
	<tr>
		<td bgcolor="#CCCCCC">
  	      <font face="Arial" size="2pt">
  	       <xsl:value-of select="@identifier"/>
  	      </font>
  	     </td>
		<xsl:choose>
			<xsl:when test="./fuge:materialType">
				<xsl:for-each select="./fuge:materialType/@OntologyTerm_ref">
					<td bgcolor="#CCCCCC">
						<font face="Arial" size="2pt">
							<xsl:value-of select="key('ontoindlookupid',.)/@term"/>
						</font>
					</td>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<td bgcolor="#CCCCCC">
					<font face="Arial" size="2pt">
						<xsl:text>na</xsl:text>
					</font>
				</td>
			</xsl:otherwise>
  	   </xsl:choose>
		<xsl:choose>
			<xsl:when test="./fuge:auditTrail/fuge:Audit">
				<td bgcolor="#CCCCCC">
					<font face="Arial" size="2pt">
						<xsl:value-of select="./fuge:auditTrail/fuge:Audit/@date"/>
					</font>
				</td>
				<td bgcolor="#CCCCCC">
					<font face="Arial" size="2pt">
						<xsl:value-of select="key('personlookupid',./fuge:auditTrail/fuge:Audit/@Contact_ref)/@name"/>
  	       	 </font>
  	       	</td> 	       	
     	   </xsl:when>
    	   <xsl:otherwise>
  	     	<td bgcolor="#CCCCCC">
  	     	 <font face="Arial" size="2pt">
  	     	   <xsl:text>na</xsl:text>
  	       	 </font>
  	       	</td>
    	   </xsl:otherwise>
    	  </xsl:choose>
		  <xsl:choose>
		  	<xsl:when test="./fuge:descriptions"> 
  	    <td bgcolor="#CCCCCC">
	     	 <font face="Arial" size="2pt">
  	       <xsl:for-each select="./fuge:descriptions/fuge:Description">
  	       	
	     	   <xsl:value-of select="@text"/>;
       	
	       </xsl:for-each>
	       	 </font>
	       	</td>	       
  	   </xsl:when>
  	   <xsl:otherwise>
	     	<td bgcolor="#CCCCCC">
	     	 <font face="Arial" size="2pt">
	     	   <xsl:text>na</xsl:text>
	       	 </font>
	       	</td>
  	   </xsl:otherwise>
  	   </xsl:choose>
  	   
  	   
  	   <xsl:choose>
  	   <xsl:when test="./fuge:characteristics/@OntologyTerm_ref">
  	       <xsl:for-each select="./fuge:characteristics/@OntologyTerm_ref">
  	       
	     	<td bgcolor="#CCCCCC">
	     	 <font face="Arial" size="2pt">
	     	   <xsl:value-of select="key('ontoindlookupid',.)/@term"/>
	       	 </font>
	       	</td>
	       	
	       </xsl:for-each>
	   </xsl:when>  
	   <xsl:otherwise>
	     	<td bgcolor="#CCCCCC">
	     	 <font face="Arial" size="2pt">
	     	   <xsl:text>na</xsl:text>
	       	 </font>
	       	</td>	   
	   </xsl:otherwise>
	   </xsl:choose>
	</tr>
</xsl:for-each> 
</table>
</xsl:template>

<xsl:template match="fuge:DataCollection">
 <table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
  <tr><td bgcolor="#CCCCCC"><font face="Arial" size="3pt"><b>Assay Tab</b></font></td></tr>

 <tr>
 <td bgcolor="#CCCCCC"><font face="Arial" size="3pt"><b>Raw Data File
 </b></font></td>
  <td bgcolor="#CCCCCC"><font face="Arial" size="3pt"><b>File Format
 </b></font></td>
   <td bgcolor="#CCCCCC"><font face="Arial" size="3pt"><b>Storage
 </b></font></td>
 </tr>
 
  <xsl:for-each select="//fuge:ExternalData">
  <tr> 
   <td bgcolor="#CCCCCC">
  	      <font face="Arial" size="2pt">
   	       <xsl:value-of select="@name"/>:    
  	       <xsl:value-of select="@location"/><br/>
  	       <xsl:value-of select="child::fuge:_externalFormatDocumentation/fuge:URI/@location"/>

  	      </font>
  	     </td>
  	     <td bgcolor="#CCCCCC">
  	      <font face="Arial" size="2pt">
  	       <xsl:value-of select="key('ontoindlookupid',child::fuge:_fileFormat/@OntologyTerm_ref)/@term"/>
  	      </font>
  	     </td> 
  	     <td bgcolor="#CCCCCC"></td>
    </tr> 
  </xsl:for-each> 
   <xsl:for-each select="//fuge:GenericInternalData">
  <tr> 
   <td bgcolor="#CCCCCC">
  	      <font face="Arial" size="2pt">
  	       <xsl:value-of select="@identifier"/>
  	      </font>
  	     </td>
  	     <td bgcolor="#CCCCCC">
  	      <font face="Arial" size="2pt">
		<xsl:text>internal</xsl:text>
  	      </font>
  	     </td>
  	     <td bgcolor="#CCCCCC">
	       	      <font face="Arial" size="2pt">
	       	      <xsl:if test="child::fuge:storage">
	       	       <xsl:value-of select="."/>
	       	       </xsl:if>
	       	      </font>
  	     </td>
    </tr> 
  </xsl:for-each>  
   <xsl:for-each select="//fcm:ListModeDataFile">
  <tr> 
   <td bgcolor="#CCCCCC">
  	      <font face="Arial" size="2pt">
  	       <xsl:value-of select="@name"/>
  	      </font>
  	     </td>
  	     <td bgcolor="#CCCCCC">
  	      <font face="Arial" size="2pt">
  	       <xsl:value-of select="key('ontoindlookupid',child::fuge:_fileFormat/@OntologyTerm_ref)/@term"/>
  	      </font>
  	     </td> 
  	     <td bgcolor="#CCCCCC"></td>
    </tr> 
  </xsl:for-each>   

</table>
</xsl:template>

	<xsl:template match="fuge:InvestigationCollection">
		<table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
			<tr>
				<td bgcolor="#CCCCCC">
					<font face="Arial" size="3pt">
					<b>Investigation Identifier</b>
					</font>
				</td>
				<xsl:for-each select="//fuge:Investigation">
				<td bgcolor="#CCCCCC">
					<font face="Arial" size="3pt">
					<xsl:value-of select="@identifier"/>
					</font>
				</td>
				</xsl:for-each>				
			</tr>
			<tr>
				<td bgcolor="#CCCCCC">
					<font face="Arial" size="3pt">
						<b>Investigation Name</b>
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
				<td bgcolor="#CCCCCC">
					<font face="Arial" size="3pt">
					 <b>Description</b>
					</font>
				</td>
				<xsl:for-each select="//fuge:Investigation">
				<xsl:choose>
				<xsl:when test="child::fuge:_descriptions">
					<xsl:for-each select="child::fuge:_descriptions/fuge:Description">
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
		</table>	
	</xsl:template>
</xsl:stylesheet>