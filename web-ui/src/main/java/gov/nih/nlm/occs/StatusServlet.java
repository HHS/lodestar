package gov.nih.nlm.occs;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * A servlet that can be embedded within your web application and simply returns the string "OK" if it could be
 * accessed.  This can be used to allow load balancers in the production environment to detect when a web application
 * has crashed and send a notification to the mailing lists.
 */
public class StatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        PrintWriter out = null;
        try {
            resp.setContentType("text/html");
    
            out = resp.getWriter();

            // This is really static stuff
            out.println("<!DOCTYPE html>");
            out.println("<html lang=\"en\">");
            out.println("<head>");
            out.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>");
            out.println("<title>NLM LinkedData/MeshRDF Health Check</title>");
            out.println("<style type=\"text/css\">");
            out.println("  html, body { font-family: Arial, Helvetica, sans-serif; }");
            out.println("  body { width: 375px; }");
            out.println("  dt {");
            out.println("    margin-bottom: 5px;");
            out.println("    font-weight: bold;");
            out.println("  }");
            out.println("  dd {");
            out.println("    margin-left: 0px;");
            out.println("    padding-left: 25px;");
            out.println("    background-position: left;");
            out.println("    background-repeat: no-repeat;");
            out.println("  }");
            out.println("  dd.pass { background-image:url(images/pass.png); }");
            out.println("  dd.fail { background-image:url(images/fail.png); }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Linked Data/MeshRDF</h1>");

            // this is the dynamic stuff
            out.println("<dl>");
            out.println("<dt>Heath Check - id.nlm.nih.gov</dt>");
            out.println("<dd id=\"virtuoso\" class=\"pass\"><strong>Virtuoso</strong></dd>");
            out.println("<dd id=\"maintwindow\" class=\"pass\"><strong>Nightly Update (IDLE)</strong></dd>");
            out.println("</dl>");
            out.println("<p style=\"font-size:small\">OK</p>");

            // again static
            out.println("</body>");
            out.println("</html>");
        }
        finally {
            if (null != out) {
                out.flush();
                out.close();
            }
        }

    }
}
