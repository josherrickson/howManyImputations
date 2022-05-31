# Test environments
* local OS X install, R 4.2
* win-builder (old, devel, release)

## R CMD check results

There was one note:

```
* checking CRAN incoming feasibility ... NOTE

Maintainer: 'Josh Errickson '
New submission

Possibly misspelled words in DESCRIPTION:
Hippel (10:48)
von (10:44)


Found the following (possibly) invalid URLs:
  URL: https://journals.sagepub.com/doi/full/10.1177/0049124117747303
    From: inst/CITATION
    Status: 503
    Message: Service Unavailable

Found the following (possibly) invalid DOIs:
  DOI: 10.1177/0049124117747303
    From: DESCRIPTION
    Status: Service Unavailable
    Message: 503

```

## Comments about NOTEs

- "von Hippel" is a proper name of the author of a paper and is not misspelled.
- The URL works as of 5/31/2022.
- The DOI is valid as confirmed on https://www.doi.org.
