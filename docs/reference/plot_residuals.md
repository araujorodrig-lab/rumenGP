# Plot model residuals

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

A ggplot object.
