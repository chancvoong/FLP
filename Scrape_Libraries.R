install.packages("RSelenium", dependencies=TRUE)
install.packages("rvest")

library('RSelenium')
library('rvest')


#### CONNECTING VIA SAUCE LABS SERVER
# saucelabs.com


user <- " " # Your Sauce Labs Username
key <- " " # Your Sauce Labs password
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

remDr$navigate("https://libwww.freelibrary.org/locations/")

#create empty data frame outside of the function
allScrapedData <- data.frame(Library=character())

#Find library address value (the css selector for the table)
Address <- remDr$findElement("css selector","#branchlist")
Address$getElementText()

#Pull all addresses
allScrapedData <- c(Address$value)

#Convert to dataframe
df1 <- data.frame(allScrapedData)

#Save as csv
write.csv(df1, file = "locations.csv")

#Use Excel to remove carriage returns and replace it with commas
#Then use text to columns (comma) to divide the values
#=TRIM(SUBSTITUTE(SUBSTITUTE(B2,CHAR(13),""),CHAR(10),", ")