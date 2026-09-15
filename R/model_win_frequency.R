
#' Model win frequency
#'
#' Summarizes how often each model is the
#' best-performing model across treatments.
#'
#' @param best_models Output from
#' best_model_by_treatment().
#'
#' @return A data frame.
#'
#' @export
model_win_frequency <- function(
    best_models
) {

  best_models |>

    dplyr::count(
      Model,
      name = "Treatments_Won"
    ) |>

    dplyr::arrange(
      dplyr::desc(
        Treatments_Won
      )
    )

}
