# Compare Model Fits

Displays observed gas production values together with predictions from
multiple fitted models for a single bottle.

## Usage

``` r
plot_model_comparison(..., head)
```

## Arguments

- ...:

  Fitted model objects.

- head:

  Head identifier.

## Value

A `ggplot2` object.

## Details

This visualization is useful for:

- Comparing competing kinetic models

- Evaluating model performance

- Identifying differences among fitted curves

- Assessing model agreement with observations

Observed measurements are displayed alongside predictions from each
supplied model, allowing direct visual comparison.

## See also

[`compare_models`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models.md),
[`plot_model_comparison_all`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_model_comparison_all.md),
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

plot_model_comparison(
  Groot = groot_fit,
  Gompertz = gompertz_fit,
  head = 1
)

```
