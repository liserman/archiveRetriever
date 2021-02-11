# Testing (aus dem Skript)
#load("L:/Hiwi/Marcel/Webscraping/Raw Data/fullUrls/IT/corriere/corriere_2020-5.RData")

#test <- data[1:10]

#scrapeArchiveUrls(test, Paths = c(title = "//h2", content = "//p"))




# Testing 2 (ilsole 2017)
load("L:/Hiwi/Marcel/Webscraping/Raw Data/fullUrls/IT/ilsole24ore/ilsole24ore_2017-1.RData")

test <- data[15472]
test

scrapeArchiveUrls("http://web.archive.org/web/20170131060045/http://www.ilsole24ore.com/art/mondo/2017-01-30/marine-pen-front-national-145809.shtml?uuid=AEPbqfK&nmll=2707", Paths = c(title = "//header/h1", content = "//div[@class='entry entry-indent relative no_h']/p//text()"), encoding = "bytes")
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



### UNVOLLSTÄNDIG BENANNTER X-PATH VEKTOR:
scrapeArchiveUrls("http://web.archive.org/web/20170131060045/http://www.ilsole24ore.com/art/mondo/2017-01-30/marine-pen-front-national-145809.shtml?uuid=AEPbqfK&nmll=2707", Paths = c(title = "//header/h1", "//div[@class='entry entry-indent relative no_h']/p//text()"), encoding = "bytes")
# ==> 2. Pfad wurde Xpath2 genannt
scrapeArchiveUrls("http://web.archive.org/web/20170131060045/http://www.ilsole24ore.com/art/mondo/2017-01-30/marine-pen-front-national-145809.shtml?uuid=AEPbqfK&nmll=2707", Paths = c("//header/h1", content = "//div[@class='entry entry-indent relative no_h']/p//text()"), encoding = "bytes")
# ==> 1. Pfad wurde Xpath1 genannt
scrapeArchiveUrls("http://web.archive.org/web/20191225120342/http://sopofbv.uni-mannheim.de/", Paths = c(title = "//header//p", "//article//h2", "//article//p"))
# ==> 2. & 3. Pfad wurden Xpath2 bzw Xpath3 genannt
scrapeArchiveUrls("http://web.archive.org/web/20191225120342/http://sopofbv.uni-mannheim.de/", Paths = c("//header//p", "//article//h2", "//article//p"))
# ==> Fehlermeldung (Please provide a named vector of Xpath or CSS paths)



### VERSCH ANZAHL X-PATHS AUF EINMAL
scrapeArchiveUrls("http://web.archive.org/web/20191225120342/http://sopofbv.uni-mannheim.de/", Paths = c(title = "//header//p", subtitle = "//article//h2", content = "//article//p"))
scrapeArchiveUrls("http://web.archive.org/web/20170131060045/http://www.ilsole24ore.com/art/mondo/2017-01-30/marine-pen-front-national-145809.shtml?uuid=AEPbqfK&nmll=2707", Paths = c(author = "//article//ul", title = "//header/h1", subtitle = "//article//h2", content = "//div[@class='entry entry-indent relative no_h']/p//text()"), encoding = "bytes")
# ==> Funktioniert



### VERSCH ARTEN WEBSEITE
scrapeArchiveUrls("http://web.archive.org/web/20210109004557/https://democrats.org/", Paths = c(title = "//h1", content = "//p"))
scrapeArchiveUrls("http://web.archive.org/web/20191225120342/http://sopofbv.uni-mannheim.de/", Paths = c(title = "//header//p", content = "//article//p"))
scrapeArchiveUrls("http://web.archive.org/web/20201227070438/https://labour.org.uk/about/labours-legacy/", Paths = c(title = "//h1", content = "//p"))
scrapeArchiveUrls("http://web.archive.org/web/20210121055015/https://twitter.com/BernieSanders", Paths = c(bio = "*[@class='Grid-cell']//h1")) #kein output für bio (wohl nicht der richtige path)
# ==> Funktioniert



### DATENOUTPUT TROTZ FEHLERMELDUNG
### ATTACHTO



### VERSCH WERTE EMPTYLIM
load("L:/Hiwi/Marcel/Webscraping/Raw Data/fullUrls/DE/taz/taz_2019-5.RData")
test <- data[1450:1480]
test
scrapeArchiveUrls(test, Paths = c(title = "//article//h1", content = "//article//p[contains(@class, 'article')]//text()"), emptylim = 13, encoding = "bytes")
# ==> Funktioniert: Error in scraping of Url 13 ... Too many empty outputs in a row.
scrapeArchiveUrls(test, Paths = c(title = "//article//h1", content = "//article//p[contains(@class, 'article')]//text()"), emptylim = 20, encoding = "bytes")
# ==> Funktioniert: Error in scraping of Url 20 ... Too many empty outputs in a row.



### STOPATEMPTY T/F
load("L:/Hiwi/Marcel/Webscraping/Raw Data/fullUrls/DE/taz/taz_2019-5.RData")
test <- data[1460:1480]
test
scrapeArchiveUrls(test, Paths = c(title = "//article//h1", content = "//article//p[contains(@class, 'article')]//text()"), encoding = "bytes")
# ==> Fehlermeldung erfolgreich: Error in scraping of Url 10 ... Too many empty outputs in a row.
scrapeArchiveUrls(test, Paths = c(title = "//article//h1", content = "//article//p[contains(@class, 'article')]//text()"), emptylim = 13, encoding = "bytes")
# ==> Fehlermeldung erfolgreich: Error in scraping of Url 13 ... Too many empty outputs in a row.
scrapeArchiveUrls(test, Paths = c(title = "//article//h1", content = "//article//p[contains(@class, 'article')]//text()"), stopatempty = F, encoding = "bytes")
# ==> Funktioniert (keine Fehlermeldung)



### IGNORE ERRORS T/F
load("L:/Hiwi/Marcel/Webscraping/Raw Data/fullUrls/DE/taz/taz_2019-5.RData")
test <- data[470:480]
test #(er: Tibble columns must have compatible sizes.)
scrapeArchiveUrls(test, Paths = c(title = "//article//h1", content = "//article//p[contains(@class, 'article')]//text()"), ignoreErrors = F, encoding = "bytes")
# ==> Fehler: Tibble columns must have compatible sizes.

scrapeArchiveUrls("http://web.archive.org/web/20170125090337/http://www.ilsole24ore.com/art/notizie/2015-06-08/le-razze-italiane-piccolo-levriero-italiano-204436.shtml", Paths = c(title = "(//div[contains(@class,'title art11_title')]//h1 | //header/h1 | //h1[@class='atitle'] | //h1[@class='atitle '] | //article//article/header/h2[@class = 'title'])", content = "(//*[@class='grid-8 top art11_body body']//p//text() | //article/div[@class='article-content ']/div/div/div//p//text() | //div[@class='aentry aentry--lined']//p//text())"), ignoreErrors = T, encoding = "bytes")
# ==> Funktioniert ("Only some of your Paths..." nicht angezeigt)



### ARCHIVE DATE T/F
scrapeArchiveUrls("http://web.archive.org/web/20170125090337/http://www.ilsole24ore.com/art/motori/2017-01-23/toyota-yaris-205049.shtml?uuid=AEAqSFG&nmll=2707", Paths = c(title = "(//div[contains(@class,'title art11_title')]//h1 | //header/h1 | //h1[@class='atitle'] | //h1[@class='atitle '] | //article//article/header/h2[@class = 'title'] | //h2[@class = 'title'])", content = "(//*[@class='grid-8 top art11_body body']//p//text() | //article/div[@class='article-content ']/div/div/div//p//text() | //div[@class='aentry aentry--lined']//p//text())"), archiveDate = T, encoding = "bytes")
scrapeArchiveUrls("http://web.archive.org/web/20190528072311/https://www.taz.de/Fusionsangebot-in-der-Autobranche/!5598075/", Paths = c(title = "//article//h1", content = "//article//p[contains(@class, 'article')]//text()"), archiveDate = T, encoding = "bytes")
# ==> Funktioniert



### STARTNUM
load("L:/Hiwi/Marcel/Webscraping/Raw Data/fullUrls/IT/ilsole24ore/ilsole24ore_2017-1.RData")
test <- data[15465:15470]
test
scrapeArchiveUrls(test, Paths = c(title = "(//div[contains(@class,'title art11_title')]//h1 | //header/h1 | //h1[@class='atitle'] | //h1[@class='atitle '] | //article//article/header/h2[@class = 'title'])", content = "(//*[@class='grid-8 top art11_body body']//p//text() | //div[@class='aentry aentry--lined']//p//text() | //div[@class='entry entry-indent relative no_h']/p//text() | //div[@class='entry relative']/p//text())"), startnum = 2, encoding = "bytes")
# ==> Fehler: Tibble columns must have compatible sizes.

load("L:/Hiwi/Marcel/Webscraping/Raw Data/fullUrls/DE/taz/taz_2019-5.RData")
test <- data[6472:6480]
test
scrapeArchiveUrls(test, Paths = c(title = "//article//h1", content = "//article//p[contains(@class, 'article')]//text()"), startnum = 5, encoding = "bytes")
# ==> Fehler: Tibble columns must have compatible sizes.



### CSS
scrapeArchiveUrls("http://web.archive.org/web/20190528072311/https://www.taz.de/Fusionsangebot-in-der-Autobranche/!5598075/", Paths = c(title = "article h1"), CSS = T)
scrapeArchiveUrls("http://web.archive.org/web/20190528072311/https://www.taz.de/Fusionsangebot-in-der-Autobranche/!5598075/", Paths = c(title = "article h1", content = "article .article"), CSS = T)
scrapeArchiveUrls("http://web.archive.org/web/20191225120342/http://sopofbv.uni-mannheim.de/", Paths = c(title = "header p", subtitle = "article h2", content = "article p"), CSS = T)
scrapeArchiveUrls("http://web.archive.org/web/20170131060045/http://www.ilsole24ore.com/art/mondo/2017-01-30/marine-pen-front-national-145809.shtml?uuid=AEPbqfK&nmll=2707", Paths = c(author = "article ul", title = "header > h1", subtitle = "article h2", content = ".entry p"),CSS = T, encoding = "bytes")
# ==> Funktioniert



### REPRODUZIEREN FEHLERMELDUNGEN ALTES SKRIPT
load("L:/Hiwi/Marcel/Webscraping/Raw Data/fullUrls/IT/ilsole24ore/ilsole24ore_2017-1.RData")
test <- data[12409]
test #(Problem: anderer title path nötig (row err))
scrapeArchiveUrls("http://web.archive.org/web/20170125090337/http://www.ilsole24ore.com/art/notizie/2015-06-08/le-razze-italiane-piccolo-levriero-italiano-204436.shtml", Paths = c(title = "(//div[contains(@class,'title art11_title')]//h1 | //header/h1 | //h1[@class='atitle'] | //h1[@class='atitle '] | //article//article/header/h2[@class = 'title'])", content = "(//*[@class='grid-8 top art11_body body']//p//text() | //article/div[@class='article-content ']/div/div/div//p//text() | //div[@class='aentry aentry--lined']//p//text())"), encoding = "bytes")
# ==> Fehlermeldung: Only some of your Paths could be extracted. A preliminary output has been printed. (nur output für content)

test <- data[12631]
test #(Problem: row err)
scrapeArchiveUrls("http://web.archive.org/web/20170125090337/http://www.ilsole24ore.com/art/motori/2017-01-23/toyota-yaris-205049.shtml?uuid=AEAqSFG&nmll=2707", Paths = c(title = "(//div[contains(@class,'title art11_title')]//h1 | //header/h1 | //h1[@class='atitle'] | //h1[@class='atitle '] | //article//article/header/h2[@class = 'title'] | //h2[@class = 'title'])", content = "(//*[@class='grid-8 top art11_body body']//p//text() | //article/div[@class='article-content ']/div/div/div//p//text() | //div[@class='aentry aentry--lined']//p//text())"), encoding = "bytes")
# ==> KEINE Fehlermeldung

test <- data[12838]
test #(Problem: row err)
scrapeArchiveUrls("http://web.archive.org/web/20170126051425/http://www.ilsole24ore.com/art/notizie/2017-01-25/bocciato-ballottaggio-181501.shtml?uuid=AEHj6wH&nmll=2707", Paths = c(title = "(//div[contains(@class,'title art11_title')]//h1 | //header/h1 | //h1[@class='atitle'] | //h1[@class='atitle '] | //article//article/header/h2[@class = 'title'] | //h2[@class = 'title'])", content = "(//*[@class='grid-8 top art11_body body']//p//text() | //div[@class='aentry aentry--lined']//p//text() | //div[@class='row relative sticky_parent']//p//text())"), encoding = "bytes")
# ==> KEINE Fehlermeldung

test <- data[12948]
test #(Problem: row err)
scrapeArchiveUrls("http://web.archive.org/web/20170126051425/http://www.ilsole24ore.com/art/tecnologie/2016-11-23/senior--non-e-questione-eta-195943.shtml", Paths = c(title = "(//div[contains(@class,'title art11_title')]//h1 | //header/h1 | //h1[@class='atitle'] | //h1[@class='atitle '] | //article//article/header/h2[@class = 'title'] | //h2[@class = 'title'])", content = "(//*[@class='grid-8 top art11_body body']//p//text() | //div[@class='aentry aentry--lined']//p//text() | //div[@class='col-md-8 col-sm-11 col-xs-12 full-print']//p//text())"), encoding = "bytes")
# ==> KEINE Fehlermeldung

test <- data[15472]
test #(Problem: row err)
scrapeArchiveUrls("http://web.archive.org/web/20170131060045/http://www.ilsole24ore.com/art/mondo/2017-01-30/marine-pen-front-national-145809.shtml?uuid=AEPbqfK&nmll=2707", Paths = c(title = "(//div[contains(@class,'title art11_title')]//h1 | //header/h1 | //h1[@class='atitle'] | //h1[@class='atitle '] | //article//article/header/h2[@class = 'title'] | //h2[@class = 'title'])", content = "(//*[@class='grid-8 top art11_body body']//p//text() | //div[@class='aentry aentry--lined']//p//text() | //div[@class='entry entry-indent relative no_h']/p//text())"), encoding = "bytes")
# ==> KEINE Fehlermeldung



### VERSCH ENCODINGS



### HOMEPAGES NICHT-EUROPÄISCHE SPRACHE
scrapeArchiveUrls("http://web.archive.org/web/20200320003840/https://www.nus.edu.sg/cn/enterprise", Paths = c(title = "//h1", content = "//p"))
scrapeArchiveUrls("http://web.archive.org/web/20200424220217/https://spbu.ru/universitet/klinika-spbgu", Paths = c(title = "//main//h1", content = "//article//p"))
scrapeArchiveUrls("http://web.archive.org/web/20200311223720/https://cu.edu.eg/ar/page.php?pg=contentFront%2FSubSectionData.php&SubSectionId=224", Paths = c(title = "//section//h4", content = "//article//section//p[3]"))
# ==> Funktioniert



### GROSSE ANZAHL URLS
load("L:/Hiwi/Marcel/Webscraping/Raw Data/fullUrls/IT/ilsole24ore/ilsole24ore_2017-1.RData")
test <- data[15472:15600]
test
scrapeArchiveUrls(test, Paths = c(title = "//header/h1", content = "//div[@class='entry entry-indent relative no_h']/p//text()"), encoding = "bytes")
# ==> Warnunug erfolgreich (You are about to scrape the information from a large number of Urls...)
# mit y dennoch durchgeführt:
#  --> nach 80%: er: Tibble columns must have compatible sizes.


