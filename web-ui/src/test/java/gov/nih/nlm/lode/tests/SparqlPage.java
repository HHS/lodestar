package gov.nih.nlm.lode.tests;

import org.openqa.selenium.WebElement;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.By;

import static org.hamcrest.CoreMatchers.*;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.testng.Assert.*;

import gov.nih.nlm.occs.selenium.SeleniumBase;

public class SparqlPage extends SeleniumBase {
    public static final String URI = "/sparql";

    public SparqlPage(WebDriver driver) {
        setDriver(driver);
    }
}

