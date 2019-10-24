# howManyImputations
Implements "how_many_imputations" from von Hippel (2018). See https://missingdata.org/

This can be installed via the `devtools` package:

```
install.packages("devtools")
library(devtools)
install_github("josherrickson/howManyImputations")
```

If you prefer not to install the entire package, the only relevant file is R/howManyImputations.R; you can just copy that function into your code.

Here's an example:

```{r}
> library(howManyImputations)
> library(mice)
> data <- airquality
> data[4:10,3] <- rep(NA,7)
> data[1:5,4] <- NA
> data <- data[-c(5,6)]
> tempData <- mice(data,m=5,maxit=10,meth='pmm',seed=500)
> modelFit1 <- with(tempData,lm(Temp~ Ozone+Solar.R+Wind))
> how_many_imputations(modelFit1)
[1] 72
> how_many_imputations(pool(modelFit1))
[1] 72
> how_many_imputations(modelFit1, cv = .01)
[1] 1767
```
