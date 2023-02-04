# Test environments
* local OS X install, R 4.2.2
* win-builder (old, devel, release)

## R CMD check results

There was one note:

```
* checking CRAN incoming feasibility ... [14s] NOTE
Maintainer: 'Josh Errickson <jerrick@umich.edu>'

Found the following (possibly) invalid URLs:
  URL: https://journals.sagepub.com/doi/full/10.1177/0049124117747303
    From: inst/CITATION
    Status: 403
    Message: Forbidden

```

## Comments about NOTEs

- The URL works as of 2/4/2023.
