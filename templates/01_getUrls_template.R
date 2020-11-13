# TEMPLATE 01: GET URLS + SUBSET TO MONTHS  

############################################################
# INSTRUCTIONS:                                            #
#                                                          #
#   - set timeframe [23-24]                                #
#   - set websites of interest [27]                        #
#   - set output directory [30]                            #
#                                                          #
############################################################

# Load packages (make sure packages are installed!)
library(stringr)
library(tidyverse)
library(jsonlite)
library(httr)
library(rvest)
library(lubridate)

rm(list = ls())

# Timeframe
from <- "201907"  # Year-Month
to <- "202005"

# Set websites
websites <- c("www.krone.at", "www.derstandard.at", "www.diepresse.com")

# Set working directory
output <- "/home/ubuntu/Scraping/AT"





#------------------ NO CHANGES NEEDED FROM HERE --------------------------------------

# Extract webpages and endings seperately
page <- c()
for (i in 1:length(websites)) {
  p <- regmatches(websites[i], regexec('www.(.*?)\\.', websites[i]))
  page[i] <- p[[1]][2]
}
ending <- str_remove_all(websites, "www.")
ending <- str_remove_all(ending, page)


url <- paste0("http://web.archive.org/cdx/search/cdx?url=",websites,"&matchType=url&&collapse=timestamp:8&limit=15000&filter=!mimetype:image/gif&filter=!mimetype:image/jpeg&from=", from, "&to=", to, "&output=json&limit=1")

url_from_json <- list()

for(n in 1:length(websites)) {
  tryCatch({
    url_from_json[[n]] <- as.data.frame(fromJSON(url[n]))
    
    names(url_from_json[[n]]) <- lapply(url_from_json[[n]][1,], as.character)
    
    url_from_json[[n]] <- url_from_json[[n]][-1,]
    
    print(n)
  }, error=function(e){cat("ERROR :", conditionMessage(e), "\n")})
}


homepages <- list()


for (n in 1:length(websites)) {
  tryCatch({
    homep <- c()
    for (i in 1:nrow(url_from_json[[n]])) {
      homep[i] <- paste0("http://web.archive.org/web/", url_from_json[[n]][i,2], "/", url_from_json[[n]][i,3])
    }
    homepages[[n]] <- homep
    print(n)
  }, error=function(e){cat("ERROR :", conditionMessage(e), "\n")})
}


for(n in 1:length(websites)) {
  
  tryCatch({
    
    fullUrls <- list()
    
    for(i in 1:length(homepages[[n]])){
      possibleError <- tryCatch(
        r <- GET(homepages[[n]][i]),
        error = function(e) e
      )
      
      if(inherits(possibleError, "error")) next
      
      status <- status_code(r)
      if(status == 200){
        paper_html <- read_html(homepages[[n]][i], encoding = "latin1")
        paper_urls <- paper_html %>%
          html_nodes("a") %>%
          html_attr("href") 
        paper_urls <- paper_urls[grepl(paste0(page[n],"\\", ending[n]), paper_urls)]
        
        paper_urlsFinal <- list()
        
        if(length(paper_urls)>0){
          for(j in 1:length(paper_urls)){
            if(!grepl("http://web.archive.org", paper_urls[j]) & grepl("//web.archive.org", paper_urls[j])){
              paper_urls[j] <- paste0("http:", paper_urls[j])
            }
            
            if(!grepl("http://web.archive.org", paper_urls[j])){
              paper_urlsFinal[[j]] <- paste0("http://web.archive.org", paper_urls[j])
            } else
              paper_urlsFinal[[j]] <- paper_urls[j]
          }
        }      
        
        paper_urlsFinal <- Reduce(c, paper_urlsFinal)
        
        fullUrls[[i]] <- paper_urlsFinal
        
        
        
        Sys.sleep(sample(1:5,1))
      } else{
        next
      }
      
      print(i)
      
    }
    
    
    if (is_empty(fullUrls)){
      print(paste0(websites[n], " Failed"))
    } else {
      setwd(output)
      save("fullUrls", file = paste0("fullUrls_", page[n], ".RData"))
      print(n)
    }
    
  }, error=function(e){cat("ERROR :", conditionMessage(e), "\n")})
  


######### Subsetting

  
  fullUrlsComplete <- Reduce(c, fullUrls)
  
  
  # Subsetting by timeframe
  
  date <- str_extract(fullUrlsComplete, "[:digit:]{14}")
  date <- as.numeric(str_sub(date, 1, 8))
  year <- as.numeric(str_sub(date, 1, 4))
  year <- year[!is.na(year)]
  month <- as.numeric(str_sub(date, 5, 6))
  month <- month[!is.na(month)]
  
  setwd(output)
  
  for(y in min(year):max(year)) {
    for(m in 1:12) {
      
      data <- fullUrlsComplete[year == y & month == m]
      
      if (is_empty(data)) {
        rm(data)
        next
      }
      else {
        save(data, file = paste0(page[n], "_", y, "-", m, ".RData"), version = 2)
        rm(data)
      }
    }
  }
  setwd(output)
  
  rm(fullUrls, fullUrlsComplete, date, month, year)
}



