
#' Validate processed ANKOM data
#'
#' Performs quality-control checks on a rumen_gp object.
#'
#' @param data A rumen_gp object.
#'
#' @return The validated rumen_gp object.
#'
#' @export
validate_ankom <- function(data) {

  # ----------------------------
  # Check object class
  # ----------------------------

  if (!inherits(data, "rumen_gp")) {
    stop(
      "Input must be a rumen_gp object."
    )
  }

  # ----------------------------
  # Required columns
  # ----------------------------

  required_cols <- c(
    "Time_h",
    "Head",
    "Gas_PSI",
    "Gas_mL",
    "Treatment",
    "Rep"
  )

  missing_cols <- setdiff(
    required_cols,
    names(data)
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

  # ----------------------------
  # Missing values
  # ----------------------------

  if (any(is.na(data$Time_h))) {
    stop("Missing Time_h values detected.")
  }

  if (any(is.na(data$Gas_mL))) {
    stop("Missing Gas_mL values detected.")
  }

  # ----------------------------
  # Duplicate observations
  # ----------------------------

  duplicates <- data |>
    dplyr::count(
      Head,
      Time_h
    ) |>
    dplyr::filter(
      n > 1
    )

  if (nrow(duplicates) > 0) {

    warning(
      paste(
        "Duplicate Head-Time observations detected:",
        nrow(duplicates),
        "duplicate combinations found."
      )
    )

  }

  # ----------------------------
  # Negative pressure values
  # ----------------------------

  min_pressure <- min(
    data$Gas_PSI,
    na.rm = TRUE
  )

  if (min_pressure < -1) {

    warning(
      paste(
        "Large negative pressure values detected.",
        "Minimum PSI =",
        round(min_pressure, 3),
        ". Please inspect the affected bottles."
      )
    )

  } else if (min_pressure < 0) {

    message(
      paste(
        "Minor negative pressure values detected.",
        "Minimum PSI =",
        round(min_pressure, 3),
        ". These may reflect normal sensor variation."
      )
    )

  }

  # ----------------------------
  # Empty bottles
  # ----------------------------

  bottle_counts <- data |>
    dplyr::count(
      Head
    )

  if (any(bottle_counts$n < 2)) {

    warning(
      "One or more bottles contain fewer than 2 observations."
    )

  }

  # ----------------------------
  # Treatment-level summary
  # ----------------------------

  message(
    "ANKOM data validation passed.",
    "\nObservations: ", nrow(data),
    "\nHeads: ", dplyr::n_distinct(data$Head),
    "\nTreatments: ", dplyr::n_distinct(data$Treatment)
  )

  data

}
