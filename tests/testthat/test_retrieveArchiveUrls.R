context("check-retrieveUrls-output")
library(testthat)
library(archiveRetriever)


#Check whether vector is function output
test_that("retrieveArchiveUrls() returns a character vector", {
output <- retrieveArchiveUrls("nytimes.com", "Jun/01/2017", "Jun/01/2018")
expect_is(output, "character")
})
