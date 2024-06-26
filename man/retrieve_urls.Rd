% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/retrieve_urls.R
\name{retrieve_urls}
\alias{retrieve_urls}
\title{retrieve_urls: Retrieving Urls from the Internet Archive}
\usage{
retrieve_urls(homepage, startDate, endDate, collapseDate = TRUE)
}
\arguments{
\item{homepage}{A character vector of the homepage, including the top-level-domain}

\item{startDate}{A character vector of the starting date of the overview. Accepts a large variety of date formats (see \link[anytime]{anytime})}

\item{endDate}{A character vector of the ending date of the overview. Accepts a large variety of date formats (see \link[anytime]{anytime})}

\item{collapseDate}{A logical value indicating whether the output should be limited to one memento per day}
}
\value{
This function retrieves the mementos of a homepage available from the Internet Archive. It returns a vector of strings of all mementos stored in the Internet Archive in the respective time frame. The mementos only refer to the homepage being retrieved and not its lower level web pages. However, a memento being stored in the Internet Archive does not guarantee that the information from the homepage can be actually scraped.  As the Internet Archive is an internet resource, it is always possible that a request fails due to connectivity problems. One easy and obvious solution is to re-try the function.
}
\description{
\code{retrieve_urls} retrieves the Urls of mementos stored in the Internet Archive
}
\examples{
\dontrun{
retrieve_urls("www.spiegel.de", "20190801", "20190901")
retrieve_urls("nytimes.com", startDate = "2018-01-01", endDate = "01/02/2018")
retrieve_urls("nytimes.com", startDate = "2018-01-01", endDate = "2018-01-02", collapseDate = FALSE)
}
}
