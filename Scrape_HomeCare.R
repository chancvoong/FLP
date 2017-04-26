install.packages("RSelenium", dependencies=TRUE)
install.packages("rvest")

library('RSelenium')
library('rvest')


#### CONNECTING VIA SAUCE LABS SERVER
# saucelabs.com


user <- "chancvoong" # Your Sauce Labs Username
key <- "c6ba611d-9e99-48a8-9762-1f95f4b92a24" # Your Sauce Labs password
port <- 80
ip <- paste0(user, ':', key, "@ondemand.saucelabs.com")
rdBrowser <- "chrome" #The brower, version and platform here were chosen arbitrarily. Choose another if you want: https://saucelabs.com/platforms
version <- "33"
platform <- "Windows 10"
extraCapabilities <- list(name = "RSelenium", username = user
                          , accessKey = key, tags = list("RSelenium-vignette", "OS/Browsers-vignette"))
remDr <- remoteDriver$new(remoteServerAddr = ip, port = port, browserName = rdBrowser
                          , version = version, platform = platform
                          , extraCapabilities = extraCapabilities)


#Launch the browser (every time it times out, open the remDr again)
remDr$open()

remDr$navigate("https://www.compass.state.pa.us/Compass.web/ProviderSearch/Home#/BasicSearch")

#create empty data frame outside of the function
allScrapedData <- data.frame(HomeCare=character())

#Find the address box and enter your search criteria
Address <- remDr$findElement("css selector","#address-basic")
Addr <- "Philadelphia"
Address$sendKeysToElement(list(Addr, ''))
Address$sendKeysToElement(list(key = 'tab'))

#notice that you can use xpath or css to find the element -- consider quotes
#Find the Children's Ages box and check at least one box
Unit <- remDr$findElement("css selector","#address-carelevel > a")
Unit$sendKeysToElement(list(key = 'enter'))

#use xpath or css to find the element
#Select children's ages 0-5
UTO <- remDr$findElement("xpath","//*[@id='address-carelevelUTO']")
UTO$clickElement()

#Checking each of the boxes indicates "and" instead of "or"
#The data was run by checking each box, writing a csv for each,
#combining the data and then removing duplicates

TOT <- remDr$findElement("xpath","//*[@id='address-carelevelTOT']")
TOT$clickElement()

ONE <- remDr$findElement("xpath","//*[@id='address-carelevelONE']")
ONE$clickElement()

TWO <- remDr$findElement("xpath","//*[@id='address-carelevelTWO']")
TWO$clickElement()

THREE <- remDr$findElement("xpath","//*[@id='address-carelevelTHREE']")
THREE$clickElement()

FOU <- remDr$findElement("xpath","//*[@id='address-carelevelFOU']")
FOU$clickElement()

FIV <- remDr$findElement("xpath","//*[@id='address-carelevelFIV']")
FIV$clickElement()

#Click enter -- will take a few minutes to load
Address$sendKeysToElement(list(key = 'enter'))

#--------------------------------------------------------------------------------------
#This code takes the entire results list and exports it to Excel csv for further cleaning

#Find library address value (the css selector for the table)
HomeCare <- remDr$findElement("css selector","#results-list")
HomeCare$getElementText()

#Pull all addresses
allScrapedData <- c(HomeCare$value)

#Convert to dataframe
df1 <- data.frame(allScrapedData)

#Save as csv
write.csv(df1, file = "locations.csv")

#Use Excel to remove carriage returns and replace it with commas
#Then use text to columns (comma) to divide the values
#=TRIM(SUBSTITUTE(SUBSTITUTE(B2,CHAR(13),""),CHAR(10),", ")


#--------------------------------------------------------------------------------------