context("check-retrieveLinks-output")
library(testthat)
library(archiveRetriever)

#Check whether function output is data frame
test_that("retrieveArchiveUrls() returns a data frame", {
  output <- retrieveArchiveLinks("http://web.archive.org/web/20190801001228/https://www.spiegel.de/")
  expect_is(output, "data.frame")
})

#Check that encoding is character
test_that("retrieveArchiveUrls() requires encoding to be character", {
  expect_error(retrieveArchiveLinks("http://web.archive.org/web/20190801001228/https://www.spiegel.de/", encoding = 1991), "encoding is not a character value")
})

#Check that encoding is character with length 1
test_that("retrieveArchiveUrls() requires encoding to be character with length 1", {
  expect_error(retrieveArchiveLinks("http://web.archive.org/web/20190801001228/https://www.spiegel.de/", encoding = c("UTF-8", "bytes")), "encoding is not a single value")
})
