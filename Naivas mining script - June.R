setwd("C:/Users/User/Onedrive/Desktop/Webscrapping/")
getwd()

library(tidyverse)  # data wrangling
library(RSelenium)  # activate Selenium server
library(rvest)      # web scrape tables
library(netstat)    # find unused port
library(data.table) # for the rbindlist function
library(robotstxt)   #robots 
library(xlsx)        #writing xlsx files
library("dplyr")

robotstxt::paths_allowed("https://naivas.online")

rD <- rsDriver(browser="firefox", port=4557L, verbose=F, chromever = NULL)

remDr <- rD$client

remDr$open()
remDr$navigate("https://naivas.online/corn-oil")

#Find in the css enviroment the body   
scroll_d <- remDr$findElement(using = "css", value = "body")


h <- read_html(remDr$getPageSource()[[1]])

#Extract name, price, description
Product_name<- h %>% html_nodes(".product-name a") %>% html_text()
str(Product_name)


Product_price<- h %>% html_nodes(".product-price") %>% html_text()
str(Product_price)

Product_description<- h %>% html_nodes(".product-name a") %>% html_text()
str(Product_description)

pattern <- "(\\d+\\s*[a-zA-Z]+)"
units <- str_extract(Product_description, pattern)

css_selector <- "div:not(.product-list-margin)"

Naivas_cornoil<- data.frame(Name=Product_name,Product_price,Product_description,units)

# Define the folder name
folder_name<- "Naivas"

# Define the file path
file_path<- file.path(folder_name, "Naivas Corn oil 25th March.xlsx")

# Check if the folder exists. If not, create it.
if (!dir.exists(folder_name)) {
  dir.create(folder_name)
}

# Write the Excel file in the folder
write.xlsx(Naivas_cornoil, file_path)



remDr$close()
rD$server$stop()
rm(rD, remDr)
gc()

