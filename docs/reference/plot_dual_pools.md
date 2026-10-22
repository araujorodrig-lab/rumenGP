# Plot Dual-Pool Logistic Decomposition

Visualizes the rapid pool, slow pool, total predicted gas production,
and observed gas production from a fitted dual-pool logistic model.

## Usage

``` r
plot_dual_pools(fit, head = NULL, treatment = NULL, mean_treatment = FALSE)
```

## Arguments

- fit:

  A `dual_logistic_fit` object.

- head:

  Optional bottle identifier. If supplied, only the selected bottle is
  plotted.

- treatment:

  Optional treatment name. If supplied, only observations belonging to
  the selected treatment are plotted.

- mean_treatment:

  Logical. If `TRUE`, treatment means are plotted.

  When used together with `treatment`, the function displays the mean
  dual-pool decomposition of the selected treatment.

  When `treatment = NULL`, mean decompositions are displayed for all
  treatments.

## Value

A `ggplot2` object.

## Details

The plot helps interpret the relative contributions of rapidly and
slowly fermentable fractions through time.

The function can be used to visualize:

- A single bottle

- All bottles within a treatment

- Mean decomposition for a selected treatment

- Mean decompositions for all treatments

Components displayed include:

- Observed gas production

- Predicted total gas production

- Rapid fermentation pool

- Slow fermentation pool

This visualization is useful for:

- Understanding substrate heterogeneity

- Investigating fermentation dynamics

- Comparing treatment-level responses

- Evaluating the relative contribution of rapid and slow fermentation
  pools

## See also

[`fit_dual_logistic`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_dual_logistic.md),
[`plot_fit`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_fit.md),
[`plot_gp`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_gp.md),
[`plot_residuals`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_residuals.md),

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

fit <- fit_dual_logistic(
  gp_clean
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3038
#> Heads: 21
#> Treatments: 5

# Single bottle
plot_dual_pools(
  fit,
  head = 6
)


# All bottles from a treatment
plot_dual_pools(
  fit,
  treatment = "TMR"
)


# Mean decomposition of one treatment
plot_dual_pools(
  fit,
  treatment = "TMR",
  mean_treatment = TRUE
)
#> Error in plot_dual_pools(fit, treatment = "TMR", mean_treatment = TRUE): unused argument (mean_treatment = TRUE)

# Mean decompositions of all treatments
plot_dual_pools(
  fit,
  mean_treatment = TRUE
)
#> Error in plot_dual_pools(fit, mean_treatment = TRUE): unused argument (mean_treatment = TRUE)
```
