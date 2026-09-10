
#' Process ANKOM RF data
#'
#' Converts raw ANKOM RF output into a standardized dataset.
#'
#' @param raw_data Raw ANKOM table.
#' @param metadata Metadata table.
#' @param headspace_ml Headspace volume.
#' @param temperature_c Incubation temperature.
#'
#' @return Processed data frame.
#'
#' @export
process_ankom <- function(
    raw_data,
    metadata = NULL,
    headspace_ml = 210,
    temperature_c = 39
) {

  headspace_L <- headspace_ml / 1000

  temp_K <- temperature_c + 273.15

  R_constant <- 8.314472

  raw_data$Time_h <-
    parse_ankom_time(
      raw_data[[1]]
    )

  names(raw_data)[1] <- "time_raw"

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
      Head = as.character(Head),

      Gas_kPa =
        Gas_PSI * 6.894757293,

      Gas_moles =
        Gas_kPa *
        (
          headspace_L /
            (
              R_constant *
                temp_K
            )
        ),

      Gas_mL =
        Gas_moles *
        22.4 *
        1000
    )

  if (!is.null(metadata)) {

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

  df

}
