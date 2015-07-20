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

public class CssAndScriptTest extends LodeBaseTest {

  @Test
  public void testScriptTags() {
    openHomePage();
    List<WebElement> links = driver.findElements(By.xpath("//script[@src]"));
    shouldBeValidLinks(links, "Found bad links in script tags");
  }

  @Test
  public void testLinkTags() {
    openHomePage();
    List<WebElement> links = driver.findElements(By.xpath("//head/link[@src]"));
    shouldBeValidLinks(links, "Found bad links in head link tags");
  }

  @Test
  public void testAllBodyLinks() {
    openHomePage();
    List<WebElement> links = driver.findElements(By.xpath("//a[@href!='#']"));
    shouldBeValidLinks(links, "Found bad links in body anchors");
  }
}