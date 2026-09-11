
#' Compare model fits
#'
#' Plots observed data together with
#' multiple model predictions.
#'
#' @param ... Fitted model objects.
#' @param head Head identifier.
#'
#' @return A ggplot object.
#'
#' @export
plot_model_comparison <- function(
    ...,
    head
) {

  fits <- list(...)

  prediction_list <- purrr::imap_dfr(
    fits,
    function(fit, model_name) {

      fit$predictions |>
        dplyr::filter(
          Head == as.character(head)
        ) |>
        dplyr::mutate(
          Model = model_name
        )

    }
  )

  if (nrow(prediction_list) == 0) {

    stop(
      paste(
        "No predictions available for Head",
        head
      )
    )

  }

  ggplot2::ggplot() +

    ggplot2::geom_point(
      data =
        prediction_list |>
        dplyr::distinct(
          Time_h,
          Observed
        ),
      ggplot2::aes(
        x = Time_h,
        y = Observed
      ),
      size = 2
    ) +

    ggplot2::geom_line(
      data = prediction_list,
      ggplot2::aes(
        x = Time_h,
        y = Predicted,
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

}
