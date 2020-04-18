:*:[xx:
wb := ComObjCreate("InternetExplorer.Application")
wb.Visible := True
wb.Navigate("www.someVendor.com")

driver:= ComObjCreate("Selenium.ChromeDriver") ;Chrome driver
driver.Get("http://www.baidu.com")