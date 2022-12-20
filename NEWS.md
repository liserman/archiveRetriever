# archiveRetriver 0.3.0

* Fixes to filtering of links in *retrieve_links()* to enable link scraping from domains with more than one domain ending.
* New option *filter* added to *retrieve_links()*. This options allows to disable the filtering of links to be sub-domains of the top-level domain.
* New option *pattern* added to *retrieve_links()*. This option allows for custom patterns by which links are filtered before output.

---

# archiveRetriever 0.2.0

* New option *collapseDate* added to *retrieve_urls()*. This option allows users to choose whether *retrieve_urls* outputs all or just one memento per requested day.

---


# archiveRetriever 0.1.2

* Fixes to *ignoreErrors* option for html reading-errors in *scrape_urls()*
* Fixes to *retrieve_links()* for Errors occurring in last Url
* Improve compatibility between *retrieve_links()* and *scrape_urls()*

---


# archiveRetriever 0.1.1

* Fixes to *ignoreErrors* option for encoding errors in *retrieve_links()*

---

# archiveRetriever 0.1.0

* Fixes to function behavior in case of timeout.
* Changes to the preliminary output printed by *scrape_urls()* function in case of error.
* Integration of more flexibility for using the *scrape_urls()* option *attachto*
* New option *collapse* added to *scrape_urls()*. This option allows users to choose whether html elements retrieved via the archiveRetriever are collapsed into a single observation or are kept as different observations in the output dataset.
* Update of the package documentation.

# archiveRetriever 0.0.2

* Minor fixes and adjustments to Error-Messages
* More stable testing environment

---

# archiveRetriever 0.0.1

* Final version for Cran submission

---

# archiveRetriever 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package.
