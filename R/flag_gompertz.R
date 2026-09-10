
#' Flag potentially problematic Gompertz fits
#'
#' Flags bottles with poor convergence,
#' low R² values and parameter-boundary issues.
#'
#' @param fit A gompertz_fit object.
#' @param r2_threshold Minimum acceptable R².
#'
#' @return Diagnostic table with QC flags.
#'
#' @export
flag_gompertz <- function(
    fit,
    r2_threshold = 0.90
) {

  if (!inherits(fit, "gompertz_fit")) {
    stop(
      "Input must be a gompertz_fit object."
    )
  }

  flags <- fit$diagnostics |>
    dplyr::mutate(

      Flag_FitFailed =
        !Converged,

      Flag_LowR2 =
        dplyr::if_else(
          !is.na(R2) &
            R2 < r2_threshold,
          TRUE,
          FALSE
        ),

      Flag_LambdaBoundary =
        dplyr::if_else(
          !is.na(Lambda_Boundary) &
            Lambda_Boundary,
          TRUE,
          FALSE
        )

    ) |>

    dplyr::mutate(

      Overall_Flag =
        dplyr::case_when(

          Flag_FitFailed ~
            "FIT_FAILED",

          Flag_LowR2 &
            Flag_LambdaBoundary ~
            "LOW_R2 + LAMBDA_AT_BOUNDARY",

          Flag_LowR2 ~
            "LOW_R2",

          Flag_LambdaBoundary ~
            "LAMBDA_AT_BOUNDARY",

          TRUE ~
            "OK"

        )

    )

  flags

}
