#' retrieve_links: Retrieving Links of Lower-level web pages of mementos from the Internet Archive
#'
#' `retrieve_links` retrieves the Urls of mementos stored in the Internet Archive
#'
#' @param ArchiveUrls A string of the memento of the Internet Archive
#' @param encoding  	Specify a encoding for the homepage. Default is 'UTF-8'
#' @param ignoreErrors Ignore errors for some Urls and proceed scraping
#'
#' @return This function retrieves the links of all lower-level web pages of mementos of a homepage available from the Internet Archive. It returns a tibble including the baseUrl and all links of lower-level web pages. However, a memento being stored in the Internet Archive does not guarantee that the information from the homepage can be actually scraped.
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

retrieve_links <- function(ArchiveUrls, encoding = "UTF-8", ignoreErrors = FALSE) {
  #### A priori consistency checks

  # Globally bind variables
  value <- NULL


  # Check Archive Url input

  stopifnot(
    "Urls need to be Internet Archive Urls. Please use the retrieve_urls function to obtain mementos from the Internet Archive." = stringr::str_detect(ArchiveUrls, "web\\.archive\\.org") == T
  )


  # Encoding must be character
  if (!is.character(encoding))
    stop (
      "encoding is not a character value. Please provide a character string to indicate the encoding of the homepage you are about to scrape."
    )

  if (length(encoding) > 1)
    stop (
      "encoding is not a single value. Please provide a single character string to indicate the encoding of the homepage you are about to scrape."
    )

  #Get homepage and top-level-domain
  #(does this always work?) - needs lot of testing!!!

  extracting <-
    stringr::str_extract(ArchiveUrls, '\\/http.*\\..*\\/$')
  extracting <-
    stringr::str_remove_all(extracting, 'www.|http\\:\\/\\/|https\\:\\/\\/')
  extracting <- stringr::str_remove_all(extracting, '\\/|\\:.*')

  page <- stringr::str_extract(extracting, '^.*\\.')
  page <- stringr::str_remove_all(page, "\\.")
  tld <- stringr::str_extract(extracting, '\\..*$')
  tld <- stringr::str_remove_all(tld, "\\.")

  #### Main function

  fullUrls <- list()
  pb <-
    txtProgressBar(min = 0,
                   max = length(ArchiveUrls),
                   style = 3)

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
      paper_html <- xml2::read_html(r, encoding = encoding)

      paper_urls <- rvest::html_nodes(paper_html, "a")
      paper_urls <- rvest::html_attr(paper_urls, "href")
      paper_urls <-
        paper_urls[grepl(paste0(page[i], "\\.", tld[i]), paper_urls)]

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

    setTxtProgressBar(pb, i)

  }

  if (length(fullUrls) > 0) {
  names(fullUrls) <- ArchiveUrls
  }

  dataReturn <- tibble::enframe(fullUrls)
  dataReturn <- tidyr::unnest(dataReturn, cols = c(value))

  names(dataReturn) <- c("baseUrl", "links")

  #### Return output

  return(dataReturn)

}
