
#' Plot Model Residuals
#'
#' Plots residuals from one or more fitted models.
#'
#' Residuals are calculated as:
#'
#' \deqn{
#' Residual = Observed - Predicted
#' }
#'
#' The function can be used to visualize:
#'
#' \itemize{
#'   \item A single bottle
#'   \item All bottles within a treatment
#'   \item Mean residual profiles for a selected treatment
#'   \item Mean residual profiles across all treatments
#'   \item Residual patterns from multiple fitted models
#' }
#'
#' Residual plots are useful for:
#'
#' \itemize{
#'   \item Identifying systematic model bias
#'   \item Detecting outliers
#'   \item Evaluating model assumptions
#'   \item Assessing goodness of fit
#'   \item Comparing competing kinetic models
#'   \item Evaluating treatment-level model performance
#' }
#'
#' Ideally, residuals should be randomly distributed
#' around zero with no obvious trend through time.
#'
#' @param ... Fitted model objects.
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
#' If \code{TRUE}, treatment means are plotted.
#'
#' When used together with \code{treatment},
#' the function displays the mean residual
#' profile of the selected treatment.
#'
#' When \code{treatment = NULL}, mean residual
#' profiles are displayed for all treatments.
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
#' gp_clean <- exclude_heads(
#'   gp,
#'   heads = c(
#'     "1",
#'     "2",
#'     "4",
#'     "20"
#'   ),
#'   reason = c(
#'     "Abnormal gas profile",
#'     "Abnormal gas profile",
#'     "Abnormal gas profile",
#'     "Abnormal gas profile"
#'   )
#' )
#'
#' groot_fit <- fit_groot(
#'   gp_clean
#' )
#'
#' gompertz_fit <- fit_gompertz(
#'   gp_clean
#' )
#'
#' # Single bottle
#' plot_residuals(
#'   Groot = groot_fit,
#'   Gompertz = gompertz_fit,
#'   head = 6
#' )
#'
#' # Treatment-specific residuals
#' plot_residuals(
#'   Groot = groot_fit,
#'   Gompertz = gompertz_fit,
#'   treatment = "TMR"
#' )
#'
#' # Mean residual profile of one treatment
#' plot_residuals(
#'   Groot = groot_fit,
#'   Gompertz = gompertz_fit,
#'   treatment = "TMR",
#'   mean_treatment = TRUE
#' )
#'
#' # Mean residual profiles of all treatments
#' plot_residuals(
#'   Groot = groot_fit,
#'   Gompertz = gompertz_fit,
#'   mean_treatment = TRUE
#' )
#'
#' @return A \code{ggplot2} object.
#'
#' @seealso
#' \code{\link{plot_fit}},
#' \code{\link{plot_gp}},
#' \code{\link{plot_model_comparison}},
#' \code{\link{plot_dual_pools}},
#' \code{\link{plot_diagnostics}}
#'
#' @export
plot_residuals <- function(
    ...,
    head = NULL,
    treatment = NULL,
    mean_treatment = FALSE
) {

  fits <- list(...)

  if (length(fits) == 0) {

    stop(
      "At least one fitted model must be supplied."
    )

  }

  if (
    !is.null(head) &&
    !is.null(treatment)
  ) {

    stop(
      "Provide either head or treatment, not both."
    )

  }

  residuals_df <- purrr::imap_dfr(
    fits,
    function(fit, model_name) {

      if (!"predictions" %in% names(fit)) {

        stop(
          paste(
            model_name,
            "does not contain predictions."
          )
        )

      }

      fit$predictions |>
        dplyr::mutate(
          Model = model_name
        )

    }
  )

  # ----------------------------------
  # Head filtering
  # ----------------------------------

  if (!is.null(head)) {

    residuals_df <- residuals_df |>
      dplyr::filter(
        Head == as.character(head)
      )

    if (nrow(residuals_df) == 0) {

      stop(
        paste(
          "No residuals available for Head",
          head
        )
      )

    }

  }

  # ----------------------------------
  # Treatment filtering
  # ----------------------------------

  if (!is.null(treatment)) {

    residuals_df <- residuals_df |>
      dplyr::filter(
        Treatment == treatment
      )

    if (nrow(residuals_df) == 0) {

      stop(
        paste(
          "Treatment",
          treatment,
          "not found."
        )
      )

    }

  }

  # ----------------------------------
  # Mean treatment residuals
  # ----------------------------------

  if (mean_treatment) {

    if (!is.null(treatment)) {

      residuals_df <- residuals_df |>
        dplyr::group_by(
          Model,
          Time_h
        ) |>
        dplyr::summarise(
          Residual =
            mean(
              Residual,
              na.rm = TRUE
            ),
          .groups = "drop"
        )

      return(

        ggplot2::ggplot(
          residuals_df,
          ggplot2::aes(
            x = Time_h,
            y = Residual,
            colour = Model
          )
        ) +

          ggplot2::geom_hline(
            yintercept = 0,
            linetype = 2
          ) +

          ggplot2::geom_line(
            linewidth = 1
          ) +

          ggplot2::geom_smooth(
            method = "loess",
            se = FALSE
          ) +

          ggplot2::labs(
            title = "Residual comparison",
            subtitle =
              paste(
                "Treatment:",
                treatment
              ),
            x = "Time (h)",
            y =
              "Mean residual (Observed - Predicted)"
          ) +

          ggplot2::theme_minimal()

      )

    }

    residuals_df <- residuals_df |>
      dplyr::group_by(
        Treatment,
        Model,
        Time_h
      ) |>
      dplyr::summarise(
        Residual =
          mean(
            Residual,
            na.rm = TRUE
          ),
        .groups = "drop"
      )

    return(

      ggplot2::ggplot(
        residuals_df,
        ggplot2::aes(
          x = Time_h,
          y = Residual,
          colour = Model
        )
      ) +

        ggplot2::geom_hline(
          yintercept = 0,
          linetype = 2
        ) +

        ggplot2::geom_line(
          linewidth = 1
        ) +

        ggplot2::facet_wrap(
          ~ Treatment,
          scales = "free_y"
        ) +

        ggplot2::labs(
          title =
            "Residual comparison by treatment",
          x = "Time (h)",
          y =
            "Mean residual (Observed - Predicted)"
        ) +

        ggplot2::theme_minimal()

    )

  }

  # ----------------------------------
  # Standard residual comparison
  # ----------------------------------

  ggplot2::ggplot(
    residuals_df,
    ggplot2::aes(
      x = Time_h,
      y = Residual,
      colour = Model
    )
  ) +

    ggplot2::geom_hline(
      yintercept = 0,
      linetype = 2
    ) +

    ggplot2::geom_line() +

    ggplot2::geom_smooth(
      method = "loess",
      se = FALSE
    ) +

    ggplot2::labs(
      title =
        if (!is.null(head)) {
          paste(
            "Residual comparison - Head",
            head
          )
        } else if (!is.null(treatment)) {
          paste(
            "Residual comparison -",
            treatment
          )
        } else {
          "Residual comparison"
        },
      x = "Time (h)",
      y =
        "Residual (Observed - Predicted)"
    ) +

    ggplot2::theme_minimal()

}
