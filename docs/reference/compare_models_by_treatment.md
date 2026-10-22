# Compare Models by Treatment

Calculates model performance separately for each treatment.

## Usage

``` r
compare_models_by_treatment(...)
```

## Arguments

- ...:

  Fitted model objects.

## Value

A data frame containing treatment-level performance metrics for each
fitted model.

## Details

Performance metrics are computed using treatment-level predictions and
observations, allowing direct comparison of competing models within each
treatment.

Typical metrics include:

- R-squared (R²)

- Root Mean Squared Error (RMSE)

- Residual Sum of Squares (RSS)

- Akaike Information Criterion (AIC)

- Bayesian Information Criterion (BIC)

This function is useful for determining whether different treatments are
best described by different kinetic models.

## See also

[`compare_models`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models.md),
[`rank_models_by_treatment`](https://araujorodrig-lab.github.io/rumenGP/reference/rank_models_by_treatment.md),
[`best_model_by_treatment`](https://araujorodrig-lab.github.io/rumenGP/reference/best_model_by_treatment.md),
[`model_win_frequency`](https://araujorodrig-lab.github.io/rumenGP/reference/model_win_frequency.md)

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

compare_models_by_treatment(
  Groot = groot_fit,
  Gompertz = gompertz_fit
)
#> # A tibble: 10 × 6
#>    Treatment Model    Mean_R2 Mean_RMSE Mean_AIC Mean_BIC
#>    <chr>     <chr>      <dbl>     <dbl>    <dbl>    <dbl>
#>  1 Blank     Groot      0.990     1.04      426.     438.
#>  2 High      Groot      0.998     1.23      469.     481.
#>  3 Low       Groot      0.998     1.04      420.     432.
#>  4 Medium    Groot      0.999     0.864     369.     380.
#>  5 TMR       Groot      0.999     0.827     356.     368.
#>  6 Blank     Gompertz   0.948     2.55      690.     701.
#>  7 High      Gompertz   0.977     4.00      817.     828.
#>  8 Low       Gompertz   0.984     3.02      721.     733.
#>  9 Medium    Gompertz   0.970     4.42      850.     862.
#> 10 TMR       Gompertz   0.981     3.28      762.     774.
```
