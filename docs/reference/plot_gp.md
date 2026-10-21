# Plot Raw Gas Production Curves

Plots observed gas-production measurements from a `rumen_gp` object.

## Usage

``` r
plot_gp(data, head = NULL, treatment = NULL, mean_treatment = FALSE)
```

## Arguments

- data:

  A `rumen_gp` object.

- head:

  Optional bottle identifier. If supplied, only the selected bottle is
  plotted.

- treatment:

  Optional treatment name. If supplied, only observations belonging to
  the selected treatment are plotted.

- mean_treatment:

  Logical. If `TRUE`, plots the mean gas-production profile of the
  selected treatment.

## Value

A `ggplot2` object.

## Details

The function can be used to visualize:

- A single bottle

- All bottles in the dataset

- All bottles within a treatment

- Mean treatment gas-production profiles

This visualization is useful for:

- Inspecting fermentation dynamics

- Identifying unusual observations

- Evaluating data quality

- Comparing bottle-level responses

- Comparing treatment-level responses

## See also

[`plot_fit`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_fit.md),
[`plot_residuals`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_residuals.md),
[`plot_treatment_mean`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_treatment_mean.md),
[`process_ankom`](https://araujorodrig-lab.github.io/rumenGP/reference/process_ankom.md)

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

# Single bottle
plot_gp(
  gp,
  head = 1
)


# All bottles
plot_gp(
  gp
)


# All bottles within a treatment
plot_gp(
  gp,
  treatment = "TMR"
)


# Mean treatment profile
plot_gp(
  gp,
  treatment = "TMR",
  mean_treatment = TRUE
)

```
