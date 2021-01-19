retrieveArchiveLinks("http://web.archive.org/web/20190801001228/https://www.spiegel.de/")
retrieveArchiveLinks("http://web.archive.org/web/20151213005404/http://independent.co.uk:80/")
retrieveArchiveLinks("http://web.archive.org/web/20121202022453/http://nytimes.com/")
# ==> Funktioniert


# TESTS mit etw längeren URLs aus der Liste durch retrieveArchiveUrls:
retrieveArchiveLinks("http://web.archive.org/web/20190501154002/https://germany.mfa.gov.ua/de")
retrieveArchiveLinks("http://web.archive.org/web/20191019000250/http://twitter.timesopen.list@nytimes.com/")
retrieveArchiveLinks("http://web.archive.org/web/19990209105230/http://www10.nytimes.com:80/")
# ==> Fehlermeldung
# er in names(fullUrls) <- ArchiveUrls :
#   Attribut 'names' [1] muss dieselbe Länge haben wie der Vektor [0]
retrieveArchiveLinks("http://web.archive.org/web/20090406112623/http://www.spiegel.de:80/#nomobile")
# ==> Fehlermeldung
# Fehler in read_xml.raw(raw, encoding = encoding, base_url = base_url, as_html = as_html,  :
# Input is not proper UTF-8, indicate encoding !
# Bytes: 0xDC 0x62 0x65 0x72 [9]
retrieveArchiveLinks("http://web.archive.org/web/20080202111209/http://www.spiegel.de:80/#oas.belegung=test/dttetelekom")
# ==> Fehlermeldung
# Fehler in read_xml.raw(raw, encoding = encoding, base_url = base_url, as_html = as_html,  :
#  Input is not proper UTF-8, indicate encoding !
# Bytes: 0xF6 0x72 0x73 0x65 [9]



### NICHT WEB-ARCHIVE URLS:
retrieveArchiveLinks("https://www.spiegel.de/")
# ==> Fehlermeldung erfolgreich



### VERSCH URL FORMATE:



### ENDCODING:


