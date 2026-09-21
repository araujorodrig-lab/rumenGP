# Summary of Groot Fits

Summarizes parameter estimates and goodness-of-fit statistics for a
fitted Groot model.

## Usage

``` r
# S3 method for class 'groot_fit'
summary(object, ...)
```

## Arguments

- object:

  A `groot_fit` object.

- ...:

  Additional arguments passed to methods.

## Value

A data frame containing parameter estimates and model diagnostics for
each fitted bottle.

## Details

The summary typically includes:

- Asymptotic gas production (`VF`)

- Half-time parameter (`b`)

- Shape parameter (`k`)

- Residual Sum of Squares (RSS)

- Root Mean Squared Error (RMSE)

- R-squared (R²)

- Akaike Information Criterion (AIC)

- Bayesian Information Criterion (BIC)

The Groot model is a flexible sigmoidal model commonly used in rumen gas
production studies.

The parameter `b` represents the time required to reach approximately
half of the asymptotic gas production, while `k` controls curve shape
and steepness.

### Notes

The Groot model is mathematically equivalent to the generalized
Michaelis-Menten model implemented in
[`fit_mm()`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_mm.md).

Parameter correspondence:

- `VF = A`

- `b = K`

- `k = c`

## See also

[`fit_groot`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_groot.md),
[`fit_mm`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_mm.md),
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

fit <- fit_groot(
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
#> Groot model summary
#> -------------------
#> Total bottles: 24
#> Successful fits: 23
#> Failed fits: 1
#> Low R-squared (< 0.90): 2
#> 
```
