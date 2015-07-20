package gov.nih.nlm.lode.tests;

import org.openqa.selenium.WebElement;
import org.openqa.selenium.By;

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
