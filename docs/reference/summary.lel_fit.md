# Summary of LEL Fits

Summarizes parameter estimates and goodness-of-fit statistics for a
fitted LEL model.

## Usage

``` r
# S3 method for class 'lel_fit'
summary(object, ...)
```

## Arguments

- object:

  A `lel_fit` object.

- ...:

  Additional arguments passed to methods.

## Value

A data frame containing parameter estimates and model diagnostics for
each fitted bottle.

## Details

The summary typically includes:

- Asymptotic gas production (`A`)

- Fractional rate constant (`k`)

- Shape parameter (`d`)

- Lag time (`lambda`)

- Residual Sum of Squares (RSS)

- Root Mean Squared Error (RMSE)

- R-squared (R²)

- Akaike Information Criterion (AIC)

- Bayesian Information Criterion (BIC)

The LEL (Logistic-Exponential with Lag) model combines exponential
fermentation kinetics with a logistic component and an explicit lag
phase.

The lag parameter (`lambda`) represents the delay before substantial
fermentation begins, while the shape parameter (`d`) controls curve
flexibility.

This combination makes the LEL model suitable for describing complex
sigmoidal fermentation profiles with delayed onset.

## See also

[`fit_lel`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_lel.md),
[`fit_le0`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_le0.md),
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

fit <- fit_lel(
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
#> Logistic-Exponential (LEL) model summary
#> ----------------------------------------
#> Total bottles: 24
#> Successful fits: 23
#> Failed fits: 1
#> Low R-squared (< 0.90): 11
#> Lambda at boundary: 11
#> 
```
