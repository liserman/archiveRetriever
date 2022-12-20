context("check-retrieveLinks-output")
library(testthat)
library(webmockr)
library(archiveRetriever)

#Check whether function output is data frame
  test_that("retrieve_links() returns a data frame", {
    vcr::use_cassette("retrieve_links1", {
    output <-
      retrieve_links("http://web.archive.org/web/20190801001228/https://www.spiegel.de/")
    })
    expect_is(output, "data.frame")
  })

#Check that encoding is character
test_that("retrieve_links() requires encoding to be character", {
  expect_error(
    retrieve_links(
      "http://web.archive.org/web/20190801001228/https://www.spiegel.de/",
      encoding = 1991
    ),
    "encoding is not a character value"
  )
})

#Check that encoding is character with length 1
test_that("retrieve_links() requires encoding to be character with length 1",
          {
            expect_error(
              retrieve_links(
                "http://web.archive.org/web/20190801001228/https://www.spiegel.de/",
                encoding = c("UTF-8", "bytes")
              ),
              "encoding is not a single value"
            )
          })


# Check error if filter not logical
test_that("retrieve_links() requires filter to be logical",
          {
            expect_error(
              retrieve_links(
                "http://web.archive.org/web/20190801001228/https://www.spiegel.de/",
                filter = "TRUE"),
              "filter is not a logical"
            )
          })


# Check error if filter length > 1
test_that("retrieve_links() requires filter to be logical",
          {
            expect_error(
              retrieve_links(
                "http://web.archive.org/web/20190801001228/https://www.spiegel.de/",
                filter = c(TRUE, FALSE)),
              "filter is not a single"
            )
          })


# Check error if pattern not character
test_that("retrieve_links() requires filter to be logical",
          {
            expect_error(
              retrieve_links(
                "http://web.archive.org/web/20190801001228/https://www.spiegel.de/",
                pattern = TRUE),
              "pattern must be a character"
            )
          })


# Check error if pattern length > 1
test_that("retrieve_links() requires filter to be logical",
          {
            expect_error(
              retrieve_links(
                "http://web.archive.org/web/20190801001228/https://www.spiegel.de/",
                pattern = c("pat1", "pat2")),
              "pattern is not a single"
            )
          })




#Check error message if timeout
test_that("retrieve_links() returns error if request timeout",
          {
            webmockr::enable()

            webmockr::to_timeout(
              webmockr::stub_request("get", "http://web.archive.org/web/20190801001228/https://www.spiegel.de/")
            )

            expect_error(
              retrieve_links(
                "http://web.archive.org/web/20190801001228/https://www.spiegel.de/"
              ),
              "Request Timeout"
            )
            webmockr::disable()
          })

#Check error message if status!=200
test_that("retrieve_links() returns error if request timeout",
          {
            webmockr::enable()

            webmockr::to_return(
              webmockr::stub_request("get", "http://web.archive.org/web/20190801001228/https://www.spiegel.de/"),
              status = 404
            )

            expect_error(
              retrieve_links(
                "http://web.archive.org/web/20190801001228/https://www.spiegel.de/"
              ),
              "HTTP status 404"
            )
            webmockr::disable()
          })

#Check ignoreErrors function
test_that("retrieve_links() returns dataframe if ignoreErrors = TRUE",
          {
            webmockr::enable()

            webmockr::to_return(
              webmockr::stub_request("get", "http://web.archive.org/web/20190801001228/https://www.spiegel.de/"),
              status = 404
            )
            output <- retrieve_links(
              "http://web.archive.org/web/20190801001228/https://www.spiegel.de/",
              ignoreErrors = TRUE
            )
            expect_is(output, "data.frame")

            webmockr::disable()
          })


#Check ingoreErrors for encoding errors
test_that("retrieve_links() returns dataframe if ignoreErrors = TRUE", {
          output <- retrieve_links("http://web.archive.org/web/20190801001228/https://www.spiegel.de/",
                                   encoding = "BIG5",
                                   ignoreErrors = TRUE)
          expect_is(output, "data.frame")
          })



# Check filter = TRUE
test_that("retrieve_links() returns a data frame", {
  vcr::use_cassette("retrieve_links2", {
    output <-
      retrieve_links("http://web.archive.org/web/20190801001228/https://www.spiegel.de/",
                     filter = TRUE)
  })
  expect_equal(nrow(output), 679)
})


# Check filter = TRUE for complicated top-level domains
test_that("retrieve_links() returns a data frame", {
  vcr::use_cassette("retrieve_links5", {
    output <-
      retrieve_links("http://web.archive.org/web/20200101044442/http://www.folha.uol.com.br/",
                     filter = TRUE)
  })
  expect_equal(nrow(output), 323)
})


# Check filter = FALSE
test_that("retrieve_links() returns a data frame", {
  vcr::use_cassette("retrieve_links3", {
    output <-
      retrieve_links("http://web.archive.org/web/20190801001228/https://www.spiegel.de/",
                     filter = FALSE)
  })
  expect_equal(nrow(output), 807)
})


# Check custom pattern
test_that("retrieve_links() returns a data frame", {
  vcr::use_cassette("retrieve_links4", {
    output <-
      retrieve_links("http://web.archive.org/web/20190801001228/https://www.spiegel.de/",
                     pattern = "spiegel.de/politik")
  })
  expect_equal(nrow(output), 37)
})




