
#' Summary of EXPL fits
#'
#' @param object An expl_fit object.
#' @param ... Additional arguments.
#'
#' @export
summary.expl_fit <- function(
    object,
    ...
) {

  diagnostics <- object$diagnostics

  cat(
    "\nExponential model with lag (EXPL) summary\n",
    "-----------------------------------------\n",
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
