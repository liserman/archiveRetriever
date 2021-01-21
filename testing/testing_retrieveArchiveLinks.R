retrieveArchiveLinks("http://web.archive.org/web/20190801001228/https://www.spiegel.de/")
retrieveArchiveLinks("http://web.archive.org/web/20151213005404/http://independent.co.uk:80/")
retrieveArchiveLinks("http://web.archive.org/web/20121202022453/http://nytimes.com/")
# ==> Funktioniert



# TESTS mit etw längeren URLs aus der Liste durch retrieveArchiveUrls:
retrieveArchiveLinks("http://web.archive.org/web/20190501154002/https://germany.mfa.gov.ua/de")
retrieveArchiveLinks("http://web.archive.org/web/20191019000250/http://twitter.timesopen.list@nytimes.com/")
retrieveArchiveLinks("http://web.archive.org/web/19990209105230/http://www10.nytimes.com:80/")
retrieveArchiveLinks("http://web.archive.org/web/20150122002030/http://independent.co.uk/")
# ==> Fehlermeldung
# er in names(fullUrls) <- ArchiveUrls :
#   Attribut 'names' [1] muss dieselbe Länge haben wie der Vektor [0]



### NICHT WEB-ARCHIVE URLS:
retrieveArchiveLinks("https://www.spiegel.de/")
retrieveArchiveLinks("https://www.theguardian.com/international")
# ==> Fehlermeldung erfolgreich
##absichtlich verändert:
retrieveArchiveLinks("http://web.arcive.org/web/20170913191635/http://sueddeutsche.de/")
retrieveArchiveLinks("http://archive.org/web/20170913191635/http://sueddeutsche.de/")
# ==> Fehlermeldung erfolgreich



### VERSCH URL FORMATE:
retrieveArchiveLinks("//web.archive.org/web/20121202022453/http://nytimes.com/")
retrieveArchiveLinks("//web.archive.org/web/20131005000337/http://spiegel.de/")
retrieveArchiveLinks("web.archive.org/web/20180102010140/http://www.sueddeutsche.de/")
# ==> Fehlermeldung: "Urls need to be Internet Archive Urls."



### ENDCODING:
retrieveArchiveLinks("http://web.archive.org/web/20121202022453/http://nytimes.com/","latin1")
retrieveArchiveLinks("http://web.archive.org/web/20131005000337/http://spiegel.de/","bytes") # (funktioniert nur damit oder latin1)
