## Test environments
- R-hub debian-clang-devel (r-devel)
- R-hub debian-gcc-devel (r-devel)
- R-hub debian-gcc-devel-nold (r-devel)
- R-hub debian-gcc-patched (r-patched)
- R-hub debian-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)
- R-hub fedora-gcc-devel (r-devel)
- R-hub linux-x86_64-rocker-gcc-san (r-devel)
- R-hub macos-highsierra-release (r-release)
- R-hub macos-highsierra-release-cran (r-release)
- R-hub macos-m1-bigsur-release (r-release)
- R-hub solaris-x86-patched (r-release)
- R-hub solaris-x86-patched-ods (r-release)
- R-hub ubuntu-gcc-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub windows-x86_64-devel (r-devel)
- R-hub windows-x86_64-oldrel (r-oldrel)
- R-hub windows-x86_64-patched (r-patched)
- R-hub windows-x86_64-release (r-release)

## R CMD check results
❯ On solaris-x86-patched (r-release), solaris-x86-patched-ods (r-release)
  checking top-level files ... NOTE
  Files ‘README.md’ or ‘NEWS.md’ cannot be checked without ‘pandoc’ being installed.

❯ On windows-x86_64-devel (r-devel)
  checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'

0 errors ✔ | 0 warnings ✔ | 2 notes ✖
