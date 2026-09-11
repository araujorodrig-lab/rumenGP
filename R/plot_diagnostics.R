
#' Plot diagnostic summaries
#'
#' Diagnostic histograms for a fitted model.
#'
#' @param fit A fitted model object.
#'
#' @return A list of ggplots.
#'
#' @export
plot_diagnostics <- function(
    fit
) {

  diagnostics <- fit$diagnostics

  p1 <- ggplot2::ggplot(
    diagnostics,
    ggplot2::aes(
      x = R2
    )
  ) +
    ggplot2::geom_histogram(
      bins = 10
    ) +
    ggplot2::theme_minimal()

  p2 <- ggplot2::ggplot(
    diagnostics,
    ggplot2::aes(
      x = RMSE
    )
  ) +
    ggplot2::geom_histogram(
      bins = 10
    ) +
    ggplot2::theme_minimal()

  p3 <- ggplot2::ggplot(
    diagnostics,
    ggplot2::aes(
      x = AIC
    )
  ) +
    ggplot2::geom_histogram(
      bins = 10
    ) +
    ggplot2::theme_minimal()

  list(
    R2 = p1,
    RMSE = p2,
    AIC = p3
  )

}
