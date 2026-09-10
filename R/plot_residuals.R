
#' Plot residuals from Gompertz fit
#'
#' @param fit A gompertz_fit object.
#' @param head Head identifier.
#'
#' @return A ggplot object.
#'
#' @export
plot_residuals <- function(
    fit,
    head
) {

  if (!inherits(fit, "gompertz_fit")) {
    stop(
      "Input must be a gompertz_fit object."
    )
  }

  df <- fit$predictions |>
    dplyr::filter(
      Head == as.character(head)
    )

  if (nrow(df) == 0) {

    stop(
      paste(
        "No residuals available for Head",
        head
      )
    )

  }

  ggplot2::ggplot(
    df,
    ggplot2::aes(
      x = Time_h,
      y = Residual
    )
  ) +

    ggplot2::geom_hline(
      yintercept = 0,
      linetype = 2,
      colour = "red"
    ) +

    ggplot2::geom_point(
      size = 2
    ) +

    ggplot2::geom_line() +

    ggplot2::labs(
      title = paste(
        "Residual plot - Head",
        head
      ),
      x = "Time (h)",
      y = "Residual (Observed - Predicted)"
    ) +

    ggplot2::theme_minimal()

}
