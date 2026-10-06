# Summary of Log-logistic Fits

Summarizes parameter estimates and goodness-of-fit statistics for a
fitted Log-logistic model.

## Usage

``` r
# S3 method for class 'loglogistic_fit'
summary(object, ...)
```

## Arguments

- object:

  A `loglogistic_fit` object.

- ...:

  Additional arguments passed to methods.

## Value

A data frame containing parameter estimates and model diagnostics for
each fitted bottle.

## Details

The summary typically includes:

- Asymptotic gas production (`VF`)

- Rate parameter (`r`)

- Shape parameter (`a`)

- Residual Sum of Squares (RSS)

- Root Mean Squared Error (RMSE)

- R-squared (R²)

- Akaike Information Criterion (AIC)

- Bayesian Information Criterion (BIC)

The Log-logistic model is a flexible sigmoidal model capable of
describing a broad range of gas production profiles.

The parameter `r` controls the speed of gas production, while `a`
controls curve shape, steepness, and inflection behavior.

### Notes

The Log-logistic model is mathematically equivalent to both the Groot
model implemented in
[`fit_groot()`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_groot.md)
and the generalized Michaelis-Menten model implemented in
[`fit_mm()`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_mm.md).

Parameter correspondence:

- `VF = A`

- `a = c = k`

- `1/r = K = b`

All three formulations produce identical fitted values, residuals,
diagnostics, AIC, BIC, RMSE, and R-squared when corresponding parameter
values are used.

## See also

[`fit_loglogistic`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_loglogistic.md),
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

fit <- fit_loglogistic(
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
#> Log-logistic model summary
#> --------------------------
#> Total bottles: 24
#> Successful fits: 24
#> Failed fits: 0
#> Low R-squared (< 0.90): 3
#> 
```
