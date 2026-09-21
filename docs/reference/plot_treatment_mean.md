# Plot Treatment Means Across Models

Compares observed and predicted treatment means across multiple fitted
models for a selected treatment.

## Usage

``` r
plot_treatment_mean(..., treatment, show_se = TRUE)
```

## Arguments

- ...:

  Fitted model objects.

- treatment:

  Treatment name.

- show_se:

  Logical. If `TRUE`, displays a standard-error ribbon around the
  observed treatment mean.

## Value

A `ggplot2` object.

## Details

The observed treatment mean is displayed as a black line with optional
standard-error bands. Predicted treatment means from each fitted model
are overlaid for visual comparison.

This visualization is useful for:

- Comparing competing kinetic models

- Evaluating treatment-level model performance

- Assessing agreement between observations and predictions

- Comparing fermentation dynamics among models

## See also

[`plot_all_treatment_means`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_all_treatment_means.md),
[`compare_models_by_treatment`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models_by_treatment.md),
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

plot_treatment_mean(
  Groot = groot_fit,
  Gompertz = gompertz_fit,
  treatment = unique(
    gp$Treatment
  )[1]
)

```
