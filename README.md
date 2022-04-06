# **howManyImputations** <a href="http://errickson.net/howManyImputations/"><img src="man/figures/logo.png" align="right" height="139" /></a>

Package website: [release](https://errickson.net/howManyImputations/) | [development](https://errickson.net/howManyImputations/dev/)

<!-- badges: start -->
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/howManyImputations)](https://cran.r-project.org/package=howManyImputations)
[![R-build-check](https://github.com/josherrickson/howManyImputations/workflows/R-build-check/badge.svg)](https://github.com/josherrickson/howManyImputations/actions/)
<!-- badges: end -->

**howManyImputations** implements "how_many_imputations" from von Hippel (2018).
See [https://missingdata.org/](https://missingdata.org/). When carrying out
multiple imputation, the old advice of 5-10 imputations is sufficient for a
point estimate (e.g. an estimated coefficient), but not for estimates of
standard errors (and consequently, hypothesis tests or confidence intervals).

von Hippel (2018) provides a way to calculate the number of imputations needed
to have consistent estimates of the standard error. To do so requires an
estimate of the Fraction of Missing Information (FMI) which can only be obtained
after running some number of imputations. Therefore, the following procedure is
recommended:

1. Carry out a limited number of imputations to enable estimation of the FMI.
  von Hippel (2018) recommends 20 imputations.
2. Use this function, \code{how_many_imputations}, to calculate how many total
  imputations you will need.
3. If the number of total imputations you will need is larger than your initial
  batch of 20, run additional imputations.

## Usage

The only function in **howManyImputations** is `how_many_imputations()`. This
takes in the results of a model fit on multiply imputed data (primarily from
**mice** but see below for working with other MI packages) and estimates how
many total imputations are needed.

```
mi_model_fit <- with(imputed_data, lm(y ~ x))
how_many_imputations(mi_model_fit)
how_many_imputations(mi_model_fit, cv = .1, alpha = .01)
```

The optional `cv` and `alpha` arguments can be used to tweaked to control how
conservative or anti-conversative the estimate is. See documentation for further
details.

Here's a worked example:

```
> library(howManyImputations)
> data(airquality)
> # Add some missingness
> airquality[4:10, 3] <- rep(NA, 7)
> airquality[1:5, 4] <- NA
> airquality <- airquality[-c(5, 6)]
> impdata1 <- mice(airquality, m = 5, maxit = 10, method = 'pmm', seed = 500)
> modelFit1 <- with(impdata1, lm(Temp ~ Ozone + Solar.R + Wind))
> how_many_imputations(modelFit1)
[1] 72
> how_many_imputations(modelFit1, cv = .01)
[1] 1767
```

If you're using a different package to carry out the imputation, and said
package produces a `list` of models as the output of its modeling step,
`how_many_imputations` tries to convert the object to a `mira` via `as.mira`
(from the [**mice**](https://cran.r-project.org/package=mice) package. Here's
the above example reworked using the
[**jomo**](https://cran.r-project.org/package=jomo) package for the imputation.


```
> library(jomo)
> library(mitools) # for the `imputationList` function
> jomodata <- jomo1(airquality, nburn = 100, nbetween = 100, nimp = 5)
> impdata2 <- imputationList(split(jomodata, jomodata$Imputation))
> modelfit2 <- with(impdata2, lm(Temp ~ Ozone + Solar.R + Wind))
> how_many_imputations(modelfit2)
[1] 77
```

## Reference

Von Hippel, Paul T. "How many imputations do you need? A two-stage calculation
using a quadratic rule." Sociological Methods & Research 49.3 (2020): 699-718.
