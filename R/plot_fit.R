
#' Plot fitted model
#'
#' Plots observed and predicted gas production
#' for an individual bottle.
#'
#' @param fit A fitted model object.
#' @param head Head identifier.
#'
#' @return A ggplot object.
#'
#' @export
plot_fit <- function(
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

    diagnostic <- fit$diagnostics |>
      dplyr::filter(
        Head == as.character(head)
      )

    if (nrow(diagnostic) > 0) {

      stop(
        paste(
          "Head",
          head,
          "has no predictions because fit status is:",
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
      colour = "blue",
      linewidth = 1
    ) +

    ggplot2::labs(
      title = paste(
        "Model fit -",
        model_name,
        "- Head",
        head
      ),
      x = "Time (h)",
      y = "Gas production (mL)"
    ) +

    ggplot2::theme_minimal()

}
