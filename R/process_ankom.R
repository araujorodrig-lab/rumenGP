
#' Process ANKOM RF data
#'
#' Converts raw ANKOM RF output into a standardized dataset.
#'
#' @param raw_data Raw ANKOM data table.
#' @param metadata Metadata table.
#' @param headspace_ml Bottle headspace volume (mL).
#' @param temperature_c Incubation temperature (°C).
#'
#' @return A processed rumen_gp data frame.
#'
#' @export
process_ankom <- function(
    raw_data,
    metadata = NULL,
    headspace_ml = 210,
    temperature_c = 39
) {

  # ----------------------------
  # Input validation
  # ----------------------------

  if (!is.data.frame(raw_data)) {
    stop("raw_data must be a data.frame.")
  }

  if (!is.numeric(headspace_ml) ||
      length(headspace_ml) != 1 ||
      headspace_ml <= 0) {
    stop("headspace_ml must be a positive number.")
  }

  if (!is.numeric(temperature_c) ||
      length(temperature_c) != 1) {
    stop("temperature_c must be numeric.")
  }

  # ----------------------------
  # Experimental constants
  # ----------------------------

  headspace_L <- headspace_ml / 1000

  temp_K <- temperature_c + 273.15

  R_constant <- 8.314472

  # ----------------------------
  # Time processing
  # ----------------------------

  names(raw_data)[1] <- "time_raw"

  raw_data$Time_h <-
    parse_ankom_time(
      raw_data$time_raw
    )

  # ----------------------------
  # Long format conversion
  # ----------------------------

  df <- raw_data |>
    tidyr::pivot_longer(
      cols = -c(
        time_raw,
        Time_h
      ),
      names_to = "Head",
      values_to = "Gas_PSI"
    ) |>
    dplyr::filter(
      !is.na(Gas_PSI)
    ) |>
    dplyr::mutate(

      Head = as.character(Head),

      # PSI to kPa
      Gas_kPa =
        Gas_PSI * 6.894757293,

      # Ideal gas law
      Gas_moles =
        Gas_kPa *
        (
          headspace_L /
            (
              R_constant *
                temp_K
            )
        ),

      # Avogadro conversion
      Gas_mL =
        Gas_moles *
        22.4 *
        1000
    )

  # ----------------------------
  # Metadata join
  # ----------------------------

  if (!is.null(metadata)) {

    if (!"Head" %in% names(metadata)) {
      stop(
        "Metadata must contain a column called 'Head'."
      )
    }

    metadata$Head <-
      as.character(
        metadata$Head
      )

    df <- dplyr::left_join(
      df,
      metadata,
      by = "Head"
    )
  }

  # ----------------------------
  # Store processing settings
  # ----------------------------

  attr(df, "settings") <- list(
    headspace_ml = headspace_ml,
    temperature_c = temperature_c
  )

  # ----------------------------
  # Assign class
  # ----------------------------

  class(df) <- c(
    "rumen_gp",
    class(df)
  )

  df
}
