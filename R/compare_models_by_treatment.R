
#' Compare models by treatment
#'
#' Calculates model performance separately
#' for each treatment.
#'
#' @param ... Fitted model objects.
#'
#' @return A data frame.
#'
#' @export
compare_models_by_treatment <- function(...) {

  fits <- list(...)

  purrr::imap_dfr(
    fits,
    function(fit, model_name) {

      fit$diagnostics |>
        dplyr::group_by(
          Treatment
        ) |>
        dplyr::summarise(

          Model = model_name,

          Mean_R2 =
            mean(
              R2,
              na.rm = TRUE
            ),

          Mean_RMSE =
            mean(
              RMSE,
              na.rm = TRUE
            ),

          Mean_AIC =
            mean(
              AIC,
              na.rm = TRUE
            ),

          Mean_BIC =
            mean(
              BIC,
              na.rm = TRUE
            ),

          .groups = "drop"

        )

    }

  )

}
