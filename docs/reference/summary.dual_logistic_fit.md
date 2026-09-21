# Summary of Dual Logistic Fits

Summarizes parameter estimates and goodness-of-fit statistics for a
fitted dual-pool logistic model.

## Usage

``` r
# S3 method for class 'dual_logistic_fit'
summary(object, ...)
```

## Arguments

- object:

  A `dual_logistic_fit` object.

- ...:

  Additional arguments passed to methods.

## Value

A data frame containing parameter estimates and model diagnostics for
each fitted bottle.

## Details

The summary typically includes:

- Rapid pool gas volume (`V1F`)

- Slow pool gas volume (`V2F`)

- Rapid pool rate constant (`k1`)

- Slow pool rate constant (`k2`)

- Lag time (`lambda`)

- Residual Sum of Squares (RSS)

- Root Mean Squared Error (RMSE)

- R-squared (R²)

- Akaike Information Criterion (AIC)

- Bayesian Information Criterion (BIC)

The Dual Logistic model partitions fermentation into rapidly and slowly
degradable fractions, providing a biologically informative description
of fermentation dynamics.

## See also

[`fit_dual_logistic`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_dual_logistic.md),
[`plot_dual_pools`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_dual_pools.md),
[`plot_fit`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_fit.md),
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

fit <- fit_dual_logistic(
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
#> Dual-pool Logistic model summary
#> --------------------------------
#> Total bottles: 24
#> Successful fits: 20
#> Failed fits: 4
#> Low R-squared (< 0.90): 0
#> Lambda at boundary: 1
#> 
```
