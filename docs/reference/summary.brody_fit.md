# Summary of Brody Fits

Summarizes parameter estimates and goodness-of-fit statistics for a
fitted Brody model.

## Usage

``` r
# S3 method for class 'brody_fit'
summary(object, ...)
```

## Arguments

- object:

  A `brody_fit` object.

- ...:

  Additional arguments passed to methods.

## Value

A data frame containing parameter estimates and model diagnostics for
each fitted bottle.

## Details

The summary typically includes:

- Parameter estimates

- Standard errors (if available)

- Residual Sum of Squares (RSS)

- Root Mean Squared Error (RMSE)

- R-squared (R²)

- Akaike Information Criterion (AIC)

- Bayesian Information Criterion (BIC)

This method provides a concise overview of model performance and
parameter values for each fitted bottle.

## See also

[`fit_brody`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_brody.md),
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

fit <- fit_brody(
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
#> Brody model summary
#> -------------------
#> Total bottles: 24
#> Successful fits: 23
#> Failed fits: 1
#> Low R-squared (< 0.90): 3
#> 
```
