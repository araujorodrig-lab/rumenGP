# Plot Model Rankings

Visualizes model rankings across multiple performance metrics.

## Usage

``` r
plot_model_rankings(ranking)
```

## Arguments

- ranking:

  Output from
  [`rank_models()`](https://araujorodrig-lab.github.io/rumenGP/reference/rank_models.md).

## Value

A `ggplot2` object.

## Details

Rankings are typically based on metrics such as:

- R-squared (R²)

- Root Mean Squared Error (RMSE)

- Residual Sum of Squares (RSS)

- Akaike Information Criterion (AIC)

- Bayesian Information Criterion (BIC)

This visualization helps identify models that consistently perform well
across several evaluation criteria.

## See also

[`rank_models`](https://araujorodrig-lab.github.io/rumenGP/reference/rank_models.md),
[`compare_models`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models.md),
[`plot_model_performance`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_model_performance.md)

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

comparison <- compare_models(
  Groot = groot_fit,
  Gompertz = gompertz_fit
)

ranking <- rank_models(
  comparison
)

plot_model_rankings(
  ranking
)

```
