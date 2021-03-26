# archiveRetriever
[![codecov](https://codecov.io/gh/liserman/archiveRetriever/branch/main/graph/badge.svg?token=B1VPXBAR7P)](https://codecov.io/gh/liserman/archiveRetriever)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/archiveRetriever)](https://cran.r-project.org/package=archiveRetriever)
[![CRAN_latest_release_date](https://www.r-pkg.org/badges/last-release/archiveRetriever)](https://cran.r-project.org/package=archiveRetriever)


R-Package to retrieve web data from the Internet Archive


The goal of the archiveRetriever package is to provide a systematic workflow for retrieving web data from mementos stored in the Internet Archive. Currently, the package includes the following functions:

- `archive_overview` generates a calender providing an overview of the available mementos of the homepage in the Internet Archive within a specific time range. This function is very useful for getting a quick glimpse of the web data available when planning to retrieve a comprehensive coverage of the homepage from the Internet Archive
- `retrieve_urls` generates a vector of links to mementos of the homepage stored in the Internet Archive within a specific time range.
- `retrieve_links` generates a tibble with two columns including the link to the memento of the homepage stored in the Internet Archive as well as all links within the memento. The two column translate to the parent link with its child references. This function is useful to fully cover the content within a homepage for retrieval.
- `scrape_urls` generates a tibble including the link of the memento being scraped as well as the scraped content structured in different columns. The number of columns for the scraped content amounts to the length of the XPath or CSS selectors used to scrape the content.


We present a short step-by-step guide as well as the functions in more detail below.

## Installation

A stable version of `archiveRetriever` can be directly accessed on CRAN:

``` r
install.packages("archiveRetriever")
```

To install the latest development version of `archiveRetriever` directly from
[GitHub](https://github.com/liserman/archiveRetriever) use:

``` r
library(devtools) # Tools to Make Developing R Packages Easier # Tools to Make Developing R Packages Easier
devtools::install_github("liserman/archiveRetriever")
```
