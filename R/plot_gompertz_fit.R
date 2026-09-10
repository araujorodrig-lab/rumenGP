
#' Plot Gompertz fit
#'
#' Plots observed and predicted gas production
#' for an individual bottle.
#'
#' @param fit A gompertz_fit object.
#' @param head Head identifier.
#'
#' @return A ggplot object.
#'
#' @export
plot_gompertz_fit <- function(
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

    diagnostic <- fit$diagnostics |>
      dplyr::filter(
        Head == as.character(head)
      )

    if (nrow(diagnostic) > 0) {

      stop(
        paste(
          "Head",
          head,
          "has no predictions because the fit status is:",
          diagnostic$Status
        )
      )

    }

    stop(
      paste(
        "Head",
        head,
        "was not found."
      )
    )

  }

  ggplot2::ggplot(
    df,
    ggplot2::aes(
      x = Time_h
    )
  ) +

    ggplot2::geom_point(
      ggplot2::aes(
        y = Observed
      ),
      size = 2
    ) +

    ggplot2::geom_line(
      ggplot2::aes(
        y = Predicted
      ),
      linewidth = 1,
      colour = "blue"
    ) +

    ggplot2::labs(
      title = paste(
        "Gompertz fit - Head",
        head
      ),
      x = "Time (h)",
      y = "Gas production (mL)"
    ) +

    ggplot2::theme_minimal()

}
