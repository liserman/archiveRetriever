# Retrieve URLs function

retrieveArchiveUrls <- function(homepage, startDate, endDate){
  
  #### A priori consistency checks
  
  
  # Check date inputs
  
  if(is.na(anytime::anydate(startDate))) stop ("startDate is not a date")
  
  if(is.na(anytime::anydate(endDate))) stop ("endDate is not a date")
  
  startDate <- anytime::anydate(startDate)
  startDate <- stringr::str_remove_all(startDate, "\\-")
  
  endDate <- anytime::anydate(endDate)
  endDate <- stringr::str_remove_all(endDate, "\\-")
  
  
  #### Main function
  
  #Extract relevant information from homepage
  page <- stringr::str_remove(homepage, 'www.|http\\:\\/\\/|https\\:\\/\\/')
  page <- stringr::str_remove(page, '\\..*')
  
  ending <- stringr::str_remove_all(homepage, "www.")
  ending <- stringr::str_remove_all(ending, page)
  
  #Do we need to capture format of date input?
  # Solved it using the anytime package - see above :)
  
  # Check homepage input
  # consistency checks are really difficult here. How about a test whether there has been any memento being saved in the Archive?
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

test <- retrieveArchiveUrls("www.spiegel.de", 20190701, "20190801")


