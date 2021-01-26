#' retrieveArchiveLinks: Retrieving Links of Lower-level web pages of mementos from the Internet Archive
#'
#' `retrieveArchiveLinks` retrieves the Urls of mementos stored in the Internet Archive
#'
#' @param ArchiveUrls A string of the memento of the Internet Archive
#' @param encoding  	Specify a encoding for the homepage. Default is 'UTF-8'
#'
#' @return This function retrieves the links of all lower-level web pages of mementos of a homepage available from the Internet Archive. It returns a tibble including the baseUrl and all links of lower-level web pages. However, a memento being stored in the Internet Archive does not guarantee that the information from the homepage can be actually scraped.
#' @examples
#' \dontrun{
#' retrieveArchiveLinks("http://web.archive.org/web/20190801001228/https://www.spiegel.de/")
#' }

# Importing dependencies with roxygen2
#' @import stringr
#' @import httr
#' @import xml2
#' @import rvest
#' @import tibble
#' @import tidyr
#' @importFrom utils setTxtProgressBar txtProgressBar






### Function --------------------

# Retrieve URLs function

retrieveArchiveLinks <- function(ArchiveUrls, encoding = "UTF-8"){


  #### A priori consistency checks

  # Globally bind variables
  value <- NULL


  # Check Archive Url input

  stopifnot("Urls need to be Internet Archive Urls. Please use the retrieveArchiveUrls function to obtain mementos from the Internet Archive." = stringr::str_detect(ArchiveUrls, "web\\.archive\\.org") == T)

  #Get homepage and top-level-domain
  #(does this always work?) - needs lot of testing!!!

  extracting <- stringr::str_extract(ArchiveUrls, '\\/http.*\\..*\\/$')
  extracting <- stringr::str_remove_all(extracting, 'www.|http\\:\\/\\/|https\\:\\/\\/')
  extracting <- stringr::str_remove_all(extracting, '\\/|\\:.*')

  page <- stringr::str_extract(extracting, '^.*\\.')
  page <- stringr::str_remove_all(page, "\\.")
  tld <- stringr::str_extract(extracting, '\\..*$')
  tld <- stringr::str_remove_all(tld, "\\.")

  #### Main function

  fullUrls <- list()
  pb <- txtProgressBar(min = 0, max = length(ArchiveUrls), style = 3)

  for(i in 1:length(ArchiveUrls)){
    possibleError <- tryCatch(
      r <- httr::GET(ArchiveUrls[i]),
      error = function(e) e
    )

    if(inherits(possibleError, "error")) next

    status <- httr::status_code(r)
    if(status == 200){
      paper_html <- xml2::read_html(ArchiveUrls[i], encoding = encoding)

      paper_urls <- rvest::html_nodes(paper_html, "a")
      paper_urls <- rvest::html_attr(paper_urls, "href")
      paper_urls <- paper_urls[grepl(paste0(page[i],"\\.", tld[i]), paper_urls)]

      paper_urlsFinal <- list()

      if(length(paper_urls)>0){
        for(j in 1:length(paper_urls)){
          if(!grepl("http://web.archive.org", paper_urls[j]) & grepl("//web.archive.org", paper_urls[j])){
            paper_urls[j] <- paste0("http:", paper_urls[j])
          }

          if(!grepl("http://web.archive.org", paper_urls[j])){
            paper_urlsFinal[[j]] <- paste0("http://web.archive.org", paper_urls[j])
          } else
            paper_urlsFinal[[j]] <- paper_urls[j]
        }
      }

      paper_urlsFinal <- Reduce(c, paper_urlsFinal)

      fullUrls[[i]] <- paper_urlsFinal


      Sys.sleep(sample(1:2,1))
    } else{
      next
    }

    setTxtProgressBar(pb, i)

  }

  names(fullUrls) <- ArchiveUrls

  dataReturn <- tibble::enframe(fullUrls)
  dataReturn <- tidyr::unnest(dataReturn, cols = c(value))

  names(dataReturn) <- c("baseUrl", "links")

  #### A posteriori consistency checks



  #### Return output

  return(dataReturn)

}
