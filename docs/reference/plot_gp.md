# Plot Raw Gas Production Curve

Plots observed gas production measurements for an individual bottle.

## Usage

``` r
plot_gp(data, head)
```

## Arguments

- data:

  A `rumen_gp` object.

- head:

  Bottle identifier to plot.

## Value

A `ggplot2` object.

## Details

This visualization displays the raw gas production profile prior to
model fitting and is useful for:

- Inspecting fermentation dynamics

- Identifying unusual observations

- Evaluating data quality

- Comparing individual bottle profiles

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

plot_gp(
  gp,
  head = 1
)

```
