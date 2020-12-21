
# Was für inputs brauchen wir?!
# Output trotz Fehlermeldung (Alles bis Fehlermeldung)

# Möglichkeit Output zu bestehendem Output zu attachen (falls Abbruch durch Fehlermeldung)
# Falls attachment dataframe angegeben, Start automatisch ab nächster Url

# Warnung bei großer Anzahl Urls -> Zeitabschätzung

# Error wenn zu viele leere
# Error wenn nicht alle XPaths


###----------------------------------------------------------------


# Importing dependencies with roxygen2
#' @import xml2
#' @import rvest
#' @import stringr
#' @import tibble





### Function --------------------

scrapeArchiveUrls <- function(Urls, Xpaths, startnum = 1, attachto = NaN, archiveDate = F, ignoreErrors = F, stopatempty = T, emptylim = 10) {

  #### A priori consistency checks

  # Urls müssen mit http anfangen
  if(!any(stringr::str_detect(Urls, "http.?\\:\\/\\/web\\.archive\\.org"))) stop ("Urls do not originate from the Internet Archive. Please use the retrieveArchiveLinks function to obtain Urls from the Internet Archive.")

  # Xpath vector sollte Namen haben
  if(is.null(names(Xpaths))) stop ("Please provide a named vector of Xpaths")

  # attachto muss output der selben Funktion sein
  if(!is.nan(attachto) & rownames(attachto)!= c("Urls", names(Xpaths), "progress")) stop ("attachto must be a failed output of this function.")

  if(!is.nan(attachto) & attachto$Urls != Urls) stop ("Input Urls and Urls in attachto file differ. Please note that the attachto file can only be used for attaching failed output from the same function.")

  #### Main function

  # Generate list for output
  scrapedUrls <- vector(mode = "list", length = length(Urls))


  #Progress bar
  pb <- txtProgressBar(min = 0, max = length(Urls), style = 3)



  # Start if attachto is used
  if(!is.nan(attachto)) {
    startnum <- sum(attachto$progress) + 1

    scrapedUrls <- split(attachto[1:sum(attachto$progress), 2:(ncol(attachto)-1)], seq(1:sum(attachto$progress)))
    length(scrapedUrls) <- length(Urls)
  }


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

        cnames <- seq(1:length(Xpaths))
        cnames <- paste0("Xpath", cnames)
        cnames[names(Xpaths)!=""] <- names(Xpaths)[names(Xpaths)!=""]

        colnames(data) <- cnames



        scrapedUrls[[i]] <- data

        # Counter for empty outputs in a row
        if (i == 1) counter <- 0

        if (sum(stringr::str_length(data) == 0) == ncol(data)) {
          counter <-  counter + 1
        } else {
          counter <- 0
        }


      },
      error=function(e){cat("ERROR :", conditionMessage(e), "\n")})

    # Stop if non-matching number of paths could be extracted
    if ((sum(stringr::str_length(scrapedUrls[[i]][1:length(Xpaths)]) == 0) != 0) & (sum(stringr::str_length(scrapedUrls[[i]][1:length(Xpaths)]) == 0) != length(Xpaths)) & (ignoreErrors == F)) {

      # Preliminary output
      predata <- do.call("rbind", scrapedUrls)
      addempty <- data.frame(matrix(nrow = length(Urls)-i, ncol = ncol(predata)))
      names(addempty) <- names(predata)

      predata <- rbind(predata, addempty)

      output <- tibble::tibble(Urls, predata, progress = 0)
      output$progress[1:(i-1)] <- 1

      warning(paste0("Error in scraping of Url ", i, " '", Urls[i], "'. Only some of your Paths could be extracted. A preliminary output has been printed."))
      return(output)
    }



    # Stop if too many empty outputs in a row
    if (counter >= emptylim & stopatempty == T & ignoreErrors == F) {

      # Preliminary output
      predata <- do.call("rbind", scrapedUrls)
      addempty <- data.frame(matrix(nrow = length(Urls)-i, ncol = ncol(predata)))
      names(addempty) <- names(predata)

      predata <- rbind(predata, addempty)

      output <- tibble::tibble(Urls, predata, progress = 0)
      output$progress[0:(i-emptylim)] <- 1

      warning(paste0("Error in scraping of Url ", i, " '", Urls[i], "'. Too many empty outputs in a row. A preliminary output has been printed."))
      return(output)
    }

    # Progress message
    setTxtProgressBar(pb, i)

  }




  # Generate output dataframe
  output <- do.call("rbind", scrapedUrls)
  output <- tibble::tibble(Urls, output)

  if (archiveDate == T){
    output$archiveDate <- anytime::anydate(stringr::str_extract(output$Urls, "(?<=\\:\\/\\/web\\.archive\\.org\\/web\\/)[0-9]{8}"))
  }

  #### A posteriori consistency checks







  #### Return output
 return(output)
}




# Testing
#load("L:/Hiwi/Marcel/Webscraping/Raw Data/fullUrls/IT/corriere/corriere_2020-5.RData")

#test <- data[1:10]

#scrapeArchiveUrls(test, Xpaths = c(title = "//h2", content = "//p"), emptylim = 2, ignoreErrors = T)




