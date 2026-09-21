# Parse ANKOM Timestamps

Converts ANKOM RF timestamps into elapsed incubation time expressed in
hours.

## Usage

``` r
parse_ankom_time(time_raw)
```

## Arguments

- time_raw:

  Character vector containing ANKOM timestamps.

## Value

A numeric vector containing elapsed incubation time in hours.

## Details

ANKOM RF systems record measurements using timestamps. This function
converts those timestamps into elapsed incubation time, measured
relative to the first observation.

The resulting values are used throughout rumenGP for:

- Data processing

- Model fitting

- Visualization

- Model comparison

In most workflows, this function is called automatically by
[`process_ankom()`](https://araujorodrig-lab.github.io/rumenGP/reference/process_ankom.md)
and does not need to be used directly.

## See also

[`read_ankom`](https://araujorodrig-lab.github.io/rumenGP/reference/read_ankom.md),
[`process_ankom`](https://araujorodrig-lab.github.io/rumenGP/reference/process_ankom.md),
[`example_data`](https://araujorodrig-lab.github.io/rumenGP/reference/example_data.md)

## Examples

``` r

timestamps <- c(
  "2024-01-01 08:00:00",
  "2024-01-01 12:00:00",
  "2024-01-01 20:00:00"
)

parse_ankom_time(
  timestamps
)
#> Warning: Some strings failed to parse
#> Warning: Some strings failed to parse
#> Warning: Some strings failed to parse
#> Warning: no non-missing arguments to min; returning Inf
#> [1] NA NA NA

# Typical workflow
files <- example_data()

raw_data <- read_ankom(
  files$ankom
)

metadata <- read_metadata(
  files$metadata
)

gp <- process_ankom(
  raw_data,
  metadata,
  headspace_ml = 210,
  temperature_c = 39
)

head(
  gp$Time_h
)
#> [1] 0 0 0 0 0 0
```
