# Rank Models Within Each Treatment

Ranks fitted models within each treatment using performance metrics
produced by
[`compare_models_by_treatment()`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models_by_treatment.md).

## Usage

``` r
rank_models_by_treatment(comparison)
```

## Arguments

- comparison:

  Output from
  [`compare_models_by_treatment()`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models_by_treatment.md).

## Value

A data frame containing model rankings for each treatment and
performance metric.

## Details

Rankings can be based on metrics such as:

- R-squared (R²)

- Root Mean Squared Error (RMSE)

- Residual Sum of Squares (RSS)

- Akaike Information Criterion (AIC)

- Bayesian Information Criterion (BIC)

This function is useful for identifying the best-performing model within
each treatment and for evaluating whether model performance varies among
treatments.

## See also

[`compare_models_by_treatment`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models_by_treatment.md),
[`best_model_by_treatment`](https://araujorodrig-lab.github.io/rumenGP/reference/best_model_by_treatment.md),
[`model_win_frequency`](https://araujorodrig-lab.github.io/rumenGP/reference/model_win_frequency.md),
[`rank_models`](https://araujorodrig-lab.github.io/rumenGP/reference/rank_models.md)

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

comparison <- compare_models_by_treatment(
  Groot = groot_fit,
  Gompertz = gompertz_fit
)

rank_models_by_treatment(
  comparison
)
#> # A tibble: 10 × 10
#>    Treatment Model    Mean_R2 Mean_RMSE Mean_AIC Mean_BIC Rank_R2 Rank_RMSE
#>    <chr>     <chr>      <dbl>     <dbl>    <dbl>    <dbl>   <int>     <int>
#>  1 BLANK     Groot      0.969     0.943     201.     210.       1         1
#>  2 Plant_A   Groot      0.968     2.40      287.     297.       1         1
#>  3 Plant_B   Groot      0.990     2.27      315.     324.       1         1
#>  4 Plant_C   Groot      0.974     2.22      320.     329.       1         1
#>  5 TMR       Groot      0.988     3.14      377.     386.       1         1
#>  6 BLANK     Gompertz   0.942     2.02      294.     303.       2         2
#>  7 Plant_A   Gompertz   0.935     5.11      421.     430.       2         2
#>  8 Plant_B   Gompertz   0.810     4.35      411.     420.       2         2
#>  9 Plant_C   Gompertz   0.959     3.84      392.     401.       2         2
#> 10 TMR       Gompertz   0.957     5.83      464.     473.       2         2
#> # ℹ 2 more variables: Rank_AIC <int>, Rank_BIC <int>
```
