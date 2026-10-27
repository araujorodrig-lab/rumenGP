# Compare Model Fits

Displays observed gas-production values together with predictions from
multiple fitted models.

## Usage

``` r
plot_model_comparison(
  ...,
  head = NULL,
  treatment = NULL,
  mean_treatment = FALSE
)
```

## Arguments

- ...:

  Fitted model objects.

- head:

  Optional bottle identifier. If supplied, only the selected bottle is
  plotted.

- treatment:

  Optional treatment name. If supplied, only observations belonging to
  the selected treatment are plotted.

- mean_treatment:

  Logical. If `TRUE`, treatment means are plotted.

  When used together with `treatment`, the function displays the mean
  observed and predicted profiles for the selected treatment.

  When `treatment = NULL`, mean profiles are displayed for all
  treatments.

## Value

A `ggplot2` object.

## Details

Observed measurements are displayed alongside predictions from each
supplied model, allowing direct visual comparison of competing kinetic
formulations.

The function can be used to visualize:

- A single bottle

- All bottles within a treatment

- The mean response of a selected treatment

- Mean responses across all treatments

This visualization is useful for:

- Comparing competing kinetic models

- Evaluating model performance

- Identifying differences among fitted curves

- Assessing agreement with observations

- Comparing treatment-level responses

- Evaluating treatment means

## See also

[`compare_models`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models.md),
[`plot_fit`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_fit.md),
[`plot_gp`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_gp.md),
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

groot_fit <- fit_groot(
  gp_clean
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3038
#> Heads: 21
#> Treatments: 5

gompertz_fit <- fit_gompertz(
  gp_clean
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3038
#> Heads: 21
#> Treatments: 5

# Single bottle
plot_model_comparison(
  Groot = groot_fit,
  Gompertz = gompertz_fit,
  head = 6
)


# All bottles from one treatment
plot_model_comparison(
  Groot = groot_fit,
  Gompertz = gompertz_fit,
  treatment = "TMR"
)


# Mean comparison for one treatment
plot_model_comparison(
  Groot = groot_fit,
  Gompertz = gompertz_fit,
  treatment = "TMR",
  mean_treatment = TRUE
)


# Mean comparison across all treatments
plot_model_comparison(
  Groot = groot_fit,
  Gompertz = gompertz_fit,
  mean_treatment = TRUE
)

```
