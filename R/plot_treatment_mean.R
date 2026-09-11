
#' Plot treatment means across models
#'
#' Compares observed and predicted treatment means
#' across multiple fitted models.
#'
#' @param ... Fitted model objects.
#' @param treatment Treatment name.
#'
#' @return A ggplot object.
#'
#' @export
plot_treatment_mean <- function(
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

  # observed means

  observed_mean <- prediction_list |>
    dplyr::group_by(
      Time_h
    ) |>
    dplyr::summarise(
      Mean_Observed = mean(Observed),
      SD_Observed = sd(Observed),
      N = dplyr::n(),
      SE_Observed = SD_Observed / sqrt(N),
      .groups = "drop"
    )

  # model means

  predicted_mean <- prediction_list |>
    dplyr::group_by(
      Model,
      Time_h
    ) |>
    dplyr::summarise(
      Mean_Predicted = mean(Predicted),
      .groups = "drop"
    )

  ggplot2::ggplot() +

    # observed mean ± SE

    ggplot2::geom_ribbon(
      data = observed_mean,
      ggplot2::aes(
        x = Time_h,
        ymin = Mean_Observed - SE_Observed,
        ymax = Mean_Observed + SE_Observed
      ),
      alpha = 0.2,
      fill = "grey70"
    ) +

    ggplot2::geom_point(
      data = observed_mean,
      ggplot2::aes(
        x = Time_h,
        y = Mean_Observed
      ),
      size = 2,
      colour = "black"
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

    ggplot2::labs(
      title = paste(
        "Treatment mean comparison -",
        treatment
      ),
      x = "Time (h)",
      y = "Gas production (mL)"
    ) +

    ggplot2::theme_minimal()

}
