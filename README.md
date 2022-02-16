# howManyImputations
[![R-build-check](https://github.com/josherrickson/howManyImputations/workflows/R-build-check/badge.svg)](https://github.com/josherrickson/howManyImputations/actions)

Implements "how_many_imputations" from von Hippel (2018). See
https://missingdata.org/

This can be installed via the `devtools` package:

```
install.packages("devtools")
library(devtools)
install_github("josherrickson/howManyImputations")
```

If you prefer not to install the entire package, the only relevant file is
R/howManyImputations.R; you can just copy that function into your code.

howManyImputations relies on the
[mice](https://cran.r-project.org/web/packages/mice/index.html) package to
compute the FMI.

Here's an example:

```{r}
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
`howManyImputations` tries to convert the object to `mira` via `as.mira`. Here's
the above example reworked using the
[jomo](https://cran.r-project.org/web/packages/jomo/index.html) package for the
imputation.


```{r}
> library(jomo)
> library(mitools) # for the `imputationList` function
> jomodata <- jomo1(airquality, nburn = 100, nbetween = 100, nimp = 5)
> impdata2 <- imputationList(split(jomodata, jomodata$Imputation))
> modelfit2 <- with(impdata2, lm(Temp ~ Ozone + Solar.R + Wind))
> # Either can work:
> how_many_imputations(modelfit2)
[1] 77
```
