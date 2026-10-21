
#' Compare Models Within a Treatment
#'
#' Displays observed and predicted gas production
#' values for multiple fitted models within a
#' selected treatment.
#'
#' Observed measurements are displayed alongside
#' model predictions, allowing visual comparison
#' of competing kinetic models across treatment
#' replicates.
#'
#' Individual panels correspond to biological
#' replicates, facilitating the evaluation of:
#'
#' \itemize{
#'   \item Agreement among competing models
#'   \item Consistency among treatment replicates
#'   \item Treatment-specific fermentation patterns
#'   \item Systematic prediction errors
#'   \item Model performance within a treatment
#' }
#'
#' @param ... Fitted model objects.
#'
#' @param treatment Treatment name to visualize.
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
#' groot_fit <- fit_groot(
#'   gp
#' )
#'
#' gompertz_fit <- fit_gompertz(
#'   gp
#' )
#'
#' plot_model_comparison_treatment(
#'   Groot = groot_fit,
#'   Gompertz = gompertz_fit,
#'   treatment = "TMR"
#' )
#'
#' @return A \code{ggplot2} object showing observed
#' gas production values and predicted model curves
#' for a selected treatment.
#'
#' @seealso
#' \code{\link{compare_models_by_treatment}},
#' \code{\link{plot_model_comparison}},
#' \code{\link{plot_model_comparison_all}},
#' \code{\link{plot_treatment_mean}},
#' \code{\link{fit_groot}},
#' \code{\link{fit_gompertz}}
#'
#' @export
plot_model_comparison_treatment <- function(
    ...,
    treatment
) {

  fits <- list(...)

  prediction_list <- purrr::imap_dfr(
    fits,
    function(fit, model_name) {

      fit$predictions |>
        dplyr::filter(
          Treatment == treatment
        ) |>
        dplyr::mutate(
          Model = model_name
        )

    }
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

  prediction_list <- prediction_list |>
    dplyr::mutate(
      Replicate = paste(
        "Rep",
        Rep
      )
    )

  observed_data <- prediction_list |>
    dplyr::distinct(
      Head,
      Rep,
      Replicate,
      Time_h,
      Observed
    )

  ggplot2::ggplot() +

    ggplot2::geom_point(
      data = observed_data,
      ggplot2::aes(
        x = Time_h,
        y = Observed
      ),
      size = 1.5,
      alpha = 0.8
    ) +

    ggplot2::geom_line(
      data = prediction_list,
      ggplot2::aes(
        x = Time_h,
        y = Predicted,
        colour = Model,
        group = interaction(
          Model,
          Head
        )
      ),
      linewidth = 1
    ) +

    ggplot2::facet_wrap(
      ~ Replicate,
      scales = "free_y"
    ) +

    ggplot2::labs(
      title = paste(
        "Model Comparison"
      ),
      subtitle = paste(
        "Treatment:",
        treatment
      ),
      x = "Time (h)",
      y = "Gas production (mL)",
      colour = "Model"
    ) +

    ggplot2::theme_minimal() +

    ggplot2::theme(
      plot.title =
        ggplot2::element_text(
          face = "bold"
        ),
      strip.text =
        ggplot2::element_text(
          face = "bold"
        )
    )

}
