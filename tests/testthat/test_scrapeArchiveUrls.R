context("check-scrapeURLs-output")
library(testthat)
library(archiveRetriever)



#Check whether function output is data frame
test_that("scrapeArchiveUrls() returns a data frame", {
  output <- scrapeArchiveUrls("http://web.archive.org/web/20170131060045/http://www.ilsole24ore.com/art/mondo/2017-01-30/marine-pen-front-national-145809.shtml?uuid=AEPbqfK&nmll=2707", Paths = c(title = "//header/h1", content = "//div[@class='entry entry-indent relative no_h']/p//text()"), encoding = "bytes")
  expect_is(output, "data.frame")
})


#Check whether function only takes Archive links
test_that("scrapeArchiveUrls() only takes Internet Archive URLs as input", {
  expect_error(scrapeArchiveUrls("https://labour.org.uk/about/labours-legacy/", Paths = c(title = "//h1", content = "//p")), "Urls do not originate")
})

#Check whether XPath vector is named
test_that("scrapeArchiveUrls() only takes named XPath/CSS vector", {
  expect_error(scrapeArchiveUrls("http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/", "//header//h1"), "Paths is not a")
})


#Check whether Archive date is taken from the URL
test_that("scrapeArchiveUrls() option archiveDate stores archiving date", {
  output <- scrapeArchiveUrls("http://web.archive.org/web/20170125090337/http://www.ilsole24ore.com/art/motori/2017-01-23/toyota-yaris-205049.shtml?uuid=AEAqSFG&nmll=2707", Paths = c(title = "(//div[contains(@class,'title art11_title')]//h1 | //header/h1 | //h1[@class='atitle'] | //h1[@class='atitle '] | //article//article/header/h2[@class = 'title'] | //h2[@class = 'title'])", content = "(//*[@class='grid-8 top art11_body body']//p//text() | //article/div[@class='article-content ']/div/div/div//p//text() | //div[@class='aentry aentry--lined']//p//text())"), archiveDate = T, encoding = "bytes")
  scrapeArchiveUrls("http://web.archive.org/web/20190528072311/https://www.taz.de/Fusionsangebot-in-der-Autobranche/!5598075/", Paths = c(title = "//article//h1", content = "//article//p[contains(@class, 'article')]//text()"), archiveDate = T, encoding = "bytes")
  expect_equal(names(output)[4], "archiveDate")
})


#Check whether function takes CSS instead of XPath
test_that("scrapeArchiveUrls() takes CSS instead of XPath", {
  output <- scrapeArchiveUrls("http://web.archive.org/web/20190528072311/https://www.taz.de/Fusionsangebot-in-der-Autobranche/!5598075/", Paths = c(title = "article h1"), CSS = T)
  expect_is(output, "data.frame")
})
