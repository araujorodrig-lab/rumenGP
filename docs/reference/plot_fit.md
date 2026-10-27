# Plot Fitted Model

Plots observed and predicted gas-production values from a fitted model
object.

## Usage

``` r
plot_fit(fit, head = NULL, treatment = NULL, mean_treatment = FALSE)
```

## Arguments

- fit:

  A fitted model object.

- head:

  Optional bottle identifier. If supplied, only the selected bottle is
  plotted.

- treatment:

  Optional treatment name. If supplied, only observations belonging to
  the selected treatment are plotted.

- mean_treatment:

  Logical. If `TRUE`, treatment means are plotted.

  When used together with `treatment`, the function displays the mean
  observed and predicted profile of the selected treatment.

  When `treatment = NULL`, mean profiles are displayed for all
  treatments.

## Value

A `ggplot2` object.

## Details

Observed measurements are displayed alongside fitted model predictions,
allowing visual assessment of model performance.

The function can be used to visualize:

- A single bottle

- All bottles in the fitted dataset

- All bottles within a treatment

- The mean fitted profile of a single treatment

- Mean fitted profiles of all treatments

This visualization is useful for:

- Evaluating model fit

- Identifying systematic deviations

- Inspecting individual fermentation profiles

- Comparing observed and predicted values

- Comparing treatment-level responses

- Evaluating treatment means

## See also

[`plot_gp`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_gp.md),
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

# Single bottle
plot_fit(
  fit,
  head = 6
)


# All bottles
plot_fit(
  fit
)


# Treatment-specific bottles
plot_fit(
  fit,
  treatment = "TMR"
)


# Mean fit for one treatment
plot_fit(
  fit,
  treatment = "TMR",
  mean_treatment = TRUE
)


# Mean fits for all treatments
plot_fit(
  fit,
  mean_treatment = TRUE
)

```
