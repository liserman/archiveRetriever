### Allg. FRAGEN ZUR HELP FILE als R newbie ###
# - Warum nur " " hier anders als bei der help file zu archiveOverview?
# - endDate Format bei nytimes example falsch?

### DATUMSFORMAT:
retrieveArchiveUrls("www.spiegel.de", 20190801, 20190901)
retrieveArchiveUrls("nytimes.com", 01/01/2018, "06/15/2019") #again: 06/15 works 15/06 not
retrieveArchiveUrls("nytimes.com", 2010/10/20, "2011/10/20") #2395 Urls | mit ": 366
retrieveArchiveUrls("www.spiegel.de", 2018-06-01, "2019-06-15") #4303 Urls | mit": 380
# ==> Funktioniert
retrieveArchiveUrls("www.spiegel.de", "2018-Jun-01", "2019-Jun-15")
retrieveArchiveUrls("nytimes.com", "Jun/01/2017", "Jun/01/2018")
retrieveArchiveUrls("nytimes.com", "Apr-15-2018", "Feb-15-2019")
retrieveArchiveUrls("www.spiegel.de", "Jan 20 2013", "Jan 20 2014")
retrieveArchiveUrls("www.spiegel.de", "01.01.2015", "01.01.2016")
retrieveArchiveUrls("nytimes.com", "April 10, 2019", "April 10, 2020")
retrieveArchiveUrls("www.spiegel.de", "20Sep2014", "20Sep2015")
retrieveArchiveUrls("nytimes.com", "01.January.2012", "01.January.2013")
# ==> Funktioniert, wenn "



### WEIRDE TOP-LEVEL DOMAIN:
retrieveArchiveUrls("www.independent.co.uk", "01.01.2015", "01.01.2016")
retrieveArchiveUrls("www.mirror.co.uk", "20Sep2014", "20Sep2015")
retrieveArchiveUrls("germany.mfa.gov.ua/de", "2018-Jun-01", "2019-Jun-15")
# ==> Funktioniert
#absichtlich verändert:
retrieveArchiveUrls("www.mirror.co..uk", "20Sep2014", "20Sep2015")
retrieveArchiveUrls("www.independent..co.uk", "20Sep2014", "20Sep2015")
retrieveArchiveUrls("germany.mfa..gov...ua/de", "2018-Jun-01", "2019-Jun-15")
# ==> KEINE Fehlermeldung



### NICHT-EXISTENTE URLS:
#absichtlich verändert um Fehlermeldung zu testen:
retrieveArchiveUrls("www.spiegel.de/thema/us_praesidentschaftswahl_2019/", "2018-Jun-01", "2019-Jun-15")
retrieveArchiveUrls("www.faz.net/aktuelll/gesellschaft/", "April 10, 2019", "April 10, 2020")
retrieveArchiveUrls("nytimes.coom", "2010/10/20", "2011/10/20")
# ==> Fehlermeldung erfolgreich
retrieveArchiveUrls("www.faz.net/aktuell//politik//politische-buecher//", "2018-Jun-01", "2019-Jun-15")
retrieveArchiveUrls("nytimes...com", "Apr-15-2018", "Feb-15-2019")
# ==> KEINE Fehlermeldung bei mehrfachem . oder / (--> normal?)

