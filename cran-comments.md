## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)

## R CMD check results
> On windows-x86_64-devel (r-devel), ubuntu-gcc-release (r-release), fedora-clang-devel (r-devel)
  checking CRAN incoming feasibility ... NOTE
  Maintainer: 'Lukas Isermann <lukas.isermann@uni-mannheim.de>'
  
  New maintainer:
    Lukas Isermann <lukas.isermann@uni-mannheim.de>
  Old maintainer(s):
    Lukas Isermann <lukas.isermann@mzes.uni-mannheim.de>
  
  Found the following (possibly) invalid URLs:
    URL: https://codecov.io/gh/liserman/archiveRetriever (moved to https://app.codecov.io/gh/liserman/archiveRetriever)
      From: README.md
      Status: 200
      Message: OK

> On windows-x86_64-devel (r-devel), ubuntu-gcc-release (r-release), fedora-clang-devel (r-devel)
  checking Rd line widths ... NOTE
    \examples lines wider than 100 characters:
       scrape_urls(Urls = "http://web.archive.org/web/20201001004918/https://www.nytimes.com/2020/09/30/opinion/biden-trump-2020-debate.html",
  Rd file 'scrape_urls.Rd':
       scrape_urls(Urls = "https://web.archive.org/web/20201001000859/https://www.nytimes.com/section/politics",
  
  These lines will be truncated in the PDF manual.

> On windows-x86_64-devel (r-devel)
  checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'

0 errors √ | 0 warnings √ | 3 notes x
