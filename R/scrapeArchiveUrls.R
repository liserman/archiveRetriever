
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
#' @import stringr
#' @import tibble





### Function --------------------

scrapeArchiveUrls <- function(Urls, Xpaths, startnum = 1, attachto = NaN) {

  #### A priori consistency checks

  # Urls müssen mit http anfangen
  if(!any(stringr::str_detect(Urls, "http\\:\\/\\/web\\.archive\\.org"))) stop ("Urls do not originate from the Internet Archive. Please use the retrieveArchiveLinks function to obtain Urls from the Internet Archive.")

  # Xpath vector sollte Namen haben
  if(is.null(names(Xpaths))) stop ("Please provide a named vector of Xpaths")


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

        data <- list()
          #Extract nodes
          for (x in 1:length(Xpaths)) {
            data[[x]] <- rvest::html_nodes(html, xpath = Xpaths[x])
            data[[x]] <- rvest::html_text(data[[x]])
            data[[x]] <- paste(data[[x]], collapse = ' ')
          }

        data <- as.data.frame(data)
        colnames(data) <- names(Xpaths)



        scrapedUrls[[i]] <- data

      },
      error=function(e){cat("ERROR :", conditionMessage(e), "\n")})

    # Progress message
    setTxtProgressBar(pb, i)

  }




  # Generate output dataframe
  output <- do.call("rbind", scrapedUrls)
  output <- tibble::tibble(Urls, output)



  #### A posteriori consistency checks







  #### Return output
 return(output)
}






# Testing
# load("L:/Hiwi/Marcel/Webscraping/Raw Data/fullUrls/IT/corriere/corriere_2020-5.RData")

# test <- data[1:10]

# scrapeArchiveUrls(test, Xpaths = c(title = "//h2", content = "//p"))




