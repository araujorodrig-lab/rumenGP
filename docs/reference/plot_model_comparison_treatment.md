# Compare Models for a Treatment

Displays observed and predicted gas production values for multiple
fitted models across all replicates of a selected treatment.

## Usage

``` r
plot_model_comparison_treatment(..., treatment)
```

## Arguments

- ...:

  Fitted model objects.

- treatment:

  Treatment name.

## Value

A `ggplot2` object.

## Details

Observed measurements are displayed alongside model predictions,
allowing visual comparison of competing kinetic models within a
treatment.

This visualization is useful for:

- Comparing competing models

- Evaluating model performance by treatment

- Assessing agreement among biological replicates

- Identifying systematic prediction errors

## See also

[`compare_models_by_treatment`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models_by_treatment.md),
[`plot_model_comparison`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_model_comparison.md),
[`plot_model_comparison_all`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_model_comparison_all.md),
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

plot_model_comparison_treatment(
  Groot = groot_fit,
  Gompertz = gompertz_fit,
  treatment = unique(
    gp$Treatment
  )[1]
)

```
