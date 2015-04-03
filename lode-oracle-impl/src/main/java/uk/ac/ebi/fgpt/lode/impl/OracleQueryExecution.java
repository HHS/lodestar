package uk.ac.ebi.fgpt.lode.impl;

import com.hp.hpl.jena.graph.Graph;
import com.hp.hpl.jena.query.*;
import com.hp.hpl.jena.query.QueryExecution;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import uk.ac.ebi.fgpt.lode.exception.LodeException;
import uk.ac.ebi.fgpt.lode.service.JenaQueryExecutionService;

//import virtuoso.jena.driver.VirtGraph;
//
// Analogs for Oracle:
import oracle.spatial.rdf.client.jena.GraphOracleSem;
import oracle.spatial.rdf.client.jena.OracleNamedGraph;

//import virtuoso.jena.driver.VirtuosoQueryExecution;
//import virtuoso.jena.driver.VirtuosoQueryExecutionFactory;
//
// Analogs for Oracle unclear:

/**
 * @author Daniel Davis
 * @date 04/02/2015
 * U.S. National Library of Medicine
 */
public class OracleQueryExecution implements JenaQueryExecutionService {

    private Logger log = LoggerFactory.getLogger(getClass());

    @Value("${lode.explorer.oracle.user}")
    private String user;

    @Value("${lode.explorer.oracle.password}")
    private String password;

    @Value("${lode.explorer.oracle.database}")
    private String database;

    @Value("${lode.explorer.oracle.inferencerule}")
    private String inferenceRule;

    @Value("${lode.explorer.oracle.allgraphs}")
    private boolean allGraphs;

    public String getEndpointURL() {
        return endpointURL;
    }

    public void close() {

    }

    public void setEndpointURL(String endpointURL) {
        this.endpointURL = endpointURL;
    }

    @Value("${lode.sparqlendpoint.url}")
    private String endpointURL;

    public String getUser() {
        return user;
    }

    public String getPassword() {
        return password;
    }

    public String getDatabase() {
        return database;
    }

    public String getInferenceRule() {
        return inferenceRule;
    }

    public void setInferenceRule(String inferenceRule) {
        this.inferenceRule = inferenceRule;
    }

    public boolean isAllGraphs() {
        return allGraphs;
    }

    public void setAllGraphs(boolean allGraphs) {
        this.allGraphs = allGraphs;
    }


    public QueryExecution getQueryExecution(Graph g, Query query, boolean withInference) throws LodeException {
	/*
        if (isNullOrEmpty(getEndpointURL())) {
            log.error("No sparql endpoint");
            throw new LodeException("You must specify a SPARQL endpoint URL");
        }
        VirtGraph set =  (VirtGraph) g;
        set.setReadFromAllGraphs(isVirtuosoAllGraphs());
        if (withInference) {
            set.setRuleSet(getVirtuosoInferenceRule());
        }
        if (query.isDescribeType()) {
             ** todo this is a hack to get virtuoso describe queries
             *  for concise bound description of given subject (i.e., SPO + CBD of each blank node object found by SPO, recursively);
             ** 
            String squery = "DEFINE sql:describe-mode \"CBD\"\n" + query.serialize();
            return virtuoso.jena.driver.VirtuosoQueryExecutionFactory.create(squery, set);
        }
        return VirtuosoQueryExecutionFactory.create(query, set);
	 */
        throw new RuntimeException("Oracle query execution not yet implemented");
    }

    public QueryExecution getQueryExecution(Graph g, String query, QuerySolutionMap initialBinding, boolean withInference) throws LodeException {
	/*
        if (isNullOrEmpty(getEndpointURL())) {
            log.error("No sparql endpoint");
            throw new LodeException("You must specify a SPARQL endpoint URL");
        }
        VirtGraph set =  (VirtGraph) g;
        set.setReadFromAllGraphs(isVirtuosoAllGraphs());
        if (withInference) {
            set.setRuleSet(getVirtuosoInferenceRule());
        }
        VirtuosoQueryExecution execution = VirtuosoQueryExecutionFactory.create(query, set);
        execution.setInitialBinding(initialBinding);
        return execution;
	 */
        throw new RuntimeException("Oracle query execution not yet implemented");
    }

    public static boolean isNullOrEmpty(Object o) {
        if (o == null) {
            return true;
        }
        return "".equals(o);
    }

    public Graph getDefaultGraph() {
	/*
         return new VirtGraph(getEndpointURL(), getVirtuosoUser() , getVirtuosoPassword());
	 */
        throw new RuntimeException("Oracle graph discovery not yet implemented");
    }

    public Graph getNamedGraph(String graphName) {
        /*
	 *return new VirtGraph(graphName, getEndpointURL(), getVirtuosoUser() , getVirtuosoPassword());
	 */
        throw new RuntimeException("Oracle graph discovery not yet implemented");
    }

}
