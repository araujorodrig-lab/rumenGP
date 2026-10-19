
#' Plot Raw Gas Production Curve
#'
#' Plots observed gas production measurements
#' for an individual bottle.
#'
#' This visualization displays the raw gas
#' production profile prior to model fitting and
#' is useful for:
#'
#' \itemize{
#'   \item Inspecting fermentation dynamics
#'   \item Identifying unusual observations
#'   \item Evaluating data quality
#'   \item Comparing individual bottle profiles
#' }
#'
#' @param data A \code{rumen_gp} object.
#'
#' @param head Bottle identifier to plot.
#'
#' @examples
#'
#' files <- example_data()
#'
#' raw_data <- read_ankom(
#'   files$ankom
#' )
#'
#' metadata <- read_metadata(
#'   files$metadata
#' )
#'
#' gp <- process_ankom(
#'   raw_data,
#'   metadata,
#'   headspace_ml = 210,
#'   temperature_c = 39
#' )
#'
#' plot_gp(
#'   gp,
#'   head = 1
#' )
#'
#' plot_gp(
#'   gp
#'   )
#'
#'
#' @return A \code{ggplot2} object.
#'
#' @seealso
#' \code{\link{plot_fit}},
#' \code{\link{plot_residuals}},
#' \code{\link{process_ankom}}
#'
#' @export
plot_gp <- function(
    data,
    head = NULL
) {

  if (!inherits(data, "rumen_gp")) {
    stop("Input must be a rumen_gp object.")
  }

  df <- data

  # Filter by head only when specified
  if (!is.null(head)) {

    df <- df |>
      dplyr::filter(
        Head == as.character(head)
      )

    if (nrow(df) == 0) {
      stop(
        paste("Head", head, "was not found.")
      )
    }

  }

  # Order observations by time
  df <- df |>
    dplyr::arrange(Head, Time_h)

  p <- ggplot2::ggplot(
    df,
    ggplot2::aes(
      x = Time_h,
      y = Gas_mL
    )
  ) +

    ggplot2::geom_line(
      color = "grey60",
      linewidth = 0.6
    ) +

    ggplot2::geom_point(
      color = "grey10",
      size = 2,
      alpha = 0.8
    ) +

    ggplot2::labs(
      title = if (is.null(head)) {
        "Raw gas production - All Heads"
      } else {
        paste("Raw gas production - Head", head)
      },
      x = "Time (h)",
      y = "Gas production (mL)"
    ) +

    ggplot2::theme_minimal()

  # Facet only when plotting all heads
  if (is.null(head)) {
    p <- p +
      ggplot2::facet_wrap(~ Head)
  }

  return(p)
}
