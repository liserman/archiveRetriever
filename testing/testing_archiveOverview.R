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


