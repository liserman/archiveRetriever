context("check-retrieveUrls-output")
library(testthat)
library(webmockr)
library(archiveRetriever)


#Check whether vector is function output
test_that("retrieve_urls() returns a character vector", {
#  skip_on_cran()
  output <- retrieve_urls("nytimes.com", "Jun/01/2017", "Jun/01/2018")
  expect_is(output, "character")
})


#Check if start date is character
test_that("retrieve_urls() only takes character vectors as startDate", {
  expect_error(
    retrieve_urls("nytimes.com", 2015 - 01 - 01, "20Sep2015"),
    "startDate is not a character vector"
  )
})

#Check if end date is character
test_that("retrieve_urls() only takes character vectors as endDate", {
  expect_error(
    retrieve_urls("nytimes.com", "2015-01-01", 2015 - 05 - 31),
    "endDate is not a character vector"
  )
})

#Check if startdate is a date
test_that("retrieve_urls() only takes dates as startDate", {
  expect_error(retrieve_urls("nytimes.com", "date", "20Sep2015"),
               "startDate is not a date")
})

#Check if enddate is a date
test_that("retrieve_urls() only takes dates as startDate", {
  expect_error(retrieve_urls("nytimes.com", "2015-01-01", "date"),
               "endDate is not a date")
})

#Check if enddate is after startdate
test_that("retrieve_urls() needs endDate to be later than startDate", {
  expect_error(
    retrieve_urls("nytimes.com", "2016-01-01", "2015-05-31"),
    "startDate cannot be later"
  )
})

#Check if enddate is not in the future
test_that("retrieve_urls() needs endDate to be not in the future", {
  expect_error(
    retrieve_urls("nytimes.com", "2016-01-01", "2055-05-31"),
    "endDate cannot be in the future"
  )
})

#Check whether Homepage has ever been saved in the Internet Archive
test_that("retrieve_urls() needs homepage to be saved in the Internet Archive",
          {
            expect_error(
              retrieve_urls(
                "https://cyprus-mail.com/2021/02/18/the-secret-helping-car-companies-stay-profitable/",
                "2016-01-01",
                "2016-05-31"
              ),
              "Homepage has never been saved in the Internet Archive"
            )
          })

#Check error message if timeout
test_that("retrieve_links() returns error if request timeout",
          {
            webmockr::enable()

            webmockr::to_timeout(
              webmockr::stub_request("get", "https://www.nytimes.com/")
            )

            expect_error(
              retrieve_urls(homepage = "https://www.nytimes.com/",
                            startDate = "2020-10-01",
                            endDate = "2020-12-31"
              ),
              "Please check whether the page exists"
            )
            webmockr::disable()
          })


