# Validate processed rumen gas production data

Performs quality-control checks on a rumen_gp object.

## Usage

``` r
validate_ankom(data)
```

## Arguments

- data:

  A rumen_gp object.

## Value

The validated rumen_gp object.

## Details

Supports datasets created by either:

- process_ankom()

- as_rumen_gp()

ANKOM-specific checks are performed only when Gas_PSI is available.
