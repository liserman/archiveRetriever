#' retrieve_urls: Retrieving Urls from the Internet Archive
#'
#' `retrieve_urls` retrieves the Urls of mementos stored in the Internet Archive
#'
#' @param homepage A character vector of the homepage, including the top-level-domain
#' @param startDate A character vector of the starting date of the overview. Accepts a large variety of date formats (see \link[anytime]{anytime})
#' @param endDate A character vector of the ending date of the overview. Accepts a large variety of date formats (see \link[anytime]{anytime})
#' @param collapseDate A logical value indicating whether the output should be limited to one memento per day
#'
#' @return This function retrieves the mementos of a homepage available from the Internet Archive. It returns a vector of strings of all mementos stored in the Internet Archive in the respective time frame. The mementos only refer to the homepage being retrieved and not its lower level web pages. However, a memento being stored in the Internet Archive does not guarantee that the information from the homepage can be actually scraped.  As the Internet Archive is an internet resource, it is always possible that a request fails due to connectivity problems. One easy and obvious solution is to re-try the function.
#' @examples
#' \dontrun{
#' retrieve_urls("www.spiegel.de", "20190801", "20190901")
#' retrieve_urls("nytimes.com", startDate = "2018-01-01", endDate = "01/02/2018")
#' retrieve_urls("nytimes.com", startDate = "2018-01-01", endDate = "2018-01-02", collapseDate = FALSE)
#' }

# Importing dependencies with roxygen2
#' @importFrom anytime anydate
#' @importFrom stringr str_remove_all
#' @importFrom lubridate today
#' @importFrom jsonlite fromJSON

# Export function
#' @export

### Function --------------------

# Retrieve URLs function
retrieve_urls <- function(homepage, startDate, endDate, collapseDate = TRUE) {

  #### A priori consistency checks

  # Check date inputs
  if (!is.character(homepage))
    stop ("homepage is not a character vector.")

  if (!is.character(startDate))
    stop ("startDate is not a character vector.")

  if (!is.character(endDate))
    stop ("endDate is not a character vector.")

  if (!is.logical(collapseDate))
    stop ("collapseDate is not a logical value.")

  if (length(homepage)>1)
    stop ("homepage can only take a single value.")

  if (length(startDate)>1)
    stop ("startDate can only take a single value.")

  if (length(endDate)>1)
    stop ("endDate can only take a single value.")

  if (length(collapseDate)>1)
    stop ("collapseDate can only take a single value.")

  if (is.na(anytime::anydate(startDate)))
    stop ("startDate is not a date.")

  if (is.na(anytime::anydate(endDate)))
    stop ("endDate is not a date.")

  if (anytime::anydate(startDate) > anytime::anydate(endDate))
    stop ("startDate cannot be later than endDate.")

  if (anytime::anydate(endDate) > anytime::anydate(lubridate::today()))
    stop ("endDate cannot be in the future.")



  startDate <- anytime::anydate(startDate)
  startDate <- stringr::str_remove_all(startDate, "\\-")

  endDate <- anytime::anydate(endDate)
  endDate <- stringr::str_remove_all(endDate, "\\-")



  #### Main function

  # Check homepage input

  if(collapseDate){
  ArchiveCheck <-
    paste0(
      "http://web.archive.org/cdx/search/cdx?url=",
      homepage,
      "&matchType=url&collapse=timestamp:8&limit=15000&filter=!mimetype:image/gif&filter=!mimetype:image/jpeg&from=",
      "19900101",
      "&to=",
      stringr::str_remove_all(lubridate::today(), "\\-"),
      "&output=json&limit=1"
    )
  } else {
    ArchiveCheck <-
      paste0(
        "http://web.archive.org/cdx/search/cdx?url=",
        homepage,
        "&matchType=url&limit=15000&filter=!mimetype:image/gif&filter=!mimetype:image/jpeg&from=",
        "19900101",
        "&to=",
        stringr::str_remove_all(lubridate::today(), "\\-"),
        "&output=json&limit=1"
      )
  }

  possibleError <- tryCatch(
    r <- httr::GET(ArchiveCheck, httr::timeout(20)),
    error = function(e)
      e
  )

  if (inherits(possibleError, "error")) {
    stop ("Homepage could not be loaded. Please check whether the page exists or try again.")
  }

  if (nrow(as.data.frame(jsonlite::fromJSON(ArchiveCheck))) == 0)
    stop ("Homepage has never been saved in the Internet Archive. Please choose another homepage.")

  if(collapseDate){
  urlArchive <-
    paste0(
      "http://web.archive.org/cdx/search/cdx?url=",
      homepage,
      "&matchType=url&collapse=timestamp:8&limit=15000&filter=!mimetype:image/gif&filter=!mimetype:image/jpeg&from=",
      startDate,
      "&to=",
      endDate,
      "&output=json&limit=1"
    )
  } else {
    urlArchive <-
      paste0(
        "http://web.archive.org/cdx/search/cdx?url=",
        homepage,
        "&matchType=url&limit=15000&filter=!mimetype:image/gif&filter=!mimetype:image/jpeg&from=",
        startDate,
        "&to=",
        endDate,
        "&output=json&limit=1"
      )
  }

  url_from_json <- as.data.frame(jsonlite::fromJSON(urlArchive))
  names(url_from_json) <- lapply(url_from_json[1, ], as.character)
  url_from_json <- url_from_json[-1, ]

  homep <- c()
  for (i in seq_len(nrow(url_from_json))) {
    homep[i] <-
      paste0("http://web.archive.org/web/",
             url_from_json[i, 2],
             "/",
             url_from_json[i, 3])
  }
  homepages <- homep

  #### Return output

  return(homepages)

}
