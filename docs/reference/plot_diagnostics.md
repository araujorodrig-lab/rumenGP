# Plot Diagnostic Summaries

Creates diagnostic histograms for a fitted model.

## Usage

``` r
plot_diagnostics(fit)
```

## Arguments

- fit:

  A fitted model object.

## Value

A named list of `ggplot2` objects.

## Details

Diagnostic plots can be used to assess:

- Residual distributions

- Parameter estimates

- Model fit quality

- Potential outliers

These plots are useful for evaluating whether model assumptions appear
reasonable and for identifying problematic fits.

## See also

[`plot_fit`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_fit.md),
[`plot_residuals`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_residuals.md),
[`flag_model`](https://araujorodrig-lab.github.io/rumenGP/reference/flag_model.md),
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

plot_diagnostics(
  fit
)
#> $R2
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_bin()`).

#> 
#> $RMSE
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_bin()`).

#> 
#> $AIC
#> Warning: Removed 1 row containing non-finite outside the scale range (`stat_bin()`).

#> 
```
