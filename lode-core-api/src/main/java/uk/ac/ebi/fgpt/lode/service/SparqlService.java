package uk.ac.ebi.fgpt.lode.service;

import uk.ac.ebi.fgpt.lode.exception.LodeException;
import uk.ac.ebi.fgpt.lode.utils.QueryType;

import java.io.OutputStream;
import java.util.Map;

/**
 * @author Simon Jupp
 * @date 21/02/2013
 * Functional Genomics Group EMBL-EBI
 *
 * A interface to for a basic SPARQL service.
 *
 */
public interface SparqlService {

    /**
     * Set the max number of results returned by the SPARQL service
     * @param limit max number of results returned
     */
    void setMaxQueryLimit(Integer limit);

    /**
     * Ger the max number of results returned by the SPARQL service
     * @return Integer max number of results returned
     */
    Integer getMaxQueryLimit();

    /**
     * Execute a SPARQL query and render results to an OutputStream
     *
     * @param query The SPARQL query
     * @param format The output format See GraphQueryFormats and TupleQueryFormats
     * @param offset Any offest set or the query, default is zero
     * @param limit Any limit set on this query
     * @param inference Use inference to answer query (not supported by all implementations)
     * @param output The output stream for the results
     * @throws LodeException All exceptions are wrapped in a LodeException
     */
    void query(String query, String format, Integer offset, Integer limit, boolean inference, OutputStream output) throws LodeException;

    /**
     * Execute a SPARQL query and render results to an OutputStream
     *
     * @param query The SPARQL query
     * @param format The output format See GraphQueryFormats and TupleQueryFormats
     * @param inference Use inference to answer query (not supported by all implementations)
     * @param output The output stream for the results
     * @throws LodeException All exceptions are wrapped in a LodeException
     */
    void query(String query, String format, boolean inference, OutputStream output) throws LodeException;

    /**
     * Describes a URI and renders the properties found in statements for that model into a simple Map.
     * Only properties whose URI appears in the uriToKeyMap can appear in the returned map.  If a property URI 
     * does not appear in any statement within the underyling model, it will not appear in the map.
     *
     * @param subjectUri - The URI of the object to describe
     * @param propertyNames - A map from property URI to key in the modelmap
     * @return A Map from the key in the model map to the map to the value.   Property names for URIs that did not 
     * @throws LodeException All exceptions are wrapped in a LodeException
     */
    Map<String,Object> getModelMap(String subjectUri, Map<String,String> uriToKeyMap) throws LodeException;

    /**
     * Returns a description of the SPARQL endpoint (http://www.w3.org/TR/sparql11-service-description/)
     *
     * @param outputStream The output stream for the results
     * @param format  format of the description
     */
    void getServiceDescription(OutputStream outputStream, String format);

    /**
     * Get the type of query, one of
     * QueryType.DESCRIBEQUERY,
     * QueryType.CONSTRUCTQUERY,
     * QueryType.TUPLEQUERY,
     * QueryType.BOOLEANQUERY,
     * @param query
     * @return
     */
    QueryType getQueryType(String query);
}
