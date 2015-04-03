package uk.ac.ebi.fgpt.lode.impl;

import uk.ac.ebi.fgpt.lode.utils.DatasourceProvider;

import oracle.jdbc.pool.OracleDataSource;

import javax.sql.DataSource;
import java.sql.SQLException;

/**
 * @author Daniel Davis
 * @date 04/02/2015
 * U.S. National Library of Medicine
 */
public class OracleDatasourceWrapperProvider implements DatasourceProvider {
    private OracleDataSource datasource;

    public void setOracleDatasource(OracleDataSource vds) {
        this.datasource = vds;
    }

    @Override public DataSource getDataSource() throws SQLException {
        return datasource;
    }
}
