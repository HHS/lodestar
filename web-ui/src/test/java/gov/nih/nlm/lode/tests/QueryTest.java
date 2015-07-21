package gov.nih.nlm.lode.tests;

import java.util.List;
import java.util.ArrayList;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.By;
import org.testng.annotations.Test;
import org.testng.Reporter;

import static org.testng.Assert.*;
import static org.hamcrest.CoreMatchers.*;
import static org.hamcrest.MatcherAssert.assertThat;

import gov.nih.nlm.occs.selenium.SeleniumTest;

public class QueryTest extends LodeBaseTest {

    public static final String FOR_LODESTAR_RESULT_ROWS = "//table[@id='lodestar-results-table']/tbody/tr";
    public static final String[] MESH_VOCAB_CLASSES = {
        "meshv:AllowedDescriptorQualifierPair",
        "meshv:CheckTag",
        "meshv:Concept",
        "meshv:DisallowedDescriptorQualifierPair",
        "meshv:GeographicalDescriptor",
        "meshv:PublicationType",
        "meshv:Qualifier",
        "meshv:SCR_Chemical",
        "meshv:SCR_Disease",
        "meshv:SCR_Protocol",
        "meshv:Term",
        "meshv:TopicalDescriptor",
        "meshv:TreeNumber"
    };

    public void clickSubmitQuery() {
        // submit the query form
        WebElement button = findElement(By.xpath("//input[@type='button'][@value='Submit Query']"));
        button.click();  
    }

    public void clickResetQuery() {
        // submit the query form
        WebElement button = findElement(By.xpath("//input[@type='button'][@value='Reset']"));
        button.click();  
    }

    public void clickOptionWithinSelect(String selectId, String optionValue) {
        String expression = String.format("//select[@id='%s']/option[@value='%s']", selectId, optionValue);
        WebElement option = findElement(By.xpath(expression));
        option.click();
    }

    public void clickOnExampleQuery(int whichQuery) {
        WebElement queries = findElement(By.id("queries_list"));
        String expression = String.format("li/a[@id='%d']", whichQuery);
        WebElement example = queries.findElement(By.xpath(expression));
        example.click();
    }

    @Test
    public void testDefaultOptions() {
        openQueryPage();
        clickSubmitQuery();

        List<WebElement> rows = findElements(By.xpath(FOR_LODESTAR_RESULT_ROWS));
        assertEquals(rows.size(), MESH_VOCAB_CLASSES.length);
        for (int i = 0; i < rows.size(); i++) {
            WebElement row = rows.get(i);
            WebElement link = row.findElement(By.xpath("td[1]/span/a"));
            String expectedEnding = MESH_VOCAB_CLASSES[i].replace("meshv:", "%2Fmesh%2Fvocab%23");

            assertThat(link.getText(), is(equalTo(MESH_VOCAB_CLASSES[i])));
            assertThat(link.getAttribute("href"), endsWith(expectedEnding));
        }
    }

    public void testExample0() {
        openQueryPage();
        clickOnExampleQuery(0);
        clickSubmitQuery();

        List<WebElement> rows = findElements(By.xpath(FOR_LODESTAR_RESULT_ROWS));
        assertEquals(rows.size(), MESH_VOCAB_CLASSES.length);
        for (int i = 0; i < rows.size(); i++) {
            WebElement row = rows.get(i);
            WebElement link = row.findElement(By.xpath("td[1]/span/a"));
            String expectedEnding = MESH_VOCAB_CLASSES[i].replace("meshv:", "%2Fmesh%2Fvocab%23");

            assertThat(link.getText(), is(equalTo(MESH_VOCAB_CLASSES[i])));
            assertThat(link.getAttribute("href"), endsWith(expectedEnding));
        }
    }

    public void testExample2() {
        openQueryPage();

        // click on 2nd example query
        clickOnExampleQuery(2);

        // select options
        clickOptionWithinSelect("year", "current");
        clickOptionWithinSelect("render", "HTML");
        clickOptionWithinSelect("limit", "50");

        // submit the query form
        clickSubmitQuery();

        // verify results without depending on order
        List<WebElement> rows = findElements(By.xpath(FOR_LODESTAR_RESULT_ROWS));
        assertEquals(rows.size(), 4);
        for (WebElement row : rows) {
            WebElement pa = row.findElement(By.xpath("td[1]/span/a"));
            String patext = pa.getText();
            if (patext.equals("mesh:D000892")) {
                assertThat(pa.getAttribute("href"), endsWith("/D000892"));
                assertEquals(row.findElement(By.xpath("td[2]")).getText(), "Anti-Infective Agents, Urinary");
            } else if (patext.equals("mesh:D000900")) {
                assertThat(pa.getAttribute("href"), endsWith("/D000900"));
                assertEquals(row.findElement(By.xpath("td[2]")).getText(), "Anti-Bacterial Agents");
            } else if (patext.equals("mesh:D059005")) {
                assertThat(pa.getAttribute("href"), endsWith("/D059005"));
                assertEquals(row.findElement(By.xpath("td[2]")).getText(), "Topoisomerase II Inhibitors");
            } else if (patext.equals("mesh:D065609")) {
                assertThat(pa.getAttribute("href"), endsWith("/D065609"));
                assertEquals(row.findElement(By.xpath("td[2]")).getText(), "Cytochrome P-450 CYP1A2 Inhibitors");
            } else {
                Reporter.log("Unexpected pharmalogical action on query 2", true);
                fail("Unexpected pharmalogical aciton on query 2");
            }
        }
    }

    @Test
    public void testExample3with2015() {
        openQueryPage();

        clickOnExampleQuery(3);
        clickOptionWithinSelect("year", "2015");
        clickOptionWithinSelect("render", "HTML");
        clickOptionWithinSelect("limit", "50");

        clickSubmitQuery();

        // verify results without depending on order
        List<WebElement> rows = findElements(By.xpath(FOR_LODESTAR_RESULT_ROWS));
        assertEquals(rows.size(), 50);
        for (WebElement row : rows) {
            WebElement desc = row.findElement(By.xpath("td[1]/span/a"));
            WebElement dlabel = row.findElement(By.xpath("td[2]"));
            String dtext = desc.getText();

            if (dtext.equals("mesh2015:D019813")) {
                assertThat(desc.getAttribute("href"), endsWith("/2015/D019813"));
                assertThat(dlabel.getText(), equalTo("1,2-Dimethylhydrazine"));          
            } else if (dtext.equals("mesh2015:D020001")) {
                assertThat(desc.getAttribute("href"), endsWith("/2015/D020001"));
                assertThat(dlabel.getText(), equalTo("1-Butanol"));       
            } else if (dtext.equals("mesh2015:D015068")) {
                assertThat(desc.getAttribute("href"), endsWith("/2015/D015068"));
                assertThat(dlabel.getText(), equalTo("17-Ketosteroids"));
            }
        }
    }

    @Test(dependsOnMethods={"testExample3with2015"})
    public void testPagination() {
        openQueryPage();

        clickOnExampleQuery(3);
        clickOptionWithinSelect("year", "2015");
        clickOptionWithinSelect("render", "HTML");
        clickOptionWithinSelect("limit", "50");

        clickSubmitQuery();

        // Make sure next link also returns 50 results
        WebElement nextLink = findElement(By.xpath("//div[@id='pagination']/a[@class='pag next']"));
        nextLink.click();

        // should be showing offset 50
        WebElement pagemes = findElement(By.xpath("//div[@id='pagination']/span[@class='pag pagmes']"));
        assertEquals(pagemes.getText(), "50 results per page (offset 50)");

        // should again be 50 results (which we verify selectively)
        List<WebElement> page2rows = findElements(By.xpath(FOR_LODESTAR_RESULT_ROWS));
        assertEquals(page2rows.size(), 50);
        for (WebElement row : page2rows) {
            WebElement desc = row.findElement(By.xpath("td[1]/span/a"));
            WebElement dlabel = row.findElement(By.xpath("td[2]"));
            String dtext = desc.getText();
            
            if (dtext.equals("mesh2015:D008456")) {
                assertThat(desc.getAttribute("href"), endsWith("/2015/D008456"));
                assertThat(dlabel.getText(), equalTo("2-Methyl-4-chlorophenoxyacetic Acid"));
            } else if (dtext.equals("mesh2015:D019840")) {
                assertThat(desc.getAttribute("href"), endsWith("/2015/D019840"));
                assertThat(dlabel.getText(), equalTo("2-Propanol"));
            }
        }

        // Go to previous page
        WebElement prevLink = findElement(By.xpath("//div[@id='pagination']/a[@class='pag prev']"));
        prevLink.click();

        // should be showing offset 0
        pagemes = findElement(By.xpath("//div[@id='pagination']/span[@class='pag pagmes']"));
        assertEquals(pagemes.getText(), "50 results per page (offset 0)");

        List<WebElement> page1rows = findElements(By.xpath(FOR_LODESTAR_RESULT_ROWS));
        assertEquals(page1rows.size(), 50);
        for (WebElement row : page1rows) {
            WebElement desc = row.findElement(By.xpath("td[1]/span/a"));
            WebElement dlabel = row.findElement(By.xpath("td[2]"));
            String dtext = desc.getText();

            if (dtext.equals("mesh2015:D019813")) {
                assertThat(desc.getAttribute("href"), endsWith("/2015/D019813"));
                assertThat(dlabel.getText(), equalTo("1,2-Dimethylhydrazine"));          
            } else if (dtext.equals("mesh2015:D020001")) {
                assertThat(desc.getAttribute("href"), endsWith("/2015/D020001"));
                assertThat(dlabel.getText(), equalTo("1-Butanol"));       
            } else if (dtext.equals("mesh2015:D015068")) {
                assertThat(desc.getAttribute("href"), endsWith("/2015/D015068"));
                assertThat(dlabel.getText(), equalTo("17-Ketosteroids"));
            }
        }
    }

    @Test(dependsOnMethods={"testExample3with2015"})
    public void testLimitRows() {
        openQueryPage();

        clickOnExampleQuery(3);
        clickOptionWithinSelect("year", "2015");
        clickOptionWithinSelect("render", "HTML");
        clickOptionWithinSelect("limit", "25");

        clickSubmitQuery();

        // should be showing offset 0
        WebElement pagemes = findElement(By.xpath("//div[@id='pagination']/span[@class='pag pagmes']"));
        assertEquals(pagemes.getText(), "25 results per page (offset 0)");

        // verify results without depending on order
        List<WebElement> rows = findElements(By.xpath(FOR_LODESTAR_RESULT_ROWS));
        assertEquals(rows.size(), 25);
        for (WebElement row : rows) {
            WebElement desc = row.findElement(By.xpath("td[1]/span/a"));
            WebElement dlabel = row.findElement(By.xpath("td[2]"));
            String dtext = desc.getText();

            if (dtext.equals("mesh2015:D019813")) {
                assertThat(desc.getAttribute("href"), endsWith("/2015/D019813"));
                assertThat(dlabel.getText(), equalTo("1,2-Dimethylhydrazine"));          
            } else if (dtext.equals("mesh2015:D020001")) {
                assertThat(desc.getAttribute("href"), endsWith("/2015/D020001"));
                assertThat(dlabel.getText(), equalTo("1-Butanol"));       
            } else if (dtext.equals("mesh2015:D015068")) {
                assertThat(desc.getAttribute("href"), endsWith("/2015/D015068"));
                assertThat(dlabel.getText(), equalTo("17-Ketosteroids"));
            }
        }
    }
}
