<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#160;">
  <!ENTITY copy "&#169;">
]>

<!--xsl stylesheet prototype for SRA XML documents representing submission 000266 
Author: Philippe Rocca-Serra, EMBL-EBI (rocca@ebi.ac.uk) -->


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html"/>

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
<html>
 <head><title>SRA Submission</title></head>

           <link rel="stylesheet"
                  type="text/css"
                  href="sra-style.css"/>

           <script src="tabs.js" type="text/javascript">

           </script> 

  <body bgcolor="gray">
   <p>
       <h1>
           <img class="floatleft" src="logo-3.png" alt="ISATAB Logo" />
                            <font color="#006838"
                              face="Verdana"
                              size="2pt">
                            <b>SRA Document:</b>
                                <xsl:value-of select="@identifier"/>
    </font></h1>
   </p>

 <ul class = "tabs primary">

    <li><a href="#investigation">INVESTIGATION</a></li>

    <li><a href="#studies">STUDY SAMPLES</a></li>

    <li><a href="#assays">EXPERIMENTS AND RUNS  </a></li>

</ul>

     <div class="content" id="investigation">      
    
    <table width="100%" font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
      <tr>
         <td class="delta">Ontology Source Reference</td>
         <!--<td class="beta"></td> -->
      </tr>
      <tr>
         <td class="delta">Term Source Name</td>
         <td class="beta">ENA-CV</td>
      </tr>
      <tr>
         <td class="delta">Term Source File</td>
         <td class="beta">ENA-CV.obo</td>
      </tr>
      <tr>
         <td class="delta">Term Source Version</td>
         <td class="beta">1</td>
      </tr>
       <tr>
         <td class="delta">Term Source Description</td>
         <td class="beta">Controlled Terminology for SRA/ENA schema</td>
      </tr>     
      
<!--      <tr>
         <td class="delta">Investigation</td>
         <td class="beta">-</td>
      </tr> 
       <tr>
         <td class="delta">Investigation Title</td>
         <td class="beta">-</td>
      </tr>
      <tr>
         <td class="delta">Investigation description</td>
         <td class="beta">-</td>
      </tr>
      <tr>
         <td class="delta">Date of Investigation submission</td>
         <td class="beta">-</td>
      </tr>
      <tr>
         <td class="delta">Investigation Public Release Date</td>
         <td class="beta">-</td>
      </tr>
       <tr>
         <td class="delta">STUDY FILE NAMES</td>
         <td class="beta">-</td>
      </tr>    
    
       <tr>
         <td class="delta">Studies</td>
         <td class="beta">-</td>
      </tr>   -->   
    <xsl:apply-templates select="STUDY"/>
    <xsl:apply-templates select="SUBMISSION"/>
    </table>
      </div>

      <div class="content" id="studies">

             <table width="100%" font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
             <xsl:apply-templates select="SAMPLE_SET"/>
          </table>
      </div>


    <div class="content" id="assays">
           <table width="100%" font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
           <xsl:apply-templates select="RUN_SET"/>
        </table>
    </div>
    
  </body>
</html>
</xsl:template>

<xsl:template match="SUBMISSION">
 <table width="100%" font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
  <xsl:for-each select="//SUBMISSION">
<!--    <tr>
   <xsl:choose>
     <xsl:when test="@accession">
      <td bgcolor="#CCCCCC"><font face="Arial" size="2pt">
       <xsl:value-of select="@accession"/>
      </td>
     </xsl:when>
     <xsl:otherwise>
      <td bgcolor="#CCCCCC"><font face="Arial" size="2pt">-</td>
     </xsl:otherwise>
    </xsl:choose>
   </tr> -->
   <tr>
    <xsl:if test="child::CONTACTS/CONTACT">
      <td class="delta" width="19.7%">Person Last Name</td>
      <td class="beta">
           <xsl:value-of select="child::CONTACTS/CONTACT/@name"/>
      </td>
     </xsl:if>
   </tr>

   <tr>
    <xsl:if test="child::CONTACTS/CONTACT">
      <td class="delta">Person Email
       </td>   
      <td class="beta">
        <xsl:value-of select="child::CONTACTS/CONTACT/@inform_on_status"/>
      </td>
    </xsl:if>  
   </tr>
  </xsl:for-each>
 </table>
</xsl:template>

<xsl:template match="STUDY">
 <table width="100%" font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
  <xsl:for-each select="//STUDY">
 <!--  <tr>
    <td bgcolor="#CCCCCC"><font face="Arial" size="2pt"><b>Study Title</td>
    <xsl:choose>
     <xsl:when test="@alias">
      <td bgcolor="#CCCCCC"><font face="Arial" size="2pt">
       <xsl:value-of select="@alias"/>
      </td>
     </xsl:when>
     <xsl:otherwise>
      <td bgcolor="#CCCCCC"><font face="Arial" size="2pt">-</td>
     </xsl:otherwise>
    </xsl:choose>
   </tr>-->

   
   
   <tr>
    <xsl:if test="child::DESCRIPTOR/STUDY_TITLE">
      <td class="delta" width="15%">Study Title
      </td>
      <td class="beta" width="5%">
           <xsl:value-of select="child::DESCRIPTOR/STUDY_TITLE"/>
      </td>
     </xsl:if>
   </tr>
   <tr>
    <td class="delta" width="15%">Study identifier</td>
    <xsl:choose>
     <xsl:when test="@accession">
      <td class="beta" width="5%">
       <xsl:value-of select="@accession"/>
      </td>
     </xsl:when>
     <xsl:otherwise>
      <td class="beta" width="5%">-</td>
     </xsl:otherwise>
    </xsl:choose>
   </tr>   

      <tr>
         <td class="delta" width="15%">Date of Submission
         </td>
         <td class="beta" width="5%">
            <!-- <xsl:apply-template select="//SUBMISSION" mode="submissiondate"/>    -->

         </td>
   </tr>
      <tr>
         <td class="delta" width="15%">Study Public Release Date
         </td>
         <td class="beta">
              <xsl:value-of select="SRA/SUBMISSION/@submission_date"/>
         </td>
   </tr>
   
   <tr>
    <xsl:if test="child::DESCRIPTOR/STUDY_ABSTRACT">
      <td class="delta" width="15%" valign="top">Study description
       </td>   
      <td class="beta" width="65%" align="justify">
        <xsl:value-of select="child::DESCRIPTOR/STUDY_ABSTRACT"/>
         <xsl:if test="child::DESCRIPTOR/STUDY_DESCRIPTION">
         <xsl:value-of select="child::DESCRIPTOR/STUDY_DESCRIPTION"/>
	</xsl:if>
      </td>
    </xsl:if>  
   </tr>   
      <tr>
       <xsl:if test="child::DESCRIPTOR/STUDY_TYPE">
         <td class="delta" width="15%">Study Design
          </td>   
         <td class="beta" width="15%">
           <xsl:value-of select="child::DESCRIPTOR/STUDY_TYPE/@existing_study_type"/>
         </td>
       </xsl:if>  
      </tr>
      
      <tr>
         <td class="delta" width="15%">Study Design Term Source REF</td>
         <td class="beta">ENA:0000060</td>
      </tr>

      <tr>
         <td class="delta" width="15%">Study Factors</td>
         <!--<td class="delta"></td>-->
      </tr>
      
      <tr>
         <td class="delta" width="15%">Factor Name</td>
         <td class="beta">-</td>
      </tr>
      <tr>
         <td class="delta" width="15%">Factor Type</td>
         <td class="beta">-</td>
      </tr>
      <tr>
         <td class="delta" width="15%">Factor Type Term Source REF</td>
         <td class="beta">-</td>
      </tr> 
      
      <tr>
         <td class="delta" width="15%">Study Assays</td>
         <!--<td class="delta"></td>-->
      </tr>
      
      <tr>
         <td class="delta" width="15%">Measurements/Endpoints Name</td>
	  <xsl:for-each select="//LIBRARY_SOURCE[generate-id(.)=generate-id(key('libsrclookupid',.)[1])]">
	      <td class="beta">
	       <xsl:value-of select="."/>
	       </td>
	   </xsl:for-each>
      </tr>
      <tr>
         <td class="delta" width="15%">Measurements/Endpoints Term Source REF</td>
         <td class="beta">ENA:0000019</td>
         <td class="beta">ENA:0000020</td>
      </tr>
      <tr>
         <td class="delta" width="15%">Technology type</td>
	  <xsl:for-each select="//LIBRARY_STRATEGY[generate-id(.)=generate-id(key('libstratlookupid',.)[1])]">
	      <td class="beta">
	       <xsl:value-of select="."/>
	       </td>
	   </xsl:for-each>      </tr>   
      <tr>
         <td class="delta" width="15%">Technology type Term Source REF</td>
         <td class="beta">ENA:0000044</td>
         <td class="beta">ENA:0000054</td> 
      </tr>        
      <tr>
         <td class="delta" width="15%">Assay File Names</td>
         <td class="beta">

         </td>
         <td class="beta">
             
         </td>
      </tr>
      
      <tr>
         <td class="delta" width="15%">Study Protocols</td>
         <!--<td class="delta"></td>-->
      </tr>
      <tr>
         <td class="delta" width="15%">Protocol Name</td>
         <td class="beta">

         </td>
      </tr>
      <tr>
         <td class="delta" width="15%">Protocol type</td>
         <td class="beta">library construction</td>
      </tr>   
      <tr>
         <td class="delta" width="15%">Protocol type Term Source REF</td>
         <td class="beta">

         </td>
      </tr>        
      <tr>
         <td class="delta" valign="top">Protocol Description</td>


	  <xsl:for-each select="//LIBRARY_CONSTRUCTION_PROTOCOL[generate-id(.)=generate-id(key('expprotlookupid',.)[1])]">
	      <td class="beta" width="20%" align="justify" valign="top">
	       <xsl:value-of select="."/>
	       </td>
	   </xsl:for-each>
     
     </tr>
  
      <tr>
         <td class="delta">Study Contacts</td>
         <!--<td class="delta"></td>-->
      </tr>


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
 </table>
</xsl:template>

<!--
<xsl:template match="SUBMISSION" mode="submissiondate">
    <xsl:value-of select="./@submission_date"/>
</xsl:template>
-->

<xsl:template match="SAMPLE_SET">

<!--<h2><font color="#003366" face="Arial" size="2pt">    Study Tab:</font></h2> -->
 <table width="100%" font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
  <tr bgcolor="#003366">
   <th class="delta">Source Name</th>
  <th class="delta">Comment[Common Name]</th>
   <th class="delta">Characteristics[Taxonomic ID]</th>
   <th class="delta">Characteristics[Description]</th>
  <xsl:for-each select="//TAG[generate-id(.)=generate-id(key('sampletaglookupid',.)[1])]">
      <th class="delta">
       <xsl:text>Characteristics[</xsl:text>
       <xsl:value-of select="."/>
       <xsl:text>]</xsl:text>
       </th>
   </xsl:for-each>
   </tr>
    <xsl:apply-templates select="SAMPLE"/>
   </table>
</xsl:template> 
   
   


<xsl:template match="SAMPLE">

  <!--  <xsl:variable name="color">
     <xsl:choose>
      <xsl:when test="position() mod 2= 0">#B0C4DE</xsl:when>
      <xsl:otherwise>#CCCCCC</xsl:otherwise>
     </xsl:choose>
    </xsl:variable>
    
    <tr bgcolor="{$color}">  --><tr>

    <xsl:choose>
     <xsl:when test="@alias">
      <td class="beta">
       <xsl:value-of select="@alias"/>
      </td>
     </xsl:when>
     <xsl:otherwise>
      <td class="beta">-</td>
     </xsl:otherwise>
    </xsl:choose>

        <xsl:choose>
          <xsl:when test="./SAMPLE_NAME/COMMON_NAME">
            <td class="beta"><xsl:value-of select="./SAMPLE_NAME/COMMON_NAME/."/>
            </td>
         </xsl:when>
         <xsl:otherwise>
          <td class="beta">-</td>
         </xsl:otherwise>
        </xsl:choose>
         <xsl:choose>
         <xsl:when test="./SAMPLE_NAME/TAXON_ID">
            <!-- <xsl:param name="url" select="./SAMPLE_NAME/TAXON_ID/."></xsl:param> -->
            <td class="beta">
               <!-- <a href="http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id={$url}" target="_blank">-->
                    <xsl:value-of select="./SAMPLE_NAME/TAXON_ID/."/>
               <!-- </a> -->
            </td>
         </xsl:when>
         <xsl:otherwise>
          <td class="beta">-</td>
         </xsl:otherwise>
        </xsl:choose>


    <xsl:choose>
     <xsl:when test="./DESCRIPTION">
    	<td  class="beta" align="justify"><xsl:value-of select="./DESCRIPTION/."/>
    	</td>
     </xsl:when>
     <xsl:otherwise>
      <td class="beta">-</td>
     </xsl:otherwise>
    </xsl:choose>
    
    <xsl:choose>
     <xsl:when test="./SAMPLE_ATTRIBUTES">

       <xsl:for-each select="SAMPLE">
        <xsl:variable name="tags" select="key('TAGS-by-SAMPLE', .)" />
         <tr>
            <xsl:for-each select="TAGS-by-SAMPLE">
             <td class="beta">
                <xsl:value-of select="$tags[/TAG = current()]" />
             </td>
            </xsl:for-each>
        </tr>
       </xsl:for-each>
       <xsl:for-each select="./SAMPLE_ATTRIBUTES/SAMPLE_ATTRIBUTE/VALUE">
	     <td class="beta">
       	  
           <xsl:value-of select="."/>
          
         </td>
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
      <td class="beta">-</td>
     </xsl:otherwise>
    </xsl:choose>
    
  </tr>
 </xsl:template>
  


<xsl:template match="RUN_SET">

<!--<h2><font color="#003366" face="Arial" size="2pt">Assay Tab:</font></h2>-->

 <table width="100%" font-family="sans-serif" border="0" cellspacing="1" cellpadding="10">
  <tr bgcolor="#003366">
   <th class="delta">Sample Name</th>

<!--   <th><font color="#CCCCCC" face="Arial" size="2pt"><i>Assay Endpoint</i></font></th>   -->

   <td class="delta" width="25">Protocol REF</td>
   <th class="delta">Parameter[strategy]</th>
   <th class="delta">Parameter[source]</th>
   <th class="delta">Parameter[selection]</th>
   <th class="delta">Parameter[layout]</th>

   <th class="delta">Assay Name</th>
   <th class="delta">Protocol REF</th>
   <th class="delta">Parameter[read information {index;type;class;base coord}]</th>
   <th class="delta">Parameter[Instrument]</th>
   <th class="delta">Performer</th>
   <th class="delta">Date</th>
 <!--
  <xsl:for-each select="//TAG[generate-id(.)=generate-id(key('runtaglookupid',.)[1])]">
      <th><font color="#CCCCCC" face="Arial" size="2pt">
       <xsl:text>Parameter[</xsl:text>
       <xsl:value-of select="."/>
       <xsl:text>]</xsl:text>
       </font></th>
   </xsl:for-each>
-->
   <th class="delta">Run Name</th>
   <th class="delta">Raw Data File</th>
   <th class="delta">Comment[File checksum method]</th>
   <th class="delta">Comment[File checksum]</th>

   </tr>
   
    <xsl:apply-templates select="RUN"/> 
   
   </table>
</xsl:template>


<xsl:template match="RUN">

    <!--<xsl:variable name="color">
     <xsl:choose>
      <xsl:when test="position() mod 2= 0">#B0C4DE</xsl:when>
      <xsl:otherwise>#CCCCCC</xsl:otherwise>
     </xsl:choose>
    </xsl:variable> -->
    
    <!--<tr bgcolor="{$color}">-->
    <tr>
    <xsl:choose>
     <xsl:when test="child::EXPERIMENT_REF/@refname">
       <td class="beta">
       <xsl:value-of select="key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/SAMPLE_DESCRIPTOR/@refname"/>
      </td>
     </xsl:when>
     <xsl:otherwise>
      <td class="beta">-</td>
     </xsl:otherwise>
    </xsl:choose>
    


<!--    <xsl:choose>
     <xsl:when test="child::EXPERIMENT_REF/@refname">
    	<td><font face="Arial" size="2pt"><xsl:value-of select="key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_SOURCE"/></font>
    	</td>
     </xsl:when>
     <xsl:otherwise>
      <td><font face="Arial" size="2pt">-</td>	
     </xsl:otherwise>
    </xsl:choose> -->


    
    <xsl:choose>
     <xsl:when test="child::EXPERIMENT_REF/@refname">
    	<td  class="beta" width="25" ><xsl:value-of select="key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_CONSTRUCTION_PROTOCOL"/>
    	    	</td>
          <td  class="beta"><xsl:value-of select="key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_STRATEGY/."/>
    	</td>
          <td  class="beta"><xsl:value-of select="key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_SOURCE/."/>
    	</td>
          <td class="beta"><xsl:value-of select="key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_SELECTION/."/>
    	</td>
          <td class="beta"><xsl:value-of select="key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_LAYOUT"/>
    	</td>
       <td class="beta">
          <xsl:value-of select="child::EXPERIMENT_REF/@refname"/>
      </td>

     </xsl:when>
     <xsl:otherwise>
      <td class="beta">-</td>
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
         <td class="beta">
          <xsl:text>Sequencing Protocol</xsl:text>
         </td>
        <td class="beta">
        <xsl:for-each select="key('exptlookupid',child::EXPERIMENT_REF/@refname)/DESIGN/SPOT_DESCRIPTOR/SPOT_DECODE_SPEC/READ_SPEC">

           <xsl:value-of select="child::READ_INDEX/."/>;
           <xsl:value-of select="child::READ_CLASS/."/>;
           <xsl:value-of select="child::READ_TYPE/."/>;
           <xsl:value-of select="child::BASE_COORD/."/>|

          </xsl:for-each>
        </td>
       </xsl:when>
        <xsl:otherwise>
            <td class="beta">-</td>
        </xsl:otherwise>
   </xsl:choose>

    <xsl:choose>
     <xsl:when test="@instrument_model">
    	<td class="beta"><xsl:value-of select="@instrument_model"/>
    	</td>
     </xsl:when>
     <xsl:otherwise>
      <td class="beta">-</td>
     </xsl:otherwise>
    </xsl:choose>

    <xsl:choose>
     <xsl:when test="@run_center">
    	<td class="beta"><xsl:value-of select="@run_center"/>
	</td>
     </xsl:when>
     <xsl:otherwise>
      <td class="beta">-</td>
     </xsl:otherwise>
    </xsl:choose>
    
    <xsl:choose>
     <xsl:when test="@run_date">
    	<td class="beta"><xsl:value-of select="@run_date"/>
    	</td>
     </xsl:when>
     <xsl:otherwise>
      <td class="beta">-</td>
     </xsl:otherwise>
    </xsl:choose>

    <xsl:choose>
     <xsl:when test="@alias">
      <td class="beta">
       <xsl:value-of select="@alias"/>
      </td>
     </xsl:when>
     <xsl:otherwise>
      <td class="beta">-</td>
     </xsl:otherwise>
    </xsl:choose>       

<!--    <xsl:choose>
     <xsl:when test="@run_file">
    	<td><font face="Arial" size="2pt"><xsl:value-of select="@run_file"/></font>
    	</td>
     </xsl:when>
     <xsl:otherwise>
      <td><font face="Arial" size="2pt">-</td>	
     </xsl:otherwise>
    </xsl:choose>-->
    
    <xsl:choose>
         <xsl:when test="child::DATA_BLOCK/FILES/FILE/@filename">
        	<td class="beta"><xsl:value-of select="child::DATA_BLOCK/FILES/FILE/@filename"/>
        	</td>
        	<td class="beta"><xsl:value-of select="key('filelookupid',child::DATA_BLOCK/FILES/FILE/@filename)/@checksum_method"/>
        	</td>
        	<td class="beta"><xsl:value-of select="key('filelookupid',child::DATA_BLOCK/FILES/FILE/@filename)/@checksum"/>
        	</td>

         </xsl:when>
         <xsl:otherwise>
          <td class="beta">-</td>	
         </xsl:otherwise>
    </xsl:choose>
    
  </tr>
 </xsl:template>
  




</xsl:stylesheet>