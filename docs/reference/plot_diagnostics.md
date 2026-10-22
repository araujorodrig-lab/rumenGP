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

gp_clean <- exclude_heads(
gp,
heads = c(
 "1",
 "2",
 "4",
 "20"
 ),
reason = c(
 "Abnormal gas profile",
 "Abnormal gas profile",
 "Abnormal gas profile",
 "Abnormal gas profile"
 )
 )

fit <- fit_groot(
  gp_clean
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3038
#> Heads: 21
#> Treatments: 5

plot_diagnostics(
  fit
)
#> $R2

#> 
#> $RMSE

#> 
#> $AIC

#> 
```
