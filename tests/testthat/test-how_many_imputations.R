test_that("basic results", {
  library(mice)
  data <- airquality
  data[4:10,3] <- rep(NA,7)
  data[1:5,4] <- NA
  data <- data[-c(5,6)]
  capture.output(tempData <- mice(data,m=5,maxit=10,meth='pmm')) -> c
  modelFit1 <- with(tempData,lm(Temp~ Ozone+Solar.R+Wind))

  hmi1 <- how_many_imputations(modelFit1)
  expect_type(hmi1, "double")
  expect_true(hmi1 > 5)
  expect_true(hmi1 < 500)

  hmi2 <- how_many_imputations(pool(modelFit1))
  expect_type(hmi2, "double")
  expect_equal(hmi1, hmi2)

  hmi3 <- how_many_imputations(modelFit1, cv = .01)
  expect_true(hmi1 < hmi3)

  hmi4 <- how_many_imputations(modelFit1, alpha = .00001)
  expect_true(hmi1 < hmi4)
})


test_that("jomo", {
  library(jomo)
  library(mitools) # for the `imputationList` function
  capture.output(jomodata <- jomo1(airquality, nburn = 100, nbetween = 100, nimp = 5)) -> c
  impdata2 <- imputationList(split(jomodata, jomodata$Imputation))
  modelfit2 <- with(impdata2, lm(Temp ~ Ozone + Solar.R + Wind))
  # Either can work:
  hmi <- how_many_imputations(modelfit2)
  expect_type(hmi, "double")
  expect_true(hmi > 5)
  expect_true(hmi < 500)
})
