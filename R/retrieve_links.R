#' retrieve_links: Retrieving Links of Lower-level web pages of mementos from the Internet Archive
#'
#' `retrieve_links` retrieves the Urls of mementos stored in the Internet Archive
#'
#' @param ArchiveUrls A string of the memento of the Internet Archive
#' @param encoding  	Specify a encoding for the homepage. Default is 'UTF-8'
#' @param ignoreErrors Ignore errors for some Urls and proceed scraping
#' @param filter Filter links by top-level domain. Only sub-domains of top-level domain will be returned. Default is TRUE.
#' @param pattern Filter links by custom pattern instead of top-level domains. Default is NULL.
#' @param nonArchive Logical input. Can be set to TRUE if you want to use the archiveRetriever to scrape web pages outside the Internet Archive.
#'
#' @return This function retrieves the links of all lower-level web pages of mementos of a homepage available from the Internet Archive. It returns a tibble including the baseUrl and all links of lower-level web pages. However, a memento being stored in the Internet Archive does not guarantee that the information from the homepage can be actually scraped. As the Internet Archive is an internet resource, it is always possible that a request fails due to connectivity problems. One easy and obvious solution is to re-try the function.
#' @examples
#' \dontrun{
#' retrieve_links("http://web.archive.org/web/20190801001228/https://www.spiegel.de/")
#' }

# Importing dependencies with roxygen2
#' @importFrom  stringr str_detect
#' @importFrom stringr str_extract
#' @importFrom stringr str_remove_all
#' @importFrom  httr GET
#' @importFrom httr status_code
#' @importFrom xml2 read_html
#' @importFrom  rvest html_nodes
#' @importFrom rvest html_attr
#' @importFrom tibble enframe
#' @importFrom tidyr unnest
#' @importFrom utils setTxtProgressBar txtProgressBar

# Export function
#' @export


### Function --------------------

# Retrieve URLs function

retrieve_links <- function(ArchiveUrls,
                           encoding = "UTF-8",
                           ignoreErrors = FALSE,
                           filter = TRUE,
                           pattern = NULL,
                           nonArchive = FALSE) {

  #### A priori consistency checks

  # Check if nonArchive is logical
  if(!is.logical(nonArchive))
    stop("nonArchive must be logical.")

  # Check Archive Urls are string vector
  if (!is.character(ArchiveUrls))
    stop("ArchiveUrls must be a character vector of Urls from the Internet Archive. Please use the retrieve_urls function to obtain mementos from the Internet Archive.")


  # Check Archive Url input
  if (!nonArchive & !all(stringr::str_detect(ArchiveUrls, "web\\.archive\\.org")))
    stop("Urls need to be Internet Archive Urls. Please use the retrieve_urls function to obtain mementos from the Internet Archive.")

  # Encoding must be character
  if (!is.character(encoding))
    stop (
      "encoding is not a character value. Please provide a character string to indicate the encoding of the homepage you are about to scrape."
    )

  if (length(encoding) > 1)
    stop (
      "encoding is not a single value. Please provide a single character string to indicate the encoding of the homepage you are about to scrape."
    )


  # filter must be logical
  if (!is.logical(filter))
    stop(
      "filter is not a logical value. Please provide a logical value of TRUE or FALSE as input to filter to indicate whether you want to filter the results by top-level domain or not. The default value of filter is TRUE."
    )

  # filter must be of length 1
  if (length(filter) > 1)
    stop(
      "filter is not a single value. Please provide a single logical value to indicate whether you want to filter the results by top-level domain or not."
    )

  # if pattern is given, force filter to be TRUE
  if (!is.null(pattern))
    filter <- TRUE

  # pattern must be NULL or character
  if (!is.null(pattern) & !is.character(pattern))
    stop(
      "pattern must be a character value. Please provide a character string by which you want to filter links before output. If you do not provide a character string, the top-level domain of the page you want to scrape is taken as default."
    )

  # pattern must be of length 1
  if (length(pattern) > 1)
    stop(
      "pattern is not a single value. Please provide a single character string by which wou want to filter links before output. If you do not provide a character string, the top-level domain of the page you want to scrape is taken as default."
    )




  #### Main function

  # if pattern is given, generate n-length vector of pattern
  if (!is.null(pattern))
    pattern <- rep(pattern, length(ArchiveUrls))


  #Get homepage and top-level-domain to filter by pattern
  if (filter & is.null(pattern)) {

    # extract domain from internet archive url
    pattern <- stringr::str_extract(ArchiveUrls, '\\/http.*\\..*$')

    # strip beginning of url
    pattern <- stringr::str_remove_all(pattern, '^\\/*www([0-9])?\\.|^\\/*http(s)*\\:\\/\\/(www([0-9])?\\.)?|^\\/')

    # strip ending of url
    pattern <- stringr::str_remove_all(pattern, '\\/.*|\\:.*')
  }


  fullUrls <- list()
  if(length(ArchiveUrls) > 1 & interactive()){
    pb <- txtProgressBar(min = 0,
                         max = length(ArchiveUrls),
                         style = 3)
  }

  for (i in seq_len(length(ArchiveUrls))) {
    possibleError <- tryCatch(
      r <- httr::GET(ArchiveUrls[i], httr::timeout(20)),
      error = function(e)
        e
    )

    if (inherits(possibleError, "error")) {

      if(!ignoreErrors){

        stop(
          possibleError[[1]]
        )

      } else {
        next
      }
    }

    status <- httr::status_code(r)
    if (status == 200) {
      possibleError <- tryCatch(
      paper_html <- xml2::read_html(r, encoding = encoding),
      error = function(e)
        e
      )

      if (inherits(possibleError, "error")) {

        if(!ignoreErrors){

          stop(
            possibleError[[1]]
          )

        } else {
          next
        }
      }

      paper_urls <- rvest::html_nodes(paper_html, "a")
      paper_urls <- rvest::html_attr(paper_urls, "href")


      if (filter) {
      paper_urls <-
        paper_urls[grepl(pattern[i], paper_urls)]
      }

      paper_urlsFinal <- list()

      if (length(paper_urls) > 0) {
        for (j in seq_len(length(paper_urls))) {
          if (!grepl("http://web.archive.org", paper_urls[j]) &
              grepl("//web.archive.org", paper_urls[j])) {
            paper_urls[j] <- paste0("http:", paper_urls[j])
          }

          if (!grepl("http://web.archive.org", paper_urls[j])) {
            paper_urlsFinal[[j]] <-
              paste0("http://web.archive.org", paper_urls[j])
          } else
            paper_urlsFinal[[j]] <- paper_urls[j]
        }
      }

      paper_urlsFinal <- Reduce(c, paper_urlsFinal)

      fullUrls[[i]] <- paper_urlsFinal


      Sys.sleep(sample(1:2, 1))
    } else{

      if(!ignoreErrors){

        stop(
          paste0("HTTP status ", httr::status_code(r), ": Links could not be retrieved. Please try again with a different URL.")
        )

      } else {
      next
      }
    }

    if(length(ArchiveUrls) > 1 & interactive()){
      setTxtProgressBar(pb, i)
    }

  }

  if (length(fullUrls) > 0) {
  names(fullUrls) <- ArchiveUrls[1:length(fullUrls)]
  }

  dataReturn <- tibble::enframe(fullUrls)
  dataReturn <- tidyr::unnest(dataReturn, cols = c("value"))

  names(dataReturn) <- c("baseUrl", "links")

  #### Return output

  return(dataReturn)

}
