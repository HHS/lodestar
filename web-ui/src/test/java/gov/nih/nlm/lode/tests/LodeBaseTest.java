package gov.nih.nlm.lode.tests;

import org.openqa.selenium.WebElement;
import org.openqa.selenium.By;

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

  public void navigationShouldBeValid() {
    WebElement navi = findElement(By.cssSelector("#home > .navi > ul"));
    elementShouldBeEnabled(navi);

    WebElement query = navi.findElement(By.xpath("li[1]/a"));
    elementTextShouldBe(query, "SPARQL query");
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
  }

  public void openHomePage() {   
    driver.get(getLodeBaseUrl());
  }
 
  public void openSparqlPage() {
    driver.get(getLodeBaseUrl() + "/sparql");
  }

  public void openExplorerPage(Boolean useprefix) {
    String prefix = (useprefix ? YEAR_PREFIX : "");
    String uri = getLodeBaseUrl() + prefix + OFLAXIN_RELURI;
    driver.get(uri);
  }

}
