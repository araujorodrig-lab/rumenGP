# Summary of EXPL Fits

Summarizes parameter estimates and goodness-of-fit statistics for a
fitted EXPL model.

## Usage

``` r
# S3 method for class 'expl_fit'
summary(object, ...)
```

## Arguments

- object:

  An `expl_fit` object.

- ...:

  Additional arguments passed to methods.

## Value

A data frame containing parameter estimates and model diagnostics for
each fitted bottle.

## Details

The summary typically includes:

- Asymptotic gas production (`Vf`)

- Fractional rate constant (`k`)

- Lag time (`lambda`)

- Residual Sum of Squares (RSS)

- Root Mean Squared Error (RMSE)

- R-squared (R²)

- Akaike Information Criterion (AIC)

- Bayesian Information Criterion (BIC)

The EXPL model describes gas production as an exponential approach to an
asymptotic gas volume following a lag phase.

The lag parameter represents the delay before substantial fermentation
begins.

## See also

[`fit_expl`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_expl.md),
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

fit <- fit_expl(
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
#> Exponential model with lag (EXPL) summary
#> -----------------------------------------
#> Total bottles: 24
#> Successful fits: 23
#> Failed fits: 1
#> Low R-squared (< 0.90): 3
#> Lambda at boundary: 8
#> 
```
