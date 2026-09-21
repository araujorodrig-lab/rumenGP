# Rank Models

Ranks fitted models using multiple model performance criteria.

## Usage

``` r
rank_models(comparison)
```

## Arguments

- comparison:

  Output of
  [`compare_models()`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models.md).

## Value

A data frame containing model rankings across performance metrics.

## Details

Rankings are based on metrics produced by
[`compare_models()`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models.md)
and may include:

- R-squared (R²)

- Root Mean Squared Error (RMSE)

- Residual Sum of Squares (RSS)

- Akaike Information Criterion (AIC)

- Bayesian Information Criterion (BIC)

Models that perform consistently well across multiple metrics typically
receive better overall rankings.

This function is useful when comparing several competing kinetic models
and identifying those that provide the best balance between fit quality
and model complexity.

## See also

[`compare_models`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models.md),
[`rank_models_by_treatment`](https://araujorodrig-lab.github.io/rumenGP/reference/rank_models_by_treatment.md),
[`plot_model_performance`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_model_performance.md),
[`plot_model_rankings`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_model_rankings.md)

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

rank_models(
  comparison
)
#>      Model Bottles Successful_Fits Failed_Fits   Mean_R2 Mean_RMSE  Mean_RSS
#> 1    Groot      24              23           1 0.9768621  2.230506  518.1984
#> 2 Gompertz      24              24           0 0.9134729  4.305830 1838.9408
#>   Mean_AIC Mean_BIC Lambda_Boundary Rank_R2 Rank_RMSE Rank_AIC Rank_BIC
#> 1 302.3719 311.4785               0       1         1        1        1
#> 2 400.7494 409.9112               8       2         2        2        2
```
