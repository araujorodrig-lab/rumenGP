
#' Summary of Michaelis-Menten fits
#'
#' Summarizes Michaelis-Menten model fitting results.
#'
#' @param object A mm_fit object.
#' @param ... Additional arguments.
#'
#' @export
summary.mm_fit <- function(
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
    "\nMichaelis-Menten model summary\n",
    "------------------------------\n",
    "Total bottles: ", n_total, "\n",
    "Successful fits: ", n_success, "\n",
    "Failed fits: ", n_failed, "\n",
    "Low R² (< 0.90): ", n_low_r2, "\n\n",
    sep = ""
  )

  invisible(object)

}
