package gov.nih.nlm.lode.tests;

import java.util.List;
import java.util.ArrayList;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;
import java.net.URL;
import java.net.URI;
import java.net.MalformedURLException;
import java.net.URISyntaxException;
import java.io.IOException;

import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.client.DefaultRedirectStrategy;
import org.apache.http.Header;
import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;
import org.apache.http.StatusLine;
import org.apache.http.message.BasicHeader;

import org.apache.commons.lang3.tuple.Pair;

import org.testng.Reporter;

import static org.testng.Assert.*;
import static org.hamcrest.CoreMatchers.*;
import static org.hamcrest.MatcherAssert.assertThat;

public class LinkChecker {

    public interface RequestCallback {
        public void withRequest(HttpRequest request);
    }

    public interface ResponseCallback {
        public void withResponse(HttpResponse response);
    }

    private URL context;
    private boolean followRedirects;

    private List<URI> links = new ArrayList<URI>();
    private List<LinkChecker.RequestCallback> requestCallbacks = new ArrayList<LinkChecker.RequestCallback>();
    private List<LinkChecker.ResponseCallback> responseCallbacks = new ArrayList<LinkChecker.ResponseCallback>();

    public LinkChecker() {
        this(null, true);
    }

    public LinkChecker(String context) {
        this(context, true);
    }

    public LinkChecker(String context, boolean followRedirects) {
        this.followRedirects = followRedirects;
        if (context == null) {
            this.context = null;
        } else {
            try {
                this.context = new URL(context);
            } catch (MalformedURLException e) {
                fail("context '"+context+"' is not a valid URL");
            }
        }
    }

    public void addRequestCallback(LinkChecker.RequestCallback callback) {
        requestCallbacks.add(callback);
    }

    public void addResponseCallback(LinkChecker.ResponseCallback callback) {
        responseCallbacks.add(callback);
    }

    public void addRequestHeader(String name, String value) {
        addRequestHeader(new BasicHeader(name, value));
    }

    public void addRequestHeader(final Header header) {
        addRequestCallback(new LinkChecker.RequestCallback() {
            public void withRequest(HttpRequest request) {
                request.setHeader(header);
            }
        });
    }

    public void shouldMatchContentType(String contentTypeExpr) {
        shouldMatchResponseHeader("Content-Type", contentTypeExpr);
    }

    public void shouldMatchResponseHeader(final String name, final String valueExpr) {       
        try {
            final Pattern pattern = Pattern.compile(valueExpr);            
            addResponseCallback(new LinkChecker.ResponseCallback() {
                public void withResponse(HttpResponse response) {
                    Header header = response.getFirstHeader(name);
                    assertNotNull(header);
                    assertTrue( pattern.matcher( header.getValue() ).matches(), 
                        String.format("%s response header '%s' should match '%s'", name, header.getValue(), valueExpr));
                }
            });
        } catch (PatternSyntaxException e) {
            fail(String.format("shouldMatchResponseHeader('%s', '%s')Z regex syntax error", name, valueExpr));
        }
    }

    public void add(String urlspec) {
        try {
            URL url = (this.context != null ? new URL(this.context, urlspec) : new URL(urlspec));
            links.add(url.toURI());
        } catch (MalformedURLException e) {
            fail("url specification '"+urlspec+"' is not valid");
        } catch (URISyntaxException e) {
            fail("url specification '"+urlspec+"' is not valid");
        }
    }

    public void add(String contextspec, String urlspec) {
        URL localContext = null;
        try { 
            localContext = new URL(contextspec);
        } catch (MalformedURLException e) {
            fail("context "+contextspec+" is not a valid URL");
        }
        try {
            URL fullurl = new URL(localContext, urlspec);
            links.add(fullurl.toURI());
        } catch (MalformedURLException e) {
            fail("url specification '"+urlspec+"' is not valid");
        } catch (URISyntaxException e) {
            fail("url specification '"+urlspec+"' is not valid");
        }
    }

    public void shouldBeValid() {
        URI lastbadlink = null;
        DefaultHttpClient client = new DefaultHttpClient();
        if (followRedirects)
            client.setRedirectStrategy(new DefaultRedirectStrategy());
        for (URI link : links) {
            HttpGet request = new HttpGet(link);
            // set any request headers
            for (LinkChecker.RequestCallback callback : requestCallbacks) {
                callback.withRequest(request);
            }
            CloseableHttpResponse response = null;
            try {
                response = client.execute(request);
            } catch (ClientProtocolException e) {
                Reporter.log(String.format("%s: ClientProtocolException: %s<br>", link, e.getMessage()));
                lastbadlink = link;
            } catch (IOException e) {
                Reporter.log(link.toString()+": IOException "+e.getMessage()+"<br>");
                lastbadlink = link;
            }
            if (response != null) {
                // must be a "successful" response code
                int code = response.getStatusLine().getStatusCode();
                if (code < 200 || code >= 300) {
                    Reporter.log(String.format("%s: status code %d, not successful", link, code));
                    lastbadlink = link;
                } else {
                    // should have correct values for expected response headers
                    for (LinkChecker.ResponseCallback callback : responseCallbacks) {
                        // TODO: catch AssertionError?
                        callback.withResponse(response);
                    }
                }
                try {
                    response.close();
                } catch (IOException e) {
                    // DO NOTHING
                }
            }
        }
        if (null != lastbadlink) {
            fail(String.format("one or more bad links, last bad link %s", lastbadlink));
        }
    }
}