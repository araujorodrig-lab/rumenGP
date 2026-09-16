
#' Plot model performance
#'
#' Visualizes model performance metrics.
#'
#' @param comparison Output from compare_models().
#'
#' @return A ggplot object.
#'
#' @export
plot_model_performance <- function(
    comparison
) {

  performance <- comparison |>

    dplyr::select(
      Model,
      Mean_R2,
      Mean_RMSE,
      Mean_AIC,
      Mean_BIC
    ) |>

    tidyr::pivot_longer(
      cols = -Model,
      names_to = "Metric",
      values_to = "Value"
    ) |>

    dplyr::mutate(

      Value = dplyr::if_else(
        Metric == "Mean_R2",
        Value * 100,
        Value
      ),

      Metric = dplyr::recode(
        Metric,
        Mean_R2   = "Mean R-squared (%)",
        Mean_RMSE = "Mean RMSE",
        Mean_AIC  = "Mean AIC",
        Mean_BIC  = "Mean BIC"
      )

    )

  ggplot2::ggplot(
    performance,
    ggplot2::aes(
      x = Model,
      y = Value,
      fill = Model
    )
  ) +

    ggplot2::geom_col() +

    ggplot2::facet_wrap(
      ~ Metric,
      scales = "free",
      ncol = 2
    ) +

    ggplot2::coord_flip() +

    ggplot2::labs(
      title = "Model performance comparison",
      subtitle =
        paste(
          "Higher R-squared is better;",
          "lower RMSE, AIC and BIC are better"
        ),
      x = NULL,
      y = NULL
    ) +

    ggplot2::theme_minimal() +

    ggplot2::theme(
      legend.position = "none",

      strip.text =
        ggplot2::element_text(
          face = "bold"
        ),

      plot.title =
        ggplot2::element_text(
          face = "bold"
        ),

      plot.subtitle =
        ggplot2::element_text(
          size = 10
        )
    )

}
