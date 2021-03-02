context("check-overview-output")
library(testthat)
library(archiveRetriever)


#Check for the sensitivity of the date format
test_that("archiveOverview() returns a plot with the correct time frame", {
  output_overview <- archiveOverview(homepage = "nytimes.com", startDate = "2018-06-01", endDate = "Dec/01/2018")
  expect_equal(output_overview$data$date[1], as.Date("2018-06-01"))
  expect_equal(output_overview$data$date[nrow(output_overview$data)], as.Date("2018-12-01"))
})


#Check for correct URLs only
test_that("archiveOverview() only creates plot for existing URLs", {
  expect_error(archiveOverview("www.independent..co.uk", "20Sep2014", "20Sep2015"), "Could not resolve host")
})
