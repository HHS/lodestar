package gov.nih.nlm.lode.tests;

import java.util.List;
import java.net.URL;
import java.net.MalformedURLException;
import java.net.HttpURLConnection;
import java.net.URLConnection;

import org.openqa.selenium.WebElement;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.By;
import org.testng.Reporter;

import static org.testng.Assert.*;
import static org.hamcrest.CoreMatchers.*;
import static org.hamcrest.MatcherAssert.assertThat;

import gov.nih.nlm.occs.selenium.SeleniumTest;

/**
 * Having our own base class limits dependence on SeleniumTest,
 * and allows us to find elements after opening a page.
 */
public class LodeBaseTest extends SeleniumTest {

  public static final String OFLAXIN_RELURI = "/D015242";
  public static final String YEAR_PREFIX = "/2015";

  public String getLodeBaseUrl() {
    if (baseUrl == null || baseUrl.equals("")) {
      return "http://iddev.nlm.nih.gov/mesh";
    } else {
      return baseUrl;
    }
  }

  public String getCurrentBaseUrl() {
    String href = null;
    try {
      WebElement basetag = driver.findElement(By.xpath("//head/base"));
      if (null != basetag) {
        href = basetag.getAttribute("href");
      }
    } catch (NoSuchElementException e) { 
      // DO NOTHiNG
    }
    if (null == href) {
      href = driver.getCurrentUrl();
    }
    return href;
  }

  public WebElement navigationShouldBeValid() {

    WebElement navi = findElement(By.cssSelector("#home > .navi > ul"));
    elementShouldBeEnabled(navi);

    WebElement query = navi.findElement(By.xpath("li[1]/a"));
    elementTextShouldBe(query, "SPARQL Query");
    assertThat(query.getAttribute("href"), endsWith("query"));
    assertThat(query.getAttribute("href"), startsWith(getLodeBaseUrl()));

    WebElement techdocs = navi.findElement(By.xpath("li[2]/a"));
    elementTextShouldBe(techdocs, "Technical Docs");

    WebElement rdfhome  = navi.findElement(By.xpath("li[3]/a"));
    elementTextShouldBe(rdfhome, "MeSH RDF Home");
    assertThat(rdfhome.getAttribute("href"), startsWith(getLodeBaseUrl()));

    WebElement meshhome = navi.findElement(By.xpath("li[4]/a"));
    elementTextShouldBe(meshhome, "MeSH Home");
    assertThat(meshhome.getAttribute("href"), endsWith("://www.nlm.nih.gov/mesh/"));

    return navi;
  }

  public void shouldBeValidLinks(List<WebElement> links) {
    shouldBeValidLinks(links, "Found some bad links");
  }

  public void shouldBeValidLinks(List<WebElement> links, String message) {
    String currentBaseUrl = getCurrentBaseUrl();
    Boolean haveBadLinks = false;

    URL context = null;
    try {
      context = new URL(currentBaseUrl);
    } catch (MalformedURLException e) {
      Reporter.log("MalforcmedURLException: "+currentBaseUrl, true);
      haveBadLinks = true;
    }

    
    for (WebElement link : links) {     
      String tag = link.getTagName();
      String href = (tag.equalsIgnoreCase("script") || tag.equalsIgnoreCase("img") ? link.getAttribute("src") : link.getAttribute("href"));

      try {
        URL fullref = new URL(context, href);
        URLConnection congeneric = fullref.openConnection();
        if (congeneric instanceof HttpURLConnection) {
          HttpURLConnection con = (HttpURLConnection) congeneric;
          int code = con.getResponseCode();
          if (code != 200 && code != 301 && code != 302) {
            Reporter.log("URL "+href+" returned status code "+con.getResponseCode(), true);
            haveBadLinks = true;
          }
        }       
      } catch (Exception e) {
        Reporter.log("URL "+href+" exception: "+e.getMessage(), true);
        haveBadLinks = true;
      }
    }

    assertFalse(haveBadLinks, message);
  }

  public void openHomePage() {   
    driver.get(getLodeBaseUrl());
  }
 
  public void openQueryPage() {
    driver.get(getLodeBaseUrl() + "/query");
  }

  public void openExplorerPage(Boolean useprefix) {
    String prefix = (useprefix ? YEAR_PREFIX : "");
    String uri = getLodeBaseUrl() + prefix + OFLAXIN_RELURI;
    driver.get(uri);
  }

}