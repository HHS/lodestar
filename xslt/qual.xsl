<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- 
  This external subset defines all of the entities that we'll use for URI prefixes from other
  various ontologies.
-->
<!DOCTYPE xsl:stylesheet SYSTEM "mesh-rdf-prefixes.ent" >

<xsl:stylesheet version="2.0" 
                xmlns:f="http://nlm.nih.gov/ns/f"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="common.xsl"/>
  <xsl:output method="text"/>


  <xsl:template match="/">

    <!-- triples for Qualifier Records -->

    <xsl:for-each select="QualifierRecordSet/QualifierRecord">
      <xsl:variable name='qualifier_uri'>
        <uri prefix='&mesh;'>
          <xsl:value-of select="QualifierUI"/>
        </uri>
      </xsl:variable>

      <!--
        Transformation rule: rdf:type
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>This relation states that a Subject node used to identify a Qualifier is of type "Qualifier".</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$qualifier_uri"/>
          <uri prefix='&rdf;'>type</uri>
          <uri prefix='&mesh;'>Qualifier</uri>
        </xsl:with-param>
      </xsl:call-template>
      
      <!--
        Transformation rule: dcterms:identifier
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>This relation states that a qualifier has a qualifier identifier.</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$qualifier_uri"/>
          <uri prefix='&dcterms;'>identifier</uri>
          <literal>
            <xsl:value-of select="QualifierUI"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>

      <!--
        Transformation rule: isQualifierType
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>This relation states that a qualifier has a qualifier type.</desc>
          <fixme report='klortho'>Rather than a predicate with a literal value, couldn't we use an rdf:type relation for
            this, and assign a class to each qualifier type?  Currently (see http://www.nlm.nih.gov/mesh/xml_data_elements.html)
            the only defined type is "1".</fixme>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$qualifier_uri"/>
          <uri prefix='&mesh;'>isQualifierType</uri>
          <literal>
            <xsl:value-of select="@QualifierType"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>

      <!--
        Transformation rule: rdfs:label
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>Every qualifier has a qualifier name.</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$qualifier_uri"/>
          <uri prefix='&rdfs;'>label</uri>
          <literal>
            <xsl:value-of select="QualifierName/String"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>

      <!--
        Transformation rule: dateCreated
      -->
      <xsl:call-template name='triple'>
        <xsl:with-param name="doc">
          <desc>This relation states that a qualifier has a date on which it was created.</desc>
        </xsl:with-param>
        <xsl:with-param name='spec'>
          <xsl:copy-of select="$qualifier_uri"/>
          <uri prefix='&mesh;'>dateCreated</uri>
          <literal>
            <xsl:value-of select="string-join((DateCreated/Year,DateCreated/Month,DateCreated/Day),'-')"/>
          </literal>
        </xsl:with-param>
      </xsl:call-template>
      
      <!--
        Transformation rule/Relation: dateRevised
      -->
      <xsl:if test="DateRevised">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A qualifier can have a date on which it was revised.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$qualifier_uri"/>
            <uri prefix='&mesh;'>dateRevised</uri>
            <literal>
              <xsl:value-of select="string-join((DateRevised/Year,DateRevised/Month,DateRevised/Day),'-')"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <!--
        Transformation rule/Relation: dateEstablished
      -->
      <xsl:if test="DateEstablished">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A qualifier can have a date on which it was established.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$qualifier_uri"/>
            <uri prefix='&mesh;'>dateEstablished</uri>
            <literal>
              <xsl:value-of select="string-join((DateEstablished/Year,DateEstablished/Month,DateEstablished/Day),'-')"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <!--
        Transformation rule/Relation: activeMeSHYear
      -->
      <xsl:for-each select="ActiveMeSHYearList/Year">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>Every qualifier has at least one year in which the record was active since it was last modified.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$qualifier_uri"/>
            <uri prefix='&mesh;'>activeMeSHYear</uri>
            <literal>
              <xsl:value-of select="."/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>

      <!--
        Transformation rule:Relation: annotation
      -->
      <xsl:if test="Annotation">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A Qualifier can have an annotation.</desc>
            <fixme>This rule extracts that annotation and converts it into a string. But sometimes, if not always, the annotation will
              have a link to another qualifier or some manual. Hence, we might have to decipher a way to express this in our RDF conversion. 
              This might require some NLP? For now however, the annotation is simply converted to a string data type.</fixme>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$qualifier_uri"/>
            <uri prefix='&mesh;'>property</uri>
            <literal>
              <xsl:value-of select="Annotation"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <!--
        Transformation rule: historyNote
      -->
      <xsl:if test="HistoryNote">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A qualifier can have a history note.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$qualifier_uri"/>
            <uri prefix='&mesh;'>historyNote</uri>
            <literal>
              <xsl:value-of select="HistoryNote"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <!--
        Transformation rule/Relation: onlineNote
      -->
      <xsl:if test="OnlineNote">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A qualifier can have an online note.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$qualifier_uri"/>
            <uri prefix='&mesh;'>onlineNote</uri>
            <literal>
              <xsl:value-of select="OnlineNote"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <!--
        Transformation rule: treeNumber
      -->
      <xsl:for-each select="TreeNumberList/TreeNumber">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A qualifier can have a tree number.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$qualifier_uri"/>
            <uri prefix='&mesh;'>treeNumber</uri>
            <literal>
              <xsl:value-of select="."/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>

      <!--
        Transformation rule: allowedTreeNode
      -->
      <xsl:for-each select="TreeNodeAllowedList/TreeNodeAllowed">
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A qualifier can have at least one allowed tree node.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$qualifier_uri"/>
            <uri prefix='&mesh;'>allowedTreeNode</uri>
            <literal>
              <xsl:value-of select="."/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>

      <xsl:if test="RecordOriginatorsList">
        <!--
          Transformation rule: recordOriginator
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A qualifier has a record originator</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$qualifier_uri"/>
            <uri prefix='&mesh;'>recordOriginator</uri>
            <literal>
              <xsl:value-of select="RecordOriginatorsList/RecordOriginator"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule: recordMaintainer
        -->
        <xsl:if test="RecordOriginatorsList/RecordMaintainer">
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>A qualifier has a record maintainer</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$qualifier_uri"/>
              <uri prefix='&mesh;'>recordMaintainer</uri>
              <literal>
                <xsl:value-of select="RecordOriginatorsList/RecordMaintainer"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>

        <!--
          Transformation rule: recordAuthorizer
        -->
        <xsl:if test="RecordOriginatorsList/RecordAuthorizer">
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>A qualifier has a record authorizer</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$qualifier_uri"/>
              <uri prefix='&mesh;'>recordAuthorizer</uri>
              <literal>
                <xsl:value-of select="RecordOriginatorsList/RecordAuthorizer"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:if>

      <xsl:for-each select="ConceptList/Concept">
        <xsl:variable name='concept_uri'>
          <uri prefix='&mesh;'>
            <xsl:value-of select="ConceptUI"/>
          </uri>
        </xsl:variable>

        <!--
          Transformation rule: concept
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A qualifier has at least one concept.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select="$qualifier_uri"/>
            <uri prefix='&mesh;'>concept</uri>
            <xsl:copy-of select='$concept_uri'/>
          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule: rdf:type
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>This relation states that a Subject node used to identify a concept is of type "Concept".</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select='$concept_uri'/>
            <uri prefix='&rdf;'>type</uri>
            <uri prefix='&mesh;'>Concept</uri>
          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule/Relation: isPreferredConcept
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A concept will or will not be the preferred concept associated with a Qualifier.</desc>
            <fixme>As with a few cases in desc, I (@klortho) think using a different class here would be better
              than a literal Y/N value.</fixme>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select='$concept_uri'/>
            <uri prefix='&mesh;'>isPreferredConcept</uri>
            <literal>
              <xsl:value-of select="@PreferredConceptYN"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule: rdfs:label
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A concept has a name.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select='$concept_uri'/>
            <uri prefix='&rdfs;'>label</uri>
            <literal>
              <xsl:value-of select="ConceptName/String"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule/Relation: dcterms:identifier
        -->
        <xsl:call-template name='triple'>
          <xsl:with-param name="doc">
            <desc>A concept has a unique identifier.</desc>
          </xsl:with-param>
          <xsl:with-param name='spec'>
            <xsl:copy-of select='$concept_uri'/>
            <uri prefix='&dcterms;'>identifier</uri>
            <literal>
              <xsl:value-of select="ConceptUI"/>
            </literal>
          </xsl:with-param>
        </xsl:call-template>

        <!--
          Transformation rule: skos:scopeNote
        -->
        <xsl:if test="ScopeNote">
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>A concept can have a scope note.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$concept_uri'/>
              <uri prefix='&skos;'>scopeNote</uri>
              <literal>
                <xsl:value-of select="ScopeNote"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>


        <xsl:for-each select="SemanticTypeList/SemanticType">
          <xsl:variable name='semantic_type_uri'>
            <uri prefix='&mesh;'>
              <xsl:value-of select="SemanticTypeUI"/>
            </uri>
          </xsl:variable>

          <!--
            Transformation rule: SemanticType
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>A concept can have a semantic type UI and semantic type name. However, I abstracted 
                this relation into the formulation stated in the output above. In this formulation, the concept 
                has a semantic type which in turn has a UI and name.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$semantic_type_uri"/>
              <uri prefix='&rdf;'>type</uri>
              <uri prefix='&mesh;'>SemanticType</uri>
            </xsl:with-param>
          </xsl:call-template>

          <!--
            Transformation rule: semanticType
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$concept_uri"/>
              <uri prefix='&mesh;'>semanticType</uri>
              <xsl:copy-of select="$semantic_type_uri"/>
            </xsl:with-param>
          </xsl:call-template>

          <!--
            Transformation rule: dcterms:identifier
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$semantic_type_uri"/>
              <uri prefix='&dcterms;'>identifier</uri>
              <literal>
                <xsl:value-of select="SemanticTypeUI"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>

          <!--
            Transformation rule: rdfs:label
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$semantic_type_uri"/>
              <uri prefix='&rdfs;'>label</uri>
              <literal>
                <xsl:value-of select="SemanticTypeName"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="ConceptRelationList/ConceptRelation">
          <xsl:variable name='blank_concept_relation'>
            <named>
              <xsl:text>_:blank_set1_</xsl:text>
              <xsl:value-of select="../../ConceptUI"/>
              <xsl:text>_</xsl:text>
              <xsl:value-of select="position()"/>
            </named>
          </xsl:variable>

          <!-- 
            Transformation rule: conceptRelation
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>There are several predicates mentioned here. The conceptRelation states that a concept has a relation to another concept.
                That relation is identified with a blank node. This blank node stores the information that describes how the current concept (concept1) is 
                related to a second concept (concept2). The first concept is either broader, narrower, or related, in relation to the second concept. We
                use the skos:broader, skos:narrower, and skos:related predicates in this case.
                This rule applies when a qualifier has a concept in its concept list that possesses a concept relation list. If this is the case,
                then there will be at least one concept relation in the concept relation list.</desc>
              <fixme>Do we need to use a blank node here?</fixme>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$concept_uri"/>
              <uri prefix='&mesh;'>conceptRelation</uri>
              <xsl:copy-of select="$blank_concept_relation"/>
            </xsl:with-param>
          </xsl:call-template>
          
          <!-- 
            Transformation rule: rdf:type
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$blank_concept_relation"/>
              <uri prefix='&rdf;'>type</uri>
              <uri prefix='&mesh;'>ConceptRelation</uri>
            </xsl:with-param>
          </xsl:call-template>
          
          <!-- 
            Transformation rule: mesh:relation
          -->
          <xsl:if test="@RelationName">
            <xsl:call-template name='triple'>
              <xsl:with-param name='spec'>
                <xsl:copy-of select="$blank_concept_relation"/>
                <uri prefix='&mesh;'>relation</uri>
                <xsl:copy-of select="f:skos_relation_uri(@RelationName)"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          
          <!-- 
            Transformation rule: mesh:concept1
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$blank_concept_relation"/>
              <uri prefix='&mesh;'>concept1</uri>
              <uri prefix='&mesh;'>
                <xsl:value-of select="Concept1UI"/>
              </uri>
            </xsl:with-param>
          </xsl:call-template>
          
          <!-- 
            Transformation rule: mesh:concept2
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <fixme>Do we really want two predicates for these, mesh:concept1 and mesh:concept2?  Are they the same
                relationship?  Does order matter?</fixme>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$blank_concept_relation"/>
              <uri prefix='&mesh;'>concept2</uri>
              <uri prefix='&mesh;'>
                <xsl:value-of select="Concept2UI"/>
              </uri>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>


        <xsl:for-each select="TermList/Term">
          <xsl:variable name='term_uri'>
            <uri prefix='&mesh;'>
              <xsl:value-of select="TermUI"/>
            </uri>
          </xsl:variable>

          <!--
            Transformation rule: term
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>This relation states that a concept has a term.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select="$concept_uri"/>
              <uri prefix='&mesh;'>term</uri>
              <xsl:copy-of select='$term_uri'/>
            </xsl:with-param>
          </xsl:call-template>
          
          <!--
            Transformation rule: rdf:type
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>This relation states that a Subject node used to identify a term is of type "Term".</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_uri'/>
              <uri prefix='&rdf;'>type</uri>
              <uri prefix='&mesh;'>Term</uri>
            </xsl:with-param>
          </xsl:call-template>

          <!--
            Transformation rule: dcterms:identifier
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>This relation states that a term has a term unique identifier.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_uri'/>
              <uri prefix='&dcterms;'>identifier</uri>
              <literal>
                <xsl:value-of select="TermUI"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>

          <!--
            Transformation rule: rdfs:label
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>A term has a term name.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_uri'/>
              <uri prefix='&rdfs;'>label</uri>
              <literal>
                <xsl:value-of select="String"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>

          <!--
            Transformation rule: dateCreated
          -->
          <xsl:if test="DateCreated">
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <desc>This relation states that a term can have a date on which it was created.</desc>
                <fixme reporter='klortho'>We need a date-generation template in common.xsl</fixme>
              </xsl:with-param>
              <xsl:with-param name='spec'>
                <xsl:copy-of select='$term_uri'/>
                <uri prefix='&mesh;'>dateCreated</uri>
                <literal>
                  <xsl:value-of select="string-join((DateCreated/Year,DateCreated/Month,DateCreated/Day),'-')"/>
                </literal>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>

          <!--
            Transformation rule: abbreviation
          -->
          <xsl:if test="Abbreviation">
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <desc>A term can have a term abbreviation.</desc>
              </xsl:with-param>
              <xsl:with-param name='spec'>
                <xsl:copy-of select='$term_uri'/>
                <uri prefix='&mesh;'>abbreviation</uri>
                <literal>
                  <xsl:value-of select="Abbreviation"/>
                </literal>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>

          <!--
            Transformation rule: sortVersion
          -->
          <xsl:if test="SortVersion">
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <desc>A term can have a sort version.</desc>
              </xsl:with-param>
              <xsl:with-param name='spec'>
                <xsl:copy-of select='$term_uri'/>
                <uri prefix='&mesh;'>sortVersion</uri>
                <literal>
                  <xsl:value-of select="SortVersion"/>
                </literal>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>

          <!--
            Transformation rule: entryVersion
          -->
          <xsl:if test="EntryVersion">
            <xsl:call-template name='triple'>
              <xsl:with-param name="doc">
                <desc>A term can have an entry version.</desc>
              </xsl:with-param>
              <xsl:with-param name='spec'>
                <xsl:copy-of select='$term_uri'/>
                <uri prefix='&mesh;'>entryVersion</uri>
                <literal>
                  <xsl:value-of select="EntryVersion"/>
                </literal>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>

          <!--
            Transformation rule: isConceptPreferredTerm
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>This relation states that a term can be a concept-preferred-term.</desc>
              <fixme reporter='klortho'>As suggested in many other places, I think a better way to deal with these Y/N values is to define
                a class that corresponds to the "Y" value, and then create an rdf:type triple iff the value is "Y".  In other
              words, create a mesh:ConceptPreferredTerm class, and then, if the value of this attribute is "Y", create 
              a triple `*term_uri* rdf:type mesh:ConceptPreferredTerm`.</fixme>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_uri'/>
              <uri prefix='&mesh;'>isConceptPreferredTerm</uri>
              <literal>
                <xsl:value-of select="@ConceptPreferredTermYN"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>

          <!--
            Transformation rule: isPermutedTerm
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>A term can be a permuted term.</desc>
              <fixme reporter='klortho'>As suggested in many other places, I think a better way to deal with these Y/N values is to define
                a class that corresponds to the "Y" value, and then create an rdf:type triple iff the value is "Y".</fixme>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_uri'/>
              <uri prefix='&mesh;'>isPermutedTerm</uri>
              <literal>
                <xsl:value-of select="@IsPermutedTermYN"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>

          <!--
            Transformation rule: lexicalTag
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>A term has a lexical tag.</desc>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_uri'/>
              <uri prefix='&mesh;'>lexicalTag</uri>
              <literal>
                <xsl:value-of select="@LexicalTag"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>

          <!--
            Transformation rule: printFlag
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>A term has a print flag.</desc>
              <fixme reporter='klortho'>As suggested in many other places, I think a better way to deal with these Y/N values is to define
                a class that corresponds to the "Y" value, and then create an rdf:type triple iff the value is "Y".</fixme>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_uri'/>
              <uri prefix='&mesh;'>printFlag</uri>
              <literal>
                <xsl:value-of select="@PrintFlagYN"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>

          <!--
            Transformation rule: isRecordPreferredTerm
          -->
          <xsl:call-template name='triple'>
            <xsl:with-param name="doc">
              <desc>A term can be a record preferred term.</desc>
              <fixme reporter='klortho'>As suggested in many other places, I think a better way to deal with these Y/N values is to define
                a class that corresponds to the "Y" value, and then create an rdf:type triple iff the value is "Y".</fixme>
            </xsl:with-param>
            <xsl:with-param name='spec'>
              <xsl:copy-of select='$term_uri'/>
              <uri prefix='&mesh;'>isRecordPreferredTerm</uri>
              <literal>
                <xsl:value-of select="@RecordPreferredTermYN"/>
              </literal>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
