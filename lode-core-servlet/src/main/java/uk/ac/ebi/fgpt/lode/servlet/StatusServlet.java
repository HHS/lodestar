package uk.ac.ebi.fgpt.lode.servlet;

import java.util.HashMap;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.PrintWriter;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * A servlet that can be embedded within your web application and simply returns the string "OK" if it could be
 * accessed.  This can be used to allow load balancers in the production environment to detect when a web application
 * has crashed and send a notification to the mailing lists.
 */
public class StatusServlet extends HttpServlet {

    private Logger log = LoggerFactory.getLogger(getClass());

    private Connection getVirtuosoConnection() {
        Connection connection = null;
        try {
            Context initcontext = new InitialContext();
            Context context = (Context) initcontext.lookup("java:comp/env");
            DataSource dataSource = (DataSource) context.lookup("jdbc/virtuoso");
            connection = dataSource.getConnection();
        } catch (NamingException e) {
            log.error("JNDI resource not found", e);
            return null;
        } catch (SQLException e) {
            log.error("Unable to connect to Virtuoso", e);
            return null;
        }
        return connection;
    }

    private Boolean canConnectVirtuoso() {
        Connection connection = getVirtuosoConnection();
        if (null == connection)
            return false;
        try { connection.close(); } catch (SQLException e) { }
        return true;
    }

    private Boolean currentlyUpdating() {
        String updatesPath = System.getenv("MESHRDF_UPDATES_PATH");
        if (null == updatesPath) {
            return false;
        }
        Boolean updating = false;
        BufferedReader br = null;
        try {
            br = new BufferedReader(new FileReader(updatesPath));
            String line = br.readLine();
            if (line.equalsIgnoreCase("yes") || line.equalsIgnoreCase("true")) {
                updating = true;
            }
        } catch (FileNotFoundException e) {
            // this is OK - IGNORE
        } catch (IOException e) {
            log.error("Reading "+updatesPath, e);
        } finally {
            if (null != br) {
                try { br.close(); } catch (IOException e) { }
            }
        }
        return updating;
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        PrintWriter out = null;
        ObjectMapper mapper = null;
        try {
            boolean ok = true;
            HashMap<String,Object> status = new HashMap<String,Object>();

            // httpd and Tomcat are implicitly OK if we are here
            status.put("httpd", true);
            status.put("tomcat", true);

            // Check status of Virtuoso DB server
            if (canConnectVirtuoso()) {
                status.put("Virtuoso", true);
            } else {
                status.put("virtuoso", false);
                if (ok) {
                    ok = false;
                    resp.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
                    resp.addHeader("Retry-After", "600");
                }
            }

            // Check whether we are currently updating
            if (!currentlyUpdating()) {
                status.put("updating", false);
            } else {
                status.put("Updating", true);
                if (ok) {
                    ok = false;
                    resp.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
                    resp.addHeader("Retry-After", "600");
                }
            }

            resp.setContentType("application/json; charset=UTF-8");
            out = resp.getWriter();
            mapper = new ObjectMapper();
            mapper.writeValue(out, status);
        }
        finally {
            if (null != out) {
                out.flush();
                out.close();
            }
        }

    }
}
