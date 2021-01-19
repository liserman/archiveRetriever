### Allg. FRAGEN ZUR HELP FILE als R newbie ###
 # - Warum nur " " bei endDate? --> help file: "string of the starting date"
 # - für Bsp nytimes: d/m/y richtig? --> stattdessen m/d/y? & " " auch für startDate



### SENSIVITÄT DATUMSFORMATE: Beispiele aus der help file testen ###
archiveOverview(homepage = "nytimes.com", startDate = 01/06/2018, endDate = "15/06/2019")
 # ==> Err: endDate is not a date
 #           - funktioniert ohne " dann aber (1 Tag für) 1970?
archiveOverview(homepage = "nytimes.com", startDate = 01/06/2018, endDate = 15/06/2019)
 #           - m/d/y ? --> funktionniert jetzt aber Zeitraum  1970 bis 2019?
archiveOverview(homepage = "nytimes.com", startDate = 06/01/2018, endDate = "06/15/2019")
 #           - m/d/y & innerhalb von einem Jahr? --> funktionniert jetzt aber Zeitraum  1970 bis 2018?
archiveOverview(homepage = "nytimes.com", startDate = 01/01/2018, endDate = "06/15/2018")
 #           - "" auch bei startDate --> funktionniert
archiveOverview(homepage = "nytimes.com", startDate = "01/01/2018", endDate = "06/15/2018")
archiveOverview(homepage = "nytimes.com", startDate = "06/01/2018", endDate = "06/15/2019")

archiveOverview(homepage = "www.spiegel.de", startDate = 20180601, endDate = "20190615")
 # ==> Funktioniert (auch wenn " für kein oder beide Datumangaben)


archiveOverview(homepage = "www.spiegel.de", startDate = 2018-06-01, endDate = "2019-06-15")
 # ==> funktioniert ABER Zeitraum 1975 bis 2019
archiveOverview(homepage = "www.spiegel.de", startDate = "2018-06-01", endDate = "2019-06-15")
 # ==> Funktioniert


### DATUMSFORMAT & JAHRESWECHSEL:
archiveOverview("www.spiegel.de", "2018-Jun-01", "2019-Jun-15")
archiveOverview("nytimes.com", "Jun/01/2017", "Jun/01/2018")
archiveOverview("nytimes.com", "Apr-15-2018", "Feb-15-2019")
archiveOverview("www.spiegel.de", "Jan 20 2013", "Jan 20 2014")
archiveOverview("www.spiegel.de", "01.01.2015", "01.01.2016")
archiveOverview("nytimes.com", "2010/10/20", "2011/10/20") # ohne ": 1970 - 2011
archiveOverview("nytimes.com", "April 10, 2019", "April 10, 2020")
archiveOverview("www.spiegel.de", "20Sep2014", "20Sep2015")
archiveOverview("nytimes.com", "01.January.2012", "01.January.2013")
# ==> Funktioniert, wenn "



### LANGER ZEITRAUM:
archiveOverview("nytimes.com", "Apr-15-2010", "Feb-15-2015")
archiveOverview("nytimes.com", "01.January.2010", "01.January.2020")
archiveOverview("www.sueddeutsche.de", "2007/10/20", "2020/10/20")
archiveOverview("www.sueddeutsche.de", "20Sep2005", "20Sep2020")
archiveOverview("www.spiegel.de",20000601, "20200615")
# ==> Funktioniert, ab >10 Jahre Plot *sehr* undeutlich



### WEIRDE TOP-LEVEL DOMAIN:
archiveOverview("www.independent.co.uk", "01.01.2015", "01.01.2016")
archiveOverview("www.mirror.co.uk", "20Sep2014", "20Sep2015")
archiveOverview("germany.mfa.gov.ua/de", "2018-Jun-01", "2019-Jun-15")
# ==> Funktioniert
#absichtlich verändert:
archiveOverview("www.mirror.co..uk", "20Sep2014", "20Sep2015")
archiveOverview("www.independent..co.uk", "20Sep2014", "20Sep2015")
archiveOverview("germany.mfa..gov..ua/de", "2018-Jun-01", "2019-Jun-15")
# ==> KEINE Fehlermeldung



### UNTERSEITE VON TOP-LEVEL DOMAIN:
archiveOverview("www.faz.net/aktuell/politik/politische-buecher/", "2018-Jun-01", "2019-Jun-15")
archiveOverview("taz.de/Kultur/!p4639/", "01.January.2017", "01.January.2018")
archiveOverview("www.theguardian.com/profile/rebecca-carroll", "Jun/01/2017", "Jun/01/2018")
archiveOverview("www.spiegel.de/schlagzeilen/",20190601, "20200615")
# ==> Funktioniert
archiveOverview("www.theguardian.com/commentisfree/2021/jan/18/who-deserves-the-wifi-the-war-is-on-in-my-house-and-i-am-losing", "01.December.2020", "19.January.2021")
# ==> Funktioniert



### NICHT-EXISTENTE URLS:
#absichtlich verändert um Fehlermeldung zu testen:
archiveOverview("www.spiegel.de/thema/us_praesidentschaftswahl_2019/", "2018-Jun-01", "2019-Jun-15")
archiveOverview("www.faz.net/aktuelll/gesellschaft/", "April 10, 2019", "April 10, 2020")
archiveOverview("nytimes.coom", "2010/10/20", "2011/10/20")
# ==> Fehlermeldung erfolgreich
archiveOverview("www.faz.net/aktuell//politik//politische-buecher//", "2018-Jun-01", "2019-Jun-15")
archiveOverview("nytimes...com", "Apr-15-2018", "Feb-15-2019")
# ==> KEINE Fehlermeldung bei mehrfachen . oder / (--> normal?)

