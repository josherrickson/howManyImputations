#' Implements two-stage "how_many_imputations" from von Hippel (2020)
#'
#' The old advice of 5-10 imputations is sufficient for a point estimate (e.g.
#' an estimated coefficient), but not for estimates of standard errors (and
#' consequently, hypothesis tests or confidence intervals).
#'
#' von Hippel (2020) provides a way to calculate the number of imputations
#' needed to have consistent estimates of the standard error. To do so requires
#' an estimate of the Fraction of Missing Information (FMI) which can only be
#' obtained after running some number of imputations. Therefore, von Hippel
#' (2020) recommends the following procedure:
#'
#' \enumerate{
#'   \item Carry out a limited number of imputations to enable estimation of the
#'   FMI. von Hippel (2020) recommends 20 imputations.
#'   \item Use this function, \code{how_many_imputations()}, to calculate how many
#'   total imputations you will need.
#'   \item If the number of total imputations you will need is larger than your
#'   initial batch of 20, run additional imputations.
#' }
#'
#' @param model Either a \code{mira} object (created by running a model on a
#'   data set which was imputed using \code{mice::mice()}) or a \code{mipo} object
#'   (creating by running \code{pool()} on a \code{mira} object), or any object
#'   which can be converted to \code{mira} via \code{as.mira()}.
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
#' @references Von Hippel, Paul T. "How many imputations do you need? A two-stage calculation using a quadratic rule." Sociological Methods & Research 49.3 (2020): 699-718.
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

#' Improper function name, use \code{how_many_imputations()} instead
#'
#' @param model See \code{how_many_imputations()}
#' @param cv See \code{how_many_imputations()}
#' @param alpha See \code{how_many_imputations()}
#' @return See \code{how_many_imputations()}
#' @export
howManyImputations <- function(model,
                               cv = .05,
                               alpha = .05) {
  warning("Proper function name is how_many_imputations")
  howManyImputations::how_many_imputations(model, cv, alpha)
}
