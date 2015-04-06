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

package uk.ac.ebi.fgpt.lode.impl;

import com.hp.hpl.jena.graph.Graph;
import com.hp.hpl.jena.query.Query;
import com.hp.hpl.jena.query.QuerySolutionMap;
import com.hp.hpl.jena.query.QueryExecution;
import org.springframework.beans.factory.annotation.Value;
import uk.ac.ebi.fgpt.lode.exception.LodeException;
import uk.ac.ebi.fgpt.lode.service.JenaQueryExecutionService;
import uk.ac.ebi.fgpt.lode.utils.DatasourceProvider;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.sql.DataSource;
import oracle.jdbc.pool.OracleDataSource;
import oracle.spatial.rdf.client.jena.OraclePool;
import oracle.spatial.rdf.client.jena.ModelOracleSem;
import java.sql.SQLException;

/**
 * @author Daniel Davis
 * @date 04/02/2015
 * U.S. National Library of Medicine
 */
public class JenaOracleConnectionPoolService implements JenaQueryExecutionService {

    private Logger log = LoggerFactory.getLogger(getClass());

    @Value("${lode.explorer.oracle.inference.model}")
    private String inferenceModel;

    @Value("${lode.explorer.oracle.allgraphs}")
    private boolean allGraphs;

    @Value("${lode.explorer.oracle.model")
    private String modelName;

    public String getInferenceModel() {
        return inferenceModel;
    }

    public void setInferenceModel(String inferenceModel) {
        this.inferenceModel = inferenceModel;
    }

    public boolean isAllGraphs() {
        return allGraphs;
    }

    public void setAllGraphs(boolean allGraphs) {
        this.allGraphs = allGraphs;
    }

    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    private DatasourceProvider datasourceProvider;

    public JenaOracleConnectionPoolService(DatasourceProvider provider) {
        this.datasourceProvider  = provider;
    }

    public Graph getNamedGraph(String graphName) {
        throw new RuntimeException("Can't create named Oracle graph \""+graphName+"\" from datasource");
    }

    public Graph getDefaultGraph() {
        try {
            OracleDataSource datasource = (OracleDataSource) dataSourceProvider.getDatasource();
            OraclePool pool = new OraclePool(datasource);
            ModelOracleSem model = ModelOracleSem.createInstance(pool.getOracle(), modelName);
            return model.getGraph();
        } catch (SQLException e) {
            log.error("Cannot create graph on model \""+modelName+"\" - "+e.getMessage(), e);
        }
        throw new RuntimeException("Can't create Oracle graph from datasource");
    }

    public OracleQueryExecution getQueryExecution(Graph g, Query query, boolean withInference) throws LodeException {
	    OracleGraphBase set = (OracleGraphBase) g;
        if (withInference) {
            // TODO: set.addModelsAndEntailment ?
        }
        OracleQueryExecution execution = OracleQueryExecutionFactory.create(query, set);
        return execution;
    }

    public OracleQueryExecution getQueryExecution(Graph g, String query, QuerySolutionMap initialBinding, boolean withInference) throws LodeException {
        // missed that "query" is a string here and a Query object above...
        OracleGraphBase set = (OracleGraphBase) g;
        if (withInference) {
            // TODO: set.addModelsAndEntailment ?
        }
        OracleQueryExecution execution = OracleQueryExecutionFactory.create(query, set);
        execution.setInitialBinding(initialBinding);
        return execution;
    }
}


