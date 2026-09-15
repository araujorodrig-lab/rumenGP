
#' Summary of LE0 fits
#'
#' @param object A le0_fit object.
#' @param ... Additional arguments.
#'
#' @export
summary.le0_fit <- function(
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

  cat(
    "\nLogistic-Exponential (LE0) model summary\n",
    "----------------------------------------\n",
    "Total bottles: ", n_total, "\n",
    "Successful fits: ", n_success, "\n",
    "Failed fits: ", n_failed, "\n",
    "Low R² (< 0.90): ", n_low_r2, "\n\n",
    sep = ""
  )

  invisible(object)

}
