
#' Identify the best model for each treatment
#'
#' Returns the top-ranked model within each treatment.
#'
#' @param ranked_comparison Output from rank_models_by_treatment().
#'
#' @return A data frame containing the best model for each treatment.
#'
#' @export
best_model_by_treatment <- function(
    ranked_comparison
) {

  ranked_comparison |>

    dplyr::mutate(

      Total_Rank =
        Rank_R2 +
        Rank_RMSE +
        Rank_AIC +
        Rank_BIC

    ) |>

    dplyr::group_by(
      Treatment
    ) |>

    dplyr::mutate(
      Overall_Rank =
        rank(
          Total_Rank,
          ties.method = "min"
        )
    ) |>

    dplyr::ungroup() |>

    dplyr::filter(
      Overall_Rank == 1
    ) |>

    dplyr::arrange(
      Treatment
    )

}
