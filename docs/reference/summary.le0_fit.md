# Summary of LE0 Fits

Summarizes parameter estimates and goodness-of-fit statistics for a
fitted LE0 model.

## Usage

``` r
# S3 method for class 'le0_fit'
summary(object, ...)
```

## Arguments

- object:

  A `le0_fit` object.

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

- Residual Sum of Squares (RSS)

- Root Mean Squared Error (RMSE)

- R-squared (R²)

- Akaike Information Criterion (AIC)

- Bayesian Information Criterion (BIC)

The LE0 (Logistic-Exponential) model combines exponential fermentation
kinetics with a logistic component to provide additional flexibility in
curve shape without requiring an explicit lag phase.

The shape parameter `d` controls the curvature of the fermentation
profile and can improve fit performance for sigmoidal gas production
data.

## See also

[`fit_le0`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_le0.md),
[`fit_lel`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_lel.md),
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

fit <- fit_le0(
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
#> Logistic-Exponential (LE0) model summary
#> ----------------------------------------
#> Total bottles: 24
#> Successful fits: 23
#> Failed fits: 1
#> Low R-squared (< 0.90): 2
#> 
```
