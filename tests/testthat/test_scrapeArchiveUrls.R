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

#Check whether Paths is character vector
test_that("scrapeArchiveUrls() only takes character vectors as Paths", {
  expect_error(scrapeArchiveUrls("http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/", c(title = 1)), "Paths is not a character vector")
})


#Check whether XPath vector is named
test_that("scrapeArchiveUrls() only takes named XPath/CSS vector as Paths", {
  expect_error(scrapeArchiveUrls("http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/", "//header//h1"), "Paths is not a named vector")
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


#Check whether startnum is numeric
test_that("scrapeArchiveUrls() needs numeric startnum", {
  expect_error(scrapeArchiveUrls(c("http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                   "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/"), c(title = "//header//h1"), startnum = "2"), "startnum is not numeric")
})

#Check whether startnum exceeds number of Urls
test_that("scrapeArchiveUrls() needs startnum smaller than input vector", {
  expect_error(scrapeArchiveUrls(c("http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                   "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/"), c(title = "//header//h1"), startnum = 3), "startnum value exceeds number of Urls given")
})

#Check whether startnum is single value
test_that("scrapeArchiveUrls() needs startnum to be a single value", {
  expect_error(scrapeArchiveUrls(c("http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                   "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/"), c(title = "//header//h1"), startnum = c(1,3)), "startnum is not a single value")
})

#Check whether CSS is a logical value
test_that("scrapeArchiveUrls() needs CSS to be a logical value", {
  expect_error(scrapeArchiveUrls("http://web.archive.org/web/20190528072311/https://www.taz.de/Fusionsangebot-in-der-Autobranche/!5598075/", Paths = c(title = "article h1"), CSS = "T"),"CSS is not a logical value")
})

#Check whether CSS is single value
test_that("scrapeArchiveUrls() needs CSS to be a single logical value", {
  expect_error(scrapeArchiveUrls("http://web.archive.org/web/20190528072311/https://www.taz.de/Fusionsangebot-in-der-Autobranche/!5598075/", Paths = c(title = "article h1"), CSS = c(T,T)),"CSS is not a single value")
})

#Check whether archiveDate is a logical value
test_that("scrapeArchiveUrls() needs archiveDate to be a logical value", {
  expect_error(scrapeArchiveUrls("http://web.archive.org/web/20190528072311/https://www.taz.de/Fusionsangebot-in-der-Autobranche/!5598075/", Paths = c(title = "article h1"), CSS = T, archiveDate = "T"),"archiveDate is not a logical value")
})

#Check whether archiveDate is single value
test_that("scrapeArchiveUrls() needs archiveDate to be a single logical value", {
  expect_error(scrapeArchiveUrls("http://web.archive.org/web/20190528072311/https://www.taz.de/Fusionsangebot-in-der-Autobranche/!5598075/", Paths = c(title = "article h1"), CSS = T, archiveDate = c(T,T)),"archiveDate is not a single value")
})

#Check whether ignoreErrors is a logical value
test_that("scrapeArchiveUrls() needs ignoreErrors to be a logical value", {
  expect_error(scrapeArchiveUrls("http://web.archive.org/web/20190528072311/https://www.taz.de/Fusionsangebot-in-der-Autobranche/!5598075/", Paths = c(title = "article h1"), CSS = T, archiveDate = T, ignoreErrors = "T"),"ignoreErrors is not a logical value")
})

#Check whether ignoreErrors is single value
test_that("scrapeArchiveUrls() needs ignoreErrors to be a single logical value", {
  expect_error(scrapeArchiveUrls("http://web.archive.org/web/20190528072311/https://www.taz.de/Fusionsangebot-in-der-Autobranche/!5598075/", Paths = c(title = "article h1"), CSS = T, archiveDate = T, ignoreErrors = c(T,T)),"ignoreErrors is not a single value")
})

#Check whether stopatempty is a logical value
test_that("scrapeArchiveUrls() needs stopatempty to be a logical value", {
  expect_error(scrapeArchiveUrls("http://web.archive.org/web/20190528072311/https://www.taz.de/Fusionsangebot-in-der-Autobranche/!5598075/", Paths = c(title = "article h1"), CSS = T, archiveDate = T, ignoreErrors = T, stopatempty = "T"),"stopatempty is not a logical value")
})

#Check whether stopatempty is single value
test_that("scrapeArchiveUrls() needs stopatempty to be a single logical value", {
  expect_error(scrapeArchiveUrls("http://web.archive.org/web/20190528072311/https://www.taz.de/Fusionsangebot-in-der-Autobranche/!5598075/", Paths = c(title = "article h1"), CSS = T, archiveDate = T, ignoreErrors = T, stopatempty = c(T,T)),"stopatempty is not a single value")
})

#Check whether emptylim is a numeric value
test_that("scrapeArchiveUrls() needs emptylim to be a numeric value", {
  expect_error(scrapeArchiveUrls("http://web.archive.org/web/20190528072311/https://www.taz.de/Fusionsangebot-in-der-Autobranche/!5598075/", Paths = c(title = "article h1"), CSS = T, archiveDate = T, ignoreErrors = T, stopatempty = T, emptylim = "5"),"emptylim is not numeric")
})

#Check whether emptylim is single value
test_that("scrapeArchiveUrls() needs emptylim to be a numeric value", {
  expect_error(scrapeArchiveUrls("http://web.archive.org/web/20190528072311/https://www.taz.de/Fusionsangebot-in-der-Autobranche/!5598075/", Paths = c(title = "article h1"), CSS = T, archiveDate = T, ignoreErrors = T, stopatempty = T, emptylim = c(5,6)),"emptylim is not a single value")
})

#Check whether encoding is a character value
test_that("scrapeArchiveUrls() needs encoding to be a character value", {
  expect_error(scrapeArchiveUrls("http://web.archive.org/web/20190528072311/https://www.taz.de/Fusionsangebot-in-der-Autobranche/!5598075/", Paths = c(title = "article h1"), CSS = T, archiveDate = T, ignoreErrors = T, stopatempty = T, emptylim = 5, encoding = 1991),"encoding is not a character value")
})

#Check whether encoding is single value
test_that("scrapeArchiveUrls() needs encoding to be a character value", {
  expect_error(scrapeArchiveUrls("http://web.archive.org/web/20190528072311/https://www.taz.de/Fusionsangebot-in-der-Autobranche/!5598075/", Paths = c(title = "article h1"), CSS = T, archiveDate = T, ignoreErrors = T, stopatempty = T, emptylim = 5, encoding = c("UTF-8", "bytes")),"encoding is not a single value")
})


#Check whether data is being correctly attached to existing data set
test_that("scrapeArchiveUrls() needs to fill first row when only second value is scraped", {
  output <- scrapeArchiveUrls(c("http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                   "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/"), c(title = "//header//h1"), startnum = 2)
  expect_equal(is.na(output$title[1]), T)
})


#Check whether only some XPaths could be scraped
test_that("scrapeArchiveUrls() needs to warn if only some XPaths can be scraped", {
  expect_warning(scrapeArchiveUrls("http://web.archive.org/web/20170125090337/http://www.ilsole24ore.com/art/notizie/2015-06-08/le-razze-italiane-piccolo-levriero-italiano-204436.shtml", Paths = c(title = "(//div[contains(@class,'title art11_title')]//h1 | //header/h1 | //h1[@class='atitle'] | //h1[@class='atitle '] | //article//article/header/h2[@class = 'title'])", content = "(//*[@class='grid-8 top art11_body body']//p//text() | //article/div[@class='article-content ']/div/div/div//p//text() | //div[@class='aentry aentry--lined']//p//text())"), ignoreErrors = F, encoding = "bytes"), "Only some of your Paths")
})


#Check whether data is being correctly processed
test_that("scrapeArchiveUrls() needs to set NA if page cannot be scraped", {
  output <- scrapeArchiveUrls(c("http://web.archive.org/web/20190502052859/http://www.taz.de/Praesident-Trong-scheut-Oeffentlichkeit/!5588752/",
                                "http://web.archive.org/web/20190502052859/http://blogs.taz.de/",
                                "http://web.archive.org/web/20190502052859/http://www.taz.de/Galerie/Die-Revolution-im-Sudan/!g5591075/"),
                              Paths = c(title = "//article//h1", content = "//article//p[contains(@class, 'article')]//text()"))
  expect_equal(is.na(output$title[3]), T)
})


#Check whether process stop if too many rows are empty
test_that("scrapeArchiveUrls() needs to stop if too many row are empty", {
  expect_warning(scrapeArchiveUrls(c("http://web.archive.org/web/20190502052859/http://www.taz.de/Praesident-Trong-scheut-Oeffentlichkeit/!5588752/",
                                "http://web.archive.org/web/20190502052859/http://blogs.taz.de/",
                                "http://web.archive.org/web/20190502052859/http://blogs.taz.de/lostineurope",
                                "http://web.archive.org/web/20190502052859/http://blogs.taz.de/lostineurope/blogfeed/"),
                              Paths = c(title = "//article//h1", content = "//article//p[contains(@class, 'article')]//text()"),
                              stopatempty = T,
                              emptylim = 2), "Too many empty outputs in a row")
})


#Check if re-start after break and attachto works
test_that("scrapeArchiveUrls() needs to take up process if it breaks", {
  output <- scrapeArchiveUrls(c("http://web.archive.org/web/20190502052859/http://www.taz.de/Praesident-Trong-scheut-Oeffentlichkeit/!5588752/",
                                "http://web.archive.org/web/20190502052859/http://blogs.taz.de/",
                                "http://web.archive.org/web/20190502052859/http://blogs.taz.de/lostineurope",
                                "http://web.archive.org/web/20190502052859/http://blogs.taz.de/lostineurope/blogfeed/"),
                              Paths = c(title = "//article//h1", content = "//article//p[contains(@class, 'article')]//text()"),
                              stopatempty = F,
                              attachto = tibble::tibble(Urls = c("http://web.archive.org/web/20190502052859/http://www.taz.de/Praesident-Trong-scheut-Oeffentlichkeit/!5588752/",
                                                                 "http://web.archive.org/web/20190502052859/http://blogs.taz.de/",
                                                                 "http://web.archive.org/web/20190502052859/http://blogs.taz.de/lostineurope"),
                                                        title = c("Vietnamesen rätseln um Staatschef",
                                                                  "",
                                                                  ""),
                                                        content = c("Wer regiert Vietnam? Offenbar ist Partei- und Staatschef Nguyen Phu Trong dazu nicht mehr fähig:",
                                                                    "",
                                                                    ""),
                                                        progress = c(1,0,0)))

  expect_equal(ncol(output), 3)
})


#Check if re-start after break and attachto works
test_that("scrapeArchiveUrls() should not take up process if it stems from other process", {
  expect_error(scrapeArchiveUrls(c("http://web.archive.org/web/20190502052859/http://www.taz.de/Praesident-Trong-scheut-Oeffentlichkeit/!5588752/",
                                "http://web.archive.org/web/20190502052859/http://blogs.taz.de/",
                                "http://web.archive.org/web/20190502052859/http://blogs.taz.de/lostineurope",
                                "http://web.archive.org/web/20190502052859/http://blogs.taz.de/lostineurope/blogfeed/"),
                              Paths = c(title = "//article//h1", content = "//article//p[contains(@class, 'article')]//text()"),
                              stopatempty = F,
                              attachto = tibble::tibble(Urls = c("http://web.archive.org/web/20190502052859/http://www.taz.de/Praesident-Trong-scheut-Oeffentlichkeit/!5588752/",
                                                                 "http://web.archive.org/web/20190502052859/http://blogs.taz.de/",
                                                                 "http://web.archive.org/web/20190502052859/http://blogs.taz.de/lostineurope"),
                                                        title = c("Vietnamesen rätseln um Staatschef",
                                                                  "",
                                                                  ""),
                                                        inhalt = c("Wer regiert Vietnam? Offenbar ist Partei- und Staatschef Nguyen Phu Trong dazu nicht mehr fähig:",
                                                                    "",
                                                                    ""),
                                                        progress = c(1,0,0))),"attachto must be a failed output of this function")
})

#Check if re-start after break and attachto works
test_that("scrapeArchiveUrls() should not take up process if it stems from other process", {
  expect_error(scrapeArchiveUrls(c("http://web.archive.org/web/20190502052859/http://www.taz.de/Praesident-Trong-scheut-Oeffentlichkeit/!5588752/",
                                   "http://web.archive.org/web/20190502052859/http://blogs.taz.de/",
                                   "http://web.archive.org/web/20190502052859/http://blogs.taz.de/lostineurope",
                                   "http://web.archive.org/web/20190502052859/http://blogs.taz.de/lostineurope/blogfeed/"),
                                 Paths = c(title = "//article//h1", content = "//article//p[contains(@class, 'article')]//text()"),
                                 stopatempty = F,
                                 attachto = tibble::tibble(Urls = c("http://web.archive.org/web/20190502052859/http://www.taz.de/Praesident-Trong-scheut-Oeffentlichkeit",
                                                                    "http://web.archive.org/web/20190502052859/http://blogs.taz.de/",
                                                                    "http://web.archive.org/web/20190502052859/http://blogs.taz.de/lostineurope"),
                                                           title = c("Vietnamesen rätseln um Staatschef",
                                                                     "",
                                                                     ""),
                                                           content = c("Wer regiert Vietnam? Offenbar ist Partei- und Staatschef Nguyen Phu Trong dazu nicht mehr fähig:",
                                                                      "",
                                                                      ""),
                                                           progress = c(1,0,0))),"Input Urls and Urls in attachto file differ")
})


#Check whether sleeper is activated after 20 Urls

test_that("scrapeArchiveUrls() needs to sleep every 20 Urls", {
  output <- scrapeArchiveUrls(c("http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/",
                                "http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/"), c(title = "//header//h1"))
  expect_equal(nrow(output), 21)
})



