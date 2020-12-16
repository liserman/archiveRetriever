#Retrieving the mementos of a homepage from the Internet Archive

# Importing dependencies with roxygen2
#' @import anytime
#' @import stringr
#' @import lubridate
#' @import jsonlite




### Function --------------------

# Retrieve URLs function
retrieveArchiveUrls <- function(homepage, startDate, endDate){

  #### A priori consistency checks


  # Check date inputs

  if(is.na(anytime::anydate(startDate))) stop ("startDate is not a date")

  if(is.na(anytime::anydate(endDate))) stop ("endDate is not a date")

  if(anytime::anydate(startDate) > anytime::anydate(endDate)) stop ("startDate cannot be later than endDate")

  if(anytime::anydate(endDate) > anytime::anydate(lubridate::today())) stop ("endDate cannot be in the future")

  startDate <- anytime::anydate(startDate)
  startDate <- stringr::str_remove_all(startDate, "\\-")

  endDate <- anytime::anydate(endDate)
  endDate <- stringr::str_remove_all(endDate, "\\-")

  # Check that domain ending exists
  if(stringr::str_detect(homepage, "\\..*$") == FALSE) stop ("Please add a top-level-domain to the homepage.")


  #### Main function

  #Extract relevant information from homepage

  #Only needed for full function!!! - Is not being used in this sub-function
  #TODO:
  page <- stringr::str_remove(homepage, 'www.|http\\:\\/\\/|https\\:\\/\\/')
  page <- stringr::str_remove(page, '\\..*')

  tld <- stringr::str_remove_all(homepage, "www.")
  tld <- stringr::str_remove_all(tld, page)

  # Check homepage input
  # consistency checks are really difficult here. How about a test whether there has been any memento being saved in the Archive?   Lukas: Gute Lösung! Scheint auch grundätzlich zu funktionieren.
  ArchiveCheck <- paste0("http://web.archive.org/cdx/search/cdx?url=",homepage,"&matchType=url&&collapse=timestamp:8&limit=15000&filter=!mimetype:image/gif&filter=!mimetype:image/jpeg&from=", "19900101", "&to=", stringr::str_remove_all(lubridate::today(), "\\-"), "&output=json&limit=1")

  if(nrow(as.data.frame(jsonlite::fromJSON(ArchiveCheck))) == 0) stop ("Homepage has never been saved in the Internet Archive. Please choose another homepage.")


  urlArchive <- paste0("http://web.archive.org/cdx/search/cdx?url=",homepage,"&matchType=url&&collapse=timestamp:8&limit=15000&filter=!mimetype:image/gif&filter=!mimetype:image/jpeg&from=", startDate, "&to=", endDate, "&output=json&limit=1")

  tryCatch({
    url_from_json <- as.data.frame(jsonlite::fromJSON(urlArchive))

    names(url_from_json) <- lapply(url_from_json[1,], as.character)

    url_from_json <- url_from_json[-1,]

  }, error=function(e){cat("ERROR :", conditionMessage(e), "\n")})

  tryCatch({
    homep <- c()
    for (i in 1:nrow(url_from_json)) {
      homep[i] <- paste0("http://web.archive.org/web/", url_from_json[i,2], "/", url_from_json[i,3])
    }
    homepages <- homep
  }, error=function(e){cat("ERROR :", conditionMessage(e), "\n")})



  #### A posteriori consistency checks



  #### Return output

  return(homepages)

}

#ArchiveUrls <- retrieveArchiveUrls("www.spiegel.de", "20190801", "20190901")


