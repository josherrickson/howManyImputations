# Test environments
* local OS X install, R 4.1.3
* win-builder (old, devel, release)

## R CMD check results

There was one note:

```
* checking CRAN incoming feasibility ... NOTE

Maintainer: 'Josh Errickson '
New submission

Possibly misspelled words in DESCRIPTION:
Hippel (10:48)
howManyImputations (9:14)
von (10:44)

Found the following (possibly) invalid DOIs:
DOI: 10.1177/0049124117747303
From: DESCRIPTION
Status: Service Unavailable
Message: 503
```

## Comments about NOTEs

- "von Hippel" is a proper name of the author of a paper and is not misspelled.
- "howManyImputation" is the name of the package and is properly spelled.
- The DOI is valid as confirmed on https://www.doi.org.

# Submission comment

This is a re-submission of the package, following some corrections in the metadata suggested by CRAN.
