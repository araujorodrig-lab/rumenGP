
#' Plot Raw Gas Production Curves
#'
#' Plots observed gas-production measurements from a
#' \code{rumen_gp} object.
#'
#' The function can be used to visualize:
#'
#' \itemize{
#'   \item A single bottle
#'   \item All bottles in the dataset
#'   \item All bottles within a treatment
#'   \item Mean treatment gas-production profiles
#' }
#'
#' This visualization is useful for:
#'
#' \itemize{
#'   \item Inspecting fermentation dynamics
#'   \item Identifying unusual observations
#'   \item Evaluating data quality
#'   \item Comparing bottle-level responses
#'   \item Comparing treatment-level responses
#' }
#'
#' @param data A \code{rumen_gp} object.
#'
#' @param head Optional bottle identifier.
#' If supplied, only the selected bottle
#' is plotted.
#'
#' @param treatment Optional treatment name.
#' If supplied, only observations belonging
#' to the selected treatment are plotted.
#'
#' @param mean_treatment Logical.
#' If \code{TRUE}, plots the mean gas-production
#' profile of the selected treatment.
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
#' # Single bottle
#' plot_gp(
#'   gp,
#'   head = 1
#' )
#'
#' # All bottles
#' plot_gp(
#'   gp
#' )
#'
#' # All bottles within a treatment
#' plot_gp(
#'   gp,
#'   treatment = "TMR"
#' )
#'
#' # Mean treatment profile
#' plot_gp(
#'   gp,
#'   treatment = "TMR",
#'   mean_treatment = TRUE
#' )
#'
#' @return A \code{ggplot2} object.
#'
#' @seealso
#' \code{\link{plot_fit}},
#' \code{\link{plot_residuals}},
#' \code{\link{plot_treatment_mean}},
#' \code{\link{process_ankom}}
#'
#' @export
plot_gp <- function(
    data,
    head = NULL,
    treatment = NULL,
    mean_treatment = FALSE
) {

  if (!inherits(data, "rumen_gp")) {
    stop(
      "Input must be a rumen_gp object."
    )
  }

  df <- data

  # ----------------------------------
  # Filter by treatment
  # ----------------------------------

  if (!is.null(treatment)) {

    df <- df |>
      dplyr::filter(
        Treatment == treatment
      )

    if (nrow(df) == 0) {

      stop(
        paste(
          "Treatment",
          treatment,
          "was not found."
        )
      )

    }

  }

  # ----------------------------------
  # Filter by head
  # ----------------------------------

  if (!is.null(head)) {

    df <- df |>
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

  }

  # ----------------------------------
  # Order observations
  # ----------------------------------

  df <- df |>
    dplyr::arrange(
      Head,
      Time_h
    )

  # ----------------------------------
  # Treatment means
  # ----------------------------------

  if (mean_treatment) {

    df_mean <- df |>
      dplyr::group_by(
        Time_h
      ) |>
      dplyr::summarise(
        Mean_Gas =
          mean(
            Gas_mL,
            na.rm = TRUE
          ),
        SD_Gas =
          stats::sd(
            Gas_mL,
            na.rm = TRUE
          ),
        .groups = "drop"
      )

    p <- ggplot2::ggplot(
      df_mean,
      ggplot2::aes(
        x = Time_h,
        y = Mean_Gas
      )
    ) +

      ggplot2::geom_ribbon(
        ggplot2::aes(
          ymin = Mean_Gas - SD_Gas,
          ymax = Mean_Gas + SD_Gas
        ),
        alpha = 0.20
      ) +

      ggplot2::geom_line(
        linewidth = 1
      ) +

      ggplot2::labs(
        title = if (
          is.null(treatment)
        ) {
          "Mean gas production"
        } else {
          paste(
            "Mean gas production -",
            treatment
          )
        },
        x = "Time (h)",
        y = "Gas production (mL)"
      ) +

      ggplot2::theme_minimal()

    return(p)

  }

  # ----------------------------------
  # Regular plotting
  # ----------------------------------

  p <- ggplot2::ggplot(
    df,
    ggplot2::aes(
      x = Time_h,
      y = Gas_mL,
      group = Head
    )
  ) +

    ggplot2::geom_line(
      color = "grey60",
      linewidth = 0.6
    ) +

    ggplot2::geom_point(
      color = "grey10",
      size = 0.8,
      alpha = 0.8
    ) +

    ggplot2::labs(
      title = dplyr::case_when(

        !is.null(head) ~ paste(
          "Raw gas production - Head",
          head
        ),

        !is.null(treatment) ~ paste(
          "Raw gas production -",
          treatment
        ),

        TRUE ~
          "Raw gas production - All Heads"

      ),
      x = "Time (h)",
      y = "Gas production (mL)"
    ) +

    ggplot2::theme_minimal()

  if (
    is.null(head) &&
    is.null(treatment)
  ) {

    p <- p +
      ggplot2::facet_wrap(
        ~ Head
      )

  }

  p

}
