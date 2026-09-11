
#' Plot treatment means for all treatments
#'
#' Compares observed and predicted treatment means
#' across multiple fitted models.
#'
#' @param ... Fitted model objects.
#'
#' @return A ggplot object.
#'
#' @export
plot_all_treatment_means <- function(...) {

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

  # Observed means by treatment

  observed_mean <- prediction_list |>
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

  # Predicted means by treatment and model

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

  ggplot2::ggplot() +

    ggplot2::geom_ribbon(
      data = observed_mean,
      ggplot2::aes(
        x = Time_h,
        ymin = Mean_Observed - SE_Observed,
        ymax = Mean_Observed + SE_Observed
      ),
      fill = "grey70",
      alpha = 0.2
    ) +

    ggplot2::geom_point(
      data = observed_mean,
      ggplot2::aes(
        x = Time_h,
        y = Mean_Observed
      ),
      size = 1
    ) +

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
      title = "Treatment mean comparison",
      x = "Time (h)",
      y = "Gas production (mL)"
    ) +

    ggplot2::theme_minimal()

}
