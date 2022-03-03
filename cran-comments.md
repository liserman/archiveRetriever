## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)

## R CMD check results
> On windows-x86_64-devel (r-devel), ubuntu-gcc-release (r-release), fedora-clang-devel (r-devel)
  checking Rd line widths ... NOTE
    \examples lines wider than 100 characters:
       scrape_urls(Urls = "http://web.archive.org/web/20201001004918/https://www.nytimes.com/2020/09/30/opinion/biden-trump-2020-debate.html",
       scrape_urls(Urls = "https://web.archive.org/web/20201001000859/https://www.nytimes.com/section/politics",
  
  Rd file 'scrape_urls.Rd':
  These lines will be truncated in the PDF manual.

> On windows-x86_64-devel (r-devel)
  checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'

0 errors √ | 0 warnings √ | 2 notes x
