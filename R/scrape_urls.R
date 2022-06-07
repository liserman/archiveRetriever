#' scrape_urls: Scraping Urls from the Internet Archive
#'
#' `scrape_urls` scrapes Urls of mementos and lower-level web pages stored in the Internet Archive using XPaths as default
#'
#' @param Urls A character vector of the memento of the Internet Archive
#' @param Paths A named character vector of the content to be scraped from the memento. Takes XPath expressions as default.
#' @param collapse Collapse matching html nodes
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
#' @return This function scrapes the content of mementos or lower-level web pages from the Internet Archive. It returns a tibble including Urls and the scraped content. However, a memento being stored in the Internet Archive does not guarantee that the information from the homepage can be actually scraped. As the Internet Archive is an internet resource, it is always possible that a request fails due to connectivity problems. One easy and obvious solution is to re-try the function.
#' @examples
#' \dontrun{
#' scrape_urls(
#' Urls = "http://web.archive.org/web/20201001004918/https://www.nytimes.com/2020/09/30/opinion/biden-trump-2020-debate.html",
#' Paths = c(title = "//h1[@itemprop='headline']", author = "//span[@itemprop='name']"))
#' scrape_urls(
#' Urls = "https://web.archive.org/web/20201001000859/https://www.nytimes.com/section/politics",
#' Paths = c(title = "//article/div/h2//text()", teaser = "//article/div/p/text()"),
#' collapse = FALSE, archiveDate = TRUE)
#'
#' }

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
           collapse = TRUE,
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


    # If Urls is dataframe, check if output from retrieve_links. If yes, reduce to Urls of interest and generate vector
    if(is.data.frame(Urls)){
      if(ncol(Urls)==1){
        Urls <- Urls[,1]
      } else
        if(ncol(Urls)>2){
          stop("Urls must be vector of Urls or output from retrieve_links(). Dataframes not obtained from retrieve_links() are not allowed.")
        } else
          if(ncol(Urls)==2){
            if (identical(names(Urls), c("baseUrl", "links"))){
              Urls <- Urls$links
            } else {
              stop("Urls must be vector of Urls or output from retrieve_links(). Dataframes not obtained from retrieve_links() are not allowed.")
            }
          }
    }

    # Check if Urls is atomic
    if(!is.atomic(Urls)){
      stop("Urls must be vector of Urls or output from retrieve_links(). Other object types are not allowed.")
    }


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


    # collapse must be logical
    if (!is.logical(collapse))
      stop ("collapse is not a logical value. Please provide TRUE or FALSE.")


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


    # attachto must stem from same scraping process
    if (!is.null(attachto))
      if (setequal(colnames(attachto),
                   c("Urls", names(Paths), "stoppedat")
      ) == FALSE)
        stop ("attachto must be a failed output of this function.")


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

# Generate counter for later use
counter <- 0


#Progress bar
if(length(Urls) > 1){
  pb <- txtProgressBar(min = 0,
                       max = length(Urls),
                       style = 3)
}


for (i in (seq_len(length(Urls)-(startnum-1))+(startnum-1))) {

  # Sys.sleep
  if ((i > startnum) & ((i - startnum) %% 20 == 0)) {
    Sys.sleep(abs(rnorm(1, 5, 2)))
  }

  # Set up List
  data <- list()

  # Avoid Urls that cannot be retrieved
  possibleError <- tryCatch(
    r <- httr::GET(Urls[i], httr::timeout(20)),
    error = function(e)
      e
  )

  # Skip if error
  if (inherits(possibleError, "error")) {
    # Fill data
    data <- as.data.frame(matrix(ncol = length(Paths), nrow = 1))

    # Name columns
    cnames <- seq_len(length(Paths))
    cnames <- paste0("Xpath", cnames)
    cnames[names(Paths) != ""] <- names(Paths)[names(Paths) != ""]

    colnames(data) <- cnames

    # Fill in scrapedUrls List and add Url information
    scrapedUrls[[i]] <- cbind(Urls[[i]], data)
    colnames(scrapedUrls[[i]])[1] <- "Urls"
    next
  }

  # Get httr status
  status <- httr::status_code(r)

  # Retrieve if status = 200
  if (status == 200) {

    possibleError <- tryCatch({
    html <- xml2::read_html(r, encoding = encoding)

    # Retrieve elements and store in data list
    if (CSS == T) {
      # Extract nodes
      for (x in seq_len(length(Paths))) {
        data[[x]] <- rvest::html_nodes(html, css = Paths[x])
        data[[x]] <- rvest::html_text(data[[x]])
      }
    } else {
      # Extract nodes
      for (x in seq_len(length(Paths))) {
        data[[x]] <- rvest::html_nodes(html, xpath = Paths[x])
        data[[x]] <- rvest::html_text(data[[x]])
      }
    }

    # If collapse = TRUE, collapse retrieved html elements
    if (collapse == TRUE) {
      for (x in seq_len(length(Paths))) {
        data[[x]] <- paste(data[[x]], collapse = ' ')
      }
    }

  # End trycatch
  },
  error = function(e) e)

    if(inherits(possibleError, "error")){
      if(ignoreErrors == TRUE){
        next
      } else {
        cat("ERROR in Urls[",i,"]:", conditionMessage(possibleError), "\n")
      }

    }

  # End status == 200 if clause
  } else {
    # Fill data
    data <- as.data.frame(matrix(ncol = length(Paths), nrow = 1))

    # Name columns
    cnames <- seq_len(length(Paths))
    cnames <- paste0("Xpath", cnames)
    cnames[names(Paths) != ""] <- names(Paths)[names(Paths) != ""]

    colnames(data) <- cnames
  }


  # Stops

    # If collapse = FALSE, stop if lengths of retrived elements differs
    if (collapse == FALSE & length(unique(sapply(data, length)))!=1 & ignoreErrors == FALSE) {

      # Preliminary output
      predata <- do.call("rbind", scrapedUrls)

      output <- tibble::tibble(predata, stoppedat = i)

      warning(
        paste0(
          "Error in scraping of Url ",
          i,
          " '",
          Urls[i],
          "'. Number of elements for paths differs. Please provide paths that result in a similar number of elements per Url or use the option collapse = TRUE. A preliminary output has been printed."
        )
      )
      return(output)
    }


    # Stop if too many empty outputs in a row

    # Counter for empty outputs in a row
    if(collapse == F){

      if (sum(sapply(sapply(data, stringr::str_length), sum) == 0) == length(Paths)){
        counter <-  counter + 1
      } else {
        counter <- 0
      }
    } else {

      if (sum(stringr::str_length(data) == 0) == length(Paths)){
        counter <-  counter + 1
      } else {
        counter <- 0
      }
    }


    if (counter >= emptylim &
        stopatempty == TRUE & ignoreErrors == FALSE) {

      # Preliminary output
      predata <- do.call("rbind", scrapedUrls)

      output <- tibble::tibble(predata, stoppedat = i)

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


    # Stop if non-matching number of paths could be extracted
    if (collapse == F){
      if (any(sapply(sapply(data, stringr::str_length), length)==0) & ignoreErrors == FALSE) {

        # Preliminary output
        predata <- do.call("rbind", scrapedUrls)

        output <- tibble::tibble(predata, stoppedat = i)

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
    } else {
      if (length(unique(sapply(data, stringr::str_length)==0))!=1 & ignoreErrors == FALSE) {

        # Preliminary output
        predata <- do.call("rbind", scrapedUrls)

        output <- tibble::tibble(predata, stoppedat = i)

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
    }



  # Data as dataframe

    # List as dataframe
    if (collapse == F){
      data <- as.data.frame(sapply(data, '[', seq(max(sapply(data, length)))))
    } else {
      data <- as.data.frame(data)
    }


    # Add column names
    cnames <- seq_len(length(Paths))
    cnames <- paste0("Xpath", cnames)
    cnames[names(Paths) != ""] <- names(Paths)[names(Paths) != ""]

    colnames(data) <- cnames


    # Add Url as row and save in List over all Urls
    scrapedUrls[[i]] <- cbind(Urls[[i]], data)
    colnames(scrapedUrls[[i]])[1] <- "Urls"


    # Progress message
    if(length(Urls) > 1){
      setTxtProgressBar(pb, i)
    }

} # End for loop

  # Generate output dataframe
  output <- do.call("rbind", scrapedUrls)

  # Attach attachto to retrived data
  if (!is.null(attachto)) {
    output <- rbind(attachto[,-grep("stoppedat", colnames(attachto))], output)
  }

  # If archiveDate = TRUE, add information
  if (archiveDate == TRUE) {
    output$archiveDate <-
      anytime::anydate(
        stringr::str_extract(
          output$Urls,
          "(?<=\\:\\/\\/web\\.archive\\.org\\/web\\/)[0-9]{8}"
        )
      )
  }

  # Output as tibble
  output <- tibble::tibble(output)

  #### Return output
  return(output)

}

