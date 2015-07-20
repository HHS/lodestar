package gov.nih.nlm.lode.tests;

import java.util.List;
import java.util.ArrayList;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.By;
import org.testng.annotations.Test;

import static org.testng.Assert.*;
import static org.hamcrest.CoreMatchers.*;
import static org.hamcrest.MatcherAssert.assertThat;

import gov.nih.nlm.occs.selenium.SeleniumTest;

public class TitlesAndNavTest extends LodeBaseTest {

  @Test
  public void testHomePage() {
    openHomePage();
    titleShouldBe("MeSH Linked Data (beta)");
    elementShouldContain(By.cssSelector("#home > h1"), "Linked Data (beta)");
    navigationShouldBeValid();
  }

  @Test
  public void testSparqlPagce() {
    openSparqlPage();
    titleShouldBe("MeSH SPARQL Explorer (beta)");
    elementShouldContain(By.cssSelector("#home > h1"), "Linked Data (beta)");
    navigationShouldBeValid();
  }

  @Test
  public void testExplorerPage() {
    openExplorerPage(false);
    titleShouldBe("MeSH RDF Explorer (beta)");
    elementShouldContain(By.cssSelector("#home > h1"), "Linked Data (beta)");
    navigationShouldBeValid();
  }

  @Test
  public void testExplorerYearPage() {
    openExplorerPage(true);
    titleShouldBe("MeSH RDF Explorer (beta)");
    elementShouldContain(By.cssSelector("#home > h1"), "Linked Data (beta)");
    navigationShouldBeValid();
  }

  @Test(dependsOnMethods={"testHomePage"})
  public void testFollowNavLinks() {
    openHomePage();
    WebElement navi = navigationShouldBeValid();
    shouldBeValidLinks(navi.findElements(By.tagName("a")));
  }
}