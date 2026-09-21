# Summary of Custom Model Fits

Summarizes a fitted custom nonlinear model.

## Usage

``` r
# S3 method for class 'custom_fit'
summary(object, ...)
```

## Arguments

- object:

  A `custom_fit` object.

- ...:

  Not used.

## Value

Invisibly returns the input `custom_fit` object.

## Details

The summary typically reports:

- Model name

- Model formula

- Parameter estimates

- Residual Sum of Squares (RSS)

- Root Mean Squared Error (RMSE)

- R-squared (R²)

- Akaike Information Criterion (AIC)

- Bayesian Information Criterion (BIC)

This method provides a concise overview of parameter estimates and model
performance for user-defined nonlinear equations fitted with
[`fit_custom()`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_custom.md).

## See also

[`fit_custom`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_custom.md),
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

custom_fit <- fit_custom(
  data = gp,
  formula =
    Gas_mL ~
      A *
      (
        Time_h /
        (
          Time_h + K
        )
      ),
  start = list(
    A = 150,
    K = 10
  ),
  lower = c(
    A = 0,
    K = 0
  ),
  model_name = "Hyperbolic"
)
#> Warning: Large negative pressure values detected. Minimum PSI = -1.274 . Please inspect the affected bottles.
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
#> Treatments: 5

summary(
  custom_fit
)
#> 
#> Custom model summary
#> --------------------
#> Model name: Hyperbolic
#> 
#> Formula:
#> Gas_mL ~ A * (Time_h/(Time_h + K))
#> 
#> Total bottles: 24
#> Successful fits: 23
#> Failed fits: 1
#> Mean R-squared: 0.8911
#> Mean RMSE: 3.6575
#> Mean AIC: 393.3084
#> Mean BIC: 400.1798
#> 
```
