
#' Flag potentially problematic Gompertz fits
#'
#' Flags bottles with poor convergence,
#' low R² values or parameter-boundary issues.
#'
#' @param fit A gompertz_fit object.
#' @param r2_threshold Minimum acceptable R².
#'
#' @return Data frame of flagged bottles.
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

      Flag = dplyr::case_when(

        !Converged ~
          "FIT_FAILED",

        R2 < r2_threshold ~
          "LOW_R2",

        Lambda_Boundary ~
          "LAMBDA_AT_BOUNDARY",

        TRUE ~
          "OK"
      )

    )

  flags

}
