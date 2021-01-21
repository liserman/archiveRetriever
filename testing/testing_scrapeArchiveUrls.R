# Testing (aus dem Skript)
#load("L:/Hiwi/Marcel/Webscraping/Raw Data/fullUrls/IT/corriere/corriere_2020-5.RData")

#test <- data[1:10]

#scrapeArchiveUrls(test, Paths = c(title = "//h2", content = "//p"))




# Testing 2 (ilsole 2017)
load("L:/Hiwi/Marcel/Webscraping/Raw Data/fullUrls/IT/ilsole24ore/ilsole24ore_2017-1.RData")

test <- data[15472]
test

scrapeArchiveUrls("http://web.archive.org/web/20170131060045/http://www.ilsole24ore.com/art/mondo/2017-01-30/marine-pen-front-national-145809.shtml?uuid=AEPbqfK&nmll=2707", Paths = c(title = "(//div[contains(@class,'title art11_title')]//h1 | //header/h1 | //h1[@class='atitle'] | //h1[@class='atitle '] | //article//article/header/h2[@class = 'title'])", content = "(//*[@class='grid-8 top art11_body body']//p//text() | //div[@class='aentry aentry--lined']//p//text() | //div[@class='entry entry-indent relative no_h']/p//text() | //div[@class='entry relative']/p//text())"), encoding = "bytes")
# ==> Funktioniert


test <- data[15472:15473]
test

scrapeArchiveUrls(test, Paths = c(title = "(//div[contains(@class,'title art11_title')]//h1 | //header/h1 | //h1[@class='atitle'] | //h1[@class='atitle '] | //article//article/header/h2[@class = 'title'])", content = "(//*[@class='grid-8 top art11_body body']//p//text() | //div[@class='aentry aentry--lined']//p//text() | //div[@class='entry entry-indent relative no_h']/p//text() | //div[@class='entry relative']/p//text())"), encoding = "bytes")
# ==> Funktioniert


test <- data[15472:15480]
test

scrapeArchiveUrls(test, Paths = c(title = "(//div[contains(@class,'title art11_title')]//h1 | //header/h1 | //h1[@class='atitle'] | //h1[@class='atitle '] | //article//article/header/h2[@class = 'title'])", content = "(//*[@class='grid-8 top art11_body body']//p//text() | //div[@class='aentry aentry--lined']//p//text() | //div[@class='entry entry-indent relative no_h']/p//text() | //div[@class='entry relative']/p//text())"), encoding = "bytes")
# ==> Fehler: Tibble columns must have compatible sizes.





### NICHT WEB-ARCHIVE URLS:
scrapeArchiveUrls("https://labour.org.uk/about/labours-legacy/", Paths = c(title = "//h1", content = "//p"))
scrapeArchiveUrls("http://www.ilsole24ore.com/art/mondo/2017-01-30/marine-pen-front-national-145809.shtml?uuid=AEPbqfK&nmll=2707", Paths = c(title = "(//div[contains(@class,'title art11_title')]//h1 | //header/h1 | //h1[@class='atitle'] | //h1[@class='atitle '] | //article//article/header/h2[@class = 'title'])", content = "(//*[@class='grid-8 top art11_body body']//p//text() | //div[@class='aentry aentry--lined']//p//text() | //div[@class='entry entry-indent relative no_h']/p//text() | //div[@class='entry relative']/p//text())"), encoding = "bytes")
# ==> Fehlermeldung erfolgreich



### VERSCH URL FORMATE:
scrapeArchiveUrls("//web.archive.org/web/20191225120342/http://sopofbv.uni-mannheim.de/", Paths = c(title = "//header//p", content = "//article//p"))
scrapeArchiveUrls("//web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/", Paths = c(title = "//header//h1", content = "//p"))
scrapeArchiveUrls("web.archive.org/web/20210109004557/https://democrats.org/", Paths = c(title = "//h1", content = "//p"))
# ==> Fehlermeldung: "Urls do not originate from the Internet Archive."



### UNBENANNTER X-PATH VEKTOR:
scrapeArchiveUrls("http://web.archive.org/web/20201009174440/https://www.uni-mannheim.de/universitaet/profil/geschichte/", "//header//h1")
scrapeArchiveUrls("http://web.archive.org/web/20191225120342/http://sopofbv.uni-mannheim.de/", Paths = "//header//p")
# ==> Fehlermeldung erfolgreich (Please provide a named vector of Xpath or CSS paths)



### VERSCH ANZAHL X-PATHS AUF EINMAL
scrapeArchiveUrls("http://web.archive.org/web/20191225120342/http://sopofbv.uni-mannheim.de/", Paths = c(title = "//header//p", subtitle = "//article//h2", content = "//article//p"))
# ==> Funktioniert



### VERSCH ARTEN WEBSEITE
scrapeArchiveUrls("http://web.archive.org/web/20210109004557/https://democrats.org/", Paths = c(title = "//h1", content = "//p"))
scrapeArchiveUrls("http://web.archive.org/web/20191225120342/http://sopofbv.uni-mannheim.de/", Paths = c(title = "//header//p", content = "//article//p"))
scrapeArchiveUrls("http://web.archive.org/web/20201227070438/https://labour.org.uk/about/labours-legacy/", Paths = c(title = "//h1", content = "//p"))
scrapeArchiveUrls("http://web.archive.org/web/20210121055015/https://twitter.com/BernieSanders", Paths = c(bio = "*[@class='Grid-cell']//h1")) #kein output für bio (wohl nicht der richtige path)
# ==> Funktioniert


