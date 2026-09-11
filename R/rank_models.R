
#' Rank models
#'
#' Ranks models based on multiple criteria.
#'
#' @param comparison Output of compare_models().
#'
#' @return Ranked comparison table.
#'
#' @export
rank_models <- function(comparison) {

  comparison |>
    dplyr::mutate(

      Rank_R2 =
        rank(
          -Mean_R2,
          ties.method = "min"
        ),

      Rank_RMSE =
        rank(
          Mean_RMSE,
          ties.method = "min"
        ),

      Rank_AIC =
        rank(
          Mean_AIC,
          ties.method = "min"
        ),

      Rank_BIC =
        rank(
          Mean_BIC,
          ties.method = "min"
        )

    )

}
