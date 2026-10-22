
#' Plot Fitted Model
#'
#' Plots observed and predicted gas-production
#' values from a fitted model object.
#'
#' Observed measurements are displayed alongside
#' fitted model predictions, allowing visual
#' assessment of model performance.
#'
#' The function can be used to visualize:
#'
#' \itemize{
#'   \item A single bottle
#'   \item All bottles in the fitted dataset
#'   \item All bottles within a treatment
#'   \item The mean fitted profile of a single treatment
#'   \item Mean fitted profiles of all treatments
#' }
#'
#' This visualization is useful for:
#'
#' \itemize{
#'   \item Evaluating model fit
#'   \item Identifying systematic deviations
#'   \item Inspecting individual fermentation profiles
#'   \item Comparing observed and predicted values
#'   \item Comparing treatment-level responses
#'   \item Evaluating treatment means
#' }
#'
#' @param fit A fitted model object.
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
#' the function displays the mean observed and
#' predicted profile of the selected treatment.
#'
#' When \code{treatment = NULL}, mean profiles
#' are displayed for all treatments.
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
#' fit <- fit_groot(
#'   gp_clean
#' )
#'
#' # Single bottle
#' plot_fit(
#'   fit,
#'   head = 6
#' )
#'
#' # All bottles
#' plot_fit(
#'   fit
#' )
#'
#' # Treatment-specific bottles
#' plot_fit(
#'   fit,
#'   treatment = "TMR"
#' )
#'
#' # Mean fit for one treatment
#' plot_fit(
#'   fit,
#'   treatment = "TMR",
#'   mean_treatment = TRUE
#' )
#'
#' # Mean fits for all treatments
#' plot_fit(
#'   fit,
#'   mean_treatment = TRUE
#' )
#'
#' @return A \code{ggplot2} object.
#'
#' @seealso
#' \code{\link{plot_gp}},
#' \code{\link{plot_residuals}},
#' \code{\link{fit_groot}}
#'
#' @export
plot_fit <- function(
    fit,
    head = NULL,
    treatment = NULL,
    mean_treatment = FALSE
) {

  if (!"predictions" %in% names(fit)) {

    stop(
      "Fit object does not contain predictions."
    )

  }

  if (nrow(fit$predictions) == 0) {

    stop(
      "Fit object contains no predictions."
    )

  }

  model_name <- class(fit)[1]

  df <- fit$predictions

  # ----------------------------------
  # Treatment filtering
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
  # Head filtering
  # ----------------------------------

  if (!is.null(head)) {

    df <- df |>
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

  }

  # ----------------------------------
  # Mean treatment profile(s)
  # ----------------------------------

  if (mean_treatment) {

    if (!is.null(treatment)) {

      df_mean <- df |>
        dplyr::group_by(
          Time_h
        ) |>
        dplyr::summarise(

          Mean_Observed =
            mean(
              Observed,
              na.rm = TRUE
            ),

          Mean_Predicted =
            mean(
              Predicted,
              na.rm = TRUE
            ),

          .groups = "drop"

        )

      return(

        ggplot2::ggplot(
          df_mean,
          ggplot2::aes(
            x = Time_h
          )
        ) +

          ggplot2::geom_point(
            ggplot2::aes(
              y = Mean_Observed
            ),
            size = 2
          ) +

          ggplot2::geom_line(
            ggplot2::aes(
              y = Mean_Predicted
            ),
            colour = "blue",
            linewidth = 1
          ) +

          ggplot2::labs(
            title = paste(
              "Mean model fit -",
              model_name
            ),
            subtitle = paste(
              "Treatment:",
              treatment
            ),
            x = "Time (h)",
            y = "Gas production (mL)"
          ) +

          ggplot2::theme_minimal()

      )

    }

    df_mean <- df |>
      dplyr::group_by(
        Treatment,
        Time_h
      ) |>
      dplyr::summarise(

        Mean_Observed =
          mean(
            Observed,
            na.rm = TRUE
          ),

        Mean_Predicted =
          mean(
            Predicted,
            na.rm = TRUE
          ),

        .groups = "drop"

      )

    return(

      ggplot2::ggplot(
        df_mean,
        ggplot2::aes(
          x = Time_h
        )
      ) +

        ggplot2::geom_point(
          ggplot2::aes(
            y = Mean_Observed
          ),
          size = 1.5
        ) +

        ggplot2::geom_line(
          ggplot2::aes(
            y = Mean_Predicted
          ),
          colour = "blue",
          linewidth = 1
        ) +

        ggplot2::facet_wrap(
          ~ Treatment
        ) +

        ggplot2::labs(
          title = paste(
            "Mean model fit -",
            model_name
          ),
          x = "Time (h)",
          y = "Gas production (mL)"
        ) +

        ggplot2::theme_minimal()

    )

  }

  # ----------------------------------
  # Single bottle
  # ----------------------------------

  if (!is.null(head)) {

    return(

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

    )

  }

  # ----------------------------------
  # All bottles
  # ----------------------------------

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
      size = 0.8
    ) +

    ggplot2::geom_line(
      ggplot2::aes(
        y = Predicted
      ),
      colour = "blue",
      linewidth = 0.8
    ) +

    ggplot2::facet_wrap(
      ~ Head
    ) +

    ggplot2::labs(
      title = paste(
        "Model fit -",
        model_name
      ),
      subtitle =
        if (!is.null(treatment))
          paste(
            "Treatment:",
            treatment
          )
      else
        NULL,
      x = "Time (h)",
      y = "Gas production (mL)"
    ) +

    ggplot2::theme_minimal()

}
