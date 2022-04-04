# Test environments
* local OS X install, R 4.1.3
* win-builder (old, devel, release)

## R CMD check results

There was one note:

```

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Josh Errickson <jerrick@umich.edu>'

New submission

Possibly mis-spelled words in DESCRIPTION:
  Hippel (3:51, 5:18)
  SAS (5:51)
  Stata (5:41)
  replicable (6:30)
  von (3:47, 5:14)

Found the following (possibly) invalid URLs:
  URL: https://cran.r-project.org/web/packages/jomo/index.html
    From: README.md
    Status: 200
    Message: OK
    CRAN URL not in canonical form
  URL: https://cran.r-project.org/web/packages/mice/index.html
    From: README.md
    Status: 200
    Message: OK
    CRAN URL not in canonical form
  The canonical URL of the CRAN page for a package is
    https://CRAN.R-project.org/package=pkgname

The Title field should be in title case. Current version is:
'Implements "how_many_imputations" from von Hippel (2018)'
In title case that is:
'Implements "How_many_imputations" from von Hippel (2018)'

The Description field should start with a capital letter.
```

## Comments about NOTEs

- "von Hippel" is a proper names and not misspelled.
- "SAS" and "Stata" is the formal name of the statistical software and are not misspelled.
- "replicable" is properly spelled.
- The URLs to the **jomo** and **mice** packages are introduced by CRAN and out
  of my control. The links are not in the DESCRIPTION file.
- For the Title field, "how_many_imputations" is a formal name from that paper, thus should not be capitalized.
- For the Description field, the Description starts with a proper name, "von
  Hippel", which does not have a capitol "v".
