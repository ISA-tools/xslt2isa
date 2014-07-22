<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#160;">
  <!ENTITY copy "&#169;">
]>

<!--xsl stylesheet prototype for html ISA-TAB like rendering of GelML XML documents  
Author: Philippe Rocca-Serra, EMBL-EBI (rocca@ebi.ac.uk) , May 2008-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:fuge="http://fuge.sourceforge.net/fuge/1.0"
	xmlns:gelml="http://www.psidev.info/gelml/1.0">
<xsl:output method="html"/>


    <xsl:key name="fugemateriallookupid"  match="fuge:GenericMaterial"  use="@identifier"/>
    <xsl:key name="gelmlmateriallookupid"  match="gelml:MeasuredMaterial"  use="@identifier"/>	
	<xsl:key name="materialcharlookupid"  match="fuge:MaterialCollection/fuge:GenericMaterial/characteristics"  use="."/>
	<xsl:key name="investigationlookupid"  match="fuge:Investigation"  use="@identifier"/>
	<xsl:key name="externaldatalookupid"  match="fuge:ExternalData"  use="@identifier"/>
	<xsl:key name="organizationlookupid"  match="fuge:Organization"  use="@identifier"/>
	<xsl:key name="personlookupid"  match="fuge:Person"  use="@identifier"/>
    <xsl:key name="protocollookupid"  match="fuge:GenericProtocol"  use="@identifier"/>
	<xsl:key name="sampleloadingprotocollookupid"  match="gelml:SampleLoadingProtocol"  use="@identifier"/>
	<xsl:key name="actionlookupid"  match="fuge:GenericAction"  use="@identifier"/>
	<xsl:key name="parameterlookupid"  match="fuge:GenericParameter"  use="@identifier"/>
	<xsl:key name="ontoindlookupid"  match="fuge:OntologyIndividual"  use="@identifier"/>
	<xsl:key name="ontosourcelookupid"  match="fuge:OntologyCollection/fuge:OntologySource"  use="@identifier"/>
	<xsl:key name="ontosourceforontoind"  match="fuge:OntologyCollection/fuge:OntologyIndividual"  use="@OntologySource_ref"/>
	<xsl:key name="genericequipmentlookupid" match="fuge:GenericEquipment" use="@identifier"/>
	<xsl:key name="contactreflookupid"  match="fuge:Audit"  use="@Contact_ref"/>

	<xsl:key name="gellookupid" match="gelml:Gel" use="@identifier"/>
	<xsl:key name="gel1dlookupid" match="gelml:Gel1D" use="@identifier"/>
	<xsl:key name="gel2dlookupid" match="gelml:Gel2D" use="@identifier"/>
	<xsl:key name="imagelookupid" match="gelml:Image" use="@identifier"/>
	
	<xsl:key name="PAby_inputCompleteMaterials"
		match="fuge:GenericProtocolApplication/fuge:genericInputCompleteMaterials"
		use="parent::node()/@identifier"/>
	
	<xsl:key name="PAby_GenericMaterialMeasurement"
		match="fuge:GenericProtocolApplication/fuge:GenericMaterialMeasurement"
		use="@Material_ref"/>
	
	<xsl:key name="PAby_inputCompleteMaterials"
		match="fuge:GenericProtocolApplication/fuge:GenericProtocolApplication"
		use="parent::node()/@identifier"/> 
	
	<xsl:key name="PAby_outputMaterials"
		match="fuge:GenericProtocolApplication/fuge:genericOutputMaterials"
		use="@Material_ref"/>
	
	<xsl:key name="PAby_outputData" 
		match="fuge:GenericProtocolApplication/fuge:genericOutputData"
		use="@Data_ref"/>

	<xsl:key name="datafilelookupid"
		match="fuge:ExternalData"
		use="@identifier"/>	

	<xsl:template match="gelml:GelML">	
<html>
 <head><title>GelML Submission</title></head>
  <body bgcolor="gray">
   <p>
    <h1>
     <font color="#003366" face="Arial" size="2pt">
      <b>GelML Document:</b>
      <xsl:value-of select="@identifier"/>
     </font>
    </h1>
   </p>
  	<!--<xsl:apply-templates/>-->
  	<xsl:apply-templates select="//fuge:OntologyCollection"/>
  	<xsl:apply-templates select="//gelml:GelMLProtocolCollection"/>
  	<xsl:apply-templates select="//gelml:GelMLMaterialCollection"/>
  	<xsl:apply-templates select="//gelml:GelMLDataCollection"/>
  	<xsl:apply-templates select="//gelml:Gel2DExperiment"/>	
  	<br/>
   </body>
</html>
</xsl:template>


<xsl:template match="//fuge:OntologyCollection">
 <table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
 	<tr><td bgcolor="#003366" width="200"><font color="#CCCCCC" face="Arial" size="3pt"><b>Ontology Source Reference</b></font></td></tr>
<tr>
	<td bgcolor="#003366" width="200"><font color="#CCCCCC" face="Arial" size="2pt"><b>Term Source Name</b></font></td>
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
  	<td bgcolor="#003366" width="200"><font color="#CCCCCC" face="Arial" size="2pt"><b>Term Source File</b></font></td>
  	<xsl:for-each select="//fuge:OntologySource">
  	     <td bgcolor="#CCCCCC"><font face="Arial" size="2pt">
  	      <xsl:value-of select="@ontologyURI"/>
  	     	<xsl:value-of select="//fuge:OntologySource[generate-id(.)=generate-id(key('ontosourcelookupid',.)[1])]/@name"/>
 	       </font></td>
	   </xsl:for-each>
   </tr>  
  <tr>
  	<td bgcolor="#003366" width="200"><font color="#CCCCCC" face="Arial" size="2pt"><b>Term Source Version</b></font></td>
  	<xsl:for-each select="//fuge:OntologySource">
  	     <td bgcolor="#CCCCCC"><font face="Arial" size="2pt">
  	      <xsl:value-of select="@identifier"/>
  	       <xsl:value-of select="."/>
 	       </font></td>
	   </xsl:for-each>
  </tr>
  <tr>
  	<td bgcolor="#003366" width="200"><font color="#CCCCCC" face="Arial" size="2pt"><b>Term Source Description</b></font></td>
  	<xsl:for-each select="//fuge:OntologySource">
  	     <td bgcolor="#CCCCCC"><font face="Arial" size="2pt">
  	      <xsl:value-of select="@endurant"/>
  	       <xsl:value-of select="."/>
 	       </font></td>
	   </xsl:for-each>
  </tr>
</table>
</xsl:template>

<xsl:template match="//gelml:GelMLProtocolCollection">
 <table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
 	<tr><td bgcolor="#003366" width="200"><font color="#CCCCCC" face="Arial" size="3pt"><b>Study Protocols</b></font></td></tr>
    <tr>
    	<td bgcolor="#003366" width="200"><font color="#CCCCCC" face="Arial" size="2pt"><b>Protocol Name</b></font></td>

	<xsl:for-each select="//fuge:GenericProtocol">
		<td bgcolor="#CCCCCC">
			<font face="Arial" size="2pt">
				<xsl:value-of select="@name"/>
			</font>
		</td>
	</xsl:for-each>
	<xsl:for-each select="//gelml:DetectionProtocol">
		<td bgcolor="#CCCCCC">
			<font face="Arial" size="2pt">
				<xsl:value-of select="@name"/>
			</font>
		</td>
	</xsl:for-each>	
    <xsl:for-each select="//gelml:ElectrophoresisProtocol">
    		<td bgcolor="#CCCCCC">
    			<font face="Arial" size="2pt">
    				<xsl:value-of select="@name"/>
    			</font>
    		</td>
    </xsl:for-each>    	
	<xsl:for-each select="//gelml:Gel2DProtocol">
		<td bgcolor="#CCCCCC">
			<font face="Arial" size="2pt">
				<xsl:value-of select="@name"/>
			</font>
		</td>
	</xsl:for-each>
    <xsl:for-each select="//gelml:SampleLoadingProtocol">
    		<td bgcolor="#CCCCCC">
    			<font face="Arial" size="2pt">
    				<xsl:value-of select="@name"/>
    			</font>
    		</td>
    </xsl:for-each> 
    <xsl:for-each select="//gelml:SubstanceMixtureProtocol">
    		<td bgcolor="#CCCCCC">
    			<font face="Arial" size="2pt">
    				<xsl:value-of select="@name"/>
    			</font>
    		</td>
    </xsl:for-each> 	 
  </tr> 
  <tr>
  	<td bgcolor="#003366" width="200"><font color="#CCCCCC" face="Arial" size="2pt"><b>Protocol Instrument</b></font></td>
  	<xsl:for-each select="//fuge:GenericProtocol">
  		<td bgcolor="#CCCCCC"><font face="Arial" size="2pt">
  		<xsl:choose>
  			<xsl:when test="child::fuge:genPrtclToEquip">	      
  			<xsl:for-each select="child::fuge:genPrtclToEquip">
  				<font face="Arial" size="2pt">
  					<xsl:value-of select="key('genericequipmentlookupid',@GenericEquipment_ref)/@name"/>
  					<xsl:text>;</xsl:text>         	        	
  				</font>
  			</xsl:for-each>
  			</xsl:when>
  			<xsl:otherwise>
  				<font face="Arial" size="2pt"><i>no instrument reported or used</i></font>
  			</xsl:otherwise>
  		</xsl:choose>	
  		</font></td> 
  	</xsl:for-each>
  	
  	<xsl:for-each select="//gelml:DetectionProtocol">
  		<td bgcolor="#CCCCCC"><font face="Arial" size="2pt">      
  			<xsl:choose>
  				<xsl:when test="./gelml:_electrophoresisEquipment">
  					<font face="Arial" size="2pt">     	
  						<xsl:value-of select="key('genericequipmentlookupid',child::gelml:_electrophoresisEquipment/@GenericEquipment_ref)/@name"/>
  						<xsl:value-of select="@GenericEquipment_ref"/>  					
  					</font>
  				</xsl:when>
  				<xsl:otherwise>
  					<font face="Arial" size="2pt"><i>no instrument reported or used</i></font>
  				</xsl:otherwise>
  			</xsl:choose>	
  		</font></td> 
  	</xsl:for-each> 
  	<xsl:for-each select="//gelml:ElectrophoresisProtocol">
  		<td bgcolor="#CCCCCC"><font face="Arial" size="2pt">      
  			<xsl:choose>
  				<xsl:when test="./gelml:_electrophoresisEquipment">
  					<font face="Arial" size="2pt">     	
  						<xsl:value-of select="key('genericequipmentlookupid',child::gelml:_electrophoresisEquipment/@GenericEquipment_ref)/@name"/>
  						<xsl:value-of select="@GenericEquipment_ref"/>  					
  					</font>
  				</xsl:when>
  				<xsl:otherwise>
  					<font face="Arial" size="2pt"><i>no instrument reported or used</i></font>
  				</xsl:otherwise>
  			</xsl:choose>	
  		</font></td> 
  	</xsl:for-each>
  	<xsl:for-each select="//gelml:Gel2DProtocol">
  		<td bgcolor="#CCCCCC"><font face="Arial" size="2pt">      
  			<xsl:choose>
  				<xsl:when test="./gelml:_electrophoresisEquipment">
  					<font face="Arial" size="2pt">     	
  						<xsl:value-of select="key('genericequipmentlookupid',child::gelml:_electrophoresisEquipment/@GenericEquipment_ref)/@name"/>
  						<xsl:value-of select="@GenericEquipment_ref"/>  					
  					</font>
  				</xsl:when>
  				<xsl:otherwise>
  					<font face="Arial" size="2pt"><i>no instrument reported or used</i></font>
  				</xsl:otherwise>
  			</xsl:choose>	
  		</font></td> 
  	</xsl:for-each>  	  	
  	<xsl:for-each select="//gelml:SampleLoadingProtocol">
  		<td bgcolor="#CCCCCC"><font face="Arial" size="2pt">      
  			<xsl:choose>
  				<xsl:when test="./gelml:_electrophoresisEquipment">
  					<font face="Arial" size="2pt">     	
  						<xsl:value-of select="key('genericequipmentlookupid',child::gelml:_electrophoresisEquipment/@GenericEquipment_ref)/@name"/>
  						<xsl:value-of select="@GenericEquipment_ref"/>  					
  					</font>
  				</xsl:when>
  				<xsl:otherwise>
  					<font face="Arial" size="2pt"><i>no instrument reported or used</i></font>
  				</xsl:otherwise>
  			</xsl:choose>	
  		</font></td> 
  	</xsl:for-each>  	 
  	<xsl:for-each select="//gelml:SubstanceMixtureProtocol">
  		<td bgcolor="#CCCCCC"><font face="Arial" size="2pt">
  		<xsl:choose>
  			<xsl:when test="./gelml:_electrophoresisEquipment">
  				<font face="Arial" size="2pt">     	
  					<xsl:value-of select="key('genericequipmentlookupid',child::gelml:_electrophoresisEquipment/@GenericEquipment_ref)/@name"/>
  					<!--<xsl:value-of select="@GenericEquipment_ref"/>  -->					
  				</font>
  			</xsl:when>
  			<xsl:otherwise>
  				<font face="Arial" size="2pt"><i>none used</i></font>
  			</xsl:otherwise>
  		</xsl:choose>
  		</font></td>
  	</xsl:for-each> 
  </tr> 
 	 
  <tr>
  	<td bgcolor="#003366" width="200"><font color="#CCCCCC" face="Arial" size="2pt"><b>Protocol Description</b></font></td>
  	<xsl:for-each select="//fuge:GenericProtocol">
  		<td bgcolor="#CCCCCC"><font face="Arial" size="2pt">
  			<font face="Arial" size="2pt">
  				<xsl:value-of select="@protocolText"/>
  			</font>
  			<xsl:for-each select="child::fuge:GenericAction">
  				<font face="Arial" size="2pt">
  					<b><xsl:text>action:</xsl:text></b>
  					<xsl:value-of select="@name"/><br/>
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
  				<xsl:when test="child::GenericAction">-->      
  			<!--</xsl:when>
  				<xsl:otherwise>
  				<font face="Arial" size="2pt">-</font>
  				</xsl:otherwise>
  				</xsl:choose>	-->	 	 
  		</font></td> 
  	</xsl:for-each>
  	<xsl:for-each select="//gelml:DetectionProtocol">
  		<td bgcolor="#CCCCCC"><font face="Arial" size="2pt">
  			<font face="Arial" size="2pt">
  				<xsl:value-of select="@protocolText"/>
  			</font>
  			<xsl:for-each select="gelml:SubstanceAction">
  				<font face="Arial" size="2pt">
  					<b><xsl:text>action:</xsl:text></b>
  					<xsl:value-of select="@actionText"/><br/>
  					<b><xsl:text>order:</xsl:text></b>
  					<xsl:value-of select="@actionOrdinal"/>
  					<br/>
  				</font>
  				<xsl:if test="child::gelml:_substanceType">
  					<xsl:value-of select="OntologyTerm_ref"/>
  				</xsl:if>
  			</xsl:for-each>	 
  		</font></td> 
  	</xsl:for-each> 
    <xsl:for-each select="//gelml:ElectrophoresisProtocol">
   		<td bgcolor="#CCCCCC"><font face="Arial" size="2pt">
  			<font face="Arial" size="2pt">
  				<xsl:value-of select="@protocolText"/>
  			</font>
  			<xsl:for-each select="child::gelml:ElectrophoresisStep">
  				<font face="Arial" size="2pt">
  					<b><xsl:text>action:</xsl:text></b>
  					<xsl:value-of select="@identifier"/><br/>
  					<b><xsl:text>order:</xsl:text></b>
  					<xsl:value-of select="./gelml:Duraction/@identifier"/>
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

  			<!--<xsl:choose>
  				<xsl:when test="child::GenericAction">-->      
  			<!--</xsl:when>
  				<xsl:otherwise>
  				<font face="Arial" size="2pt">-</font>
  				</xsl:otherwise>
  				</xsl:choose>	-->	 	 
  		</font></td> 
  	</xsl:for-each>	
  	<xsl:for-each select="//gelml:Gel2DProtocol">
  		<td bgcolor="#CCCCCC"><font face="Arial" size="2pt">
  			<font face="Arial" size="2pt">
  				<xsl:value-of select="@protocolText"/>
  			</font>
  			<xsl:for-each select="child::gelml:SampleLoadingAction">
  				<font face="Arial" size="2pt">
  					<b><xsl:text>action:</xsl:text></b>
  					<xsl:value-of select="@identifier"/><br/>
  					<b><xsl:text>order:</xsl:text></b>
  					<xsl:value-of select="@actionOrdinal"/>
  					<br/>
  				</font>
  			</xsl:for-each>
  			<xsl:for-each select="child::gelml:FirstDimensionAction">
  				<font face="Arial" size="2pt">
  					<b><xsl:text>first dimension:</xsl:text></b>
  					<xsl:value-of select="@identifier"/><br/>
  					<b><xsl:text>order:</xsl:text></b>
  					<xsl:value-of select="@actionOrdinal"/>
  					<br/>
  				</font>
  			</xsl:for-each>        
  			<xsl:for-each select="child::gelml:SecondDimensionAction">
  				<font face="Arial" size="2pt">
  					<b><xsl:text>second dimension: </xsl:text></b>
  					<xsl:value-of select="@identifier"/><br/>
  					<b><xsl:text>order:</xsl:text></b>
  					<xsl:value-of select="@actionOrdinal"/>
  					<br/>
  				</font>
  			</xsl:for-each>
  			<xsl:for-each select="child::gelml:InterDimensionAction">
  				<font face="Arial" size="2pt">
  					<b><xsl:text>inter dimension action: </xsl:text></b>
  					<xsl:value-of select="@identifier"/><br/>
  					<b><xsl:text>order:</xsl:text></b>
  					<xsl:value-of select="@actionOrdinal"/>
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
  				<xsl:when test="child::GenericAction">-->      
  			<!--</xsl:when>
  				<xsl:otherwise>
  				<font face="Arial" size="2pt">-</font>
  				</xsl:otherwise>
  				</xsl:choose>	-->	 	 
  		</font></td> 
  	</xsl:for-each> 	
  	<xsl:for-each select="//gelml:SampleLoadingProtocol">
  		<td bgcolor="#CCCCCC"><font face="Arial" size="2pt">  
  			<font face="Arial" size="2pt">
  				<xsl:value-of select="@protocolText"/>
  			</font>    
  			<xsl:choose>
  				<xsl:when test="./gelml:_electrophoresisEquipment">
  					<font face="Arial" size="2pt">     	
  						<xsl:value-of select="key('genericequipmentlookupid',child::gelml:_electrophoresisEquipment/@GenericEquipment_ref)/@name"/>
  						<xsl:value-of select="@GenericEquipment_ref"/>  					
  					</font>
  				</xsl:when>
  				<xsl:otherwise>
  					<font face="Arial" size="2pt"><i>no instrument reported or used</i></font>
  				</xsl:otherwise>
  			</xsl:choose>	
  		</font></td> 
  	</xsl:for-each>
   	<xsl:for-each select="//gelml:SubstanceMixtureProtocol">
  		<td bgcolor="#CCCCCC"><font face="Arial" size="2pt">      
  			<xsl:choose>
  				<xsl:when test="./gelml:SubstanceAction">
  					<xsl:for-each select="./gelml:SubstanceAction">
  						<font face="Arial" size="2pt">     	
  							<xsl:value-of select="@name"/>  					
  						</font>						
  					</xsl:for-each>
  				</xsl:when>
  				<xsl:otherwise>
  					<font face="Arial" size="2pt"><i>no instrument reported or used</i></font>
  				</xsl:otherwise>
  			</xsl:choose>	
  		</font></td> 
  	</xsl:for-each>
  	  
  </tr>
</table>
</xsl:template>

<xsl:template match="//gelml:GelMLMaterialCollection">

 <table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">

 	<tr><td bgcolor="#003366" width="200"><font color="#CCCCCC" face="Arial" size="3pt"><b>Study Tab</b></font></td></tr>
 	<tr bgcolor="#003366">
 	<td  width="200">
 		<font color="#CCCCCC" face="Arial" size="2pt">
    <b>
	 Material Name
    </b>
   </font>
  </td>
 	<td>
 		<font color="#CCCCCC" face="Arial" size="2pt">
    <b>
	 Material Type
    </b>
   </font>
  </td>  
 	<td>
 		<font color="#CCCCCC" face="Arial" size="2pt">
    <b>
	 Description
    </b>
   </font>
  </td>
 	<td>
 		<font color="#CCCCCC" face="Arial" size="2pt">
 			<b>
 				Date
 			</b>
 		</font>
 	</td> 
 	<td>
 		<font color="#CCCCCC" face="Arial" size="2pt">
 			<b>
 				Performer
 			</b>
 		</font>
 	</td> 	   
 	<xsl:for-each select="//fuge:_characteristics">
 		<td><b><font face="Arial" size="2pt">
       <xsl:text>Characteristics[</xsl:text>
       <!--<xsl:value-of select="@OntologyTerm_ref"/>-->
      	<xsl:value-of select="key('ontosourcelookupid',key('ontoindlookupid',@OntologyTerm_ref)/@OntologySource_ref)/@name"/>
       <xsl:text>]</xsl:text>
       </font></b></td>
   </xsl:for-each>
   </tr>
 

<xsl:for-each select="fuge:GenericMaterial">
	<xsl:variable name="color">
		<xsl:choose>
			<xsl:when test="position() mod 2= 0">#B0C4DE</xsl:when>
			<xsl:otherwise>#CCCCCC</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
<tr bgcolor="{$color}">
   	<td width="200">
  	      <font face="Arial" size="2pt">
  	       <!--<xsl:value-of select="@identifier"/>:-->
  	      	<xsl:value-of select="@name"/>
  	      </font>
  	     </td>
	<xsl:choose>
		<xsl:when test="./fuge:_materialType">
			<xsl:for-each select="./fuge:_materialType/@OntologyTerm_ref">
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
	     	 	<font color="darkred"><i><xsl:text>na</xsl:text></i></font>
	       	 </font>
	       	</td>
  	   </xsl:otherwise>
  	</xsl:choose>

  	<xsl:choose>
  		<xsl:when test="./fuge:descriptions"> 
  			<td>
  				<font face="Arial" size="2pt">
  					<xsl:for-each select="./fuge:descriptions/fuge:Description">						
  						<xsl:value-of select="@text"/><br/> 						
  					</xsl:for-each>
  				</font>
  			</td>	       
  		</xsl:when>
  		<xsl:otherwise>
  			<td>
  				<font face="Arial" size="2pt">
  					<font color="darkred"><i><xsl:text>na</xsl:text></i></font>
  				</font>
  			</td>
  		</xsl:otherwise>
  	</xsl:choose> 
      
  	<xsl:choose>
  		<xsl:when test="./fuge:auditTrail/fuge:Audit">
        	<td>
  	     	 <font face="Arial" size="2pt">
  	     	 	<xsl:value-of select="substring-before(./fuge:auditTrail/fuge:Audit/@date,'T')"/>
  	       	 </font>
  	       	</td>
   	     	<td>
  	     	 <font face="Arial" size="2pt">
  	     	 	<xsl:value-of select="key('personlookupid',./fuge:auditTrail/fuge:Audit/@Contact_ref)/@name"/>
  	       	 </font>
  	       	</td> 	       	
     	   </xsl:when>
    	<xsl:otherwise>
  	     	<td>
  	     	 <font face="Arial" size="2pt">
  	     	 	<font color="darkred"><i><xsl:text>na</xsl:text></i></font>
  	       	 </font>
  	       	</td>
    		<td>
    			<font face="Arial" size="2pt">
    				<font color="darkred"><i><xsl:text>na</xsl:text></i></font>
    			</font>
    		</td> 		
       </xsl:otherwise>
  	   </xsl:choose> 
  	     	   
    <xsl:choose>
  	   	<xsl:when test="./fuge:characteristics">
    		<xsl:for-each select="./fuge:characteristics">
	     	<td>
	     	 <font face="Arial" size="2pt">
	     	 	<xsl:value-of select="key('ontoindlookupid',@OntologyTerm_ref)/@term"/>
	       	 </font>
	       	</td>
	       	
	       </xsl:for-each>
	   </xsl:when>  
	   <xsl:otherwise>
	     	<td>
	     	 <font face="Arial" size="2pt">
	     	 	<font color="darkred"><i><xsl:text>na</xsl:text></i></font>
	       	 </font>
	       	</td>	   
	   </xsl:otherwise>
   </xsl:choose>  	   
  	   
  </tr> 	       
	  </xsl:for-each> 
 	<xsl:for-each select="gelml:MeasuredMaterial">
 		<tr>
 			<td width="200">
 				<font face="Arial" size="2pt">
 					<xsl:value-of select="@name"/>
 				</font>
 			</td>
 		</tr>
 	</xsl:for-each>
</table>
</xsl:template>

<xsl:template name="Gel2DExperiment" match="//gelml:Gel2DExperiment">

	<xsl:if test="child::gelml:SampleLoadingApplication/fuge:GenericMaterialMeasurement">
		
	<table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
		<tr>
			<td  bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt"><b>Sample Name</b></font></td>
			<td  bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt"><b>Protocol REF</b></font></td>
			<td  bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt"><b>Electrophoresis Gel Name</b></font></td>
			<td  bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt"><b>1st Dimension</b></font></td>
			<td  bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt"><b>2nd Dimension</b></font></td>
			<td  bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt"><b>comment[acrylamide proportion]</b></font></td>
			<td  bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt"><b>Electrophoresis type</b></font></td>    
			<td  bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt"><b>Scan Name</b></font></td>
			<td  bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt"><b>Protocol REF</b></font></td>
			<td  bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt"><b>Label</b></font></td>			
			<td  bgcolor="#003366"><font color="#CCCCCC" face="Arial" size="2pt"><b>Image File</b></font></td>
		</tr>
		<xsl:for-each select="child::gelml:SampleLoadingApplication/fuge:GenericMaterialMeasurement">
			<xsl:variable name="color">
				<xsl:choose>
					<xsl:when test="position() mod 2= 0">#B0C4DE</xsl:when>
					<xsl:otherwise>#CCCCCC</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
		<tr bgcolor="{$color}">
			<td><font face="Arial" size="2pt"><xsl:value-of select="key('fugemateriallookupid',@Material_ref)/@name"/></font></td>
			<td><font face="Arial" size="2pt"><xsl:value-of select="key('sampleloadingprotocollookupid',parent::node()/@SampleLoadingProtocol_ref)/@name"/></font></td>
			<td><font face="Arial" size="2pt"><xsl:value-of select="key('gellookupid',parent::node()/@Gel_ref)/@name"/></font></td>
			<td><font face="Arial" size="2pt"><xsl:value-of select="parent::node()/following-sibling::node()[2]/gelml:_inputFirstDimension/gelml:Gel/@name"/></font></td>
			<td><font face="Arial" size="2pt"><xsl:value-of select="parent::node()/following-sibling::node()[2]/gelml:_inputSecondDimension/gelml:Gel/@name"/></font></td>
			<td><font face="Arial" size="2pt"><xsl:value-of select="parent::node()/following-sibling::node()[2]/gelml:_inputSecondDimension/gelml:Gel/gelml:_percentAcrylamide/fuge:AtomicValue/@value"/> %</font></td>	
			<td><font face="Arial" size="2pt"><xsl:value-of select="key('ontoindlookupid',parent::node()/following-sibling::node()[1]/@OntologyTerm_ref)/@term"/></font></td>
			<td><font face="Arial" size="2pt"><xsl:value-of select="parent::node()/preceding-sibling::node()[3]/@identifier"/></font></td>			
			<td><font face="Arial" size="2pt"><xsl:value-of select="key('protocollookupid',parent::node()/preceding-sibling::node()[3]/@ImageAcquisitionProtocol_ref)/@name"/></font></td>	
			<td><font face="Arial" size="2pt"><xsl:value-of select="key('ontoindlookupid',key('imagelookupid',parent::node()/preceding-sibling::node()[3]/@Image_ref)/gelml:_channel/fuge:ComplexValue/fuge:_value/@OntologyTerm_ref)/@term"/></font></td>				
			<td><font face="Arial" size="2pt"><xsl:value-of select="key('imagelookupid',parent::node()/preceding-sibling::node()[3]/@Image_ref)/@location"/></font></td>
			</tr>
	    </xsl:for-each>
		<!--<xsl:for-each select="child::gelml:ExcisionApplication">
			<tr bgcolor="#CCCCCC">
				<td><font face="Arial" size="2pt"><xsl:value-of select="@ElectrophoresedGel_ref"/></font></td>
				<td bgcolor="#CCCCCC"><font face="Arial" size="2pt"><xsl:value-of select="parent::node()/@SampleLoadingProtocol_ref"/></font></td>
				<td bgcolor="#CCCCCC"><font face="Arial" size="2pt"><xsl:value-of select="parent::node()/@Gel_ref"/></font></td>
				<td bgcolor="#CCCCCC"><font face="Arial" size="2pt"><xsl:value-of select="key('ontoindlookupid',parent::node()/following-sibling::node()[1]/@OntologyTerm_ref)/@term"/></font></td>
				<td bgcolor="#CCCCCC"><font face="Arial" size="2pt"><xsl:value-of select="parent::node()/following-sibling::node()[2]/gelml:_inputFirstDimension/gelml:Gel/@name"/></font></td>
				<td bgcolor="#CCCCCC"><font face="Arial" size="2pt"><xsl:value-of select="parent::node()/following-sibling::node()[2]/gelml:_inputSecondDimension/gelml:Gel/@name"/></font></td>
				<td bgcolor="#CCCCCC"><font face="Arial" size="2pt"><xsl:value-of select="parent::node()/following-sibling::node()[2]/gelml:_inputSecondDimension/gelml:Gel/gelml:_percentAcrylamide/fuge:AtomicValue/@value"/> %</font></td>
				<td bgcolor="#CCCCCC"><font face="Arial" size="2pt"><xsl:value-of select="parent::node()/preceding-sibling::node()[3]/@Image_ref"/></font></td>
				<td bgcolor="#CCCCCC"><font face="Arial" size="2pt"><xsl:value-of select="parent::node()/preceding-sibling::node()[3]/@ImageAcquisitionProtocol_ref"/></font></td>				
			</tr>
	</xsl:for-each>	-->
	</table>
	</xsl:if>	
</xsl:template>


	<!--
		<table font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
		<tr>
		<td  bgcolor="#33333"><font color="gray" face="Arial" size="2pt">Sample</font></td>
		<td  bgcolor="#33333"><font color="gray" face="Arial" size="2pt">Protocol REF</font></td>
		<td  bgcolor="#33333"><font color="gray" face="Arial" size="2pt">Gel Name</font></td>
		<td  bgcolor="#33333"><font color="gray" face="Arial" size="2pt">Electrophoresis type</font></td>    
		<td  bgcolor="#33333"><font color="gray" face="Arial" size="2pt">Image File</font></td>
		</tr>
		</table>
	-->





</xsl:stylesheet>