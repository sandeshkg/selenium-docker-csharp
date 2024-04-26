using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;

var chromeOptions = new ChromeOptions();
// remember about the necessary arguments when running inside container! 
chromeOptions.AddArguments("--headless","--disable-gpu",
    "--no-sandbox", "--disable-dev-shm-usage"); 
var i = 0;
while (true)
{
    Console.Write("Provide a version of Chrome browser you want to launch (type 'q' to quit):");
    //var input = Console.ReadLine();
    
    //if (string.Equals(input, "q", StringComparison.OrdinalIgnoreCase))
    //    break;

    //chromeOptions.BrowserVersion = input;

    //var chromeService = ChromeDriverService.CreateDefaultService();
    //chromeService.SuppressInitialDiagnosticInformation = true;

    try
    {
        //var driver = new ChromeDriver(chromeService,chromeOptions);
        
        var driver = new ChromeDriver(chromeOptions);

        driver.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(5);

        driver.Navigate().GoToUrl("https://www.whatsmybrowser.org/");
        Console.WriteLine(driver.FindElement(By.TagName("h2")).Text);
        
        ITakesScreenshot screenshot = driver as ITakesScreenshot;
        Screenshot ss1 = screenshot.GetScreenshot();

        ss1.SaveAsFile(@"/app/ss1.png");

        driver.Quit();
    }
    catch (Exception e)
    {
        Console.WriteLine(e);
    }

    var input = Console.ReadLine();

    i++;
    if (i > 10)
        break;
}