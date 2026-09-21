# Summary of Gompertz Fits

Summarizes parameter estimates and goodness-of-fit statistics for a
fitted Gompertz model.

## Usage

``` r
# S3 method for class 'gompertz_fit'
summary(object, ...)
```

## Arguments

- object:

  A `gompertz_fit` object.

- ...:

  Additional arguments passed to methods.

## Value

A data frame containing parameter estimates and model diagnostics for
each fitted bottle.

## Details

The summary typically includes:

- Asymptotic gas production (`A`)

- Maximum gas production rate (`mu`)

- Lag time (`lambda`)

- Residual Sum of Squares (RSS)

- Root Mean Squared Error (RMSE)

- R-squared (R²)

- Akaike Information Criterion (AIC)

- Bayesian Information Criterion (BIC)

The modified Gompertz model provides a biologically meaningful
description of fermentation kinetics by explicitly estimating:

- Final gas production potential

- Maximum fermentation rate

- Lag phase duration

## See also

[`fit_gompertz`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_gompertz.md),
[`plot_fit`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_fit.md),
[`plot_residuals`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_residuals.md),
[`compare_models`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models.md)

## Examples

``` r

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

fit <- fit_gompertz(
  gp
)
#> Warning: Large negative pressure values detected. Minimum PSI = -1.274 . Please inspect the affected bottles.
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
#> Treatments: 5

summary(
  fit
)
#> 
#> Gompertz model summary
#> ----------------------
#> Total bottles: 24
#> Successful fits: 24
#> Failed fits: 0
#> Low R-squared (< 0.90): 3
#> Lambda at boundary: 8
#> 
```
