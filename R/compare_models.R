
#' Compare fitted kinetic models
#'
#' Compares model performance metrics across
#' multiple fitted models.
#'
#' @param ... Named fitted model objects.
#'
#' @return A data frame summarizing model performance.
#'
#' @export
compare_models <- function(...) {

  models <- list(...)

  if (length(models) < 2) {
    stop(
      "Please provide at least two fitted models."
    )
  }

  results <- purrr::imap_dfr(
    models,
    function(model, model_name) {

      diagnostics <- model$diagnostics

      data.frame(

        Model = model_name,

        Bottles =
          nrow(diagnostics),

        Successful_Fits =
          sum(
            diagnostics$Converged,
            na.rm = TRUE
          ),

        Failed_Fits =
          sum(
            !diagnostics$Converged,
            na.rm = TRUE
          ),

        Mean_R2 =
          mean(
            diagnostics$R2,
            na.rm = TRUE
          ),

        Mean_RMSE =
          mean(
            diagnostics$RMSE,
            na.rm = TRUE
          ),

        Mean_RSS =
          mean(
            diagnostics$RSS,
            na.rm = TRUE
          ),

        Mean_AIC =
          mean(
            diagnostics$AIC,
            na.rm = TRUE
          ),

        Mean_BIC =
          mean(
            diagnostics$BIC,
            na.rm = TRUE
          ),

        Lambda_Boundary =
          sum(
            diagnostics$Lambda_Boundary,
            na.rm = TRUE
          )

      )

    }
  )

  rownames(results) <- NULL

  results

}
