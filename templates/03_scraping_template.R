# TEMPLATE 03: SCRAPING

############################################################
# INSTRUCTIONS:                                            #
#                                                          #
#   - set Startpoint and Endpoint [32-35]                  #
#   - set paper and homepage ending [38-41]                #
#   - set article path and title path [57-59]              #
#   - set working directory [63-66]                        #
#                                                          #
############################################################

rm(list=ls())

# Load packages
library(stringr)
library(tidyverse)
library(Rcrawler)
library(httr)
library(rvest)
library(lubridate)
library(pushoverr)

# Set pushover message for Konstantin
set_pushover_user(user = "unhfoc7i8oasiequuxs27dje3zkz1p")
set_pushover_app(token = "aw1ciyv4dzmn7ba6wtcrjp3ai2oans")


#_____General settings____________________________________________________#

# Startpoint ------------------ Change here!
startnum <- 1
startmonth <- 201907
endmonth <- 202005


# Set newspaper --------------- Change here!
paper <- "berlingske"
ending <- ".dk"
country <- "DK"


# Set timeframe (one observation per month)
year <- rep(as.numeric(substring(startmonth, 1, 4)):as.numeric(substring(endmonth, 1, 4)), each = 12)
month <- rep(seq(1,12,1), times = as.numeric(substring(endmonth, 1, 4))-as.numeric(substring(startmonth, 1, 4))+1)
d <- (year * 100) + month
year <- year[d>=startmonth & d<=endmonth]
month <- month[d>=startmonth & d<=endmonth]
d <- d[d>=startmonth & d<=endmonth]


# Set article and title paths by timeframe
titlepath <- vector("character", length = length(d))
articlepath <- vector("character", length = length(d))


#Paths ------------------------ Change here!
titlepath[d>201906] <- "//h1[@class='article-header__title']"
articlepath[d>201906] <- "//*[@class = 'article-body']//p"


# Define overall working directory and create folders
wd <- paste0("/home/ubuntu/Scraping/",country,"/")
wdOut <- paste0("/home/ubuntu/database/",country,"/", paper)

dir.create(paste0("/home/ubuntu/database/", country), showWarnings = F)
dir.create(wdOut, showWarnings = FALSE)





#------------------ NO CHANGES NEEDED FROM HERE --------------------------------------

# Create directories
for (i in 1:length(unique(year))) {
dir.create(paste0(wdOut, "/", unique(year)[i]), showWarnings = F)  
}

httr::set_config(httr::config(http_version = 0))


# Get index of startmonth
st <- match(startmonth, d)


# Create dataDump
directory <- paste0(wd, "/dataDump_", paper)
dir.create(directory, showWarnings = FALSE)



#--- LOOP ----------------

for (t in st:length(year)) {
  
  # Set working directory and read data
  setwd(wd)
  tryCatch({
    load(paste0(paper, "_", year[t], "-", month[t], ".RData"))
  }, error=function(e){cat("ERROR :", conditionMessage(e), "\n")})
  
  if(t>st){
    startnum <- 1
  }
  
  # RCrawler
  for(i in startnum:length(data)){
    setwd(directory)
    tryCatch({
      Rcrawler(data[i], MaxDepth = 0, ExtractXpathPat = c(titlepath[t], articlepath[t]), no_cores = 1, no_conn = 1,ManyPerPattern=TRUE)
    }, error=function(e){cat("ERROR :", conditionMessage(e), "\n")})
    
    cat(paste0("Timeframe ", year[t], "-", month[t], "\n", "Already ", i, " sites scraped. There are ", length(data) - i , " sites left to scrape"))
    
    if(exists("DATA")){
      #restructure data list
      dat <- DATA %>% 
        map_df(enframe) %>% 
        unnest() %>% 
        group_by(name) %>% 
        summarise(value = paste(value,collapse = ""))%>%
        mutate(Id = rep(1:nrow(INDEX), each = 2)) %>% 
        arrange(name) %>% 
        spread(name, value) %>% 
        rename(title = `1`, article = `2`)
      
      #extract date of article and broader area (sports, politics etc...)
      INDEX <- INDEX %>% 
        mutate(Id = as.numeric(Id),
               date = str_match(Url,"/web/(\\w+?)/")[,2],
               date = parse_datetime(str_sub(date, 1, 8), "%Y%m%d")
        ) %>% 
        as.tibble()
      
      #merge articles with meta data and clean up a bit
      dat_full <- INDEX %>% 
        mutate(Id = as.numeric(Id)) %>% 
        left_join(dat, by = c("Id")) %>% 
        mutate(article = str_replace_all(article, pattern = "\n", " "),
               article = str_replace_all(article, pattern = "\t", " "),
               article = str_replace_all(article, pattern = "\\s+", " ")
        )
      
      save(dat_full, file = paste0(wdOut,"/",year[t] , "/articles_", paper, year[t], "-", month[t], "-", i, ".RData"))
      
      #Remove html files to save space
      unlink(paste0(directory, "/*"), recursive = TRUE, force = TRUE)
      rm(DATA, INDEX, dat, dat_full)
    } else {
      
      unlink(paste0(directory, "/*"), recursive = TRUE, force = TRUE)
      next
    }
  
  Sys.sleep(5)    
  }
  
  Sys.sleep(10)
  #pushover(message = paste0("Der Zeitraum ", year[t], "-", month[t], " ist gescrapt!"))
  
  
  # Get rid of all objects we do not need
  rm(list=setdiff(ls(), c("paper", "ending", "year", "month", "titlepath", "articlepath", "wd","wdOut", "directory", "st", "country", "startnum")))
}
#_________________________________________________________________#

