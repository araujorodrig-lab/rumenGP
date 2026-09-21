
#' Summary of custom model fits
#'
#' Summarizes a custom_fit object.
#'
#' @param object A custom_fit object.
#' @param ... Not used.
#'
#' @return Invisibly returns the input object.
#'
#' @export
summary.custom_fit <- function(
    object,
    ...
) {

  diagnostics <- object$diagnostics

  n_bottles <- nrow(
    diagnostics
  )

  n_success <- sum(
    diagnostics$Converged,
    na.rm = TRUE
  )

  n_failed <- sum(
    !diagnostics$Converged,
    na.rm = TRUE
  )

  mean_r2 <- mean(
    diagnostics$R2,
    na.rm = TRUE
  )

  mean_rmse <- mean(
    diagnostics$RMSE,
    na.rm = TRUE
  )

  mean_aic <- mean(
    diagnostics$AIC,
    na.rm = TRUE
  )

  mean_bic <- mean(
    diagnostics$BIC,
    na.rm = TRUE
  )

  cat(

    "\nCustom model summary\n",
    "--------------------\n",

    "Model name: ",
    object$model_name,

    "\n\nFormula:\n",

    paste(
      deparse(
        object$formula
      ),
      collapse = "\n"
    ),

    "\n\n",

    "Total bottles: ",
    n_bottles,

    "\n",

    "Successful fits: ",
    n_success,

    "\n",

    "Failed fits: ",
    n_failed,

    "\n",

    "Mean R-squared: ",
    round(
      mean_r2,
      4
    ),

    "\n",

    "Mean RMSE: ",
    round(
      mean_rmse,
      4
    ),

    "\n",

    "Mean AIC: ",
    round(
      mean_aic,
      4
    ),

    "\n",

    "Mean BIC: ",
    round(
      mean_bic,
      4
    ),

    "\n\n",

    sep = ""

  )

  invisible(object)

}
