## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)

## R CMD check results
❯ On windows-x86_64-devel (r-devel), ubuntu-gcc-release (r-release), fedora-clang-devel (r-devel)
  checking CRAN incoming feasibility ... NOTE
  Maintainer: 'Lukas Isermann <lukas.isermann@uni-mannheim.de>'
  
  New maintainer:
    Lukas Isermann <lukas.isermann@uni-mannheim.de>
  Old maintainer(s):
    Lukas Isermann <lukas.isermann@mzes.uni-mannheim.de>

❯ On windows-x86_64-devel (r-devel), ubuntu-gcc-release (r-release), fedora-clang-devel (r-devel)
  checking Rd line widths ... NOTE
  Rd file 'scrape_urls.Rd':
       Urls = "http://web.archive.org/web/20201001004918/https://www.nytimes.com/2020/09/30/opinion/biden-trump-2020-debate.html",
  
    \examples lines wider than 100 characters:
  These lines will be truncated in the PDF manual.

❯ On windows-x86_64-devel (r-devel)
  checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'

0 errors ✔ | 0 warnings ✔ | 3 notes ✖
