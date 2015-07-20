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

public class QueryTest extends LodeBaseTest {

  @Test
  public void testQueryPageExample2() {
    openQueryPage();
    WebElement queries = findElement(By.id("queries_list"));
    WebElement ex0 = queries.findElement(By.xpath("li/a[@id='2']"));
    ex0.click();

    WebElement year_current = findElement(By.xpath("//select[@id='year']/option[@value='current']"));
    year_current.click();

    WebElement render_html = findElement(By.xpath("//select[@id='render']/option[@value='HTML']"));
    render_html.click();

    WebElement results_50 = findElement(By.xpath("//select[@id='limit']/option[@value='50']"));
    results_50.click();

    WebElement submit_btn = findElement(By.xpath("//input[@type='button'][text()='Submit Query']"));
    submit_btn.click();

    WebElement mesh_D000892_byval = findElement(By.xpath("//div[@id='lodestar-results-table']/tbody/tr/td[1]/span/a[text()='mesh:D000892']"));
    WebElement mesh_D000900_byval = findElement(By.xpath("//div[@id='lodestar-results-table']/tbody/tr/td[1]/span/a[text()='mesh:D000900']"));
  }
}