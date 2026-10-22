# Identify the Best Model for Each Treatment

Returns the top-ranked model within each treatment.

## Usage

``` r
best_model_by_treatment(ranked_comparison)
```

## Arguments

- ranked_comparison:

  Output from
  [`rank_models_by_treatment()`](https://araujorodrig-lab.github.io/rumenGP/reference/rank_models_by_treatment.md).

## Value

A data frame containing the highest-ranked model for each treatment.

## Details

Rankings are obtained from
[`rank_models_by_treatment()`](https://araujorodrig-lab.github.io/rumenGP/reference/rank_models_by_treatment.md)
and are based on model performance metrics such as:

- R-squared (R²)

- Root Mean Squared Error (RMSE)

- Residual Sum of Squares (RSS)

- Akaike Information Criterion (AIC)

- Bayesian Information Criterion (BIC)

This function provides a concise summary of the best-performing model
for each treatment and is useful for identifying whether different
treatments are best described by different kinetic models.

## See also

[`compare_models_by_treatment`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models_by_treatment.md),
[`rank_models_by_treatment`](https://araujorodrig-lab.github.io/rumenGP/reference/rank_models_by_treatment.md),
[`model_win_frequency`](https://araujorodrig-lab.github.io/rumenGP/reference/model_win_frequency.md),
[`compare_models`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models.md)

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

groot_fit <- fit_groot(
  gp_clean
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3038
#> Heads: 21
#> Treatments: 5

gompertz_fit <- fit_gompertz(
  gp_clean
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3038
#> Heads: 21
#> Treatments: 5

comparison <- compare_models_by_treatment(
  Groot = groot_fit,
  Gompertz = gompertz_fit
)

ranking <- rank_models_by_treatment(
  comparison
)

best_model_by_treatment(
  ranking
)
#> # A tibble: 5 × 12
#>   Treatment Model Mean_R2 Mean_RMSE Mean_AIC Mean_BIC Rank_R2 Rank_RMSE Rank_AIC
#>   <chr>     <chr>   <dbl>     <dbl>    <dbl>    <dbl>   <int>     <int>    <int>
#> 1 Blank     Groot   0.990     1.04      426.     438.       1         1        1
#> 2 High      Groot   0.998     1.23      469.     481.       1         1        1
#> 3 Low       Groot   0.998     1.04      420.     432.       1         1        1
#> 4 Medium    Groot   0.999     0.864     369.     380.       1         1        1
#> 5 TMR       Groot   0.999     0.827     356.     368.       1         1        1
#> # ℹ 3 more variables: Rank_BIC <int>, Total_Rank <int>, Overall_Rank <int>
```
