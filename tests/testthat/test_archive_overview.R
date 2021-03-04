context("check-overview-output")
library(testthat)
library(archiveRetriever)


#Check for the sensitivity of the date format
test_that("archive_overview() returns a plot with the correct time frame", {
  output_overview <-
    archive_overview(homepage = "nytimes.com",
                     startDate = "2018-06-01",
                     endDate = "Dec/01/2018")
  expect_equal(output_overview$data$date[1], as.Date("2018-06-01"))
  expect_equal(output_overview$data$date[nrow(output_overview$data)], as.Date("2018-12-01"))
})

#Check for correct output when covering more than one year
test_that("archive_overview() returns a plot in gtable class", {
  output_overview <-
    archive_overview(homepage = "nytimes.com",
                     startDate = "2018-06-01",
                     endDate = "Dec/01/2019")
  expect_is(output_overview, "gtable")
})

#Check for correct URLs only
test_that("archive_overview() only creates plot for existing URLs", {
  expect_error(
    archive_overview("www.independent..co.uk", "20Sep2014", "20Sep2015"),
    "Could not resolve host"
  )
})

#Check if start date is character
test_that("archive_overview() only takes character vectors as startDate", {
  expect_error(
    archive_overview("nytimes.com", 2015 - 01 - 01, "20Sep2015"),
    "startDate is not a character vector"
  )
})

#Check if end date is character
test_that("archive_overview() only takes character vectors as endDate", {
  expect_error(
    archive_overview("nytimes.com", "2015-01-01", 2015 - 05 - 31),
    "endDate is not a character vector"
  )
})

#Check if startdate is a date
test_that("archive_overview() only takes dates as startDate", {
  expect_error(archive_overview("nytimes.com", "date", "20Sep2015"),
               "startDate is not a date")
})

#Check if enddate is a date
test_that("archive_overview() only takes dates as startDate", {
  expect_error(archive_overview("nytimes.com", "2015-01-01", "date"),
               "endDate is not a date")
})

#Check if enddate is after startdate
test_that("archive_overview() needs endDate to be later than startDate", {
  expect_error(
    archive_overview("nytimes.com", "2016-01-01", "2015-05-31"),
    "startDate cannot be later"
  )
})

#Check if enddate is not in the future
test_that("archive_overview() needs endDate to be not in the future", {
  expect_error(
    archive_overview("nytimes.com", "2016-01-01", "2055-05-31"),
    "endDate cannot be in the future"
  )
})


#Check whether Homepage has ever been saved in the Internet Archive
test_that("archive_overview() needs homepage to be saved in the Internet Archive",
          {
            expect_error(
              archive_overview(
                "https://cyprus-mail.com/2021/02/18/the-secret-helping-car-companies-stay-profitable/",
                "2016-01-01",
                "2016-05-31"
              ),
              "Homepage has never been saved in the Internet Archive"
            )
          })


#Check whether URL exists with 200 status
test_that("archive_overview() needs homepage with status 200", {
  expect_error(
    archive_overview(
      "https://www.sowi.uni-mannheim.de/schoen/team/akademische-mitarbeiterinnen-und-mitarbeiter/gavras-konstantin/",
      "2016-01-01",
      "2016-05-31"
    ),
    "Please add an existing URL"
  )
})
