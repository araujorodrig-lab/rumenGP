# Compare Models Within a Treatment

Displays observed and predicted gas production values for multiple
fitted models within a selected treatment.

## Usage

``` r
plot_model_comparison_treatment(..., treatment)
```

## Arguments

- ...:

  Fitted model objects.

- treatment:

  Treatment name to visualize.

## Value

A `ggplot2` object showing observed gas production values and predicted
model curves for a selected treatment.

## Details

Observed measurements are displayed alongside model predictions,
allowing visual comparison of competing kinetic models across treatment
replicates.

Individual panels correspond to biological replicates, facilitating the
evaluation of:

- Agreement among competing models

- Consistency among treatment replicates

- Treatment-specific fermentation patterns

- Systematic prediction errors

- Model performance within a treatment

## See also

[`compare_models_by_treatment`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models_by_treatment.md),
[`plot_model_comparison`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_model_comparison.md),
[`plot_model_comparison_all`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_model_comparison_all.md),
[`plot_treatment_mean`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_treatment_mean.md),
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

plot_model_comparison_treatment(
  Groot = groot_fit,
  Gompertz = gompertz_fit,
  treatment = "TMR"
)

```
