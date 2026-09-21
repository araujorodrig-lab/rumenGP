# Convert data to a rumen_gp object

Converts gas production data from any source into the internal rumenGP
format.

## Usage

``` r
as_rumen_gp(
  data,
  head_col,
  time_col,
  gas_col = NULL,
  pressure_col = NULL,
  treatment_col = NULL,
  bottle_col = NULL,
  rep_col = NULL,
  pressure_unit = c("psi", "kpa"),
  headspace_volume = NULL,
  headspace_unit = c("mL", "L"),
  temperature = 39,
  zero_negative_pressure = FALSE
)
```

## Arguments

- data:

  A data frame.

- head_col:

  Column identifying bottles.

- time_col:

  Column containing incubation time.

- gas_col:

  Optional column containing cumulative gas production (mL).

- pressure_col:

  Optional column containing pressure measurements.

- treatment_col:

  Optional treatment column.

- bottle_col:

  Optional bottle column.

- rep_col:

  Optional replicate column.

- pressure_unit:

  Pressure unit. Either "psi" or "kpa".

- headspace_volume:

  Headspace volume. Required when pressure_col is supplied.

- headspace_unit:

  Headspace unit. Either "mL" or "L".

- temperature:

  Incubation temperature in degC.

- zero_negative_pressure:

  Logical. If TRUE, negative pressure values are converted to zero
  before gas-volume calculations.

## Value

A rumen_gp object.

## Details

The function accepts either cumulative gas volume or gas pressure
measurements.

When pressure is supplied, gas volume is estimated using the same
conversion used by process_ankom().

## Examples

``` r
if (FALSE) { # \dontrun{

# ----------------------------
# Example 1: Gas volume data
# ----------------------------

manual_volume <- data.frame(
  Bottle = c(
    1, 1, 1,
    2, 2, 2
  ),
  Treatment = c(
    "Control", "Control", "Control",
    "Corn", "Corn", "Corn"
  ),
  Time = c(
    0, 4, 8,
    0, 4, 8
  ),
  Gas = c(
    0, 20, 40,
    0, 35, 60
  )
)

gp <- as_rumen_gp(
  data = manual_volume,
  head_col = "Bottle",
  treatment_col = "Treatment",
  time_col = "Time",
  gas_col = "Gas"
)

head(gp)

# ----------------------------
# Example 2: Pressure data
# ----------------------------

manual_pressure <- data.frame(
  Bottle = rep(
    1,
    10
  ),
  Time = c(
    0, 2, 4, 6, 8,
    12, 16, 24, 36, 48
  ),
  PSI = c(
    0,
    0.2,
    0.5,
    0.8,
    1.2,
    1.8,
    2.5,
    3.2,
    4.0,
    4.5
  )
)

gp <- as_rumen_gp(
  data = manual_pressure,
  head_col = "Bottle",
  time_col = "Time",
  pressure_col = "PSI",
  pressure_unit = "psi",
  headspace_volume = 60
)

head(gp)

# Example model fit
fit <- fit_groot(gp)

summary(fit)

} # }
```
