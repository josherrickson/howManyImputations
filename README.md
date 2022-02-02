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
[mice](https://cran.r-project.org/web/packages/mice/index.html) package
(specifically it's `pool` function) to compute the FMI.

Here's an example:

```{r}
> library(howManyImputations)
> library(mice)
> data <- airquality
> # Add some missingness
> data[4:10, 3] <- rep(NA, 7)
> data[1:5, 4] <- NA
> data <- data[-c(5, 6)]
> impdata1 <- mice(data, m = 5, maxit = 10, method = 'pmm', seed = 500)
> modelFit1 <- with(impdata1, lm(Temp ~ Ozone + Solar.R + Wind))
> how_many_imputations(modelFit1)
[1] 72
> how_many_imputations(modelFit1, cv = .01)
[1] 1767
```

If you're using a different package to carry out the imputation, and said
package produces a `list` of models as the output of its modeling step, mice's
`as.mira` function may be helpful. Here's the above example reworked using the
[jomo](https://cran.r-project.org/web/packages/jomo/index.html) package for the
imputation.


```{r}
> library(jomo)
> library(mitools) # for the `imputationList` function
> jomodata <- jomo1(data, nburn = 100, nbetween = 100, nimp = 5)
Found  4 continuous outcomes and no categorical. Using function jomo1con.
..........First imputation registered.
..........Imputation number  2 registered
..........Imputation number  3 registered
..........Imputation number  4 registered
..........Imputation number  5 registered
The posterior mean of the fixed effects estimates is:
                X1
Ozone    41.812161
Solar.R 184.546038
Wind      9.892974
Temp     78.231518

The posterior covariance matrix is:
             Ozone     Solar.R       Wind      Temp
Ozone   1106.82980 1004.928038 -66.625543 212.52663
Solar.R 1004.92804 8609.143741  -1.627078 264.08859
Wind     -66.62554   -1.627078  12.337231 -14.45349
Temp     212.52663  264.088588 -14.453487  89.35698
> impdata2 <- imputationList(split(jomodata, jomodata$Imputation))
> modelfit2 <- with(impdata2, lm(Temp ~ Ozone + Solar.R + Wind))
> # Either can work:
> how_many_imputations(as.mira(modelfit2))
[1] 77
> how_many_imputations(pool(modelfit2))
[1] 77
```
