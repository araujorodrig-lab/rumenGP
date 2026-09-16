
#' Plot treatment means for all treatments
#'
#' Compares observed and predicted treatment means
#' across multiple fitted models.
#'
#' @param ... Fitted model objects.
#' @param show_se Logical. Show observed +/- SE ribbon.
#'
#' @return A ggplot object.
#'
#' @export
plot_all_treatment_means <- function(
    ...,
    show_se = TRUE
) {

  fits <- list(...)

  prediction_list <- purrr::imap_dfr(
    fits,
    function(fit, model_name) {

      fit$predictions |>
        dplyr::mutate(
          Model = model_name
        )

    }
  )

  # ----------------------------
  # Observed treatment means
  # ----------------------------

  observed_mean <- prediction_list |>
    dplyr::distinct(
      Treatment,
      Head,
      Time_h,
      Observed
    ) |>
    dplyr::group_by(
      Treatment,
      Time_h
    ) |>
    dplyr::summarise(
      Mean_Observed = mean(Observed),
      SD_Observed = sd(Observed),
      N = dplyr::n(),
      SE_Observed = SD_Observed / sqrt(N),
      .groups = "drop"
    )

  # ----------------------------
  # Predicted treatment means
  # ----------------------------

  predicted_mean <- prediction_list |>
    dplyr::group_by(
      Treatment,
      Model,
      Time_h
    ) |>
    dplyr::summarise(
      Mean_Predicted = mean(Predicted),
      .groups = "drop"
    )

  p <- ggplot2::ggplot()

  # ----------------------------
  # Observed SE ribbon
  # ----------------------------

  if (show_se) {

    p <- p +

      ggplot2::geom_ribbon(
        data = observed_mean,
        ggplot2::aes(
          x = Time_h,
          ymin = Mean_Observed - SE_Observed,
          ymax = Mean_Observed + SE_Observed
        ),
        fill = "grey75",
        alpha = 0.25
      )

  }

  p +

    # Observed mean line

    ggplot2::geom_line(
      data = observed_mean,
      ggplot2::aes(
        x = Time_h,
        y = Mean_Observed
      ),
      colour = "black",
      linewidth = 0.8
    ) +

    # Observed mean points

    ggplot2::geom_point(
      data = observed_mean,
      ggplot2::aes(
        x = Time_h,
        y = Mean_Observed
      ),
      colour = "black",
      size = 1.5
    ) +

    # Model predictions

    ggplot2::geom_line(
      data = predicted_mean,
      ggplot2::aes(
        x = Time_h,
        y = Mean_Predicted,
        colour = Model
      ),
      linewidth = 1
    ) +

    ggplot2::facet_wrap(
      ~ Treatment,
      scales = "free_y"
    ) +

    ggplot2::labs(
      title = "Observed vs predicted treatment means",
      subtitle = "Comparison of fitted gas production models",
      x = "Time (h)",
      y = "Gas production (mL)",
      colour = "Model"
    ) +

    ggplot2::theme_minimal() +

    ggplot2::theme(
      legend.position = "bottom",
      strip.text = ggplot2::element_text(
        face = "bold"
      ),
      plot.title = ggplot2::element_text(
        face = "bold"
      )
    )

}
