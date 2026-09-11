
#' Plot all Gompertz fits
#'
#' Displays observed and predicted gas
#' production for all bottles.
#'
#' @param fit A gompertz_fit object.
#'
#' @return A ggplot object.
#'
#' @export
plot_all_gompertz_fits <- function(
    fit
) {

  if (!inherits(
    fit,
    "gompertz_fit"
  )) {

    stop(
      "Input must be a gompertz_fit object."
    )

  }

  ggplot2::ggplot(
    fit$predictions,
    ggplot2::aes(
      x = Time_h
    )
  ) +

    ggplot2::geom_point(
      ggplot2::aes(
        y = Observed
      ),
      size = 1
    ) +

    ggplot2::geom_line(
      ggplot2::aes(
        y = Predicted
      ),
      colour = "blue"
    ) +

    ggplot2::facet_wrap(
      ~ Head,
      scales = "free_y"
    ) +

    ggplot2::theme_minimal()

}
