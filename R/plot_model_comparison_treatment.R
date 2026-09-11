
#' Compare models for a treatment
#'
#' Displays observed and predicted values
#' for multiple models across all replicates
#' of a selected treatment.
#'
#' @param ... Fitted model objects.
#' @param treatment Treatment name.
#'
#' @return A ggplot object.
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

  ggplot2::ggplot() +

    ggplot2::geom_point(
      data =
        prediction_list |>
        dplyr::distinct(
          Head,
          Rep,
          Time_h,
          Observed
        ),
      ggplot2::aes(
        x = Time_h,
        y = Observed
      ),
      size = 1.5
    ) +

    ggplot2::geom_line(
      data = prediction_list,
      ggplot2::aes(
        x = Time_h,
        y = Predicted,
        colour = Model,
        group = interaction(Model, Head)
      ),
      linewidth = 1
    ) +

    ggplot2::facet_wrap(
      ~ Rep,
      scales = "free_y"
    ) +

    ggplot2::labs(
      title = paste(
        "Model comparison -",
        treatment
      ),
      x = "Time (h)",
      y = "Gas production (mL)"
    ) +

    ggplot2::theme_minimal()

}
