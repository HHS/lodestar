package gov.nih.nlm.lode.tests;

import org.openqa.selenium.support.PageFactory;

import gov.nih.nlm.occs.selenium.SeleniumTest;

/**
 *  * Having our own base class limits dependence on SeleniumTest.
 *   * We also use it to make sure all tests know how to login.
 *    */
public class LodeBaseTest extends SeleniumTest {
  
  public HomePage openHomePage() {
    driver.get(baseUrl + HomePage.URI);
    return PageFactory.initElements(driver, HomePage.class);
  }

  /* public SparqlPage openSparqlPage() {
    driver.get(baseUrl + SparqlPage.URI);
    return PageFactory.initElements(driver, SparqlPage.class);
  }*/ 
}
