<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY dcterms "http://purl.org/dc/terms/">
  <!ENTITY mesh "http://nlm.nih.gov#MeSH:">
  <!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#">
  <!ENTITY skos "http://www.w3.org/2004/02/skos/core#">
]>


<xsl:stylesheet version="2.0"
                xmlns:f="http://nlm.nih.gov/ns/f"
                xmlns:dcterms='&dcterms;'
                xmlns:mesh="&mesh;"
                xmlns:rdfs="&rdfs;"
                xmlns:rdf="&rdf;"
                xmlns:skos="&skos;"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="f">

  <xsl:import href="common.xsl"/>
  <xsl:output method="text"/>


  <xsl:template match="/">

    <xsl:for-each select="DescriptorRecordSet/DescriptorRecord">

      <!--
        Transformation rule: dcterms:identifier
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <output>*descriptor_uri* dcterms:identifier *descriptor_id*</output>
          <desc>This relation states that a descriptor record has a unique identifier.</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <uri prefix='&mesh;'>
            <xsl:value-of select="DescriptorUI"/>
          </uri>
          <uri prefix='&dcterms;'>identifier</uri>
          <literal>
            <xsl:value-of select="DescriptorUI"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>

      <!--
        Transformation rule: rdf:type
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <output>*descriptor_uri* rdf:type mesh:Descriptor</output>
          <desc>This relation states that a Subject node used to identify a Descriptor record 
            is of type "Descriptor".</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <uri prefix='&mesh;'>
            <xsl:value-of select="DescriptorUI"/>
          </uri>
          <uri prefix='&rdf;'>type</uri>
          <uri prefix='&mesh;'>Descriptor</uri>
        </xsl:with-param>
      </xsl:call-template>

      <!-- 
        Transformation rule: descriptorClass
      -->
      <xsl:call-template name="triple">
        <xsl:with-param name="doc">
          <output>*descriptor_uri* mesh:descriptorClass *descriptor_class*</output>
          <desc>This relation states that a descriptor record has a descriptor class to which 
            it belongs to.</desc>
        </xsl:with-param>
        <xsl:with-param name="spec">
          <uri prefix='&mesh;'>
            <xsl:value-of select="DescriptorUI"/>
          </uri>
          <uri prefix="&mesh;">descriptorClass</uri>
          <literal>
            <xsl:value-of select="@DescriptorClass"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>

      <!--
        Transformation rule: rdfs:label
      -->      
      <xsl:call-template name="triple">
        <xsl:with-param name="doc">
          <output>*descriptor_uri* rdfs:label *descriptor_name*</output>
          <desc>This relation states that a descriptor record has a name.</desc>
        </xsl:with-param>
        <xsl:with-param name="spec">
          <uri prefix='&mesh;'>
            <xsl:value-of select="DescriptorUI"/>
          </uri>
          <uri prefix='&rdfs;'>label</uri>
          <literal>
            <xsl:value-of select="DescriptorName/String"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>
            
      <xsl:for-each select="ConceptList/Concept">
        <!-- $concept_uri is used in many calls to the `triple` template below -->
        <xsl:variable name='concept_uri'>
          <uri prefix='&mesh;'>
            <xsl:value-of select="ConceptUI"/>
          </uri>
        </xsl:variable>

        <!--
          Transformation rule: concept
        -->
        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <output>*descriptor_uri* mesh:concept *concept_uri*</output>
            <desc>This relation states that a descriptor record has a concept.</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <uri prefix='&mesh;'>
              <xsl:value-of select="../../DescriptorUI"/>
            </uri>
            <uri prefix='&mesh;'>concept</uri>
            <xsl:copy-of select="$concept_uri"/>
          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule: rdf:type
        -->
        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <output>*concept_uri* rdf:type mesh:Concept</output>
            <desc>This relation states that a Subject node used to identify a concept 
              is of type "Concept".</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select="$concept_uri"/>
            <uri prefix='&rdf;'>type</uri>
            <uri prefix='&mesh;'>Concept</uri>
          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule: isPreferredConcept
        -->
        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <output>*concept_uri* mesh:isPreferredConcept Y/N</output>
            <desc>This relation states that yes, "Y", a concept is the preferred concept or 
              no, "N", the concept is not the preferred concept.</desc>
            <fixme>Wouldn't it be better to define a PreferredConcept class, and use that as
              this concept's rdf:type, instead of have a triple with a literal "Y" or "N"
              value?</fixme>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select="$concept_uri"/>
            <uri prefix='&mesh;'>isPreferredConcept</uri>
            <literal>
              <xsl:value-of select="@PreferredConceptYN"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
        
        <!--
          Transformation rule: rdfs:label
        -->
        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <output>*concept_uri* rdfs:label *concept_name*</output>
            <desc>This relation states that a concept has a concept name.</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select="$concept_uri"/>
            <uri prefix='&rdfs;'>label</uri>
            <literal>
              <xsl:value-of select="ConceptName/String"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule: dcterms:identifier
        -->
        <xsl:call-template name="triple">
          <xsl:with-param name="doc">
            <output>*concept_uri* dcterms:identifier *concept_id*</output>
            <desc>This relation states that a concept has a unique identifier.</desc>
          </xsl:with-param>
          <xsl:with-param name="spec">
            <xsl:copy-of select="$concept_uri"/>
            <uri prefix='&dcterms;'>identifier</uri>
            <literal>
              <xsl:value-of select="ConceptUI"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>

        <xsl:if test="CASN1Name">
          <!--
            Transformation rule: CASN1_label
          -->    
          <xsl:call-template name="triple">
            <xsl:with-param name="doc">
              <output>*concept_uri* mesh:CASN1_label *CASN1Name*</output>
              <desc>This relation states that a concept has a Chemical Abstracts Type N1 Name.</desc>
              <fixme>Do we want to parse the CASN1Name (e.g. for other purposes)?</fixme>
            </xsl:with-param>
            <xsl:with-param name="spec">
              <xsl:copy-of select="$concept_uri"/>
              <uri prefix='&mesh;'>CASN1_label</uri>
              <literal>
                <xsl:value-of select="CASN1Name"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>

        <xsl:if test="RegistryNumber">
          <!--
            Transformation rule: registryNumber
          -->
          <xsl:call-template name="triple">
            <xsl:with-param name="doc">
              <output>*concept_uri* mesh:registryNumber *registry_number*</output>
              <desc>This relation states that a concept has a registry number.</desc>
            </xsl:with-param>
            <xsl:with-param name="spec">
              <xsl:copy-of select="$concept_uri"/>
              <uri prefix='&mesh;'>registryNumber</uri>
              <literal>
                <xsl:value-of select="RegistryNumber"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>

        <xsl:if test="ScopeNote">
          <!--
            Transformation rule: skos:scopeNote
          -->
          <xsl:call-template name="triple">
            <xsl:with-param name="doc">
              <output>*concept_uri* skos:scopeNote *scope_note*</output>
              <desc>This relation states tht a concept has a scope note.</desc>
            </xsl:with-param>
            <xsl:with-param name="spec">
              <xsl:copy-of select="$concept_uri"/>
              <uri prefix='&skos;'>scopeNote</uri>
              <literal>
                <xsl:value-of select="ScopeNote"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>

        <xsl:if test="SemanticTypeList">
          <xsl:for-each select="SemanticTypeList/SemanticType">
            <xsl:variable name='semantic_type_uri'>
              <uri prefix='&mesh;'>
                <xsl:value-of select="SemanticTypeUI"/>
              </uri>
            </xsl:variable>

            <!--
              Transformation rule: semanticType
            -->            
            <xsl:call-template name="triple">
              <xsl:with-param name="doc">
                <output>*concept_uri* mesh:semanticType *semantic_type_uri*</output>
                <desc>This relation states that a concept has a semantic type.</desc>
                <fixme></fixme>
              </xsl:with-param>
              <xsl:with-param name="spec">
                <xsl:copy-of select="$concept_uri"/>
                <uri prefix='&mesh;'>semanticType</uri>
                <xsl:copy-of select="$semantic_type_uri"/>
              </xsl:with-param>
            </xsl:call-template>

            <!--
              Transformation rule: rdf:type
            -->
            <xsl:call-template name="triple">
              <xsl:with-param name="doc">
                <output>*semantic_type_uri* rdf:type mesh:SemanticType</output>
                <desc>Specifies the class of the semantic type resource.</desc>
              </xsl:with-param>
              <xsl:with-param name="spec">
                <xsl:copy-of select="$semantic_type_uri"/>
                <uri prefix='&rdf;'>type</uri>
                <uri prefix='&mesh;'>SemanticType</uri>
              </xsl:with-param>
            </xsl:call-template>
 
            <!--
              Transformation rule: rdfs:label
            -->
            <xsl:call-template name="triple">
              <xsl:with-param name="doc">
                <output>*semantic_type_uri* rdfs:label *semantic_type_name*</output>
                <desc>This rule states the a semantic type unique identifier has a semantic type name.</desc>
                <fixme>I'm not sure if this relation is correct. But we've created this 
                  type of relation for the concepts of a descriptor. We should check this (for e.g.,
                  with a MeSH expert or by a literature search).</fixme>
              </xsl:with-param>
              <xsl:with-param name="spec">
                <xsl:copy-of select="$semantic_type_uri"/>
                <uri prefix='&rdfs;'>label</uri>
                <literal>
                  <xsl:value-of select="SemanticTypeName"/>
                </literal>
              </xsl:with-param>
            </xsl:call-template>

            <!--
              Transformation rule: dcterms:identifier
            -->
            <xsl:call-template name="triple">
              <xsl:with-param name="doc">
                <output>*semantic_type_uri* dcterms:identifier *semantic_type_id*</output>
                <desc>This rule states that a semantic type has a unique identifier.</desc>
              </xsl:with-param>
              <xsl:with-param name="spec">
                <xsl:copy-of select="$semantic_type_uri"/>
                <uri prefix='&dcterms;'>identifier</uri>
                <literal>
                  <xsl:value-of select="SemanticTypeUI"/>
                </literal>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:if>

        <xsl:if test="RelatedRegistryNumberList">
          <xsl:for-each select="RelatedRegistryNumberList/RelatedRegistryNumber">
            <!--
              Transformation rule: relatedRegistryNumber
            -->
            <xsl:call-template name="triple">
              <xsl:with-param name="doc">
                <output>*concept_uri mesh:relatedRegistryNumber *related_registry_number*</output>
                <desc>This relation states that a concept has a related registry number.</desc>
                <fixme>Maybe it would be good to reduce this value to only a number. But 
                  I'm not sure. Need to check with a MeSH expert to see how important is the text
                  after the number.</fixme>
              </xsl:with-param>
              <xsl:with-param name="spec">
                <xsl:copy-of select="$concept_uri"/>
                <uri prefix='&mesh;'>relatedRegistryNumber</uri>
                <literal>
                  <xsl:value-of select="."/>
                </literal>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:if>

        <xsl:if test="ConceptRelationList">
          <xsl:for-each select="ConceptRelationList/ConceptRelation">
            <xsl:variable name='blank_node'>
              <named>
                <xsl:text>_:blank_set1_</xsl:text>
                <xsl:value-of select="../../ConceptUI"/>
                <xsl:text>_</xsl:text>
                <xsl:value-of select="position()"/>
              </named>
            </xsl:variable>

            <xsl:call-template name="triple">
              <xsl:with-param name="doc">
                <output></output>
                <desc></desc>
                <fixme></fixme>
              </xsl:with-param>
              <xsl:with-param name="spec">
                <xsl:copy-of select="$concept_uri"/>
                <uri prefix='&mesh;'>conceptRelation</uri>
                <xsl:copy-of select="$blank_node"/>
              </xsl:with-param>
            </xsl:call-template>
            
            <xsl:call-template name="triple">
              <xsl:with-param name="doc">
                <output></output>
                <desc></desc>
                <fixme></fixme>
              </xsl:with-param>
              <xsl:with-param name="spec">
                <xsl:copy-of select="$blank_node"/>
                <uri prefix='&rdf;'>type</uri>
                <uri prefix='&mesh;'>ConceptRelation</uri>
              </xsl:with-param>
            </xsl:call-template>            
            
            <xsl:if test="@RelationName">
              <xsl:variable name='skos_relation'>
                <xsl:choose>
                  <xsl:when test="@RelationName = 'BRD'">
                    <xsl:text>broader</xsl:text>
                  </xsl:when>
                  <xsl:when test="@RelationName = 'NRW'">
                    <xsl:text>narrower</xsl:text>
                  </xsl:when>
                  <xsl:when test="@RelationName = 'REL'">
                    <xsl:text>related</xsl:text>
                  </xsl:when>
                </xsl:choose>
              </xsl:variable>
              <xsl:call-template name="triple">
                <xsl:with-param name="doc">
                  <output></output>
                  <desc></desc>
                  <fixme></fixme>
                </xsl:with-param>
                <xsl:with-param name="spec">
                  <xsl:copy-of select="$blank_node"/>
                  <uri prefix='&mesh;'>relation</uri>
                  <uri prefix='&skos;'>
                    <xsl:value-of select="$skos_relation"/>
                  </uri>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:if>

            <xsl:call-template name="triple">
              <xsl:with-param name="doc">
                <output></output>
                <desc></desc>
              </xsl:with-param>
              <xsl:with-param name="spec">
                <xsl:copy-of select="$blank_node"/>
                <uri prefix='&mesh;'>concept1</uri>
                <uri prefix='&mesh;'>
                  <xsl:value-of select="Concept1UI"/>
                </uri>
              </xsl:with-param>
            </xsl:call-template>
            
            <xsl:call-template name="triple">
              <xsl:with-param name="doc">
                <output></output>
                <desc></desc>
                <fixme></fixme>
              </xsl:with-param>
              <xsl:with-param name="spec">
                <xsl:copy-of select="$blank_node"/>
                <uri prefix='&mesh;'>concept2</uri>
                <uri prefix='&mesh;'>
                  <xsl:value-of select="Concept2UI"/>
                </uri>
              </xsl:with-param>
            </xsl:call-template>
            
            <!-- added by rw -->
            <xsl:if test="RelationAttribute">
              <xsl:call-template name="triple">
                <xsl:with-param name="doc">
                  <output></output>
                  <desc></desc>
                  <fixme></fixme>
                </xsl:with-param>
                <xsl:with-param name="spec">
                  <xsl:copy-of select="$blank_node"/>
                  <uri prefix='&mesh;'>relationAttribute</uri>
                  <literal>
                    <xsl:value-of select="RelationAttribute"/>
                  </literal>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>

        <xsl:for-each select="TermList/Term">
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <output>*concept_uri* mesh:term *term_uri*</output>
              <desc>This relation states that a concept has a term.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$concept_uri"/>
              <uri prefix='&mesh;'>term</uri>
              <uri prefix='&mesh;'>
                <xsl:value-of select="TermUI"/>
              </uri>
            </xsl:with-param>
          </xsl:call-template>
          
          
          <!--
            Transformation rule: rdf:type
            ==============================
            Output: <term_uri> rdf:type <Term> .
            ========================================
            Additional: A concept has at least one term associated with it.
          -->
          
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&rdf;type&gt; </xsl:text>
          <xsl:text>&lt;&mesh;Term&gt; .&#10;</xsl:text>
          
          <!--
            Transformation rule: dcterms:identifier
            =======================================
            Output: <term_uri> dcterms:identifier "termUI" .
            ==================================================
            Additional: This relation states that a term has a term unique identifier.
            ============================================================================
            Need to address: N/A.
          -->
          
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&dcterms;identifier&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>" .&#10;</xsl:text>
          
          <xsl:if test="@IsPermutedTermYN = 'N'">
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="TermUI"/>
            <xsl:text>&gt; </xsl:text>
            <xsl:text>&lt;&rdfs;label&gt; </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="String"/>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:if>
          
          <!--
            Transformation rule: termData
            =================================================================
            Output: <term_uri> termData _:blankTermUI_termNumber .
            ==========================================================
            Addtional: This relation states that a term has data associated with it. A blank node 
            stores the term data.
            ======================================================================================
            Need to address: This relation was created in order to stick with the XML representation of MeSH.
          -->
          
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;termData&gt; </xsl:text>
          <xsl:text>_:blank</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="position()"/>
          <xsl:text> .&#10;</xsl:text>
          
          <!--
            Transformation rule/Relation: rdf:type
            =======================================
            Output: _:blankTermUI_termNumber rdf:type <TermData> .
            =======================================================
            Description: This relation states that a Subject node used to identify term data is 
            of type "TermData".
            ====================================================================================
            Need to address: N/A.
          -->
          
          <xsl:text>_:blank</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="position()"/>
          <xsl:text> </xsl:text>
          <xsl:text>&lt;&rdf;type&gt; </xsl:text>
          <xsl:text>&lt;&mesh;TermData&gt; .&#10;</xsl:text>
          
          <!--
            Transformation rule: isConceptPreferredTerm
            ============================================
            Output: _:blankTermUI_termNo isConceptPreferredTerm "Y/N" .
            ============================================================
            Additional: This relation states that a term can be a concept-preferred-term. But it
            does so indirectly because the isConceptPreferredTerm relation is with a blank node.
            ======================================================================================
            Need to address: N/A.
          -->
          
          <xsl:text>_:blank</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="position()"/>
          <xsl:text> </xsl:text>
          <xsl:text>&lt;&mesh;isConceptPreferredTerm&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@ConceptPreferredTermYN"/>
          <xsl:text>" .&#10;</xsl:text>
          
          <!--
            Transformation rule: isPermutedTerm
            =====================================
            Output: _:blankTermUI_termNo isPermutedTerm "Y/N" .
            =====================================================
            Additional: This relation states that a term can be a permuted term. But it does so 
            indirectly because the isPermutedTerm relation is with a blank node.
            ====================================================================================
            Need to address: N/A.
          -->
          
          <xsl:text>_:blank</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="position()"/>
          <xsl:text> </xsl:text>
          <xsl:text>&lt;&mesh;isPermutedTerm&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@IsPermutedTermYN"/>
          <xsl:text>" .&#10;</xsl:text>
          
          <!--
            Transformation rule: lexicalTag
            ===================================
            Output: _:blankTermUI_termNo lexicalTag "lexicalTag" .
            ==========================================================
            Additional: This relation states that a term has a lexical tag. But it does so 
            indirectly becuase the hasLexicalTag relation is with a blank node.
            ==============================================================================
            Need to address: N/A.
          -->
          
          <xsl:text>_:blank</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="position()"/>
          <xsl:text> </xsl:text>
          <xsl:text>&lt;&mesh;lexicalTag&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@LexicalTag"/>
          <xsl:text>" .&#10;</xsl:text>
          
          <!--
            Transformation rule: printFlag
            ===================================
            Output: _:blankTermUI_termNo printFlag "Y/N" .
            ==================================================
            Additional: This relation states that a term has a print flag. But it does this 
            indirectly because the hasPrintFlag relation is with a blank node.
            ======================================================================================
            Need to address: N/A.
          -->
          
          <xsl:text>_:blank</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="position()"/>
          <xsl:text> </xsl:text>
          <xsl:text>&lt;&mesh;printFlag&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@PrintFlagYN"/>
          <xsl:text>" .&#10;</xsl:text>
          
          <!--
            Transformation rule: isRecordPreferredTerm
            ===========================================
            Output: _:blankTermUI_termNo isRecordPreferredTerm "Y/N" .
            ============================================================
            Additional: This relation states that a term can be a record preferred term. But it does 
            this indirectly because the relation is with a blank node.
            ========================================================================================
            Need to address: N/A.
          -->
          
          <xsl:text>_:blank</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="position()"/>
          <xsl:text> </xsl:text>
          <xsl:text>&lt;&mesh;isRecordPreferredTerm&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="@RecordPreferredTermYN"/>
          <xsl:text>" .&#10;</xsl:text>
          
          <!--
            Transformation rule: dcterms:identifier
            ========================================
            Output: _:blankTermUI_termNo dcterms:identifier "termUI" .
            ===========================================================
            Additional: This relation states that a term has a term unique identifier. However, it 
            does so indirectly because the relation is with a blank node.
            ======================================================================================
            Additional: N/A.
          -->
          
          <xsl:text>_:blank</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="position()"/>
          <xsl:text> </xsl:text>
          <xsl:text>&lt;&dcterms;identifier&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>" .&#10;</xsl:text>
          
          <!--
            Transformation rule: rdfs:label
            =================================
            Output: _:blankTermUI_termNo rdfs:label "termName" .
            ======================================================
            Additional: This relation states that a term has a term name. But it does so 
            indirectly because the relation is with a blank node.
            ====================================================================================
            Need to address: N/A.
          -->
          
          <xsl:text>_:blank</xsl:text>
          <xsl:value-of select="TermUI"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="position()"/>
          <xsl:text> </xsl:text>
          <xsl:text>&lt;&rdfs;label&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="String"/>
          <xsl:text>" .&#10;</xsl:text>
          
          <!--
            Transformation rule: dateCreated
            ======================================
            Output: _:blankTermUI_termNo dateCreated "dateCreated" .
            ============================================================
            Additional: This relation states that a term can have a date on which it was created.
            ======================================================================================
            Need to address: N/A.
          -->
          
          <xsl:if test="DateCreated">
            <xsl:text>_:blank</xsl:text>
            <xsl:value-of select="TermUI"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="position()"/>
            <xsl:text> </xsl:text>
            <xsl:text>&lt;&mesh;dateCreated&gt; </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="string-join((DateCreated/Year,DateCreated/Month,DateCreated/Day),'-')"/>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:if>
          
          <!--
            Transformation rule: abbreviation
            =========================================
            Output: _:blankTermUI_termNo abbreviation "termAbbreviation" .
            =============================================================
            Additional: This relation states that a term has a term abbreviation.
            =======================================================================
            Need to address: N/A.
          -->
          
          <xsl:if test="Abbreviation">
            <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="position()"/>
            <xsl:text> </xsl:text>
            <xsl:text>&lt;&mesh;abbreviation> </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="Abbreviation"/>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:if>
          
          <!--
            Transformation rule: sortVersion
            ====================================
            Output: _:blankTermUI_termNo sortVersion "sortVersion" .
            ===================================================
            Additional: This rule states that a term has a sort version.
            ==============================================================
            Need to address: N/A.
          -->
          
          <xsl:if test="SortVersion">
            <xsl:text>_:blank</xsl:text><xsl:value-of select="TermUI"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="position()"/>
            <xsl:text> </xsl:text>
            <xsl:text>&lt;&mesh;sortVersion> </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="SortVersion"/>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:if>
          
          <!--
            Transformation rule: entryVersion
            =======================================
            Output: _:blankTermUI_termNo entryVersion "entryVersion" .
            =====================================================
            Additional: This rule states that a term has an entry version.
            =================================================================
            Need to address: N/A.
          -->
          
          <xsl:if test="EntryVersion">
            <xsl:text>_:blank</xsl:text>
            <xsl:value-of select="TermUI"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="position()"/>
            <xsl:text> </xsl:text>
            <xsl:text>&lt;&mesh;entryVersion> </xsl:text>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="EntryVersion"/>
            <xsl:text>" .&#10;</xsl:text>
          </xsl:if>
          
          <!--
            Transformation rule: thesaurusID
            =====================================
            Output: _:blankTermUI_termNo thesaurusID "thesaurusID" .
            ===================================================
            Additional: This relation states that a term has a thesaurus ID.
            ===================================================================
            Need to address: N/A.
          -->
          
          <xsl:if test="ThesaurusIDlist">
            <xsl:variable name="pos" select="position()"/>
            <xsl:for-each select="ThesaurusIDlist/ThesaurusID">
              <xsl:text>_:blank</xsl:text>
              <xsl:value-of select="../../TermUI"/>
              <xsl:text>_</xsl:text>
              <xsl:copy-of select="$pos"/>
              <xsl:text> </xsl:text>
              <xsl:text>&lt;&mesh;thesaurusID> </xsl:text>
              <xsl:value-of select='f:literal-str(.)'/>
              <xsl:text> .&#10;</xsl:text>
            </xsl:for-each>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each>


      <xsl:if test="EntryCombinationList">
        <xsl:for-each select="EntryCombinationList/EntryCombination">
          <!--
            Transformation rule: entryCombination
            =========================================
            Output: <desc_uri> entryCombination _:blankDescriptorUI_entryCombinationNumber .
            ====================================================================================
            Additional: This relation states that a descriptor record has a entry combination. The entry
            combination has an ECIN and an ECOUT (see below). 
            ============================================================================================
            Need to address: N/A
          -->
          
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="../../DescriptorUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;entryCombination&gt; </xsl:text>
          <xsl:text>_:blank</xsl:text>
          <xsl:value-of select="../../DescriptorUI"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="position()"/>
          <xsl:text> .&#10;</xsl:text>
          
          <!--
            Transformation rule/Relation: rdf:type
            ========================================
            Output: _:blankDescriptorUI_entryCombinationNumber	 rdf:type 	<EntryCombination> .
            =====================================================================================
            Description: This relation states that a Subject node used to identify an entry 
            combination is of type "EntryCombination".
            ==================================================================================
            Need to address: N/A.
          -->
          
          <xsl:text>_:blank</xsl:text>
          <xsl:value-of select="../../DescriptorUI"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="position()"/>
          <xsl:text> </xsl:text>
          <xsl:text>&lt;&rdf;type&gt; </xsl:text>
          <xsl:text>&lt;&mesh;EntryCombination&gt; .&#10;</xsl:text>
          <xsl:text>_:blank</xsl:text>
          <xsl:value-of select="../../DescriptorUI"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="position()"/>
          <xsl:text> </xsl:text>
          <xsl:text>&lt;&mesh;ECINDescriptor&gt; </xsl:text>
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="ECIN/DescriptorReferredTo/DescriptorUI"/>
          <xsl:text>&gt;</xsl:text>
          <xsl:text> .&#10;</xsl:text>
          <xsl:text>_:blank</xsl:text>
          <xsl:value-of select="../../DescriptorUI"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="position()"/>
          <xsl:text> </xsl:text>
          <xsl:text>&lt;&mesh;ECINQualifier&gt; </xsl:text>
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="ECIN/QualifierReferredTo/QualifierUI"/>
          <xsl:text>&gt;</xsl:text>
          <xsl:text> .&#10;</xsl:text>
          <xsl:text>_:blank</xsl:text>
          <xsl:value-of select="../../DescriptorUI"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="position()"/>
          <xsl:text> </xsl:text>
          <xsl:text>&lt;&mesh;ECOUTDescriptor&gt; </xsl:text>
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="ECOUT/DescriptorReferredTo/DescriptorUI"/>
          <xsl:text>&gt;</xsl:text>
          <xsl:text> .&#10;</xsl:text>
          
          <xsl:if test="ECOUT/QualifierReferredTo">
            <xsl:text>_:blank</xsl:text>
            <xsl:value-of select="../../DescriptorUI"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="position()"/>
            <xsl:text> </xsl:text>
            <xsl:text>&lt;&mesh;ECOUTQualifier&gt; </xsl:text>
            <xsl:text>&lt;&mesh;</xsl:text>
            <xsl:value-of select="ECOUT/QualifierReferredTo/QualifierUI"/>
            <xsl:text>&gt;</xsl:text>
            <xsl:text> .&#10;</xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:if>

      <xsl:if test="AllowableQualifiersList">

        <xsl:for-each select="AllowableQualifiersList/AllowableQualifier">

          <!--
            Transformation rule: allowableQualifier
            ===========================================
            Output: <desc_uri> allowableQualifier <qual_uri> .
            ======================================================
            Additional: This relation states that a descriptor record has an allowable qualifier.
            ======================================================================================
            Need to address: N/A.
          -->

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="../../DescriptorUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;allowableQualifier&gt; </xsl:text>
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="QualifierReferredTo/QualifierUI"/>
          <xsl:text>&gt;</xsl:text>
          <xsl:text> .&#10;</xsl:text>


          <!--
      	    Transformation rule: rdf:type
      	    =================================
      	    Output: <qual_uri> rdf:type <Qualifier> .
      	    =============================================================
      	    Additional: This relation states that a Subject node used to identify a Descriptor record is of type "Descritpor".
     	    -->

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="QualifierReferredTo/QualifierUI"/>
          <xsl:text>&gt;</xsl:text>
          <xsl:text> </xsl:text>
          <xsl:text>&lt;&rdf;type&gt; </xsl:text>
          <xsl:text>&lt;&mesh;Qualifier&gt; .&#10;</xsl:text>


          <!--
            Transformation rule: dcterms:identifier
            =========================================
            Output: <qual_uri> dcterms:identifier "qualUI" .
            =================================================
            Additional: This relation states that an allowable qualifier has a unique identifier.
            ======================================================================================
            Need to address: N/A.
          -->

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="QualifierReferredTo/QualifierUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&dcterms;identifier&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="QualifierReferredTo/QualifierUI"/>
          <xsl:text>" .&#10;</xsl:text>

          <!--
            Transformation rule: rdfs:label
            ======================================
            Output: <qual_uri> rdfs:label "qualName" .
            ===================================================
            Additional: This relation states that an allowable qualifier has a name.
            =========================================================================
            Need to address: N/A.
          -->

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="QualifierReferredTo/QualifierUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&rdfs;label&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="QualifierReferredTo/QualifierName/String"/>
          <xsl:text>" .&#10;</xsl:text>

          <!--
            Transformation rule: abbreviation
            ==============================================
            Output: <qual_uri> abbreviation "qualAbbrev" .
            ===================================================
            Additional: This relation states that an allowable qualifier has an abbreviation.
            ===================================================================================
            Need to address: N/A.
          -->

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="QualifierReferredTo/QualifierUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;abbreviation&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="Abbreviation"/>
          <xsl:text>" .&#10;</xsl:text>

        </xsl:for-each>

      </xsl:if>

      <xsl:if test="TreeNumberList">
        <xsl:for-each select="TreeNumberList/TreeNumber">

          <!-- 
            Transformation rule: treeNumber
            ===================================
            Output: <desc_uri> treeNumber "treeNumber"
            ==============================================
            Additional: Every MeSH descriptor record can have some integer number of tree numbers. These are presented as characters separated by perionds in the MeSH browser under the 
            "Tree Number" relation. I named this the hasTreeNumber relation in RDF.
          -->

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="../../DescriptorUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;treeNumber&gt; </xsl:text>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>" .&#10;</xsl:text>

        </xsl:for-each>
      </xsl:if>

      <!--
        Transformation rule: annotation
        ====================================
        Output: <desc_uri> annotation "annotation" .
        ================================================
        Additional: This rule states that a descriptor record has an annotation.
        =========================================================================
        Need to address: Every MeSH descriptor can have an annotation. This rule extracts that annotation and converts it into a string. But sometimes, if not always, the annotation will
        have a link to another descriptor. Hence, we might have to decipher a way to express this in our RDF conversion. This might require some NLP? For now however, the 
        annotation is simply converted to a string data type.
      -->

      <xsl:if test="Annotation">
        <!-- This if statement is necessary to ensure that the hasAnnotation relationship is 
          extracted ONLY when the Annotation element exists for a descriptor record. This if 
          statements checks to see if the element Annotation exists for a descriptor record. -->
        <!-- hasAnnotation -->
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;annotation> </xsl:text>
        
        <xsl:value-of select='f:literal-str(Annotation)'/>
        <xsl:text> .&#10;</xsl:text>
      </xsl:if>

      <!-- 
        Transformation rules: dateCreated, dateRevised, dateEstablished
        ================================================================
        Output: <desc_uri> dateCreated "dateCreated" ., <desc_uri> dateRevised "dateRevised" ., <desc_uri> dateEstablished "dateEstablished" .
        ========================================================================================================================================
        Additional: This relation states that a descriptor record has a date on which it was created, revised and established.
        ========================================================================================================================
        Need to address: Whether this date representation will be sufficient for us to compute on? We could also change it to the date-time format as provided by the dateTime
        XSLT 2.0 function.
      -->

      <xsl:text>&lt;&mesh;</xsl:text>
      <xsl:value-of select="DescriptorUI"/>
      <xsl:text>&gt; </xsl:text>
      <xsl:text>&lt;&mesh;dateCreated> </xsl:text>
      <xsl:text>"</xsl:text>
      <xsl:value-of
        select="xs:date(string-join((DateCreated/Year,DateCreated/Month,DateCreated/Day),'-'))"/>
      <xsl:text>" .&#10;</xsl:text>

      <xsl:if test="DateRevised">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;dateRevised> </xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of
          select="xs:date(string-join((DateRevised/Year,DateRevised/Month,DateRevised/Day),'-'))"/>
        <xsl:text>" .&#10;</xsl:text>
      </xsl:if>

      <xsl:if test="DateEstablished">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;dateEstablished> </xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of
          select="xs:date(string-join((DateEstablished/Year,DateEstablished/Month,DateEstablished/Day),'-'))"/>
        <xsl:text>" .&#10;</xsl:text>
      </xsl:if>

      <!--
        Tranformation rule: activeMeSHYear
        =======================================
        Output: <desc_uri> activeMeSHYear "year" .
        ==============================================
        Additional: This relation states that a descriptor record has an active MeSH year.
        ===================================================================================
        Need to address: N/A.
      -->
      <xsl:for-each select="ActiveMeSHYearList/Year">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="../../DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;activeMeSHYear> </xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>" .&#10;</xsl:text>
      </xsl:for-each>

      <!--
        Transformation rule: historyNote
        ====================================
        Output: <desc_uri> historyNote "historyNote" .
        ==================================================
        Additional: This relation states that a descriptor has a history note.
        =======================================================================
        Need to address: N/A.
      -->

      <xsl:if test="HistoryNote">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;historyNote> </xsl:text>
        <xsl:value-of select='f:literal-str(HistoryNote)'/>
        <xsl:text> .&#10;</xsl:text>
      </xsl:if>

      <!--
        Transformation rule: onlineNote
        ====================================
        Output: <desc_uri> onlineNote "onlineote" .
        ================================================
        Additional: This relation states that a descriptor has a online note.
        =======================================================================
        Need to address: N/A.
      -->

      <xsl:if test="OnlineNote">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;onlineNote> </xsl:text>
        <xsl:value-of select='f:literal-str(OnlineNote)'/>
        <xsl:text> .&#10;</xsl:text>
      </xsl:if>

      <!--
        Transformation rule: publicMeSHNote
        ====================================
        Output: <desc_uri> publicMeSHNote "publicMeSHNote" .
        ==========================================================
        Additional: This relation states that a descriptor has a public MeSH note.
        =======================================================================
        Need to address: N/A
      -->

      <xsl:if test="PublicMeSHNote">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;publicMeSHNote> </xsl:text>
        <xsl:value-of select='f:literal-str(PublicMeSHNote)'/>
        <xsl:text> .&#10;</xsl:text>
      </xsl:if>

      <!--
        Transformation rule: previousIndexing
        =========================================
        Output: <desc_uri> previousIndexing "previousIndexing" .
        ============================================================
        Additional: This relation states that a descriptor has some previous indexing.
        ================================================================================
        Need to address: Whether there is any use in parsing the previous indexing text to derive 
        other triples.
      -->

      <xsl:if test="PreviousIndexingList">
        <xsl:for-each select="PreviousIndexingList/PreviousIndexing">
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="../../DescriptorUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;previousIndexing> </xsl:text>
          <xsl:value-of select="f:literal-str(.)"/>
          <xsl:text> .&#10;</xsl:text>
        </xsl:for-each>
      </xsl:if>

      <!--
        Transformation rule: pharmacologicalAction>
        ===============================================
        Output: <desc_uri> pharmacologicalAction <desc_uri> ., where the two <desc_uri> values are 
        different.
        ==========================================================================================
        Additional: This relation states that a descriptor hasa pharmacological action.
        ================================================================================
        Need to address: The pharmacological action is represented here as a <desc_uri>. That is, 
        as a descriptor unique identifier. I felt this was the best thing to do since the 
        pharmacological action consists of a descriptor unique identifier and a name.
        But this information is already obtained by the XSLT code when it extracts the relations 
        in RDF. We can always get the name referred to by the pharmacological action by fetching 
        the name corresponding to the descriptor unique identifier, the <desc_uri>.
      -->

      <xsl:if test="PharmacologicalActionList">
        <xsl:for-each select="PharmacologicalActionList/PharmacologicalAction">
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="../../DescriptorUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&mesh;pharmacologicalAction> </xsl:text>
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="DescriptorReferredTo/DescriptorUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text> .&#10;</xsl:text>
        </xsl:for-each>
      </xsl:if>

      <!--
        Transformation rule: runningHead
        =====================================
        Output: <desc_uri> runningHead "runningHead" .
        ====================================================
        Additional: This relation says that a descriptor has a running head.
        =====================================================================
        Need to address: Whether or not there would be any value to breaking up the text of the 
        running head.
      -->

      <xsl:if test="RunningHead">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;runningHead> </xsl:text>
        <xsl:value-of select="f:literal-str(RunningHead)"/>
        <xsl:text> .&#10;</xsl:text>
      </xsl:if>

      <!--
        Transformation rule: recordOriginator, recordMaintainer, recordAuthorizer
        ===========================================================================
        Output: <desc_uri> recordOriginator "recordOriginator" .,
                <desc_uri> recordMaintainer "recordMaintainer" .,
                <desc_uri> recordOriginator "recordAuthorizer" .
        ==========================================================
        Additional: This relation states that a descriptor has a record originator, maintainer and 
        authorizer.
        ========================================================================================
        Need to address: N/A.
      -->

      <xsl:if test="RecordOriginatorsList">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;recordOriginator> </xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="RecordOriginatorsList/RecordOriginator"/>
        <xsl:text>" .&#10;</xsl:text>

        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;recordMaintainer> </xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="RecordOriginatorsList/RecordMaintainer"/>
        <xsl:text>" .&#10;</xsl:text>

        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;recordAuthorizer> </xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="RecordOriginatorsList/RecordAuthorizer"/>
        <xsl:text>" .&#10;</xsl:text>
      </xsl:if>

      <!--
        Transformation rules: seeAlso, hasRelatedDescriptor
        =====================================================
        Output: <desc_uri> seeAlso <desc_uri>, <desc_uri> hasRelatedDescriptor <desc_uri> .
        =============================================================================
        Additional:
        
        The <desc_uri> seeAlso <desc_uri> is different from what a person would see in the 
        MeSH browser. In the browser one would see <desc_uri> seeAlso "name".
        
        The <desc_uri> hasRelatedDescriptor <desc_uri> is where I decided to deviate from what 
        I saw in the browser b/c the descriptor UI remains unchanged even though the 
        descriptor name can change.
        ============================
        Need to address: I felt that some of the information in the SeeRelatedList element was 
        repetative b/c it consisted of a list of descriptor unique identifiers and names. Hence, 
        I decided to use the output specified above b/c we could always access the unique 
        identifier and name for a descriptor given its unique identifier, we extract this 
        information from the XML already. I thought the hasRelatedDescriptor relation was more 
        expressive and explicit in this case than the seeAlso relation.
      -->

      <xsl:if test="SeeRelatedList">
        <xsl:for-each select="SeeRelatedList/SeeRelatedDescriptor">

          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="../../DescriptorUI"/>
          <xsl:text>&gt; </xsl:text>
          <xsl:text>&lt;&rdfs;seeAlso&gt; </xsl:text>
          <xsl:text>&lt;&mesh;</xsl:text>
          <xsl:value-of select="DescriptorReferredTo/DescriptorUI"/>
          <xsl:text>&gt;</xsl:text>
          <xsl:text> .&#10;</xsl:text>

        </xsl:for-each>
      </xsl:if>

      <!--
        Transformation rule: considerAlso
        ===================================
        Output: <desc_uri> considerAlso "considerAlso" .
        ==================================================
        Additional: 
        =================
        Need to address: Maybe we can break this up into several considerTermsAt
      -->

      <xsl:if test="ConsiderAlso">
        <xsl:text>&lt;&mesh;</xsl:text>
        <xsl:value-of select="DescriptorUI"/>
        <xsl:text>&gt; </xsl:text>
        <xsl:text>&lt;&mesh;considerAlso> </xsl:text>
        <xsl:value-of select="f:literal-str(ConsiderAlso)"/>
        <xsl:text> .&#10;</xsl:text>
      </xsl:if>
    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>
