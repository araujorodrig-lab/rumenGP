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
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3618
#> Heads: 25
#> Treatments: 5

gompertz_fit <- fit_gompertz(
  gp
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3618
#> Heads: 25
#> Treatments: 5

comparison <- compare_models(
  Groot = groot_fit,
  Gompertz = gompertz_fit
)

comparison
#>      Model Bottles Successful_Fits Failed_Fits   Mean_R2 Mean_RMSE Mean_RSS
#> 1    Groot      25              24           1 0.9430432  2.016908 3365.539
#> 2 Gompertz      25              24           1 0.9292455  3.922136 3438.554
#>   Mean_AIC Mean_BIC Lambda_Boundary
#> 1 450.3568 462.2290               0
#> 2 761.3896 773.2882              22
```
