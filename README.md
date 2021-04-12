
# archiveRetriever

[![codecov](https://codecov.io/gh/liserman/archiveRetriever/branch/main/graph/badge.svg?token=B1VPXBAR7P)](https://codecov.io/gh/liserman/archiveRetriever)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/archiveRetriever)](https://cran.r-project.org/package=archiveRetriever)
[![CRAN\_latest\_release\_date](https://www.r-pkg.org/badges/last-release/archiveRetriever)](https://cran.r-project.org/package=archiveRetriever)
[![Downloads](https://cranlogs.r-pkg.org/badges/archiveRetriever)](https://cran.r-project.org/package=archiveRetriever)

R-Package to retrieve web data from the Internet Archive

The goal of the archiveRetriever package is to provide a systematic
workflow for retrieving web data from mementos stored in the Internet
Archive. Currently, the package includes the following functions:

-   `archive_overview` generates a calender providing an overview of the
    available mementos of the homepage in the Internet Archive within a
    specific time range. This function is very useful for getting a
    quick glimpse of the web data available when planning to retrieve a
    comprehensive coverage of the homepage from the Internet Archive
-   `retrieve_urls` generates a vector of links to mementos of the
    homepage stored in the Internet Archive within a specific time
    range.
-   `retrieve_links` generates a tibble with two columns including the
    link to the memento of the homepage stored in the Internet Archive
    as well as all links within the memento. The two column translate to
    the parent link with its child references. This function is useful
    to fully cover the content within a homepage for retrieval.
-   `scrape_urls` generates a tibble including the link of the memento
    being scraped as well as the scraped content structured in different
    columns. The number of columns for the scraped content amounts to
    the length of the XPath or CSS selectors used to scrape the content.

We present a short step-by-step guide as well as the functions in more
detail below.

## Installation

A stable version of `archiveRetriever` can be directly accessed on CRAN:

``` r
install.packages("archiveRetriever", force = TRUE)
```

To install the latest development version of `archiveRetriever` directly
from [GitHub](https://github.com/liserman/archiveRetriever) use:

``` r
library(devtools) # Tools to Make Developing R Packages Easier
devtools::install_github("liserman/archiveRetriever")
```

## How to use this package

First, load the package

``` r
library(archiveRetriever) # Systematically retrieving web data from the Internet Archive
```

In the following, we are going to exemplify the workflow of the package
using the mementos of the [New York Times online
version](https://www.nytimes.com) stored in the Internet Archive.

The workflow of the package follows a simple rule:

1.  Get an overview of data availability in the Internet Archive

2.  Retrieve the mementos of the base url from the Internet Archive

3.  Retrieve the links within the base url from the memento stored in
    the Internet Archive (only necessary when scraping complete
    homepages)

4.  Scrape the content and get it conveniently stored in tibbles.

### archive\_overview

As the Internet Archive is not able to archive the complete internet it
is always important to check whether the memento of the homepage you
want to scrape is actually available in the Internet Archive.

``` r
nytimes_overview <- archive_overview(homepage = "https://www.nytimes.com/",
                     startDate = "2020-10-01",
                     endDate = "2020-12-31")
```

The `archive_overview` function creates a calendar providing an overview
of the homepage’s availability in the Internet Archive.

``` r
nytimes_overview
```

<img src="man/figures/unnamed-chunk-6-1.png" width="100%" />

For the New York Times, we find that the Internet Archive save a memento
of their homepage every day, which is highly reasonable as this homepage
is one of the most visited homepages on the internet.

Next to base urls, the Internet Archive also stores child urls as
mementos. Using the `archive_overview` function, it is of course also
possible to get a calendar showing the availability of mementos of
specific child urls (for example the article of the New York Times on
the election of Joe Biden as 46. President of the USA).

``` r
nytimesArticle_overview <- archive_overview(homepage = "https://www.nytimes.com/2020/11/07/us/politics/biden-election.html",
                     startDate = "2020-10-01",
                     endDate = "2020-12-31")
```

``` r
nytimesArticle_overview
```

<img src="man/figures/unnamed-chunk-8-1.png" width="100%" />

As the article has been published on November 07, there are of course no
mementos available before that date.

### retrieve\_urls

The Internet Archive stores mementos of homepages in their archive which
allows researchers to retrieve historical content from the internet or
examine changes to existing homepages. Scraping content from the
Internet Archive often requires retrieving mementos from a certain time
range or specific points in time.

Applying the `retrieve_urls` function on a homepage results in a
character vector of mementos of the homepage available from the Internet
Archive.

``` r
nytimes_mementos <- retrieve_urls(homepage = "https://www.nytimes.com/",
                     startDate = "2020-10-01",
                     endDate = "2020-12-31")
```

In the Internet Archive often more than one memento is stored each day.
For convenience, the `retrieve_urls` only retrieves one memento for each
day.

``` r
nytimes_mementos[1:10]
#>  [1] "http://web.archive.org/web/20201001000041/https://www.nytimes.com/"
#>  [2] "http://web.archive.org/web/20201002000016/http://nytimes.com/"     
#>  [3] "http://web.archive.org/web/20201003000006/https://nytimes.com/"    
#>  [4] "http://web.archive.org/web/20201004000201/https://www.nytimes.com/"
#>  [5] "http://web.archive.org/web/20201005000047/http://nytimes.com/"     
#>  [6] "http://web.archive.org/web/20201006000036/http://nytimes.com/"     
#>  [7] "http://web.archive.org/web/20201007000202/https://www.nytimes.com/"
#>  [8] "http://web.archive.org/web/20201008000222/https://www.nytimes.com/"
#>  [9] "http://web.archive.org/web/20201009000201/https://www.nytimes.com/"
#> [10] "http://web.archive.org/web/20201010000605/http://nytimes.com/"
```

### retrieve\_links

For many scraping applications, researchers aim to extract information
from all links within a homepage to get a complete picture of the
information stored, e.g. when scraping news content from online
newspapers, blogs on Reddit or press releases published by political
parties.

Sticking to the example of the New York Times, we extract all links of
the memento stored on October 01, 2020 using the `retrieve_links`
function. Please be aware that the `retrieve_links` function only takes
mementos of the Internet Archive as input to ensure only these pages are
being scraped using our scraping functions.

``` r
nytimes_links <- retrieve_links(ArchiveUrls = "http://web.archive.org/web/20201001000041/https://www.nytimes.com/")
```

The `retrieve_links` function results in a tibble with two columns,
including the base url of the memento in the first column and all links
in the second column. From this, user of this function might decide to
filter out links which do not point to content relevant for analysis
using packages for string operations, such as
[stringr](https://github.com/tidyverse/stringr).

``` r
head(nytimes_links)
#> # A tibble: 6 x 2
#>   baseUrl                               links                                   
#>   <chr>                                 <chr>                                   
#> 1 http://web.archive.org/web/202010010~ http://web.archive.org/web/202010010000~
#> 2 http://web.archive.org/web/202010010~ http://web.archive.org/web/202010010000~
#> 3 http://web.archive.org/web/202010010~ http://web.archive.org/web/202010010000~
#> 4 http://web.archive.org/web/202010010~ http://web.archive.org/web/202010010000~
#> 5 http://web.archive.org/web/202010010~ http://web.archive.org/web/202010010000~
#> 6 http://web.archive.org/web/202010010~ http://web.archive.org/web/202010010000~
```

For some applications, it might not be necessary to include the
`retrieve_links` function into the workflow. When only interested in one
specific homepage, it can be sufficient to only retrieve the mementos
using the `retrieve_urls` function.
