test_that("multiplication works", {
  library(mice)
  data <- airquality
  data[4:10,3] <- rep(NA,7)
  data[1:5,4] <- NA
  data <- data[-c(5,6)]
  set.seed(500)
  capture.output(tempData <- mice(data,m=5,maxit=10,meth='pmm')) -> c
  modelFit1 <- with(tempData,lm(Temp~ Ozone+Solar.R+Wind))
  expect_equal(how_many_imputations(modelFit1), 72)
  expect_equal(how_many_imputations(pool(modelFit1)), 72)
  expect_equal(how_many_imputations(modelFit1, cv = .01), 1767)
})
