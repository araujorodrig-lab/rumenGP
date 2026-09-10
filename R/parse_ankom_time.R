
#' Parse ANKOM timestamps
#'
#' Converts ANKOM RF timestamps into elapsed incubation time (hours).
#'
#' @param time_raw Character vector containing ANKOM timestamps.
#'
#' @return Numeric vector of elapsed incubation time in hours.
#'
#' @export
parse_ankom_time <- function(time_raw) {

  # ANKOM omits day 0, so add it back
  time_std <- ifelse(
    grepl("^[0-9]+\\.", time_raw),
    time_raw,
    paste0("0.", time_raw)
  )

  parsed <- strsplit(time_std, "\\.")

  total_seconds <- vapply(
    parsed,
    function(x) {

      day <- as.numeric(x[1])

      time_of_day <- lubridate::hms(x[2])

      day * 86400 +
        as.numeric(time_of_day)

    },
    numeric(1)
  )

  elapsed_h <- (
    total_seconds -
      min(total_seconds, na.rm = TRUE)
  ) / 3600

  elapsed_h

}
