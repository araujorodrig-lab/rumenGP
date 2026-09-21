# Compare Fitted Kinetic Models

Compares performance metrics across multiple fitted kinetic models.

## Usage

``` r
compare_models(...)
```

## Arguments

- ...:

  Named fitted model objects.

## Value

A data frame summarizing model performance metrics for each fitted
model.

## Details

Model comparison metrics typically include:

- R-squared (R²)

- Root Mean Squared Error (RMSE)

- Residual Sum of Squares (RSS)

- Akaike Information Criterion (AIC)

- Bayesian Information Criterion (BIC)

This function helps researchers identify models that provide the best
balance between goodness of fit and model complexity.

The resulting comparison table can be used with:

- [`rank_models()`](https://araujorodrig-lab.github.io/rumenGP/reference/rank_models.md)

- [`plot_model_performance()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_model_performance.md)

- [`plot_model_rankings()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_model_rankings.md)

## See also

[`rank_models`](https://araujorodrig-lab.github.io/rumenGP/reference/rank_models.md),
[`compare_models_by_treatment`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models_by_treatment.md),
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

comparison
#>      Model Bottles Successful_Fits Failed_Fits   Mean_R2 Mean_RMSE  Mean_RSS
#> 1    Groot      24              23           1 0.9768621  2.230506  518.1984
#> 2 Gompertz      24              24           0 0.9134729  4.305830 1838.9408
#>   Mean_AIC Mean_BIC Lambda_Boundary
#> 1 302.3719 311.4785               0
#> 2 400.7494 409.9112               8
```
