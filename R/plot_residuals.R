
#' Plot model residuals
#'
#' Plots residuals for an individual bottle.
#'
#' @param fit A fitted model object containing a
#' predictions element.
#' @param head Head identifier.
#'
#' @return A ggplot object.
#'
#' @export
plot_residuals <- function(
    fit,
    head
) {

  if (!"predictions" %in% names(fit)) {

    stop(
      "Fit object does not contain predictions."
    )

  }

  model_name <- class(fit)[1]

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
      colour = "black"
    ) +

    ggplot2::geom_point(
      size = 2
    ) +

    ggplot2::geom_line(
      linewidth = 0.5
    ) +

    ggplot2::geom_smooth(
      method = "loess",
      se = FALSE,
      colour = "red",
      linewidth = 1
    ) +

    ggplot2::labs(
      title = paste(
        "Residual plot -",
        model_name,
        "- Head",
        head
      ),
      x = "Time (h)",
      y = "Residual (Observed - Predicted)"
    ) +

    ggplot2::theme_minimal()

}
