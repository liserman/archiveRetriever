# Get an overview of available mementos of the homepage from the Internet Archive

# Importing dependencies with roxygen2
#' @import anytime
#' @import stringr
#' @import lubridate
#' @import jsonlite
#' @import tibble
#' @import dplyr
#' @import ggplot2
#' @import gridExtra




### Function --------------------

archiveOverview <- function(homepage, startDate, endDate){

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

  # Check homepage input
  ArchiveCheck <- paste0("http://web.archive.org/cdx/search/cdx?url=",homepage,"&matchType=url&&collapse=timestamp:8&limit=15000&filter=!mimetype:image/gif&filter=!mimetype:image/jpeg&from=", "19900101", "&to=", stringr::str_remove_all(lubridate::today(), "\\-"), "&output=json&limit=1")

  if(nrow(as.data.frame(jsonlite::fromJSON(ArchiveCheck))) == 0) stop ("Homepage has never been saved in the Internet Archive. Please choose another homepage.")


  urlArchive <- paste0("http://web.archive.org/cdx/search/cdx?url=",homepage,"&matchType=url&&collapse=timestamp:8&limit=15000&filter=!mimetype:image/gif&filter=!mimetype:image/jpeg&from=", startDate, "&to=", endDate, "&output=json&limit=1")

  tryCatch({
    url_from_json <- as.data.frame(jsonlite::fromJSON(urlArchive))

    names(url_from_json) <- lapply(url_from_json[1,], as.character)

    url_from_json <- url_from_json[-1,]

  }, error=function(e){cat("ERROR :", conditionMessage(e), "\n")})

  collectDates <- url_from_json$timestamp
  collectDates <- stringr::str_sub(collectDates, 1, 8)
  collectDates <- anytime::anydate(collectDates)

  collectDates <- tibble::as_tibble(collectDates)
  collectDates <- dplyr::mutate(collectDates, availableDates = value)

  allDates <- tibble::as_tibble(seq(as.Date(anytime::anydate(startDate)),as.Date(anytime::anydate(endDate)),by=1))
  allDates <- dplyr::rename(allDates, date = value)

  dfDates <- dplyr::left_join(allDates, collectDates, by = c("date" = "value"))
  dfDates <- dplyr::mutate(dfDates, homepage = homepage)
  dfDates$day <- lubridate::wday(dfDates$date, label = T, week_start = getOption("lubridate.week.start", 1), locale = Sys.getlocale("LC_TIME"))
  dfDates$week <- format(dfDates$date, format="%V")
  dfDates$month <- lubridate::month(dfDates$date, label = T)
  dfDates$ddate <- factor(sprintf("%02d", lubridate::day(dfDates$date)))
  dfDates$year <- lubridate::year(dfDates$date)

  #Get calender week 53 correctly
  dfDates$monthnum <- lubridate::month(dfDates$date)
  dfDates$week[dfDates$monthnum==12 & dfDates$week == "01"] <- "53"

  dfDates$week <- factor(dfDates$week)

  dfDates$availability <- "Available"
  dfDates$availability[is.na(dfDates$availableDates)] <- "Not available"

  #Noch zu lösendes Problem: Wie soll der Plot über mehrere Jahre hinweg angezeigt werden?
    # Vorschlag: grid.arrange? Zumindest bis zu einer bestimmten Anzahl Jahre sollte das ganz gut funktionieren
    #   Alternative: wir schränken den Zeitraum ein, der gleichzeitig angeschaut werden kann. Wenn Zeitraum zu groß, Fehlermeldung mit Aufforderung Zeitraum zu reduzieren.

  if(length(unique(dfDates$year)) == 1){
    p <- ggplot2::ggplot(dfDates, ggplot2::aes(x=week,y=day))+
      ggplot2::geom_tile(ggplot2::aes(fill=availability))+
      ggplot2::geom_text(ggplot2::aes(label=ddate))+
      ggplot2::scale_y_discrete(limits = rev(levels(dfDates$day)))+
      ggplot2::scale_fill_manual(values=c("#8dd3c7", "#fb8072"))+
      ggplot2::facet_grid(~month,scales="free",space="free")+
      ggplot2::labs(x="Week" ,y="", title = as.character(homepage), subtitle = as.character(unique(dfDates$year)))+
      ggplot2::theme_bw(base_size=10)+
      ggplot2::theme(legend.title=ggplot2::element_blank(),
                     panel.grid=ggplot2::element_blank(),
                     panel.border=ggplot2::element_blank(),
                     axis.ticks=ggplot2::element_blank(),
                     strip.background=ggplot2::element_blank(),
                     legend.position="top",
                     legend.justification="right",
                     legend.direction="horizontal",
                     legend.key.size=ggplot2::unit(0.3,"cm"),
                     legend.spacing.x=ggplot2::unit(0.2,"cm"))

    return(p)
  }

  if(length(unique(dfDates$year)) > 1){

    plotFunction <- function(dfDates, year){

      dfDatesPlot <- dfDates[dfDates$year == year,]

      ggplot2::ggplot(dfDatesPlot, ggplot2::aes(x=week,y=day))+
        ggplot2::geom_tile(ggplot2::aes(fill=availability))+
        ggplot2::geom_text(ggplot2::aes(label=ddate))+
        ggplot2::scale_y_discrete(limits = rev(levels(dfDatesPlot$day)))+
        ggplot2::scale_fill_manual(values=c("#8dd3c7", "#fb8072"))+
        ggplot2::facet_grid(~month,scales="free",space="free")+
        ggplot2::labs(x="Week" ,y="", title = as.character(unique(dfDatesPlot$year)))+
        ggplot2::theme_bw(base_size=10)+
        ggplot2::theme(legend.title=ggplot2::element_blank(),
                       panel.grid=ggplot2::element_blank(),
                       panel.border=ggplot2::element_blank(),
                       axis.ticks=ggplot2::element_blank(),
                       strip.background=ggplot2::element_blank(),
                       legend.position="top",
                       legend.justification="right",
                       legend.direction="horizontal",
                       legend.key.size=ggplot2::unit(0.3,"cm"),
                       legend.spacing.x=ggplot2::unit(0.2,"cm"))
    }

    plot_list <- lapply(
      unique(dfDates$year),
      plotFunction,
      dfDates = dfDates
    )

  return(gridExtra::grid.arrange(grobs = plot_list, top = as.character(homepage)))

  }


}


#weltOverview <- archiveOverview(homepage = "www.welt.de", startDate = 20180601, endDate = "20190615")

