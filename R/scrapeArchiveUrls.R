


# Warnung bei großer Anzahl Urls -> Zeitabschätzung



###----------------------------------------------------------------


# Importing dependencies with roxygen2
#' @import xml2
#' @import rvest
#' @import stringr
#' @import tibble





### Function --------------------

scrapeArchiveUrls <- function(Urls, Paths, startnum = 1, attachto = NaN, CSS = F, archiveDate = F, ignoreErrors = F, stopatempty = T, emptylim = 10) {

  #### A priori consistency checks

  # Urls müssen mit http anfangen
  if(!any(stringr::str_detect(Urls, "http.?\\:\\/\\/web\\.archive\\.org"))) stop ("Urls do not originate from the Internet Archive. Please use the retrieveArchiveLinks function to obtain Urls from the Internet Archive.")

  # Xpath vector sollte Namen haben
  if(is.null(names(Paths))) stop ("Please provide a named vector of Xpath or CSS paths")

  # attachto muss output derselben Funktion sein
  if(!is.nan(attachto)) if (rownames(attachto)!= c("Urls", names(Paths), "progress")) stop ("attachto must be a failed output of this function.")

  if(!is.nan(attachto)) if (attachto$Urls != Urls) stop ("Input Urls and Urls in attachto file differ. Please note that the attachto file can only be used for attaching failed output from the same function.")

  # Warning and wait to proceed if large number of Urls
  if (length(Urls) >= 100) {
    message("Warning: You are about to scrape the information from a large number of Urls. This process may take some time. Press \"y\" to proceed.")
    line <- readline()

    if (line != "y") {stop("Execution halted")}

  }



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

        if (CSS == T) {
          # Extract nodes
          for (x in 1:length(Paths)) {
            data[[x]] <- rvest::html_nodes(html, css = Paths[x])
            data[[x]] <- rvest::html_text(data[[x]])
            data[[x]] <- paste(data[[x]], collapse = ' ')
          }
        } else {
          # Extract nodes
          for (x in 1:length(Paths)) {
            data[[x]] <- rvest::html_nodes(html, xpath = Paths[x])
            data[[x]] <- rvest::html_text(data[[x]])
            data[[x]] <- paste(data[[x]], collapse = ' ')
          }
        }

        data <- as.data.frame(data)

        cnames <- seq(1:length(Paths))
        cnames <- paste0("Xpath", cnames)
        cnames[names(Paths)!=""] <- names(Paths)[names(Paths)!=""]

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
    if ((sum(stringr::str_length(scrapedUrls[[i]][1:length(Paths)]) == 0) != 0) & (sum(stringr::str_length(scrapedUrls[[i]][1:length(Paths)]) == 0) != length(Paths)) & (ignoreErrors == F)) {

      # Preliminary output
      predata <- do.call("rbind", scrapedUrls)
      addempty <- data.frame(matrix(nrow = length(Urls)-i, ncol = ncol(predata)))
      names(addempty) <- names(predata)

      predata <- rbind(predata, addempty)

      output <- tibble::tibble(Urls, predata, progress = 0)
      output$progress[0:(i-1)] <- 1

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

#scrapeArchiveUrls(test, Paths = c(title = "//h2", content = "//p"))




