context("check-retrieveUrls-output")
library(testthat)
library(archiveRetriever)


#Check whether vector is function output
test_that("retrieve_urls() returns a character vector", {
output <- retrieve_urls("nytimes.com", "Jun/01/2017", "Jun/01/2018")
expect_is(output, "character")
})


#Check if start date is character
test_that("retrieve_urls() only takes character vectors as startDate", {
  expect_error(retrieve_urls("nytimes.com", 2015-01-01, "20Sep2015"), "startDate is not a character vector")
})

#Check if end date is character
test_that("retrieve_urls() only takes character vectors as endDate", {
  expect_error(retrieve_urls("nytimes.com", "2015-01-01", 2015-05-31), "endDate is not a character vector")
})

#Check if startdate is a date
test_that("retrieve_urls() only takes dates as startDate", {
  expect_error(retrieve_urls("nytimes.com", "date", "20Sep2015"), "startDate is not a date")
})

#Check if enddate is a date
test_that("retrieve_urls() only takes dates as startDate", {
  expect_error(retrieve_urls("nytimes.com", "2015-01-01", "date"), "endDate is not a date")
})

#Check if enddate is after startdate
test_that("retrieve_urls() needs endDate to be later than startDate", {
  expect_error(retrieve_urls("nytimes.com", "2016-01-01", "2015-05-31"), "startDate cannot be later")
})

#Check if enddate is not in the future
test_that("retrieve_urls() needs endDate to be not in the future", {
  expect_error(retrieve_urls("nytimes.com", "2016-01-01", "2055-05-31"), "endDate cannot be in the future")
})

#Check whether Homepage has ever been saved in the Internet Archive
test_that("retrieve_urls() needs homepage to be saved in the Internet Archive", {
  expect_error(retrieve_urls("https://cyprus-mail.com/2021/02/18/the-secret-helping-car-companies-stay-profitable/", "2016-01-01", "2016-05-31"), "Homepage has never been saved in the Internet Archive")
})

#Check whether URL exists with 200 status
test_that("retrieve_urls() needs homepage with status 200", {
  expect_error(retrieve_urls("https://www.sowi.uni-mannheim.de/schoen/team/akademische-mitarbeiterinnen-und-mitarbeiter/gavras-konstantin/", "2016-01-01", "2016-05-31"), "Please add an existing URL")
})


