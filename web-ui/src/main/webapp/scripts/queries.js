/*
 * Copyright (c) 2013 EMBL - European Bioinformatics Institute
 * Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software distributed under the
 * License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions
 * and limitations under the License.
 */

var exampleQueries = [

    {
        shortname : "MeSH Linked Data Predicates",
        description: "Retrieve the list of distinct predicates in MeSH RDF",
        query: 	"PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>\n"+
	        "PREFIX mesh: <http://id.nlm.nih.gov/mesh/>\n"+
	        "SELECT DISTINCT ?p\n" +
				"FROM <http://id.nlm.nih.gov/mesh2014>\n" +
				" WHERE {\n" +
				"  ?s ?p ?o\n" +
				" } \n"+
				"ORDER BY\n"+
				"?p\n"
    },
	
	{
        shortname : "Ofloxacin Pharmacological Actions",
        description: "The Pharmacological Actions of Oflaxacin and their labels",
        query: "PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>\n"+
	       "PREFIX mesh: <http://id.nlm.nih.gov/mesh/>\n"+
	       "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n"+
	       "SELECT *\n" +
				"FROM <http://id.nlm.nih.gov/mesh2014>\n" +
				"WHERE {\n" +
				"  mesh:D015242 meshv:pharmacologicalAction ?pa .\n" +
				"  ?pa rdfs:label ?paLabel\n" +
				"} \n"
    },
	
	{
        shortname : "Allowable Qualifiers",
        description: "Any MeSH descriptor that has an allowable qualifier of 'drug effects'.",
        query: "PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>\n"+
	       "PREFIX mesh: <http://id.nlm.nih.gov/mesh/>\n"+
	       "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n"+
	       "SELECT distinct ?d ?dLabel \n" +
				"FROM <http://id.nlm.nih.gov/mesh2014>\n" +
				"WHERE {\n" +
				"  ?d meshv:allowableQualifier ?q .\n" +
				"  ?q rdfs:label 'drug effects' . \n" +
				"  ?d rdfs:label ?dLabel \n" +
				"} \n" +
				"ORDER BY ?dLabel\n"
    },
	
	{
        shortname : "String search on 'infection'",
        description: "Any MeSH term ('D' or 'M') that has 'infection' as part of its name.",
        query: "PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>\n"+
	       "PREFIX mesh: <http://id.nlm.nih.gov/mesh/>\n"+
	       "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n"+    
	       "SELECT ?d ?dName ?c ?cName\n" +
				"FROM <http://id.nlm.nih.gov/mesh2014>\n" +
				"WHERE {\n" +
				"  ?d meshv:concept ?c .\n" +
				"  ?d rdfs:label ?dName .\n" +
				"  ?c rdfs:label ?cName\n" +
				"  FILTER(REGEX(?dName,'infection','i') || REGEX(?cName,'infection','i')) \n"+
				"} \n" +
				"ORDER BY ?d"

    }

];
