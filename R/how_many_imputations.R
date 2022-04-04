#' How Many Imputations?
#'
#' Implements two-stage "how_many_imputations" from von Hippel (2018)
#'
#' @param model Either a \code{mira} object (created by running a model on a
#'   data set which was imputed using \code{mice}) or a \code{mipo} object
#'   (creating by runing \code{pool()} on a \code{mira} object), or any object
#'   which can be coverted to \code{mira} via \code{as.mira}.
#' @param cv Desired precision of standard errors. Default to .05. If the data
#'   were re-imputed, the estimated standard errors would differ by no more than
#'   this amount.
#' @param alpha Significance level for choice of "conservative" FMI.
#' @return The number of required imputations to obtain the \code{cv} level of
#'   precision.
#' @export
#' @importFrom methods is
#' @importFrom stats plogis qlogis qnorm
#' @importFrom mice mice as.mira pool
#'
#' @references von Hippel, Paul T. (2018)
#' \sQuote{How Many Imputations Do You Need? A Two-stage Calculation Using a Quadratic Rule.},
#' \emph{Sociological Methods & Research} p.0049124117747303.
#'
#' @examples
#' data(airquality)
#' # Add some missingness
#' airquality[4:10, 3] <- rep(NA, 7)
#' airquality[1:5, 4] <- NA
#' airquality <- airquality[-c(5, 6)]
#' impdata1 <- mice::mice(airquality, m = 5, maxit = 10, method = 'pmm', seed = 500)
#' modelFit1 <- with(impdata1, lm(Temp ~ Ozone + Solar.R + Wind))
#' how_many_imputations(modelFit1)
#' how_many_imputations(modelFit1, cv = .01)
#'
#' # Using a non-`mice` library.
#' library(jomo)
#' library(mitools) # for the `imputationList` function
#' jomodata <- jomo::jomo1(airquality, nburn = 100, nbetween = 100, nimp = 5)
#' impdata2 <- mitools::imputationList(split(jomodata, jomodata$Imputation))
#' modelfit2 <- with(impdata2, lm(Temp ~ Ozone + Solar.R + Wind))
#' how_many_imputations(modelfit2)
how_many_imputations <- function(model,
                                 cv = .05,
                                 alpha = .05) {
  if (!is(model, "mipo")) {
    tryCatch( model <- mice::as.mira(model),
             error = function(e) {
               stop("model must be a `mira`, or convertible to `mira`.")
             })
    model <- mice::pool(model)
  }


  fmi <- max(model$pooled$fmi)
  z <- qnorm(1 - alpha/2)

  fmiu <- plogis(qlogis(fmi) + z*sqrt(2/model$m))

  ceiling(1 + 1/2*(fmiu/cv)^2)
}
