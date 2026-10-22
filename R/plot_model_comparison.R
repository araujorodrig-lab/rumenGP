
#' Compare Model Fits
#'
#' Displays observed gas-production values together
#' with predictions from multiple fitted models.
#'
#' Observed measurements are displayed alongside
#' predictions from each supplied model, allowing
#' direct visual comparison of competing kinetic
#' formulations.
#'
#' The function can be used to visualize:
#'
#' \itemize{
#'   \item A single bottle
#'   \item All bottles within a treatment
#'   \item The mean response of a selected treatment
#'   \item Mean responses across all treatments
#' }
#'
#' This visualization is useful for:
#'
#' \itemize{
#'   \item Comparing competing kinetic models
#'   \item Evaluating model performance
#'   \item Identifying differences among fitted curves
#'   \item Assessing agreement with observations
#'   \item Comparing treatment-level responses
#'   \item Evaluating treatment means
#' }
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
#' the function displays the mean observed and
#' predicted profiles for the selected treatment.
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
#' groot_fit <- fit_groot(
#'   gp_clean
#' )
#'
#' gompertz_fit <- fit_gompertz(
#'   gp_clean
#' )
#'
#' # Single bottle
#' plot_model_comparison(
#'   Groot = groot_fit,
#'   Gompertz = gompertz_fit,
#'   head = 6
#' )
#'
#' # All bottles from one treatment
#' plot_model_comparison(
#'   Groot = groot_fit,
#'   Gompertz = gompertz_fit,
#'   treatment = "TMR"
#' )
#'
#' # Mean comparison for one treatment
#' plot_model_comparison(
#'   Groot = groot_fit,
#'   Gompertz = gompertz_fit,
#'   treatment = "TMR",
#'   mean_treatment = TRUE
#' )
#'
#' # Mean comparison across all treatments
#' plot_model_comparison(
#'   Groot = groot_fit,
#'   Gompertz = gompertz_fit,
#'   mean_treatment = TRUE
#' )
#'
#' @return A \code{ggplot2} object.
#'
#' @seealso
#' \code{\link{compare_models}},
#' \code{\link{plot_fit}},
#' \code{\link{plot_gp}},
#' \code{\link{fit_groot}},
#' \code{\link{fit_gompertz}}
#'
#' @export
plot_model_comparison <- function(
    ...,
    head = NULL,
    treatment = NULL,
    mean_treatment = FALSE
) {

  fits <- list(...)

  if (
    !is.null(head) &&
    !is.null(treatment)
  ) {

    stop(
      "Provide either head or treatment, not both."
    )

  }

  prediction_list <- purrr::imap_dfr(
    fits,
    function(fit, model_name) {

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

    prediction_list <- prediction_list |>
      dplyr::filter(
        Head == as.character(head)
      )

    if (nrow(prediction_list) == 0) {

      stop(
        paste(
          "No predictions available for Head",
          head
        )
      )

    }

  }

  # ----------------------------------
  # Treatment filtering
  # ----------------------------------

  if (!is.null(treatment)) {

    prediction_list <- prediction_list |>
      dplyr::filter(
        Treatment == treatment
      )

    if (nrow(prediction_list) == 0) {

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
  # Mean treatment profile(s)
  # ----------------------------------

  if (mean_treatment) {

    # ==========================
    # One treatment
    # ==========================

    if (!is.null(treatment)) {

      observed_mean <-

        prediction_list |>

        dplyr::group_by(
          Time_h
        ) |>

        dplyr::summarise(
          Observed =
            mean(
              Observed,
              na.rm = TRUE
            ),
          .groups = "drop"
        )

      predicted_mean <-

        prediction_list |>

        dplyr::group_by(
          Model,
          Time_h
        ) |>

        dplyr::summarise(
          Predicted =
            mean(
              Predicted,
              na.rm = TRUE
            ),
          .groups = "drop"
        )

      return(

        ggplot2::ggplot() +

          ggplot2::geom_point(
            data = observed_mean,
            ggplot2::aes(
              Time_h,
              Observed
            ),
            size = 2
          ) +

          ggplot2::geom_line(
            data = predicted_mean,
            ggplot2::aes(
              Time_h,
              Predicted,
              colour = Model
            ),
            linewidth = 1
          ) +

          ggplot2::labs(
            title =
              "Model comparison",
            subtitle =
              paste(
                "Treatment:",
                treatment
              ),
            x = "Time (h)",
            y = "Gas production (mL)"
          ) +

          ggplot2::theme_minimal()

      )

    }

    # ==========================
    # All treatments
    # ==========================

    observed_mean <-

      prediction_list |>

      dplyr::group_by(
        Treatment,
        Time_h
      ) |>

      dplyr::summarise(
        Observed =
          mean(
            Observed,
            na.rm = TRUE
          ),
        .groups = "drop"
      )

    predicted_mean <-

      prediction_list |>

      dplyr::group_by(
        Treatment,
        Model,
        Time_h
      ) |>

      dplyr::summarise(
        Predicted =
          mean(
            Predicted,
            na.rm = TRUE
          ),
        .groups = "drop"
      )

    return(

      ggplot2::ggplot() +

        ggplot2::geom_point(
          data = observed_mean,
          ggplot2::aes(
            Time_h,
            Observed
          ),
          size = 1.5
        ) +

        ggplot2::geom_line(
          data = predicted_mean,
          ggplot2::aes(
            Time_h,
            Predicted,
            colour = Model
          ),
          linewidth = 1
        ) +

        ggplot2::facet_wrap(
          ~ Treatment,
          scales = "free_y"
        ) +

        ggplot2::labs(
          title =
            "Model comparison by treatment",
          x = "Time (h)",
          y = "Gas production (mL)"
        ) +

        ggplot2::theme_minimal()

    )

  }

  # ----------------------------------
  # Single head
  # ----------------------------------

  if (!is.null(head)) {

    return(

      ggplot2::ggplot() +

        ggplot2::geom_point(
          data =
            prediction_list |>
            dplyr::distinct(
              Time_h,
              Observed
            ),
          ggplot2::aes(
            Time_h,
            Observed
          ),
          size = 2
        ) +

        ggplot2::geom_line(
          data = prediction_list,
          ggplot2::aes(
            Time_h,
            Predicted,
            colour = Model
          ),
          linewidth = 1
        ) +

        ggplot2::labs(
          title = paste(
            "Model comparison - Head",
            head
          ),
          x = "Time (h)",
          y = "Gas production (mL)"
        ) +

        ggplot2::theme_minimal()

    )

  }

  # ----------------------------------
  # Treatment bottles
  # ----------------------------------

  ggplot2::ggplot() +

    ggplot2::geom_point(
      data =
        prediction_list |>
        dplyr::distinct(
          Head,
          Time_h,
          Observed
        ),
      ggplot2::aes(
        Time_h,
        Observed
      ),
      size = 1
    ) +

    ggplot2::geom_line(
      data = prediction_list,
      ggplot2::aes(
        Time_h,
        Predicted,
        colour = Model,
        group = interaction(
          Model,
          Head
        )
      ),
      linewidth = 0.8
    ) +

    ggplot2::facet_wrap(
      ~ Head
    ) +

    ggplot2::labs(
      title = "Model comparison",
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
