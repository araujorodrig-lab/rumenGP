
#' Plot model residuals
#'
#' Plots residuals for an individual bottle.
#'
#' @param fit A fitted model object containing a
#' predictions element.
#' @param head Optional Head identifier.
#' If omitted and only one bottle is present,
#' that bottle is plotted automatically.
#'
#' @return A ggplot object.
#'
#' @export
plot_residuals <- function(
    fit,
    head = NULL
) {

  if (!"predictions" %in% names(fit)) {

    stop(
      "Fit object does not contain predictions."
    )

  }

  if (nrow(fit$predictions) == 0) {

    stop(
      "Fit object contains no residuals."
    )

  }

  model_name <- class(fit)[1]

  available_heads <- unique(
    fit$predictions$Head
  )

  # ----------------------------
  # Automatic Head selection
  # ----------------------------

  if (is.null(head)) {

    if (length(available_heads) == 1) {

      head <- available_heads

    } else {

      stop(
        paste(
          "Multiple bottles detected.",
          "Please supply head =",
          paste(
            available_heads,
            collapse = ", "
          )
        )
      )

    }

  }

  # ----------------------------
  # Filter selected bottle
  # ----------------------------

  df <- fit$predictions |>
    dplyr::filter(
      Head == as.character(head)
    )

  # ----------------------------
  # Missing bottle handling
  # ----------------------------

  if (nrow(df) == 0) {

    stop(
      paste(
        "No residuals available for Head",
        head
      )
    )

  }

  # ----------------------------
  # Plot
  # ----------------------------

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
