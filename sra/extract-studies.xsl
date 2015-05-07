<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
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
    <xsl:template name="process-lib-strategies-sources">
        <xsl:param name="acc-number" required="yes"/>
        <xsl:variable name="experiment-ids" select="document(concat('http://www.ebi.ac.uk/ena/data/view/', $acc-number, '&amp;display=xml'))/ROOT/SUBMISSION/SUBMISSION_LINKS/SUBMISSION_LINK/XREF_LINK/DB[contains(.,'NA-EXPERIMENT')]/following-sibling::ID"/>
        <studies>
            <xsl:for-each select="tokenize($experiment-ids, ',')">
                <xsl:variable name="experiment-document-lib-desc" select="document(concat('http://www.ebi.ac.uk/ena/data/view/', ., '&amp;display=xml'))/ROOT"/>
                <xsl:apply-templates select="$experiment-document-lib-desc/EXPERIMENT" mode="get-studies">
                    <xsl:with-param name="id" select="."/>
                </xsl:apply-templates>                
            </xsl:for-each>
        </studies>
    </xsl:template>
    
    <xsl:template match="EXPERIMENT" mode="get-studies">
        <xsl:param name="id" required="yes"/>
        <study acc-number="{ $id }" accession="{ @accession }" library-strategy="{ DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_STRATEGY }" library-source="{ DESIGN/LIBRARY_DESCRIPTOR/LIBRARY_SOURCE }"/>
    </xsl:template>
    
</xsl:stylesheet>
