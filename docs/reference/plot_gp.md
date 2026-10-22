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

  Logical. If `TRUE`, treatment means are plotted.

  When used together with `treatment`, the function displays the mean
  gas-production profile of the selected treatment.

  When `treatment = NULL`, mean profiles are displayed for all
  treatments.

## Value

A `ggplot2` object.

## Details

The function can be used to visualize:

- A single bottle

- All bottles in the dataset

- All bottles within a treatment

- The mean profile of a single treatment

- Mean profiles of all treatments

This visualization is useful for:

- Inspecting fermentation dynamics

- Identifying unusual observations

- Evaluating data quality

- Comparing bottle-level responses

- Comparing treatment-level responses

- Exploring treatment means and variability

## See also

[`plot_fit`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_fit.md),
[`plot_residuals`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_residuals.md),
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

# Single bottle
plot_gp(
  gp_clean,
  head = 6
)


# All bottles
plot_gp(
  gp_clean
)


# All bottles within a treatment
plot_gp(
  gp_clean,
  treatment = "TMR"
)


# Mean profile for one treatment
plot_gp(
  gp_clean,
  treatment = "TMR",
  mean_treatment = TRUE
)


# Mean profiles for all treatments
plot_gp(
  gp_clean,
  mean_treatment = TRUE
)

```
