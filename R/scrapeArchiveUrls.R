
# Was für inputs brauchen wir?!
# Output als dataframe: Url, String_XPath1, String_XPath2, ..., String_XPathN, Date
# Output trotz Fehlermeldung (Alles bis Fehlermeldung)
# Möglichkeit Output zu bestehendem Output zu attachen (falls Abbruch durch Fehlermeldung)
# Falls attachment dataframe angegeben, Start automatisch ab nächster Url

# Warnung bei großer Anzahl Urls -> Zeitabschätzung
# Möglichkeit Artikel einzeln in Ordner abzuspeichern

# MÖglichkeit verschiedene Xpaths für unterschiedliche Zeiträume anzugeben


scrapeArchiveUrls <- function(Urls, Xpaths = "//h1", startnum = 1, attachto = NaN) {
  
  #### A priori consistency checks
  
  # Urls müssen mit http anfangen
  
  
  
  #### Main function
  
  # Generate list for output
  scrapedUrls <- vector(mode = "list", length = length(Urls))
  
  # Loop over all Urls
  for (i in startnum:length(Urls)) {
    
    # Scrape page, using rvest
    tryCatch(
      {
        html <- Urls[i] %>% 
          read_html()
      }, 
      error=function(e){cat("ERROR :", conditionMessage(e), "\n")})
    
    #Extract nodes
    data <- html %>% 
      html_nodes(xpath = Xpaths) %>% 
      html_text()
    
    
    # Progress message
    if(length(Urls)>1){
    cat(paste0(i, " of ", length(Urls), " Urls scraped, ", (length(Urls)-i), " Urls left to go\n"))
    }
      
  }
  
  
  # Can only take (output) one XPath at the moment, needs to be rewritten to be able to handle several XPaths
  # Data cleaning and processing missing
  
  
  
  
  
  
  
  
  
  
  
  
  #### A posteriori consistency checks
  
  
  
  
  
  
  
  #### Return output
 return(data) 
}






# Testing
load("L:/Hiwi/Marcel/Webscraping/Raw Data/fullUrls/IT/corriere/corriere_2020-5.RData")



scrapeArchiveUrls(test, Xpaths = c("(//h1)[1]", "//h2"))




