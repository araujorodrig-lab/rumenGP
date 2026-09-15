
#' Summary of Groot fits
#'
#' @param object A groot_fit object.
#' @param ... Additional arguments.
#'
#' @export
summary.groot_fit <- function(
    object,
    ...
) {

  diagnostics <- object$diagnostics

  cat(
    "\nGroot model summary\n",
    "-------------------\n",
    "Total bottles: ",
    nrow(diagnostics),
    "\n",
    "Successful fits: ",
    sum(diagnostics$Converged),
    "\n",
    "Failed fits: ",
    sum(!diagnostics$Converged),
    "\n",
    "Low R² (< 0.90): ",
    sum(
      diagnostics$R2 < 0.90,
      na.rm = TRUE
    ),
    "\n\n",
    sep = ""
  )

  invisible(object)

}
