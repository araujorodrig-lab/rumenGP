# Plot All Fitted Curves

Displays observed and predicted gas production values for all bottles in
a fitted model.

## Usage

``` r
plot_all_fits(fit)
```

## Arguments

- fit:

  A fitted model object produced by one of the rumenGP model-fitting
  functions.

## Value

A `ggplot2` object.

## Details

Each panel corresponds to a single bottle and shows:

- Observed gas production values

- Model predictions

This plot is useful for quickly evaluating model performance across all
bottles in a dataset.

## See also

[`plot_fit`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_fit.md),
[`plot_residuals`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_residuals.md),
[`fit_groot`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_groot.md)

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

plot_all_fits(
  fit
)

```
