# **howManyImputations** <a href="http://errickson.net/howManyImputations/"><img src="man/figures/logo.png" align="right" height="139" /></a>

Package website: [release](https://errickson.net/howManyImputations/) | [development](https://errickson.net/howManyImputations/dev/)

<!-- badges: start -->
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/howManyImputations)](https://cran.r-project.org/package=howManyImputations)
[![R-build-check](https://github.com/josherrickson/howManyImputations/workflows/R-build-check/badge.svg)](https://github.com/josherrickson/howManyImputations/actions/)
<!-- badges: end -->

Implements "how_many_imputations" from von Hippel (2018). See
https://missingdata.org/

This can be installed via the `devtools` package:

```
install.packages("devtools")
library(devtools)
install_github("josherrickson/howManyImputations")
```

The only function in **howManyImputations** is `how_many_imputations`. Here's an
example:

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
