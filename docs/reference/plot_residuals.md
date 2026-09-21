# Plot Model Residuals

Plots residuals for an individual bottle.

## Usage

``` r
plot_residuals(fit, head = NULL)
```

## Arguments

- fit:

  A fitted model object containing a predictions element.

- head:

  Optional Head identifier. If omitted and only one bottle is present,
  that bottle is plotted automatically.

## Value

A `ggplot2` object.

## Details

Residuals are calculated as:

\$\$ Residual = Observed - Predicted \$\$

Residual plots are useful for:

- Identifying systematic model bias

- Detecting outliers

- Evaluating model assumptions

- Assessing goodness of fit

Ideally, residuals should be randomly distributed around zero with no
obvious trend through time.

## See also

[`plot_fit`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_fit.md),
[`plot_residual_comparison`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_residual_comparison.md),
[`plot_diagnostics`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_diagnostics.md),
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

fit <- fit_groot(
  gp
)
#> Warning: Large negative pressure values detected. Minimum PSI = -1.274 . Please inspect the affected bottles.
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
#> Treatments: 5

plot_residuals(
  fit,
  head = 1
)
#> `geom_smooth()` using formula = 'y ~ x'

```
