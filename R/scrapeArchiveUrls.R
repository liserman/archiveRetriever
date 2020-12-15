
# Was für inputs brauchen wir?!
# Output als dataframe: Url, String_XPath1, String_XPath2, ..., String_XPathN, Date
# Output trotz Fehlermeldung (Alles bis Fehlermeldung)
# Möglichkeit Output zu bestehendem Output zu attachen (falls Abbruch durch Fehlermeldung)
# Falls attachment dataframe angegeben, Start automatisch ab nächster Url

# Warnung bei großer Anzahl Urls -> Zeitabschätzung
# Möglichkeit Artikel einzeln in Ordner abzuspeichern

# MÖglichkeit verschiedene Xpaths für unterschiedliche Zeiträume anzugeben


###----------------------------------------------------------------


# Importing dependencies with roxygen2
#' @import xml2
#' @import rvest







### Function --------------------

scrapeArchiveUrls <- function(Urls, XpathHeader, XpathContent, startnum = 1, attachto = NaN) {

  #### A priori consistency checks

  # Urls müssen mit http anfangen
  if(!any(stringr::str_detect(Urls, "http\\:\\/\\/web\\.archive\\.org"))) stop ("Urls do not originate from the Internet Archive. Please use the retrieveArchiveLinks function to obtain Urls from the Internet Archive.")




  #### Main function

  # Generate list for output
  scrapedUrls <- vector(mode = "list", length = length(Urls))

  #Progress bar
  pb <- txtProgressBar(min = 0, max = length(Urls), style = 3)

  # Loop over all Urls
  for (i in startnum:length(Urls)) {

    # Scrape page, using rvest
    tryCatch(
      {
        html <- xml2::read_html(Urls[i])

        if(missing(XpathHeader)){

          for (x in 1:length(XpathContent)){
            #Extract nodes
            dataContent <- rvest::html_nodes(html, xpath = XpathContent[x])
            dataContent <- rvest::html_text(dataContent)
            dataContent <- paste(dataContent, collapse = ' ')
          }



          data <- tibble::tibble(content = dataContent)

        }

        if(!missing(XpathHeader)){
          #Extract nodes
          for (x in 1:length(XpathHeader)) {
            dataHeader <- rvest::html_nodes(html, xpath = XpathHeader[x])
            dataHeader <- rvest::html_text(dataHeader)
          }

          for (x in 1:length(XpathContent)){
            dataContent <- rvest::html_nodes(html, xpath = XpathContent[x])
            dataContent <- rvest::html_text(dataContent)
            dataContent <- paste(dataContent, collapse = ' ')
          }


          data <- tibble::tibble(header = dataHeader, content = dataContent)
        }


        scrapedUrls[[i]] <- data

      },
      error=function(e){cat("ERROR :", conditionMessage(e), "\n")})

    # Progress message
    setTxtProgressBar(pb, i)

  }


  # Can only take (output) one XPath at the moment, needs to be rewritten to be able to handle several XPaths
  # Data cleaning and processing missing












  #### A posteriori consistency checks







  #### Return output
 return(data)
}






# Testing
#load("L:/Hiwi/Marcel/Webscraping/Raw Data/fullUrls/IT/corriere/corriere_2020-5.RData")

test <- data[1:10]

scrapeArchiveUrls(test, XpathHeader = c("//h2"))




