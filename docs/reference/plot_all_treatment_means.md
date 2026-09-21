# Plot Treatment Means for All Treatments

Compares observed and predicted treatment means across multiple fitted
models.

## Usage

``` r
plot_all_treatment_means(..., show_se = TRUE)
```

## Arguments

- ...:

  Fitted model objects.

- show_se:

  Logical. If `TRUE`, displays a standard-error ribbon around the
  observed treatment mean.

## Value

A `ggplot2` object.

## Details

The observed treatment mean is shown as a black line with optional
standard-error bands. Predicted treatment means from each fitted model
are overlaid for comparison.

This visualization is useful for evaluating model performance at the
treatment level rather than at the individual bottle level.

## See also

[`plot_treatment_mean`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_treatment_mean.md),
[`compare_models`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models.md),
[`fit_groot`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_groot.md),
[`fit_gompertz`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_gompertz.md)

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

groot_fit <- fit_groot(
  gp
)
#> Warning: Large negative pressure values detected. Minimum PSI = -1.274 . Please inspect the affected bottles.
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
#> Treatments: 5

gompertz_fit <- fit_gompertz(
  gp
)
#> Warning: Large negative pressure values detected. Minimum PSI = -1.274 . Please inspect the affected bottles.
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
#> Treatments: 5

plot_all_treatment_means(
  Groot = groot_fit,
  Gompertz = gompertz_fit
)

```
