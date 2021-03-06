#' How Many Imputations?
#'
#' Implements two-stage "how_many_imputations" from von Hippel (2018)
#'
#' @param model Either a `mira` object (created by running a model on a data set which was imputed via "mice")
#' or a `mipo` object (creating by runing `pool()` on a `mira` object).
#' @param cv Desired precision of standard errors. Default to .05. (I.e., if the data were re-imputed, the
#' estimated standard errors would differ by no more than this amount.)
#' @param alpha Significance level for choice of "conservative" FMI.
#'
#' @return The number of required imputations to obtain the `cv` level of precision.
#' @export
#' @importFrom methods is
#' @importFrom stats plogis qlogis qnorm
#' @importFrom mice pool
#'
#' @references von Hippel, Paul T. (2018)
#' \sQuote{How Many Imputations Do You Need? A Two-stage Calculation Using a Quadratic Rule.},
#' \emph{Sociological Methods & Research} p.0049124117747303.
#'
#' @examples
#' library(mice)
#' data <- airquality
#' data[4:10,3] <- rep(NA,7)
#' data[1:5,4] <- NA
#' data <- data[-c(5,6)]
#' tempData <- mice(data,m=5,maxit=10,meth='pmm',seed=500)
#' modelFit1 <- with(tempData,lm(Temp~ Ozone+Solar.R+Wind))
#' how_many_imputations(modelFit1)
#' how_many_imputations(pool(modelFit1))
#' how_many_imputations(modelFit1, cv = .01)

how_many_imputations <- function(model,
                                 cv = .05,
                                 alpha = .05) {
  if (is(model, 'mira')) {
    model <- mice::pool(model)
  }
  if (!is(model, "mipo")) {
    stop("Model must be multiply imputed.")
  }
  fmi <- max(model$pooled$fmi)
  z <- qnorm(1 - alpha/2)

  fmiu <- plogis(qlogis(fmi) + z*sqrt(2/model$m))

  ceiling(1 + 1/2*(fmiu/cv)^2)
}
