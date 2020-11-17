#Retrieving the Links within a main domain of the Internet Archive



# Retrieve URLs function

retrieveArchiveLinks <- function(ArchiveUrls, encoding = "latin1"){


  #### A priori consistency checks


  # Check Archive Url input

  if(stringr::str_detect(ArchiveUrls, "^http\\:\\/\\/web\\.archive\\.org") == F) stop ("Url is no Internet Archive URL.")

  #Get main domain and ending

  extracting <- stringr::str_extract(ArchiveUrls, '\\/http.*\\..*\\/$')
  extracting <- stringr::str_remove_all(extracting, 'www.|http\\:\\/\\/|https\\:\\/\\/')
  extracting <- stringr::str_remove_all(extracting, '\\/|\\:.*')

  page <- stringr::str_extract(extracting, '^.*\\.')
  page <- stringr::str_remove_all(page, "\\.")
  ending <- stringr::str_extract(extracting, '\\..*$')
  ending <- stringr::str_remove_all(ending, "\\.")

  #### Main function

  fullUrls <- list()

  for(i in 1:length(ArchiveUrls)){
    possibleError <- tryCatch(
      r <- GET(ArchiveUrls[i]),
      error = function(e) e
    )

    if(inherits(possibleError, "error")) next

    status <- status_code(r)
    if(status == 200){
      paper_html <- read_html(ArchiveUrls[i], encoding = encoding)
      paper_urls <- paper_html %>%
        html_nodes("a") %>%
        html_attr("href")
      paper_urls <- paper_urls[grepl(paste0(page[n],"\\", ending[n]), paper_urls)]

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



      Sys.sleep(sample(1:5,1))
    } else{
      next
    }

    print(i)

  }


  #### A posteriori consistency checks



  #### Return output

  return(homepages)

}
