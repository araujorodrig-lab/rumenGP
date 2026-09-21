
# ----------------------------------
# Internal pressure -> gas volume
# ----------------------------------

pressure_to_volume <- function(
    pressure,
    pressure_unit = c(
      "psi",
      "kpa"
    ),
    headspace_volume,
    headspace_unit = c(
      "mL",
      "L"
    ),
    temperature = 39
) {

  pressure_unit <- match.arg(
    pressure_unit
  )

  headspace_unit <- match.arg(
    headspace_unit
  )

  # ----------------------------
  # Validation
  # ----------------------------

  if (
    !is.numeric(
      headspace_volume
    ) ||
    length(
      headspace_volume
    ) != 1 ||
    headspace_volume <= 0
  ) {

    stop(
      "headspace_volume must be a positive number."
    )

  }

  if (
    !is.numeric(
      temperature
    ) ||
    length(
      temperature
    ) != 1
  ) {

    stop(
      "temperature must be numeric."
    )

  }

  # ----------------------------
  # Constants
  # ----------------------------

  psi_to_kpa <- 6.894757293

  R_constant <- 8.314472

  # ----------------------------
  # Pressure
  # ----------------------------

  pressure_kPa <- pressure

  if (
    pressure_unit == "psi"
  ) {

    pressure_kPa <-
      pressure * psi_to_kpa

  }

  # ----------------------------
  # Headspace
  # ----------------------------

  headspace_L <- headspace_volume

  if (
    headspace_unit == "mL"
  ) {

    headspace_L <-
      headspace_volume / 1000

  }

  # ----------------------------
  # Temperature
  # ----------------------------

  temperature_K <-
    temperature + 273.15

  # ----------------------------
  # Gas calculations
  # ----------------------------

  gas_moles <-
    pressure_kPa *
    (
      headspace_L /
        (
          R_constant *
            temperature_K
        )
    )

  gas_mL <-
    gas_moles *
    22.4 *
    1000

  gas_mL

}
