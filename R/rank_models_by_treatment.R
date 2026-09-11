
#' Rank models within each treatment
#'
#' @param comparison Output from compare_models_by_treatment().
#'
#' @return Ranked data frame.
#'
#' @export
rank_models_by_treatment <- function(comparison) {

  if (!is.data.frame(comparison)) {
    stop(
      "comparison must be a data.frame."
    )
  }

  required_cols <- c(
    "Treatment",
    "Model",
    "Mean_R2",
    "Mean_RMSE",
    "Mean_AIC",
    "Mean_BIC"
  )

  missing_cols <- setdiff(
    required_cols,
    names(comparison)
  )

  if (length(missing_cols) > 0) {

    stop(
      paste(
        "Missing required column(s):",
        paste(
          missing_cols,
          collapse = ", "
        )
      )
    )

  }

  comparison |>

    dplyr::group_by(
      Treatment
    ) |>

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

    ) |>

    dplyr::ungroup()

}
