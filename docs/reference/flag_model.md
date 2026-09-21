# Flag potentially problematic model fits

Flags bottles with poor convergence, low R-squared values and
parameter-boundary issues.

## Usage

``` r
flag_model(fit, r2_threshold = 0.9)
```

## Arguments

- fit:

  A fitted model object.

- r2_threshold:

  Minimum acceptable R-squared.

## Value

Diagnostic table with QC flags.
