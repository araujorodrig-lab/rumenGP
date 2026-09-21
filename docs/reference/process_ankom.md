# Process ANKOM RF data

Converts raw ANKOM RF output into a standardized dataset.

## Usage

``` r
process_ankom(
  raw_data,
  metadata = NULL,
  headspace_ml = 210,
  temperature_c = 39,
  zero_negative_pressure = FALSE
)
```

## Arguments

- raw_data:

  Raw ANKOM data table.

- metadata:

  Metadata table.

- headspace_ml:

  Bottle headspace volume (mL).

- temperature_c:

  Incubation temperature (degC).

- zero_negative_pressure:

  Logical. If TRUE, negative pressure values are converted to zero
  before gas-volume calculations.

## Value

A processed rumen_gp data frame.

## Details

Head 0 is reserved by the ANKOM RF system as the receiver/base station
and is automatically removed during processing.
