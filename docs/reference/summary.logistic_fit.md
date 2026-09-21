# Summary of Logistic Fits

Summarizes parameter estimates and goodness-of-fit statistics for a
fitted Logistic model.

## Usage

``` r
# S3 method for class 'logistic_fit'
summary(object, ...)
```

## Arguments

- object:

  A `logistic_fit` object.

- ...:

  Additional arguments passed to methods.

## Value

A data frame containing parameter estimates and model diagnostics for
each fitted bottle.

## Details

The summary typically includes:

- Asymptotic gas production (`A`)

- Fractional rate constant (`k`)

- Lag time (`lambda`)

- Residual Sum of Squares (RSS)

- Root Mean Squared Error (RMSE)

- R-squared (R²)

- Akaike Information Criterion (AIC)

- Bayesian Information Criterion (BIC)

The Logistic model describes gas production using a sigmoidal curve
characterized by:

- An initial lag phase

- A rapid fermentation phase

- A plateau approaching asymptotic gas production

The lag parameter (`lambda`) determines the position of the sigmoid
along the time axis, while `k` controls curve steepness.

## See also

[`fit_logistic`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_logistic.md),
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

fit <- fit_logistic(
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
#> Logistic model summary
#> ----------------------
#> Total bottles: 24
#> Successful fits: 24
#> Failed fits: 0
#> Low R-squared (< 0.90): 7
#> Lambda at boundary: 9
#> 
```
