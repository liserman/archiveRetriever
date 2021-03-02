context("check-retrieveLinks-output")
library(testthat)
library(archiveRetriever)

#Check whether function output is data frame
test_that("retrieveArchiveUrls() returns a data frame", {
  output <- retrieveArchiveLinks("http://web.archive.org/web/20190801001228/https://www.spiegel.de/")
  expect_is(output, "data.frame")
})



