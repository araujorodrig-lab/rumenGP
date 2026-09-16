
#' Summary of dual logistic fits
#'
#' @param object A dual_logistic_fit object.
#' @param ... Additional arguments.
#'
#' @export
summary.dual_logistic_fit <- function(
    object,
    ...
) {

  diagnostics <- object$diagnostics

  cat(
    "\nDual-pool Logistic model summary\n",
    "--------------------------------\n",
    "Total bottles: ",
    nrow(diagnostics),
    "\n",
    "Successful fits: ",
    sum(diagnostics$Converged),
    "\n",
    "Failed fits: ",
    sum(!diagnostics$Converged),
    "\n",
    "Low R-squared (< 0.90): ",
    sum(diagnostics$R2 < 0.90,
        na.rm = TRUE),
    "\n",
    "Lambda at boundary: ",
    sum(
      diagnostics$Lambda_Boundary,
      na.rm = TRUE
    ),
    "\n\n",
    sep = ""
  )

  invisible(object)

}
