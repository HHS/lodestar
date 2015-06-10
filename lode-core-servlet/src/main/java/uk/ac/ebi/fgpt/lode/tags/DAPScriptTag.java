package uk.ac.ebi.fgpt.lode.tags;

import java.io.IOException;
import javax.servlet.jsp.JspContext;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.SimpleTagSupport;

/**
 * DAPScriptTag inserts the appropriate DAP code in each page to register a visit to the page.
 */
public class DAPScriptTag extends SimpleTagSupport {
    public void doTag() throws IOException, JspException {
        JspContext jspContext = getJspContext();
        String environment = System.getenv("MESHRDF_ENV");
        if (null != environment && environment.equals("production")) {
            jspContext.getOut().print("<script src=\"http://ohdear.this.isnt.right/analytics.js\"></script>");
        }
    }
}
