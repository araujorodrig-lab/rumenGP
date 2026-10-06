# Summary of Inverse Paralogistic Fits

Summarizes parameter estimates and goodness-of-fit statistics for a
fitted Inverse Paralogistic model.

## Usage

``` r
# S3 method for class 'inverse_paralogistic_fit'
summary(object, ...)
```

## Arguments

- object:

  An `inverse_paralogistic_fit` object.

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

The Inverse Paralogistic model is a flexible sigmoidal model capable of
describing a broad range of cumulative gas production profiles.

The parameter `r` controls the speed of gas production, while `a`
controls curve shape, steepness, and inflection behavior.

## See also

[`fit_inverse_paralogistic`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_inverse_paralogistic.md),
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

fit <- fit_inverse_paralogistic(
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
#> Inverse Paralogistic model summary
#> ----------------------------------
#> Total bottles: 24
#> Successful fits: 24
#> Failed fits: 0
#> Low R-squared (< 0.90): 5
#> 
```
