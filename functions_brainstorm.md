# Brainstorm Functions
Ideen für Funktionen des Packages


* crawl Urls - MAIN FUNCTION!!!
* crawl timeframe - MAIN FUNCTION PLUS TIME FRAME OPTION 

URL
* get Urls 2 functions:
  - only collect main URLs
  - collect hrefs within main URLs

Content
* crawl headlines only (default h1 XPATH?) and return tibble
* crawl content only
* crawl full (without default options, but two mandatory options (title, content) and one non-mandatory (time of article publication, if not specified, time of memento will be used))


Comment: package should always return one dataset including all articles specified in the full articles or article headlines functions

Additional functions:
* get overview of available dates (single function)

* add function with integration to a browser, allowing to check for the XPATH of the articles? (complicated function, needed?)

