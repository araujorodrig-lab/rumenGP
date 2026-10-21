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
#>  1 Blank     Groot      0.792     0.890     355.     366.       1         1
#>  2 High      Groot      0.976     5.55      639.     651.       1         1
#>  3 Low       Groot      0.998     1.04      420.     432.       1         1
#>  4 Medium    Groot      0.999     0.864     369.     380.       1         1
#>  5 TMR       Groot      0.952     1.67      475.     487.       2         1
#>  6 Blank     Gompertz   0.774     2.10      564.     576.       2         2
#>  7 High      Gompertz   0.970     6.56      901.     913.       2         2
#>  8 Low       Gompertz   0.984     3.02      721.     733.       2         2
#>  9 Medium    Gompertz   0.970     4.42      850.     862.       2         2
#> 10 TMR       Gompertz   0.954     3.40      773.     784.       1         2
#> # ℹ 2 more variables: Rank_AIC <int>, Rank_BIC <int>
```
