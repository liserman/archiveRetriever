#' retrieveArchiveUrls: Retrieving Urls from the Internet Archive
#'
#' `retrieveArchiveUrls` retrieves the Urls of mementos stored in the Internet Archive
#'
#' @param homepage A character vector of the homepage, including the top-level-domain
#' @param startDate A character vector of the starting date of the overview. Accepts a large variety of date formats (see \link[anytime]{anytime})
#' @param endDate A character vector of the ending date of the overview. Accepts a large variety of date formats (see \link[anytime]{anytime})
#'
#' @return This function retrieves the mementos of a homepage available from the Internet Archive. It returns a vector of strings of all mementos stored in the Internet Archive in the respective time frame. The mementos only refer to the homepage being retrieved and not its lower level web pages. However, a memento being stored in the Internet Archive does not guarantee that the information from the homepage can be actually scraped.
#' @examples
#' \dontrun{
#' retrieveArchiveUrls("www.spiegel.de", "20190801", "20190901")
#' retrieveArchiveUrls("nytimes.com", startDate = "2018-01-01", endDate = "01/02/2018")
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
retrieveArchiveUrls <- function(homepage, startDate, endDate){

  #### A priori consistency checks


  # Check date inputs

  if(!is.character(startDate)) stop ("startDate is not a character vector.")

  if(!is.character(endDate)) stop ("endDate is not a character vector.")

  if(is.na(anytime::anydate(startDate))) stop ("startDate is not a date.")

  if(is.na(anytime::anydate(endDate))) stop ("endDate is not a date.")

  if(anytime::anydate(startDate) > anytime::anydate(endDate)) stop ("startDate cannot be later than endDate.")

  if(anytime::anydate(endDate) > anytime::anydate(lubridate::today())) stop ("endDate cannot be in the future.")

  startDate <- anytime::anydate(startDate)
  startDate <- stringr::str_remove_all(startDate, "\\-")

  endDate <- anytime::anydate(endDate)
  endDate <- stringr::str_remove_all(endDate, "\\-")

  # Check that domain ending exists
  UrlTest <- httr::GET(homepage)
  if(httr::status_code(UrlTest) != 200) stop ("Please add an existing URL.")


  #### Main function

  # Check homepage input
  # consistency checks are really difficult here. How about a test whether there has been any memento being saved in the Archive?   Lukas: Gute Lösung! Scheint auch grundätzlich zu funktionieren.
  ArchiveCheck <- paste0("http://web.archive.org/cdx/search/cdx?url=",homepage,"&matchType=url&&collapse=timestamp:8&limit=15000&filter=!mimetype:image/gif&filter=!mimetype:image/jpeg&from=", "19900101", "&to=", stringr::str_remove_all(lubridate::today(), "\\-"), "&output=json&limit=1")

  if(nrow(as.data.frame(jsonlite::fromJSON(ArchiveCheck))) == 0) stop ("Homepage has never been saved in the Internet Archive. Please choose another homepage.")


  urlArchive <- paste0("http://web.archive.org/cdx/search/cdx?url=",homepage,"&matchType=url&&collapse=timestamp:8&limit=15000&filter=!mimetype:image/gif&filter=!mimetype:image/jpeg&from=", startDate, "&to=", endDate, "&output=json&limit=1")

  url_from_json <- as.data.frame(jsonlite::fromJSON(urlArchive))
  names(url_from_json) <- lapply(url_from_json[1,], as.character)
  url_from_json <- url_from_json[-1,]

  homep <- c()
  for (i in 1:nrow(url_from_json)) {
    homep[i] <- paste0("http://web.archive.org/web/", url_from_json[i,2], "/", url_from_json[i,3])
  }
  homepages <- homep




  #### A posteriori consistency checks



  #### Return output

  return(homepages)

}

