
#' Compare models for all bottles
#'
#' Displays observed and predicted values for
#' multiple fitted models across all bottles.
#'
#' @param ... Fitted model objects.
#'
#' @return A ggplot object.
#'
#' @export
plot_model_comparison_all <- function(...) {

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
        x = Time_h,
        y = Observed
      ),
      size = 0.8
    ) +

    ggplot2::geom_line(
      data = prediction_list,
      ggplot2::aes(
        x = Time_h,
        y = Predicted,
        colour = Model
      ),
      linewidth = 0.8
    ) +

    ggplot2::facet_wrap(
      ~ Head,
      scales = "free_y"
    ) +

    ggplot2::theme_minimal() +

    ggplot2::labs(
      x = "Time (h)",
      y = "Gas production (mL)",
      title = "Model comparison across bottles"
    )

}
