
#' Summary of EXP0 fits
#'
#' @param object An exp0_fit object.
#' @param ... Additional arguments.
#'
#' @export
summary.exp0_fit <- function(
    object,
    ...
) {

  diagnostics <- object$diagnostics

  cat(
    "\nExponential model (EXP0) summary\n",
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
    sum(
      diagnostics$R2 < 0.90,
      na.rm = TRUE
    ),
    "\n\n",
    sep = ""
  )

  invisible(object)

}
