
#' Plot model rankings
#'
#' Visualizes model ranks across
#' performance metrics.
#'
#' @param ranking Output from
#' rank_models().
#'
#' @return A ggplot object.
#'
#' @export
plot_model_rankings <- function(
    ranking
) {

  ranks <- ranking |>

    dplyr::select(
      Model,
      Rank_R2,
      Rank_RMSE,
      Rank_AIC,
      Rank_BIC
    ) |>

    tidyr::pivot_longer(
      cols = -Model,
      names_to = "Metric",
      values_to = "Rank"
    )

  ggplot2::ggplot(
    ranks,
    ggplot2::aes(
      x = Model,
      y = Rank,
      fill = Model
    )
  ) +

    ggplot2::geom_col() +

    ggplot2::facet_wrap(
      ~ Metric,
      ncol = 2
    ) +

    ggplot2::coord_flip() +

    ggplot2::scale_y_reverse(
      breaks = seq(
        1,
        max(ranks$Rank),
        1
      )
    ) +

    ggplot2::labs(
      title = "Model ranking comparison",
      subtitle =
        "Rank 1 = best model",
      x = NULL,
      y = "Rank"
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
        )
    )

}
