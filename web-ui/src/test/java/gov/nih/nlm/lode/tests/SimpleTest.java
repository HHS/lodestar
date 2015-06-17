package gov.nih.nlm.lode.tests;

import org.testng.annotations.Test;

import org.openqa.selenium.By;

import gov.nih.nlm.occs.selenium.SeleniumTest;

public class SimpleTest extends LodeBaseTest {

   @Test
   public void myTest() {
        HomePage page = openHomePage();
        page.titleShouldBe("MeSH Linked Data (beta)");
        page.elementShouldContain(By.xpath("//*[@id='home']/h1"), "Linked Data (beta)");
   }
}
