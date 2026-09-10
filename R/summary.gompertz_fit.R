
#' Summary of Gompertz fits
#'
#' Summarizes model fitting results.
#'
#' @param object A gompertz_fit object.
#' @param ... Additional arguments.
#'
#' @export
summary.gompertz_fit <- function(
    object,
    ...
) {

  diagnostics <- object$diagnostics

  n_total <- nrow(diagnostics)

  n_success <- sum(
    diagnostics$Converged,
    na.rm = TRUE
  )

  n_failed <- sum(
    !diagnostics$Converged,
    na.rm = TRUE
  )

  n_low_r2 <- sum(
    diagnostics$R2 < 0.90,
    na.rm = TRUE
  )

  n_lambda_boundary <- sum(
    diagnostics$Lambda_Boundary,
    na.rm = TRUE
  )

  cat(
    "\nGompertz model summary\n",
    "----------------------\n",
    "Total bottles: ", n_total, "\n",
    "Successful fits: ", n_success, "\n",
    "Failed fits: ", n_failed, "\n",
    "Low R² (< 0.90): ", n_low_r2, "\n",
    "Lambda at boundary: ", n_lambda_boundary, "\n\n",
    sep = ""
  )

  invisible(object)

}
