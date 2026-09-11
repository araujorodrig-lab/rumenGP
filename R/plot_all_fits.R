
#' Plot all fitted curves
#'
#' Displays observed and predicted values
#' for all bottles.
#'
#' @param fit A fitted model object.
#'
#' @return A ggplot object.
#'
#' @export
plot_all_fits <- function(fit) {

  if (!"predictions" %in% names(fit)) {
    stop(
      "Fit object does not contain predictions."
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

    ggplot2::theme_minimal() +

    ggplot2::labs(
      x = "Time (h)",
      y = "Gas production (mL)"
    )

}
