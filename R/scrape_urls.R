#' scrape_urls: Scraping Urls from the Internet Archive
#'
#' `scrape_urls` scrapes Urls of mementos and lower-level web pages stored in the Internet Archive using XPaths as default
#'
#' @param Urls A character vector of the memento of the Internet Archive
#' @param Paths A named character vector of the content to be scraped from the memento. Takes XPath expressions as default.
#' @param startnum Specify the starting number for scraping the Urls. Important when scraping breaks during process.
#' @param attachto Scraper attaches new content to existing object in working memory. Object should stem from same scraping process.
#' @param CSS Use CSS selectors as input for the Paths
#' @param archiveDate Retrieve the archiving date
#' @param ignoreErrors Ignore errors for some Urls and proceed scraping
#' @param stopatempty Stop if scraping does not succeed
#' @param emptylim Specify the number of Urls not being scraped until break-off
#' @param encoding  	Specify a default encoding for the homepage. Default is 'UTF-8'
#' @param lengthwarning Warning function for large number of URLs appears. Set FALSE to disable default warning.
#'
#' @return This function scrapes the content of mementos or lower-level web pages from the Internet Archive. It returns a tibble including Urls and the scraped content. However, a memento being stored in the Internet Archive does not guarantee that the information from the homepage can be actually scraped.

# Importing dependencies with roxygen2
#' @importFrom xml2 read_html
#' @importFrom rvest html_nodes
#' @importFrom rvest html_text
#' @importFrom stringr str_detect
#' @importFrom stringr str_extract
#' @importFrom stringr str_length
#' @importFrom tibble tibble
#' @importFrom stats rnorm

# Export function to namespace
#' @export



### Function --------------------

scrape_urls <-
  function(Urls,
           Paths,
           startnum = 1,
           attachto = NULL,
           CSS = FALSE,
           archiveDate = FALSE,
           ignoreErrors = FALSE,
           stopatempty = TRUE,
           emptylim = 10,
           encoding = "UTF-8",
           lengthwarning = TRUE) {
    #### A priori consistency checks
    # Globally bind variables
    counter <- NULL

    # Urls must start with http
    if (!any(stringr::str_detect(Urls, "web\\.archive\\.org")))
      stop (
        "Urls do not originate from the Internet Archive. Please use the retrieveArchiveLinks function to obtain Urls from the Internet Archive."
      )

    # Xpath vector shall be named vector
    if (is.null(names(Paths)))
      stop ("Paths is not a named vector. Please provide a named vector of Xpath or CSS paths.")

    # Xpath vector must be a character vector
    if (!is.character(Paths))
      stop (
        "Paths is not a character vector. Please provide a named character vector of Xpath or CSS paths."
      )

    # startnum must be a single numerical value in the range of the length of Urls
    if (!is.numeric(startnum))
      stop (
        "startnum is not numeric. Please provide a numeric indicating at which Url you want to start the scraping process."
      )

    if (length(startnum) > 1)
      stop (
        "startnum is not a single value. Please provide a single numeric indicating at which Url you want to start the scraping process."
      )

    if (startnum > length(Urls))
      stop (
        "startnum value exceeds number of Urls given. Please provide a numeric indicating at which Url you want to start the scraping process."
      )

    # attachto must stem from the same scraping process
    if (!is.null(attachto))
      if (setequal(colnames(attachto),
                   c("Urls", names(Paths), "progress")
                   ) == F)
        stop ("attachto must be a failed output of this function.")

    checkAttachtoUrl <- attachto$Urls[1]
    checkUrl <- Urls[1]

    if (!is.null(attachto))
      if (checkAttachtoUrl != checkUrl)
        stop (
          "Input Urls and Urls in attachto file differ. Please note that the attachto file can only be used for attaching failed output from the same function and scraping process."
        )

    # CSS must be logical
    if (!is.logical(CSS))
      stop ("CSS is not a logical value. Please provide TRUE or FALSE.")

    if (length(CSS) > 1)
      stop ("CSS is not a single value. Please provide TRUE or FALSE.")

    # archiveDate must be logical

    if (!is.logical(archiveDate))
      stop ("archiveDate is not a logical value. Please provide TRUE or FALSE.")

    if (length(archiveDate) > 1)
      stop ("archiveDate is not a single value. Please provide TRUE or FALSE.")

    # ignoreErrors must be logical
    if (!is.logical(ignoreErrors))
      stop ("ignoreErrors is not a logical value. Please provide TRUE or FALSE.")

    if (length(ignoreErrors) > 1)
      stop ("ignoreErrors is not a single value. Please provide TRUE or FALSE.")

    # stopatempty must be logical
    if (!is.logical(stopatempty))
      stop ("stopatempty is not a logical value. Please provide TRUE or FALSE.")

    if (length(stopatempty) > 1)
      stop ("stopatempty is not a single value. Please provide TRUE or FALSE.")


    # emptylim must be numeric
    if (!is.numeric(emptylim))
      stop ("emptylim is not numeric. Please provide a numeric value.")

    if (length(emptylim) > 1)
      stop ("emptylim is not a single value. Please provide a single numeric value.")

    # Encoding must be character
    if (!is.character(encoding))
      stop (
        "encoding is not a character value. Please provide a character string to indicate the encoding of the homepage you are about to scrape."
      )

    if (length(encoding) > 1)
      stop (
        "encoding is not a single value. Please provide a single character string to indicate the encoding of the homepage you are about to scrape."
      )

    # Warning and wait to proceed if large number of Urls
    if (length(Urls) >= 100 & lengthwarning != FALSE) {
      message(
        "Warning: You are about to scrape the information from a large number of Urls. This process may take some time. Press \"y\" to proceed. \n For automated processes using a virtual machine disable this warning message with the option lengthwarning = F"
      )
      line <- readline()

      if (line != "y") {
        stop("Execution halted")
      }

    }


    #### Main function

    # Generate list for output
    scrapedUrls <- vector(mode = "list", length = length(Urls))


    #Progress bar
    pb <- txtProgressBar(min = 0,
                         max = length(Urls),
                         style = 3)



    # Start if attachto is used
    if (!is.null(attachto)) {
      scrapedUrls <-
        split(attachto[1:sum(attachto$progress), 2:(ncol(attachto) - 1)], seq(1:sum(attachto$progress)))
      length(scrapedUrls) <- length(Urls)
    }


    if (startnum > 1) {
      for (i in seq_len(startnum - 1)) {
        if (is.null(scrapedUrls[[i]])) {
          scrapedUrls[[i]] <-
            as.data.frame(matrix(ncol = length(Paths), nrow = 1))

          cnames <- seq(1:length(Paths))
          cnames <- paste0("Xpath", cnames)
          cnames[names(Paths) != ""] <- names(Paths)[names(Paths) != ""]

          colnames(scrapedUrls[[i]]) <- cnames
        }
      }
    }


    # Loop over all Urls
    for (i in (seq_len(length(Urls)-(startnum-1))+(startnum-1))) {
      # Sys.sleep
      if ((i > startnum) & ((i - startnum) %% 20 == 0)) {
        Sys.sleep(abs(rnorm(1, 5, 2)))
      }



      # Avoid Urls that cannot be retrieved
      possibleError <- tryCatch(
        r <- httr::GET(Urls[i], httr::timeout(20)),
        error = function(e)
          e
      )


      if (inherits(possibleError, "error")) {
        scrapedUrls[[i]] <-
          as.data.frame(matrix(ncol = length(Paths), nrow = 1))

        cnames <- seq_len(length(Paths))
        cnames <- paste0("Xpath", cnames)
        cnames[names(Paths) != ""] <- names(Paths)[names(Paths) != ""]

        colnames(scrapedUrls[[i]]) <- cnames
        next
      }

      status <- httr::status_code(r)
      if (status == 200) {
        # Scrape page, using rvest
        tryCatch({
          html <- xml2::read_html(Urls[i], encoding = encoding)


          data <- list()

          if (CSS == T) {
            # Extract nodes
            for (x in seq_len(length(Paths))) {
              data[[x]] <- rvest::html_nodes(html, css = Paths[x])
              data[[x]] <- rvest::html_text(data[[x]])
              data[[x]] <- paste(data[[x]], collapse = ' ')
            }
          } else {
            # Extract nodes
            for (x in seq_len(length(Paths))) {
              data[[x]] <- rvest::html_nodes(html, xpath = Paths[x])
              data[[x]] <- rvest::html_text(data[[x]])
              data[[x]] <- paste(data[[x]], collapse = ' ')
            }
          }

          data <- as.data.frame(data)

          cnames <- seq_len(length(Paths))
          cnames <- paste0("Xpath", cnames)
          cnames[names(Paths) != ""] <- names(Paths)[names(Paths) != ""]

          colnames(data) <- cnames



          scrapedUrls[[i]] <- data


          # Counter for empty outputs in a row
          if (i == 1) {
            counter <- 0
          }
          if (sum(stringr::str_length(data) == 0) == ncol(data)) {
            counter <-  counter + 1
          } else {
            counter <- 0
          }



        },
        error = function(e) {
          cat("ERROR :", conditionMessage(e), "\n")
        })
      }


      if (is.null(scrapedUrls[[i]])) {
        scrapedUrls[[i]] <-
          as.data.frame(matrix(ncol = length(Paths), nrow = 1))

        cnames <- seq_len(length(Paths))
        cnames <- paste0("Xpath", cnames)
        cnames[names(Paths) != ""] <- names(Paths)[names(Paths) != ""]

        colnames(scrapedUrls[[i]]) <- cnames

      }



      # Stop if non-matching number of paths could be extracted
      if ((sum(stringr::str_length(scrapedUrls[[i]][seq_len(length(Paths))]) == 0) != 0) &
          (sum(stringr::str_length(scrapedUrls[[i]][seq_len(length(Paths))]) == 0) != length(Paths)) &
          (ignoreErrors == F)) {
        # Preliminary output

        predata <- do.call("rbind", scrapedUrls)

        Urls <- Urls[seq_len(nrow(predata))]

        output <- tibble::tibble(Urls, predata, progress = 0)
        output$progress[0:(i - 1)] <- 1

        warning(
          paste0(
            "Error in scraping of Url ",
            i,
            " '",
            Urls[i],
            "'. Only some of your Paths could be extracted. A preliminary output has been printed."
          )
        )
        return(output)
      }


      # Stop if too many empty outputs in a row
      if (counter >= emptylim &
          stopatempty == T & ignoreErrors == F) {
        # Preliminary output

        predata <- do.call("rbind", scrapedUrls)

        Urls <- Urls[seq_len(nrow(predata))]

        output <- tibble::tibble(Urls, predata, progress = 0)
        output$progress[0:(i - emptylim)] <- 1

        warning(
          paste0(
            "Error in scraping of Url ",
            i,
            " '",
            Urls[i],
            "'. Too many empty outputs in a row. A preliminary output has been printed."
          )
        )
        return(output)
      }

      # Progress message
      setTxtProgressBar(pb, i)

    }

    # Generate output dataframe

    output <- do.call("rbind", scrapedUrls)

    Urls <- Urls[seq_len(nrow(output))]
    output <- tibble::tibble(Urls, output)

    if (archiveDate == T) {
      output$archiveDate <-
        anytime::anydate(
          stringr::str_extract(
            output$Urls,
            "(?<=\\:\\/\\/web\\.archive\\.org\\/web\\/)[0-9]{8}"
          )
        )
    }

    #### Return output
    return(output)
  }
