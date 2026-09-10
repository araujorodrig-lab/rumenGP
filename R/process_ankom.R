#' Process ANKOM RF data
#'
#' Converts raw ANKOM RF output into a standardized dataset.
#'
#' Head 0 is reserved by the ANKOM RF system as the
#' receiver/base station and is automatically removed
#' during processing.
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

  psi_to_kpa <- 6.894757293

  # ----------------------------
  # Time processing
  # ----------------------------

  names(raw_data)[1] <- "time_raw"

  raw_data$Time_h <- parse_ankom_time(
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
    dplyr::mutate(
      Head = as.character(Head)
    ) |>

    # Remove ANKOM receiver/base station
    dplyr::filter(
      Head != "0"
    ) |>

    # Remove empty channels
    dplyr::filter(
      !is.na(Gas_PSI)
    ) |>

    dplyr::mutate(

      # PSI to kPa
      Gas_kPa =
        Gas_PSI * psi_to_kpa,

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

    required_cols <- c(
      "Head",
      "Sample",
      "Rep"
    )

    missing_cols <- setdiff(
      required_cols,
      names(metadata)
    )

    if (length(missing_cols) > 0) {
      stop(
        paste(
          "Metadata is missing required column(s):",
          paste(missing_cols,
                collapse = ", ")
        )
      )
    }

    metadata$Head <- as.character(
      metadata$Head
    )

    df <- dplyr::left_join(
      df,
      metadata,
      by = "Head"
    )

    # Keep only bottles present in metadata
    df <- df |>
      dplyr::filter(
        !is.na(Sample)
      )
  }

  # ----------------------------
  # Store processing settings
  # ----------------------------

  attr(df, "settings") <- list(
    headspace_ml = headspace_ml,
    temperature_c = temperature_c,
    psi_to_kpa = psi_to_kpa,
    gas_constant = R_constant
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
