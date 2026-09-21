# Summary of Michaelis-Menten Fits

Summarizes parameter estimates and goodness-of-fit statistics for a
fitted Michaelis-Menten model.

## Usage

``` r
# S3 method for class 'mm_fit'
summary(object, ...)
```

## Arguments

- object:

  A `mm_fit` object.

- ...:

  Additional arguments passed to methods.

## Value

A data frame containing parameter estimates and model diagnostics for
each fitted bottle.

## Details

The summary typically includes:

- Asymptotic gas production (`A`)

- Half-time parameter (`K`)

- Shape parameter (`c`)

- Residual Sum of Squares (RSS)

- Root Mean Squared Error (RMSE)

- R-squared (R²)

- Akaike Information Criterion (AIC)

- Bayesian Information Criterion (BIC)

The generalized Michaelis-Menten model is a flexible sigmoidal model
commonly used to describe cumulative gas production.

The parameter `K` represents the time required to reach approximately
half of the asymptotic gas production, while `c` controls curve shape
and steepness.

### Notes

The generalized Michaelis-Menten model is mathematically equivalent to
the Groot model implemented in
[`fit_groot()`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_groot.md).

Parameter correspondence:

- `A = VF`

- `K = b`

- `c = k`

Both formulations produce identical fitted values and model diagnostics
when convergence is achieved.

## See also

[`fit_mm`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_mm.md),
[`fit_groot`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_groot.md),
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

fit <- fit_mm(
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
#> Michaelis-Menten model summary
#> ------------------------------
#> Total bottles: 24
#> Successful fits: 23
#> Failed fits: 1
#> Low R-squared (< 0.90): 2
#> 
```
