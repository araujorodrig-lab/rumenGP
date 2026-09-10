
#' Plot raw gas production curve
#'
#' Plots observed gas production for a bottle.
#'
#' @param data A rumen_gp object.
#' @param head Head identifier.
#'
#' @return A ggplot object.
#'
#' @export
plot_gp <- function(
    data,
    head
) {

  if (!inherits(data, "rumen_gp")) {
    stop(
      "Input must be a rumen_gp object."
    )
  }

  df <- data |>
    dplyr::filter(
      Head == as.character(head)
    )

  if (nrow(df) == 0) {

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
      x = Time_h,
      y = Gas_mL
    )
  ) +

    ggplot2::geom_point(
      size = 2
    ) +

    ggplot2::geom_line() +

    ggplot2::labs(
      title = paste(
        "Raw gas production - Head",
        head
      ),
      x = "Time (h)",
      y = "Gas production (mL)"
    ) +

    ggplot2::theme_minimal()

}
