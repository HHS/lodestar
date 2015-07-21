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
        "meshv:TreeNumber",
    };

    public static final String[][] EX2_CHECKED_RESULTS = {
        { "mesh:D000892", "/D000892", "Anti-Infective Agents, Urinary" },
        { "mesh:D000900", "/D000900", "Anti-Bacterial Agents" },
        { "mesh:D059005", "/D059005", "Topoisomerase II Inhibitors" },
        { "mesh:D065609", "/D065609", "Cytochrome P-450 CYP1A2 Inhibitors" },
    };

    public static final String[][] EX3_PAGE1_CHECKED_RESULTS = {
        { "mesh2015:D019813", "/2015/D019813", "1,2-Dimethylhydrazine" },
        { "mesh2015:D020001", "/2015/D020001", "1-Butanol" },
        { "mesh2015:D015068", "/2015/D015068", "17-Ketosteroids" },
    };

    public static final String[][] EX3_PAGE2_CHECKED_RESULTS = {
        { "mesh2015:D008456", "/2015/D008456", "2-Methyl-4-chlorophenoxyacetic Acid" },
        { "mesh2015:D019840", "/2015/D019840", "2-Propanol" },
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

    @Test(groups="query", dependsOnGroups="basics2")
    public void testDefaults() {
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

    @Test(groups="query", dependsOnMethods={"testDefaults"})
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

    @Test(groups="query", dependsOnMethods={"testDefaults"})
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

        // verify selected results without depending on order
        int numMatched = 0;
        List<WebElement> rows = findElements(By.xpath(FOR_LODESTAR_RESULT_ROWS));
        assertEquals(rows.size(), 4);
        for (WebElement row : rows) {
            WebElement link = row.findElement(By.xpath("td[1]/span/a"));
            String linktext = link.getText();

            boolean amatch = false;
            for (String expected[] : EX2_CHECKED_RESULTS) {
                String expectedLinkText = expected[0];
                String expectedLinkEnding = expected[1];
                String expectedCol2Text = expected[2];

                if (linktext.equals(expectedLinkText)) {
                    assertThat(link.getAttribute("href"), endsWith(expectedLinkEnding));
                    assertEquals(row.findElement(By.xpath("td[2]")).getText(), expectedCol2Text);
                    numMatched++;
                    amatch = true;
                }
            }
            assertTrue(amatch, "Unexpected pharmalogical action on example query 2");
        }
        assertEquals(numMatched, EX2_CHECKED_RESULTS.length);
    }

    @Test(groups="query", dependsOnMethods={"testDefaults"})
    public void testExample3with2015() {
        openQueryPage();

        clickOnExampleQuery(3);
        clickOptionWithinSelect("year", "2015");
        clickOptionWithinSelect("render", "HTML");
        clickOptionWithinSelect("limit", "50");

        clickSubmitQuery();

        // verify results without depending on order
        int numMatched = 0;
        List<WebElement> rows = findElements(By.xpath(FOR_LODESTAR_RESULT_ROWS));
        assertEquals(rows.size(), 50);
        for (WebElement row : rows) {
            WebElement desc = row.findElement(By.xpath("td[1]/span/a"));
            WebElement dlabel = row.findElement(By.xpath("td[2]"));
            String dtext = desc.getText();

            for (String expected[] : EX3_PAGE1_CHECKED_RESULTS) {
                String expectedLinkText = expected[0];
                String expectedLinkEnding = expected[1];
                String expectedCol2Text = expected[2];

                if (dtext.equals(expectedLinkText)) {
                    assertThat(desc.getAttribute("href"), endsWith(expectedLinkEnding));
                    assertEquals(dlabel.getText(), expectedCol2Text);
                    numMatched++;
                }
            }
        }
        assertEquals(numMatched, EX3_PAGE1_CHECKED_RESULTS.length);
    }

    @Test(groups="query", dependsOnMethods={"testExample3with2015"})
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
        int page2matched = 0;
        List<WebElement> page2rows = findElements(By.xpath(FOR_LODESTAR_RESULT_ROWS));
        assertEquals(page2rows.size(), 50);
        for (WebElement row : page2rows) {
            WebElement desc = row.findElement(By.xpath("td[1]/span/a"));
            WebElement dlabel = row.findElement(By.xpath("td[2]"));
            String dtext = desc.getText();

            for (String expected[] : EX3_PAGE2_CHECKED_RESULTS) {
                String expectedLinkText = expected[0];
                String expectedLinkEnding = expected[1];
                String expectedCol2Text = expected[2];

                if (dtext.equals(expectedLinkText)) {
                    assertThat(desc.getAttribute("href"), endsWith(expectedLinkEnding));
                    assertEquals(dlabel.getText(), expectedCol2Text);
                    page2matched++;
                }
            }           
        }
        assertEquals(page2matched, EX3_PAGE2_CHECKED_RESULTS.length);

        // Go to previous page
        WebElement prevLink = findElement(By.xpath("//div[@id='pagination']/a[@class='pag prev']"));
        prevLink.click();

        // should be showing offset 0
        int page1matched = 0;
        pagemes = findElement(By.xpath("//div[@id='pagination']/span[@class='pag pagmes']"));
        assertEquals(pagemes.getText(), "50 results per page (offset 0)");

        List<WebElement> page1rows = findElements(By.xpath(FOR_LODESTAR_RESULT_ROWS));
        assertEquals(page1rows.size(), 50);
        for (WebElement row : page1rows) {
            WebElement desc = row.findElement(By.xpath("td[1]/span/a"));
            WebElement dlabel = row.findElement(By.xpath("td[2]"));
            String dtext = desc.getText();

            for (String expected[] : EX3_PAGE1_CHECKED_RESULTS) {
                String expectedLinkText = expected[0];
                String expectedLinkEnding = expected[1];
                String expectedCol2Text = expected[2];

                if (dtext.equals(expectedLinkText)) {
                    assertThat(desc.getAttribute("href"), endsWith(expectedLinkEnding));
                    assertEquals(dlabel.getText(), expectedCol2Text);
                    page1matched++;
                }
            }
        }
        assertEquals(page1matched, EX3_PAGE1_CHECKED_RESULTS.length);
    }

    @Test(groups="queries", dependsOnMethods={"testExample3with2015"})
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
        int numMatched = 0;
        List<WebElement> rows = findElements(By.xpath(FOR_LODESTAR_RESULT_ROWS));
        assertEquals(rows.size(), 25);
        for (WebElement row : rows) {
            WebElement desc = row.findElement(By.xpath("td[1]/span/a"));
            WebElement dlabel = row.findElement(By.xpath("td[2]"));
            String dtext = desc.getText();

            for (String expected[] : EX3_PAGE1_CHECKED_RESULTS) {
                String expectedLinkText = expected[0];
                String expectedLinkEnding = expected[1];
                String expectedCol2Text = expected[2];

                if (dtext.equals(expectedLinkText)) {
                    assertThat(desc.getAttribute("href"), endsWith(expectedLinkEnding));
                    assertEquals(dlabel.getText(), expectedCol2Text);
                    numMatched++;
                }
            }
        }

        // NOTE: One of these checked results is passed row 25
        assertEquals(numMatched, EX3_PAGE1_CHECKED_RESULTS.length - 1);
    }
}
