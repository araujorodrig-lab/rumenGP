
#' Compare residuals across models
#'
#' @param ... Fitted model objects.
#' @param head Head identifier.
#'
#' @return A ggplot object.
#'
#' @export
plot_residual_comparison <- function(
    ...,
    head
) {

  fits <- list(...)

  residuals_df <- purrr::imap_dfr(
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

    ggplot2::theme_minimal()

}
