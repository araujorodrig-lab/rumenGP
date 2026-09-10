
#' Exclude problematic ANKOM heads
#'
#' Removes specified bottles while recording
#' the exclusion information.
#'
#' @param data A rumen_gp object.
#' @param heads Character vector of heads to remove.
#' @param reason Character vector of exclusion reasons.
#'
#' @return A filtered rumen_gp object.
#'
#' @export
exclude_heads <- function(
    data,
    heads,
    reason = NULL
) {

  if (!inherits(data, "rumen_gp")) {
    stop(
      "Input must be a rumen_gp object."
    )
  }

  excluded <- data.frame(
    Head = heads,
    Reason =
      if (is.null(reason))
        NA_character_
    else
      reason
  )

  out <- data |>
    dplyr::filter(
      !Head %in% heads
    )

  attr(
    out,
    "excluded_heads"
  ) <- excluded

  class(out) <- class(data)

  out

}
