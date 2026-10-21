# Compare Models for All Bottles

Displays observed and predicted gas production values for multiple
fitted models across all bottles.

## Usage

``` r
plot_model_comparison_all(...)
```

## Arguments

- ...:

  Fitted model objects.

## Value

A `ggplot2` object.

## Details

Observed values are shown alongside model predictions, allowing visual
comparison of competing kinetic models across the entire dataset.

This visualization is useful for:

- Comparing model performance

- Evaluating agreement between models

- Identifying systematic deviations

- Exploring treatment responses

## See also

[`compare_models`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models.md),
[`plot_model_comparison`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_model_comparison.md),
[`plot_model_comparison_treatment`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_model_comparison_treatment.md),
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
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3618
#> Heads: 25
#> Treatments: 5

gompertz_fit <- fit_gompertz(
  gp
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3618
#> Heads: 25
#> Treatments: 5

plot_model_comparison_all(
  Groot = groot_fit,
  Gompertz = gompertz_fit
)

```
